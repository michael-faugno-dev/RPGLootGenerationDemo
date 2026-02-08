using System;
using System.IO;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Collections.Generic;
using System.Linq;
using Npgsql;
using DotNetEnv;

//
// LootGen — PostgreSQL Database Version with Materialized Views
//
// Setup:
//   1. Copy .env.example to .env
//   2. Update .env with your database credentials
//
// Usage examples:
//   dotnet run -- --level 35 --category helmet --count 3 --mf 25
//   dotnet run -- --level 30 --category armor --count 1 --legendary
//   dotnet run -- --level 45 --category weapon --count 5 --mf 100 --legendary --monsterlevel 55 --maplevel 50 --username "JohnDoe" --character "Warrior"
//
// Reads all data from PostgreSQL database using optimized materialized views
// Use --savedb flag to save generated items to the database (or saveToDatabase parameter in code)

#region Models

public class TierDef
{
    public string Code { get; set; } = "";
    public string Name { get; set; } = "";
    public int MinLevel { get; set; }
    public int MaxLevel { get; set; }
    public int BasePotential { get; set; } = 0;
    public int BaseDropWeight { get; set; } = 100;
}

public class RarityDef
{
    public string Code { get; set; } = "";
    public string Name { get; set; } = "";
    public string? DisplayColor { get; set; }
    public int PrefixCount { get; set; }
    public int SuffixCount { get; set; }
    public double BaseMultiplier { get; set; } = 1.0;
    public int BaseDropWeight { get; set; } = 1;
    public string? Description { get; set; }
    public bool? IsHandcrafted { get; set; }
    public string NameFormat { get; set; } = "{base_name}";
    public bool? CanBeCrafted { get; set; }
    public int? PotentialBonus { get; set; } = 0;
}

public class StatValue
{
    public string Type { get; set; } = "flat";
    public double T1 { get; set; }
    public double T2 { get; set; }
    public double T3 { get; set; }
    public double T4 { get; set; }

    public double GetValueForTier(string tierCode)
    {
        return tierCode.ToUpperInvariant() switch
        {
            "T1" => T1,
            "T2" => T2,
            "T3" => T3,
            "T4" => T4,
            _ => T1
        };
    }
}

public class TierRequirements
{
    public int Level { get; set; }
    public int? STR { get; set; }
    public int? DEX { get; set; }
    public int? INT { get; set; }
}

public class BaseItem
{
    public string Code { get; set; } = "";
    public string Name { get; set; } = "";
    public string Category { get; set; } = "";
    public string? Slot { get; set; }
    public string Tier { get; set; } = "";
    public Dictionary<string, StatValue> BaseStats { get; set; } = new();
    public List<string>? AllowedAffixes { get; set; }
    public Dictionary<string, string>? TierNames { get; set; }
    public Dictionary<string, TierRequirements>? Requirements { get; set; }
    public string? WeaponClass { get; set; }
    public Dictionary<string, double>? AffixWeightMultipliers { get; set; }

    public Dictionary<string, double> GetStatsForTier(string tierCode)
    {
        var result = new Dictionary<string, double>();
        foreach (var kv in BaseStats)
        {
            result[kv.Key] = kv.Value.GetValueForTier(tierCode);
        }
        return result;
    }
}

public class ArmorDef : BaseItem { }
public class WeaponDef : BaseItem { }
public class AccessoryDef : BaseItem { }

public class LegendaryItemDef
{
    public string Code { get; set; } = "";
    public string Name { get; set; } = "";
    public string? BaseType { get; set; }
    public string Category { get; set; } = "";
    public string? Slot { get; set; }
    public string Tier { get; set; } = "";
    public Dictionary<string, double>? FixedBaseStats { get; set; }
    public List<FixedAffix>? FixedAffixes { get; set; }
    public string? UniquePower { get; set; }
    public JsonElement? LegendaryPower { get; set; }
}

public class FixedAffix
{
    public string AffixCode { get; set; } = "";
    public double Value { get; set; }
    public string? Display { get; set; }
}

public class AffixDef
{
    public string Code { get; set; } = "";
    public string Name { get; set; } = "";
    public string Kind { get; set; } = "";
    public string Type { get; set; } = "flat";
    public int BaseWeight { get; set; } = 1;
    public List<string>? Tags { get; set; }
    public string? Description { get; set; }
    public Dictionary<string, string?>? EpithetsByTier { get; set; }
    public Dictionary<string, Dictionary<string, RangeDef?>>? SpawnRangesBySlotThenTier { get; set; }
    public Dictionary<string, int>? WeightOverridesBySlot { get; set; }
}

public class RangeDef
{
    public double Min { get; set; }
    public double Max { get; set; }
}

#endregion

#region Runtime DTOs

public class RolledAffix
{
    public AffixDef Def { get; set; }
    public double Value { get; set; }
    public string Epithet { get; set; }
    public string Kind => Def.Kind;
    public RolledAffix(AffixDef def, double value, string epithet)
    {
        Def = def;
        Value = value;
        Epithet = epithet;
    }
}

public class RolledItem
{
    public string DisplayName { get; set; } = "";
    public RarityDef Rarity { get; set; } = null!;
    public string Tier { get; set; } = "";
    public BaseItem Base { get; set; } = null!;
    public string? UniquePower { get; set; }
    public List<RolledAffix> Affixes { get; set; } = new();
    public Dictionary<string, double> FinalStats { get; set; } = new();
    public int PotentialMax { get; set; }
    public int PotentialCurrent { get; set; }
}

#endregion

#region Main

