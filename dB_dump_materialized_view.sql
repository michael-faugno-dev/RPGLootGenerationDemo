--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

-- Started on 2025-11-21 11:43:01

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE rebots_game;
--
-- TOC entry 5067 (class 1262 OID 16752)
-- Name: rebots_game; Type: DATABASE; Schema: -; Owner: -
--

CREATE DATABASE rebots_game WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


\connect rebots_game

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 2200)
-- Name: Public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA "Public";


--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA "Public"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA "Public" IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 227 (class 1259 OID 16904)
-- Name: affix_epithets; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".affix_epithets (
    affix_code text NOT NULL,
    tier_code character varying(2) NOT NULL,
    epithet text NOT NULL
);


--
-- TOC entry 228 (class 1259 OID 16922)
-- Name: affix_spawn_ranges; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".affix_spawn_ranges (
    affix_code text NOT NULL,
    item_slot text NOT NULL,
    tier_code character varying(2) NOT NULL,
    min_value integer NOT NULL,
    max_value integer NOT NULL
);


--
-- TOC entry 229 (class 1259 OID 16939)
-- Name: affix_weight_overrides; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".affix_weight_overrides (
    affix_code text NOT NULL,
    item_slot text NOT NULL,
    weight integer NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 16897)
-- Name: affixes; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".affixes (
    code text NOT NULL,
    name text NOT NULL,
    kind text NOT NULL,
    value_type text NOT NULL,
    base_weight integer NOT NULL,
    tags text[] NOT NULL,
    description text
);


--
-- TOC entry 245 (class 1259 OID 17195)
-- Name: armor_affix_weight_multipliers; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".armor_affix_weight_multipliers (
    armor_id integer NOT NULL,
    affix_code character varying(50) NOT NULL,
    weight numeric(5,2) NOT NULL
);


--
-- TOC entry 244 (class 1259 OID 17180)
-- Name: armor_allowed_affixes; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".armor_allowed_affixes (
    armor_id integer NOT NULL,
    affix_name character varying(50) NOT NULL
);


--
-- TOC entry 243 (class 1259 OID 17162)
-- Name: armor_base_stats; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".armor_base_stats (
    id integer NOT NULL,
    armor_id integer NOT NULL,
    tier character varying(2) NOT NULL,
    stat_name character varying(50) NOT NULL,
    stat_type character varying(20) NOT NULL,
    value integer NOT NULL
);


--
-- TOC entry 239 (class 1259 OID 17115)
-- Name: armor_base_stats_id_seq; Type: SEQUENCE; Schema: Public; Owner: -
--

CREATE SEQUENCE "Public".armor_base_stats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 239
-- Name: armor_base_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: Public; Owner: -
--

ALTER SEQUENCE "Public".armor_base_stats_id_seq OWNED BY "Public".armor_base_stats.id;


--
-- TOC entry 242 (class 1259 OID 17144)
-- Name: armor_requirements; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".armor_requirements (
    id integer NOT NULL,
    armor_id integer NOT NULL,
    tier character varying(2) NOT NULL,
    req_level integer NOT NULL,
    req_str integer,
    req_dex integer
);


--
-- TOC entry 238 (class 1259 OID 17114)
-- Name: armor_requirements_id_seq; Type: SEQUENCE; Schema: Public; Owner: -
--

CREATE SEQUENCE "Public".armor_requirements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 238
-- Name: armor_requirements_id_seq; Type: SEQUENCE OWNED BY; Schema: Public; Owner: -
--

ALTER SEQUENCE "Public".armor_requirements_id_seq OWNED BY "Public".armor_requirements.id;


--
-- TOC entry 241 (class 1259 OID 17126)
-- Name: armor_tiers; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".armor_tiers (
    id integer NOT NULL,
    armor_id integer NOT NULL,
    tier character varying(2) NOT NULL,
    tier_name character varying(100) NOT NULL
);


--
-- TOC entry 237 (class 1259 OID 17113)
-- Name: armor_tiers_id_seq; Type: SEQUENCE; Schema: Public; Owner: -
--

CREATE SEQUENCE "Public".armor_tiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 237
-- Name: armor_tiers_id_seq; Type: SEQUENCE OWNED BY; Schema: Public; Owner: -
--

ALTER SEQUENCE "Public".armor_tiers_id_seq OWNED BY "Public".armor_tiers.id;


--
-- TOC entry 240 (class 1259 OID 17116)
-- Name: armors; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".armors (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(50) NOT NULL,
    armor_class character varying(20) NOT NULL,
    slot character varying(20) NOT NULL,
    description text NOT NULL
);


--
-- TOC entry 236 (class 1259 OID 17112)
-- Name: armors_id_seq; Type: SEQUENCE; Schema: Public; Owner: -
--

CREATE SEQUENCE "Public".armors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 236
-- Name: armors_id_seq; Type: SEQUENCE OWNED BY; Schema: Public; Owner: -
--

ALTER SEQUENCE "Public".armors_id_seq OWNED BY "Public".armors.id;


--
-- TOC entry 231 (class 1259 OID 16973)
-- Name: legendary_item_base_stats; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".legendary_item_base_stats (
    legendary_item_code text NOT NULL,
    stat_name text NOT NULL,
    value integer NOT NULL
);


--
-- TOC entry 232 (class 1259 OID 16985)
-- Name: legendary_item_fixed_affixes; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".legendary_item_fixed_affixes (
    legendary_item_code text NOT NULL,
    affix_code text NOT NULL,
    value integer NOT NULL,
    display_text text
);


--
-- TOC entry 230 (class 1259 OID 16961)
-- Name: legendary_items; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".legendary_items (
    code text NOT NULL,
    name text NOT NULL,
    category text NOT NULL,
    base_type text,
    tier_code character varying(2) NOT NULL,
    min_level integer NOT NULL,
    item_level integer NOT NULL,
    description text,
    lore text,
    slot text,
    legendary_power_name text,
    legendary_power_description text,
    legendary_power_proc_chance integer,
    legendary_power_cooldown integer,
    legendary_power_effect_data jsonb,
    visual_effects jsonb
);


--
-- TOC entry 224 (class 1259 OID 16865)
-- Name: tiers; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".tiers (
    code character varying(2) NOT NULL,
    name character varying(50) NOT NULL,
    display_name character varying(50) NOT NULL,
    min_level integer NOT NULL,
    max_level integer NOT NULL,
    base_potential integer NOT NULL,
    base_drop_weight integer NOT NULL,
    description text,
    color character varying(7) NOT NULL
);


--
-- TOC entry 246 (class 1259 OID 17210)
-- Name: mv_armor_relations; Type: MATERIALIZED VIEW; Schema: Public; Owner: -
--

CREATE MATERIALIZED VIEW "Public".mv_armor_relations AS
 SELECT a.id AS armor_id,
    a.code AS armor_code,
    a.name AS armor_name,
    a.category AS armor_category,
    a.armor_class,
    a.slot AS armor_slot,
    a.description AS armor_description,
    at.tier AS tier_code,
    at.tier_name AS armor_tier_name,
    t.name AS global_tier_name,
    t.display_name AS global_tier_display_name,
    t.min_level AS tier_min_level,
    t.max_level AS tier_max_level,
    t.base_potential,
    t.base_drop_weight AS tier_base_drop_weight,
    t.color AS tier_color,
    ar.req_level,
    ar.req_str,
    ar.req_dex,
    abs.stat_name AS base_stat_name,
    abs.stat_type AS base_stat_type,
    abs.value AS base_stat_value,
    af.code AS affix_code,
    af.name AS affix_name,
    af.kind AS affix_kind,
    af.value_type AS affix_value_type,
    af.base_weight AS affix_base_weight,
    af.tags AS affix_tags,
    af.description AS affix_description,
    ae.epithet AS affix_epithet_for_tier,
    asr.item_slot AS spawn_item_slot,
    asr.min_value AS spawn_min_value,
    asr.max_value AS spawn_max_value,
    aawm.weight AS armor_affix_weight_multiplier,
    awo.weight AS affix_weight_override,
        CASE
            WHEN (awo.weight IS NOT NULL) THEN (awo.weight)::numeric
            ELSE ((af.base_weight)::numeric * COALESCE(aawm.weight, 1.0))
        END AS effective_weight
   FROM (((((((((("Public".armors a
     LEFT JOIN "Public".armor_tiers at ON ((at.armor_id = a.id)))
     LEFT JOIN "Public".tiers t ON (((t.code)::text = (at.tier)::text)))
     LEFT JOIN "Public".armor_requirements ar ON (((ar.armor_id = a.id) AND ((ar.tier)::text = (at.tier)::text))))
     LEFT JOIN "Public".armor_base_stats abs ON (((abs.armor_id = a.id) AND ((abs.tier)::text = (at.tier)::text))))
     LEFT JOIN "Public".armor_allowed_affixes aaa ON ((aaa.armor_id = a.id)))
     LEFT JOIN "Public".affixes af ON ((af.code = (aaa.affix_name)::text)))
     LEFT JOIN "Public".affix_epithets ae ON (((ae.affix_code = af.code) AND ((ae.tier_code)::text = (at.tier)::text))))
     LEFT JOIN "Public".affix_spawn_ranges asr ON (((asr.affix_code = af.code) AND (asr.item_slot = (a.code)::text) AND ((asr.tier_code)::text = (at.tier)::text))))
     LEFT JOIN "Public".armor_affix_weight_multipliers aawm ON (((aawm.armor_id = a.id) AND ((aawm.affix_code)::text = af.code))))
     LEFT JOIN "Public".affix_weight_overrides awo ON (((awo.affix_code = af.code) AND (awo.item_slot = (a.code)::text))))
  WITH NO DATA;


--
-- TOC entry 234 (class 1259 OID 17009)
-- Name: weapon_affix_weight_multipliers; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".weapon_affix_weight_multipliers (
    weapon_id integer NOT NULL,
    affix_code character varying(50) NOT NULL,
    weight numeric(5,2) NOT NULL
);


--
-- TOC entry 223 (class 1259 OID 16842)
-- Name: weapon_allowed_affixes; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".weapon_allowed_affixes (
    weapon_id integer NOT NULL,
    affix_name character varying(50) NOT NULL,
    affix_weight_multiplier numeric
);


--
-- TOC entry 222 (class 1259 OID 16828)
-- Name: weapon_base_stats; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".weapon_base_stats (
    id integer NOT NULL,
    weapon_id integer NOT NULL,
    tier character varying(2) NOT NULL,
    stat_name character varying(50) NOT NULL,
    stat_type character varying(20) NOT NULL,
    value integer NOT NULL
);


--
-- TOC entry 220 (class 1259 OID 16814)
-- Name: weapon_requirements; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".weapon_requirements (
    id integer NOT NULL,
    weapon_id integer NOT NULL,
    tier character varying(2) NOT NULL,
    req_level integer NOT NULL,
    req_str integer,
    req_dex integer
);


--
-- TOC entry 218 (class 1259 OID 16800)
-- Name: weapon_tiers; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".weapon_tiers (
    id integer NOT NULL,
    weapon_id integer NOT NULL,
    tier character varying(2) NOT NULL,
    tier_name character varying(100) NOT NULL
);


--
-- TOC entry 216 (class 1259 OID 16773)
-- Name: weapons; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".weapons (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    category character varying(50) NOT NULL,
    weapon_class character varying(20) NOT NULL,
    slot character varying(20) NOT NULL,
    description text NOT NULL
);


--
-- TOC entry 235 (class 1259 OID 17037)
-- Name: mv_weapon_relations; Type: MATERIALIZED VIEW; Schema: Public; Owner: -
--

CREATE MATERIALIZED VIEW "Public".mv_weapon_relations AS
 SELECT w.id AS weapon_id,
    w.code AS weapon_code,
    w.name AS weapon_name,
    w.category AS weapon_category,
    w.weapon_class,
    w.slot AS weapon_slot,
    w.description AS weapon_description,
    wt.tier AS tier_code,
    wt.tier_name AS weapon_tier_name,
    tr.name AS global_tier_name,
    tr.display_name AS global_tier_display_name,
    tr.min_level AS tier_min_level,
    tr.max_level AS tier_max_level,
    tr.base_potential,
    tr.base_drop_weight AS tier_base_drop_weight,
    tr.color AS tier_color,
    wr.req_level,
    wr.req_str,
    wr.req_dex,
    wbs.stat_name AS base_stat_name,
    wbs.stat_type AS base_stat_type,
    wbs.value AS base_stat_value,
    a.code AS affix_code,
    a.name AS affix_name,
    a.kind AS affix_kind,
    a.value_type AS affix_value_type,
    a.base_weight AS affix_base_weight,
    a.tags AS affix_tags,
    a.description AS affix_description,
    ae.epithet AS affix_epithet_for_tier,
    asr.item_slot AS spawn_item_slot,
    asr.min_value AS spawn_min_value,
    asr.max_value AS spawn_max_value,
    wawm.weight AS weapon_affix_weight_multiplier,
    awo.weight AS affix_weight_override,
        CASE
            WHEN (awo.weight IS NOT NULL) THEN (awo.weight)::numeric
            ELSE ((a.base_weight)::numeric * COALESCE(wawm.weight, 1.0))
        END AS effective_weight
   FROM (((((((((("Public".weapons w
     LEFT JOIN "Public".weapon_tiers wt ON ((wt.weapon_id = w.id)))
     LEFT JOIN "Public".tiers tr ON (((tr.code)::text = (wt.tier)::text)))
     LEFT JOIN "Public".weapon_requirements wr ON (((wr.weapon_id = w.id) AND ((wr.tier)::text = (wt.tier)::text))))
     LEFT JOIN "Public".weapon_base_stats wbs ON (((wbs.weapon_id = w.id) AND ((wbs.tier)::text = (wt.tier)::text))))
     LEFT JOIN "Public".weapon_allowed_affixes waa ON ((waa.weapon_id = w.id)))
     LEFT JOIN "Public".affixes a ON ((a.code = (waa.affix_name)::text)))
     LEFT JOIN "Public".affix_epithets ae ON (((ae.affix_code = a.code) AND ((ae.tier_code)::text = (wt.tier)::text))))
     LEFT JOIN "Public".affix_spawn_ranges asr ON (((asr.affix_code = a.code) AND (asr.item_slot = (w.code)::text) AND ((asr.tier_code)::text = (wt.tier)::text))))
     LEFT JOIN "Public".weapon_affix_weight_multipliers wawm ON (((wawm.weapon_id = w.id) AND ((wawm.affix_code)::text = a.code))))
     LEFT JOIN "Public".affix_weight_overrides awo ON (((awo.affix_code = a.code) AND (awo.item_slot = (w.code)::text))))
  WITH NO DATA;


--
-- TOC entry 225 (class 1259 OID 16887)
-- Name: rarities; Type: TABLE; Schema: Public; Owner: -
--