class Program
{
    static void Main(string[] args)
    {
        // Load environment variables from .env file
        Env.Load();

        var (level, category, count, mf, monsterLevel, mapLevel, username, characterName, connectionString, saveToDb, forceLegendary) = ParseArgs(args);

        // Build connection string from environment variables if not provided
        if (string.IsNullOrWhiteSpace(connectionString))
        {
            connectionString = BuildConnectionString();
        }

        if (string.IsNullOrWhiteSpace(connectionString))
        {
            Console.WriteLine("Error: Database connection not configured");
            Console.WriteLine("Either:");
            Console.WriteLine("  1. Create a .env file with DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD");
            Console.WriteLine("  2. Use --connectionstring parameter");
            Console.WriteLine();
            Console.WriteLine("Example .env file:");
            Console.WriteLine("  DB_HOST=localhost");
            Console.WriteLine("  DB_PORT=5432");
            Console.WriteLine("  DB_NAME=YOUR_DATABASE");
            Console.WriteLine("  DB_USER=postgres");
            Console.WriteLine("  DB_PASSWORD=your_password");
            return;
        }

        Console.WriteLine($"=== Loot Generator (Database Version - Optimized) ===");
        Console.WriteLine($"Level={level}, Category={category}, Count={count}, MF={mf}%, Monster={monsterLevel}, Map={mapLevel}");
        Console.WriteLine($"User={username}, Character={characterName}, ForceLegendary={forceLegendary}");
        Console.WriteLine();

        // Load all data from database using optimized materialized views
        var tiersDb = LoadTiers(connectionString);
        var raritiesDb = LoadRarities(connectionString);
        var affixDb = LoadAffixes(connectionString);
        var armorDb = LoadArmor(connectionString);
        var weaponDb = LoadWeapons(connectionString);
        var legendaryDb = LoadLegendaryItems(connectionString);
        Console.WriteLine($"Loaded from database: {tiersDb.Count} tiers, {raritiesDb.Count} rarities, {affixDb.Count} affixes, {armorDb.Count} armor, {weaponDb.Count} weapons, {legendaryDb.Count} legendaries");
        Console.WriteLine();

        var rng = new Random();

        for (int i = 0; i < count; i++)
        {
            var item = RollOneItem(level, category, mf, tiersDb, raritiesDb, armorDb, weaponDb, legendaryDb, affixDb, rng, forceLegendary);
            if (item != null)
            {
                PrintItem(item);

                if (saveToDb)
                {
                    SaveItemToDatabase(item, username, characterName, level, mf, monsterLevel, mapLevel, connectionString);
                    Console.WriteLine();
                }
            }
        }
    }

    #endregion

    #region Database Loading - OPTIMIZED with Materialized Views

    static List<TierDef> LoadTiers(string connectionString)
    {
        var tiers = new List<TierDef>();
        using var conn = new NpgsqlConnection(connectionString);
        conn.Open();

        using var cmd = new NpgsqlCommand(@"
            SELECT code, name, min_level, max_level, base_potential, base_drop_weight 
            FROM ""Public"".tiers 
            ORDER BY min_level", conn);

        using var reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            tiers.Add(new TierDef
            {
                Code = reader.GetString(0),
                Name = reader.GetString(1),
                MinLevel = reader.GetInt32(2),
                MaxLevel = reader.GetInt32(3),
                BasePotential = reader.GetInt32(4),
                BaseDropWeight = reader.GetInt32(5)
            });
        }

        return tiers;
    }

    static List<RarityDef> LoadRarities(string connectionString)
    {
        var rarities = new List<RarityDef>();
        using var conn = new NpgsqlConnection(connectionString);
        conn.Open();

        using var cmd = new NpgsqlCommand(@"
            SELECT code, name, display_color, prefix_count, suffix_count, 
                   base_stat_multiplier, base_drop_weight, potential_bonus,
                   description, can_be_crafted, is_handcrafted, name_format
            FROM ""Public"".rarities 
            ORDER BY base_drop_weight DESC", conn);

        using var reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            rarities.Add(new RarityDef
            {
                Code = reader.GetString(0),
                Name = reader.GetString(1),
                DisplayColor = reader.IsDBNull(2) ? null : reader.GetString(2),
                PrefixCount = reader.GetInt32(3),
                SuffixCount = reader.GetInt32(4),
                BaseMultiplier = (double)reader.GetDecimal(5),
                BaseDropWeight = reader.GetInt32(6),
                PotentialBonus = reader.GetInt32(7),
                Description = reader.IsDBNull(8) ? null : reader.GetString(8),
                CanBeCrafted = reader.GetBoolean(9),
                IsHandcrafted = reader.GetBoolean(10),
                NameFormat = reader.GetString(11)
            });
        }

        return rarities;
    }