CREATE TABLE "Public".rarities (
    code character varying(20) NOT NULL,
    name character varying(50) NOT NULL,
    display_color character varying(7) NOT NULL,
    prefix_count integer NOT NULL,
    suffix_count integer NOT NULL,
    base_stat_multiplier numeric(4,2) NOT NULL,
    base_drop_weight integer NOT NULL,
    potential_bonus integer NOT NULL,
    description text,
    can_be_crafted boolean DEFAULT true NOT NULL,
    is_handcrafted boolean DEFAULT false NOT NULL,
    is_legendary boolean DEFAULT false NOT NULL,
    name_format text NOT NULL
);


--
-- TOC entry 233 (class 1259 OID 17002)
-- Name: vw_legendary_items_full; Type: MATERIALIZED VIEW; Schema: Public; Owner: -
--

CREATE MATERIALIZED VIEW "Public".vw_legendary_items_full AS
 SELECT li.code AS legendary_code,
    li.name AS legendary_name,
    li.category,
    li.base_type,
    li.slot,
    li.tier_code,
    t.display_name AS tier_display_name,
    li.min_level,
    li.item_level,
    li.description,
    li.lore,
    libs.stat_name,
    libs.value AS base_stat_value,
    lia.affix_code,
    a.name AS affix_name,
    lia.value AS affix_value,
    lia.display_text AS affix_display_text,
    li.legendary_power_name,
    li.legendary_power_description,
    li.legendary_power_proc_chance,
    li.legendary_power_cooldown,
    li.legendary_power_effect_data,
    li.visual_effects
   FROM (((("Public".legendary_items li
     LEFT JOIN "Public".tiers t ON (((t.code)::text = (li.tier_code)::text)))
     LEFT JOIN "Public".legendary_item_base_stats libs ON ((libs.legendary_item_code = li.code)))
     LEFT JOIN "Public".legendary_item_fixed_affixes lia ON ((lia.legendary_item_code = li.code)))
     LEFT JOIN "Public".affixes a ON ((a.code = lia.affix_code)))
  WITH NO DATA;


--
-- TOC entry 221 (class 1259 OID 16827)
-- Name: weapon_base_stats_id_seq; Type: SEQUENCE; Schema: Public; Owner: -
--

CREATE SEQUENCE "Public".weapon_base_stats_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 221
-- Name: weapon_base_stats_id_seq; Type: SEQUENCE OWNED BY; Schema: Public; Owner: -
--

ALTER SEQUENCE "Public".weapon_base_stats_id_seq OWNED BY "Public".weapon_base_stats.id;


--
-- TOC entry 219 (class 1259 OID 16813)
-- Name: weapon_requirements_id_seq; Type: SEQUENCE; Schema: Public; Owner: -
--

CREATE SEQUENCE "Public".weapon_requirements_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 219
-- Name: weapon_requirements_id_seq; Type: SEQUENCE OWNED BY; Schema: Public; Owner: -
--

ALTER SEQUENCE "Public".weapon_requirements_id_seq OWNED BY "Public".weapon_requirements.id;


--
-- TOC entry 217 (class 1259 OID 16799)
-- Name: weapon_tiers_id_seq; Type: SEQUENCE; Schema: Public; Owner: -
--

CREATE SEQUENCE "Public".weapon_tiers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 217
-- Name: weapon_tiers_id_seq; Type: SEQUENCE OWNED BY; Schema: Public; Owner: -
--

ALTER SEQUENCE "Public".weapon_tiers_id_seq OWNED BY "Public".weapon_tiers.id;


--
-- TOC entry 215 (class 1259 OID 16772)
-- Name: weapons_id_seq; Type: SEQUENCE; Schema: Public; Owner: -
--

CREATE SEQUENCE "Public".weapons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 215
-- Name: weapons_id_seq; Type: SEQUENCE OWNED BY; Schema: Public; Owner: -
--

ALTER SEQUENCE "Public".weapons_id_seq OWNED BY "Public".weapons.id;


--
-- TOC entry 4797 (class 2604 OID 17165)
-- Name: armor_base_stats id; Type: DEFAULT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_base_stats ALTER COLUMN id SET DEFAULT nextval('"Public".armor_base_stats_id_seq'::regclass);


--
-- TOC entry 4796 (class 2604 OID 17147)
-- Name: armor_requirements id; Type: DEFAULT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_requirements ALTER COLUMN id SET DEFAULT nextval('"Public".armor_requirements_id_seq'::regclass);


--
-- TOC entry 4795 (class 2604 OID 17129)
-- Name: armor_tiers id; Type: DEFAULT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_tiers ALTER COLUMN id SET DEFAULT nextval('"Public".armor_tiers_id_seq'::regclass);


--
-- TOC entry 4794 (class 2604 OID 17121)
-- Name: armors id; Type: DEFAULT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armors ALTER COLUMN id SET DEFAULT nextval('"Public".armors_id_seq'::regclass);


--
-- TOC entry 4790 (class 2604 OID 16831)
-- Name: weapon_base_stats id; Type: DEFAULT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_base_stats ALTER COLUMN id SET DEFAULT nextval('"Public".weapon_base_stats_id_seq'::regclass);


--
-- TOC entry 4789 (class 2604 OID 16817)
-- Name: weapon_requirements id; Type: DEFAULT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_requirements ALTER COLUMN id SET DEFAULT nextval('"Public".weapon_requirements_id_seq'::regclass);


--
-- TOC entry 4788 (class 2604 OID 16803)
-- Name: weapon_tiers id; Type: DEFAULT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_tiers ALTER COLUMN id SET DEFAULT nextval('"Public".weapon_tiers_id_seq'::regclass);


--
-- TOC entry 4787 (class 2604 OID 16776)
-- Name: weapons id; Type: DEFAULT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapons ALTER COLUMN id SET DEFAULT nextval('"Public".weapons_id_seq'::regclass);


--
-- TOC entry 5042 (class 0 OID 16904)
-- Dependencies: 227
-- Data for Name: affix_epithets; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".affix_epithets VALUES ('hp', 'T1', 'Vital');
INSERT INTO "Public".affix_epithets VALUES ('hp', 'T2', 'Core Neural');
INSERT INTO "Public".affix_epithets VALUES ('hp', 'T3', 'Matrix Biofram');
INSERT INTO "Public".affix_epithets VALUES ('hp', 'T4', 'Immortal Core');
INSERT INTO "Public".affix_epithets VALUES ('trans_attack', 'T1', 'Overdrive');
INSERT INTO "Public".affix_epithets VALUES ('trans_attack', 'T2', 'Burstdrive');
INSERT INTO "Public".affix_epithets VALUES ('trans_attack', 'T3', 'Nanostrike');
INSERT INTO "Public".affix_epithets VALUES ('trans_attack', 'T4', 'Quantum Surge');
INSERT INTO "Public".affix_epithets VALUES ('trans_defense', 'T1', 'Firewall');
INSERT INTO "Public".affix_epithets VALUES ('trans_defense', 'T2', 'Bulwark Node');
INSERT INTO "Public".affix_epithets VALUES ('trans_defense', 'T3', 'Aegis Grid');
INSERT INTO "Public".affix_epithets VALUES ('trans_defense', 'T4', 'Quantum Bastion');
INSERT INTO "Public".affix_epithets VALUES ('basic_attack', 'T1', 'Keen');
INSERT INTO "Public".affix_epithets VALUES ('basic_attack', 'T2', 'Edge Pulse');
INSERT INTO "Public".affix_epithets VALUES ('basic_attack', 'T3', 'Blade Plasma');
INSERT INTO "Public".affix_epithets VALUES ('basic_attack', 'T4', 'Edge Photon Cutter');
INSERT INTO "Public".affix_epithets VALUES ('basic_defense', 'T1', 'Reinforced');
INSERT INTO "Public".affix_epithets VALUES ('basic_defense', 'T2', 'Alloy Frame');
INSERT INTO "Public".affix_epithets VALUES ('basic_defense', 'T3', 'Titanium Guard');
INSERT INTO "Public".affix_epithets VALUES ('basic_defense', 'T4', 'Adamantine Shield');
INSERT INTO "Public".affix_epithets VALUES ('trans_charge_time', 'T1', 'Quickboot');
INSERT INTO "Public".affix_epithets VALUES ('trans_charge_time', 'T2', 'Overclock');
INSERT INTO "Public".affix_epithets VALUES ('trans_charge_time', 'T3', 'Nanoclock');
INSERT INTO "Public".affix_epithets VALUES ('trans_charge_time', 'T4', 'Singularity Sync');
INSERT INTO "Public".affix_epithets VALUES ('elemental_damage', 'T1', 'Ionic');
INSERT INTO "Public".affix_epithets VALUES ('elemental_damage', 'T2', 'Cryo');
INSERT INTO "Public".affix_epithets VALUES ('elemental_damage', 'T3', 'Thermal Quantum');
INSERT INTO "Public".affix_epithets VALUES ('elemental_damage', 'T4', 'Radiant');
INSERT INTO "Public".affix_epithets VALUES ('trans_reset_percentage', 'T1', 'Reboot');
INSERT INTO "Public".affix_epithets VALUES ('trans_reset_percentage', 'T2', 'Rollback');
INSERT INTO "Public".affix_epithets VALUES ('trans_reset_percentage', 'T3', 'Failsafe');
INSERT INTO "Public".affix_epithets VALUES ('trans_reset_percentage', 'T4', 'System Restore');
INSERT INTO "Public".affix_epithets VALUES ('endurance_threshold', 'T1', 'Stalwart');
INSERT INTO "Public".affix_epithets VALUES ('endurance_threshold', 'T2', 'Unyielding');
INSERT INTO "Public".affix_epithets VALUES ('endurance_threshold', 'T3', 'Enduric Node');
INSERT INTO "Public".affix_epithets VALUES ('endurance_threshold', 'T4', 'Iron Protocol');
INSERT INTO "Public".affix_epithets VALUES ('plus_to_skill', 'T3', 'Arcane Protocol Daemon');
INSERT INTO "Public".affix_epithets VALUES ('plus_to_skill', 'T4', 'Kernel Cyber Daemon Sovereign AI');
INSERT INTO "Public".affix_epithets VALUES ('specific_ability_cdr', 'T2', 'Threaded Parallel');
INSERT INTO "Public".affix_epithets VALUES ('specific_ability_cdr', 'T3', 'Asynchronous');
INSERT INTO "Public".affix_epithets VALUES ('specific_ability_cdr', 'T4', 'Quantum Thread');
INSERT INTO "Public".affix_epithets VALUES ('speed', 'T1', 'of Velocity');
INSERT INTO "Public".affix_epithets VALUES ('speed', 'T2', 'of Streamline');
INSERT INTO "Public".affix_epithets VALUES ('speed', 'T3', 'of Warpdrive');
INSERT INTO "Public".affix_epithets VALUES ('speed', 'T4', 'of Lightspeed');
INSERT INTO "Public".affix_epithets VALUES ('trans_speed', 'T1', 'of Overclock');
INSERT INTO "Public".affix_epithets VALUES ('trans_speed', 'T2', 'of Pingburst');
INSERT INTO "Public".affix_epithets VALUES ('trans_speed', 'T3', 'of Datastream');
INSERT INTO "Public".affix_epithets VALUES ('trans_speed', 'T4', 'of Hyperthreading');
INSERT INTO "Public".affix_epithets VALUES ('evasion', 'T1', 'of Drift');
INSERT INTO "Public".affix_epithets VALUES ('evasion', 'T2', 'of Sync');
INSERT INTO "Public".affix_epithets VALUES ('evasion', 'T3', 'of Ghoststep');
INSERT INTO "Public".affix_epithets VALUES ('evasion', 'T4', 'of Phase Shift');
INSERT INTO "Public".affix_epithets VALUES ('crit_chance', 'T1', 'of Focus');
INSERT INTO "Public".affix_epithets VALUES ('crit_chance', 'T2', 'of Precision');
INSERT INTO "Public".affix_epithets VALUES ('crit_chance', 'T3', 'of Exploit');
INSERT INTO "Public".affix_epithets VALUES ('crit_chance', 'T4', 'of Critical Cascade');
INSERT INTO "Public".affix_epithets VALUES ('trans_duration_length', 'T1', 'of Persistence');
INSERT INTO "Public".affix_epithets VALUES ('trans_duration_length', 'T2', 'of Sustain');
INSERT INTO "Public".affix_epithets VALUES ('trans_duration_length', 'T3', 'of Prolongation');
INSERT INTO "Public".affix_epithets VALUES ('trans_duration_length', 'T4', 'of Continuum');
INSERT INTO "Public".affix_epithets VALUES ('jump', 'T1', 'of Spring');
INSERT INTO "Public".affix_epithets VALUES ('jump', 'T2', 'of Thrusters');
INSERT INTO "Public".affix_epithets VALUES ('jump', 'T3', 'of Grav Boost');
INSERT INTO "Public".affix_epithets VALUES ('jump', 'T4', 'of Antigrav');
INSERT INTO "Public".affix_epithets VALUES ('thorns', 'T1', 'of Feedback');
INSERT INTO "Public".affix_epithets VALUES ('thorns', 'T2', 'of Spikes');
INSERT INTO "Public".affix_epithets VALUES ('thorns', 'T3', 'of Countermesh');
INSERT INTO "Public".affix_epithets VALUES ('thorns', 'T4', 'of Reflective Matrix');
INSERT INTO "Public".affix_epithets VALUES ('damage_vs_elite', 'T1', 'of Hunter');
INSERT INTO "Public".affix_epithets VALUES ('damage_vs_elite', 'T2', 'of Predator');
INSERT INTO "Public".affix_epithets VALUES ('damage_vs_elite', 'T3', 'of Executioner');
INSERT INTO "Public".affix_epithets VALUES ('damage_vs_elite', 'T4', 'of Annihilator');
INSERT INTO "Public".affix_epithets VALUES ('virus', 'T1', 'of Infection');
INSERT INTO "Public".affix_epithets VALUES ('virus', 'T2', 'of Virus');
INSERT INTO "Public".affix_epithets VALUES ('virus', 'T3', 'of Nanovirus');
INSERT INTO "Public".affix_epithets VALUES ('virus', 'T4', 'of Black ICE');
INSERT INTO "Public".affix_epithets VALUES ('endurance_percent', 'T1', 'of Integrity');
INSERT INTO "Public".affix_epithets VALUES ('endurance_percent', 'T2', 'of Kernel');
INSERT INTO "Public".affix_epithets VALUES ('endurance_percent', 'T3', 'of Redundancy');
INSERT INTO "Public".affix_epithets VALUES ('endurance_percent', 'T4', 'of Eternal Frame');
INSERT INTO "Public".affix_epithets VALUES ('knockback', 'T1', 'of Impact');
INSERT INTO "Public".affix_epithets VALUES ('knockback', 'T2', 'of Forcewave');
INSERT INTO "Public".affix_epithets VALUES ('knockback', 'T3', 'of Repulsor');
INSERT INTO "Public".affix_epithets VALUES ('knockback', 'T4', 'of Graviton Blast');
INSERT INTO "Public".affix_epithets VALUES ('dash_cdr', 'T1', 'of Sprint');
INSERT INTO "Public".affix_epithets VALUES ('dash_cdr', 'T2', 'of Dashdrive');
INSERT INTO "Public".affix_epithets VALUES ('dash_cdr', 'T3', 'of Warpstep');
INSERT INTO "Public".affix_epithets VALUES ('dash_cdr', 'T4', 'of Blink');
INSERT INTO "Public".affix_epithets VALUES ('plus_to_skill_other_class', 'T3', 'of Adaptation Emulation');
INSERT INTO "Public".affix_epithets VALUES ('plus_to_skill_other_class', 'T4', 'of Crosslink Omni-Link');


--
-- TOC entry 5043 (class 0 OID 16922)
-- Dependencies: 228
-- Data for Name: affix_spawn_ranges; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'helmet', 'T1', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'helmet', 'T2', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'helmet', 'T3', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'helmet', 'T4', 20, 50);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_sword', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_sword', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_sword', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_sword', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_sword', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_sword', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_sword', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_sword', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'shoulder', 'T1', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'shoulder', 'T2', 12, 24);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'shoulder', 'T3', 16, 32);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'shoulder', 'T4', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'body', 'T1', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'body', 'T2', 25, 50);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'body', 'T3', 35, 70);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'body', 'T4', 50, 100);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'gloves', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'gloves', 'T2', 8, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'gloves', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'gloves', 'T4', 13, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'pants', 'T1', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'pants', 'T2', 12, 24);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'pants', 'T3', 16, 32);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'pants', 'T4', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'boots', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'boots', 'T2', 8, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'boots', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('hp', 'boots', 'T4', 13, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_hammer', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_hammer', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_hammer', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_hammer', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_mace', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_mace', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_mace', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_mace', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_axe', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_axe', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_axe', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '1h_axe', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '2h_sword', 'T1', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '2h_sword', 'T2', 9, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '2h_sword', 'T3', 12, 24);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '2h_sword', 'T4', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '2h_hammer', 'T1', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '2h_hammer', 'T2', 9, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '2h_hammer', 'T3', 12, 24);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '2h_hammer', 'T4', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '2h_axe', 'T1', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '2h_axe', 'T2', 9, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '2h_axe', 'T3', 12, 24);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', '2h_axe', 'T4', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_blaster', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_blaster', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_blaster', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_blaster', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_rifle', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_rifle', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_rifle', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_rifle', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_cannon', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_cannon', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_cannon', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_cannon', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_launcher', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_launcher', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_launcher', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_attack', 'ranged_launcher', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'helmet', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'helmet', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'helmet', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'helmet', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shoulder', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shoulder', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shoulder', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shoulder', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'body', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'body', 'T2', 7, 14);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'body', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'body', 'T4', 12, 24);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'pants', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'pants', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'pants', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'pants', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'boots', 'T1', 2, 5);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'boots', 'T2', 3, 7);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'boots', 'T3', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'boots', 'T4', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shield_phase', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shield_phase', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shield_phase', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shield_phase', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shield_photon', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shield_photon', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shield_photon', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shield_photon', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shield_quantum', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shield_quantum', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shield_quantum', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_defense', 'shield_quantum', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_hammer', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_hammer', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_hammer', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_hammer', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_mace', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_mace', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_mace', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_mace', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_axe', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_axe', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_axe', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '1h_axe', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '2h_sword', 'T1', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '2h_sword', 'T2', 9, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '2h_sword', 'T3', 12, 24);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '2h_sword', 'T4', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '2h_hammer', 'T1', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '2h_hammer', 'T2', 9, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '2h_hammer', 'T3', 12, 24);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '2h_hammer', 'T4', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '2h_axe', 'T1', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '2h_axe', 'T2', 9, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '2h_axe', 'T3', 12, 24);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', '2h_axe', 'T4', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_blaster', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_blaster', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_blaster', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_blaster', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_rifle', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_rifle', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_rifle', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_rifle', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_cannon', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_cannon', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_cannon', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_cannon', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_launcher', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_launcher', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_launcher', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_attack', 'ranged_launcher', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'helmet', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'helmet', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'helmet', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'helmet', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shoulder', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shoulder', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shoulder', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shoulder', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'body', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'body', 'T2', 7, 14);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'body', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'body', 'T4', 12, 24);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'pants', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'pants', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'pants', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'pants', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'boots', 'T1', 2, 5);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'boots', 'T2', 3, 7);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'boots', 'T3', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'boots', 'T4', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shield_phase', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shield_phase', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shield_phase', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shield_phase', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shield_photon', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shield_photon', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shield_photon', 'T3', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shield_photon', 'T4', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shield_quantum', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shield_quantum', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shield_quantum', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('basic_defense', 'shield_quantum', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_charge_time', 'helmet', 'T1', 1, 2);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_charge_time', 'helmet', 'T2', 1, 3);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_charge_time', 'helmet', 'T3', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_charge_time', 'helmet', 'T4', 2, 5);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_charge_time', 'shoulder', 'T1', 1, 2);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_charge_time', 'shoulder', 'T2', 1, 3);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_charge_time', 'shoulder', 'T3', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_charge_time', 'shoulder', 'T4', 2, 5);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_charge_time', 'augment_chip', 'T1', 1, 2);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_charge_time', 'augment_chip', 'T2', 1, 3);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_charge_time', 'augment_chip', 'T3', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_charge_time', 'augment_chip', 'T4', 2, 5);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_sword', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_sword', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_sword', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_sword', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_hammer', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_hammer', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_hammer', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_hammer', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_mace', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_mace', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_mace', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_mace', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_axe', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_axe', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_axe', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '1h_axe', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '2h_sword', 'T1', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '2h_sword', 'T2', 11, 23);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '2h_sword', 'T3', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '2h_sword', 'T4', 18, 38);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '2h_hammer', 'T1', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '2h_hammer', 'T2', 11, 23);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '2h_hammer', 'T3', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '2h_hammer', 'T4', 18, 38);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '2h_axe', 'T1', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '2h_axe', 'T2', 11, 23);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '2h_axe', 'T3', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', '2h_axe', 'T4', 18, 38);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_blaster', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_blaster', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_blaster', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_blaster', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_rifle', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_rifle', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_rifle', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_rifle', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_cannon', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_cannon', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_cannon', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_cannon', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_launcher', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_launcher', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_launcher', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('elemental_damage', 'ranged_launcher', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_reset_percentage', 'helmet', 'T1', 2, 5);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_reset_percentage', 'helmet', 'T2', 3, 7);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_reset_percentage', 'helmet', 'T3', 4, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_reset_percentage', 'helmet', 'T4', 5, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_reset_percentage', 'shoulder', 'T1', 2, 5);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_reset_percentage', 'shoulder', 'T2', 3, 7);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_reset_percentage', 'shoulder', 'T3', 4, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_reset_percentage', 'shoulder', 'T4', 5, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_reset_percentage', 'augment_chip', 'T1', 2, 5);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_reset_percentage', 'augment_chip', 'T2', 3, 7);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_reset_percentage', 'augment_chip', 'T3', 4, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_reset_percentage', 'augment_chip', 'T4', 5, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'body', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'body', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'body', 'T3', 10, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'body', 'T4', 12, 22);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'pants', 'T1', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'pants', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'pants', 'T3', 8, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'pants', 'T4', 10, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'shield_phase', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'shield_phase', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'shield_phase', 'T3', 10, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'shield_phase', 'T4', 12, 22);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'shield_photon', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'shield_photon', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'shield_photon', 'T3', 10, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'shield_photon', 'T4', 12, 22);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'shield_quantum', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'shield_quantum', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'shield_quantum', 'T3', 10, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_threshold', 'shield_quantum', 'T4', 12, 22);
INSERT INTO "Public".affix_spawn_ranges VALUES ('plus_to_skill', 'augment_chip', 'T3', 1, 1);
INSERT INTO "Public".affix_spawn_ranges VALUES ('plus_to_skill', 'augment_chip', 'T4', 1, 2);
INSERT INTO "Public".affix_spawn_ranges VALUES ('specific_ability_cdr', 'augment_chip', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('specific_ability_cdr', 'augment_chip', 'T3', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('specific_ability_cdr', 'augment_chip', 'T4', 8, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('specific_ability_cdr', 'helmet', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('specific_ability_cdr', 'helmet', 'T3', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('specific_ability_cdr', 'helmet', 'T4', 8, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('specific_ability_cdr', 'gloves', 'T2', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('specific_ability_cdr', 'gloves', 'T3', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('specific_ability_cdr', 'gloves', 'T4', 8, 18);
INSERT INTO "Public".affix_spawn_ranges VALUES ('speed', 'boots', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('speed', 'boots', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('speed', 'boots', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('speed', 'boots', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'gloves', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'gloves', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'gloves', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'gloves', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_sword', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_sword', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_sword', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_sword', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_hammer', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_hammer', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_hammer', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_hammer', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_mace', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_mace', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_mace', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_mace', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_axe', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_axe', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_axe', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '1h_axe', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '2h_sword', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '2h_sword', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '2h_sword', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '2h_sword', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '2h_hammer', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '2h_hammer', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '2h_hammer', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '2h_hammer', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '2h_axe', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '2h_axe', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '2h_axe', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', '2h_axe', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_blaster', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_blaster', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_blaster', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_blaster', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_rifle', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_rifle', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_rifle', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_rifle', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_cannon', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_cannon', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_cannon', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_cannon', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_launcher', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_launcher', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_launcher', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_speed', 'ranged_launcher', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'helmet', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'helmet', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'helmet', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'helmet', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'shoulder', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'shoulder', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'shoulder', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'shoulder', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'pants', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'pants', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'pants', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'pants', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'boots', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'boots', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'boots', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('evasion', 'boots', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_sword', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_sword', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_sword', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_sword', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_hammer', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_hammer', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_hammer', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_hammer', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_mace', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_mace', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_mace', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_mace', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_axe', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_axe', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_axe', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '1h_axe', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '2h_sword', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '2h_sword', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '2h_sword', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '2h_sword', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '2h_hammer', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '2h_hammer', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '2h_hammer', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '2h_hammer', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '2h_axe', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '2h_axe', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '2h_axe', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', '2h_axe', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_blaster', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_blaster', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_blaster', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_blaster', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_rifle', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_rifle', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_rifle', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_rifle', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_cannon', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_cannon', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_cannon', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_cannon', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_launcher', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_launcher', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_launcher', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'ranged_launcher', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'gloves', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'gloves', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'gloves', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('crit_chance', 'gloves', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_duration_length', 'helmet', 'T1', 3, 5);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_duration_length', 'helmet', 'T2', 4, 7);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_duration_length', 'helmet', 'T3', 6, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_duration_length', 'helmet', 'T4', 7, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_duration_length', 'shoulder', 'T1', 3, 5);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_duration_length', 'shoulder', 'T2', 4, 7);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_duration_length', 'shoulder', 'T3', 6, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_duration_length', 'shoulder', 'T4', 7, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_duration_length', 'augment_chip', 'T1', 3, 5);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_duration_length', 'augment_chip', 'T2', 4, 7);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_duration_length', 'augment_chip', 'T3', 6, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('trans_duration_length', 'augment_chip', 'T4', 7, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('jump', 'boots', 'T1', 1, 3);
INSERT INTO "Public".affix_spawn_ranges VALUES ('jump', 'boots', 'T2', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('jump', 'boots', 'T3', 2, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('jump', 'boots', 'T4', 3, 7);
INSERT INTO "Public".affix_spawn_ranges VALUES ('jump', 'wings', 'T1', 2, 4);
INSERT INTO "Public".affix_spawn_ranges VALUES ('jump', 'wings', 'T2', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('jump', 'wings', 'T3', 4, 8);
INSERT INTO "Public".affix_spawn_ranges VALUES ('jump', 'wings', 'T4', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shield_phase', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shield_phase', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shield_phase', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shield_phase', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shield_photon', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shield_photon', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shield_photon', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shield_photon', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shield_quantum', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shield_quantum', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shield_quantum', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shield_quantum', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'body', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'body', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'body', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'body', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shoulder', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shoulder', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shoulder', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('thorns', 'shoulder', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_sword', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_sword', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_sword', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_sword', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_hammer', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_hammer', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_hammer', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_hammer', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_mace', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_mace', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_mace', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_mace', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_axe', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_axe', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_axe', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '1h_axe', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '2h_sword', 'T1', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '2h_sword', 'T2', 11, 23);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '2h_sword', 'T3', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '2h_sword', 'T4', 18, 38);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '2h_hammer', 'T1', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '2h_hammer', 'T2', 11, 23);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '2h_hammer', 'T3', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '2h_hammer', 'T4', 18, 38);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '2h_axe', 'T1', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '2h_axe', 'T2', 11, 23);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '2h_axe', 'T3', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', '2h_axe', 'T4', 18, 38);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_blaster', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_blaster', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_blaster', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_blaster', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_rifle', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_rifle', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_rifle', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_rifle', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_cannon', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_cannon', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_cannon', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_cannon', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_launcher', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_launcher', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_launcher', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'ranged_launcher', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'gloves', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'gloves', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'gloves', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('damage_vs_elite', 'gloves', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_sword', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_sword', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_sword', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_sword', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_hammer', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_hammer', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_hammer', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_hammer', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_mace', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_mace', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_mace', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_mace', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_axe', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_axe', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_axe', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '1h_axe', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '2h_sword', 'T1', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '2h_sword', 'T2', 11, 23);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '2h_sword', 'T3', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '2h_sword', 'T4', 18, 38);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '2h_hammer', 'T1', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '2h_hammer', 'T2', 11, 23);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '2h_hammer', 'T3', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '2h_hammer', 'T4', 18, 38);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '2h_axe', 'T1', 8, 16);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '2h_axe', 'T2', 11, 23);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '2h_axe', 'T3', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', '2h_axe', 'T4', 18, 38);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_blaster', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_blaster', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_blaster', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_blaster', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_rifle', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_rifle', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_rifle', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_rifle', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_cannon', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_cannon', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_cannon', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_cannon', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_launcher', 'T1', 5, 10);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_launcher', 'T2', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_launcher', 'T3', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('virus', 'ranged_launcher', 'T4', 12, 25);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'body', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'body', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'body', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'body', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'helmet', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'helmet', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'helmet', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'helmet', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'shoulder', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'shoulder', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'shoulder', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'shoulder', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'pants', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'pants', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'pants', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('endurance_percent', 'pants', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_sword', 'T1', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_sword', 'T2', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_sword', 'T3', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_sword', 'T4', 25, 50);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_hammer', 'T1', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_hammer', 'T2', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_hammer', 'T3', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_hammer', 'T4', 25, 50);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_mace', 'T1', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_mace', 'T2', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_mace', 'T3', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_mace', 'T4', 25, 50);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_axe', 'T1', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_axe', 'T2', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_axe', 'T3', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '1h_axe', 'T4', 25, 50);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '2h_sword', 'T1', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '2h_sword', 'T2', 23, 45);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '2h_sword', 'T3', 30, 60);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '2h_sword', 'T4', 38, 75);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '2h_hammer', 'T1', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '2h_hammer', 'T2', 23, 45);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '2h_hammer', 'T3', 30, 60);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '2h_hammer', 'T4', 38, 75);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '2h_axe', 'T1', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '2h_axe', 'T2', 23, 45);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '2h_axe', 'T3', 30, 60);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', '2h_axe', 'T4', 38, 75);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_blaster', 'T1', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_blaster', 'T2', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_blaster', 'T3', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_blaster', 'T4', 25, 50);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_rifle', 'T1', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_rifle', 'T2', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_rifle', 'T3', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_rifle', 'T4', 25, 50);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_cannon', 'T1', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_cannon', 'T2', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_cannon', 'T3', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_cannon', 'T4', 25, 50);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_launcher', 'T1', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_launcher', 'T2', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_launcher', 'T3', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'ranged_launcher', 'T4', 25, 50);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'shield_phase', 'T1', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'shield_phase', 'T2', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'shield_phase', 'T3', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'shield_phase', 'T4', 25, 50);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'shield_photon', 'T1', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'shield_photon', 'T2', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'shield_photon', 'T3', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'shield_photon', 'T4', 25, 50);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'shield_quantum', 'T1', 10, 20);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'shield_quantum', 'T2', 15, 30);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'shield_quantum', 'T3', 20, 40);
INSERT INTO "Public".affix_spawn_ranges VALUES ('knockback', 'shield_quantum', 'T4', 25, 50);
INSERT INTO "Public".affix_spawn_ranges VALUES ('dash_cdr', 'boots', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('dash_cdr', 'boots', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('dash_cdr', 'boots', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('dash_cdr', 'boots', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('dash_cdr', 'augment_chip', 'T1', 3, 6);
INSERT INTO "Public".affix_spawn_ranges VALUES ('dash_cdr', 'augment_chip', 'T2', 4, 9);
INSERT INTO "Public".affix_spawn_ranges VALUES ('dash_cdr', 'augment_chip', 'T3', 6, 12);
INSERT INTO "Public".affix_spawn_ranges VALUES ('dash_cdr', 'augment_chip', 'T4', 7, 15);
INSERT INTO "Public".affix_spawn_ranges VALUES ('plus_to_skill_other_class', 'augment_chip', 'T3', 1, 2);
INSERT INTO "Public".affix_spawn_ranges VALUES ('plus_to_skill_other_class', 'augment_chip', 'T4', 1, 2);


--
-- TOC entry 5044 (class 0 OID 16939)
-- Dependencies: 229
-- Data for Name: affix_weight_overrides; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".affix_weight_overrides VALUES ('hp', 'helmet', 12);
INSERT INTO "Public".affix_weight_overrides VALUES ('basic_attack', '1h_sword', 12);
INSERT INTO "Public".affix_weight_overrides VALUES ('hp', 'body', 15);
INSERT INTO "Public".affix_weight_overrides VALUES ('basic_attack', '2h_sword', 12);
INSERT INTO "Public".affix_weight_overrides VALUES ('basic_defense', 'body', 12);
INSERT INTO "Public".affix_weight_overrides VALUES ('basic_defense', 'shield_photon', 15);
INSERT INTO "Public".affix_weight_overrides VALUES ('speed', 'boots', 15);
INSERT INTO "Public".affix_weight_overrides VALUES ('crit_chance', 'ranged_rifle', 12);
INSERT INTO "Public".affix_weight_overrides VALUES ('jump', 'wings', 15);
INSERT INTO "Public".affix_weight_overrides VALUES ('knockback', '1h_hammer', 12);
INSERT INTO "Public".affix_weight_overrides VALUES ('knockback', '2h_hammer', 12);


--
-- TOC entry 5041 (class 0 OID 16897)
-- Dependencies: 226
-- Data for Name: affixes; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".affixes VALUES ('hp', 'HP', 'prefix', 'flat', 10, '{defenseive,offensive,transformation}', 'Increases maximum hit points');
INSERT INTO "Public".affixes VALUES ('trans_attack', 'Trans Attack', 'prefix', 'flat', 8, '{"offensive,transformation"}', 'Increases attack damage while transformed');
INSERT INTO "Public".affixes VALUES ('trans_defense', 'Trans Defense', 'prefix', 'flat', 8, '{defenseive,transformation}', 'Increases attack damage while transformed');
INSERT INTO "Public".affixes VALUES ('basic_attack', 'Basic Attack', 'prefix', 'flat', 10, '{offsenive}', 'Increases basic attack damage');
INSERT INTO "Public".affixes VALUES ('basic_defense', 'Basic Defense', 'prefix', 'flat', 10, '{defensive}', 'Increases basic defense');
INSERT INTO "Public".affixes VALUES ('trans_charge_time', 'Trans Charge Time', 'prefix', 'flat', 6, '{transformation,utility}', 'Reduces transformation charge time');
INSERT INTO "Public".affixes VALUES ('elemental_damage', 'Elemental Damage', 'prefix', 'flat', 8, '{offensive,elemental}', 'Adds elemental damage to attacks');
INSERT INTO "Public".affixes VALUES ('trans_reset_percentage', 'Trans Reset Percentage', 'prefix', 'flat', 5, '{transformation,utility}', 'Chance to reset transformation cooldown');
INSERT INTO "Public".affixes VALUES ('endurance_threshold', 'Endurance Threshold', 'prefix', 'flat', 7, '{defensive}', 'Increases maximum endurance threshold');
INSERT INTO "Public".affixes VALUES ('plus_to_skill', 'Plus To Skill', 'prefix', 'flat', 3, '{utility}', 'Increases skill level (only on T3+ items)');
INSERT INTO "Public".affixes VALUES ('specific_ability_cdr', 'Specific Ability CDR', 'prefix', 'flat', 6, '{utility}', 'Reduces cooldown of specific ability (only on T2+ items)');
INSERT INTO "Public".affixes VALUES ('speed', 'Speed', 'suffix', 'flat', 10, '{utility,movement}', 'Increases movement speed');
INSERT INTO "Public".affixes VALUES ('trans_speed', 'Trans Speed', 'suffix', 'flat', 8, '{transformation,utility}', 'Increases attack speed while transformed');
INSERT INTO "Public".affixes VALUES ('evasion', 'Evasion', 'suffix', 'flat', 8, '{defensive,utility}', 'Increases dodge chance');
INSERT INTO "Public".affixes VALUES ('crit_chance', 'Critical Chance', 'suffix', 'flat', 9, '{offensive}', 'Increases critical hit chance');
INSERT INTO "Public".affixes VALUES ('trans_duration_length', 'Trans Duration Length', 'suffix', 'flat', 7, '{transformation}', 'Increases transformation duration');
INSERT INTO "Public".affixes VALUES ('jump', 'Jump', 'suffix', 'flat', 6, '{utility,movement}', 'Increases jump height');
INSERT INTO "Public".affixes VALUES ('thorns', 'Thorns', 'suffix', 'flat', 7, '{defensive}', 'Reflects damage back to attackers');
INSERT INTO "Public".affixes VALUES ('damage_vs_elite', 'Damage Vs Elite', 'suffix', 'flat', 8, '{offensive}', 'Increases damage against elite enemies');
INSERT INTO "Public".affixes VALUES ('virus', 'Virus', 'suffix', 'flat', 7, '{offensive,elemental}', 'Applies damage over time effect');
INSERT INTO "Public".affixes VALUES ('endurance_percent', 'Endurance Percent', 'suffix', 'percent', 7, '{defensive}', 'Increases endurance regeneration rate');
INSERT INTO "Public".affixes VALUES ('knockback', 'Knockback', 'suffix', 'flat', 6, '{offensive,utility}', 'Chance to knock enemies back');
INSERT INTO "Public".affixes VALUES ('dash_cdr', 'Dash CDR', 'suffix', 'flat', 8, '{utility,movement}', 'Reduces dash cooldown');
INSERT INTO "Public".affixes VALUES ('plus_to_skill_other_class', 'Plus To Skill Other Class', 'suffix', 'flat', 3, '{utility}', 'Grants skill from another class (only on T3+ items)');


--
-- TOC entry 5060 (class 0 OID 17195)
-- Dependencies: 245
-- Data for Name: armor_affix_weight_multipliers; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".armor_affix_weight_multipliers VALUES (1, 'plus_to_skill', 1.50);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (1, 'specific_ability_cdr', 1.40);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (1, 'trans_duration_length', 1.30);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (1, 'hp', 1.20);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (2, 'trans_defense', 1.50);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (2, 'basic_defense', 1.40);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (2, 'endurance_threshold', 1.30);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (3, 'hp', 1.80);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (3, 'trans_defense', 1.40);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (3, 'basic_defense', 1.40);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (3, 'endurance_percent', 1.30);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (4, 'crit_chance', 1.60);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (4, 'trans_attack', 1.50);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (4, 'basic_attack', 1.50);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (4, 'speed', 1.30);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (5, 'trans_defense', 1.50);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (5, 'basic_defense', 1.40);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (5, 'endurance_threshold', 1.30);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (6, 'speed', 2.00);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (6, 'trans_speed', 1.70);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (6, 'evasion', 1.50);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (6, 'dash_cdr', 1.40);
INSERT INTO "Public".armor_affix_weight_multipliers VALUES (6, 'jump', 1.30);


--
-- TOC entry 5059 (class 0 OID 17180)
-- Dependencies: 244
-- Data for Name: armor_allowed_affixes; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'hp');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'trans_attack');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'trans_defense');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'basic_attack');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'basic_defense');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'trans_charge_time');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'elemental_damage');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'trans_reset_percentage');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'endurance_threshold');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'plus_to_skill');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'specific_ability_cdr');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'speed');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'trans_speed');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'evasion');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'crit_chance');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'trans_duration_length');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'jump');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'thorns');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'damage_vs_elite');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'virus');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'endurance_percent');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'knockback');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'dash_cdr');
INSERT INTO "Public".armor_allowed_affixes VALUES (1, 'plus_to_skill_other_class');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'hp');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'trans_attack');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'trans_defense');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'basic_attack');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'basic_defense');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'trans_charge_time');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'elemental_damage');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'trans_reset_percentage');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'endurance_threshold');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'plus_to_skill');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'specific_ability_cdr');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'speed');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'trans_speed');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'evasion');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'crit_chance');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'trans_duration_length');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'jump');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'thorns');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'damage_vs_elite');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'virus');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'endurance_percent');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'knockback');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'dash_cdr');
INSERT INTO "Public".armor_allowed_affixes VALUES (2, 'plus_to_skill_other_class');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'hp');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'trans_attack');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'trans_defense');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'basic_attack');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'basic_defense');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'trans_charge_time');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'elemental_damage');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'trans_reset_percentage');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'endurance_threshold');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'plus_to_skill');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'specific_ability_cdr');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'speed');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'trans_speed');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'evasion');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'crit_chance');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'trans_duration_length');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'jump');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'thorns');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'damage_vs_elite');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'virus');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'endurance_percent');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'knockback');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'dash_cdr');
INSERT INTO "Public".armor_allowed_affixes VALUES (3, 'plus_to_skill_other_class');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'hp');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'trans_attack');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'trans_defense');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'basic_attack');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'basic_defense');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'trans_charge_time');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'elemental_damage');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'trans_reset_percentage');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'endurance_threshold');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'plus_to_skill');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'specific_ability_cdr');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'speed');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'trans_speed');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'evasion');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'crit_chance');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'trans_duration_length');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'jump');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'thorns');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'damage_vs_elite');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'virus');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'endurance_percent');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'knockback');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'dash_cdr');
INSERT INTO "Public".armor_allowed_affixes VALUES (4, 'plus_to_skill_other_class');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'hp');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'trans_attack');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'trans_defense');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'basic_attack');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'basic_defense');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'trans_charge_time');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'elemental_damage');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'trans_reset_percentage');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'endurance_threshold');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'plus_to_skill');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'specific_ability_cdr');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'speed');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'trans_speed');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'evasion');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'crit_chance');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'trans_duration_length');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'jump');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'thorns');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'damage_vs_elite');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'virus');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'endurance_percent');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'knockback');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'dash_cdr');
INSERT INTO "Public".armor_allowed_affixes VALUES (5, 'plus_to_skill_other_class');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'hp');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'trans_attack');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'trans_defense');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'basic_attack');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'basic_defense');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'trans_charge_time');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'elemental_damage');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'trans_reset_percentage');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'endurance_threshold');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'plus_to_skill');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'specific_ability_cdr');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'speed');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'trans_speed');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'evasion');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'crit_chance');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'trans_duration_length');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'jump');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'thorns');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'damage_vs_elite');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'virus');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'endurance_percent');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'knockback');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'dash_cdr');
INSERT INTO "Public".armor_allowed_affixes VALUES (6, 'plus_to_skill_other_class');