    static List<AffixDef> LoadAffixes(string connectionString)
    {
        var affixes = new List<AffixDef>();
        using var conn = new NpgsqlConnection(connectionString);
        conn.Open();

        // Load base affix data
        using var cmd = new NpgsqlCommand(@"
            SELECT code, name, kind, value_type, base_weight, tags, description
            FROM ""Public"".affixes", conn);

        using var reader = cmd.ExecuteReader();
        while (reader.Read())
        {
            var affix = new AffixDef
            {
                Code = reader.GetString(0),
                Name = reader.GetString(1),
                Kind = reader.GetString(2),
                Type = reader.GetString(3),
                BaseWeight = reader.GetInt32(4),
                Tags = reader.IsDBNull(5) ? null : ((string[])reader.GetValue(5)).ToList(),
                Description = reader.IsDBNull(6) ? null : reader.GetString(6),
                EpithetsByTier = new Dictionary<string, string?>(),
                SpawnRangesBySlotThenTier = new Dictionary<string, Dictionary<string, RangeDef?>>(),
                WeightOverridesBySlot = new Dictionary<string, int>()
            };
            affixes.Add(affix);
        }
        reader.Close();

        // Load epithets
        using var epithetCmd = new NpgsqlCommand(@"
            SELECT affix_code, tier_code, epithet
            FROM ""Public"".affix_epithets", conn);

        using var epithetReader = epithetCmd.ExecuteReader();
        while (epithetReader.Read())
        {
            var affixCode = epithetReader.GetString(0);
            var tierCode = epithetReader.GetString(1);
            var epithet = epithetReader.GetString(2);

            var affix = affixes.FirstOrDefault(a => a.Code == affixCode);
            if (affix != null)
            {
                affix.EpithetsByTier![tierCode] = epithet;
            }
        }
        epithetReader.Close();

        // Load spawn ranges
        using var rangeCmd = new NpgsqlCommand(@"
            SELECT affix_code, item_slot, tier_code, min_value, max_value
            FROM ""Public"".affix_spawn_ranges", conn);

        using var rangeReader = rangeCmd.ExecuteReader();
        while (rangeReader.Read())
        {
            var affixCode = rangeReader.GetString(0);
            var itemSlot = rangeReader.GetString(1);
            var tierCode = rangeReader.GetString(2);
            var minValue = rangeReader.GetInt32(3);
            var maxValue = rangeReader.GetInt32(4);

            var affix = affixes.FirstOrDefault(a => a.Code == affixCode);
            if (affix != null)
            {
                if (!affix.SpawnRangesBySlotThenTier!.ContainsKey(itemSlot))
                {
                    affix.SpawnRangesBySlotThenTier[itemSlot] = new Dictionary<string, RangeDef?>();
                }
                affix.SpawnRangesBySlotThenTier[itemSlot][tierCode] = new RangeDef { Min = minValue, Max = maxValue };
            }
        }
        rangeReader.Close();

        // Load weight overrides
        using var weightCmd = new NpgsqlCommand(@"
            SELECT affix_code, item_slot, weight
            FROM ""Public"".affix_weight_overrides", conn);

        using var weightReader = weightCmd.ExecuteReader();
        while (weightReader.Read())
        {
            var affixCode = weightReader.GetString(0);
            var itemSlot = weightReader.GetString(1);
            var weight = weightReader.GetInt32(2);

            var affix = affixes.FirstOrDefault(a => a.Code == affixCode);
            if (affix != null)
            {
                affix.WeightOverridesBySlot![itemSlot] = weight;
            }
        }

        return affixes;
    }

    static List<WeaponDef> LoadWeapons(string connectionString)
    {
        var weapons = new Dictionary<string, WeaponDef>();

        using var conn = new NpgsqlConnection(connectionString);
        conn.Open();

        // Query the materialized view - everything is pre-joined!
        using var cmd = new NpgsqlCommand(@"
            SELECT DISTINCT
                weapon_code,
                weapon_name,
                weapon_category,
                weapon_class,
                weapon_slot,
                tier_code,
                weapon_tier_name
            FROM ""Public"".mv_weapon_relations
            ORDER BY weapon_code, tier_code", conn);

        using var reader = cmd.ExecuteReader();
        var weaponList = new List<(string code, string name, string category, string weaponClass, string slot, string tier, string tierName)>();

        while (reader.Read())
        {
            weaponList.Add((
                reader.GetString(0),
                reader.GetString(1),
                reader.GetString(2),
                reader.GetString(3),
                reader.GetString(4),
                reader.GetString(5),
                reader.GetString(6)
            ));
        }
        reader.Close();

        foreach (var weaponData in weaponList)
        {
            var key = $"{weaponData.code}_{weaponData.tier}";

            if (weapons.ContainsKey(key))
                continue;

            var weapon = new WeaponDef
            {
                Code = weaponData.code,
                Name = weaponData.name,
                Category = weaponData.category,
                Slot = weaponData.slot,
                Tier = weaponData.tier,
                WeaponClass = weaponData.weaponClass,
                BaseStats = new Dictionary<string, StatValue>(),
                TierNames = new Dictionary<string, string>(),
                Requirements = new Dictionary<string, TierRequirements>(),
                AllowedAffixes = new List<string>(),
                AffixWeightMultipliers = new Dictionary<string, double>()
            };

            weapon.TierNames![weaponData.tier] = weaponData.tierName;

            using var detailCmd = new NpgsqlCommand(@"
                SELECT 
                    req_level, req_str, req_dex,
                    base_stat_name, base_stat_type, base_stat_value,
                    affix_code, effective_weight
                FROM ""Public"".mv_weapon_relations
                WHERE weapon_code = @code AND tier_code = @tier", conn);

            detailCmd.Parameters.AddWithValue("code", weaponData.code);
            detailCmd.Parameters.AddWithValue("tier", weaponData.tier);

            using var detailReader = detailCmd.ExecuteReader();

            var stats = new Dictionary<string, Dictionary<string, double>>();
            var affixesProcessed = new HashSet<string>();
            bool reqLoaded = false;

            while (detailReader.Read())
            {
                if (!reqLoaded && !detailReader.IsDBNull(0))
                {
                    weapon.Requirements![weaponData.tier] = new TierRequirements
                    {
                        Level = detailReader.GetInt32(0),
                        STR = detailReader.IsDBNull(1) ? null : detailReader.GetInt32(1),
                        DEX = detailReader.IsDBNull(2) ? null : detailReader.GetInt32(2)
                    };
                    reqLoaded = true;
                }

                if (!detailReader.IsDBNull(3))
                {
                    var statName = detailReader.GetString(3);
                    var value = (double)detailReader.GetInt32(5);

                    if (!stats.ContainsKey(statName))
                        stats[statName] = new Dictionary<string, double>();

                    stats[statName][weaponData.tier] = value;
                }

                if (!detailReader.IsDBNull(6))
                {
                    var affixCode = detailReader.GetString(6);

                    if (!affixesProcessed.Contains(affixCode))
                    {
                        weapon.AllowedAffixes!.Add(affixCode);

                        if (!detailReader.IsDBNull(7))
                        {
                            weapon.AffixWeightMultipliers![affixCode] = (double)detailReader.GetDecimal(7);
                        }

                        affixesProcessed.Add(affixCode);
                    }
                }
            }

            foreach (var statKv in stats)
            {
                var statValue = new StatValue
                {
                    Type = "flat",
                    T1 = statKv.Value.ContainsKey("T1") ? statKv.Value["T1"] : 0,
                    T2 = statKv.Value.ContainsKey("T2") ? statKv.Value["T2"] : 0,
                    T3 = statKv.Value.ContainsKey("T3") ? statKv.Value["T3"] : 0,
                    T4 = statKv.Value.ContainsKey("T4") ? statKv.Value["T4"] : 0
                };
                weapon.BaseStats[statKv.Key] = statValue;
            }

            weapons[key] = weapon;
        }

        return weapons.Values.ToList();
    }

    static List<ArmorDef> LoadArmor(string connectionString)
    {
        var armors = new Dictionary<string, ArmorDef>();

        using var conn = new NpgsqlConnection(connectionString);
        conn.Open();

        using var cmd = new NpgsqlCommand(@"
            SELECT DISTINCT
                armor_code,
                armor_name,
                armor_category,
                armor_class,
                armor_slot,
                tier_code,
                armor_tier_name
            FROM ""Public"".mv_armor_relations
            ORDER BY armor_code, tier_code", conn);

        using var reader = cmd.ExecuteReader();
        var armorList = new List<(string code, string name, string category, string armorClass, string slot, string tier, string tierName)>();

        while (reader.Read())
        {
            armorList.Add((
                reader.GetString(0),
                reader.GetString(1),
                reader.GetString(2),
                reader.GetString(3),
                reader.GetString(4),
                reader.GetString(5),
                reader.GetString(6)
            ));
        }
        reader.Close();

        foreach (var armorData in armorList)
        {
            var key = $"{armorData.code}_{armorData.tier}";

            if (armors.ContainsKey(key))
                continue;

            var armor = new ArmorDef
            {
                Code = armorData.code,
                Name = armorData.name,
                Category = armorData.category,
                Slot = armorData.slot,
                Tier = armorData.tier,
                WeaponClass = armorData.armorClass,
                BaseStats = new Dictionary<string, StatValue>(),
                TierNames = new Dictionary<string, string>(),
                Requirements = new Dictionary<string, TierRequirements>(),
                AllowedAffixes = new List<string>(),
                AffixWeightMultipliers = new Dictionary<string, double>()
            };

            armor.TierNames![armorData.tier] = armorData.tierName;

            using var detailCmd = new NpgsqlCommand(@"
                SELECT 
                    req_level, req_str, req_dex,
                    base_stat_name, base_stat_type, base_stat_value,
                    affix_code, effective_weight
                FROM ""Public"".mv_armor_relations
                WHERE armor_code = @code AND tier_code = @tier", conn);

            detailCmd.Parameters.AddWithValue("code", armorData.code);
            detailCmd.Parameters.AddWithValue("tier", armorData.tier);

            using var detailReader = detailCmd.ExecuteReader();

            var stats = new Dictionary<string, Dictionary<string, double>>();
            var affixesProcessed = new HashSet<string>();
            bool reqLoaded = false;

            while (detailReader.Read())
            {
                if (!reqLoaded && !detailReader.IsDBNull(0))
                {
                    armor.Requirements![armorData.tier] = new TierRequirements
                    {
                        Level = detailReader.GetInt32(0),
                        STR = detailReader.IsDBNull(1) ? null : detailReader.GetInt32(1),
                        DEX = detailReader.IsDBNull(2) ? null : detailReader.GetInt32(2)
                    };
                    reqLoaded = true;
                }

                if (!detailReader.IsDBNull(3))
                {
                    var statName = detailReader.GetString(3);
                    var value = (double)detailReader.GetInt32(5);

                    if (!stats.ContainsKey(statName))
                        stats[statName] = new Dictionary<string, double>();

                    stats[statName][armorData.tier] = value;
                }

                if (!detailReader.IsDBNull(6))
                {
                    var affixCode = detailReader.GetString(6);

                    if (!affixesProcessed.Contains(affixCode))
                    {
                        armor.AllowedAffixes!.Add(affixCode);

                        if (!detailReader.IsDBNull(7))
                        {
                            armor.AffixWeightMultipliers![affixCode] = (double)detailReader.GetDecimal(7);
                        }

                        affixesProcessed.Add(affixCode);
                    }
                }
            }

            foreach (var statKv in stats)
            {
                var statValue = new StatValue
                {
                    Type = "flat",
                    T1 = statKv.Value.ContainsKey("T1") ? statKv.Value["T1"] : 0,
                    T2 = statKv.Value.ContainsKey("T2") ? statKv.Value["T2"] : 0,
                    T3 = statKv.Value.ContainsKey("T3") ? statKv.Value["T3"] : 0,
                    T4 = statKv.Value.ContainsKey("T4") ? statKv.Value["T4"] : 0
                };
                armor.BaseStats[statKv.Key] = statValue;
            }

            armors[key] = armor;
        }

        return armors.Values.ToList();
    }

    static List<LegendaryItemDef> LoadLegendaryItems(string connectionString)
    {
        var legendaries = new List<LegendaryItemDef>();
        using var conn = new NpgsqlConnection(connectionString);
        conn.Open();

        using var cmd = new NpgsqlCommand(@"
            SELECT code, name, category, base_type, tier_code, slot,
                   legendary_power_name, legendary_power_description
            FROM ""Public"".legendary_items", conn);

        using var reader = cmd.ExecuteReader();
        var legendaryList = new List<(string code, string name, string category, string? baseType, string tier, string? slot, string? powerName, string? powerDesc)>();
        while (reader.Read())
        {
            legendaryList.Add((
                reader.GetString(0),
                reader.GetString(1),
                reader.GetString(2),
                reader.IsDBNull(3) ? null : reader.GetString(3),
                reader.GetString(4),
                reader.IsDBNull(5) ? null : reader.GetString(5),
                reader.IsDBNull(6) ? null : reader.GetString(6),
                reader.IsDBNull(7) ? null : reader.GetString(7)
            ));
        }
        reader.Close();

        foreach (var legData in legendaryList)
        {
            var legendary = new LegendaryItemDef
            {
                Code = legData.code,
                Name = legData.name,
                Category = legData.category,
                BaseType = legData.baseType,
                Tier = legData.tier,
                Slot = legData.slot,
                FixedBaseStats = new Dictionary<string, double>(),
                FixedAffixes = new List<FixedAffix>()
            };

            if (!string.IsNullOrWhiteSpace(legData.powerName) || !string.IsNullOrWhiteSpace(legData.powerDesc))
            {
                legendary.UniquePower = string.IsNullOrWhiteSpace(legData.powerName)
                    ? legData.powerDesc
                    : string.IsNullOrWhiteSpace(legData.powerDesc)
                        ? legData.powerName
                        : $"{legData.powerName}: {legData.powerDesc}";
            }

            using var statCmd = new NpgsqlCommand(@"
                SELECT stat_name, value 
                FROM ""Public"".legendary_item_base_stats 
                WHERE legendary_item_code = @code", conn);
            statCmd.Parameters.AddWithValue("code", legData.code);

            using var statReader = statCmd.ExecuteReader();
            while (statReader.Read())
            {
                legendary.FixedBaseStats![statReader.GetString(0)] = (double)statReader.GetInt32(1);
            }
            statReader.Close();

            using var affixCmd = new NpgsqlCommand(@"
                SELECT affix_code, value, display_text 
                FROM ""Public"".legendary_item_fixed_affixes 
                WHERE legendary_item_code = @code", conn);
            affixCmd.Parameters.AddWithValue("code", legData.code);

            using var affixReader = affixCmd.ExecuteReader();
            while (affixReader.Read())
            {
                legendary.FixedAffixes!.Add(new FixedAffix
                {
                    AffixCode = affixReader.GetString(0),
                    Value = (double)affixReader.GetInt32(1),
                    Display = affixReader.IsDBNull(2) ? null : affixReader.GetString(2)
                });
            }

            legendaries.Add(legendary);
        }

        return legendaries;
    }

    #endregion

    #region Item Generation

    static RolledItem? RollOneItem(
        int level,
        string category,
        int mf,
        List<TierDef> tiersDb,
        List<RarityDef> raritiesDb,
        List<ArmorDef> armorDb,
        List<WeaponDef> weaponDb,
        List<LegendaryItemDef> legendaryDb,
        List<AffixDef> affixDb,
        Random rng,
        bool forceLegendary)
    {
        var eligibleTiers = tiersDb.Where(t => level >= t.MinLevel && level <= t.MaxLevel).ToList();
        if (eligibleTiers.Count == 0)
        {
            Console.WriteLine($"No tier available for level {level}");
            return null;
        }

        var tier = WeightedChoice(eligibleTiers, eligibleTiers.Select(t => (double)t.BaseDropWeight).ToList(), rng);

        RarityDef rarity;
        if (forceLegendary)
        {
            var legRarity = raritiesDb.FirstOrDefault(r => string.Equals(r.Code, "legendary", StringComparison.OrdinalIgnoreCase));
            if (legRarity == null)
            {
                Console.WriteLine("No legendary rarity defined in DB");
                return null;
            }
            rarity = legRarity;
        }
        else
        {
            var weights = raritiesDb.Select(r => r.BaseDropWeight * (1.0 + mf / 100.0)).ToList();
            rarity = WeightedChoice(raritiesDb, weights, rng);
        }

        if (string.Equals(rarity.Code, "legendary", StringComparison.OrdinalIgnoreCase))
        {
            var eligibleLegs = legendaryDb.Where(l =>
                string.Equals(l.Category, category, StringComparison.OrdinalIgnoreCase) &&
                string.Equals(l.Tier, tier.Code, StringComparison.OrdinalIgnoreCase)
            ).ToList();

            if (eligibleLegs.Count == 0)
            {
                Console.WriteLine($"No legendary item for category={category}, tier={tier.Code}");
                return null;
            }

            var chosenLeg = eligibleLegs[rng.Next(eligibleLegs.Count)];
            return BuildLegendary(chosenLeg, rarity, tier, affixDb);
        }

        BaseItem? chosenBase = null;
        if (string.Equals(category, "armor", StringComparison.OrdinalIgnoreCase))
        {
            var candidates = armorDb.Where(a => string.Equals(a.Tier, tier.Code, StringComparison.OrdinalIgnoreCase)).ToList();
            if (candidates.Count == 0)
            {
                Console.WriteLine($"No armor for tier={tier.Code}");
                return null;
            }
            chosenBase = candidates[rng.Next(candidates.Count)];
        }
        else if (string.Equals(category, "weapon", StringComparison.OrdinalIgnoreCase))
        {
            var candidates = weaponDb.Where(w => string.Equals(w.Tier, tier.Code, StringComparison.OrdinalIgnoreCase)).ToList();
            if (candidates.Count == 0)
            {
                Console.WriteLine($"No weapon for tier={tier.Code}");
                return null;
            }
            chosenBase = candidates[rng.Next(candidates.Count)];
        }
        else if (category.Contains("helmet") || category.Contains("shoulder") || category.Contains("body") ||
                 category.Contains("gloves") || category.Contains("pants") || category.Contains("boots"))
        {
            var slot = category.ToLowerInvariant();
            var candidates = armorDb.Where(a =>
                string.Equals(a.Tier, tier.Code, StringComparison.OrdinalIgnoreCase) &&
                string.Equals(a.Slot, slot, StringComparison.OrdinalIgnoreCase)
            ).ToList();

            if (candidates.Count == 0)
            {
                Console.WriteLine($"No armor for slot={slot}, tier={tier.Code}");
                return null;
            }
            chosenBase = candidates[rng.Next(candidates.Count)];
        }

        if (chosenBase == null)
        {
            Console.WriteLine($"No valid base item found for category={category}");
            return null;
        }

        return BuildNormalItem(chosenBase, rarity, tier, affixDb, rng);
    }

    static RolledItem BuildNormalItem(BaseItem baseItem, RarityDef rarity, TierDef tier, List<AffixDef> affixDb, Random rng)
    {
        var pot = (rarity.CanBeCrafted ?? true) ? (tier.BasePotential + (rarity.PotentialBonus ?? 0)) : 0;

        var finalStats = new Dictionary<string, double>();
        foreach (var kv in baseItem.GetStatsForTier(baseItem.Tier))
        {
            finalStats[kv.Key] = kv.Value * rarity.BaseMultiplier;
        }

        var allowedAffixCodes = baseItem.AllowedAffixes ?? new List<string>();
        var eligibleAffixes = affixDb
            .Where(a => allowedAffixCodes.Contains(a.Code))
            .ToList();

        var prefixPool = eligibleAffixes.Where(a => string.Equals(a.Kind, "prefix", StringComparison.OrdinalIgnoreCase)).ToList();
        var suffixPool = eligibleAffixes.Where(a => string.Equals(a.Kind, "suffix", StringComparison.OrdinalIgnoreCase)).ToList();

        var affixes = new List<RolledAffix>();

        for (int i = 0; i < rarity.PrefixCount; i++)
        {
            if (prefixPool.Count == 0) break;
            var chosen = PickAffix(prefixPool, baseItem, rng);
            prefixPool.Remove(chosen);

            var (value, epithet) = RollAffixValue(chosen, baseItem.Code, baseItem.Tier, rng);
            var rolled = new RolledAffix(chosen, value, epithet);
            affixes.Add(rolled);

            if (finalStats.ContainsKey(chosen.Name))
                finalStats[chosen.Name] += value;
            else
                finalStats[chosen.Name] = value;
        }

        for (int i = 0; i < rarity.SuffixCount; i++)
        {
            if (suffixPool.Count == 0) break;
            var chosen = PickAffix(suffixPool, baseItem, rng);
            suffixPool.Remove(chosen);

            var (value, epithet) = RollAffixValue(chosen, baseItem.Code, baseItem.Tier, rng);
            var rolled = new RolledAffix(chosen, value, epithet);
            affixes.Add(rolled);

            if (finalStats.ContainsKey(chosen.Name))
                finalStats[chosen.Name] += value;
            else
                finalStats[chosen.Name] = value;
        }

        string prefixEpithet = "";
        string suffixEpithet = "";
        foreach (var ax in affixes)
        {
            if (!string.IsNullOrWhiteSpace(ax.Epithet))
            {
                if (string.Equals(ax.Kind, "prefix", StringComparison.OrdinalIgnoreCase) && string.IsNullOrWhiteSpace(prefixEpithet))
                {
                    prefixEpithet = ax.Epithet;
                }
                else if (string.Equals(ax.Kind, "suffix", StringComparison.OrdinalIgnoreCase) && string.IsNullOrWhiteSpace(suffixEpithet))
                {
                    suffixEpithet = ax.Epithet;
                }
            }
        }

        var baseName = baseItem.Name;
        if (baseItem.TierNames != null && baseItem.TierNames.ContainsKey(baseItem.Tier))
        {
            baseName = baseItem.TierNames[baseItem.Tier];
        }

        var displayName = BuildItemName(rarity.NameFormat, baseName, prefixEpithet, suffixEpithet);

        return new RolledItem
        {
            DisplayName = displayName,
            Rarity = rarity,
            Tier = baseItem.Tier,
            Base = baseItem,
            Affixes = affixes,
            FinalStats = finalStats,
            PotentialMax = pot,
            PotentialCurrent = pot
        };
    }

    static AffixDef PickAffix(List<AffixDef> pool, BaseItem baseItem, Random rng)
    {
        var weights = new List<double>();
        foreach (var a in pool)
        {
            double w = a.BaseWeight;

            if (a.WeightOverridesBySlot != null && a.WeightOverridesBySlot.ContainsKey(baseItem.Code))
            {
                w = a.WeightOverridesBySlot[baseItem.Code];
            }
            else if (baseItem.AffixWeightMultipliers != null && baseItem.AffixWeightMultipliers.ContainsKey(a.Code))
            {
                w *= baseItem.AffixWeightMultipliers[a.Code];
            }

            weights.Add(w);
        }

        return WeightedChoice(pool, weights, rng);
    }

    static (double value, string epithet) RollAffixValue(AffixDef affix, string itemCode, string tierCode, Random rng)
    {
        string epithet = "";
        if (affix.EpithetsByTier != null && affix.EpithetsByTier.ContainsKey(tierCode))
        {
            epithet = affix.EpithetsByTier[tierCode] ?? "";
        }

        double min = 1, max = 10;
        if (affix.SpawnRangesBySlotThenTier != null && affix.SpawnRangesBySlotThenTier.ContainsKey(itemCode))
        {
            var byTier = affix.SpawnRangesBySlotThenTier[itemCode];
            if (byTier.ContainsKey(tierCode) && byTier[tierCode] != null)
            {
                min = byTier[tierCode]!.Min;
                max = byTier[tierCode]!.Max;
            }
        }

        double value = RandomInRange(min, max, rng);
        return (value, epithet);
    }

    static string BuildItemName(string format, string baseName, string prefixEpithet, string suffixEpithet)
    {
        var fmt = format;

        fmt = fmt.Replace("{prefix} {prefix} {prefix}", "{prefix}")
                 .Replace("{prefix} {prefix}", "{prefix}")
                 .Replace("{suffix} {suffix}", "{suffix}");

        var name = fmt.Replace("{base_name}", baseName)
                      .Replace("{prefix}", prefixEpithet.Trim())
                      .Replace("{suffix}", suffixEpithet.Trim())
                      .Replace("  ", " ")
                      .Trim();

        return name;
    }

    static RolledItem BuildLegendary(LegendaryItemDef leg, RarityDef rarity, TierDef tier, List<AffixDef> affixDb)
    {
        var pot = (rarity.CanBeCrafted ?? true) ? (tier.BasePotential + (rarity.PotentialBonus ?? 0)) : 0;

        string uniquePower = leg.UniquePower ?? "";

        var finalStats = leg.FixedBaseStats != null
            ? new Dictionary<string, double>(leg.FixedBaseStats)
            : new Dictionary<string, double>();

        var affixes = new List<RolledAffix>();
        if (leg.FixedAffixes != null && leg.FixedAffixes.Count > 0)
        {
            foreach (var fixedAffix in leg.FixedAffixes)
            {
                var affixDef = affixDb.FirstOrDefault(a =>
                    string.Equals(a.Code, fixedAffix.AffixCode, StringComparison.OrdinalIgnoreCase));

                if (affixDef != null)
                {
                    var rolledAffix = new RolledAffix(affixDef, fixedAffix.Value, "");
                    affixes.Add(rolledAffix);

                    var statKey = affixDef.Name;
                    if (finalStats.ContainsKey(statKey))
                    {
                        finalStats[statKey] += fixedAffix.Value;
                    }
                    else
                    {
                        finalStats[statKey] = fixedAffix.Value;
                    }
                }
            }
        }

        var item = new RolledItem
        {
            DisplayName = leg.Name,
            Rarity = rarity,
            Tier = string.IsNullOrWhiteSpace(leg.Tier) ? tier.Code : leg.Tier,
            Base = new BaseItem
            {
                Code = leg.Code,
                Name = leg.Name,
                Category = leg.Category,
                Slot = leg.Slot,
                Tier = string.IsNullOrWhiteSpace(leg.Tier) ? tier.Code : leg.Tier,
                BaseStats = new Dictionary<string, StatValue>()
            },
            UniquePower = uniquePower,
            Affixes = affixes,
            FinalStats = finalStats,
            PotentialMax = pot,
            PotentialCurrent = pot
        };
        return item;
    }

    #endregion

    #region Database Saving

    static void SaveItemToDatabase(
        RolledItem item,
        string username,
        string characterName,
        int generationLevel,
        int magicFind,
        int monsterLevel,
        int mapLevel,
        string connectionString)
    {
        using var conn = new NpgsqlConnection(connectionString);
        conn.Open();

        try
        {
            var statsJson = "[" + string.Join(",", item.FinalStats.Select(s =>
                $"{{\"stat_name\":\"{s.Key}\",\"value\":{s.Value}}}")) + "]";

            var affixesJson = "[" + string.Join(",", item.Affixes.Select(a =>
                $"{{\"code\":\"{a.Def.Code}\",\"name\":\"{a.Def.Name}\",\"kind\":\"{a.Kind}\",\"value\":{a.Value},\"epithet\":\"{a.Epithet}\"}}")) + "]";

            using var itemCmd = new NpgsqlCommand(@"
                INSERT INTO ""Public"".generated_items 
                (username, character_name, display_name, base_code, base_name, category, slot, 
                 tier_code, rarity_code, rarity_name, rarity_color,
                 potential_max, potential_current, unique_power, 
                 stats, affixes,
                 generation_level, magic_find, monster_level, map_level)
                VALUES 
                (@username, @character_name, @display_name, @base_code, @base_name, @category, @slot,
                 @tier_code, @rarity_code, @rarity_name, @rarity_color,
                 @potential_max, @potential_current, @unique_power,
                 @stats::jsonb, @affixes::jsonb,
                 @generation_level, @magic_find, @monster_level, @map_level)
                RETURNING id, item_uuid", conn);

            itemCmd.Parameters.AddWithValue("username", username);
            itemCmd.Parameters.AddWithValue("character_name", characterName);
            itemCmd.Parameters.AddWithValue("display_name", item.DisplayName);
            itemCmd.Parameters.AddWithValue("base_code", item.Base.Code);
            itemCmd.Parameters.AddWithValue("base_name", item.Base.Name);
            itemCmd.Parameters.AddWithValue("category", item.Base.Category);
            itemCmd.Parameters.AddWithValue("slot", (object?)item.Base.Slot ?? DBNull.Value);
            itemCmd.Parameters.AddWithValue("tier_code", item.Tier);
            itemCmd.Parameters.AddWithValue("rarity_code", item.Rarity.Code);
            itemCmd.Parameters.AddWithValue("rarity_name", item.Rarity.Name);
            itemCmd.Parameters.AddWithValue("rarity_color", (object?)item.Rarity.DisplayColor ?? DBNull.Value);
            itemCmd.Parameters.AddWithValue("potential_max", item.PotentialMax);
            itemCmd.Parameters.AddWithValue("potential_current", item.PotentialCurrent);
            itemCmd.Parameters.AddWithValue("unique_power", (object?)item.UniquePower ?? DBNull.Value);
            itemCmd.Parameters.AddWithValue("stats", statsJson);
            itemCmd.Parameters.AddWithValue("affixes", affixesJson);
            itemCmd.Parameters.AddWithValue("generation_level", generationLevel);
            itemCmd.Parameters.AddWithValue("magic_find", magicFind);
            itemCmd.Parameters.AddWithValue("monster_level", (object?)monsterLevel);
            itemCmd.Parameters.AddWithValue("map_level", (object?)mapLevel);

            using var reader = itemCmd.ExecuteReader();
            if (reader.Read())
            {
                var itemId = reader.GetInt32(0);
                var itemUuid = reader.GetGuid(1);
                Console.WriteLine($"   >>> Saved to database (ID: {itemId}, UUID: {itemUuid})");
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"   !!! Error saving to database: {ex.Message}");
            Console.WriteLine($"   !!! Details: {ex.StackTrace}");
        }
    }

    #endregion

    #region Printing

    static void PrintItem(RolledItem it)
    {
        var slot = it.Base.Slot ?? "";
        Console.WriteLine($"[ ] {it.DisplayName}  (rarity:{it.Rarity.Name}, base:{it.Base.Name}, tier:{it.Tier}, category:{it.Base.Category}, slot:{slot}, code:{it.Base.Code})");
        Console.WriteLine($"   Potential: {it.PotentialCurrent}/{it.PotentialMax}");

        foreach (var kv in it.FinalStats.OrderBy(k => k.Key, StringComparer.OrdinalIgnoreCase))
        {
            Console.WriteLine($"   - {kv.Key}: {FormatNumber(kv.Value)}");
        }

        foreach (var ax in it.Affixes)
        {
            Console.WriteLine($"   + {FormatNumber(ax.Value)} {ax.Def.Name}");
        }

        if (!string.IsNullOrWhiteSpace(it.UniquePower))
        {
            Console.WriteLine($"   * Unique: {it.UniquePower}");
        }

        Console.WriteLine();
    }

    static string FormatNumber(double v)
    {
        if (Math.Abs(v - Math.Round(v)) < 1e-9) return ((int)Math.Round(v)).ToString();
        return v.ToString("0.##");
    }

    #endregion

    #region Helpers

    static (int level, string category, int count, int mf, int monsterLevel, int mapLevel,
        string username, string characterName, string connectionString,
        bool saveToDb, bool forceLegendary) ParseArgs(string[] args)
    {
        int level = 1, count = 1, mf = 0, monsterLevel = 0, mapLevel = 0;
        string category = "armor";
        string username = "TestUser";
        string characterName = "TestCharacter";
        string connectionString = "";
        bool saveToDb = false;
        bool forceLegendary = false;

        for (int i = 0; i < args.Length; i++)
        {
            string a = args[i];

            if (a == "--level" && i + 1 < args.Length && int.TryParse(args[i + 1], out var L)) { level = L; i++; }
            else if (a == "--category" && i + 1 < args.Length) { category = args[i + 1]; i++; }
            else if (a == "--count" && i + 1 < args.Length && int.TryParse(args[i + 1], out var C)) { count = C; i++; }
            else if (a == "--mf" && i + 1 < args.Length && int.TryParse(args[i + 1], out var M)) { mf = M; i++; }
            else if (a == "--monsterlevel" && i + 1 < args.Length && int.TryParse(args[i + 1], out var ML)) { monsterLevel = ML; i++; }
            else if (a == "--maplevel" && i + 1 < args.Length && int.TryParse(args[i + 1], out var MAP)) { mapLevel = MAP; i++; }
            else if ((a == "--username" || a == "--user") && i + 1 < args.Length) { username = args[i + 1]; i++; }
            else if ((a == "--character" || a == "--char") && i + 1 < args.Length) { characterName = args[i + 1]; i++; }

            else if (a == "--connectionstring" && i + 1 < args.Length)
            {
                connectionString = args[i + 1];
                i++;
            }

            else if (a == "--savedb") saveToDb = true;
            else if (a == "--legendary") forceLegendary = true;
        }

        return (level, category, count, mf, monsterLevel, mapLevel, username, characterName,
                connectionString, saveToDb, forceLegendary);
    }

    static string BuildConnectionString()
    {
        var host = Environment.GetEnvironmentVariable("DB_HOST");
        var port = Environment.GetEnvironmentVariable("DB_PORT");
        var database = Environment.GetEnvironmentVariable("DB_NAME");
        var username = Environment.GetEnvironmentVariable("DB_USER");
        var password = Environment.GetEnvironmentVariable("DB_PASSWORD");

        if (string.IsNullOrWhiteSpace(host) ||
            string.IsNullOrWhiteSpace(port) ||
            string.IsNullOrWhiteSpace(database) ||
            string.IsNullOrWhiteSpace(username) ||
            string.IsNullOrWhiteSpace(password))
        {
            return "";
        }

        return $"Host={host};Port={port};Database={database};Username={username};Password={password}";
    }


    static T WeightedChoice<T>(IList<T> items, IList<double> weights, Random rng)
    {
        double total = 0;
        for (int i = 0; i < weights.Count; i++) total += weights[i];
        double roll = rng.NextDouble() * total;

        for (int i = 0; i < items.Count; i++)
        {
            if (roll < weights[i]) return items[i];
            roll -= weights[i];
        }
        return items[^1];
    }

    static double RandomInRange(double min, double max, Random rng)
    {
        return min + rng.NextDouble() * (max - min);
    }

    #endregion
}