--
-- TOC entry 5058 (class 0 OID 17162)
-- Dependencies: 243
-- Data for Name: armor_base_stats; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".armor_base_stats VALUES (1, 1, 'T1', 'HP', 'flat', 50);
INSERT INTO "Public".armor_base_stats VALUES (2, 1, 'T2', 'HP', 'flat', 75);
INSERT INTO "Public".armor_base_stats VALUES (3, 1, 'T3', 'HP', 'flat', 100);
INSERT INTO "Public".armor_base_stats VALUES (4, 1, 'T4', 'HP', 'flat', 125);
INSERT INTO "Public".armor_base_stats VALUES (5, 1, 'T1', 'crit_resist', 'percent', 4);
INSERT INTO "Public".armor_base_stats VALUES (6, 1, 'T2', 'crit_resist', 'percent', 6);
INSERT INTO "Public".armor_base_stats VALUES (7, 1, 'T3', 'crit_resist', 'percent', 8);
INSERT INTO "Public".armor_base_stats VALUES (8, 1, 'T4', 'crit_resist', 'percent', 10);
INSERT INTO "Public".armor_base_stats VALUES (9, 2, 'T1', 'HP', 'flat', 40);
INSERT INTO "Public".armor_base_stats VALUES (10, 2, 'T2', 'HP', 'flat', 60);
INSERT INTO "Public".armor_base_stats VALUES (11, 2, 'T3', 'HP', 'flat', 80);
INSERT INTO "Public".armor_base_stats VALUES (12, 2, 'T4', 'HP', 'flat', 100);
INSERT INTO "Public".armor_base_stats VALUES (13, 2, 'T1', 'status_resist', 'percent', 5);
INSERT INTO "Public".armor_base_stats VALUES (14, 2, 'T2', 'status_resist', 'percent', 10);
INSERT INTO "Public".armor_base_stats VALUES (15, 2, 'T3', 'status_resist', 'percent', 15);
INSERT INTO "Public".armor_base_stats VALUES (16, 2, 'T4', 'status_resist', 'percent', 20);
INSERT INTO "Public".armor_base_stats VALUES (17, 3, 'T1', 'HP', 'flat', 80);
INSERT INTO "Public".armor_base_stats VALUES (18, 3, 'T2', 'HP', 'flat', 120);
INSERT INTO "Public".armor_base_stats VALUES (19, 3, 'T3', 'HP', 'flat', 160);
INSERT INTO "Public".armor_base_stats VALUES (20, 3, 'T4', 'HP', 'flat', 200);
INSERT INTO "Public".armor_base_stats VALUES (21, 4, 'T1', 'HP', 'flat', 20);
INSERT INTO "Public".armor_base_stats VALUES (22, 4, 'T2', 'HP', 'flat', 30);
INSERT INTO "Public".armor_base_stats VALUES (23, 4, 'T3', 'HP', 'flat', 40);
INSERT INTO "Public".armor_base_stats VALUES (24, 4, 'T4', 'HP', 'flat', 50);
INSERT INTO "Public".armor_base_stats VALUES (25, 4, 'T1', 'attack_speed', 'percent', 2);
INSERT INTO "Public".armor_base_stats VALUES (26, 4, 'T2', 'attack_speed', 'percent', 4);
INSERT INTO "Public".armor_base_stats VALUES (27, 4, 'T3', 'attack_speed', 'percent', 6);
INSERT INTO "Public".armor_base_stats VALUES (28, 4, 'T4', 'attack_speed', 'percent', 8);
INSERT INTO "Public".armor_base_stats VALUES (29, 5, 'T1', 'DEF', 'flat', 25);
INSERT INTO "Public".armor_base_stats VALUES (30, 5, 'T2', 'DEF', 'flat', 40);
INSERT INTO "Public".armor_base_stats VALUES (31, 5, 'T3', 'DEF', 'flat', 55);
INSERT INTO "Public".armor_base_stats VALUES (32, 5, 'T4', 'DEF', 'flat', 70);
INSERT INTO "Public".armor_base_stats VALUES (33, 5, 'T1', 'status_resist', 'percent', 5);
INSERT INTO "Public".armor_base_stats VALUES (34, 5, 'T2', 'status_resist', 'percent', 10);
INSERT INTO "Public".armor_base_stats VALUES (35, 5, 'T3', 'status_resist', 'percent', 15);
INSERT INTO "Public".armor_base_stats VALUES (36, 5, 'T4', 'status_resist', 'percent', 20);
INSERT INTO "Public".armor_base_stats VALUES (37, 6, 'T1', 'DEF', 'flat', 20);
INSERT INTO "Public".armor_base_stats VALUES (38, 6, 'T2', 'DEF', 'flat', 35);
INSERT INTO "Public".armor_base_stats VALUES (39, 6, 'T3', 'DEF', 'flat', 50);
INSERT INTO "Public".armor_base_stats VALUES (40, 6, 'T4', 'DEF', 'flat', 65);
INSERT INTO "Public".armor_base_stats VALUES (41, 6, 'T1', 'movement_speed', 'percent', 3);
INSERT INTO "Public".armor_base_stats VALUES (42, 6, 'T2', 'movement_speed', 'percent', 6);
INSERT INTO "Public".armor_base_stats VALUES (43, 6, 'T3', 'movement_speed', 'percent', 9);
INSERT INTO "Public".armor_base_stats VALUES (44, 6, 'T4', 'movement_speed', 'percent', 12);


--
-- TOC entry 5057 (class 0 OID 17144)
-- Dependencies: 242
-- Data for Name: armor_requirements; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".armor_requirements VALUES (1, 1, 'T1', 1, NULL, NULL);
INSERT INTO "Public".armor_requirements VALUES (2, 1, 'T2', 11, 10, NULL);
INSERT INTO "Public".armor_requirements VALUES (3, 1, 'T3', 26, 20, NULL);
INSERT INTO "Public".armor_requirements VALUES (4, 1, 'T4', 41, 40, NULL);
INSERT INTO "Public".armor_requirements VALUES (5, 2, 'T1', 1, NULL, NULL);
INSERT INTO "Public".armor_requirements VALUES (6, 2, 'T2', 11, 12, NULL);
INSERT INTO "Public".armor_requirements VALUES (7, 2, 'T3', 26, 24, NULL);
INSERT INTO "Public".armor_requirements VALUES (8, 2, 'T4', 41, 40, NULL);
INSERT INTO "Public".armor_requirements VALUES (9, 3, 'T1', 1, NULL, NULL);
INSERT INTO "Public".armor_requirements VALUES (10, 3, 'T2', 11, 15, NULL);
INSERT INTO "Public".armor_requirements VALUES (11, 3, 'T3', 26, 30, NULL);
INSERT INTO "Public".armor_requirements VALUES (12, 3, 'T4', 41, 50, NULL);
INSERT INTO "Public".armor_requirements VALUES (13, 4, 'T1', 1, NULL, NULL);
INSERT INTO "Public".armor_requirements VALUES (14, 4, 'T2', 11, NULL, 12);
INSERT INTO "Public".armor_requirements VALUES (15, 4, 'T3', 26, NULL, 24);
INSERT INTO "Public".armor_requirements VALUES (16, 4, 'T4', 41, NULL, 40);
INSERT INTO "Public".armor_requirements VALUES (17, 5, 'T1', 1, NULL, NULL);
INSERT INTO "Public".armor_requirements VALUES (18, 5, 'T2', 11, 10, 8);
INSERT INTO "Public".armor_requirements VALUES (19, 5, 'T3', 26, 20, 16);
INSERT INTO "Public".armor_requirements VALUES (20, 5, 'T4', 41, 35, 28);
INSERT INTO "Public".armor_requirements VALUES (21, 6, 'T1', 1, NULL, NULL);
INSERT INTO "Public".armor_requirements VALUES (22, 6, 'T2', 11, NULL, 12);
INSERT INTO "Public".armor_requirements VALUES (23, 6, 'T3', 26, NULL, 24);
INSERT INTO "Public".armor_requirements VALUES (24, 6, 'T4', 41, NULL, 40);


--
-- TOC entry 5056 (class 0 OID 17126)
-- Dependencies: 241
-- Data for Name: armor_tiers; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".armor_tiers VALUES (1, 1, 'T1', 'Neuro-Cap');
INSERT INTO "Public".armor_tiers VALUES (2, 1, 'T2', 'Synapse Visor');
INSERT INTO "Public".armor_tiers VALUES (3, 1, 'T3', 'Asynchronous Synapse Crown');
INSERT INTO "Public".armor_tiers VALUES (4, 1, 'T4', 'Overmind Halo');
INSERT INTO "Public".armor_tiers VALUES (5, 2, 'T1', 'Steel Pad');
INSERT INTO "Public".armor_tiers VALUES (6, 2, 'T2', 'Servo Mantle');
INSERT INTO "Public".armor_tiers VALUES (7, 2, 'T3', 'Ion Pauldron');
INSERT INTO "Public".armor_tiers VALUES (8, 2, 'T4', 'Nebula Shoulderguard');
INSERT INTO "Public".armor_tiers VALUES (9, 3, 'T1', 'Kevlar Weave');
INSERT INTO "Public".armor_tiers VALUES (10, 3, 'T2', 'Circuit Mesh');
INSERT INTO "Public".armor_tiers VALUES (11, 3, 'T3', 'Nano Carapace');
INSERT INTO "Public".armor_tiers VALUES (12, 3, 'T4', 'Starlight Exosuit');
INSERT INTO "Public".armor_tiers VALUES (13, 4, 'T1', 'Fiber Grip');
INSERT INTO "Public".armor_tiers VALUES (14, 4, 'T2', 'Augmentor Gloves');
INSERT INTO "Public".armor_tiers VALUES (15, 4, 'T3', 'Neural Gauntlets');
INSERT INTO "Public".armor_tiers VALUES (16, 4, 'T4', 'Singularity Claws');
INSERT INTO "Public".armor_tiers VALUES (17, 5, 'T1', 'Carbon Legwraps');
INSERT INTO "Public".armor_tiers VALUES (18, 5, 'T2', 'Synth-Lattice Legs');
INSERT INTO "Public".armor_tiers VALUES (19, 5, 'T3', 'Abyssal Frames');
INSERT INTO "Public".armor_tiers VALUES (20, 5, 'T4', 'Genesis Casing');
INSERT INTO "Public".armor_tiers VALUES (21, 6, 'T1', 'Kinetic Boots');
INSERT INTO "Public".armor_tiers VALUES (22, 6, 'T2', 'Hover Treads');
INSERT INTO "Public".armor_tiers VALUES (23, 6, 'T3', 'Ion Greaves');
INSERT INTO "Public".armor_tiers VALUES (24, 6, 'T4', 'Warp Striders');


--
-- TOC entry 5055 (class 0 OID 17116)
-- Dependencies: 240
-- Data for Name: armors; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".armors VALUES (1, 'helmet', 'Helmet', 'armor', 'light', 'head', 'Protective headgear with neural interface capabilities');
INSERT INTO "Public".armors VALUES (2, 'shoulder', 'Shoulder', 'armor', 'medium', 'shoulders', 'Reinforced shoulder plating with integrated shielding');
INSERT INTO "Public".armors VALUES (3, 'body', 'Body', 'armor', 'heavy', 'chest', 'Core armor chassis providing maximum protection');
INSERT INTO "Public".armors VALUES (4, 'gloves', 'Gloves', 'armor', 'light', 'hands', 'Enhanced gauntlets with precision actuators');
INSERT INTO "Public".armors VALUES (5, 'pants', 'Pants', 'armor', 'medium', 'legs', 'Armored leg plating with mobility systems');
INSERT INTO "Public".armors VALUES (6, 'boots', 'Boots', 'armor', 'light', 'feet', 'Advanced footwear with propulsion enhancement');


--
-- TOC entry 5046 (class 0 OID 16973)
-- Dependencies: 231
-- Data for Name: legendary_item_base_stats; Type: TABLE DATA; Schema: Public; Owner: -
--



--
-- TOC entry 5047 (class 0 OID 16985)
-- Dependencies: 232
-- Data for Name: legendary_item_fixed_affixes; Type: TABLE DATA; Schema: Public; Owner: -
--



--
-- TOC entry 5045 (class 0 OID 16961)
-- Dependencies: 230
-- Data for Name: legendary_items; Type: TABLE DATA; Schema: Public; Owner: -
--



--
-- TOC entry 5040 (class 0 OID 16887)
-- Dependencies: 225
-- Data for Name: rarities; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".rarities VALUES ('magic', 'Magic', '#4169E1', 1, 1, 1.10, 60, 10, 'Items with 1 prefix and 1 suffix', true, false, false, '{prefix} {base_name} {suffix}');
INSERT INTO "Public".rarities VALUES ('rare', 'Rare', '#FFD700', 2, 2, 1.20, 30, 20, 'Items with 2 prefixes and 2 suffixes', true, false, false, '{prefix} {base_name} {suffix}');
INSERT INTO "Public".rarities VALUES ('epic', 'Epic', '#9370DB', 3, 2, 1.30, 15, 30, 'Items with 3 prefixes and 2 suffixes', true, false, false, '{prefix} {base_name} {suffix}');
INSERT INTO "Public".rarities VALUES ('legendary', 'Legendary', '#FF8C00', 3, 3, 1.40, 5, 0, 'Handcrafted unique items with special legendary powers - Cannot be crafted on', true, false, false, '{unique_name}');
INSERT INTO "Public".rarities VALUES ('normal', 'Normal', '#FFFFFF', 0, 0, 1.00, 100, 0, 'Basic items with no affixes', true, false, false, '{base_name}');


--
-- TOC entry 5039 (class 0 OID 16865)
-- Dependencies: 224
-- Data for Name: tiers; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".tiers VALUES ('T1', 'Basic', 'Tier 1', 1, 10, 20, 100, 'Entry-level equipment for beginning your journey', '#808080');
INSERT INTO "Public".tiers VALUES ('T2', 'Advanced', 'Tier 2', 11, 25, 40, 150, 'Improved gear for progressing through mid-level content', '#4169E1');
INSERT INTO "Public".tiers VALUES ('T3', 'Superior', 'Tier 3', 26, 40, 60, 200, 'High-quality equipment for challenging encounters', '#9370DB');
INSERT INTO "Public".tiers VALUES ('T4', 'Elite', 'Tier 4', 41, 999, 80, 250, 'Top-tier endgame equipment with maximum power', '#FFD700');


--
-- TOC entry 5049 (class 0 OID 17009)
-- Dependencies: 234
-- Data for Name: weapon_affix_weight_multipliers; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (1, 'basic_attack', 1.20);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (1, 'crit_chance', 1.50);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (1, 'speed', 1.40);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (1, 'trans_speed', 1.30);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (2, 'knockback', 2.00);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (2, 'basic_attack', 1.50);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (2, 'trans_attack', 1.30);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (2, 'speed', 0.70);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (3, 'elemental_damage', 1.50);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (3, 'basic_attack', 1.30);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (3, 'knockback', 1.40);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (4, 'crit_chance', 1.60);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (4, 'damage_vs_elite', 1.40);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (4, 'basic_attack', 1.30);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (5, 'basic_attack', 1.60);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (5, 'trans_attack', 1.50);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (5, 'crit_chance', 1.30);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (5, 'speed', 0.80);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (6, 'knockback', 2.50);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (6, 'basic_attack', 1.70);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (6, 'trans_attack', 1.40);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (6, 'speed', 0.60);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (6, 'crit_chance', 0.80);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (7, 'crit_chance', 1.80);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (7, 'damage_vs_elite', 1.60);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (7, 'basic_attack', 1.50);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (7, 'knockback', 1.30);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (8, 'speed', 1.70);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (8, 'trans_speed', 1.50);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (8, 'virus', 1.40);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (8, 'basic_attack', 1.30);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (9, 'crit_chance', 2.00);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (9, 'damage_vs_elite', 1.60);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (9, 'virus', 1.40);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (9, 'basic_attack', 1.20);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (10, 'elemental_damage', 1.80);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (10, 'knockback', 1.50);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (10, 'basic_attack', 1.40);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (10, 'speed', 0.70);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (11, 'elemental_damage', 1.70);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (11, 'damage_vs_elite', 1.50);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (11, 'knockback', 1.40);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (11, 'virus', 1.30);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (12, 'evasion', 1.80);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (12, 'speed', 1.50);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (12, 'trans_defense', 1.30);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (13, 'basic_defense', 1.80);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (13, 'trans_defense', 1.60);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (13, 'endurance_threshold', 1.50);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (14, 'thorns', 1.70);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (14, 'basic_defense', 1.40);
INSERT INTO "Public".weapon_affix_weight_multipliers VALUES (14, 'endurance_threshold', 1.50);


--
-- TOC entry 5038 (class 0 OID 16842)
-- Dependencies: 223
-- Data for Name: weapon_allowed_affixes; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".weapon_allowed_affixes VALUES (1, 'elemental_damage', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (1, 'trans_speed', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (1, 'crit_chance', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (1, 'damage_vs_elite', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (1, 'virus', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (1, 'knockback', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (2, 'trans_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (2, 'basic_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (1, 'trans_attack', 1);
INSERT INTO "Public".weapon_allowed_affixes VALUES (2, 'elemental_damage', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (2, 'trans_speed', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (2, 'crit_chance', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (2, 'damage_vs_elite', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (2, 'virus', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (2, 'knockback', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (3, 'trans_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (3, 'basic_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (1, 'basic_attack', 1);
INSERT INTO "Public".weapon_allowed_affixes VALUES (3, 'elemental_damage', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (3, 'trans_speed', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (3, 'crit_chance', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (3, 'damage_vs_elite', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (3, 'virus', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (3, 'knockback', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (4, 'trans_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (4, 'basic_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (4, 'elemental_damage', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (4, 'trans_speed', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (4, 'crit_chance', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (4, 'damage_vs_elite', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (4, 'virus', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (4, 'knockback', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (5, 'trans_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (5, 'basic_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (5, 'elemental_damage', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (5, 'trans_speed', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (5, 'crit_chance', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (5, 'damage_vs_elite', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (5, 'virus', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (5, 'knockback', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (6, 'trans_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (6, 'basic_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (6, 'elemental_damage', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (6, 'trans_speed', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (6, 'crit_chance', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (6, 'damage_vs_elite', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (6, 'virus', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (6, 'knockback', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (7, 'trans_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (7, 'basic_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (7, 'elemental_damage', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (7, 'trans_speed', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (7, 'crit_chance', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (7, 'damage_vs_elite', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (7, 'virus', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (7, 'knockback', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (8, 'trans_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (8, 'basic_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (8, 'elemental_damage', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (8, 'trans_speed', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (8, 'crit_chance', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (8, 'damage_vs_elite', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (8, 'virus', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (8, 'knockback', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (9, 'trans_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (9, 'basic_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (9, 'elemental_damage', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (9, 'trans_speed', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (9, 'crit_chance', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (9, 'damage_vs_elite', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (9, 'virus', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (9, 'knockback', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (10, 'trans_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (10, 'basic_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (10, 'elemental_damage', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (10, 'trans_speed', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (10, 'crit_chance', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (10, 'damage_vs_elite', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (10, 'virus', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (10, 'knockback', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (11, 'trans_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (11, 'basic_attack', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (11, 'elemental_damage', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (11, 'trans_speed', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (11, 'crit_chance', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (11, 'damage_vs_elite', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (11, 'virus', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (11, 'knockback', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (12, 'trans_defense', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (12, 'basic_defense', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (12, 'endurance_threshold', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (12, 'evasion', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (12, 'thorns', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (12, 'knockback', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (13, 'trans_defense', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (13, 'basic_defense', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (13, 'endurance_threshold', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (13, 'evasion', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (13, 'thorns', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (13, 'knockback', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (14, 'trans_defense', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (14, 'basic_defense', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (14, 'endurance_threshold', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (14, 'evasion', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (14, 'thorns', NULL);
INSERT INTO "Public".weapon_allowed_affixes VALUES (14, 'knockback', NULL);


--
-- TOC entry 5037 (class 0 OID 16828)
-- Dependencies: 222
-- Data for Name: weapon_base_stats; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".weapon_base_stats VALUES (2, 1, 'T2', 'ATK', 'flat', 15);
INSERT INTO "Public".weapon_base_stats VALUES (3, 1, 'T3', 'ATK', 'flat', 20);
INSERT INTO "Public".weapon_base_stats VALUES (4, 1, 'T4', 'ATK', 'flat', 25);
INSERT INTO "Public".weapon_base_stats VALUES (5, 2, 'T1', 'ATK', 'flat', 10);
INSERT INTO "Public".weapon_base_stats VALUES (6, 2, 'T2', 'ATK', 'flat', 15);
INSERT INTO "Public".weapon_base_stats VALUES (7, 2, 'T3', 'ATK', 'flat', 20);
INSERT INTO "Public".weapon_base_stats VALUES (8, 2, 'T4', 'ATK', 'flat', 25);
INSERT INTO "Public".weapon_base_stats VALUES (9, 3, 'T1', 'ATK', 'flat', 10);
INSERT INTO "Public".weapon_base_stats VALUES (10, 3, 'T2', 'ATK', 'flat', 15);
INSERT INTO "Public".weapon_base_stats VALUES (11, 3, 'T3', 'ATK', 'flat', 20);
INSERT INTO "Public".weapon_base_stats VALUES (12, 3, 'T4', 'ATK', 'flat', 25);
INSERT INTO "Public".weapon_base_stats VALUES (13, 4, 'T1', 'ATK', 'flat', 10);
INSERT INTO "Public".weapon_base_stats VALUES (14, 4, 'T2', 'ATK', 'flat', 15);
INSERT INTO "Public".weapon_base_stats VALUES (15, 4, 'T3', 'ATK', 'flat', 20);
INSERT INTO "Public".weapon_base_stats VALUES (16, 4, 'T4', 'ATK', 'flat', 25);
INSERT INTO "Public".weapon_base_stats VALUES (17, 5, 'T1', 'ATK', 'flat', 15);
INSERT INTO "Public".weapon_base_stats VALUES (18, 5, 'T2', 'ATK', 'flat', 23);
INSERT INTO "Public".weapon_base_stats VALUES (19, 5, 'T3', 'ATK', 'flat', 31);
INSERT INTO "Public".weapon_base_stats VALUES (20, 5, 'T4', 'ATK', 'flat', 39);
INSERT INTO "Public".weapon_base_stats VALUES (21, 6, 'T1', 'ATK', 'flat', 15);
INSERT INTO "Public".weapon_base_stats VALUES (22, 6, 'T2', 'ATK', 'flat', 23);
INSERT INTO "Public".weapon_base_stats VALUES (23, 6, 'T3', 'ATK', 'flat', 31);
INSERT INTO "Public".weapon_base_stats VALUES (24, 6, 'T4', 'ATK', 'flat', 39);
INSERT INTO "Public".weapon_base_stats VALUES (25, 7, 'T1', 'ATK', 'flat', 15);
INSERT INTO "Public".weapon_base_stats VALUES (26, 7, 'T2', 'ATK', 'flat', 23);
INSERT INTO "Public".weapon_base_stats VALUES (27, 7, 'T3', 'ATK', 'flat', 31);
INSERT INTO "Public".weapon_base_stats VALUES (28, 7, 'T4', 'ATK', 'flat', 39);
INSERT INTO "Public".weapon_base_stats VALUES (29, 8, 'T1', 'ATK', 'flat', 12);
INSERT INTO "Public".weapon_base_stats VALUES (30, 8, 'T2', 'ATK', 'flat', 18);
INSERT INTO "Public".weapon_base_stats VALUES (31, 8, 'T3', 'ATK', 'flat', 24);
INSERT INTO "Public".weapon_base_stats VALUES (32, 8, 'T4', 'ATK', 'flat', 30);
INSERT INTO "Public".weapon_base_stats VALUES (33, 9, 'T1', 'ATK', 'flat', 12);
INSERT INTO "Public".weapon_base_stats VALUES (34, 9, 'T2', 'ATK', 'flat', 18);
INSERT INTO "Public".weapon_base_stats VALUES (35, 9, 'T3', 'ATK', 'flat', 24);
INSERT INTO "Public".weapon_base_stats VALUES (36, 9, 'T4', 'ATK', 'flat', 30);
INSERT INTO "Public".weapon_base_stats VALUES (37, 10, 'T1', 'ATK', 'flat', 12);
INSERT INTO "Public".weapon_base_stats VALUES (38, 10, 'T2', 'ATK', 'flat', 18);
INSERT INTO "Public".weapon_base_stats VALUES (39, 10, 'T3', 'ATK', 'flat', 24);
INSERT INTO "Public".weapon_base_stats VALUES (40, 10, 'T4', 'ATK', 'flat', 30);
INSERT INTO "Public".weapon_base_stats VALUES (41, 11, 'T1', 'ATK', 'flat', 12);
INSERT INTO "Public".weapon_base_stats VALUES (42, 11, 'T2', 'ATK', 'flat', 18);
INSERT INTO "Public".weapon_base_stats VALUES (43, 11, 'T3', 'ATK', 'flat', 24);
INSERT INTO "Public".weapon_base_stats VALUES (44, 11, 'T4', 'ATK', 'flat', 30);
INSERT INTO "Public".weapon_base_stats VALUES (45, 12, 'T1', 'DEF', 'flat', 30);
INSERT INTO "Public".weapon_base_stats VALUES (46, 12, 'T2', 'DEF', 'flat', 45);
INSERT INTO "Public".weapon_base_stats VALUES (47, 12, 'T3', 'DEF', 'flat', 60);
INSERT INTO "Public".weapon_base_stats VALUES (48, 12, 'T4', 'DEF', 'flat', 75);
INSERT INTO "Public".weapon_base_stats VALUES (49, 12, 'T1', 'block_chance', 'percent', 3);
INSERT INTO "Public".weapon_base_stats VALUES (50, 12, 'T2', 'block_chance', 'percent', 6);
INSERT INTO "Public".weapon_base_stats VALUES (51, 12, 'T3', 'block_chance', 'percent', 9);
INSERT INTO "Public".weapon_base_stats VALUES (52, 12, 'T4', 'block_chance', 'percent', 12);
INSERT INTO "Public".weapon_base_stats VALUES (53, 12, 'T1', 'movement_speed', 'percent', 2);
INSERT INTO "Public".weapon_base_stats VALUES (54, 12, 'T2', 'movement_speed', 'percent', 4);
INSERT INTO "Public".weapon_base_stats VALUES (55, 12, 'T3', 'movement_speed', 'percent', 6);
INSERT INTO "Public".weapon_base_stats VALUES (56, 12, 'T4', 'movement_speed', 'percent', 8);
INSERT INTO "Public".weapon_base_stats VALUES (57, 13, 'T1', 'DEF', 'flat', 35);
INSERT INTO "Public".weapon_base_stats VALUES (58, 13, 'T2', 'DEF', 'flat', 52);
INSERT INTO "Public".weapon_base_stats VALUES (59, 13, 'T3', 'DEF', 'flat', 70);
INSERT INTO "Public".weapon_base_stats VALUES (60, 13, 'T4', 'DEF', 'flat', 88);
INSERT INTO "Public".weapon_base_stats VALUES (61, 13, 'T1', 'block_chance', 'percent', 3);
INSERT INTO "Public".weapon_base_stats VALUES (62, 13, 'T2', 'block_chance', 'percent', 6);
INSERT INTO "Public".weapon_base_stats VALUES (63, 13, 'T3', 'block_chance', 'percent', 9);
INSERT INTO "Public".weapon_base_stats VALUES (64, 13, 'T4', 'block_chance', 'percent', 12);
INSERT INTO "Public".weapon_base_stats VALUES (65, 13, 'T1', 'damage_reduction', 'percent', 2);
INSERT INTO "Public".weapon_base_stats VALUES (66, 13, 'T2', 'damage_reduction', 'percent', 3);
INSERT INTO "Public".weapon_base_stats VALUES (67, 13, 'T3', 'damage_reduction', 'percent', 4);
INSERT INTO "Public".weapon_base_stats VALUES (68, 13, 'T4', 'damage_reduction', 'percent', 5);
INSERT INTO "Public".weapon_base_stats VALUES (69, 14, 'T1', 'DEF', 'flat', 30);
INSERT INTO "Public".weapon_base_stats VALUES (70, 14, 'T2', 'DEF', 'flat', 45);
INSERT INTO "Public".weapon_base_stats VALUES (71, 14, 'T3', 'DEF', 'flat', 60);
INSERT INTO "Public".weapon_base_stats VALUES (72, 14, 'T4', 'DEF', 'flat', 75);
INSERT INTO "Public".weapon_base_stats VALUES (73, 14, 'T1', 'block_chance', 'percent', 3);
INSERT INTO "Public".weapon_base_stats VALUES (74, 14, 'T2', 'block_chance', 'percent', 6);
INSERT INTO "Public".weapon_base_stats VALUES (75, 14, 'T3', 'block_chance', 'percent', 9);
INSERT INTO "Public".weapon_base_stats VALUES (76, 14, 'T4', 'block_chance', 'percent', 12);
INSERT INTO "Public".weapon_base_stats VALUES (77, 14, 'T1', 'HP', 'flat', 25);
INSERT INTO "Public".weapon_base_stats VALUES (78, 14, 'T2', 'HP', 'flat', 40);
INSERT INTO "Public".weapon_base_stats VALUES (79, 14, 'T3', 'HP', 'flat', 60);
INSERT INTO "Public".weapon_base_stats VALUES (80, 14, 'T4', 'HP', 'flat', 85);
INSERT INTO "Public".weapon_base_stats VALUES (1, 1, 'T1', 'ATK', 'flat', 10);


--
-- TOC entry 5035 (class 0 OID 16814)
-- Dependencies: 220
-- Data for Name: weapon_requirements; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".weapon_requirements VALUES (1, 1, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (2, 1, 'T2', 11, 15, 10);
INSERT INTO "Public".weapon_requirements VALUES (3, 1, 'T3', 26, 30, 20);
INSERT INTO "Public".weapon_requirements VALUES (4, 1, 'T4', 41, 50, 35);
INSERT INTO "Public".weapon_requirements VALUES (5, 2, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (6, 2, 'T2', 11, 20, 5);
INSERT INTO "Public".weapon_requirements VALUES (7, 2, 'T3', 26, 40, 10);
INSERT INTO "Public".weapon_requirements VALUES (8, 2, 'T4', 41, 65, 15);
INSERT INTO "Public".weapon_requirements VALUES (9, 3, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (10, 3, 'T2', 11, 18, 8);
INSERT INTO "Public".weapon_requirements VALUES (11, 3, 'T3', 26, 35, 15);
INSERT INTO "Public".weapon_requirements VALUES (12, 3, 'T4', 41, 55, 25);
INSERT INTO "Public".weapon_requirements VALUES (13, 4, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (14, 4, 'T2', 11, 16, 12);
INSERT INTO "Public".weapon_requirements VALUES (15, 4, 'T3', 26, 32, 24);
INSERT INTO "Public".weapon_requirements VALUES (16, 4, 'T4', 41, 52, 38);
INSERT INTO "Public".weapon_requirements VALUES (17, 5, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (18, 5, 'T2', 11, 25, NULL);
INSERT INTO "Public".weapon_requirements VALUES (19, 5, 'T3', 26, 45, NULL);
INSERT INTO "Public".weapon_requirements VALUES (20, 5, 'T4', 41, 70, NULL);
INSERT INTO "Public".weapon_requirements VALUES (21, 6, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (22, 6, 'T2', 11, 30, NULL);
INSERT INTO "Public".weapon_requirements VALUES (23, 6, 'T3', 26, 55, NULL);
INSERT INTO "Public".weapon_requirements VALUES (24, 6, 'T4', 41, 85, NULL);
INSERT INTO "Public".weapon_requirements VALUES (25, 7, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (26, 7, 'T2', 11, 28, NULL);
INSERT INTO "Public".weapon_requirements VALUES (27, 7, 'T3', 26, 50, NULL);
INSERT INTO "Public".weapon_requirements VALUES (28, 7, 'T4', 41, 75, NULL);
INSERT INTO "Public".weapon_requirements VALUES (29, 8, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (30, 8, 'T2', 11, NULL, 20);
INSERT INTO "Public".weapon_requirements VALUES (31, 8, 'T3', 26, NULL, 40);
INSERT INTO "Public".weapon_requirements VALUES (32, 8, 'T4', 41, NULL, 65);
INSERT INTO "Public".weapon_requirements VALUES (33, 9, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (34, 9, 'T2', 11, 8, 18);
INSERT INTO "Public".weapon_requirements VALUES (35, 9, 'T3', 26, 16, 36);
INSERT INTO "Public".weapon_requirements VALUES (36, 9, 'T4', 41, 26, 58);
INSERT INTO "Public".weapon_requirements VALUES (37, 10, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (38, 10, 'T2', 11, 15, 12);
INSERT INTO "Public".weapon_requirements VALUES (39, 10, 'T3', 26, 30, 24);
INSERT INTO "Public".weapon_requirements VALUES (40, 10, 'T4', 41, 48, 38);
INSERT INTO "Public".weapon_requirements VALUES (41, 11, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (42, 11, 'T2', 11, 12, 15);
INSERT INTO "Public".weapon_requirements VALUES (43, 11, 'T3', 26, 24, 30);
INSERT INTO "Public".weapon_requirements VALUES (44, 11, 'T4', 41, 38, 48);
INSERT INTO "Public".weapon_requirements VALUES (45, 12, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (46, 12, 'T2', 11, 15, NULL);
INSERT INTO "Public".weapon_requirements VALUES (47, 12, 'T3', 26, 30, NULL);
INSERT INTO "Public".weapon_requirements VALUES (48, 12, 'T4', 41, 50, NULL);
INSERT INTO "Public".weapon_requirements VALUES (49, 13, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (50, 13, 'T2', 11, 20, NULL);
INSERT INTO "Public".weapon_requirements VALUES (51, 13, 'T3', 26, 40, NULL);
INSERT INTO "Public".weapon_requirements VALUES (52, 13, 'T4', 41, 65, NULL);
INSERT INTO "Public".weapon_requirements VALUES (53, 14, 'T1', 1, NULL, NULL);
INSERT INTO "Public".weapon_requirements VALUES (54, 14, 'T2', 11, 18, NULL);
INSERT INTO "Public".weapon_requirements VALUES (55, 14, 'T3', 26, 35, NULL);
INSERT INTO "Public".weapon_requirements VALUES (56, 14, 'T4', 41, 55, NULL);


--
-- TOC entry 5033 (class 0 OID 16800)
-- Dependencies: 218
-- Data for Name: weapon_tiers; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".weapon_tiers VALUES (1, 1, 'T1', 'Plasma Cutter');
INSERT INTO "Public".weapon_tiers VALUES (2, 1, 'T2', 'Photon Blade');
INSERT INTO "Public".weapon_tiers VALUES (3, 1, 'T3', 'Quantom Edge');
INSERT INTO "Public".weapon_tiers VALUES (4, 1, 'T4', 'Void Katana');
INSERT INTO "Public".weapon_tiers VALUES (5, 2, 'T1', 'Steel Baton');
INSERT INTO "Public".weapon_tiers VALUES (6, 2, 'T2', 'Shock Mace');
INSERT INTO "Public".weapon_tiers VALUES (7, 2, 'T3', 'Ion Scepter');
INSERT INTO "Public".weapon_tiers VALUES (8, 2, 'T4', 'Antimatter Rod');
INSERT INTO "Public".weapon_tiers VALUES (9, 3, 'T1', 'Ripper Hatchet');
INSERT INTO "Public".weapon_tiers VALUES (10, 3, 'T2', 'Chainlink Cleaver');
INSERT INTO "Public".weapon_tiers VALUES (11, 3, 'T3', 'Thermal Splitter');
INSERT INTO "Public".weapon_tiers VALUES (12, 3, 'T4', 'Eclipse Reaver');
INSERT INTO "Public".weapon_tiers VALUES (13, 4, 'T1', 'Piston Strike');
INSERT INTO "Public".weapon_tiers VALUES (14, 4, 'T2', 'Servo Crusher');
INSERT INTO "Public".weapon_tiers VALUES (15, 4, 'T3', 'Graviton Maul');
INSERT INTO "Public".weapon_tiers VALUES (16, 4, 'T4', 'Singularity Hammer');
INSERT INTO "Public".weapon_tiers VALUES (18, 5, 'T1', 'Charged Claymore');
INSERT INTO "Public".weapon_tiers VALUES (19, 5, 'T2', 'Nano Greatsword');
INSERT INTO "Public".weapon_tiers VALUES (20, 5, 'T3', 'Fusion Blade');
INSERT INTO "Public".weapon_tiers VALUES (21, 5, 'T4', 'Celestial Executioner');
INSERT INTO "Public".weapon_tiers VALUES (22, 6, 'T1', 'Hydraulic Sledge');
INSERT INTO "Public".weapon_tiers VALUES (23, 6, 'T2', 'Tremor Breaker');
INSERT INTO "Public".weapon_tiers VALUES (24, 6, 'T3', 'Meteor Crusher');
INSERT INTO "Public".weapon_tiers VALUES (25, 6, 'T4', 'World Ender');
INSERT INTO "Public".weapon_tiers VALUES (26, 7, 'T1', 'Scrap Hewer');
INSERT INTO "Public".weapon_tiers VALUES (27, 7, 'T2', 'Circuit Splitter');
INSERT INTO "Public".weapon_tiers VALUES (28, 7, 'T3', 'Graviton Carver');
INSERT INTO "Public".weapon_tiers VALUES (29, 7, 'T4', 'Starfall Executioner');
INSERT INTO "Public".weapon_tiers VALUES (30, 8, 'T1', 'Pulse Pistol');
INSERT INTO "Public".weapon_tiers VALUES (31, 8, 'T2', 'Rapid Ionizer');
INSERT INTO "Public".weapon_tiers VALUES (32, 8, 'T3', 'Plasma Repeater');
INSERT INTO "Public".weapon_tiers VALUES (33, 8, 'T4', 'Voidstream Blaster');
INSERT INTO "Public".weapon_tiers VALUES (34, 9, 'T1', 'Bolt Carbine');
INSERT INTO "Public".weapon_tiers VALUES (35, 9, 'T2', 'Smart Rifle');
INSERT INTO "Public".weapon_tiers VALUES (36, 9, 'T3', 'Cryo Marksman');
INSERT INTO "Public".weapon_tiers VALUES (37, 9, 'T4', 'Oblivion Sniper');
INSERT INTO "Public".weapon_tiers VALUES (38, 10, 'T1', 'Charge Cannon');
INSERT INTO "Public".weapon_tiers VALUES (39, 10, 'T2', 'Arc Projector');
INSERT INTO "Public".weapon_tiers VALUES (40, 10, 'T3', 'Fusion Howitzer');
INSERT INTO "Public".weapon_tiers VALUES (41, 10, 'T4', 'Supernova Destructor');
INSERT INTO "Public".weapon_tiers VALUES (42, 11, 'T1', 'Grenade Tube');
INSERT INTO "Public".weapon_tiers VALUES (43, 11, 'T2', 'Missile Pod');
INSERT INTO "Public".weapon_tiers VALUES (44, 11, 'T3', 'Quantum Mortar');
INSERT INTO "Public".weapon_tiers VALUES (45, 11, 'T4', 'Apocalypse Launcher');
INSERT INTO "Public".weapon_tiers VALUES (46, 12, 'T1', 'Flicker Barrier');
INSERT INTO "Public".weapon_tiers VALUES (47, 12, 'T2', 'Phase Wall');
INSERT INTO "Public".weapon_tiers VALUES (48, 12, 'T3', 'Warp Aegis');
INSERT INTO "Public".weapon_tiers VALUES (49, 12, 'T4', 'Dimensional Guard');
INSERT INTO "Public".weapon_tiers VALUES (50, 13, 'T1', 'Light Buckler');
INSERT INTO "Public".weapon_tiers VALUES (51, 13, 'T2', 'Photon Barrier');
INSERT INTO "Public".weapon_tiers VALUES (52, 13, 'T3', 'Radiant Bulwark');
INSERT INTO "Public".weapon_tiers VALUES (53, 13, 'T4', 'Stellar Fortress');
INSERT INTO "Public".weapon_tiers VALUES (54, 14, 'T1', 'Nano Plate');
INSERT INTO "Public".weapon_tiers VALUES (55, 14, 'T2', 'Quantum Shield');
INSERT INTO "Public".weapon_tiers VALUES (56, 14, 'T3', 'Singularity Guard');
INSERT INTO "Public".weapon_tiers VALUES (57, 14, 'T4', 'Event Horizon');


--
-- TOC entry 5031 (class 0 OID 16773)
-- Dependencies: 216
-- Data for Name: weapons; Type: TABLE DATA; Schema: Public; Owner: -
--

INSERT INTO "Public".weapons VALUES (1, '1h_sword', '1 Hand Sword', 'weapon', '1h', 'main_hand', 'Balanced energy blade for swift combat');
INSERT INTO "Public".weapons VALUES (2, '1h_mace', '1 Hand Mace', 'weapon', '1h', 'main_hand', 'Reinforced bludgeon for crushing force');
INSERT INTO "Public".weapons VALUES (3, '1h_axe', '1 Hand Axe', 'weapon', '1h', 'main_hand', 'Sharp cleaving weapon with lethal edge');
INSERT INTO "Public".weapons VALUES (4, '1h_hammer', '1 Hand Hammer', 'weapon', '1h', 'main_hand', 'Heavy striking tool with kinetic impact');
INSERT INTO "Public".weapons VALUES (5, '2h_sword', '2 Hand Sword', 'weapon', '2h', 'two_hand', 'Massive energy blade for devastating strikes');
INSERT INTO "Public".weapons VALUES (6, '2h_hammer', '2 Hand Hammer', 'weapon', '2h', 'two_hand', 'Colossal impact weapon with seismic force');
INSERT INTO "Public".weapons VALUES (7, '2h_axe', '2 Hand Axe', 'weapon', '2h', 'two_hand', 'Heavy cleaving weapon for brutal attacks');
INSERT INTO "Public".weapons VALUES (8, 'ranged_blaster', 'Blaster', 'weapon', 'ranged', 'main_hand', 'Rapid-fire energy weapon for sustained damage');
INSERT INTO "Public".weapons VALUES (9, 'ranged_rifle', 'Rifle', 'weapon', 'ranged', 'main_hand', 'Precision weapon for accurate long-range shots');
INSERT INTO "Public".weapons VALUES (10, 'ranged_cannon', 'Cannon', 'weapon', 'ranged', 'main_hand', 'Heavy weapon for explosive area damage');
INSERT INTO "Public".weapons VALUES (11, 'ranged_launcher', 'Launcher', 'weapon', 'ranged', 'main_hand', 'Projectile launcher for high-impact ordinance');
INSERT INTO "Public".weapons VALUES (12, 'shield_phase', 'Phase Shield', 'weapon', 'shield', 'off_hand', 'Defensive barrier that phases out incoming damage');
INSERT INTO "Public".weapons VALUES (13, 'shield_photon', 'Photon Shield', 'weapon', 'shield', 'off_hand', 'Energy shield that redirects incoming attacks');
INSERT INTO "Public".weapons VALUES (14, 'shield_quantum', 'Quantum Shield', 'weapon', 'shield', 'off_hand', 'Reality-warping shield with complex defenses');


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 239
-- Name: armor_base_stats_id_seq; Type: SEQUENCE SET; Schema: Public; Owner: -
--

SELECT pg_catalog.setval('"Public".armor_base_stats_id_seq', 44, true);


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 238
-- Name: armor_requirements_id_seq; Type: SEQUENCE SET; Schema: Public; Owner: -
--

SELECT pg_catalog.setval('"Public".armor_requirements_id_seq', 24, true);


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 237
-- Name: armor_tiers_id_seq; Type: SEQUENCE SET; Schema: Public; Owner: -
--

SELECT pg_catalog.setval('"Public".armor_tiers_id_seq', 24, true);


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 236
-- Name: armors_id_seq; Type: SEQUENCE SET; Schema: Public; Owner: -
--

SELECT pg_catalog.setval('"Public".armors_id_seq', 6, true);


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 221
-- Name: weapon_base_stats_id_seq; Type: SEQUENCE SET; Schema: Public; Owner: -
--

SELECT pg_catalog.setval('"Public".weapon_base_stats_id_seq', 80, true);


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 219
-- Name: weapon_requirements_id_seq; Type: SEQUENCE SET; Schema: Public; Owner: -
--

SELECT pg_catalog.setval('"Public".weapon_requirements_id_seq', 56, true);


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 217
-- Name: weapon_tiers_id_seq; Type: SEQUENCE SET; Schema: Public; Owner: -
--

SELECT pg_catalog.setval('"Public".weapon_tiers_id_seq', 57, true);


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 215
-- Name: weapons_id_seq; Type: SEQUENCE SET; Schema: Public; Owner: -
--

SELECT pg_catalog.setval('"Public".weapons_id_seq', 2, true);


--
-- TOC entry 4823 (class 2606 OID 16910)
-- Name: affix_epithets affix_epithets_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".affix_epithets
    ADD CONSTRAINT affix_epithets_pkey PRIMARY KEY (affix_code, tier_code);


--
-- TOC entry 4825 (class 2606 OID 16928)
-- Name: affix_spawn_ranges affix_spawn_ranges_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".affix_spawn_ranges
    ADD CONSTRAINT affix_spawn_ranges_pkey PRIMARY KEY (affix_code, item_slot, tier_code);


--
-- TOC entry 4827 (class 2606 OID 16945)
-- Name: affix_weight_overrides affix_weight_overrides_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".affix_weight_overrides
    ADD CONSTRAINT affix_weight_overrides_pkey PRIMARY KEY (affix_code, item_slot);


--
-- TOC entry 4821 (class 2606 OID 16903)
-- Name: affixes affixes_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".affixes
    ADD CONSTRAINT affixes_pkey PRIMARY KEY (code);


--
-- TOC entry 4849 (class 2606 OID 17167)
-- Name: armor_base_stats armor_base_stats_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_base_stats
    ADD CONSTRAINT armor_base_stats_pkey PRIMARY KEY (id);


--
-- TOC entry 4845 (class 2606 OID 17149)
-- Name: armor_requirements armor_requirements_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_requirements
    ADD CONSTRAINT armor_requirements_pkey PRIMARY KEY (id);


--
-- TOC entry 4841 (class 2606 OID 17133)
-- Name: armor_tiers armor_tiers_armor_id_tier_key; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_tiers
    ADD CONSTRAINT armor_tiers_armor_id_tier_key UNIQUE (armor_id, tier);


--
-- TOC entry 4843 (class 2606 OID 17131)
-- Name: armor_tiers armor_tiers_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_tiers
    ADD CONSTRAINT armor_tiers_pkey PRIMARY KEY (id);


--
-- TOC entry 4837 (class 2606 OID 17125)
-- Name: armors armors_code_key; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armors
    ADD CONSTRAINT armors_code_key UNIQUE (code);


--
-- TOC entry 4839 (class 2606 OID 17123)
-- Name: armors armors_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armors
    ADD CONSTRAINT armors_pkey PRIMARY KEY (id);


--
-- TOC entry 4831 (class 2606 OID 16979)
-- Name: legendary_item_base_stats legendary_item_base_stats_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".legendary_item_base_stats
    ADD CONSTRAINT legendary_item_base_stats_pkey PRIMARY KEY (legendary_item_code, stat_name);


--
-- TOC entry 4833 (class 2606 OID 16991)
-- Name: legendary_item_fixed_affixes legendary_item_fixed_affixes_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".legendary_item_fixed_affixes
    ADD CONSTRAINT legendary_item_fixed_affixes_pkey PRIMARY KEY (legendary_item_code, affix_code);


--
-- TOC entry 4829 (class 2606 OID 16967)
-- Name: legendary_items legendary_items_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".legendary_items
    ADD CONSTRAINT legendary_items_pkey PRIMARY KEY (code);


--
-- TOC entry 4855 (class 2606 OID 17199)
-- Name: armor_affix_weight_multipliers pk_armor_affix_weights; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_affix_weight_multipliers
    ADD CONSTRAINT pk_armor_affix_weights PRIMARY KEY (armor_id, affix_code);


--
-- TOC entry 4853 (class 2606 OID 17184)
-- Name: armor_allowed_affixes pk_armor_allowed_affixes; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_allowed_affixes
    ADD CONSTRAINT pk_armor_allowed_affixes PRIMARY KEY (armor_id, affix_name);


--
-- TOC entry 4835 (class 2606 OID 17013)
-- Name: weapon_affix_weight_multipliers pk_weapon_affix_weights; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_affix_weight_multipliers
    ADD CONSTRAINT pk_weapon_affix_weights PRIMARY KEY (weapon_id, affix_code);


--
-- TOC entry 4815 (class 2606 OID 16846)
-- Name: weapon_allowed_affixes pk_weapon_allowed_affixes; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_allowed_affixes
    ADD CONSTRAINT pk_weapon_allowed_affixes PRIMARY KEY (weapon_id, affix_name);


--
-- TOC entry 4819 (class 2606 OID 16896)
-- Name: rarities rarities_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".rarities
    ADD CONSTRAINT rarities_pkey PRIMARY KEY (code);


--
-- TOC entry 4817 (class 2606 OID 16871)
-- Name: tiers tiers_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".tiers
    ADD CONSTRAINT tiers_pkey PRIMARY KEY (code);


--
-- TOC entry 4851 (class 2606 OID 17169)
-- Name: armor_base_stats uq_armor_tier_stat; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_base_stats
    ADD CONSTRAINT uq_armor_tier_stat UNIQUE (armor_id, tier, stat_name);


--
-- TOC entry 4847 (class 2606 OID 17151)
-- Name: armor_requirements uq_req_tier_per_armor; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_requirements
    ADD CONSTRAINT uq_req_tier_per_armor UNIQUE (armor_id, tier);


--
-- TOC entry 4807 (class 2606 OID 16821)
-- Name: weapon_requirements uq_req_tier_per_weapon; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_requirements
    ADD CONSTRAINT uq_req_tier_per_weapon UNIQUE (weapon_id, tier);


--
-- TOC entry 4811 (class 2606 OID 16835)
-- Name: weapon_base_stats uq_weapon_tier_stat; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_base_stats
    ADD CONSTRAINT uq_weapon_tier_stat UNIQUE (weapon_id, tier, stat_name);


--
-- TOC entry 4813 (class 2606 OID 16833)
-- Name: weapon_base_stats weapon_base_stats_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_base_stats
    ADD CONSTRAINT weapon_base_stats_pkey PRIMARY KEY (id);


--
-- TOC entry 4809 (class 2606 OID 16819)
-- Name: weapon_requirements weapon_requirements_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_requirements
    ADD CONSTRAINT weapon_requirements_pkey PRIMARY KEY (id);


--
-- TOC entry 4803 (class 2606 OID 16805)
-- Name: weapon_tiers weapon_tiers_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_tiers
    ADD CONSTRAINT weapon_tiers_pkey PRIMARY KEY (id);


--
-- TOC entry 4805 (class 2606 OID 16807)
-- Name: weapon_tiers weapon_tiers_weapon_id_tier_key; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_tiers
    ADD CONSTRAINT weapon_tiers_weapon_id_tier_key UNIQUE (weapon_id, tier);


--
-- TOC entry 4799 (class 2606 OID 16782)
-- Name: weapons weapons_code_key; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapons
    ADD CONSTRAINT weapons_code_key UNIQUE (code);


--
-- TOC entry 4801 (class 2606 OID 16780)
-- Name: weapons weapons_pkey; Type: CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapons
    ADD CONSTRAINT weapons_pkey PRIMARY KEY (id);


--
-- TOC entry 4864 (class 2606 OID 16911)
-- Name: affix_epithets affix_epithets_affix_code_fkey; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".affix_epithets
    ADD CONSTRAINT affix_epithets_affix_code_fkey FOREIGN KEY (affix_code) REFERENCES "Public".affixes(code);


--
-- TOC entry 4865 (class 2606 OID 16916)
-- Name: affix_epithets affix_epithets_tier_code_fkey; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".affix_epithets
    ADD CONSTRAINT affix_epithets_tier_code_fkey FOREIGN KEY (tier_code) REFERENCES "Public".tiers(code);


--
-- TOC entry 4866 (class 2606 OID 16929)
-- Name: affix_spawn_ranges affix_spawn_ranges_affix_code_fkey; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".affix_spawn_ranges
    ADD CONSTRAINT affix_spawn_ranges_affix_code_fkey FOREIGN KEY (affix_code) REFERENCES "Public".affixes(code);


--
-- TOC entry 4867 (class 2606 OID 16934)
-- Name: affix_spawn_ranges affix_spawn_ranges_tier_code_fkey; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".affix_spawn_ranges
    ADD CONSTRAINT affix_spawn_ranges_tier_code_fkey FOREIGN KEY (tier_code) REFERENCES "Public".tiers(code);


--
-- TOC entry 4868 (class 2606 OID 16946)
-- Name: affix_weight_overrides affix_weight_overrides_affix_code_fkey; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".affix_weight_overrides
    ADD CONSTRAINT affix_weight_overrides_affix_code_fkey FOREIGN KEY (affix_code) REFERENCES "Public".affixes(code);


--
-- TOC entry 4873 (class 2606 OID 17014)
-- Name: weapon_affix_weight_multipliers fk_affix_weights_weapon; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_affix_weight_multipliers
    ADD CONSTRAINT fk_affix_weights_weapon FOREIGN KEY (weapon_id) REFERENCES "Public".weapons(id);


--
-- TOC entry 4862 (class 2606 OID 16847)
-- Name: weapon_allowed_affixes fk_allowed_affixes_weapon; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_allowed_affixes
    ADD CONSTRAINT fk_allowed_affixes_weapon FOREIGN KEY (weapon_id) REFERENCES "Public".weapons(id);


--
-- TOC entry 4882 (class 2606 OID 17205)
-- Name: armor_affix_weight_multipliers fk_armor_affix_weights_affix; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_affix_weight_multipliers
    ADD CONSTRAINT fk_armor_affix_weights_affix FOREIGN KEY (affix_code) REFERENCES "Public".affixes(code);


--
-- TOC entry 4883 (class 2606 OID 17200)
-- Name: armor_affix_weight_multipliers fk_armor_affix_weights_armor; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_affix_weight_multipliers
    ADD CONSTRAINT fk_armor_affix_weights_armor FOREIGN KEY (armor_id) REFERENCES "Public".armors(id);


--
-- TOC entry 4880 (class 2606 OID 17190)
-- Name: armor_allowed_affixes fk_armor_allowed_affixes_affix; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_allowed_affixes
    ADD CONSTRAINT fk_armor_allowed_affixes_affix FOREIGN KEY (affix_name) REFERENCES "Public".affixes(code);


--
-- TOC entry 4881 (class 2606 OID 17185)
-- Name: armor_allowed_affixes fk_armor_allowed_affixes_armor; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_allowed_affixes
    ADD CONSTRAINT fk_armor_allowed_affixes_armor FOREIGN KEY (armor_id) REFERENCES "Public".armors(id);


--
-- TOC entry 4878 (class 2606 OID 17170)
-- Name: armor_base_stats fk_armor_base_stats_armor; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_base_stats
    ADD CONSTRAINT fk_armor_base_stats_armor FOREIGN KEY (armor_id) REFERENCES "Public".armors(id);


--
-- TOC entry 4879 (class 2606 OID 17175)
-- Name: armor_base_stats fk_armor_base_stats_tier; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_base_stats
    ADD CONSTRAINT fk_armor_base_stats_tier FOREIGN KEY (tier) REFERENCES "Public".tiers(code);


--
-- TOC entry 4876 (class 2606 OID 17152)
-- Name: armor_requirements fk_armor_requirements_armor; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_requirements
    ADD CONSTRAINT fk_armor_requirements_armor FOREIGN KEY (armor_id) REFERENCES "Public".armors(id);


--
-- TOC entry 4877 (class 2606 OID 17157)
-- Name: armor_requirements fk_armor_requirements_tier; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_requirements
    ADD CONSTRAINT fk_armor_requirements_tier FOREIGN KEY (tier) REFERENCES "Public".tiers(code);


--
-- TOC entry 4874 (class 2606 OID 17134)
-- Name: armor_tiers fk_armor_tiers_armor; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_tiers
    ADD CONSTRAINT fk_armor_tiers_armor FOREIGN KEY (armor_id) REFERENCES "Public".armors(id);


--
-- TOC entry 4875 (class 2606 OID 17139)
-- Name: armor_tiers fk_armor_tiers_tier; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".armor_tiers
    ADD CONSTRAINT fk_armor_tiers_tier FOREIGN KEY (tier) REFERENCES "Public".tiers(code);


--
-- TOC entry 4860 (class 2606 OID 16836)
-- Name: weapon_base_stats fk_base_stats_weapon; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_base_stats
    ADD CONSTRAINT fk_base_stats_weapon FOREIGN KEY (weapon_id) REFERENCES "Public".weapons(id);


--
-- TOC entry 4863 (class 2606 OID 16956)
-- Name: weapon_allowed_affixes fk_weapon_allowed_affixes_tier; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_allowed_affixes
    ADD CONSTRAINT fk_weapon_allowed_affixes_tier FOREIGN KEY (affix_name) REFERENCES "Public".affixes(code);


--
-- TOC entry 4861 (class 2606 OID 16882)
-- Name: weapon_base_stats fk_weapon_base_stats_tier; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_base_stats
    ADD CONSTRAINT fk_weapon_base_stats_tier FOREIGN KEY (tier) REFERENCES "Public".tiers(code);


--
-- TOC entry 4858 (class 2606 OID 16877)
-- Name: weapon_requirements fk_weapon_requirements_tier; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_requirements
    ADD CONSTRAINT fk_weapon_requirements_tier FOREIGN KEY (tier) REFERENCES "Public".tiers(code);


--
-- TOC entry 4859 (class 2606 OID 16822)
-- Name: weapon_requirements fk_weapon_requirements_weapon; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_requirements
    ADD CONSTRAINT fk_weapon_requirements_weapon FOREIGN KEY (weapon_id) REFERENCES "Public".weapons(id);


--
-- TOC entry 4856 (class 2606 OID 16872)
-- Name: weapon_tiers fk_weapon_tiers_tier; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_tiers
    ADD CONSTRAINT fk_weapon_tiers_tier FOREIGN KEY (tier) REFERENCES "Public".tiers(code);


--
-- TOC entry 4870 (class 2606 OID 16980)
-- Name: legendary_item_base_stats legendary_item_base_stats_legendary_item_code_fkey; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".legendary_item_base_stats
    ADD CONSTRAINT legendary_item_base_stats_legendary_item_code_fkey FOREIGN KEY (legendary_item_code) REFERENCES "Public".legendary_items(code);


--
-- TOC entry 4871 (class 2606 OID 16997)
-- Name: legendary_item_fixed_affixes legendary_item_fixed_affixes_affix_code_fkey; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".legendary_item_fixed_affixes
    ADD CONSTRAINT legendary_item_fixed_affixes_affix_code_fkey FOREIGN KEY (affix_code) REFERENCES "Public".affixes(code);


--
-- TOC entry 4872 (class 2606 OID 16992)
-- Name: legendary_item_fixed_affixes legendary_item_fixed_affixes_legendary_item_code_fkey; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".legendary_item_fixed_affixes
    ADD CONSTRAINT legendary_item_fixed_affixes_legendary_item_code_fkey FOREIGN KEY (legendary_item_code) REFERENCES "Public".legendary_items(code);


--
-- TOC entry 4869 (class 2606 OID 16968)
-- Name: legendary_items legendary_items_tier_code_fkey; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".legendary_items
    ADD CONSTRAINT legendary_items_tier_code_fkey FOREIGN KEY (tier_code) REFERENCES "Public".tiers(code);


--
-- TOC entry 4857 (class 2606 OID 16808)
-- Name: weapon_tiers weapon_tiers_weapon_id_fkey; Type: FK CONSTRAINT; Schema: Public; Owner: -
--

ALTER TABLE ONLY "Public".weapon_tiers
    ADD CONSTRAINT weapon_tiers_weapon_id_fkey FOREIGN KEY (weapon_id) REFERENCES "Public".weapons(id);


--
-- TOC entry 5061 (class 0 OID 17210)
-- Dependencies: 246 5063
-- Name: mv_armor_relations; Type: MATERIALIZED VIEW DATA; Schema: Public; Owner: -
--

REFRESH MATERIALIZED VIEW "Public".mv_armor_relations;


--
-- TOC entry 5050 (class 0 OID 17037)
-- Dependencies: 235 5063
-- Name: mv_weapon_relations; Type: MATERIALIZED VIEW DATA; Schema: Public; Owner: -
--

REFRESH MATERIALIZED VIEW "Public".mv_weapon_relations;


--
-- TOC entry 5048 (class 0 OID 17002)
-- Dependencies: 233 5063
-- Name: vw_legendary_items_full; Type: MATERIALIZED VIEW DATA; Schema: Public; Owner: -
--

REFRESH MATERIALIZED VIEW "Public".vw_legendary_items_full;


-- Completed on 2025-11-21 11:43:01

--
-- PostgreSQL database dump complete
--

