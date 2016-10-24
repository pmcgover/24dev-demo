--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.3
-- Dumped by pg_dump version 9.5.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: family; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE family (
    family_key character varying(20),
    id integer NOT NULL,
    notes character varying DEFAULT '0'::character varying NOT NULL,
    female_plant_id integer DEFAULT 1 NOT NULL,
    male_plant_id integer DEFAULT 1 NOT NULL,
    seed_notes character varying DEFAULT '0'::character varying NOT NULL,
    form_fnmwu character(1) DEFAULT 'U'::bpchar NOT NULL,
    is_plus character(1) DEFAULT 'U'::bpchar NOT NULL,
    is_root character varying DEFAULT '0'::character varying NOT NULL,
    seeds_in_storage numeric DEFAULT '-1'::integer NOT NULL,
    ploidy_n integer DEFAULT '-1'::integer NOT NULL,
    seed_germ_percent numeric DEFAULT '-1'::numeric NOT NULL,
    seed_germ_date date DEFAULT '1111-11-11'::date NOT NULL,
    cross_date date DEFAULT '1111-11-11'::date NOT NULL,
    id_taxa integer NOT NULL,
    web_photos character varying DEFAULT '0'::character varying NOT NULL,
    web_url character varying DEFAULT '0'::character varying NOT NULL,
    CONSTRAINT family_form_fnmwu_check CHECK ((form_fnmwu = ANY (ARRAY['U'::bpchar, 'F'::bpchar, 'N'::bpchar, 'M'::bpchar, 'W'::bpchar]))),
    CONSTRAINT family_is_plus_check CHECK ((is_plus = ANY (ARRAY['N'::bpchar, 'Y'::bpchar, 'U'::bpchar]))),
    CONSTRAINT family_seed_germ_percent_check CHECK ((seed_germ_percent < (1)::numeric))
);


ALTER TABLE family OWNER TO "user";

--
-- Name: plant; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE plant (
    plant_key character varying(20),
    id integer NOT NULL,
    notes character varying DEFAULT '0'::character varying NOT NULL,
    sex_mfbu character(1) DEFAULT 'U'::bpchar NOT NULL,
    published_botanical_name character varying DEFAULT '0'::character varying NOT NULL,
    common_name character varying DEFAULT '0'::character varying NOT NULL,
    alternate_name character varying DEFAULT '0'::character varying NOT NULL,
    aquired_from character varying DEFAULT '0'::character varying NOT NULL,
    female_external_parent character varying DEFAULT '0'::character varying NOT NULL,
    male_external_parent character varying DEFAULT '0'::character varying NOT NULL,
    form_fnmwu character(1) DEFAULT 'U'::bpchar NOT NULL,
    is_plus character(1) DEFAULT 'U'::bpchar NOT NULL,
    is_cultivar character(1) DEFAULT 'U'::bpchar NOT NULL,
    is_variety character(1) DEFAULT 'U'::bpchar NOT NULL,
    is_from_wild character(1) DEFAULT 'U'::bpchar NOT NULL,
    ploidy_n integer DEFAULT 0 NOT NULL,
    date_aquired date DEFAULT '1111-11-11'::date NOT NULL,
    id_taxa integer NOT NULL,
    id_family integer NOT NULL,
    web_photos character varying DEFAULT '0'::character varying NOT NULL,
    web_url character varying DEFAULT '0'::character varying NOT NULL,
    CONSTRAINT plant_form_fnmwu_check CHECK ((form_fnmwu = ANY (ARRAY['U'::bpchar, 'F'::bpchar, 'N'::bpchar, 'M'::bpchar, 'W'::bpchar]))),
    CONSTRAINT plant_is_cultivar_check CHECK ((is_cultivar = ANY (ARRAY['N'::bpchar, 'Y'::bpchar, 'U'::bpchar]))),
    CONSTRAINT plant_is_from_wild_check CHECK ((is_from_wild = ANY (ARRAY['N'::bpchar, 'Y'::bpchar, 'U'::bpchar]))),
    CONSTRAINT plant_is_plus_check CHECK ((is_plus = ANY (ARRAY['N'::bpchar, 'Y'::bpchar, 'U'::bpchar]))),
    CONSTRAINT plant_is_variety_check CHECK ((is_variety = ANY (ARRAY['N'::bpchar, 'Y'::bpchar, 'U'::bpchar]))),
    CONSTRAINT plant_sex_mfbu_check CHECK ((sex_mfbu = ANY (ARRAY['U'::bpchar, 'M'::bpchar, 'F'::bpchar, 'B'::bpchar])))
);


ALTER TABLE plant OWNER TO "user";

--
-- Name: taxa; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE taxa (
    taxa_key character varying(20),
    id integer NOT NULL,
    notes character varying DEFAULT '0'::character varying NOT NULL,
    species character varying DEFAULT '0'::character varying NOT NULL,
    species_hybrid character varying DEFAULT '0'::character varying NOT NULL,
    common_name character varying DEFAULT '0'::character varying NOT NULL,
    binomial_name character varying DEFAULT '0'::character varying NOT NULL,
    kingdom character varying DEFAULT '0'::character varying NOT NULL,
    family character varying DEFAULT '0'::character varying NOT NULL,
    genus character varying DEFAULT '0'::character varying NOT NULL,
    web_photos character varying DEFAULT '0'::character varying NOT NULL,
    web_url character varying DEFAULT '0'::character varying NOT NULL,
    CONSTRAINT taxa_check CHECK ((((species)::text = '0'::text) OR ((species_hybrid)::text = '0'::text)))
);


ALTER TABLE taxa OWNER TO "user";

--
-- Name: avw_family; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avw_family AS
 SELECT f.family_key,
    f.id,
    f.notes,
    p1.plant_key AS female_parent,
    p2.plant_key AS male_parent,
    f.seed_notes,
    f.form_fnmwu,
    f.is_plus,
    f.is_root,
    f.seeds_in_storage,
    f.ploidy_n,
    f.seed_germ_percent,
    f.seed_germ_date,
    f.cross_date,
    t.taxa_key,
    f.web_photos,
    f.web_url
   FROM family f,
    taxa t,
    plant p1,
    plant p2
  WHERE ((f.id_taxa = t.id) AND (f.female_plant_id = p1.id) AND (f.male_plant_id = p2.id));


ALTER TABLE avw_family OWNER TO "user";

--
-- Name: journal; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE journal (
    journal_key character varying(50) DEFAULT '0'::character varying NOT NULL,
    id integer NOT NULL,
    notes character varying DEFAULT '0'::character varying NOT NULL,
    author character varying(50) DEFAULT '0'::character varying NOT NULL,
    id_plant integer NOT NULL,
    id_family integer NOT NULL,
    id_test_spec integer NOT NULL,
    id_site integer NOT NULL,
    date date DEFAULT '1111-11-11'::date NOT NULL,
    web_url character varying DEFAULT '0'::character varying NOT NULL
);


ALTER TABLE journal OWNER TO "user";

--
-- Name: site; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE site (
    site_key character varying(50) NOT NULL,
    id integer NOT NULL,
    location_code character varying(5) NOT NULL,
    name_long character varying DEFAULT '0'::character varying NOT NULL,
    notes character varying DEFAULT '0'::character varying NOT NULL,
    address character varying DEFAULT '0'::character varying NOT NULL,
    loc_lat character varying DEFAULT '0'::character varying NOT NULL,
    loc_long character varying DEFAULT '0'::character varying NOT NULL,
    elevation_ft numeric DEFAULT '0'::numeric NOT NULL,
    aspen_site_index character varying DEFAULT '0'::character varying NOT NULL,
    usda_soil_texture character varying DEFAULT '0'::character varying NOT NULL,
    drainage_class_usda character varying(3) DEFAULT 'U'::character varying NOT NULL,
    mean_annual_precip_in numeric DEFAULT '0'::numeric NOT NULL,
    mean_annual_temp_f numeric DEFAULT '0'::numeric NOT NULL,
    frost_free_period_days numeric DEFAULT '0'::numeric NOT NULL,
    depth_to_water_table_in numeric DEFAULT '0'::numeric NOT NULL,
    usda_map_url character varying DEFAULT '0'::character varying NOT NULL,
    web_url character varying DEFAULT '0'::character varying NOT NULL,
    web_photos character varying DEFAULT '0'::character varying NOT NULL,
    contact character varying DEFAULT '0'::character varying NOT NULL,
    CONSTRAINT site_drainage_class_usda_check CHECK (((drainage_class_usda)::text = ANY ((ARRAY['U'::character varying, 'VPD'::character varying, 'PD'::character varying, 'SPD'::character varying, 'MWD'::character varying, 'WD'::character varying, 'SED'::character varying, 'ED'::character varying])::text[])))
);


ALTER TABLE site OWNER TO "user";

--
-- Name: test_spec; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE test_spec (
    test_spec_key character varying(50) NOT NULL,
    id integer NOT NULL,
    notes character varying DEFAULT '0'::character varying NOT NULL,
    activity_type character varying(5) DEFAULT '0'::character varying NOT NULL,
    test_type character varying(20) DEFAULT '0'::character varying NOT NULL,
    research_hypothesis character varying DEFAULT '0'::character varying NOT NULL,
    null_hypothesis character varying DEFAULT '0'::character varying NOT NULL,
    reject_null_hypothesis character(1) DEFAULT '0'::bpchar,
    web_protocol character varying DEFAULT '0'::character varying NOT NULL,
    web_url character varying DEFAULT '0'::character varying NOT NULL,
    web_photos character varying DEFAULT '0'::character varying NOT NULL,
    test_start_date date DEFAULT '1111-11-11'::date NOT NULL,
    id_site integer NOT NULL,
    CONSTRAINT test_spec_activity_type_check CHECK (((activity_type)::text = ANY ((ARRAY['0'::character varying, 'TRIAL'::character varying, 'EVENT'::character varying])::text[]))),
    CONSTRAINT test_spec_reject_null_hypothesis_check CHECK ((reject_null_hypothesis = ANY (ARRAY['Y'::bpchar, 'N'::bpchar, '0'::bpchar]))),
    CONSTRAINT test_spec_test_type_check CHECK (((test_type)::text = ANY ((ARRAY['0'::character varying, 'nursery'::character varying, 'breeding'::character varying, 'field-planting'::character varying, 'field-trial'::character varying, 'propagation'::character varying])::text[])))
);


ALTER TABLE test_spec OWNER TO "user";

--
-- Name: avw_journal; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avw_journal AS
 SELECT j.journal_key,
    j.id,
    j.notes,
    j.author,
    p.plant_key,
    f.family_key,
    ts.test_spec_key,
    s.site_key,
    j.date,
    j.web_url
   FROM journal j,
    site s,
    plant p,
    family f,
    test_spec ts
  WHERE ((j.id_test_spec = ts.id) AND (j.id_site = s.id) AND (j.id_plant = p.id) AND (j.id_family = f.id));


ALTER TABLE avw_journal OWNER TO "user";

--
-- Name: avw_plant; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avw_plant AS
 SELECT p.plant_key,
    p.id,
    p.notes,
    p.sex_mfbu,
    p.published_botanical_name,
    p.common_name,
    p.alternate_name,
    p.aquired_from,
    p.female_external_parent,
    p.male_external_parent,
    p.form_fnmwu,
    p.is_plus,
    p.is_cultivar,
    p.is_variety,
    p.is_from_wild,
    p.ploidy_n,
    p.date_aquired,
    t.taxa_key,
    f.family_key,
    p.web_photos,
    p.web_url
   FROM plant p,
    taxa t,
    family f
  WHERE ((p.id_taxa = t.id) AND (p.id_family = f.id))
  ORDER BY p.id;


ALTER TABLE avw_plant OWNER TO "user";

--
-- Name: avw_site; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avw_site AS
 SELECT site.site_key,
    site.id,
    site.location_code,
    site.name_long,
    site.notes,
    site.address,
    site.loc_lat,
    site.loc_long,
    site.elevation_ft,
    site.aspen_site_index,
    site.usda_soil_texture,
    site.drainage_class_usda,
    site.mean_annual_precip_in,
    site.mean_annual_temp_f,
    site.frost_free_period_days,
    site.depth_to_water_table_in,
    site.usda_map_url,
    site.web_url,
    site.web_photos,
    site.contact
   FROM site
  ORDER BY site.id;


ALTER TABLE avw_site OWNER TO "user";

--
-- Name: avw_taxa; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avw_taxa AS
 SELECT taxa.taxa_key,
    taxa.id,
    taxa.notes,
    taxa.species,
    taxa.species_hybrid,
    taxa.common_name,
    taxa.binomial_name,
    taxa.kingdom,
    taxa.family,
    taxa.genus,
    taxa.web_photos,
    taxa.web_url
   FROM taxa
  ORDER BY taxa.id;


ALTER TABLE avw_taxa OWNER TO "user";

--
-- Name: test_detail; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE test_detail (
    test_detail_key character varying(50) DEFAULT '0'::character varying NOT NULL,
    id integer NOT NULL,
    notes character varying DEFAULT '0'::character varying NOT NULL,
    notes2 character varying DEFAULT '0'::character varying NOT NULL,
    start_quantity numeric DEFAULT '-1'::numeric NOT NULL,
    end_quantity numeric DEFAULT '-1'::numeric NOT NULL,
    this_start_date date DEFAULT '1111-11-11'::date NOT NULL,
    score_date date DEFAULT '1111-11-11'::date NOT NULL,
    stock_type character(4) DEFAULT 'U'::bpchar NOT NULL,
    stock_length_cm numeric DEFAULT '-1'::numeric NOT NULL,
    stock_dia_mm numeric DEFAULT '-1'::numeric NOT NULL,
    nbr_of_stems integer DEFAULT '-1'::integer NOT NULL,
    is_plus_ynu character(1) DEFAULT '0'::bpchar,
    collar_median_dia_mm numeric DEFAULT '-1'::numeric NOT NULL,
    dbh_circ_cm numeric DEFAULT '-1'::numeric NOT NULL,
    height_cm numeric DEFAULT '-1'::numeric NOT NULL,
    bias_3_3 numeric DEFAULT '-4'::numeric NOT NULL,
    leaf_score integer DEFAULT '-1'::integer NOT NULL,
    canker_score integer DEFAULT '-1'::integer NOT NULL,
    swasp_score integer DEFAULT '-1'::integer NOT NULL,
    id_plant integer NOT NULL,
    id_family integer NOT NULL,
    id_test_spec integer NOT NULL,
    row_nbr numeric DEFAULT '-1'::numeric NOT NULL,
    column_nbr numeric DEFAULT '-1'::numeric NOT NULL,
    replication_nbr integer DEFAULT '-1'::integer NOT NULL,
    plot_nbr integer DEFAULT '-1'::integer NOT NULL,
    block_nbr integer DEFAULT '-1'::integer NOT NULL,
    CONSTRAINT test_detail_bias_3_3_check CHECK (((bias_3_3 < (4)::numeric) AND (bias_3_3 > ('-5'::integer)::numeric))),
    CONSTRAINT test_detail_canker_score_check CHECK ((canker_score < 6)),
    CONSTRAINT test_detail_is_plus_ynu_check CHECK ((is_plus_ynu = ANY (ARRAY['Y'::bpchar, 'N'::bpchar, 'U'::bpchar, '0'::bpchar]))),
    CONSTRAINT test_detail_leaf_score_check CHECK ((leaf_score < 6)),
    CONSTRAINT test_detail_stock_type_check CHECK ((stock_type = ANY (ARRAY['U'::bpchar, 'ASP'::bpchar, 'SASP'::bpchar, 'WASP'::bpchar, 'SCP'::bpchar, 'DC'::bpchar, 'ODC'::bpchar, 'RS'::bpchar, 'SE'::bpchar, 'SEL'::bpchar, '1-0'::bpchar, '1-1'::bpchar, '1-2'::bpchar]))),
    CONSTRAINT test_detail_swasp_score_check CHECK ((swasp_score < 6))
);


ALTER TABLE test_detail OWNER TO "user";

--
-- Name: avw_test_detail; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avw_test_detail AS
 SELECT td.test_detail_key,
    td.id,
    td.notes,
    td.notes2,
    td.start_quantity,
    td.end_quantity,
    td.this_start_date,
    td.score_date,
    td.stock_type,
    td.stock_length_cm,
    td.stock_dia_mm,
    td.nbr_of_stems,
    td.is_plus_ynu,
    td.collar_median_dia_mm,
    td.dbh_circ_cm,
    td.height_cm,
    td.bias_3_3,
    td.leaf_score,
    td.canker_score,
    td.swasp_score,
    p.plant_key,
    f.family_key,
    ts.test_spec_key,
    td.row_nbr,
    td.column_nbr,
    td.replication_nbr,
    td.plot_nbr,
    td.block_nbr
   FROM test_detail td,
    test_spec ts,
    family f,
    plant p
  WHERE ((td.id_test_spec = ts.id) AND (td.id_plant = p.id) AND (td.id_family = f.id));


ALTER TABLE avw_test_detail OWNER TO "user";

--
-- Name: avw_test_spec; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avw_test_spec AS
 SELECT ts.test_spec_key,
    ts.id,
    ts.notes,
    ts.activity_type,
    ts.test_type,
    ts.research_hypothesis,
    ts.null_hypothesis,
    ts.reject_null_hypothesis,
    ts.web_protocol,
    ts.web_url,
    ts.web_photos,
    ts.test_start_date,
    s.site_key
   FROM test_spec ts,
    site s
  WHERE (ts.id_site = s.id);


ALTER TABLE avw_test_spec OWNER TO "user";

--
-- Name: family_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE family_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE family_id_seq OWNER TO "user";

--
-- Name: family_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE family_id_seq OWNED BY family.id;


--
-- Name: journal_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE journal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE journal_id_seq OWNER TO "user";

--
-- Name: journal_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE journal_id_seq OWNED BY journal.id;


--
-- Name: pedigree; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE pedigree (
    id integer NOT NULL,
    pedigree_key character varying NOT NULL,
    path character varying NOT NULL
);


ALTER TABLE pedigree OWNER TO "user";

--
-- Name: pedigree_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE pedigree_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE pedigree_id_seq OWNER TO "user";

--
-- Name: pedigree_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE pedigree_id_seq OWNED BY pedigree.id;


--
-- Name: plant_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE plant_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE plant_id_seq OWNER TO "user";

--
-- Name: plant_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE plant_id_seq OWNED BY plant.id;


--
-- Name: site_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE site_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE site_id_seq OWNER TO "user";

--
-- Name: site_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE site_id_seq OWNED BY site.id;


--
-- Name: taxa_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE taxa_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE taxa_id_seq OWNER TO "user";

--
-- Name: taxa_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE taxa_id_seq OWNED BY taxa.id;


--
-- Name: test_detail_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE test_detail_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE test_detail_id_seq OWNER TO "user";

--
-- Name: test_detail_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE test_detail_id_seq OWNED BY test_detail.id;


--
-- Name: test_spec_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE test_spec_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE test_spec_id_seq OWNER TO "user";

--
-- Name: test_spec_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE test_spec_id_seq OWNED BY test_spec.id;


--
-- Name: vw1_master_test_detail; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw1_master_test_detail AS
 SELECT td.test_detail_key,
    td.id,
    td.notes,
    td.notes2,
    td.stock_type,
    td.start_quantity,
    td.end_quantity,
    td.dbh_circ_cm,
    td.height_cm,
    td.stock_length_cm,
    td.collar_median_dia_mm,
    trunc((td.end_quantity / td.start_quantity), 3) AS survival_rate,
    (trunc((td.end_quantity / td.start_quantity), 3) * td.collar_median_dia_mm) AS vigor_survival,
    td.is_plus_ynu,
        CASE
            WHEN (td.is_plus_ynu = 'Y'::bpchar) THEN 1
            ELSE 0
        END AS is_plus_tree,
    td.bias_3_3,
    ts.test_spec_key,
    ts.test_type,
    td.row_nbr,
    td.column_nbr,
    td.replication_nbr,
    date_part('isoyear'::text, td.this_start_date) AS year
   FROM test_detail td,
    test_spec ts
  WHERE ((lower((td.notes)::text) !~~ lower('%willow%'::text)) AND (td.id_test_spec = ts.id))
  ORDER BY (trunc((td.end_quantity / td.start_quantity), 3) * td.collar_median_dia_mm) DESC;


ALTER TABLE vw1_master_test_detail OWNER TO "user";

--
-- Name: vw2_nursery_stocktype_test_detail; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw2_nursery_stocktype_test_detail AS
 SELECT vw1_master_test_detail.test_detail_key,
    vw1_master_test_detail.stock_type,
    count(vw1_master_test_detail.replication_nbr) AS nbr_of_replications,
    sum(vw1_master_test_detail.end_quantity) AS sum_of_end_qty,
    sum(vw1_master_test_detail.is_plus_tree) AS sum_of_plus_trees,
    count(DISTINCT vw1_master_test_detail.year) AS nbr_of_years,
    trunc(avg(vw1_master_test_detail.survival_rate), 3) AS avg_survival_rate,
    trunc(avg(vw1_master_test_detail.height_cm), 3) AS avg_heigth_cm,
    trunc(avg(vw1_master_test_detail.collar_median_dia_mm), 3) AS avg_collar_median_dia_mm,
        CASE
            WHEN (trunc(avg(vw1_master_test_detail.vigor_survival), 3) > (0)::numeric) THEN trunc(avg(vw1_master_test_detail.vigor_survival), 3)
            ELSE (0)::numeric
        END AS avg_vigor_survival,
    (trunc(avg(vw1_master_test_detail.vigor_survival), 3) + (sum(vw1_master_test_detail.is_plus_tree))::numeric) AS vigorsurvival_plus_plustrees
   FROM vw1_master_test_detail
  WHERE ((vw1_master_test_detail.test_type)::text = 'nursery'::text)
  GROUP BY vw1_master_test_detail.test_detail_key, vw1_master_test_detail.stock_type
  ORDER BY (trunc(avg(vw1_master_test_detail.vigor_survival), 3) + (sum(vw1_master_test_detail.is_plus_tree))::numeric) DESC;


ALTER TABLE vw2_nursery_stocktype_test_detail OWNER TO "user";

--
-- Name: vw3_nursery_summary_test_detail; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw3_nursery_summary_test_detail AS
 SELECT vw1_master_test_detail.test_detail_key,
    count(vw1_master_test_detail.replication_nbr) AS nbr_of_replications,
    count(DISTINCT vw1_master_test_detail.stock_type) AS nbr_of_stock_types,
    count(DISTINCT vw1_master_test_detail.year) AS nbr_of_years,
    sum(vw1_master_test_detail.start_quantity) AS sum_of_start_qty,
    sum(vw1_master_test_detail.end_quantity) AS sum_of_end_qty,
    sum(vw1_master_test_detail.is_plus_tree) AS sum_of_plus_trees,
    trunc(avg(vw1_master_test_detail.survival_rate), 3) AS avg_survival_rate,
    trunc(avg(vw1_master_test_detail.height_cm), 3) AS avg_heigth_cm,
    trunc(avg(vw1_master_test_detail.collar_median_dia_mm), 3) AS avg_collar_median_dia_mm,
        CASE
            WHEN (trunc(avg(vw1_master_test_detail.vigor_survival), 3) > (0)::numeric) THEN trunc(avg(vw1_master_test_detail.vigor_survival), 3)
            ELSE (0)::numeric
        END AS avg_vigor_survival,
    (trunc(avg(vw1_master_test_detail.vigor_survival), 3) + (sum(vw1_master_test_detail.is_plus_tree))::numeric) AS vigorsurvival_plus_plustrees
   FROM vw1_master_test_detail
  WHERE ((vw1_master_test_detail.test_type)::text = 'nursery'::text)
  GROUP BY vw1_master_test_detail.test_detail_key
  ORDER BY
        CASE
            WHEN (trunc(avg(vw1_master_test_detail.vigor_survival), 3) > (0)::numeric) THEN trunc(avg(vw1_master_test_detail.vigor_survival), 3)
            ELSE (0)::numeric
        END DESC;


ALTER TABLE vw3_nursery_summary_test_detail OWNER TO "user";

--
-- Name: vw_trials; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw_trials AS
 SELECT tsp.test_spec_key,
    tsp.id AS test_spec_id,
    tsp.research_hypothesis,
    tsp.reject_null_hypothesis,
    tsp.activity_type,
    s.site_key,
    s.notes AS site_notes,
    s.drainage_class_usda,
    td.test_detail_key,
    td.id AS test_detail_id,
    td.notes AS test_detail_notes,
    td.start_quantity,
    td.this_start_date AS test_start_date,
    td.score_date,
    td.end_quantity,
    trunc((td.end_quantity / td.start_quantity), 3) AS survival_rate,
    td.stock_type,
    td.stock_length_cm,
    td.stock_dia_mm,
    td.dbh_circ_cm,
    p.plant_key,
    p.id AS plant_id,
    f.family_key,
    f.id AS family_id,
    td.row_nbr,
    td.column_nbr,
    td.replication_nbr,
    td.plot_nbr,
    td.block_nbr
   FROM site s,
    test_spec tsp,
    plant p,
    family f,
    test_detail td
  WHERE ((tsp.id_site = s.id) AND (td.id_test_spec = tsp.id) AND (td.id_plant = p.id) AND (td.id_family = f.id) AND ((tsp.activity_type)::text = 'TRIAL'::text))
  ORDER BY tsp.test_spec_key, td.this_start_date;


ALTER TABLE vw_trials OWNER TO "user";

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY family ALTER COLUMN id SET DEFAULT nextval('family_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY journal ALTER COLUMN id SET DEFAULT nextval('journal_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY pedigree ALTER COLUMN id SET DEFAULT nextval('pedigree_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY plant ALTER COLUMN id SET DEFAULT nextval('plant_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY site ALTER COLUMN id SET DEFAULT nextval('site_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY taxa ALTER COLUMN id SET DEFAULT nextval('taxa_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY test_detail ALTER COLUMN id SET DEFAULT nextval('test_detail_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY test_spec ALTER COLUMN id SET DEFAULT nextval('test_spec_id_seq'::regclass);


--
-- Data for Name: family; Type: TABLE DATA; Schema: public; Owner: user
--

COPY family (family_key, id, notes, female_plant_id, male_plant_id, seed_notes, form_fnmwu, is_plus, is_root, seeds_in_storage, ploidy_n, seed_germ_percent, seed_germ_date, cross_date, id_taxa, web_photos, web_url) FROM stdin;
TBD	1	To Be Determined	1	1	0	U	U	0	-1	-1	-1	1111-11-11	1111-11-11	2	0	0
NA	2	Does Not Apply	1	1	0	U	U	0	-1	-1	-1	1111-11-11	1111-11-11	2	0	0
17XGA04	33	Family notes here.	48	35	0	U	N	0	0	2	-1	1111-11-11	2004-04-01	7	0	0
18XAG04	34	Family notes here.	34	49	0	U	N	0	0	2	-1	1111-11-11	2004-04-01	6	0	0
21XAAG91	58	Family notes here.	41	56	0	U	N	0	0	2	-1	1111-11-11	1991-04-01	2	0	0
53XAA92	102	Family notes here.	27	24	0	U	N	0	0	2	-1	1111-11-11	1992-04-01	3	0	0
68XAA93	120	Family notes here.	27	14	0	U	N	0	0	2	-1	1111-11-11	1993-04-01	3	0	0
69XAA93	121	Family notes here.	27	13	0	U	N	0	0	2	-1	1111-11-11	1993-04-01	3	0	0
70XAA93	123	Family notes here.	27	15	0	U	N	0	0	2	-1	1111-11-11	1993-04-01	3	0	0
71XAA93	124	Family notes here.	27	16	0	U	N	0	0	2	-1	1111-11-11	1993-04-01	3	0	0
72XAA93	125	Family notes here.	27	17	0	U	N	0	0	2	-1	1111-11-11	1993-04-01	3	0	0
73XAA93	126	Family notes here.	27	19	0	U	N	0	0	2	-1	1111-11-11	1993-04-01	3	0	0
76XAA02	129	Family notes here.	11	33	0	U	N	0	0	2	-1	1111-11-11	2002-04-01	3	0	0
77XAA02	130	Family notes here.	34	33	0	U	N	0	0	2	-1	1111-11-11	2002-04-01	3	0	0
78XAA02	131	Family notes here.	43	33	0	U	N	0	0	2	-1	1111-11-11	2002-04-01	3	0	0
79XAA03	132	Family notes here.	11	35	0	U	N	0	0	2	-1	1111-11-11	2003-04-01	3	0	0
80XAA04	137	Family notes here.	46	35	0	U	N	0	0	2	-1	1111-11-11	2004-04-01	3	0	0
81XAA04	138	Family notes here.	41	35	0	U	N	0	0	2	-1	1111-11-11	2004-04-01	3	0	0
82XAA04	139	Family notes here.	44	35	0	U	Y	0	0	2	-1	1111-11-11	2004-04-01	3	0	0
83XAA04	140	Family notes here.	11	35	0	U	Y	0	0	2	-1	1111-11-11	2004-04-01	3	0	0
84XAA04	141	Family notes here.	47	35	0	U	Y	0	0	2	-1	1111-11-11	2004-04-01	3	0	0
85XAA04	142	Family notes here.	34	35	0	U	N	0	0	2	-1	1111-11-11	2004-04-01	3	0	0
92XAA10	152	Family notes here.	138	133	0	U	N	0	0	2	0.77	2010-06-02	2010-04-01	3	0	0
89XAA10	153	Family notes here.	138	8	0	U	N	0	0	2	0.71	2010-06-02	2010-04-01	3	0	0
91XAA10	154	Family notes here.	138	19	0	U	N	0	0	2	0.43	2010-06-02	2010-04-01	3	0	0
98XAA10	155	Family notes here.	141	144	0	U	N	0	0	2	0.34	2010-06-02	2010-04-01	3	0	0
101XAA10	156	Family notes here.	141	19	0	U	N	0	0	2	0.07	2010-06-02	2010-04-01	3	0	0
99XAA10	157	Family notes here.	141	35	0	U	N	0	0	2	0.5	2010-06-02	2010-04-01	3	0	0
100XAA10	158	Family notes here.	141	143	0	U	N	0	0	2	0.28	2010-06-02	2010-04-01	3	0	0
97XAA10	159	Family notes here.	142	19	0	U	N	0	0	2	0.53	2010-06-02	2010-04-01	3	0	0
96XAA10	160	Family notes here.	142	133	0	U	N	0	0	2	0.39	2010-06-02	2010-04-01	3	0	0
94XAA10	161	Family notes here.	142	8	0	U	N	0	0	2	0.71	2010-06-02	2010-04-01	3	0	0
95XAA10	162	Family notes here.	140	133	0	U	N	0	0	2	0.28	2010-06-02	2010-04-01	3	0	0
88XAA10	163	Family notes here.	140	8	0	U	N	0	0	2	0.89	2010-06-02	2010-04-01	3	0	0
87XAA10	164	Family notes here.	140	35	0	U	N	0	0	2	0.21	2010-06-02	2010-04-01	3	0	0
90XAA10	165	Family notes here.	140	19	0	U	N	0	0	2	0.86	2010-06-02	2010-04-01	3	0	0
93XAA10	166	Family notes here.	11	35	0	U	Y	0	0	2	0.71	2010-06-02	2010-04-01	3	0	0
102XAA10	168	Family notes here.	134	19	0	U	N	0	0	2	0.05	2010-06-02	2010-04-01	3	0	0
104XAA10	169	Family notes here.	134	144	0	U	N	0	0	2	0.45	2010-06-02	2010-04-01	3	0	0
103XAA10	170	Family notes here.	139	19	0	U	N	0	0	2	0.51	2010-06-02	2010-04-01	3	0	0
1XCAGW	171	Family notes here.	66	163	Fair to good, very heavy seed set for OP.	U	U	0	1000	2	-1	1111-11-11	1111-11-11	2	0	0
1XAW	172	Family notes here.	162	163	poor	U	U	0	0	2	0.5	1111-11-11	1111-11-11	2	0	0
2xB	173	Family notes here.	179	26	C173 had Fair to good seed set but seed had to be manually pulled.   I sampled 188 seeds planted on 4/4 and counted 120 viable seedlings.  Estimated germination after 4 days is 64%. 	U	U	Y	500	2	0.64	2012-04-05	2012-03-03	13	0	0
2XGW	175	Family notes here.	201	163	Poor bigtooth germination - perhaps related to the sparse seedset of the catkins (few of males in the area).	U	U	0	500	2	0.1	2013-06-01	2013-05-04	2	0	0
3XGW	176	Family notes here.	202	163	Poor bigtooth germination - perhaps related to the sparse seedset of the catkins (few of males in the area).  All seedlings failed in 2013 via short 288 cell flats at Bell.	U	U	0	500	2	0.05	2013-06-01	2013-05-24	2	0	0
5XGW	177	Family notes here.	203	163	Best bigtooth germination - perhaps related to the full seedset of the catkins (lots of males in the area).	U	U	0	2000	2	0.9	2013-06-01	2013-05-24	2	0	0
2xRR	178	Family notes here.	199	61	Seedlings had a 48/100 useable count - ranking sixth out of the 6 crosses.  They started very slow!	U	U	0	500	2	0.63	2013-05-10	2012-04-20	2	0	0
22xAR	179	Family notes here.	204	61	Seedlings had a 61/100 useable count - ranking fith out of the 6 crosses.	U	U	0	500	2	0.77	2013-05-10	2012-04-20	2	0	0
105xAA	182	Family notes here.	204	19	Seedlings had a 65/100 useable count - ranking third out of the 6 crosses.	U	U	0	500	2	0.7	2013-05-10	2012-04-20	3	0	0
106xAA	183	Parents: 83AA565 x NFA, Progeny expectations: VDRF, Priority: High. 83AA565 may have VRF, and flowered at 5yrs.	205	19	Fair	U	U	0	1000	2	0.33	2014-06-02	2014-05-12	3	TBD	0
107xAA	184	Parents: 30AA5MF x 80AA3MF, Progeny expectations: VDRF, Priority: H.  The female flowers were small and weak - bad branches?	141	182	Good. 2014 batch had small green seeds.	U	U	U	400	2	0.61	2014-06-02	2014-05-12	3	TBD	0
13xGB	188	Parents: gg102 x CAG177, Progeny expectations: VDRF, Priority: Med.  Compare with the U07m GAs with gg102 that did poorly.	48	65	fair	U	U	U	500	2	0.31	2014-06-02	2014-05-12	2	TBD	0
15xB	190	Parents: C173 x 9AG105, Progeny expectations: VDRF, Priority: Med. Compare to 3xRR, 9xBr, 5xRB	179	200	good	U	U	U	1200	2	0.24	2014-06-02	2014-05-12	15	TBD	0
16xAB	191	Parents: 83AA565 x CAG177, Progeny expectations: VDRF, Priority: High. 83AA565 may have VRF, and flowered at 5yrs.	205	65	fair	U	U	U	700	2	0.35	2014-06-02	2014-05-12	2	TBD	0
17xB	192	Parents: Plaza x 4AE1, Progeny expectations: VDRF, Priority: High.  This B is unrelated to CAG204 or CAG177. Planted 10 seedlings from Rakers.	207	213	very poor, did not seem viable. 	U	U	U	0	2	0.09	2014-06-02	2014-05-12	15	TBD	0
1xBAR	195	Parents: CAG204 x AAG2001, Progeny expectations: VDR, Priority: High.  AAG2001 is a vigorous & variable hybrid with Crandon and A266 parentage.	66	42	poor	U	U	U	0	2	0	2014-06-02	2014-05-12	2	TBD	0
20xBS	196	Parents: CAG204 x 4TG1, Progeny expectations: VDRF, Priority: High.  4TG1 is the best McGovern smithii 	66	214	good	U	U	U	200	2	0.87	2014-06-02	2014-05-12	2	TBD	0
21xBA	197	Parents: CAG204 x 80AA3MF, Progeny expectations: VDRF, Priority: High.  80AA3MF is vigorous but a poor rooter	66	182	poor	U	U	U	0	2	0.27	2014-06-02	2014-05-12	2	TBD	0
86XAA10	167	Family notes here.	11	19	0	U	N	Y	0	2	0.78	2010-06-02	2010-04-01	3	0	0
23xBA	199	Parents: CAG204 x 82AA3, Progeny expectations: VDRF, Priority: High.  82AA3 is PMGs alba from his GR sites.	66	208	fair	U	U	U	1100	2	0.61	2014-06-02	2014-05-12	2	TBD	0
3xRR	200	Parents: Plaza x 9AG105, Progeny expectations: VDRF, Priority: High. How will RR families compare to B families?	207	200	fair	U	U	U	0	2	0.1	2014-06-02	2014-05-12	2	TBD	0
4xGW	201	Parents: gg102 x Wind, Progeny Expectations: ?.  Priority: High. Seed produced late in 2013, but did not send to Rakers until 2014.  Most are GA types (from RNE), from 2013. Compare to low performing GA/AGs. 	48	163	poor	U	U	U	300	2	0.34	2014-06-02	2014-05-12	2	TBD	0
5xRB	203	Parents: 9AG105 x CAG177, Progeny Expectations: VDRF, Priority: High.  9AG105 is bisexual, compare to reciprocal 9xBR.	200	65	fair 	U	U	U	300	2	0.35	2014-06-02	2014-05-12	2	TBD	0
8xBG	206	Parents: CAG204 x gg101, Progeny Expectations: VDRF, Priority: Med.  Compare to AGs with gg101 that did poorly in U07M 	66	49	fair	U	U	U	1200	2	0.37	2014-06-02	2014-05-12	2	TBD	0
9xBR	207	Parents: CAG204 x 9AG105, Progeny Expectations: VDRF, Priority: High.  9AG105 is bisexual, compare to 5xRB	66	200	fair 	U	U	U	0	2	0.04	2014-06-02	2014-05-12	2	TBD	0
7xBT	205	Parents: CAG204 x ST11, Progeny Expectations: VDRF, Priority: Med.  Compare to BG families.	66	209	good	U	U	Y	200	2	0.88	2014-06-02	2014-05-12	2	TBD	0
6xBA	204	Parents: CAG204 x NFA, Progeny Expectations: VDR, Priority: Med. NFA is vigorous but in many crosses	66	19	fair	U	U	Y	300	2	0.41	2014-06-02	2014-05-12	2	TBD	0
4xRR	202	Parents: Plaza x AGRR1, Progeny Expectations: VDRFG, Priority: High.  How will RR families compare to B families?	207	61	poor	U	U	Y	600	2	0.06	2014-06-02	2014-05-12	2	TBD	0
22xBG	198	Parents: CAG204 x G4, Progeny expectations: VDRF, Priority: Med. G4 has good form, many flowers.	66	210	good	U	U	Y	800	2	0.76	2014-06-02	2014-05-12	2	TBD	0
19xGB	194	Parents: G5 x CAG177, Progeny expectations: VDRFG, Priority: High. G5 may have  Figured Wood.	211	65	poor	U	U	Y	0	2	0.33	2014-06-02	2014-05-12	2	TBD	0
18xBG	193	Parents: CAG204 x G6, Progeny expectations: VDRFG, Priority: High.  G6 has Figured Wood from UP Michigan.	66	212	good	U	U	Y	1300	2	0.38	2014-06-02	2014-05-12	2	TBD	0
14xB	189	Parents: C173 x AGRR1, Progeny expectations: VDRFG, Priority: High. AGRR1 has low figured wood but good veneer peeling qualities.	179	61	good	U	U	Y	500	2	0.63	2014-06-02	2014-05-12	15	TBD	0
12xRB	187	Parents: Plaza x CAG177. Progeny expectations: VDRF. Priority: Med. Compare to 3xRR.	207	65	fair	U	U	Y	300	2	0.8	2014-06-02	2014-05-12	2	TBD	0
11xAB	186	Parents: A266 x CAG177, A266 female is vigorous, CAG177 male has good form/rooting.  Progeny expectations: VDR, Priority: High.	9	65	fair 	U	U	Y	0	2	0.67	2014-06-02	2014-05-12	2	TBD	0
10xBR	185	Parents: CAG204 x AGRR1, Progeny expectations: VDRFG, Priority: High, (may have figured progeny). 	66	61	Fair. Seed not sent to Rakers in 2014,since its the same cross as 5xCAGR.	U	U	Y	200	2	0	2014-06-02	2014-05-12	2	TBD	0
5xCAGR	181	Family notes here.	66	61	Seedlings had a 81/100 useable count - ranking second out of the 6 crosses.	U	U	Y	500	2	0.85	2013-05-10	2012-04-20	2	0	0
4xACAG	180	Family notes here.	11	65	Seedlings had a 64/100 useable count - ranking fourth out of the 6 crosses.	U	U	Y	500	2	0.7	2013-05-10	2012-04-20	2	0	0
3XCAGC	174	Family notes here.	66	63	Seedlings had a 87/100 useable count - ranking first out of the 6 crosses. 3xCAGC seedlings had the best 2013 seedling quality at Rakers. 	U	U	Y	500	2	0.92	2013-05-10	2012-04-20	2	0	0
2XAAE06	151	Family notes here.	11	1	0	U	N	Y	0	2	-1	1111-11-11	2006-04-01	2	0	0
1XAAE05	150	Family notes here.	11	1	0	U	N	Y	0	2	-1	1111-11-11	2005-04-01	2	0	0
9XTG93	149	Family notes here.	149	60	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	5	0	0
9XAGA91	148	Family notes here.	57	7	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
9XAG91	147	Family notes here.	30	50	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	6	0	0
9XAA90	146	Family notes here.	9	5	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	3	0	0
8XAGA91	145	Family notes here.	57	64	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
8XAG91	144	Family notes here.	11	60	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	6	0	0
8XAA90	143	Family notes here.	9	7	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	3	0	0
7XTG93	136	Family notes here.	74	60	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	5	0	0
7XGA91	135	Family notes here.	51	23	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	7	0	0
7XAGA91	134	Family notes here.	57	21	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
7XAA90	133	Family notes here.	9	8	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	3	0	0
75XAA95	128	Family notes here.	9	23	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
74XAA95	127	Family notes here.	25	23	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
6XAA89	122	Family notes here.	9	5	0	U	N	Y	0	2	-1	1111-11-11	1989-04-01	3	0	0
67XAA93	119	Family notes here.	11	19	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
66XAA93	118	Family notes here.	11	18	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
65XAA93	117	Family notes here.	11	17	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
64XAA93	116	Family notes here.	11	16	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
63XAA93	115	Family notes here.	11	15	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
62XAA93	114	Family notes here.	11	13	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
61XAA93	113	Family notes here.	11	14	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
60XAA93	112	Family notes here.	9	19	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
5XTG93	111	Family notes here.	67	60	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	5	0	0
5XAE91	110	Family notes here.	30	73	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	9	0	0
5XAA89	109	Family notes here.	11	23	0	U	N	Y	0	2	-1	1111-11-11	1989-04-01	3	0	0
59XAA93	108	Family notes here.	9	18	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
58XAA93	107	Family notes here.	9	17	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
57XAA93	106	Family notes here.	9	16	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
56XAA93	105	Family notes here.	9	15	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
55XAA93	104	Family notes here.	9	13	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
54XAA93	103	Family notes here.	9	14	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	3	0	0
50XAA92	101	Family notes here.	29	24	0	U	N	Y	0	2	-1	1111-11-11	1992-04-01	3	0	0
4XTG91	100	Family notes here.	67	50	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	5	0	0
4XAGA90	99	Family notes here.	1	5	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	2	0	0
4XAG90	98	Family notes here.	20	52	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	6	0	0
4XAE91	97	Family notes here.	4	73	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	9	0	0
4XAA89	96	Family notes here.	1	23	0	U	N	Y	0	2	-1	1111-11-11	1989-04-01	3	0	0
47XAA92	95	Family notes here.	12	24	0	U	N	Y	0	2	-1	1111-11-11	1992-04-01	3	0	0
46XAA92	94	Family notes here.	9	23	0	U	N	Y	0	2	-1	1111-11-11	1992-04-01	3	0	0
45XAA92	93	Family notes here.	9	1	0	U	N	Y	0	2	-1	1111-11-11	1992-04-01	3	0	0
44XAA92	92	Family notes here.	9	1	0	U	N	Y	0	2	-1	1111-11-11	1992-04-01	3	0	0
43XAA92	91	Family notes here.	9	24	0	U	N	Y	0	2	-1	1111-11-11	1992-04-01	3	0	0
42XAA91	90	Family notes here.	2	2	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
41XAA91	88	Family notes here.	4	3	0	U	Y	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
40XAA91	87	Family notes here.	4	6	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
3XTG90	86	Family notes here.	69	53	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	5	0	0
3XAGA90	85	Family notes here.	56	7	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	2	0	0
3XAG90	84	Family notes here.	29	52	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	6	0	0
3XAA89	83	Family notes here.	4	23	0	U	N	Y	0	2	-1	1111-11-11	1989-04-01	3	0	0
39XAA91	82	Family notes here.	30	10	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
36XAA91	81	Family notes here.	11	21	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
35XAA91	80	Family notes here.	30	23	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
33XAA91	79	Family notes here.	4	23	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
32XAA91	78	Family notes here.	9	7	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
31XAA91	77	Family notes here.	9	64	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
30XAA91	76	Family notes here.	30	6	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
2XTG90	75	Family notes here.	67	52	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	5	0	0
2XT4E04	74	Family notes here.	45	40	0	U	N	Y	0	3	-1	1111-11-11	2004-04-01	2	0	0
2XGT91	73	Family notes here.	51	68	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	4	0	0
2XGAG91	72	Family notes here.	59	1	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
2XGAE91	71	Family notes here.	59	73	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
2XGA88	70	Family notes here.	1	23	0	U	N	Y	0	2	-1	1111-11-11	1988-04-01	7	0	0
2XAGA90	69	Family notes here.	56	5	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	2	0	0
2XAG90	68	Family notes here.	9	52	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	6	0	0
2XAAG88	67	Family notes here.	9	60	0	U	N	Y	0	2	-1	1111-11-11	1988-04-01	2	0	0
2XAA88	66	Family notes here.	9	23	0	U	N	Y	0	2	-1	1111-11-11	1988-04-01	3	0	0
29XAA91	65	Family notes here.	9	10	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
28XAA91	64	Family notes here.	9	3	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
27XAA91	63	Family notes here.	4	7	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
26XAA91	62	Family notes here.	30	3	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
25XAA91	61	Family notes here.	9	28	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
23XAA91	60	Family notes here.	30	7	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
22XAA91	59	Family notes here.	11	7	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
21XAA91	57	Family notes here.	11	3	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
20XAAG91	56	Family notes here.	9	56	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
20XAA91	55	Family notes here.	9	21	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
1XTT91	54	Family notes here.	67	68	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
1XTG90	53	Family notes here.	67	53	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	5	0	0
1XTE04	52	Family notes here.	45	1	0	U	N	Y	0	2	-1	1111-11-11	2004-04-01	2	0	0
1XT4E04	51	Family notes here.	75	40	0	U	N	Y	0	3	-1	1111-11-11	2004-04-01	2	0	0
1XGT90	50	Family notes here.	54	70	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	4	0	0
1XGG91	49	Family notes here.	51	50	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
1XGE91	48	Family notes here.	51	73	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
1XGAG91	47	Family notes here.	51	60	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
1XGAAG91	46	Family notes here.	59	60	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
1XGA84	45	Family notes here.	1	23	0	U	N	Y	0	2	-1	1111-11-11	1984-04-01	7	0	0
1XEE91	44	Family notes here.	72	73	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
1XAT90	43	Family notes here.	7	70	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	9	0	0
1XAGE91	42	Family notes here.	57	73	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
1XAGC91	41	Family notes here.	56	64	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
1XAGA88	40	Family notes here.	57	23	0	U	N	Y	0	2	-1	1111-11-11	1988-04-01	2	0	0
1XAG88	39	Family notes here.	9	52	0	U	N	Y	0	2	-1	1111-11-11	1988-04-01	6	0	0
1XAE91	38	Family notes here.	9	73	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	9	0	0
1XAC91	37	Family notes here.	4	64	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
1XAAG88	36	Family notes here.	9	56	0	U	N	Y	0	2	-1	1111-11-11	1988-04-01	2	0	0
19XAAG91	35	Family notes here.	30	60	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
17XAAG91	32	Family notes here.	4	60	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
17XAA91	31	Family notes here.	4	21	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
16XAG93	30	Family notes here.	11	55	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	6	0	0
16XAAG91	29	Family notes here.	11	60	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
16XAA91	28	Family notes here.	4	10	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	3	0	0
15XTG93	27	Family notes here.	152	60	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	5	0	0
15XAGA91	26	Family notes here.	57	23	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
15XAG91	25	Family notes here.	4	50	0	U	Y	Y	0	2	-1	1111-11-11	1991-04-01	6	0	0
15XAA90	24	Family notes here.	20	7	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	3	0	0
14XTG93	23	Family notes here.	151	55	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	5	0	0
14XGAA91	22	Family notes here.	59	23	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
14XAG91	21	Family notes here.	4	1	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	6	0	0
14XAA90	20	Family notes here.	20	5	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	3	0	0
13XTG93	19	Family notes here.	151	60	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	5	0	0
13XGAG91	18	Family notes here.	59	60	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
13XAG91	17	Family notes here.	4	1	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	6	0	0
13XAA90	16	Family notes here.	29	7	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	3	0	0
12XTG93	15	Family notes here.	150	55	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	5	0	0
12XGAA91	14	Family notes here.	59	7	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
12XAG91	13	Family notes here.	9	60	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	6	0	0
12XAA90	12	Family notes here.	29	8	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	3	0	0
11XTG93	11	Family notes here.	150	60	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	5	0	0
11XAAG91	10	Family notes here.	9	60	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	2	0	0
11XAA90	9	Family notes here.	39	7	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	3	0	0
10XTG93	8	Family notes here.	149	50	0	U	N	Y	0	2	-1	1111-11-11	1993-04-01	5	0	0
10XGA91	7	Family notes here.	51	21	0	U	N	Y	0	2	-1	1111-11-11	1991-04-01	7	0	0
2XA4E05	6	Family notes here.	9	40	0	U	N	Y	0	3	-1	1111-11-11	2005-04-01	2	0	0
1XA4E05	5	Family notes here.	11	40	0	U	N	Y	0	3	-1	1111-11-11	2005-04-01	9	0	0
10XAA91	4	Family notes here.	39	5	0	U	N	Y	0	2	-1	1111-11-11	1990-04-01	3	0	0
1XAA85	3	Family notes here.	9	23	0	W	N	Y	0	2	-1	1111-11-11	1111-11-11	3	0	0
\.


--
-- Name: family_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('family_id_seq', 1, false);


--
-- Data for Name: journal; Type: TABLE DATA; Schema: public; Owner: user
--

COPY journal (journal_key, id, notes, author, id_plant, id_family, id_test_spec, id_site, date, web_url) FROM stdin;
TBD	1	To Be Determined	0	2	2	2	2	1111-11-11	0
NA	2	Does Not Apply	0	2	2	2	2	1111-11-11	0
2012-bell-nursery	3	Journal notes here.	MBP	2	2	14	2	2012-04-06	0
2012-bell-nursery	4	Journal notes here.	MBP	2	2	14	2	2012-05-30	0
2011-RNE-AlbaPolePlanting	5	Journal notes here.	MBP	2	2	17	2	2011-11-05	0
2011-RNE-AlbaPolePlanting	6	Journal notes here.	MBP	2	2	17	2	2012-04-21	0
2011-RNE-AlbaPolePlanting	7	Journal notes here.	MBP	2	2	17	2	2012-06-23	0
2011-1xCAGW-Cross	8	Journal notes here.	MBP	2	2	16	2	2012-06-23	0
2012-2xCAG12-Cross	9	Journal notes here.	MBP	2	2	15	2	2012-06-28	0
1CAGW01	10	Journal notes here.	MBP	181	171	14	2	2012-06-28	0
2012-2xCAG12-Cross	11	Journal notes here.	MBP	2	173	15	2	2012-08-28	0
2012-bell-nursery	12	Journal notes here.	MBP	2	2	14	2	2012-09-03	0
RevisedExternalPlant-IDs	13	Journal notes here.	MBP	182	2	2	8	2012-09-03	0
2011-1xCAGW-Cross	14	Journal notes here.	MBP	2	2	16	2	2012-09-15	0
2012-2xCAG12-Cross	15	Journal notes here.	MBP	2	2	15	2	2012-09-15	0
2012-bell-nursery	16	Journal notes here.	MBP	2	2	14	2	2012-10-08	0
2012-field	17	Journal notes here.	MBP	2	2	2	2	2012-10-08	0
2012-bell-nursery	18	Journal notes here.	MBP	2	2	14	2	2012-11-23	0
WASP-2013-A	19	Journal notes here.	MBP	193	2	18	6	2013-02-01	0
2013-breeding-observations	20	Journal notes here.	MBP	2	2	19	6	2013-03-19	0
ASP-2013-D	21	Journal notes here.	MBP	1	1	1	1	2013-03-26	0
2013-breeding-observations	22	Journal notes here.	MBP	1	1	1	1	2013-03-26	0
2013-breeding-observations	23	Journal notes here.	MBP	1	1	1	1	2013-04-12	0
2013-breeding-observations	24	Journal notes here.	MBP	1	1	1	1	2013-04-13	0
2013-field	25	Journal notes here.	MBP	1	1	1	1	2013-04-13	0
2013-breeding-observations	26	Journal notes here.	MBP	1	1	1	1	2013-04-17	0
2013-breeding-observations	27	Journal notes here.	MBP	1	1	1	1	2013-04-20	0
2013-breeding-observations	28	Journal notes here.	MBP	1	1	1	1	2013-04-27	0
2013-breeding-observations	29	Journal notes here.	MBP	1	1	1	1	2013-05-11	0
2013-breeding-observations	30	Journal notes here.	MBP	1	1	1	1	2013-05-14	0
2013-breeding-observations	31	Journal notes here.	MBP	1	1	1	1	2013-05-15	0
2013-breeding-observations	32	Journal notes here.	MBP	1	1	1	1	2013-05-18	0
2013-field	33	Journal notes here.	MBP	1	1	1	1	2013-05-22	0
2013-breeding-observations	34	Journal notes here.	MBP	1	1	1	1	2013-05-23	0
2013-bell-nursery	35	Journal notes here.	MBP	1	1	1	1	2013-05-26	0
2013-breeding-observations	36	Journal notes here.	MBP	1	1	1	1	2013-05-30	0
2013-bell-nursery	37	Journal notes here.	MBP	1	1	1	1	2013-07-20	0
2013-bell-nursery	38	Journal notes here.	MBP	1	1	1	1	2013-07-21	0
2013-field	39	Journal notes here.	MBP	1	1	1	1	2013-07-22	0
2013-bell-nursery	40	Journal notes here.	MBP	1	1	1	1	2013-09-21	0
2014-breeding-observations	41	Journal notes here.	MBP	1	1	1	1	2014-02-28	0
2014-breeding-observations	42	Journal notes here.	MBP	1	1	1	1	2014-02-28	0
2014-breeding-observations	43	Journal notes here.	MBP	1	1	1	1	2014-03-01	0
2014-bell-nursery	44	Journal notes here.	MBP	1	1	1	1	2014-09-22	0
2014-bell-nursery	45	Journal notes here.	MBP	1	1	1	1	2014-09-30	0
\.


--
-- Name: journal_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('journal_id_seq', 1, false);


--
-- Data for Name: pedigree; Type: TABLE DATA; Schema: public; Owner: user
--

COPY pedigree (id, pedigree_key, path) FROM stdin;
1	 100XAA10   	 >F1 30XAA91=(PCA2 x A57) >F2 100XAA10=(30AA5MF x 83AA1MF)
2	 100XAA10   	 >F1 41XAA91=(A10 x A73) >F2 83XAA04=(A502 x AA4102) >F3 100XAA10=(30AA5MF x 83AA1MF)
3	 101XAA10   	 >F1 30XAA91=(PCA2 x A57) >F2 101XAA10=(30AA5MF x NORTHFOX)
4	 102XAA10   	 >F1 35XAA91=(PCA2 x JAMIE) >F2 102XAA10=(35AA202 x NORTHFOX)
5	 103XAA10   	 >F1 33XAA91=(A10 x JAMIE) >F2 103XAA10=(33AA11 x NORTHFOX)
6	 104XAA10   	 >F1 35XAA91=(PCA2 x JAMIE) >F2 104XAA10=(35AA202 x 83AA2MF)
7	 104XAA10   	 >F1 41XAA91=(A10 x A73) >F2 83XAA04=(A502 x AA4102) >F3 104XAA10=(35AA202 x 83AA2MF)
8	 105xAA     	 >F1 3XAA89=(A10 x JAMIE) >F2 105xAA=(3AA202 x NORTHFOX)
9	 106xAA     	 >F1 41XAA91=(A10 x A73) >F2 83XAA04=(A502 x AA4102) >F3 106xAA=(83AA565 x NORTHFOX)
10	 107xAA     	 >F1 23XAA91=(PCA2 x PRINCE) >F2 80XAA04=(AA2301 x AA4102) >F3 107xAA=(30AA5MF x 80AA3MF)
11	 107xAA     	 >F1 30XAA91=(PCA2 x A57) >F2 107xAA=(30AA5MF x 80AA3MF)
12	 107xAA     	 >F1 41XAA91=(A10 x A73) >F2 80XAA04=(AA2301 x AA4102) >F3 107xAA=(30AA5MF x 80AA3MF)
13	 10XAA91    	 >F1 10XAA91=(PIONEER x A344)
14	 10xBR      	 >F1 10xBR=(CAG204 x AGRR1)
15	 10XGA91    	 >F1 10XGA91=(BT044 x A546)
16	 10XTG93    	 >F1 10XTG93=(ST7 x BT016)
17	 11XAA90    	 >F1 11XAA90=(PIONEER x PRINCE)
18	 11XAAG91   	 >F1 11XAAG91=(A266 x AGMORIN)
19	 11xAB      	 >F1 11xAB=(A266 x CAG177)
20	 11XTG93    	 >F1 11XTG93=(ST8 x AGMORIN)
21	 12XAA90    	 >F1 12XAA90=(PCA1 x EBL)
22	 12XAG91    	 >F1 12XAG91=(A266 x AGMORIN)
23	 12XGAA91   	 >F1 12XGAA91=(GA14 x PRINCE)
24	 12xRB      	 >F1 12xRB=(PLAZA x CAG177)
25	 12XTG93    	 >F1 12XTG93=(ST8 x BT017)
26	 13XAA90    	 >F1 13XAA90=(PCA1 x PRINCE)
27	 13XAG91    	 >F1 13XAG91=(A10 x TBD)
28	 13XGAG91   	 >F1 13XGAG91=(GA14 x AGMORIN)
29	 13xGB      	 >F1 1XGG91=(BT044 x BT016) >F2 13xGB=(GG102 x CAG177)
30	 13XTG93    	 >F1 13XTG93=(ST9 x AGMORIN)
31	 14XAA90    	 >F1 14XAA90=(ALGER x A344)
32	 14XAG91    	 >F1 14XAG91=(A10 x TBD)
33	 14xB       	 >F1 14xB=(C173 x AGRR1)
34	 14XGAA91   	 >F1 14XGAA91=(GA14 x JAMIE)
35	 14XTG93    	 >F1 14XTG93=(ST9 x BT017)
36	 15XAA90    	 >F1 15XAA90=(ALGER x PRINCE)
37	 15XAG91    	 >F1 15XAG91=(A10 x BT016)
38	 15XAGA91   	 >F1 15XAGA91=(FHAG x JAMIE)
39	 15xB       	 >F1 9XAG91=(PCA2 x BT016) >F2 15xB=(C173 x 9AG105)
40	 15XTG93    	 >F1 15XTG93=(ST10 x AGMORIN)
41	 16XAA91    	 >F1 16XAA91=(A10 x YUGO2)
42	 16XAAG91   	 >F1 16XAAG91=(A502 x AGMORIN)
43	 16xAB      	 >F1 41XAA91=(A10 x A73) >F2 83XAA04=(A502 x AA4102) >F3 16xAB=(83AA565 x CAG177)
44	 16XAG93    	 >F1 16XAG93=(A502 x BT017)
45	 17XAA91    	 >F1 17XAA91=(A10 x A546)
46	 17XAAG91   	 >F1 17XAAG91=(A10 x AGMORIN)
47	 17xB       	 >F1 4XAE91=(A10 x E120) >F2 17xB=(PLAZA x 4AE1)
48	 17XGA04    	 >F1 1XGG91=(BT044 x BT016) >F2 17XGA04=(GG102 x AA4102)
49	 17XGA04    	 >F1 41XAA91=(A10 x A73) >F2 17XGA04=(GG102 x AA4102)
50	 18XAG04    	 >F1 1XGG91=(BT044 x BT016) >F2 18XAG04=(AA4101 x GG101)
51	 18XAG04    	 >F1 41XAA91=(A10 x A73) >F2 18XAG04=(AA4101 x GG101)
52	 18xBG      	 >F1 18xBG=(CAG204 x G6)
53	 19XAAG91   	 >F1 19XAAG91=(PCA2 x AGMORIN)
54	 19xGB      	 >F1 19xGB=(G5 x CAG177)
55	 1XA4E05    	 >F1 1XA4E05=(A502 x TA10)
56	 1XAA85     	 >F1 1XAA85=(A266 x JAMIE)
57	 1XAAE05    	 >F1 1XAAE05=(A502 x TBD)
58	 1XAAG88    	 >F1 1XAAG88=(A266 x CRANDON)
59	 1XAC91     	 >F1 1XAC91=(A10 x C28)
60	 1XAE91     	 >F1 1XAE91=(A266 x E120)
61	 1XAG88     	 >F1 1XAG88=(A266 x FHBT)
62	 1XAGA88    	 >F1 1XAGA88=(FHAG x JAMIE)
63	 1XAGC91    	 >F1 1XAGC91=(CRANDON x C28)
64	 1XAGE91    	 >F1 1XAGE91=(FHAG x E120)
65	 1XAT90     	 >F1 1XAT90=(PRINCE x ST3)
66	 1XAW       	 >F1 41XAA91=(A10 x A73) >F2 83XAA04=(A502 x AA4102) >F3 1XAW=(83AA301 x WIND)
67	 1xBAR      	 >F1 20XAAG91=(A266 x CRANDON) >F2 1xBAR=(CAG204 x AAG2001)
68	 1XEE91     	 >F1 1XEE91=(E138 x E120)
69	 1XGA84     	 >F1 1XGA84=(TBD x JAMIE)
70	 1XGAAG91   	 >F1 1XGAAG91=(GA14 x AGMORIN)
71	 1XGAG91    	 >F1 1XGAG91=(BT044 x AGMORIN)
72	 1XGE91     	 >F1 1XGE91=(BT044 x E120)
73	 1XGG91     	 >F1 1XGG91=(BT044 x BT016)
74	 1XGT90     	 >F1 1XGT90=(BT2 x ST3)
75	 1XT4E04    	 >F1 1XT4E04=(T8057 x TA10)
76	 1XTE04     	 >F1 1XTE04=(CLONE5 x TBD)
77	 1XTG90     	 >F1 1XTG90=(ST071 x BT1)
78	 1XTT91     	 >F1 1XTT91=(ST071 x ST072)
79	 20XAA91    	 >F1 20XAA91=(A266 x A546)
80	 20XAAG91   	 >F1 20XAAG91=(A266 x CRANDON)
81	 20xBS      	 >F1 4XTG91=(ST071 x BT016) >F2 20xBS=(CAG204 x 4TG1)
82	 21XAA91    	 >F1 21XAA91=(A502 x A73)
83	 21XAAG91   	 >F1 32XAA91=(A266 x PRINCE) >F2 21XAAG91=(AA3201 x CRANDON)
84	 21xBA      	 >F1 23XAA91=(PCA2 x PRINCE) >F2 80XAA04=(AA2301 x AA4102) >F3 21xBA=(CAG204 x 80AA3MF)
85	 21xBA      	 >F1 41XAA91=(A10 x A73) >F2 80XAA04=(AA2301 x AA4102) >F3 21xBA=(CAG204 x 80AA3MF)
86	 22XAA91    	 >F1 22XAA91=(A502 x PRINCE)
87	 22xAR      	 >F1 3XAA89=(A10 x JAMIE) >F2 22xAR=(3AA202 x AGRR1)
88	 22xBG      	 >F1 22xBG=(CAG204 x G4)
89	 23XAA91    	 >F1 23XAA91=(PCA2 x PRINCE)
90	 23xBA      	 >F1 41XAA91=(A10 x A73) >F2 82XAA04=(AA901 x AA4102) >F3 23xBA=(CAG204 x 82AA3)
91	 23xBA      	 >F1 9XAA90=(A266 x A344) >F2 82XAA04=(AA901 x AA4102) >F3 23xBA=(CAG204 x 82AA3)
92	 25XAA91    	 >F1 25XAA91=(A266 x PA092)
93	 26XAA91    	 >F1 26XAA91=(PCA2 x A73)
94	 27XAA91    	 >F1 27XAA91=(A10 x PRINCE)
95	 28XAA91    	 >F1 28XAA91=(A266 x A73)
96	 29XAA91    	 >F1 29XAA91=(A266 x YUGO2)
97	 2XA4E05    	 >F1 2XA4E05=(A266 x TA10)
98	 2XAA88     	 >F1 2XAA88=(A266 x JAMIE)
99	 2XAAE06    	 >F1 2XAAE06=(A502 x TBD)
100	 2XAAG88    	 >F1 2XAAG88=(A266 x AGMORIN)
101	 2XAG90     	 >F1 2XAG90=(A266 x FHBT)
102	 2XAGA90    	 >F1 2XAGA90=(CRANDON x A344)
103	 2xB        	 >F1 15XAG91=(A10 x BT016) >F2 2xB=(C173 x 15AG4MF)
104	 2xB        	 >F1 2xB=(C173 x 15AG4MF)
105	 2XGA88     	 >F1 2XGA88=(TBD x JAMIE)
106	 2XGAE91    	 >F1 2XGAE91=(GA14 x E120)
107	 2XGAG91    	 >F1 2XGAG91=(GA14 x TBD)
108	 2XGT91     	 >F1 2XGT91=(BT044 x ST072)
109	 2xRR       	 >F1 9XAG91=(PCA2 x BT016) >F2 2xRR=(9AG103 x AGRR1)
110	 2XT4E04    	 >F1 2XT4E04=(CLONE5 x TA10)
111	 2XTG90     	 >F1 2XTG90=(ST071 x FHBT)
112	 30XAA91    	 >F1 30XAA91=(PCA2 x A57)
113	 31XAA91    	 >F1 31XAA91=(A266 x C28)
114	 32XAA91    	 >F1 32XAA91=(A266 x PRINCE)
115	 33XAA91    	 >F1 33XAA91=(A10 x JAMIE)
116	 35XAA91    	 >F1 35XAA91=(PCA2 x JAMIE)
117	 36XAA91    	 >F1 36XAA91=(A502 x A546)
118	 39XAA91    	 >F1 39XAA91=(PCA2 x YUGO2)
119	 3XAA89     	 >F1 3XAA89=(A10 x JAMIE)
120	 3XAG90     	 >F1 3XAG90=(PCA1 x FHBT)
121	 3XAGA90    	 >F1 3XAGA90=(CRANDON x PRINCE)
122	 3XCAGC     	 >F1 3XCAGC=(CAG204 x AE42)
123	 3xRR       	 >F1 9XAG91=(PCA2 x BT016) >F2 3xRR=(PLAZA x 9AG105)
124	 3XTG90     	 >F1 3XTG90=(ST2 x BT1)
125	 40XAA91    	 >F1 40XAA91=(A10 x A57)
126	 41XAA91    	 >F1 41XAA91=(A10 x A73)
127	 42XAA91    	 >F1 42XAA91=(NA x NA)
128	 43XAA92    	 >F1 43XAA92=(A266 x ZOO)
129	 44XAA92    	 >F1 44XAA92=(A266 x TBD)
130	 45XAA92    	 >F1 45XAA92=(A266 x TBD)
131	 46XAA92    	 >F1 46XAA92=(A266 x JAMIE)
132	 47XAA92    	 >F1 47XAA92=(GODFREY x ZOO)
133	 4XAA89     	 >F1 4XAA89=(TBD x JAMIE)
134	 4xACAG     	 >F1 4xACAG=(A502 x CAG177)
135	 4XAE91     	 >F1 4XAE91=(A10 x E120)
136	 4XAG90     	 >F1 4XAG90=(ALGER x FHBT)
137	 4XAGA90    	 >F1 4XAGA90=(TBD x A344)
138	 4xGW       	 >F1 1XGG91=(BT044 x BT016) >F2 4xGW=(GG102 x WIND)
139	 4xRR       	 >F1 4xRR=(PLAZA x AGRR1)
140	 4XTG91     	 >F1 4XTG91=(ST071 x BT016)
141	 50XAA92    	 >F1 50XAA92=(PCA1 x ZOO)
142	 53XAA92    	 >F1 1XAA85=(A266 x JAMIE) >F2 53XAA92=(AA101 x ZOO)
143	 54XAA93    	 >F1 54XAA93=(A266 x POL2)
144	 55XAA93    	 >F1 55XAA93=(A266 x POL3)
145	 56XAA93    	 >F1 56XAA93=(A266 x SER41)
146	 57XAA93    	 >F1 57XAA93=(A266 x SER42)
147	 58XAA93    	 >F1 58XAA93=(A266 x SER5)
148	 59XAA93    	 >F1 59XAA93=(A266 x SER6)
149	 5XAA89     	 >F1 5XAA89=(A502 x JAMIE)
150	 5XAE91     	 >F1 5XAE91=(PCA2 x E120)
151	 5xCAGR     	 >F1 5xCAGR=(CAG204 x AGRR1)
152	 5xRB       	 >F1 9XAG91=(PCA2 x BT016) >F2 5xRB=(9AG105 x CAG177)
153	 5XTG93     	 >F1 5XTG93=(ST071 x AGMORIN)
154	 60XAA93    	 >F1 60XAA93=(A266 x NORTHFOX)
155	 61XAA93    	 >F1 61XAA93=(A502 x POL2)
156	 62XAA93    	 >F1 62XAA93=(A502 x POL3)
157	 63XAA93    	 >F1 63XAA93=(A502 x SER41)
158	 64XAA93    	 >F1 64XAA93=(A502 x SER42)
159	 65XAA93    	 >F1 65XAA93=(A502 x SER5)
160	 66XAA93    	 >F1 66XAA93=(A502 x SER6)
161	 67XAA93    	 >F1 67XAA93=(A502 x NORTHFOX)
162	 68XAA93    	 >F1 1XAA85=(A266 x JAMIE) >F2 68XAA93=(AA101 x POL2)
163	 69XAA93    	 >F1 1XAA85=(A266 x JAMIE) >F2 69XAA93=(AA101 x POL3)
164	 6XAA89     	 >F1 6XAA89=(A266 x A344)
165	 6xBA       	 >F1 6xBA=(CAG204 x NORTHFOX)
166	 70XAA93    	 >F1 1XAA85=(A266 x JAMIE) >F2 70XAA93=(AA101 x SER41)
167	 71XAA93    	 >F1 1XAA85=(A266 x JAMIE) >F2 71XAA93=(AA101 x SER42)
168	 72XAA93    	 >F1 1XAA85=(A266 x JAMIE) >F2 72XAA93=(AA101 x SER5)
169	 73XAA93    	 >F1 1XAA85=(A266 x JAMIE) >F2 73XAA93=(AA101 x NORTHFOX)
170	 74XAA95    	 >F1 74XAA95=(SOUTHBELL x JAMIE)
171	 75XAA95    	 >F1 75XAA95=(A266 x JAMIE)
172	 76XAA02    	 >F1 21XAA91=(A502 x A73) >F2 76XAA02=(A502 x AA2101)
173	 77XAA02    	 >F1 21XAA91=(A502 x A73) >F2 77XAA02=(AA4101 x AA2101)
174	 77XAA02    	 >F1 41XAA91=(A10 x A73) >F2 77XAA02=(AA4101 x AA2101)
175	 78XAA02    	 >F1 20XAAG91=(A266 x CRANDON) >F2 78XAA02=(AAG2002 x AA2101)
176	 78XAA02    	 >F1 21XAA91=(A502 x A73) >F2 78XAA02=(AAG2002 x AA2101)
177	 79XAA03    	 >F1 41XAA91=(A10 x A73) >F2 79XAA03=(A502 x AA4102)
178	 7XAA90     	 >F1 7XAA90=(A266 x EBL)
179	 7XAGA91    	 >F1 7XAGA91=(FHAG x A546)
180	 7xBT       	 >F1 7xBT=(CAG204 x ST11)
181	 7XGA91     	 >F1 7XGA91=(BT044 x JAMIE)
182	 7XTG93     	 >F1 7XTG93=(ST5 x AGMORIN)
183	 80XAA04    	 >F1 23XAA91=(PCA2 x PRINCE) >F2 80XAA04=(AA2301 x AA4102)
184	 80XAA04    	 >F1 41XAA91=(A10 x A73) >F2 80XAA04=(AA2301 x AA4102)
185	 81XAA04    	 >F1 32XAA91=(A266 x PRINCE) >F2 81XAA04=(AA3201 x AA4102)
186	 81XAA04    	 >F1 41XAA91=(A10 x A73) >F2 81XAA04=(AA3201 x AA4102)
187	 82XAA04    	 >F1 41XAA91=(A10 x A73) >F2 82XAA04=(AA901 x AA4102)
188	 82XAA04    	 >F1 9XAA90=(A266 x A344) >F2 82XAA04=(AA901 x AA4102)
189	 83XAA04    	 >F1 41XAA91=(A10 x A73) >F2 83XAA04=(A502 x AA4102)
190	 84XAA04    	 >F1 30XAA91=(PCA2 x A57) >F2 84XAA04=(AA3001 x AA4102)
191	 84XAA04    	 >F1 41XAA91=(A10 x A73) >F2 84XAA04=(AA3001 x AA4102)
192	 85XAA04    	 >F1 41XAA91=(A10 x A73) >F2 85XAA04=(AA4101 x AA4102)
193	 86XAA10    	 >F1 86XAA10=(A502 x NORTHFOX)
194	 87XAA10    	 >F1 40XAA91=(A10 x A57) >F2 87XAA10=(40AA08 x AA4102)
195	 87XAA10    	 >F1 41XAA91=(A10 x A73) >F2 87XAA10=(40AA08 x AA4102)
196	 88XAA10    	 >F1 40XAA91=(A10 x A57) >F2 88XAA10=(40AA08 x EBL)
197	 89XAA10    	 >F1 41XAA91=(A10 x A73) >F2 89XAA10=(41AA111 x EBL)
198	 8XAA90     	 >F1 8XAA90=(A266 x PRINCE)
199	 8XAG91     	 >F1 8XAG91=(A502 x AGMORIN)
200	 8XAGA91    	 >F1 8XAGA91=(FHAG x C28)
201	 8xBG       	 >F1 1XGG91=(BT044 x BT016) >F2 8xBG=(CAG204 x GG101)
202	 90XAA10    	 >F1 40XAA91=(A10 x A57) >F2 90XAA10=(40AA08 x NORTHFOX)
203	 91XAA10    	 >F1 41XAA91=(A10 x A73) >F2 91XAA10=(41AA111 x NORTHFOX)
204	 92XAA10    	 >F1 35XAA91=(PCA2 x JAMIE) >F2 92XAA10=(41AA111 x 35AA201)
205	 92XAA10    	 >F1 41XAA91=(A10 x A73) >F2 92XAA10=(41AA111 x 35AA201)
206	 93XAA10    	 >F1 41XAA91=(A10 x A73) >F2 93XAA10=(A502 x AA4102)
207	 94XAA10    	 >F1 40XAA91=(A10 x A57) >F2 94XAA10=(40AA6MF x EBL)
208	 95XAA10    	 >F1 35XAA91=(PCA2 x JAMIE) >F2 95XAA10=(40AA08 x 35AA201)
209	 95XAA10    	 >F1 40XAA91=(A10 x A57) >F2 95XAA10=(40AA08 x 35AA201)
210	 96XAA10    	 >F1 35XAA91=(PCA2 x JAMIE) >F2 96XAA10=(40AA6MF x 35AA201)
211	 96XAA10    	 >F1 40XAA91=(A10 x A57) >F2 96XAA10=(40AA6MF x 35AA201)
212	 97XAA10    	 >F1 40XAA91=(A10 x A57) >F2 97XAA10=(40AA6MF x NORTHFOX)
213	 98XAA10    	 >F1 30XAA91=(PCA2 x A57) >F2 98XAA10=(30AA5MF x 83AA2MF)
214	 98XAA10    	 >F1 41XAA91=(A10 x A73) >F2 83XAA04=(A502 x AA4102) >F3 98XAA10=(30AA5MF x 83AA2MF)
215	 99XAA10    	 >F1 30XAA91=(PCA2 x A57) >F2 99XAA10=(30AA5MF x AA4102)
216	 99XAA10    	 >F1 41XAA91=(A10 x A73) >F2 99XAA10=(30AA5MF x AA4102)
217	 9XAA90     	 >F1 9XAA90=(A266 x A344)
218	 9XAG91     	 >F1 9XAG91=(PCA2 x BT016)
219	 9XAGA91    	 >F1 9XAGA91=(FHAG x PRINCE)
220	 9xBR       	 >F1 9XAG91=(PCA2 x BT016) >F2 9xBR=(CAG204 x 9AG105)
221	 9XTG93     	 >F1 9XTG93=(ST7 x AGMORIN)
\.


--
-- Name: pedigree_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('pedigree_id_seq', 221, true);


--
-- Data for Name: plant; Type: TABLE DATA; Schema: public; Owner: user
--

COPY plant (plant_key, id, notes, sex_mfbu, published_botanical_name, common_name, alternate_name, aquired_from, female_external_parent, male_external_parent, form_fnmwu, is_plus, is_cultivar, is_variety, is_from_wild, ploidy_n, date_aquired, id_taxa, id_family, web_photos, web_url) FROM stdin;
TBD	1	To Be Determined	U	0	0	0	0	0	0	U	U	U	U	U	0	1111-11-11	2	2	0	0
NA	2	Does Not Apply	U	0	0	0	0	0	0	U	U	U	U	U	0	1111-11-11	2	2	0	0
A73	3	Plant notes here.	M	Populus alba 'Pyramidalis' 	Bolleana	0	Aquired notes here.	0	0	F	N	Y	N	U	2	1991-01-01	3	2	0	0
A10	4	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	Y	Y	N	Y	2	1989-01-01	3	2	0	0
A344	5	Plant notes here.	M	0	0	0	Aquired notes here.	A69	A57	W	Y	Y	N	N	2	1989-01-01	3	2	0	0
A57	6	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	Y	N	U	2	1991-01-01	3	2	0	0
PRINCE	7	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	1990-01-01	3	2	0	0
EBL	8	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	N	N	N	Y	2	1985-01-01	3	2	0	0
A266	9	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	Y	Y	N	N	2	1991-01-01	3	2	0	0
YUGO2	10	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	1991-01-01	3	2	0	0
A502	11	Plant notes here.	F	0	0	0	Aquired notes here.	P.alba n2 Istituto Pignatelli - Villafranca Piemonte TO Italy	P.alba n2 Istituto Pignatelli - Villafranca Piemonte TO Italy	M	Y	Y	N	N	2	1989-01-01	3	2	0	0
GODFREY	12	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	F	N	N	N	Y	2	1992-01-01	3	2	0	0
POL3	13	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	U	Y	N	N	Y	2	1993-01-01	3	2	0	0
POL2	14	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	1993-01-01	3	2	0	0
SER41	15	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	1993-01-01	3	2	0	0
SER42	16	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	1993-01-01	3	2	0	0
SER5	17	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	1993-01-01	3	2	0	0
SER6	18	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	1993-01-01	3	2	0	0
NORTHFOX	19	Plant notes here.	M	0	NFA	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	1991-01-01	3	2	0	0
ALGER	20	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	N	N	N	Y	2	1985-01-01	3	2	0	0
A546	21	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	N	2	1991-01-01	3	2	0	0
A101	22	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	Y	N	N	N	2	1991-01-01	3	2	0	0
JAMIE	23	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	1983-01-01	3	2	0	0
ZOO	24	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	N	N	N	Y	2	1992-01-01	3	2	0	0
SOUTHBELL	25	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	N	N	N	Y	2	1995-01-01	3	2	0	0
15AG4MF	26	Plant notes here.	U	0	0	15AG-8m-55-51	Aquired notes here.	0	0	M	Y	N	N	N	2	2011-01-01	6	25	0	0
AA101	27	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	N	N	N	N	2	1987-01-01	3	3	0	0
PA092	28	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	1991-01-01	3	2	0	0
PCA1	29	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	N	N	N	N	2	1988-01-01	3	2	0	0
PCA2	30	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	N	N	N	N	2	1988-01-01	3	2	0	0
AA510	31	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	Y	N	N	N	2	1989-01-01	3	109	0	0
AA511	32	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	Y	N	N	N	2	1990-01-01	3	109	0	0
AA2101	33	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	W	Y	N	N	N	2	1992-01-01	3	57	0	0
AA4101	34	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	Y	2	2001-01-01	3	88	0	0
AA4102	35	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	Y	N	N	Y	2	2001-01-01	3	88	0	0
AA4201	36	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	Y	N	N	Y	2	2001-01-01	3	90	0	0
DN34	37	Plant notes here.	M	P. xcanadensis 'Eugenei'	Carolina	NC-5326	Aquired notes here.	0	0	M	Y	Y	N	Y	2	1985-01-01	1	2	0	0
NM6	38	Plant notes here.	M	Populus nigra L. x P. maximowiczii A. Henry 'NM6'	0	0	Aquired notes here.	0	0	M	Y	Y	N	N	2	2004-01-01	1	2	0	0
PIONEER	39	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	N	N	N	Y	2	1990-01-01	3	2	0	0
TA10	40	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	4	2004-01-01	1	2	0	0
AA3201	41	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	78	0	0
AAG2001	42	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	1	56	0	0
AAG2002	43	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	1	56	0	0
AA901	44	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	146	0	0
CLONE5	45	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	1	2	0	0
AA2301	46	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	60	0	0
AA3001	47	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	76	0	0
GG102	48	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	1	49	0	0
GG101	49	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	1	49	0	0
BT016	50	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1990-01-01	1	2	0	0
BT044	51	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1990-01-01	1	2	0	0
FHBT	52	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1988-01-01	6	2	0	0
BT1	53	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1990-01-01	1	2	0	0
BT2	54	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1990-01-01	1	2	0	0
BT017	55	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1993-01-01	1	2	0	0
CRANDON	56	Plant notes here.	B	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1983-01-01	6	2	0	0
FHAG	57	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1987-01-01	6	2	0	0
KENT	58	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1989-01-01	6	2	0	0
GA14	59	Plant notes here.	F	0	0	0	Aquired notes here.	srs,g3	A56	M	N	N	N	N	2	1991-01-01	7	2	0	0
AGMORIN	60	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1985-01-01	6	2	0	0
AGRR1	61	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1991-01-01	6	2	0	0
CA2	62	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1985-01-01	9	2	0	0
AE42	63	Plant notes here.	M	0	0	0	Aquired notes here.	a69	e12	M	N	N	N	N	2	1989-01-01	9	2	0	0
C28	64	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1991-01-01	9	2	0	0
CAG177	65	Plant notes here.	M	0	0	0	Aquired notes here.	c18	ag7	M	N	N	N	N	2	1989-01-01	1	2	0	0
CAG204	66	Plant notes here.	F	0	0	0	Aquired notes here.	c18	ag7	M	Y	N	N	N	2	1989-01-01	1	2	0	0
ST071	67	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1990-01-01	1	2	0	0
ST072	68	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1991-01-01	1	2	0	0
ST2	69	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1990-01-01	1	2	0	0
ST3	70	Plant notes here.	B	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1990-01-01	1	2	0	0
EE102	71	Plant notes here.	F	0	0	0	Aquired notes here.	e138	e120	M	N	N	N	N	2	2003-01-01	1	44	0	0
E138	72	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1991-01-01	1	2	0	0
E120	73	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	1991-01-01	1	2	0	0
ST5	74	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	Y	2	1993-01-01	1	2	0	0
T8057	75	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	Y	2	2004-01-01	1	2	0	0
R43C76	76	Plant notes here.	F	0	0	0	Aquired notes here.	7439-0033	7431-0033	M	N	N	N	Y	2	2004-01-01	1	2	0	0
R32C77	77	Plant notes here.	F	0	0	0	Aquired notes here.	7439-0033	7431-0033	M	N	N	N	Y	2	2004-01-01	1	2	0	0
R28C74	78	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	Y	2	2004-01-01	1	2	0	0
76AA4	79	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA5	80	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA6	81	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA7	82	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA8	83	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA9	84	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA1	85	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA2	86	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA3	87	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA10	88	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA11	89	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA12	90	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA13	91	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA14	92	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA15	93	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA16	94	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA17	95	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA18	96	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA19	97	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
77AA1	98	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	130	0	0
77AA2	99	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	130	0	0
77AA9	100	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	130	0	0
77AA8	101	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	130	0	0
77AA3	102	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	130	0	0
77AA4	103	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	130	0	0
77AA5	104	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	130	0	0
77AA6	105	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	130	0	0
83AA1	106	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2005-01-01	3	140	0	0
83AA2	107	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2005-01-01	3	140	0	0
83AA3	108	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2005-01-01	3	140	0	0
83AA4	109	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2005-01-01	3	140	0	0
83AA5	110	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2005-01-01	1	2	0	0
83AA6	111	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2005-01-01	3	140	0	0
83AA58	112	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2005-01-01	3	140	0	0
83AA101	113	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2009-01-01	3	140	0	0
83AA102	114	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2009-01-01	3	140	0	0
83AA103	115	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2009-01-01	3	140	0	0
83AA104	116	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2009-01-01	3	140	0	0
T0601	117	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	Y	2	2006-01-01	1	2	0	0
T0602	118	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	Y	2	2006-01-01	1	2	0	0
4AA101	119	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2009-01-01	3	96	0	0
70AA01	120	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2009-01-01	3	123	0	0
68AA01	121	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2009-01-01	3	120	0	0
62AA01	122	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2009-01-01	3	114	0	0
76AA214	123	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA217	124	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
83AA189	125	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2005-01-01	3	140	0	0
83AA202	126	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2009-01-01	3	140	0	0
83AA203	127	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2005-01-01	3	140	0	0
83AA204	128	Plant notes here.	U	0	0	A204	Aquired notes here.	0	0	M	Y	N	N	N	2	2009-01-01	3	140	0	0
83AA206	129	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2005-01-01	3	140	0	0
83AA208	130	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2005-01-01	3	140	0	0
83AA209	131	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2005-01-01	3	140	0	0
35AA200	132	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2010-01-01	3	80	0	0
35AA201	133	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2010-01-01	3	80	0	0
35AA202	134	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2010-01-01	3	80	0	0
83AA105	135	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2009-01-01	3	140	0	0
83AA106	136	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2009-01-01	3	140	0	0
83AA107	137	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2009-01-01	3	140	0	0
41AA111	138	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2001-01-01	3	88	0	0
33AA11	139	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2010-01-01	3	79	0	0
40AA08	140	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2010-01-01	3	87	0	0
30AA5MF	141	Plant notes here.	F	0	0	30AA-8m-5-2	Aquired notes here.	0	0	M	N	N	N	N	2	2010-01-01	3	76	0	0
40AA6MF	142	Plant notes here.	F	0	0	40AA-8m-23-27	Aquired notes here.	0	0	M	N	N	N	N	2	2010-01-01	3	87	0	0
83AA1MF	143	Plant notes here.	M	0	0	83AA-7m-3-17	Aquired notes here.	0	0	M	N	N	N	N	2	2010-01-01	3	140	0	0
83AA2MF	144	Plant notes here.	M	0	0	83AA-7m-7-4	Aquired notes here.	0	0	M	N	N	N	N	2	2010-01-01	3	140	0	0
83AA166	145	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2005-01-01	3	140	0	0
87AA101	146	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2010-01-01	3	164	0	0
90AA101	147	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2010-01-01	3	165	0	0
94AA101	148	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2010-01-01	3	161	0	0
ST7	149	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	Y	2	1993-03-06	1	2	0	0
ST8	150	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	Y	2	1993-03-06	1	2	0	0
ST9	151	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	Y	2	1993-03-23	1	2	0	0
ST10	152	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	Y	2	1993-03-23	1	2	0	0
100AA01	153	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2010-09-16	3	158	0	0
100AA02	154	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2010-09-16	3	158	0	0
100AA03	155	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2010-09-16	3	158	0	0
100AA04	156	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2010-09-16	3	158	0	0
ZOSS	157	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	2010-12-18	6	2	0	0
J2	158	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	2010-12-17	3	2	0	0
76AA205	159	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA211	160	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
76AA218	161	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2004-01-01	3	129	0	0
83AA301	162	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	N	N	N	N	2	2011-04-21	3	140	0	0
WIND	163	Plant notes here.	M	0	Wind or Open Pollinated 	W	Aquired notes here.	0	0	U	U	N	N	U	2	1111-11-11	2	1	0	0
83AA3MF	164	Plant notes here.	U	0	0	83AA-MSU-69	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA4MF	165	Plant notes here.	U	0	0	83AA-MSU-70	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA5MF	166	Plant notes here.	U	0	0	83AA-MSU-66	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA6MF	167	Plant notes here.	U	0	0	83AA-MSU-75	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA7MF	168	Plant notes here.	U	0	0	83AA-MSU-74	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA8MF	169	Plant notes here.	U	0	0	83AA-MSU-65	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA9MF	170	Plant notes here.	U	0	0	83AA-MSU-68	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA10MF	171	Plant notes here.	U	0	0	83AA-MSU-63	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA11MF	172	Plant notes here.	U	0	0	83AA-MSU-72	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA12MF	173	Plant notes here.	U	0	0	83AA-MSU-71	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA13MF	174	Plant notes here.	U	0	0	83AA-MSU-67	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA14MF	175	Plant notes here.	U	0	0	83AA-MSU-73	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA15MF	176	Plant notes here.	U	0	0	83AA-MSU-64	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA16MF	177	Plant notes here.	U	0	0	83AA-MSU-76	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
83AA17MF	178	Plant notes here.	U	0	0	83AA-MSU-62	Aquired notes here.	0	0	U	U	N	N	N	2	2010-05-14	3	140	0	0
C173	179	Plant notes here.	F	0	0	Ca-14-75	Aquired notes here.	0	0	W	Y	Y	N	N	2	2012-02-20	13	2	TBD	0
T202	180	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	U	N	N	N	2	2012-02-20	11	2	TBD	0
1CAGW01	181	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-06-28	14	171	TBD	0
80AA3MF	182	Plant notes here.	U	0	0	TBD	Aquired notes here.	0	0	W	Y	N	N	N	2	2012-06-21	3	137	TBD	0
1CAGW02	183	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	14	171	TBD	0
1CAGW03	184	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	14	171	TBD	0
100AA11	185	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	3	158	TBD	0
100AA12	186	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	3	158	TBD	0
101AA11	187	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	3	156	TBD	0
103AA11	188	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	3	170	TBD	0
104AA11	189	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	3	169	TBD	0
104AA12	190	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	3	169	TBD	0
92AA11	191	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	3	152	TBD	0
93AA11	192	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	3	166	TBD	0
93AA12	193	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	3	166	TBD	0
95AA11	194	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	3	162	TBD	0
97AA11	195	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	3	159	TBD	0
98AA11	196	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	3	155	TBD	0
97AA12	197	Plant notes here.	U	0	0	0	Aquired notes here.	0	0	U	Y	N	N	N	2	2012-11-04	3	159	TBD	0
A69	198	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	N	N	N	Y	2	1989-01-01	3	2	TBD	0
9AG103	199	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	N	N	N	N	2	1991-01-01	6	147	0	0
9AG105	200	Plant notes here.	B	0	0	0	Aquired notes here.	0	0	W	Y	N	N	N	2	1991-01-01	6	147	0	0
G1	201	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	N	N	N	Y	2	2013-05-04	10	175	0	0
G2	202	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	N	N	N	Y	2	2013-05-04	10	176	0	0
G3	203	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	N	N	N	Y	2	2013-05-24	10	177	0	0
3AA202	204	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	Y	N	N	N	2	2013-04-13	3	83	0	0
83AA565	205	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	M	Y	N	N	N	2	2014-04-07	3	140	0	0
80AA5MF	206	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	N	2	2014-04-07	3	137	TBD	0
PLAZA	207	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	2014-04-07	6	2	TBD	0
82AA3	208	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	Y	N	N	N	2	2014-04-07	3	139	TBD	0
ST11	209	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	Y	N	N	Y	2	2014-04-07	11	2	TBD	0
G4	210	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	M	Y	N	N	Y	2	2014-04-07	10	2	TBD	0
G5	211	Plant notes here.	F	0	0	0	Aquired notes here.	0	0	W	U	N	N	Y	2	2014-04-07	10	2	TBD	0
G6	212	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	Y	2	2014-04-07	10	2	TBD	0
4AE1	213	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	N	2	2014-04-07	9	97	TBD	0
4TG1	214	Plant notes here.	M	0	0	0	Aquired notes here.	0	0	W	Y	N	N	N	2	2014-04-07	5	100	TBD	0
\.


--
-- Name: plant_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('plant_id_seq', 1, false);


--
-- Data for Name: site; Type: TABLE DATA; Schema: public; Owner: user
--

COPY site (site_key, id, location_code, name_long, notes, address, loc_lat, loc_long, elevation_ft, aspen_site_index, usda_soil_texture, drainage_class_usda, mean_annual_precip_in, mean_annual_temp_f, frost_free_period_days, depth_to_water_table_in, usda_map_url, web_url, web_photos, contact) FROM stdin;
TBD	1	TBD	0	To Be Determined	0	0	0	0	0	0	U	0	0	0	0	0	0	0	0
NA	2	NA	0	Does Not Apply	0	0	0	0	0	0	U	0	0	0	0	0	0	0	0
Bell-Nursery	3	BELLN	0	MBP	0	0	0	900	0	sand	WD	34	48	170	1000	0	0	0	0
Costa-Nursery	4	COSTN	0	MBP	0	0	0	900	0	sand	WD	34	48	170	1000	0	0	0	0
Dykema-Nursery	5	DYKEN	0	MBP	0	0	0	900	0	sand	ED	34	48	170	1000	0	0	0	0
Bell-Indoor	6	BELLI	0	MBP	0	0	0	900	0	0	U	-1	-1	-1	-1	0	0	0	0
Rockford-NE	7	RNE	0	MBP	0	0	0	900	0	0	WD	0	0	0	-1	0	0	0	0
MFUPTIC	8	MF	0	MFUPTIC	0	0	0	0	0	0	U	-1	-1	-1	-1	0	0	0	0
\.


--
-- Name: site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('site_id_seq', 1, false);


--
-- Data for Name: taxa; Type: TABLE DATA; Schema: public; Owner: user
--

COPY taxa (taxa_key, id, notes, species, species_hybrid, common_name, binomial_name, kingdom, family, genus, web_photos, web_url) FROM stdin;
TBD	1	To Be Determined	0	NA	0	0	0	0	0	0	0
NA	2	Does Not Apply - See Taxa table for separate hybrid taxa definitions.	NA	0	0	0	0	0	0	0	0
A	3	Native to Europe, aka White Poplar	P. alba Linnaeus	0	White Poplar	0	Plantae	Salicaceae	Populus	0	http://en.wikipedia.org/wiki/Populus_alba
GT	4	Occurs naturally, susceptible to BLD	0	P. grandidentata x P. tremuloides	A.k.a P. xbarnesii	P. xsmithii Boivin	Plantae	Salicaceae	Populus	0	0
TG	5	Occurs naturally, susceptible to BLD	0	P. tremuloides x P. grandidentata	A.k.a P. xbarnesii	P. xsmithii Boivin	Plantae	Salicaceae	Populus	0	0
AG	6	Occurs where P. alba females are present.	0	P. alba x P. grandidentata	AG	P. xrouleauiana Bovin	Plantae	Salicaceae	Populus	0	0
GA	7	Not common in the wild since most P. albas are females and P. grandidentata seed has more exacting requirements.	0	P. grandidentata x P. alba	GA	P. xrouleauiana Bovin	Plantae	Salicaceae	Populus	0	0
AT	8	Not as common in the wild as AG	0	P. alba x P. tremuloides	0	P. xheimburgeri Boivin	Plantae	Salicaceae	Populus	0	0
AE	9	A valuable cross - used by itself or with CAGs	0	P. alba x P. tremula	gray poplar	P. xcanescens Smith	Plantae	Salicaceae	Populus	0	0
G	10	Native to NE USA.	P. grandidentata Michaux	0	Big Tooth aspen	0	Plantae	Salicaceae	Populus	0	http://en.wikipedia.org/wiki/Populus_grandidentata
T	11	Native to Northern North America	P. tremuloides Michaux	0	Small Tooth aspen	0	Plantae	Salicaceae	Populus	0	http://en.wikipedia.org/wiki/Populus_tremuloides
E	12	Native to Europe	P. tremula Linnaeus	0	European Aspen	0	Plantae	Salicaceae	Populus	0	http://en.wikipedia.org/wiki/Populus_tremula
CAG	13	A double hybrid cross pioneered by the Canadians and known for diversity with some good rooting individuals despite poor rooting parents.	0	(P. alba x P. grandidentata) x P. canescens	CAG	0	Plantae	Salicaceae	Populus	0	0
CAGW	14	Describes an open pollinated (Wind) CAG cross.  They may have potential for interesting recombinations.	0	(P. canescens x (P. alba x P. grandidentata)) x OP	CAGW	0	Plantae	Salicaceae	Populus	0	0
B	15	Alternate name for CAG crosses for brevity.  A double hybrid cross pioneered by the Canadians and known for diversity with some good rooting individuals despite poor rooting parents.	0	(P. alba x P. grandidentata) x P. canescens	CAG	0	Plantae	Salicaceae	Populus	0	0
R	16	Alternate name for AG/GA crosses (P. xrouleauiana) for brevity.	0	P. alba x P. grandidentata (and reciprocal)	AG or GA	P. xrouleauiana Bovin	Plantae	Salicaceae	Populus	0	0
S	17	Alternate name for the TG/GT smithii (P. xsmithii Boivin) crosses for brevity 	0	P. tremuloides x P. grandidentata (and reciprocal)	TG or GT	P. xsmithii Boivin	Plantae	Salicaceae	Populus	0	0
W	18	W stands for Wind pollinated. Therefore the exact male parent is unknown.	Wind Pollinated	0	Open Pollinated	NA	NA	NA	NA	0	0
\.


--
-- Name: taxa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('taxa_id_seq', 1, false);


--
-- Data for Name: test_detail; Type: TABLE DATA; Schema: public; Owner: user
--

COPY test_detail (test_detail_key, id, notes, notes2, start_quantity, end_quantity, this_start_date, score_date, stock_type, stock_length_cm, stock_dia_mm, nbr_of_stems, is_plus_ynu, collar_median_dia_mm, dbh_circ_cm, height_cm, bias_3_3, leaf_score, canker_score, swasp_score, id_plant, id_family, id_test_spec, row_nbr, column_nbr, replication_nbr, plot_nbr, block_nbr) FROM stdin;
TBD	-1	Dummy record used for id_prev_test_detail null values	1	-1	-1	1111-11-11	1111-11-11	U   	-1	-1	-1	0	-1	-1	-1	-4	-1	-1	-1	1	2	2	-1	-1	-1	-1	-1
TBD	1	To Be Determined	1	-1	-1	1111-11-11	1111-11-11	U   	-1	-1	-1	0	-1	-1	-1	-4	-1	-1	-1	1	2	2	-1	-1	-1	-1	-1
NA	2	Does Not Apply	2	-1	-1	1111-11-11	1111-11-11	U   	-1	-1	-1	0	-1	-1	-1	-4	-1	-1	-1	2	2	2	-1	-1	-1	-1	-1
pip-190	3	tag marked 83aa190 but not in DB	0	1	1	2010-03-25	2010-11-01	1-0 	10	-1	-1	U	-1	-1	238.8	-4	-1	-1	-1	2	140	7	-1	2	-1	-1	-1
83aa107	4	Has little tomentose on bark	0	1	1	2010-03-25	2010-11-01	1-0 	10	-1	-1	U	-1	-1	383.5	-4	-1	-1	-1	137	2	7	-1	2	-1	-1	-1
83aa106	5	Has Knotty Poplar trait real strong, need to propagate more	0	1	1	2010-03-25	2010-11-01	1-0 	10	-1	-1	Y	-1	-1	302.3	-4	-1	-1	-1	136	2	7	-1	2	-1	-1	-1
83aa105	6	0	0	1	1	2010-03-25	2010-11-01	1-0 	10	-1	-1	U	-1	-1	170.2	-4	-1	-1	-1	135	2	7	-1	2	-1	-1	-1
83aa104	7	Had #1 dia in 2009, 3 boles totaled 311 hgt.	0	1	1	2010-03-25	2010-11-01	1-0 	10	-1	-1	Y	-1	-1	388.6	-4	-1	-1	-1	116	2	7	-1	2	-1	-1	-1
83aa103	8	0	0	1	1	2010-03-25	2010-11-01	1-0 	10	-1	-1	U	-1	-1	198.1	-4	-1	-1	-1	115	2	7	-1	2	-1	-1	-1
83aa101	9	0	0	1	1	2010-03-25	2010-11-01	1-0 	10	-1	-1	U	-1	-1	251.5	-4	-1	-1	-1	113	2	7	-1	2	-1	-1	-1
83aa203	10	0	0	6	6	2010-03-25	2010-11-01	1-1 	10	-1	-1	U	-1	-1	223.5	-4	-1	-1	-1	127	2	7	-1	2	-1	-1	-1
83aa203	11	Whip Planting - 63 Whip, grew 76 planted 2' deep	0	1	1	2010-03-25	2010-11-01	DC  	160	-1	-1	U	-1	-1	193	-4	-1	-1	-1	127	2	7	-1	2	-1	-1	-1
76aa217	12	Whip Planting - 72 Whip, grew 48 planted 2' deep	0	1	1	2010-03-25	2010-11-01	DC  	183	-1	-1	U	-1	-1	121.9	-4	-1	-1	-1	124	2	7	-1	2	-1	-1	-1
83aa214	13	Whip Planting - 100 Whip, grew 37 planted 2' deep	0	1	1	2010-03-25	2010-11-01	DC  	254	-1	-1	U	-1	-1	94	-4	-1	-1	-1	2	140	7	-1	2	-1	-1	-1
83aa206	14	Whip Planting - 87 Whip, grew 40 planted 2' deep	0	1	1	2010-03-25	2010-11-01	DC  	221	-1	-1	U	-1	-1	101.6	-4	-1	-1	-1	129	2	7	-1	2	-1	-1	-1
83aa209	15	Whip Planting - 78 Whip, grew 33 planted 2' deep	0	1	1	2010-03-25	2010-11-01	DC  	199	-1	-1	Y	-1	-1	83.8	-4	-1	-1	-1	131	2	7	-1	2	-1	-1	-1
83aa211	16	Whip Planting - 89 Whip, grew 43 planted 2' deep	0	1	1	2010-03-25	2010-11-01	DC  	226	-1	-1	U	-1	-1	109.2	-4	-1	-1	-1	2	140	7	-1	2	-1	-1	-1
prince	17	suckers from source	0	4	4	2010-04-10	2010-11-01	1-0 	10	-1	-1	U	-1	-1	137.2	-4	-1	-1	-1	7	2	7	-1	3	-1	-1	-1
jamie	18	cuttings from RNE upper branches.  Used #16 IBA.	0	21	0	2010-04-10	2010-11-01	DC  	15	-1	-1	U	-1	-1	0	-4	-1	-1	-1	23	2	7	-1	3	-1	-1	-1
ebl	19	suckers from source, very bushy	0	2	2	2010-04-10	2010-11-01	1-0 	30	-1	-1	U	-1	-1	66	-4	-1	-1	-1	8	2	7	-1	3	-1	-1	-1
nfa	20	suckers from source, very bushy	0	2	2	2010-04-10	2010-11-01	1-0 	30	-1	-1	U	-1	-1	137.2	-4	-1	-1	-1	19	2	7	-1	3	-1	-1	-1
j2	21	suckers from source	0	1	1	2010-04-10	2010-11-01	1-0 	30	-1	-1	U	-1	-1	129.5	-4	-1	-1	-1	158	2	7	-1	3	-1	-1	-1
83aa206	22	0	0	1	1	2010-04-10	2010-11-01	1-0 	30	-1	-1	Y	-1	-1	195.6	-4	-1	-1	-1	129	2	7	-1	3	-1	-1	-1
83aa204	23	Best performing in this row. This clone did well as cuttings, very competitive.	0	1	1	2010-04-10	2010-11-01	1-0 	30	-1	-1	U	-1	-1	228.6	-4	-1	-1	-1	128	2	7	-1	3	-1	-1	-1
83aa202	24	NOT pip-202	0	1	1	2010-04-10	2010-11-01	1-0 	30	-1	-1	U	-1	-1	139.7	-4	-1	-1	-1	126	2	7	-1	3	-1	-1	-1
41aa111	25	A P3 Parent clone, need more...	0	10	1	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	25.4	-4	-1	-1	-1	138	2	7	-1	4	-1	-1	-1
nfa	26	0	0	54	8	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	81.3	-4	-1	-1	-1	19	2	7	-1	4	-1	-1	-1
ebl	27	0	0	26	8	2010-04-10	2010-11-01	DC  	15	-1	-1	U	-1	-1	81.3	-4	-1	-1	-1	8	2	7	-1	4	-1	-1	-1
a266	28	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	14	0	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	0	-4	-1	-1	-1	9	2	7	-1	4	-1	-1	-1
83aa204	29	Awesome! By far the best clone for cutting performance in 2010.  4 trees had height ranges from 103 to 88 and the first 2 cuttings (from South) had 20 mm diameters at the base.  This is tested as PIP-204 in 2009.	0	7	6	2010-04-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	228.6	-4	-1	-1	-1	128	2	7	-1	5	-1	-1	-1
pip58	30	nice	0	7	7	2010-04-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	139.7	-4	-1	-1	-1	2	140	7	-1	5	-1	-1	-1
83aa107	31	PIP-183, This was noted in 2009 for having aspen like bark, being greener and having much less tomentose.  It still applies in 2010.	0	6	4	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	91.4	-4	-1	-1	-1	137	2	7	-1	5	-1	-1	-1
pip202	32	Not 83AA202 !!	0	3	1	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	101.6	-4	-1	-1	-1	2	140	7	-1	5	-1	-1	-1
pip48	33	0	0	6	2	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	45.7	-4	-1	-1	-1	2	140	7	-1	5	-1	-1	-1
40aa6mf	34	Used #16 IBA	0	10	0	2010-04-10	2010-11-01	DC  	15	-1	-1	U	-1	-1	0	-4	-1	-1	-1	142	2	7	-1	5	-1	-1	-1
33aa11	35	0	0	6	0	2010-04-10	2010-11-01	DC  	15	-1	-1	U	-1	-1	0	-4	-1	-1	-1	139	2	7	-1	5	-1	-1	-1
aa4102	36	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	15	0	2010-04-10	2010-11-01	DC  	15	-1	-1	U	-1	-1	0	-4	-1	-1	-1	35	2	7	-1	5	-1	-1	-1
pip206	37	NOT 83AA206 !!	0	8	2	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	121.9	-4	-1	-1	-1	2	140	7	-1	6	-1	-1	-1
pip203	38	NOT 83AA203 !!	0	10	2	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	78.7	-4	-1	-1	-1	2	140	7	-1	6	-1	-1	-1
83aa206	39	NOT PIP-206	0	21	14	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	111.8	-4	-1	-1	-1	129	2	7	-1	6	-1	-1	-1
83aa203	40	PIP-2010 control clone - 95BC, 43BC, 87C, 97A, 74A, 21A	0	32	20	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	76.2	-4	-1	-1	-1	127	2	7	-1	6	-1	-1	-1
83aa209	41	Noted for its vigor/poor rooting. had 18% rooting in 2009	0	16	9	2010-04-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	139.7	-4	-1	-1	-1	131	2	7	-1	6	-1	-1	-1
83aa217	42	0	0	13	6	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	73.7	-4	-1	-1	-1	2	140	7	-1	6	-1	-1	-1
83aa214	43	0	0	20	10	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	71.1	-4	-1	-1	-1	2	140	7	-1	6	-1	-1	-1
pip63	44	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	5	2	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	48.3	-4	-1	-1	-1	2	140	7	-1	6	-1	-1	-1
pip189	45	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results.  This had the #1 PIP score in 2009.	0	4	1	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	58.4	-4	-1	-1	-1	2	140	7	-1	6	-1	-1	-1
pip190	46	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	4	0	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	0	-4	-1	-1	-1	2	140	7	-1	6	-1	-1	-1
pip181	47	0	0	16	11	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	96.5	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip187	48	Not found in PIP spreadsheet, could it be 188?	0	10	9	2010-04-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	149.9	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip197	49	0	0	10	5	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	78.7	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip193	50	0	0	9	3	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	61	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip206	51	0	0	7	3	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	121.9	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip196	52	0	0	11	4	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	101.6	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip182	53	0	0	13	11	2010-04-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	119.4	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip184	54	0	0	9	4	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	83.8	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip194	55	0	0	14	8	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	96.5	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip200	56	0	0	10	6	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	73.7	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip199	57	Yellow tagged	0	10	8	2010-04-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	96.5	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip195	58	0	0	12	6	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	94	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip185	59	0	0	11	5	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	76.2	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip186	60	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	12	2	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	50.8	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip198	61	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	11	0	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	0	-4	-1	-1	-1	2	140	7	-1	7	-1	-1	-1
pip180	62	0	0	11	9	2010-04-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	137.2	-4	-1	-1	-1	2	140	7	-1	8	-1	-1	-1
pip164	63	0	0	15	12	2010-04-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	137.2	-4	-1	-1	-1	2	140	7	-1	8	-1	-1	-1
pip171	64	0	0	16	12	2010-04-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	114.3	-4	-1	-1	-1	2	140	7	-1	8	-1	-1	-1
pip170	65	0	0	12	8	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	68.6	-4	-1	-1	-1	2	140	7	-1	8	-1	-1	-1
pip175	66	0	0	14	7	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	83.8	-4	-1	-1	-1	2	140	7	-1	8	-1	-1	-1
pip154	67	0	0	16	9	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	71.1	-4	-1	-1	-1	2	140	7	-1	8	-1	-1	-1
pip176	68	0	0	10	3	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	58.4	-4	-1	-1	-1	2	140	7	-1	8	-1	-1	-1
pip173	69	0	0	16	9	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	81.3	-4	-1	-1	-1	2	140	7	-1	8	-1	-1	-1
pip172	70	0	0	10	5	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	76.2	-4	-1	-1	-1	2	140	7	-1	8	-1	-1	-1
pip156	71	0	0	13	5	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	50.8	-4	-1	-1	-1	2	140	7	-1	8	-1	-1	-1
pip191	72	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	8	1	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	48.3	-4	-1	-1	-1	2	140	7	-1	8	-1	-1	-1
pip201	73	0	0	7	3	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	58.4	-4	-1	-1	-1	2	140	7	-1	8	-1	-1	-1
pip188	74	0	0	8	0	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	0	-4	-1	-1	-1	2	140	7	-1	8	-1	-1	-1
pip159	75	Check this for selection??	0	11	10	2010-04-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	76.2	-4	-1	-1	-1	2	140	7	-1	9	-1	-1	-1
pip160	76	0	0	18	16	2010-04-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	101.6	-4	-1	-1	-1	2	140	7	-1	9	-1	-1	-1
pip161	77	0	0	14	6	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	58.4	-4	-1	-1	-1	2	140	7	-1	9	-1	-1	-1
pip168	78	0	0	12	11	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	71.1	-4	-1	-1	-1	2	140	7	-1	9	-1	-1	-1
pip177	79	0	0	13	10	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	63.5	-4	-1	-1	-1	2	140	7	-1	9	-1	-1	-1
pip162	80	0	0	16	14	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	86.4	-4	-1	-1	-1	2	140	7	-1	9	-1	-1	-1
pip167	81	0	0	11	5	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	81.3	-4	-1	-1	-1	2	140	7	-1	9	-1	-1	-1
pip174	82	0	0	13	10	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	91.4	-4	-1	-1	-1	2	140	7	-1	9	-1	-1	-1
pip178	83	0	0	12	1	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	78.7	-4	-1	-1	-1	2	140	7	-1	9	-1	-1	-1
pip166	84	83xA166 - Strong early performer that was cut back to make more cuttings indoors (ASP tests)	0	11	9	2010-04-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	71.1	-4	-1	-1	-1	2	140	7	-1	9	-1	-1	-1
pip179	85	0	0	13	1	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	91.4	-4	-1	-1	-1	2	140	7	-1	9	-1	-1	-1
pip87	86	0	0	12	7	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	66	-4	-1	-1	-1	2	140	7	-1	10	-1	-1	-1
pip69	87	0	0	11	7	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	94	-4	-1	-1	-1	2	140	7	-1	10	-1	-1	-1
pip74	88	0	0	17	14	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	101.6	-4	-1	-1	-1	2	140	7	-1	10	-1	-1	-1
pip157	89	0	0	10	9	2010-04-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	83.8	-4	-1	-1	-1	2	140	7	-1	10	-1	-1	-1
pip153	90	0	0	11	7	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	58.4	-4	-1	-1	-1	2	140	7	-1	10	-1	-1	-1
pip155	91	0	0	11	8	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	78.7	-4	-1	-1	-1	2	140	7	-1	10	-1	-1	-1
pip151	92	0	0	8	6	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	94	-4	-1	-1	-1	2	140	7	-1	10	-1	-1	-1
pip165	93	0	0	14	7	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	63.5	-4	-1	-1	-1	2	140	7	-1	10	-1	-1	-1
pip163	94	0	0	16	9	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	101.6	-4	-1	-1	-1	2	140	7	-1	10	-1	-1	-1
pip152	95	0	0	14	5	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	91.4	-4	-1	-1	-1	2	140	7	-1	10	-1	-1	-1
pip158	96	0	0	15	5	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	83.8	-4	-1	-1	-1	2	140	7	-1	10	-1	-1	-1
pip169	97	0	0	15	4	2010-04-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	73.7	-4	-1	-1	-1	2	140	7	-1	10	-1	-1	-1
83xaa107	98	Stock Started as ASP material. Tallest is 113	0	16	16	2010-04-10	2010-11-01	ASP 	10	-1	-1	Y	-1	-1	139.7	-4	-1	-1	-1	137	2	7	-1	11	-1	-1	-1
zoss	99	This is likely an AG or canescens clone	0	3	3	2010-04-10	2010-11-01	ASP 	10	-1	-1	Y	-1	-1	111.8	-4	-1	-1	-1	157	2	7	-1	11	-1	-1	-1
83aa2mf	100	0	0	2	2	2010-04-10	2010-11-01	ASP 	10	-1	-1	U	-1	-1	0	-4	-1	-1	-1	144	2	7	-1	11	-1	-1	-1
83aa1mf	101	0	0	5	5	2010-04-10	2010-11-01	ASP 	10	-1	-1	U	-1	-1	121.9	-4	-1	-1	-1	143	2	7	-1	11	-1	-1	-1
40aa6mf	102	0	0	2	2	2010-04-10	2010-11-01	ASP 	10	-1	-1	U	-1	-1	154.9	-4	-1	-1	-1	142	2	7	-1	11	-1	-1	-1
83aa1mf	103	0	0	2	1	2010-04-10	2010-11-01	ASP 	10	-1	-1	U	-1	-1	198.1	-4	-1	-1	-1	143	2	7	-1	11	-1	-1	-1
100aa01	104	Planted in Summer	0	14	14	2010-04-10	2010-11-01	ASP 	10	-1	-1	Y	-1	-1	101.6	-4	-1	-1	-1	153	2	7	-1	12	-1	-1	-1
100xaa10	105	tallest=89 quite branchy	0	14	63	2010-04-10	2010-11-01	SEL 	10	-1	-1	U	-1	-1	101.6	-4	-1	-1	-1	2	158	7	-1	12	-1	-1	-1
100aa04	106	0	0	15	11	2010-04-10	2010-11-01	SEL 	10	-1	-1	Y	-1	-1	91.4	-4	-1	-1	-1	156	2	7	-1	13	-1	-1	-1
100aa03	107	0	0	12	12	2010-04-10	2010-11-01	SEL 	10	-1	-1	Y	-1	-1	101.6	-4	-1	-1	-1	155	2	7	-1	13	-1	-1	-1
100aa02	108	0	0	9	9	2010-04-10	2010-11-01	SEL 	10	-1	-1	Y	-1	-1	78.7	-4	-1	-1	-1	154	2	7	-1	13	-1	-1	-1
100xaa10	109	tallest=49, SASP rejects	0	100	6	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	76.2	-4	-1	-1	-1	2	158	8	-1	7	-1	-1	-1
87xaa10	110	tallest=53	0	60	48	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	96.5	-4	-1	-1	-1	2	164	8	-1	7	-1	-1	-1
101xaa10	111	tallest=48	0	60	33	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	96.5	-4	-1	-1	-1	2	156	8	-1	7	-1	-1	-1
102xaa10	112	tallest=30	0	30	16	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	99.1	-4	-1	-1	-1	2	168	8	-1	7	-1	-1	-1
91xaa10	113	tallest=58	0	75	54	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	88.9	-4	-1	-1	-1	2	154	8	-1	7	-1	-1	-1
91xaa10	114	tallest=54	0	75	32	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	83.8	-4	-1	-1	-1	2	154	8	-1	8	-1	-1	-1
98xaa10	115	tallest=53	0	150	75	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	83.8	-4	-1	-1	-1	2	155	8	-1	8	-1	-1	-1
100xaa10	116	tallest=58	0	100	75	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	101.6	-4	-1	-1	-1	2	158	8	-1	8	-1	-1	-1
104xaa10	117	tallest=61	0	100	105	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	104.1	-4	-1	-1	-1	2	169	8	-1	8	-1	-1	-1
104xaa10	118	tallest=54	0	100	18	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	104.1	-4	-1	-1	-1	2	169	8	-1	9	-1	-1	-1
103xaa10	119	tallest=60	0	150	120	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	91.4	-4	-1	-1	-1	2	170	8	-1	9	-1	-1	-1
97xaa10	120	tallest=66	0	160	120	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	101.6	-4	-1	-1	-1	2	159	8	-1	9	-1	-1	-1
86xaa10	121	tallest=60	0	160	150	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	101.6	-4	-1	-1	-1	2	167	8	-1	10	-1	-1	-1
93xaa10	122	tallest=71	0	250	120	2010-06-19	2010-11-01	SEL 	10	-1	-1	Y	-1	-1	101.6	-4	-1	-1	-1	2	166	8	-1	10	-1	-1	-1
93xaa10	123	tallest=56	0	250	195	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	109.2	-4	-1	-1	-1	2	166	8	-1	11	-1	-1	-1
94xaa10	124	tallest=59	0	100	75	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	99.1	-4	-1	-1	-1	2	161	8	-1	11	-1	-1	-1
94xaa10	125	tallest=60	0	100	90	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	96.5	-4	-1	-1	-1	2	161	8	-1	12	-1	-1	-1
99xaa10	126	tallest=67	0	200	120	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	101.6	-4	-1	-1	-1	2	157	8	-1	12	-1	-1	-1
96xaa10	127	tallest=57	0	75	27	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	99.1	-4	-1	-1	-1	2	157	8	-1	12	-1	-1	-1
96xaa10	128	tallest=63	0	75	60	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	106.7	-4	-1	-1	-1	2	160	8	-1	13	-1	-1	-1
89xaa10	129	tallest=66 (6 @ 66)	0	300	225	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	104.1	-4	-1	-1	-1	2	153	8	-1	13	-1	-1	-1
92xaa10	130	tallest=64 (drought loss)	0	200	160	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	96.5	-4	-1	-1	-1	2	152	8	-1	14	-1	-1	-1
90xaa10	131	tallest=60	0	125	60	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	96.5	-4	-1	-1	-1	2	165	8	-1	14	-1	-1	-1
90xaa10	132	tallest=56 (1 with variagated leaves)	0	125	120	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	96.5	-4	-1	-1	-1	2	165	8	-1	15	-1	-1	-1
95xaa10	133	tallest=54	0	60	75	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	94	-4	-1	-1	-1	2	162	8	-1	15	-1	-1	-1
88xaa10	134	tallest=58	0	150	105	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	104.1	-4	-1	-1	-1	2	163	8	-1	15	-1	-1	-1
88xaa10	135	tallest=64	0	150	135	2010-06-19	2010-11-01	SEL 	10	-1	-1	U	-1	-1	96.5	-4	-1	-1	-1	2	163	8	-1	16	-1	-1	-1
76xaa02	136	Seed was frozen till 2007. 1-1 stock South to North. Tallest was #5 - 85.  See PIP notes for #'s 5,7,8,9,11	0	11	11	2008-04-01	2008-11-01	SEL 	15	-1	-1	U	-1	-1	137.2	-4	-1	-1	-1	2	129	4	-1	-1	-1	-1	-1
76xaa02	137	0	0	6	2	2008-04-01	2008-11-01	SEL 	15	-1	-1	U	-1	-1	132.1	-4	-1	-1	-1	2	129	4	-1	-1	-1	-1	-1
76xaa02	138	0	0	4	1	2008-04-01	2008-11-01	SEL 	15	-1	-1	U	-1	-1	61	-4	-1	-1	-1	2	129	4	-1	-1	-1	-1	-1
76xaa02	139	0	0	4	2	2008-04-01	2008-11-01	SEL 	15	-1	-1	U	-1	-1	71.1	-4	-1	-1	-1	2	129	4	-1	-1	-1	-1	-1
76xaa02	140	Wide crown? Close nodes. One was 85!  	0	4	4	2008-04-01	2008-11-01	SEL 	15	-1	-1	U	-1	-1	127	-4	-1	-1	-1	2	129	4	-1	-1	-1	-1	-1
76xaa02	141	Fastigate?  Was 	0	4	1	2008-04-01	2008-11-01	SEL 	15	-1	-1	U	-1	-1	167.6	-4	-1	-1	-1	2	129	4	-1	-1	-1	-1	-1
76xaa02	142	Fastigate?	0	4	3	2008-04-01	2008-11-01	SEL 	15	-1	-1	U	-1	-1	127	-4	-1	-1	-1	2	129	4	-1	-1	-1	-1	-1
76xaa02	143	Fastigate?	0	4	1	2008-04-01	2008-11-01	SEL 	15	-1	-1	U	-1	-1	66	-4	-1	-1	-1	2	129	4	-1	-1	-1	-1	-1
83xaa04	144	These were part of 200 (1 flat) seedlings, lanted 20 - 13 survived.  The ID numbers here were carried over to the PIP tests...	0	20	13	2008-04-01	2008-11-01	SEL 	10	-1	-1	U	-1	-1	121.9	-4	-1	-1	-1	2	140	4	-1	-1	-1	-1	-1
83xaa04	145	0	0	1	1	2008-04-01	2008-11-01	SEL 	10	-1	-1	U	-1	-1	66	-4	-1	-1	-1	2	140	3	-1	-1	-1	-1	-1
83aa203	146	May be PIP #3	0	1	1	2008-04-01	2008-11-01	SEL 	10	-1	-1	U	-1	-1	129.5	-4	-1	-1	-1	127	2	3	-1	-1	-1	-1	-1
83xaa04	147	0	0	1	1	2008-04-01	2008-11-01	SEL 	10	-1	-1	U	-1	-1	101.6	-4	-1	-1	-1	2	140	3	-1	-1	-1	-1	-1
83xaa04	148	May be PIP #5	0	1	1	2008-04-01	2008-11-01	SEL 	10	-1	-1	U	-1	-1	119.4	-4	-1	-1	-1	2	140	3	-1	-1	-1	-1	-1
83xaa04	149	0	0	1	1	2008-04-01	2008-11-01	SEL 	10	-1	-1	U	-1	-1	101.6	-4	-1	-1	-1	2	140	3	-1	-1	-1	-1	-1
83xaa04	150	0	0	1	1	2008-04-01	2008-11-01	SEL 	10	-1	-1	U	-1	-1	99.1	-4	-1	-1	-1	2	140	3	-1	-1	-1	-1	-1
83aa208	151	0	0	1	1	2008-04-01	2008-11-01	SEL 	10	-1	-1	U	-1	-1	99.1	-4	-1	-1	-1	130	2	3	-1	-1	-1	-1	-1
83xaa04	152	May be PIP #9	0	1	1	2008-04-01	2008-11-01	SEL 	10	-1	-1	U	-1	-1	182.9	-4	-1	-1	-1	2	140	3	-1	-1	-1	-1	-1
83xaa04	153	0	0	1	1	2008-04-01	2008-11-01	SEL 	10	-1	-1	U	-1	-1	61	-4	-1	-1	-1	2	140	3	-1	-1	-1	-1	-1
83xaa04	154	0	0	1	1	2008-04-01	2008-11-01	SEL 	10	-1	-1	U	-1	-1	94	-4	-1	-1	-1	2	140	3	-1	-1	-1	-1	-1
83xaa04	155	0	0	1	1	2008-04-01	2008-11-01	SEL 	10	-1	-1	U	-1	-1	83.8	-4	-1	-1	-1	2	140	3	-1	-1	-1	-1	-1
83xaa04	156	0	0	1	1	2008-04-01	2008-11-01	SEL 	10	-1	-1	U	-1	-1	81.3	-4	-1	-1	-1	2	140	3	-1	-1	-1	-1	-1
76aa218	157	PIP09-T5=0	0	10	2	2009-04-04	2009-11-01	DC  	10	-1	-1	U	-1	-1	91.4	-4	-1	-1	-1	161	2	6	-1	-1	-1	-1	-1
76aa217	158	Nice - vigorous, PIP09-T5=18	0	20	12	2009-04-04	2009-11-01	DC  	10	-1	-1	U	-1	-1	76.2	-4	-1	-1	-1	124	2	6	-1	-1	-1	-1	-1
76aa214	159	PIP09-T5=4	0	10	6	2009-04-04	2009-11-01	DC  	10	-1	-1	U	-1	-1	127	-4	-1	-1	-1	123	2	6	-1	-1	-1	-1	-1
76aa211	160	Short 1-0 parent stock, PIP09-T5=16	0	10	4	2009-04-04	2009-11-01	DC  	10	-1	-1	U	-1	-1	91.4	-4	-1	-1	-1	160	2	6	-1	-1	-1	-1	-1
76aa205	161	PIP09-T5=46	0	12	7	2009-04-04	2009-11-01	DC  	10	-1	-1	U	-1	-1	121.9	-4	-1	-1	-1	159	2	6	-1	-1	-1	-1	-1
83aa209	162	Huge 1-0 parent stock, Large leaves, wavy, syliptic, PIP09-T5=28	0	11	2	2009-04-04	2009-11-01	DC  	10	-1	-1	U	-1	-1	157.5	-4	-1	-1	-1	131	2	6	-1	-1	-1	-1	-1
83aa208	163	PIP09-T5=70	0	4	2	2009-04-04	2009-11-01	DC  	10	-1	-1	U	-1	-1	88.9	-4	-1	-1	-1	130	2	6	-1	-1	-1	-1	-1
83aa206	164	NIce! Tallest=81, 100% rooting if 4 is counted.  PIP09-T5=100	0	4	3	2009-04-04	2009-11-01	DC  	10	-1	-1	U	-1	-1	121.9	-4	-1	-1	-1	129	2	6	-1	-1	-1	-1	-1
83aa203	165	Dark green leaves - Bugs like leaves...  The PIP-09-T5 test had incredible callus cluster roots at cutting base.  PIP09-T5=66	0	6	5	2009-04-04	2009-11-01	DC  	10	-1	-1	U	-1	-1	142.2	-4	-1	-1	-1	127	2	6	-1	-1	-1	-1	-1
pip120	166	Tallest=31 Dia 5-9mm (Dykema PIP cuttings)	0	11	11	2010-05-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	22	-4	-1	-1	-1	2	140	8	-1	3	-1	-1	-1
pip101	167	Tallest=32   (Dykema PIP cuttings)	0	12	9	2010-05-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	25	-4	-1	-1	-1	2	140	8	-1	3	-1	-1	-1
pip115	168	Tallest=37   (Dykema PIP cuttings)	0	12	10	2010-05-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	24	-4	-1	-1	-1	2	140	8	-1	3	-1	-1	-1
pip129	169	Tallest=37   (Dykema PIP cuttings)	0	14	11	2010-05-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	23	-4	-1	-1	-1	2	140	8	-1	3	-1	-1	-1
pip37	170	Tallest=43   (Dykema PIP cuttings)	0	15	10	2010-05-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	33	-4	-1	-1	-1	2	140	8	-1	4	-1	-1	-1
pip31	171	Tallest=37   (Dykema PIP cuttings)	0	14	11	2010-05-10	2010-11-01	DC  	10	-1	-1	Y	-1	-1	29	-4	-1	-1	-1	2	140	8	-1	4	-1	-1	-1
pip9	172	Tallest=49 biased  (Dykema PIP cuttings)	0	11	8	2010-05-10	2010-11-01	DC  	10	-1	-1	U	-1	-1	31	-4	-1	-1	-1	2	140	8	-1	5	-1	-1	-1
93xaa10	173	Flat 2 all 1-0 stock (select 2)	0	12	10	2011-04-17	2011-09-01	1-0 	15	4	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	3	-1	-1	-1
83aa221	174	PIP120 ? Check notes (select 2)	0	12	12	2011-04-17	2011-09-01	1-0 	30	4	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	4	-1	-1	-1
90aa101	175	Variegated 10% on 5/26/11 (Reverted)	0	1	1	2011-04-17	2011-09-01	1-0 	40	5	-1	N	-1	-1	-1	-4	-1	-1	-1	147	2	13	-1	5	-1	-1	-1
94aa101	176	Variegated 50% on 5/26/11, 50% on 9/1/11	0	1	1	2011-04-17	2011-09-01	1-0 	40	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	148	2	13	-1	6	-1	-1	-1
87aa101	177	Variegated 0% on 5/26/11 looked dead.  (Reverted)	0	1	1	2011-04-17	2011-09-01	1-0 	30	4	-1	N	-1	-1	-1	-4	-1	-1	-1	146	2	13	-1	7	-1	-1	-1
88xaa10	178	Nice 5/26/11 Begin Row (right side)	0	6	2	2011-04-17	2011-09-01	DC  	15	14	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	8	-1	-1	-1
88xaa10	179	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	9	-1	-1	-1
88xaa10	180	0	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	10	-1	-1	-1
88xaa10	181	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	11	-1	-1	-1
88xaa10	182	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	12	-1	-1	-1
88xaa10	183	0	0	5	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	13	-1	-1	-1
88xaa10	184	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	14	-1	-1	-1
88xaa10	185	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	15	-1	-1	-1
88xaa10	186	0	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	16	-1	-1	-1
88xaa10	187	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	17	-1	-1	-1
88xaa10	188	0	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	18	-1	-1	-1
88xaa10	189	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	19	-1	-1	-1
88xaa10	190	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	20	-1	-1	-1
88xaa10	191	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	21	-1	-1	-1
88xaa10	192	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	22	-1	-1	-1
88xaa10	193	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	23	-1	-1	-1
88xaa10	194	end row	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	24	-1	-1	-1
88xaa10	195	begin row	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	25	-1	-1	-1
88xaa10	196	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	26	-1	-1	-1
88xaa10	197	0	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	27	-1	-1	-1
88xaa10	198	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	28	-1	-1	-1
88xaa10	199	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	29	-1	-1	-1
88xaa10	200	0	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	30	-1	-1	-1
88xaa10	201	0	0	6	1	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	31	-1	-1	-1
88xaa10	202	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	32	-1	-1	-1
88xaa10	203	0	0	5	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	33	-1	-1	-1
88xaa10	204	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	34	-1	-1	-1
88xaa10	205	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	35	-1	-1	-1
88xaa10	206	0	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	36	-1	-1	-1
88xaa10	207	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	37	-1	-1	-1
88xaa10	208	0	0	5	1	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	38	-1	-1	-1
88xaa10	209	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	163	13	-1	39	-1	-1	-1
89xaa10	210	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	40	-1	-1	-1
89xaa10	211	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	41	-1	-1	-1
89xaa10	212	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	5	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	42	-1	-1	-1
89xaa10	213	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	43	-1	-1	-1
89xaa10	214	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	44	-1	-1	-1
89xaa10	215	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	45	-1	-1	-1
89xaa10	216	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	46	-1	-1	-1
89xaa10	217	0	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	47	-1	-1	-1
89xaa10	218	end row	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	48	-1	-1	-1
89xaa10	219	begin row	0	6	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	49	-1	-1	-1
89xaa10	220	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	50	-1	-1	-1
89xaa10	221	0	0	5	1	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	51	-1	-1	-1
89xaa10	222	0	0	5	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	52	-1	-1	-1
89xaa10	223	0	0	6	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	53	-1	-1	-1
89xaa10	224	0	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	54	-1	-1	-1
89xaa10	225	0	0	5	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	55	-1	-1	-1
89xaa10	226	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	56	-1	-1	-1
89xaa10	227	0	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	57	-1	-1	-1
89xaa10	228	0	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	1	-1	-1	-1
89xaa10	229	0	0	5	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	2	-1	-1	-1
89xaa10	230	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	3	-1	-1	-1
89xaa10	231	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	4	-1	-1	-1
89xaa10	232	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	5	-1	-1	-1
89xaa10	233	end row	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	6	-1	-1	-1
89xaa10	234	begin row	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	7	-1	-1	-1
89xaa10	235	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	8	-1	-1	-1
89xaa10	236	0	0	5	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	9	-1	-1	-1
89xaa10	237	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	10	-1	-1	-1
89xaa10	238	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	153	13	-1	11	-1	-1	-1
91xaa10	239	0	0	7	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	12	-1	-1	-1
91xaa10	240	0	0	7	6	2011-04-17	2011-09-01	DC  	-1	8	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	13	-1	-1	-1
91xaa10	241	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	14	-1	-1	-1
91xaa10	242	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	15	-1	-1	-1
91xaa10	243	0	0	4	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	16	-1	-1	-1
91xaa10	244	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	17	-1	-1	-1
91xaa10	245	0	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	18	-1	-1	-1
91xaa10	246	0	0	4	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	19	-1	-1	-1
91xaa10	247	0	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	20	-1	-1	-1
91xaa10	248	0	0	5	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	21	-1	-1	-1
91xaa10	249	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	22	-1	-1	-1
91xaa10	250	0	0	5	0	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	23	-1	-1	-1
91xaa10	251	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	24	-1	-1	-1
91xaa10	252	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	25	-1	-1	-1
91xaa10	253	0	0	5	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	26	-1	-1	-1
91xaa10	254	end row	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	27	-1	-1	-1
91xaa10	255	begin row	0	7	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	28	-1	-1	-1
91xaa10	256	0	0	5	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	29	-1	-1	-1
91xaa10	257	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	30	-1	-1	-1
91xaa10	258	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	31	-1	-1	-1
91xaa10	259	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	32	-1	-1	-1
91xaa10	260	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	33	-1	-1	-1
91xaa10	261	Best family selection	0	6	6	2011-04-17	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	34	-1	-1	-1
91xaa10	262	0	0	4	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	35	-1	-1	-1
91xaa10	263	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	4	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	36	-1	-1	-1
91xaa10	264	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	37	-1	-1	-1
91xaa10	265	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	38	-1	-1	-1
91xaa10	266	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	39	-1	-1	-1
91xaa10	267	0	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	40	-1	-1	-1
91xaa10	268	0	0	4	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	154	13	-1	41	-1	-1	-1
99xaa10	269	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	42	-1	-1	-1
99xaa10	270	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	43	-1	-1	-1
99xaa10	271	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	44	-1	-1	-1
99xaa10	272	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	45	-1	-1	-1
99xaa10	273	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	46	-1	-1	-1
99xaa10	274	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	4	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	47	-1	-1	-1
99xaa10	275	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	48	-1	-1	-1
99xaa10	276	0	0	4	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	49	-1	-1	-1
99xaa10	277	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	50	-1	-1	-1
99xaa10	278	0	0	7	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	51	-1	-1	-1
99xaa10	279	0	0	2	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	52	-1	-1	-1
99xaa10	280	0	0	5	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	53	-1	-1	-1
99xaa10	281	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	54	-1	-1	-1
99xaa10	282	end row	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	55	-1	-1	-1
99xaa10	283	begin row	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	56	-1	-1	-1
99xaa10	284	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	57	-1	-1	-1
99xaa10	285	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	58	-1	-1	-1
99xaa10	286	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	59	-1	-1	-1
99xaa10	287	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	60	-1	-1	-1
99xaa10	288	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	61	-1	-1	-1
99xaa10	289	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	62	-1	-1	-1
99xaa10	290	0	0	6	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	63	-1	-1	-1
99xaa10	291	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	64	-1	-1	-1
99xaa10	292	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	65	-1	-1	-1
99xaa10	293	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	66	-1	-1	-1
99xaa10	294	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	67	-1	-1	-1
99xaa10	295	0	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	68	-1	-1	-1
99xaa10	296	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	69	-1	-1	-1
99xaa10	297	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	157	13	-1	70	-1	-1	-1
87xaa10	298	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	6	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	71	-1	-1	-1
87xaa10	299	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	72	-1	-1	-1
87xaa10	300	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	73	-1	-1	-1
87xaa10	301	0	0	6	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	74	-1	-1	-1
87xaa10	302	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	75	-1	-1	-1
87xaa10	303	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	5	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	76	-1	-1	-1
87xaa10	304	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	77	-1	-1	-1
87xaa10	305	0	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	78	-1	-1	-1
87xaa10	306	end row	0	6	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	79	-1	-1	-1
87xaa10	307	begin row	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	80	-1	-1	-1
87xaa10	308	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	81	-1	-1	-1
87xaa10	309	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	82	-1	-1	-1
87xaa10	310	0	0	4	1	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	83	-1	-1	-1
87xaa10	311	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	84	-1	-1	-1
87xaa10	312	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	85	-1	-1	-1
87xaa10	313	0	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	86	-1	-1	-1
87xaa10	314	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	164	13	-1	87	-1	-1	-1
100xaa10	315	Cutting stock from Dykema 2010	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	1	-1	-1	-1
100xaa10	316	Cutting stock from Dykema 2010	0	6	6	2011-04-17	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	2	-1	-1	-1
100xaa10	317	Cutting stock from Dykema 2010	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	3	-1	-1	-1
100xaa10	318	Cutting stock from Dykema 2010	0	6	6	2011-04-17	2011-09-01	DC  	-1	6	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	4	-1	-1	-1
100xaa10	319	Cutting stock from Dykema 2010	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	5	-1	-1	-1
100xaa10	320	Cutting stock from Dykema 2010	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	6	-1	-1	-1
100xaa10	321	Cutting stock from Dykema 2010	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	7	-1	-1	-1
100xaa10	322	Cutting stock from Dykema 2010	0	5	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	8	-1	-1	-1
100xaa10	323	PRAVL - Stock from Dykema 2010	PRAVL	6	6	2011-04-17	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	9	-1	-1	-1
100xaa10	324	Cutting stock from Dykema 2010	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	10	-1	-1	-1
100xaa10	325	Cutting stock from Dykema 2010	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	11	-1	-1	-1
100xaa10	326	Cutting stock from Dykema 2010	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	12	-1	-1	-1
100xaa10	327	Cutting stock from Dykema 2010	0	6	6	2011-04-17	2011-09-01	DC  	-1	11	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	13	-1	-1	-1
100xaa10	328	end row	0	5	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	14	-1	-1	-1
100xaa10	329	begin row	0	6	6	2011-04-17	2011-09-01	DC  	-1	11	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	15	-1	-1	-1
100xaa10	330	Cutting stock from Dykema 2010	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	16	-1	-1	-1
100xaa10	331	Cutting stock from Dykema 2010	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	17	-1	-1	-1
100xaa10	332	Cutting stock from Dykema 2010	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	18	-1	-1	-1
100xaa10	333	Cutting stock from Dykema 2010	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	19	-1	-1	-1
100xaa10	334	Cutting stock from Dykema 2010	0	6	6	2011-04-17	2011-09-01	DC  	-1	6	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	20	-1	-1	-1
100xaa10	335	Cutting stock from Dykema 2010	0	6	4	2011-04-17	2011-09-01	DC  	-1	7	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	21	-1	-1	-1
100xaa10	336	Cutting stock from Dykema 2010	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	22	-1	-1	-1
100xaa10	337	Cutting stock from Dykema 2010	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	23	-1	-1	-1
100xaa10	338	Cutting stock from Dykema 2010	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	24	-1	-1	-1
100xaa10	339	Cutting stock from Dykema 2010	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	25	-1	-1	-1
100xaa10	340	Cutting stock from Dykema 2010	0	5	5	2011-04-17	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	26	-1	-1	-1
100xaa10	341	Cutting stock from Dykema 2010	0	5	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	27	-1	-1	-1
100xaa10	342	Cutting stock from Dykema 2010	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	28	-1	-1	-1
100xaa10	343	Cutting stock from Dykema 2010	0	4	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	29	-1	-1	-1
95xaa10	344	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	12	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	30	-1	-1	-1
95xaa10	345	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	8	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	31	-1	-1	-1
95xaa10	346	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	32	-1	-1	-1
95xaa10	347	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	33	-1	-1	-1
95xaa10	348	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	34	-1	-1	-1
95xaa10	349	0	0	5	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	35	-1	-1	-1
95xaa10	350	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	36	-1	-1	-1
95xaa10	351	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	37	-1	-1	-1
95xaa10	352	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	38	-1	-1	-1
95xaa10	353	0	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	39	-1	-1	-1
95xaa10	354	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	40	-1	-1	-1
95xaa10	355	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	41	-1	-1	-1
95xaa10	356	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	42	-1	-1	-1
95xaa10	357	0	0	6	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	43	-1	-1	-1
95xaa10	358	end row	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	44	-1	-1	-1
95xaa10	359	begin row	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	45	-1	-1	-1
95xaa10	360	0	0	6	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	46	-1	-1	-1
95xaa10	361	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	47	-1	-1	-1
95xaa10	362	0	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	48	-1	-1	-1
95xaa10	363	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	49	-1	-1	-1
95xaa10	364	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	50	-1	-1	-1
95xaa10	365	0	0	6	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	51	-1	-1	-1
95xaa10	366	0	0	5	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	52	-1	-1	-1
95xaa10	367	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	53	-1	-1	-1
95xaa10	368	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	54	-1	-1	-1
95xaa10	369	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	55	-1	-1	-1
95xaa10	370	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	4	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	56	-1	-1	-1
95xaa10	371	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	57	-1	-1	-1
95xaa10	372	0	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	58	-1	-1	-1
95xaa10	373	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	162	13	-1	59	-1	-1	-1
102xaa10	374	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	168	13	-1	60	-1	-1	-1
102xaa10	375	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	168	13	-1	61	-1	-1	-1
102xaa10	376	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	12	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	168	13	-1	62	-1	-1	-1
102xaa10	377	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	168	13	-1	63	-1	-1	-1
102xaa10	378	0	0	6	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	168	13	-1	64	-1	-1	-1
102xaa10	379	end row	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	168	13	-1	65	-1	-1	-1
102xaa10	380	begin row	0	6	5	2011-04-17	2011-09-01	DC  	-1	8	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	168	13	-1	66	-1	-1	-1
102xaa10	381	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	168	13	-1	67	-1	-1	-1
102xaa10	382	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	168	13	-1	68	-1	-1	-1
102xaa10	383	0	0	5	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	168	13	-1	69	-1	-1	-1
102xaa10	384	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	4	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	168	13	-1	70	-1	-1	-1
102xaa10	385	0	0	6	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	168	13	-1	71	-1	-1	-1
102xaa10	386	0	0	5	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	168	13	-1	72	-1	-1	-1
101xaa10	387	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	73	-1	-1	-1
101xaa10	388	0	0	4	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	74	-1	-1	-1
101xaa10	389	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	75	-1	-1	-1
101xaa10	390	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	76	-1	-1	-1
101xaa10	391	end row	0	5	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	77	-1	-1	-1
101xaa10	392	begin row	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	78	-1	-1	-1
101xaa10	393	0	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	79	-1	-1	-1
101xaa10	394	0	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	80	-1	-1	-1
101xaa10	395	0	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	81	-1	-1	-1
101xaa10	396	0	0	4	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	82	-1	-1	-1
83aa204	397	Vigorous clone, not the best rooter.	0	7	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	246	-4	-1	-1	-1	128	2	13	-1	1	-1	-1	-1
83aa204	398	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	246	-4	-1	-1	-1	128	2	13	-1	2	-1	-1	-1
83aa215	399	Nice, Get 2010 source details	0	11	10	2011-04-17	2011-09-01	DC  	-1	12	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	3	-1	-1	-1
83aa215	400	Nice, Get 2010 source details	0	8	6	2011-04-17	2011-09-01	DC  	-1	13	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	4	-1	-1	-1
83aa212	401	Nice, Get 2010 source details	0	9	9	2011-04-17	2011-09-01	DC  	-1	10	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	5	-1	-1	-1
83aa212	402	Nice, Get 2010 source details	0	10	9	2011-04-17	2011-09-01	DC  	-1	12	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	6	-1	-1	-1
a502	403	0	0	5	3	2011-04-17	2011-09-01	DC  	25	10	-1	Y	-1	-1	-1	-4	-1	-1	-1	11	2	13	-1	7	-1	-1	-1
a502	404	0	0	6	3	2011-04-17	2011-09-01	DC  	25	12	-1	N	-1	-1	-1	-4	-1	-1	-1	11	2	13	-1	8	-1	-1	-1
41aa111	405	0	0	9	3	2011-04-17	2011-09-01	DC  	25	-1	-1	Y	-1	-1	-1	-4	-1	-1	-1	138	2	13	-1	9	-1	-1	-1
41aa111	406	0	0	7	2	2011-04-17	2011-09-01	DC  	25	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	138	2	13	-1	10	-1	-1	-1
83aa217	407	Not good	0	8	4	2011-04-17	2011-09-01	DC  	-1	10	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	11	-1	-1	-1
83aa217	408	Not good	0	9	5	2011-04-17	2011-09-01	DC  	-1	10	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	12	-1	-1	-1
83aa103	409	Check for spear leaf mutation	0	6	3	2011-04-17	2011-09-01	DC  	-1	13	-1	N	-1	-1	-1	-4	-1	-1	-1	115	2	13	-1	13	-1	-1	-1
83aa103	410	Check for spear leaf mutation	0	5	4	2011-04-17	2011-09-01	DC  	-1	13	-1	N	-1	-1	-1	-4	-1	-1	-1	115	2	13	-1	14	-1	-1	-1
83aa216	411	Very Nice	0	6	5	2011-04-17	2011-09-01	DC  	-1	12	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	15	-1	-1	-1
83aa216	412	Very Nice	0	6	6	2011-04-17	2011-09-01	DC  	-1	16	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	16	-1	-1	-1
nfa	413	northFox alba	0	11	7	2011-04-17	2011-09-01	DC  	25	-1	-1	Y	-1	-1	-1	-4	-1	-1	-1	19	2	13	-1	17	-1	-1	-1
nfa	414	northFox alba	0	11	8	2011-04-17	2011-09-01	DC  	25	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	19	2	13	-1	18	-1	-1	-1
ebl	415	EastBeltline alba	0	11	6	2011-04-17	2011-09-01	DC  	25	-1	-1	Y	-1	-1	-1	-4	-1	-1	-1	8	140	13	-1	19	-1	-1	-1
ebl	416	EastBeltline alba	0	11	7	2011-04-17	2011-09-01	DC  	25	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	8	140	13	-1	20	-1	-1	-1
83aa104	417	Selected in 9/2009 for its remarkable growth performance. Compare now	0	7	3	2011-04-17	2011-09-01	DC  	-1	19	-1	N	-1	-1	-1	-4	-1	-1	-1	116	2	13	-1	21	-1	-1	-1
83aa104	418	Selected in 9/2009 for its remarkable growth performance. Compare now	0	8	4	2011-04-17	2011-09-01	DC  	-1	19	-1	N	-1	-1	-1	-4	-1	-1	-1	116	2	13	-1	22	-1	-1	-1
83aa107	419	Aspen like appearance	0	8	4	2011-04-17	2011-09-01	DC  	-1	12	-1	Y	-1	-1	-1	-4	-1	-1	-1	137	2	13	-1	23	-1	-1	-1
83aa107	420	Aspen like appearance	0	7	4	2011-04-17	2011-09-01	DC  	-1	12	-1	N	-1	-1	-1	-4	-1	-1	-1	137	2	13	-1	24	-1	-1	-1
83aa204	421	selected for 2012. Vigorous, but a fair rooter	0	9	7	2011-04-17	2011-09-01	DC  	-1	12	-1	Y	-1	-1	203	-4	-1	-1	-1	128	2	13	-1	25	-1	-1	-1
83aa204	422	0	0	10	6	2011-04-17	2011-09-01	DC  	-1	12	-1	N	-1	-1	203	-4	-1	-1	-1	128	2	13	-1	26	-1	-1	-1
83aa227	423	Nice, Get 2010 source details	0	6	5	2011-04-17	2011-09-01	DC  	-1	6	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	27	-1	-1	-1
83aa227	424	Nice, Get 2010 source details	0	5	5	2011-04-17	2011-09-01	DC  	-1	6	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	28	-1	-1	-1
83aa211	425	0	0	5	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	29	-1	-1	-1
83aa211	426	0	0	5	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	30	-1	-1	-1
83aa106	427	Selected in 9/2009 for its numerous small side shoots. Are there?	0	6	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	136	2	13	-1	31	-1	-1	-1
83aa106	428	Selected in 9/2009 for its numerous small side shoots. Are there?	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	136	2	13	-1	32	-1	-1	-1
83aa228	429	0	0	8	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	33	-1	-1	-1
83aa228	430	0	0	6	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	34	-1	-1	-1
83aa214	431	0	0	4	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	35	-1	-1	-1
83aa214	432	0	0	5	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	36	-1	-1	-1
83aa204	433	0	0	9	6	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	178	-4	-1	-1	-1	128	2	13	-1	37	-1	-1	-1
83aa204	434	0	0	9	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	178	-4	-1	-1	-1	128	2	13	-1	38	-1	-1	-1
83aa1mf	435	0	0	17	3	2011-04-17	2011-09-01	DC  	-1	10	-1	Y	-1	-1	-1	-4	-1	-1	-1	143	2	13	-1	41	-1	-1	-1
83aa1mf	436	0	0	17	5	2011-04-17	2011-09-01	DC  	-1	10	-1	N	-1	-1	-1	-4	-1	-1	-1	143	2	13	-1	42	-1	-1	-1
83aa2mf	437	0	0	8	5	2011-04-17	2011-09-01	DC  	-1	10	-1	Y	-1	-1	-1	-4	-1	-1	-1	144	2	13	-1	43	-1	-1	-1
83aa2mf	438	0	0	8	3	2011-04-17	2011-09-01	DC  	-1	10	-1	N	-1	-1	-1	-4	-1	-1	-1	144	2	13	-1	44	-1	-1	-1
83aa226	439	0	0	3	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	45	-1	-1	-1
83aa226	440	0	0	4	4	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	46	-1	-1	-1
83aa224	441	0	0	6	5	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	47	-1	-1	-1
83aa223	442	0	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	48	-1	-1	-1
83aa225	443	0	0	5	3	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	49	-1	-1	-1
83aa222	444	0	0	11	10	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	50	-1	-1	-1
83aa220	445	0	0	7	2	2011-04-17	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	51	-1	-1	-1
104xaa10	446	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	6	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	1	-1	-1	-1
104xaa10	447	0	0	11	11	2011-04-25	2011-09-01	DC  	-1	10	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	2	-1	-1	-1
104xaa10	448	0	0	40	10	2011-04-25	2011-09-01	DC  	-1	10	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	3	-1	-1	-1
104xaa10	449	0	0	7	7	2011-04-25	2011-09-01	DC  	-1	6	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	4	-1	-1	-1
104xaa10	450	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	5	-1	-1	-1
104xaa10	451	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	6	-1	-1	-1
104xaa10	452	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	7	-1	-1	-1
104xaa10	453	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	8	-1	-1	-1
104xaa10	454	PRAVL - Stock from Dykema 2010	PRAVL	6	6	2011-04-25	2011-09-01	DC  	-1	10	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	9	-1	-1	-1
104xaa10	455	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	10	-1	-1	-1
104xaa10	456	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	6	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	11	-1	-1	-1
104xaa10	457	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	12	-1	-1	-1
104xaa10	458	0	0	6	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	13	-1	-1	-1
104xaa10	459	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	14	-1	-1	-1
104xaa10	460	end row	0	6	5	2011-04-25	2011-09-01	DC  	-1	10	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	15	-1	-1	-1
104xaa10	461	begin row (yes, this row is duplicated)	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	15	-1	-1	-1
104xaa10	462	0	0	7	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	16	-1	-1	-1
104xaa10	463	0	0	7	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	17	-1	-1	-1
104xaa10	464	0	0	9	9	2011-04-25	2011-09-01	DC  	-1	11	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	18	-1	-1	-1
104xaa10	465	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	19	-1	-1	-1
104xaa10	466	RF	0	6	6	2011-04-25	2011-09-01	DC  	-1	12	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	20	-1	-1	-1
104xaa10	467	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	21	-1	-1	-1
104xaa10	468	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	22	-1	-1	-1
104xaa10	469	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	23	-1	-1	-1
104xaa10	470	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	24	-1	-1	-1
104xaa10	471	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	25	-1	-1	-1
104xaa10	472	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	26	-1	-1	-1
104xaa10	473	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	27	-1	-1	-1
104xaa10	474	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	169	13	-1	28	-1	-1	-1
97xaa10	475	0	0	6	2	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	29	-1	-1	-1
97xaa10	476	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	9	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	30	-1	-1	-1
97xaa10	477	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	31	-1	-1	-1
97xaa10	478	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	32	-1	-1	-1
97xaa10	479	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	33	-1	-1	-1
97xaa10	480	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	34	-1	-1	-1
97xaa10	481	0	0	6	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	35	-1	-1	-1
97xaa10	482	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	36	-1	-1	-1
97xaa10	483	0	0	6	2	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	37	-1	-1	-1
97xaa10	484	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	38	-1	-1	-1
97xaa10	485	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	39	-1	-1	-1
97xaa10	486	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	40	-1	-1	-1
97xaa10	487	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	41	-1	-1	-1
97xaa10	488	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	42	-1	-1	-1
97xaa10	489	end row	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	43	-1	-1	-1
97xaa10	490	begin row	0	5	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	44	-1	-1	-1
97xaa10	491	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	12	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	45	-1	-1	-1
97xaa10	492	0	0	6	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	46	-1	-1	-1
97xaa10	493	0	0	5	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	47	-1	-1	-1
97xaa10	494	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	48	-1	-1	-1
97xaa10	495	0	0	6	1	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	49	-1	-1	-1
97xaa10	496	0	0	7	7	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	50	-1	-1	-1
97xaa10	497	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	51	-1	-1	-1
97xaa10	498	0	0	6	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	52	-1	-1	-1
97xaa10	499	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	7	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	53	-1	-1	-1
97xaa10	500	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	54	-1	-1	-1
97xaa10	501	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	55	-1	-1	-1
97xaa10	502	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	56	-1	-1	-1
97xaa10	503	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	159	13	-1	57	-1	-1	-1
40aa6mf	504	0	0	10	1	2011-04-25	2011-09-01	DC  	-1	-1	-1	Y	-1	-1	-1	-4	-1	-1	-1	140	2	13	-1	58	-1	-1	-1
40aa6mf	505	0	0	9	1	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	140	2	13	-1	59	-1	-1	-1
98xaa10	506	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	60	-1	-1	-1
98xaa10	507	0	0	6	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	61	-1	-1	-1
98xaa10	508	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	62	-1	-1	-1
98xaa10	509	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	5	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	63	-1	-1	-1
98xaa10	510	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	64	-1	-1	-1
98xaa10	511	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	12	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	65	-1	-1	-1
98xaa10	512	0	0	8	7	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	66	-1	-1	-1
98xaa10	513	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	5	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	67	-1	-1	-1
98xaa10	514	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	68	-1	-1	-1
100aa01	515	Cuttings from selected SASP 2010 1-0 stock. 	0	19	13	2011-04-25	2011-09-01	DC  	-1	8	-1	Y	-1	-1	-1	-4	-1	-1	-1	153	2	13	-1	1	-1	-1	-1
100aa01	516	Cuttings from selected SASP 2010 1-0 stock. Why North row 100%	0	19	19	2011-04-25	2011-09-01	DC  	-1	8	-1	N	-1	-1	-1	-4	-1	-1	-1	153	2	13	-1	2	-1	-1	-1
100aa02	517	Cuttings from selected SASP 2010 1-0 stock. 	0	13	11	2011-04-25	2011-09-01	DC  	-1	8	-1	Y	-1	-1	-1	-4	-1	-1	-1	154	2	13	-1	3	-1	-1	-1
100aa02	518	Cuttings from selected SASP 2010 1-0 stock. Why North row 100%	0	11	11	2011-04-25	2011-09-01	DC  	-1	8	-1	N	-1	-1	-1	-4	-1	-1	-1	154	2	13	-1	4	-1	-1	-1
100aa03	519	Cuttings from selected SASP 2010 1-0 stock. Best of 4 clones?	0	13	8	2011-04-25	2011-09-01	DC  	-1	8	-1	Y	-1	-1	-1	-4	-1	-1	-1	155	2	13	-1	5	-1	-1	-1
100aa03	520	Cuttings from selected SASP 2010 1-0 stock. Why North row ~100%	0	14	13	2011-04-25	2011-09-01	DC  	-1	8	-1	N	-1	-1	-1	-4	-1	-1	-1	155	2	13	-1	6	-1	-1	-1
100aa04	521	Cuttings from selected SASP 2010 1-0 stock. 	0	12	10	2011-04-25	2011-09-01	DC  	-1	8	-1	Y	-1	-1	-1	-4	-1	-1	-1	156	2	13	-1	7	-1	-1	-1
100aa04	522	Cuttings from selected SASP 2010 1-0 stock. 	0	12	8	2011-04-25	2011-09-01	DC  	-1	8	-1	N	-1	-1	-1	-4	-1	-1	-1	156	2	13	-1	8	-1	-1	-1
100xaa10	523	Cutting stock from Bell 2010 nursery	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	9	-1	-1	-1
100xaa10	524	Cutting stock from Bell 2010 nursery	0	6	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	10	-1	-1	-1
100xaa10	525	Cutting stock from Bell 2010 nursery	0	5	3	2011-04-25	2011-09-01	DC  	-1	0	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	11	-1	-1	-1
100xaa10	526	Cutting stock from Bell 2010 nursery	0	6	3	2011-04-25	2011-09-01	DC  	-1	1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	12	-1	-1	-1
100xaa10	527	Cutting stock from Bell 2010 nursery	0	6	3	2011-04-25	2011-09-01	DC  	-1	2	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	13	-1	-1	-1
100xaa10	528	Cutting stock from Bell 2010 nursery	0	6	4	2011-04-25	2011-09-01	DC  	-1	3	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	14	-1	-1	-1
100xaa10	529	Cutting stock from Bell 2010 nursery (end row)	0	6	2	2011-04-25	2011-09-01	DC  	-1	4	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	15	-1	-1	-1
100xaa10	530	Cutting stock from Bell 2010 nursery (begin row)	0	6	2	2011-04-25	2011-09-01	DC  	-1	5	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	16	-1	-1	-1
100xaa10	531	Cutting stock from Bell 2010 nursery	0	6	4	2011-04-25	2011-09-01	DC  	-1	6	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	17	-1	-1	-1
100xaa10	532	Cutting stock from Bell 2010 nursery PRAVL	0	6	6	2011-04-25	2011-09-01	DC  	-1	12	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	18	-1	-1	-1
100xaa10	533	Cutting stock from Bell 2010 nursery	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	19	-1	-1	-1
100xaa10	534	Cutting stock from Bell 2010 nursery	0	4	2	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	20	-1	-1	-1
100xaa10	535	Cutting stock from Bell 2010 nursery	0	4	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	21	-1	-1	-1
100xaa10	536	Cutting stock from Bell 2010 nursery	0	4	4	2011-04-25	2011-09-01	DC  	-1	4	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	22	-1	-1	-1
100xaa10	537	Cutting stock from Bell 2010 nursery	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	158	13	-1	23	-1	-1	-1
83aa218	538	Nice, Get 2010 source details	0	9	9	2011-04-25	2011-09-01	DC  	-1	13	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	24	-1	-1	-1
83aa218	539	Nice, Get 2010 source details	0	8	5	2011-04-25	2011-09-01	DC  	-1	10	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	25	-1	-1	-1
83aa203	540	0	0	4	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	127	2	13	-1	26	-1	-1	-1
83aa203	541	0	0	4	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	127	2	13	-1	27	-1	-1	-1
83aa209	542	0	0	7	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	131	2	13	-1	28	-1	-1	-1
83aa209	543	0	0	7	2	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	131	2	13	-1	29	-1	-1	-1
83aa207	544	0	0	5	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	30	-1	-1	-1
83aa207	545	0	0	5	1	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	31	-1	-1	-1
83aa206	546	0	0	8	6	2011-04-25	2011-09-01	DC  	-1	10	-1	Y	-1	-1	170	-4	-1	-1	-1	129	2	13	-1	32	-1	-1	-1
83aa206	547	0	0	9	4	2011-04-25	2011-09-01	DC  	-1	6	-1	N	-1	-1	170	-4	-1	-1	-1	129	2	13	-1	33	-1	-1	-1
83aa203	548	0	0	7	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	127	2	13	-1	34	-1	-1	-1
83aa203	549	0	0	6	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	127	2	13	-1	35	-1	-1	-1
83aa226	550	0	0	3	1	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	36	-1	-1	-1
83aa226	551	0	0	4	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	37	-1	-1	-1
83aa206	552	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	12	-1	N	-1	-1	170	-4	-1	-1	-1	129	2	13	-1	38	-1	-1	-1
83aa206	553	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	10	-1	N	-1	-1	170	-4	-1	-1	-1	129	2	13	-1	39	-1	-1	-1
83aa213	554	0	0	7	7	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	40	-1	-1	-1
83aa213	555	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	140	13	-1	41	-1	-1	-1
101xaa10	556	0	0	5	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	42	-1	-1	-1
101xaa10	557	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	43	-1	-1	-1
101xaa10	558	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	44	-1	-1	-1
101xaa10	559	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	45	-1	-1	-1
101xaa10	560	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	46	-1	-1	-1
101xaa10	561	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	47	-1	-1	-1
101xaa10	562	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	4	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	48	-1	-1	-1
101xaa10	563	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	49	-1	-1	-1
101xaa10	564	0	0	4	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	50	-1	-1	-1
101xaa10	565	end row	0	5	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	51	-1	-1	-1
101xaa10	566	begin row	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	52	-1	-1	-1
101xaa10	567	0	0	4	2	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	53	-1	-1	-1
101xaa10	568	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	54	-1	-1	-1
101xaa10	569	0	0	5	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	55	-1	-1	-1
101xaa10	570	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	56	-1	-1	-1
101xaa10	571	0	0	4	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	57	-1	-1	-1
101xaa10	572	0	0	5	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	58	-1	-1	-1
101xaa10	573	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	59	-1	-1	-1
101xaa10	574	0	0	4	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	60	-1	-1	-1
101xaa10	575	0	0	1	1	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	156	13	-1	61	-1	-1	-1
83aa204	576	Cutting stock was 6 with 1 stubby root section. Intended as a 1yr stool.	0	4	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	128	2	13	-1	62	-1	-1	-1
98xaa10	577	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	1	-1	-1	-1
98xaa10	578	0	0	5	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	2	-1	-1	-1
98xaa10	579	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	4	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	3	-1	-1	-1
98xaa10	580	0	0	5	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	4	-1	-1	-1
98xaa10	581	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	5	-1	-1	-1
98xaa10	582	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	6	-1	-1	-1
98xaa10	583	0	0	5	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	7	-1	-1	-1
98xaa10	584	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	8	-1	-1	-1
98xaa10	585	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	9	-1	-1	-1
98xaa10	586	end row	0	5	4	2011-04-25	2011-09-01	DC  	-1	4	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	10	-1	-1	-1
98xaa10	587	begin row	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	11	-1	-1	-1
98xaa10	588	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	12	-1	-1	-1
98xaa10	589	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	6	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	13	-1	-1	-1
98xaa10	590	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	14	-1	-1	-1
98xaa10	591	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	15	-1	-1	-1
98xaa10	592	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	4	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	16	-1	-1	-1
98xaa10	593	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	17	-1	-1	-1
98xaa10	594	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	18	-1	-1	-1
98xaa10	595	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	19	-1	-1	-1
98xaa10	596	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	4	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	20	-1	-1	-1
98xaa10	597	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	155	13	-1	21	-1	-1	-1
90xaa10	598	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	13	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	22	-1	-1	-1
90xaa10	599	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	23	-1	-1	-1
90xaa10	600	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	24	-1	-1	-1
90xaa10	601	0	0	6	2	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	25	-1	-1	-1
90xaa10	602	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	26	-1	-1	-1
90xaa10	603	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	12	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	27	-1	-1	-1
90xaa10	604	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	7	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	28	-1	-1	-1
90xaa10	605	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	29	-1	-1	-1
90xaa10	606	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	12	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	30	-1	-1	-1
90xaa10	607	0	0	6	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	31	-1	-1	-1
90xaa10	608	0	0	6	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	32	-1	-1	-1
90xaa10	609	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	33	-1	-1	-1
90xaa10	610	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	34	-1	-1	-1
90xaa10	611	end row	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	35	-1	-1	-1
90xaa10	612	begin row	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	36	-1	-1	-1
90xaa10	613	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	37	-1	-1	-1
90xaa10	614	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	38	-1	-1	-1
90xaa10	615	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	39	-1	-1	-1
90xaa10	616	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	40	-1	-1	-1
90xaa10	617	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	8	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	41	-1	-1	-1
90xaa10	618	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	42	-1	-1	-1
90xaa10	619	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	43	-1	-1	-1
90xaa10	620	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	44	-1	-1	-1
90xaa10	621	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	45	-1	-1	-1
90xaa10	622	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	46	-1	-1	-1
90xaa10	623	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	47	-1	-1	-1
90xaa10	624	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	8	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	48	-1	-1	-1
90xaa10	625	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	9	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	49	-1	-1	-1
90xaa10	626	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	165	13	-1	50	-1	-1	-1
86xaa10	627	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	10	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	51	-1	-1	-1
86xaa10	628	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	52	-1	-1	-1
86xaa10	629	0	0	5	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	53	-1	-1	-1
86xaa10	630	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	6	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	54	-1	-1	-1
86xaa10	631	0	0	5	4	2011-04-25	2011-09-01	DC  	-1	6	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	55	-1	-1	-1
86xaa10	632	0	0	6	6	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	56	-1	-1	-1
86xaa10	633	0	0	5	6	2011-04-25	2011-09-01	DC  	-1	12	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	57	-1	-1	-1
86xaa10	634	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	58	-1	-1	-1
86xaa10	635	end row	0	5	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	59	-1	-1	-1
86xaa10	636	begin row	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	60	-1	-1	-1
86xaa10	637	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	61	-1	-1	-1
86xaa10	638	First Tree is vigorous	0	6	5	2011-04-25	2011-09-01	DC  	-1	8	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	62	-1	-1	-1
86xaa10	639	0	0	5	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	63	-1	-1	-1
86xaa10	640	0	0	6	3	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	64	-1	-1	-1
86xaa10	641	0	0	6	4	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	65	-1	-1	-1
86xaa10	642	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	66	-1	-1	-1
86xaa10	643	0	0	6	5	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	67	-1	-1	-1
86xaa10	644	0	0	5	2	2011-04-25	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	68	-1	-1	-1
93xaa10	645	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	1	-1	-1	-1
93xaa10	646	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	2	-1	-1	-1
93xaa10	647	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	3	-1	-1	-1
93xaa10	648	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	4	-1	-1	-1
93xaa10	649	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	5	-1	-1	-1
93xaa10	650	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	6	-1	-1	-1
93xaa10	651	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	7	-1	-1	-1
93xaa10	652	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	12	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	8	-1	-1	-1
93xaa10	653	0	0	5	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	9	-1	-1	-1
93xaa10	654	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	8	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	10	-1	-1	-1
93xaa10	655	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	11	-1	-1	-1
93xaa10	656	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	6	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	12	-1	-1	-1
93xaa10	657	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	13	-1	-1	-1
93xaa10	658	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	14	-1	-1	-1
93xaa10	659	end row	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	15	-1	-1	-1
93xaa10	660	begin row	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	16	-1	-1	-1
93xaa10	661	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	17	-1	-1	-1
93xaa10	662	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	18	-1	-1	-1
93xaa10	663	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	19	-1	-1	-1
93xaa10	664	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	20	-1	-1	-1
93xaa10	665	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	21	-1	-1	-1
93xaa10	666	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	22	-1	-1	-1
93xaa10	667	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	23	-1	-1	-1
93xaa10	668	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	24	-1	-1	-1
93xaa10	669	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	25	-1	-1	-1
93xaa10	670	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	26	-1	-1	-1
93xaa10	671	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	27	-1	-1	-1
93xaa10	672	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	28	-1	-1	-1
93xaa10	673	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	29	-1	-1	-1
93xaa10	674	PRAVL - Stock from Dykema 2010	PRAVL	6	6	2011-05-06	2011-09-01	DC  	-1	12	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	166	13	-1	30	-1	-1	-1
103xaa10	675	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	31	-1	-1	-1
103xaa10	676	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	5	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	32	-1	-1	-1
103xaa10	677	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	4	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	33	-1	-1	-1
103xaa10	678	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	34	-1	-1	-1
103xaa10	679	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	35	-1	-1	-1
103xaa10	680	Remove tags marked with P	0	5	4	2011-05-06	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	36	-1	-1	-1
103xaa10	681	0	0	5	2	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	37	-1	-1	-1
103xaa10	682	Remove tags marked with P	0	6	6	2011-05-06	2011-09-01	DC  	-1	4	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	38	-1	-1	-1
103xaa10	683	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	39	-1	-1	-1
103xaa10	684	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	40	-1	-1	-1
103xaa10	685	end row	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	41	-1	-1	-1
103xaa10	686	begin row	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	42	-1	-1	-1
103xaa10	687	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	43	-1	-1	-1
103xaa10	688	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	44	-1	-1	-1
103xaa10	689	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	45	-1	-1	-1
103xaa10	690	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	46	-1	-1	-1
103xaa10	691	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	47	-1	-1	-1
103xaa10	692	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	48	-1	-1	-1
103xaa10	693	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	49	-1	-1	-1
103xaa10	694	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	50	-1	-1	-1
103xaa10	695	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	51	-1	-1	-1
103xaa10	696	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	52	-1	-1	-1
86xaa10	697	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	1	-1	-1	-1
86xaa10	698	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	2	-1	-1	-1
86xaa10	699	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	3	-1	-1	-1
86xaa10	700	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	4	-1	-1	-1
86xaa10	701	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	5	-1	-1	-1
86xaa10	702	Yes, this row this column number duplicated	0	5	5	2011-05-06	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	5	-1	-1	-1
86xaa10	703	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	6	-1	-1	-1
86xaa10	704	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	7	-1	-1	-1
86xaa10	705	0	0	6	2	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	8	-1	-1	-1
86xaa10	706	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	9	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	9	-1	-1	-1
86xaa10	707	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	167	13	-1	10	-1	-1	-1
103xaa10	708	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	11	-1	-1	-1
103xaa10	709	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	4	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	12	-1	-1	-1
103xaa10	710	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	13	-1	-1	-1
103xaa10	711	end row	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	14	-1	-1	-1
103xaa10	712	begin row	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	15	-1	-1	-1
103xaa10	713	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	16	-1	-1	-1
103xaa10	714	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	17	-1	-1	-1
103xaa10	715	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	170	13	-1	18	-1	-1	-1
96xaa10	716	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	19	-1	-1	-1
96xaa10	717	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	20	-1	-1	-1
96xaa10	718	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	21	-1	-1	-1
96xaa10	719	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	22	-1	-1	-1
96xaa10	720	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	23	-1	-1	-1
96xaa10	721	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	24	-1	-1	-1
96xaa10	722	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	25	-1	-1	-1
96xaa10	723	0	0	5	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	26	-1	-1	-1
96xaa10	724	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	27	-1	-1	-1
96xaa10	725	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	28	-1	-1	-1
96xaa10	726	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	29	-1	-1	-1
96xaa10	727	0	0	5	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	30	-1	-1	-1
96xaa10	728	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	12	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	31	-1	-1	-1
96xaa10	729	0	0	5	1	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	32	-1	-1	-1
96xaa10	730	end row	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	33	-1	-1	-1
96xaa10	731	begin row	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	34	-1	-1	-1
96xaa10	732	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	35	-1	-1	-1
96xaa10	733	0	0	5	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	36	-1	-1	-1
96xaa10	734	0	0	5	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	37	-1	-1	-1
96xaa10	735	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	38	-1	-1	-1
96xaa10	736	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	39	-1	-1	-1
96xaa10	737	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	40	-1	-1	-1
96xaa10	738	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	41	-1	-1	-1
96xaa10	739	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	42	-1	-1	-1
96xaa10	740	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	43	-1	-1	-1
96xaa10	741	0	0	6	2	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	44	-1	-1	-1
96xaa10	742	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	45	-1	-1	-1
96xaa10	743	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	46	-1	-1	-1
96xaa10	744	0	0	6	2	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	47	-1	-1	-1
96xaa10	745	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	160	13	-1	48	-1	-1	-1
92xaa10	746	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	1	-1	-1	-1
92xaa10	747	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	2	-1	-1	-1
92xaa10	748	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	6	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	3	-1	-1	-1
92xaa10	749	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	4	-1	-1	-1
92xaa10	750	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	5	-1	-1	-1
92xaa10	751	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	6	-1	-1	-1
92xaa10	752	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	7	-1	-1	-1
92xaa10	753	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	8	-1	-1	-1
92xaa10	754	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	9	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	9	-1	-1	-1
92xaa10	755	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	10	-1	-1	-1
92xaa10	756	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	11	-1	-1	-1
92xaa10	757	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	12	-1	-1	-1
92xaa10	758	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	13	-1	-1	-1
92xaa10	759	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	14	-1	-1	-1
92xaa10	760	end row	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	15	-1	-1	-1
92xaa10	761	begin row	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	16	-1	-1	-1
92xaa10	762	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	17	-1	-1	-1
92xaa10	763	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	18	-1	-1	-1
92xaa10	764	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	19	-1	-1	-1
92xaa10	765	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	20	-1	-1	-1
92xaa10	766	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	21	-1	-1	-1
92xaa10	767	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	22	-1	-1	-1
92xaa10	768	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	23	-1	-1	-1
92xaa10	769	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	24	-1	-1	-1
92xaa10	770	0	0	6	2	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	25	-1	-1	-1
92xaa10	771	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	26	-1	-1	-1
92xaa10	772	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	27	-1	-1	-1
92xaa10	773	0	0	6	2	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	28	-1	-1	-1
92xaa10	774	0	0	6	0	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	29	-1	-1	-1
92xaa10	775	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	152	13	-1	30	-1	-1	-1
94xaa10	776	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	31	-1	-1	-1
94xaa10	777	0	0	6	2	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	32	-1	-1	-1
94xaa10	778	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	33	-1	-1	-1
94xaa10	779	0	0	6	2	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	34	-1	-1	-1
94xaa10	780	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	35	-1	-1	-1
94xaa10	781	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	36	-1	-1	-1
94xaa10	782	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	37	-1	-1	-1
94xaa10	783	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	38	-1	-1	-1
94xaa10	784	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	39	-1	-1	-1
94xaa10	785	end row	0	6	4	2011-05-06	2011-09-01	DC  	-1	10	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	40	-1	-1	-1
94xaa10	786	begin row	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	41	-1	-1	-1
94xaa10	787	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	42	-1	-1	-1
94xaa10	788	0	0	5	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	43	-1	-1	-1
94xaa10	789	0	0	5	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	44	-1	-1	-1
94xaa10	790	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	5	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	45	-1	-1	-1
94xaa10	791	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	46	-1	-1	-1
94xaa10	792	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	47	-1	-1	-1
94xaa10	793	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	48	-1	-1	-1
94xaa10	794	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	49	-1	-1	-1
94xaa10	795	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	50	-1	-1	-1
94xaa10	796	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	6	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	1	-1	-1	-1
94xaa10	797	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	2	-1	-1	-1
94xaa10	798	0	0	6	3	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	3	-1	-1	-1
94xaa10	799	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	10	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	4	-1	-1	-1
94xaa10	800	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	5	-1	-1	-1
94xaa10	801	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	6	-1	-1	-1
94xaa10	802	0	0	6	6	2011-05-06	2011-09-01	DC  	-1	5	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	7	-1	-1	-1
94xaa10	803	0	0	6	4	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	8	-1	-1	-1
94xaa10	804	0	0	6	5	2011-05-06	2011-09-01	DC  	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	161	13	-1	9	-1	-1	-1
15ag4mf	805	WASP stock started from rootlings, planted as ASP plugs. Tallest was 10' on 9/1/11	0	100	100	2011-06-01	2011-09-01	ASP 	8	2	-1	Y	-1	-1	-1	-4	-1	-1	-1	26	2	13	-1	10	-1	-1	-1
83aa204	806	Cuttings started from sylleptic stems. Planted as ASP plugs. Tallest was 8' on 9/1/11	0	110	110	2011-06-01	2011-09-01	WASP	8	2	-1	N	-1	-1	-1	-4	-1	-1	-1	128	2	13	-1	1	-1	-1	-1
41aa111	807	0	0	5	5	2011-06-01	2011-09-01	1-0 	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	138	2	13	-1	2	-1	-1	-1
41aa111	808	0	0	10	10	2011-06-01	2011-09-01	WASP	8	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	138	2	13	-1	3	-1	-1	-1
a502	809	0	0	7	7	2011-06-01	2011-09-01	WASP	8	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	11	2	13	-1	4	-1	-1	-1
1xcagw	810	0	0	7	7	2011-07-02	2011-09-01	SEL 	-1	-1	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	171	13	-1	2	-1	-1	-1
1xaw11	811	Seeded 5/14/11, Planted 7/2/11. 3 have AG characteristics	0	48	23	2011-07-02	2011-09-01	SEL 	-1	-1	-1	Y	-1	-1	-1	-4	-1	-1	-1	2	172	13	-1	3	-1	-1	-1
1xcagw	812	Seeded 5/30/11, Planted 7/16/11	0	22	22	2011-07-16	2011-09-01	SEL 	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	171	13	-1	4	-1	-1	-1
1xcagw	813	Seeded 5/30/11, Planted 7/16/11. About 60/40% Alba/Aspen characteristics. Losses from rabbits.	0	130	122	2011-07-16	2011-09-01	SEL 	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	171	13	-1	1	-1	-1	-1
1xcagw	814	Seeded 5/30/11, Planted 7/16/11. About 60/40% Alba/Aspen characteristics. Losses from rabbits.	0	130	96	2011-07-16	2011-09-01	SEL 	-1	-1	-1	N	-1	-1	-1	-4	-1	-1	-1	2	171	13	-1	2	-1	-1	-1
90xaa10	815	 2012: Start rep 1, row 1, (FYI: NOTES2 = 2011-ID, which is id_prev_test_detail). Biased = edge effect	969	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	2	4	-1	-1	1	1	14	1	1	1	-1	-1
86xaa10	816	Biased = 1, edge effect	993	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	1	4	-1	-1	1	1	14	1	2	1	-1	-1
103xaa10	817	Biased = 1, edge effect	1036	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	1	4	-1	-1	1	1	14	1	3	1	-1	-1
92xaa10	818	Biased = 1, edge effect	1105	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	1	4	-1	-1	1	1	14	1	4	1	-1	-1
98xaa10	819	Biased = 1, edge effect, leaf spots on lower leaves	936	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	1	3	-1	-1	1	1	14	1	5	1	-1	-1
86xaa10	820	Biased = 1, edge effect, nice!	1060	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	1	4	-1	-1	1	1	14	1	6	1	-1	-1
92xaa10	821	Biased = 1, edge effect	1108	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	1	3	-1	-1	1	1	14	1	7	1	-1	-1
90xaa10	822	Biased = 1, edge effect. Nice! Largest dia=23mm at collar.	968	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	1	4	-1	-1	1	1	14	1	8	1	-1	-1
86xaa10	823	Biased = 1, edge effect	1056	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	1	4	-1	-1	1	1	14	1	9	1	-1	-1
98xaa10	824	Biased = 1, edge effect. short...	942	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	1	3	-1	-1	1	1	14	1	10	1	-1	-1
93xaa10	825	Biased = 1, edge effect. Nice! Largest dia=23mm at collar.	1028	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	1	4	-1	-1	1	1	14	1	11	1	-1	-1
98xaa10	826	Biased = -2, nursery bad spot - needs soil test.	946	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	-2	4	-1	-1	1	1	14	1	12	1	-1	-1
90xaa10	827	Biased = -2, nursery bad spot - needs soil test.	960	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.1	-1	-1	-2	3	-1	-1	1	1	14	1	13	1	-1	-1
90xaa10	828	Biased = -2, nursery bad spot - needs soil test.	971	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.1	-1	-1	-2	4	-1	-1	1	1	14	1	14	1	-1	-1
83aa204	829	Biased = -2, nursery bad spot - needs soil test.	773	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	-2	4	-1	-1	1	1	14	1	15	1	-1	-1
91xaa10	875	0	605	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	0	3	-1	-1	1	1	14	3	11	1	-1	-1
83aa204	830	Biased = -2, nursery bad spot - needs soil test. Interesting - poor	773	10	2	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	-2	4	-1	-1	1	1	14	1	16	1	-1	-1
100xaa10	831	Biased = -2, nursery bad spot - needs soil test.	670	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.4	-1	-1	-2	3	-1	-1	1	1	14	1	17	1	-1	-1
102xaa10	832	Biased = -2, nursery bad spot - needs soil test.	728	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-2	3	-1	-1	1	1	14	1	18	1	-1	-1
100xaa10	833	Biased = -2, nursery bad spot - needs soil test.	668	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	-2	3	-1	-1	1	1	14	1	19	1	-1	-1
102xaa10	834	Biased = -2, nursery bad spot - needs soil test.	736	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	-2	3	-1	-1	1	1	14	1	20	1	-1	-1
100aa03	835	Biased = -2, nursery bad spot - needs soil test.	873	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-2	4	-1	-1	1	1	14	1	21	1	-1	-1
83aa216	836	Biased = -2, nursery bad spot - needs soil test.	763	10	3	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.4	-1	-1	-2	4	-1	-1	1	1	14	1	22	1	-1	-1
83aa206	837	Biased = -2, nursery bad spot - needs soil test.	900	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	-2	4	-1	-1	1	1	14	1	23	1	-1	-1
104xaa10	838	Biased = -2, nursery bad spot - needs soil test.	801	10	0	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0	-1	-1	-2	4	-1	-1	1	1	14	1	24	1	-1	-1
104xaa10	839	End rep1, row1.  Biased = -2, nursery bad spot - needs soil test.	818	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-2	4	-1	-1	1	1	14	1	25	1	-1	-1
92xaa10	840	Start rep1, row 2, col 1. Biased=edge of row	1102	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	2	4	-1	-1	1	1	14	2	1	1	-1	-1
103xaa10	841	Nice!	1034	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	0	4	-1	-1	1	1	14	2	2	1	-1	-1
96xaa10	842	Bad	1073	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	2	3	1	-1	-1
98xaa10	843	0	933	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	2	4	1	-1	-1
93xaa10	844	0	1025	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	2	5	1	-1	-1
86xaa10	845	0	1052	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-1	4	-1	-1	1	1	14	2	6	1	-1	-1
86xaa10	846	0	1055	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	-1	4	-1	-1	1	1	14	2	7	1	-1	-1
103xaa10	847	0	1063	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-1	4	-1	-1	1	1	14	2	8	1	-1	-1
93xaa10	848	0	1006	10	2	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	-1	4	-1	-1	1	1	14	2	9	1	-1	-1
90xaa10	849	0	978	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	-1	4	-1	-1	1	1	14	2	10	1	-1	-1
98xaa10	850	0	943	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	-1	4	-1	-1	1	1	14	2	11	1	-1	-1
93xaa10	851	0	1010	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	-1	4	-1	-1	1	1	14	2	12	1	-1	-1
93xaa10	852	Biased= -2, Bad nusery area.	1008	10	3	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	-2	4	-1	-1	1	1	14	2	13	1	-1	-1
100xaa10	853	Biased= -2, Bad nusery area.	679	10	3	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-2	3	-1	-1	1	1	14	2	14	1	-1	-1
100xaa10	854	Biased= -2, Bad nusery area.	687	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	-2	4	-1	-1	1	1	14	2	15	1	-1	-1
95xaa10	855	Biased= -2, Bad nusery area.	722	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-2	4	-1	-1	1	1	14	2	16	1	-1	-1
83aa212	856	Biased= -2, Bad nusery area.	753	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	-2	3	-1	-1	1	1	14	2	17	1	-1	-1
102xaa10	857	Biased= -2, Bad nusery area.	732	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	-2	3	-1	-1	1	1	14	2	18	1	-1	-1
83aa215	858	Biased= -2, Bad nusery area.	751	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	-2	4	-1	-1	1	1	14	2	19	1	-1	-1
104xaa10	859	Biased= -2, Bad nusery area.	814	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-2	2	-1	-1	1	1	14	2	20	1	-1	-1
83aa206	860	Biased= -2, Bad nusery area.	900	10	1	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	-2	3	-1	-1	1	1	14	2	21	1	-1	-1
104xaa10	861	Biased= -2, Bad nusery area.	808	10	2	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	-2	3	-1	-1	1	1	14	2	22	1	-1	-1
100xaa10	862	Biased= -2, Bad nusery area.	886	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	-2	3	-1	-1	1	1	14	2	23	1	-1	-1
104xaa10	863	Biased= -2, Bad nusery area.	810	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	-2	4	-1	-1	1	1	14	2	24	1	-1	-1
101xaa10	864	End rep1, row2.  Biased= -2, Bad nusery area.	911	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	-2	4	-1	-1	1	1	14	2	25	1	-1	-1
99xaa10	865	Start rep1, row 3, col 1	644	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	0	4	-1	-1	1	1	14	3	1	1	-1	-1
100xaa10	866	0	675	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	3	2	1	-1	-1
100xaa10	867	0	692	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	3	3	1	-1	-1
83aa227	868	0	775	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	3	-1	-1	1	1	14	3	4	1	-1	-1
41aa111	869	0	757	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	3	5	1	-1	-1
100aa01	870	0	869	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	3	6	1	-1	-1
97xaa10	871	0	830	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	3	7	1	-1	-1
100aa04	872	0	875	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	3	8	1	-1	-1
97xaa10	873	0	845	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	3	9	1	-1	-1
100xaa10	874	0	912	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.3	-1	-1	0	4	-1	-1	1	1	14	3	10	1	-1	-1
91xaa10	876	Biased= -2, Bad nusery area.	613	10	2	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.4	-1	-1	-2	3	-1	-1	1	1	14	3	12	1	-1	-1
83aa221	877	Biased= -2, Bad nusery area.	526	10	0	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0	-1	-1	-2	3	-1	-1	1	1	14	3	13	1	-1	-1
96xaa10	878	Biased= -2, Bad nusery area.	1099	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	-2	3	-1	-1	1	1	14	3	14	1	-1	-1
98xaa10	879	Biased= -2, Bad nusery area.	950	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	-2	3	-1	-1	1	1	14	3	15	1	-1	-1
86xaa10	880	Biased= -2, Bad nusery area.	981	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	-2	4	-1	-1	1	1	14	3	16	1	-1	-1
83aa218	881	0	892	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	3	-1	-1	1	1	14	3	17	1	-1	-1
86xaa10	882	0	987	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	3	-1	-1	1	1	14	3	18	1	-1	-1
86xaa10	883	End rep1, row3	984	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	3	-1	-1	1	1	14	3	19	1	-1	-1
100xaa10	884	Start rep1, row 4, col 1	686	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	2	4	-1	-1	1	1	14	4	1	1	-1	-1
99xaa10	885	0	629	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	4	2	1	-1	-1
100xaa10	886	Very NICE! Sylleptical	681	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.4	-1	-1	0	4	-1	-1	1	1	14	4	3	1	-1	-1
83aa107	887	0	771	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	0	3	-1	-1	1	1	14	4	4	1	-1	-1
83aa216	888	0	763	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	4	5	1	-1	-1
100aa02	889	0	871	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	3	-1	-1	1	1	14	4	6	1	-1	-1
97xaa10	890	0	853	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	0	4	-1	-1	1	1	14	4	7	1	-1	-1
101xaa10	891	0	928	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	0	4	-1	-1	1	1	14	4	8	1	-1	-1
101xaa10	892	0	916	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	4	9	1	-1	-1
101xaa10	893	0	915	10	1	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.3	-1	-1	0	1	-1	-1	1	1	14	4	10	1	-1	-1
91xaa10	894	0	615	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.4	-1	-1	0	3	-1	-1	1	1	14	4	11	1	-1	-1
91xaa10	895	Biased= -2, Bad nusery area.	617	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.3	-1	-1	-2	3	-1	-1	1	1	14	4	12	1	-1	-1
89xxaa10	896	Biased= -2, Bad nusery area.	585	10	1	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.3	-1	-1	-2	3	-1	-1	1	1	14	4	13	1	-1	-1
91xaa10	897	Biased= -2, Bad nusery area.	592	10	2	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	-2	4	-1	-1	1	1	14	4	14	1	-1	-1
90xaa10	898	Biased= -2, Bad nusery area.	957	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-2	3	-1	-1	1	1	14	4	15	1	-1	-1
90xaa10	899	Biased= -2, Bad nusery area.	952	10	3	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.4	-1	-1	-2	4	-1	-1	1	1	14	4	16	1	-1	-1
98xaa10	900	Biased= -2, Bad nusery area.	940	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-2	3	-1	-1	1	1	14	4	17	1	-1	-1
86xaa10	901	Biased= -2, Bad nusery area.	985	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-2	3	-1	-1	1	1	14	4	18	1	-1	-1
103xaa10	902	End rep1, row4, Biased= -2, Bad nusery area.	1039	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-2	3	-1	-1	1	1	14	4	19	1	-1	-1
83aa216	903	Sart REP2, row1,  Biased= -2, Bad nusery area & pre-rooted cuttings.	763	10	2	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	-3	3	-1	-1	1	1	14	1	1	2	-1	-1
104xaa10	904	Bad nusery area & pre-rooted cuttings.0	818	10	2	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-3	3	-1	-1	1	1	14	1	2	2	-1	-1
83aa107	905	dead - Bad nusery area & pre-rooted cuttings.	771	10	0	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0	-1	-1	-3	0	-1	-1	1	1	14	1	3	2	-1	-1
100xaa10	906	Bad nusery area & pre-rooted cuttings.	675	10	2	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	-3	3	-1	-1	1	1	14	1	4	2	-1	-1
83aa204	907	Bad nusery area & pre-rooted cuttings.	773	10	2	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	-3	3	-1	-1	1	1	14	1	5	2	-1	-1
104xaa10	908	Bad nusery area & pre-rooted cuttings.	801	10	0	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0	-1	-1	-3	0	-1	-1	1	1	14	2	1	2	-1	-1
41aa111	909	Bad nusery area & pre-rooted cuttings.	757	10	0	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0	-1	-1	-3	0	-1	-1	1	1	14	2	2	2	-1	-1
83aa227	910	Bad nusery area & pre-rooted cuttings.	775	10	0	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0	-1	-1	-3	0	-1	-1	1	1	14	2	3	2	-1	-1
101xaa10	911	Bad nusery area & pre-rooted cuttings.	911	10	0	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0	-1	-1	-3	0	-1	-1	1	1	14	2	4	2	-1	-1
100xaa10	912	Bad nusery area & pre-rooted cuttings.	679	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	-3	4	-1	-1	1	1	14	2	5	2	-1	-1
99xaa10	913	Start rep2, row 3, col 1	629	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	1	4	-1	-1	1	1	14	3	1	2	-1	-1
91xaa10	914	0	617	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	0	4	-1	-1	1	1	14	3	2	2	-1	-1
89xxaa10	915	0	585	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	3	3	2	-1	-1
91xaa10	916	0	615	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	3	4	2	-1	-1
102xaa10	917	0	732	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	3	5	2	-1	-1
100xaa10	918	0	670	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	3	6	2	-1	-1
100xaa10	919	0	686	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	0	4	-1	-1	1	1	14	3	7	2	-1	-1
83aa215	920	0	751	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	0	4	-1	-1	1	1	14	3	8	2	-1	-1
102xaa10	921	0	736	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	3	9	2	-1	-1
95xaa10	922	0	722	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	0	4	-1	-1	1	1	14	3	10	2	-1	-1
83aa204	923	0	773	10	3	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.4	-1	-1	0	4	-1	-1	1	1	14	3	11	2	-1	-1
83aa216	924	0	763	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	3	12	2	-1	-1
100xaa10	925	0	886	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.1	-1	-1	0	4	-1	-1	1	1	14	3	13	2	-1	-1
83aa206	926	0	900	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	0	4	-1	-1	1	1	14	3	14	2	-1	-1
100aa03	927	0	873	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	3	15	2	-1	-1
98xaa10	928	0	950	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	0	3	-1	-1	1	1	14	3	16	2	-1	-1
90xaa10	929	0	978	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	3	17	2	-1	-1
86xaa10	930	0	987	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	3	-1	-1	1	1	14	3	18	2	-1	-1
86xaa10	931	0	984	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	0	4	-1	-1	1	1	14	3	19	2	-1	-1
90xaa10	932	Biased= 1, edge	969	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	1	4	-1	-1	1	1	14	3	20	2	-1	-1
98xaa10	933	0	943	10	0	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0	-1	-1	0	4	-1	-1	1	1	14	3	21	2	-1	-1
86xaa10	934	0	1060	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	0	4	-1	-1	1	1	14	3	22	2	-1	-1
103xaa10	935	0	1036	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	3	23	2	-1	-1
86xaa10	936	0	1055	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	0	4	-1	-1	1	1	14	3	24	2	-1	-1
93xaa10	937	End rep2, row3	1008	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	3	25	2	-1	-1
99xaa10	938	Biased= 1, edge	644	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.3	-1	-1	1	4	-1	-1	1	1	14	4	1	2	-1	-1
91xaa10	939	Biased= 1, edge	592	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	1	4	-1	-1	1	1	14	4	2	2	-1	-1
83aa221	940	Biased= 1, edge	526	10	2	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.3	-1	-1	1	4	-1	-1	1	1	14	4	3	2	-1	-1
91xaa10	941	Biased= 1, edge	605	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.1	-1	-1	1	3	-1	-1	1	1	14	4	4	2	-1	-1
91xaa10	942	0	613	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	4	5	2	-1	-1
100xaa10	943	0	681	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	0	4	-1	-1	1	1	14	4	6	2	-1	-1
83aa212	944	0	753	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	4	7	2	-1	-1
100xaa10	945	0	687	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	0	3	-1	-1	1	1	14	4	8	2	-1	-1
100xaa10	946	0	692	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.3	-1	-1	0	4	-1	-1	1	1	14	4	9	2	-1	-1
102xaa10	947	0	728	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	4	10	2	-1	-1
100xaa10	948	0	668	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	0	4	-1	-1	1	1	14	4	11	2	-1	-1
104xaa10	949	good	810	10	10	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	3	-1	-1	1	1	14	4	12	2	-1	-1
83aa206	950	0	900	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	4	13	2	-1	-1
104xaa10	951	0	808	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	0	4	-1	-1	1	1	14	4	14	2	-1	-1
104xaa10	952	0	814	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	4	15	2	-1	-1
86xaa10	953	bad form	981	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	4	16	2	-1	-1
98xaa10	954	0	940	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	4	17	2	-1	-1
103xaa10	955	0	1039	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	0	4	-1	-1	1	1	14	4	18	2	-1	-1
86xaa10	956	bad form	993	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	0	4	-1	-1	1	1	14	4	19	2	-1	-1
90xaa10	957	0	952	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	4	20	2	-1	-1
83aa218	958	0	892	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	0	4	-1	-1	1	1	14	4	21	2	-1	-1
93xaa10	959	0	1025	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	4	22	2	-1	-1
86xaa10	960	bad form	1052	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.3	-1	-1	0	4	-1	-1	1	1	14	4	23	2	-1	-1
92xaa10	961	Nice!	1102	10	10	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.1	-1	-1	0	4	-1	-1	1	1	14	4	24	2	-1	-1
92xaa10	962	0	1108	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	4	25	2	-1	-1
93xaa10	963	End rep2, row4	1006	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	0	4	-1	-1	1	1	14	4	26	2	-1	-1
86xaa10	964	Biased= 1, edge	1056	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	1	4	-1	-1	1	1	14	5	1	2	-1	-1
93xaa10	965	Biased= 1, edge	1010	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	1	4	-1	-1	1	1	14	5	2	2	-1	-1
103xaa10	966	0	1063	10	10	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	5	3	2	-1	-1
86xaa10	967	0	985	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	5	4	2	-1	-1
90xaa10	968	0	968	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	0	4	-1	-1	1	1	14	5	5	2	-1	-1
98xaa10	969	0	933	10	10	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	5	6	2	-1	-1
90xaa10	970	0	960	10	10	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	0	4	-1	-1	1	1	14	5	7	2	-1	-1
93xaa10	971	0	1028	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	0	3	-1	-1	1	1	14	5	8	2	-1	-1
92xaa10	972	Biased= 1, edge	1105	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	1	3	-1	-1	1	1	14	6	1	2	-1	-1
103xaa10	973	Biased= 1, edge	1034	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	1	3	-1	-1	1	1	14	6	2	2	-1	-1
96xaa10	974	Biased= 1, edge	1023	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	1	4	-1	-1	1	1	14	6	3	2	-1	-1
96xaa10	975	Biased= 1, edge	1099	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	1	4	-1	-1	1	1	14	6	4	2	-1	-1
98xaa10	976	Biased= 1, edge	936	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	1	4	-1	-1	1	1	14	6	5	2	-1	-1
90xaa10	977	Biased= 1, edge	971	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	1	4	-1	-1	1	1	14	6	6	2	-1	-1
98xaa10	978	Biased= 1, edge	942	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.1	-1	-1	1	4	-1	-1	1	1	14	6	7	2	-1	-1
98xaa10	979	Biased= 1, edge	946	10	10	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	1	4	-1	-1	1	1	14	6	8	2	-1	-1
90xaa10	980	End rep2	957	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	6	9	2	-1	-1
100aa01	981	Sart REP3, row1	869	10	3	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	1	1	3	-1	-1
83aa215	982	0	751	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	0	4	-1	-1	1	1	14	1	2	3	-1	-1
83aa212	983	0	753	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	1	3	3	-1	-1
83aa204	984	0	773	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	1	4	3	-1	-1
83aa212	985	0	753	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	1	5	3	-1	-1
100xaa10	986	was missed	912	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	1	6	3	-1	-1
100aa02	987	0	871	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	1	7	3	-1	-1
101xaa10	988	0	928	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	1	8	3	-1	-1
100aa04	989	0	875	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	1	9	3	-1	-1
100aa01	990	0	869	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	0	4	-1	-1	1	1	14	1	10	3	-1	-1
92xaa10	991	0	1102	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	1	11	3	-1	-1
83aa218	992	Biased= 1, edge	892	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	1	4	-1	-1	1	1	14	1	12	3	-1	-1
100aa02	993	0	871	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	3	-1	-1	1	1	14	2	1	3	-1	-1
100aa04	994	poor	875	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	3	-1	-1	1	1	14	2	2	3	-1	-1
83aa204	995	poor	773	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	3	-1	-1	1	1	14	2	3	3	-1	-1
100xaa10	996	poor - decieving (compare)	675	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.3	-1	-1	0	3	-1	-1	1	1	14	2	4	3	-1	-1
83aa215	997	0	751	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	0	3	-1	-1	1	1	14	2	5	3	-1	-1
97xaa10	998	Nice!	853	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	2	6	3	-1	-1
101xaa10	999	0	916	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	4	-1	-1	1	1	14	2	7	3	-1	-1
97xaa10	1000	0	830	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	0	4	-1	-1	1	1	14	2	8	3	-1	-1
97xaa10	1001	Nice!	845	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	0	4	-1	-1	1	1	14	2	9	3	-1	-1
101xaa10	1002	0	915	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	0	4	-1	-1	1	1	14	2	10	3	-1	-1
92xaa10	1003	0	1108	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	0	4	-1	-1	1	1	14	2	11	3	-1	-1
93xaa10	1004	0	1028	10	3	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.5	-1	-1	0	4	-1	-1	1	1	14	2	12	3	-1	-1
93xaa10	1005	End rep3, row2	1028	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	1	4	-1	-1	1	1	14	2	13	3	-1	-1
93xaa10	1006	Sart REP3, row3 -  Flat 1 test	525	10	2	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	1	4	-1	-1	1	1	14	3	1	3	-1	-1
94aa101	1007	variagated alba	528	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	0	4	-1	-1	1	1	14	3	3	3	-1	-1
83aa227	1008	verify this key #######	775	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.6	-1	-1	0	4	-1	-1	1	1	14	3	5	3	-1	-1
83aa216	1009	0	763	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	3	6	3	-1	-1
104xaa10	1010	0	808	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	0	4	-1	-1	1	1	14	3	7	3	-1	-1
100aa03	1011	0	873	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.4	-1	-1	0	4	-1	-1	1	1	14	3	8	3	-1	-1
104xaa10	1012	0	801	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	0	3	-1	-1	1	1	14	3	9	3	-1	-1
104xaa10	1013	0	818	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	0	4	-1	-1	1	1	14	3	10	3	-1	-1
90xaa10	1014	0	952	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	0	4	-1	-1	1	1	14	3	11	3	-1	-1
83aa206	1015	End rep3, row3	900	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	3	12	3	-1	-1
93xaa10	1016	Sart REP3, row4	525	10	3	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	0	4	-1	-1	1	1	14	4	1	3	-1	-1
93xaa10	1017	Flat 2 test - same clones in f2?	1372	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.5	-1	-1	0	4	-1	-1	1	1	14	4	2	3	-1	-1
93xaa10	1018	Flat 2 test - same clones in f2?	1373	10	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.4	-1	-1	0	3	-1	-1	1	1	14	4	3	3	-1	-1
41aa111	1019	0	757	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.8	-1	-1	0	3	-1	-1	1	1	14	4	4	3	-1	-1
83aa216	1020	0	763	10	3	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.3	-1	-1	0	4	-1	-1	1	1	14	4	5	3	-1	-1
83aa206	1021	0	900	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	4	6	3	-1	-1
104xaa10	1022	0	814	10	7	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	0	4	-1	-1	1	1	14	4	7	3	-1	-1
100xaa10	1023	0	886	10	8	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	4	-1	-1	1	1	14	4	8	3	-1	-1
104xaa10	1024	0	801	10	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	0	3	-1	-1	1	1	14	4	9	3	-1	-1
104xaa10	1025	0	814	10	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	0	4	-1	-1	1	1	14	4	10	3	-1	-1
98xaa10	1026	0	942	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.9	-1	-1	0	4	-1	-1	1	1	14	4	11	3	-1	-1
104xaa10	1027	End rep3, row4	808	10	9	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	0	4	-1	-1	1	1	14	4	12	3	-1	-1
1xcagw	1028	8/26 rooting=  2/6 aspen type	1168	6	2	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.5	-1	-1	1	1	-1	-1	1	1	14	5	1	3	-1	-1
1xcagw	1029	8/26 rooting=  4/7 aspen type	1168	7	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.6	-1	-1	0	0	-1	-1	1	1	14	5	2	3	-1	-1
1xaw	1030	8/26 rooting= 5/7 alba type	1166	8	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	0	0	-1	-1	1	1	14	5	3	3	-1	-1
1xaw	1031	8/26 rooting= 5/6 alba type	1166	6	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0.7	-1	-1	0	0	-1	-1	1	1	14	5	4	3	-1	-1
1xcagw	1032	8/26 rooting= 0/7 alba type Biased=1, edge	1168	7	0	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0	-1	-1	0	1	-1	-1	1	1	14	5	5	3	-1	-1
1xcagw	1033	8/26 rooting= 0/7 alba type	1168	7	0	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0	-1	-1	0	1	-1	-1	1	1	14	5	6	3	-1	-1
1xcagw	1034	8/26 rooting= 5/7 alba type - Yellow tagged	1168	7	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.3	-1	-1	0	1	-1	-1	1	1	14	5	7	3	-1	-1
1xcagw	1035	8/26 rooting=  5/6 aspen type	1168	6	5	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.2	-1	-1	0	1	-1	-1	1	1	14	6	1	3	-1	-1
1cagw01	1036	8/26 rooting=  6/6 Excellent! Aspen type. amily 1xCAGW. Selected as 1CAGW01	1168	6	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.5	-1	-1	0	1	-1	-1	1	1	14	6	2	3	-1	-1
1xaw	1037	8/26 rooting=  2/6  Potential AG - Yellow tagged	1166	6	2	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1	-1	-1	0	1	-1	-1	1	1	14	6	3	3	-1	-1
1xaw	1038	8/26 rooting=  0/6 aspen type	1166	6	0	2012-04-06	2012-09-12	DC  	15	-1	-1	U	0	-1	-1	0	1	-1	-1	1	1	14	6	4	3	-1	-1
1cagw02	1039	8/26 rooting=  4/8 alba type - Vigorous - Family 1xCAGW	1168	8	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.3	-1	-1	0	1	-1	-1	1	1	14	6	5	3	-1	-1
1xcagw	1040	8/26 rooting=  4/8 aspen type - has very thin terminal tips and leaves - bad - Clone for poor aspen rooter	1168	7	4	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.8	-1	-1	0	1	-1	-1	1	1	14	6	6	3	-1	-1
1cagw03	1041	8/26 rooting= 6/7 aspen type - Vigorous - Family 1xCAGW	1168	7	6	2012-04-06	2012-09-12	DC  	15	-1	-1	U	1.3	-1	-1	0	1	-1	-1	1	1	14	6	7	3	-1	-1
c173	1042	1/3 survived Planted 3 WASP tip cuttings - WASP (30' tall)	1	3	1	2012-04-06	2012-09-12	WASP	15	-1	-1	U	0.7	-1	-1	0	1	-1	-1	1	1	14	6	10	3	-1	-1
15ag4mf	1043	Wasp - planted 5/5/12 qty 13 - WASP	1	20	11	2012-04-06	2012-09-12	WASP	15	-1	-1	U	1	-1	-1	0	1	-1	-1	1	1	14	6	11	3	-1	-1
2xb	1044	Seed date= ?, Plant date= ???  SE (estimated counts)	2	70	40	2012-04-06	2012-09-12	SEL 	15	-1	-1	U	-1	-1	-1	0	1	-1	-1	1	1	14	6	12	3	-1	-1
2xb	1045	Seed date= ?, Plant date= ???  SE (estimated counts)	2	250	200	2012-04-06	2012-09-12	SEL 	15	-1	-1	U	-1	-1	-1	0	1	-1	-1	1	1	14	8	1	3	-1	-1
2xb	1046	Seed date= ?, Plant date= ???  SE (estimated counts)	2	70	50	2012-04-06	2012-09-12	SEL 	15	-1	-1	U	-1	-1	-1	0	1	-1	-1	1	1	14	10	1	3	-1	-1
1xcagw	1047	Seed date= ?, Plant date= ???  SE (estimated counts)	2	10	10	2012-04-06	2012-09-12	SEL 	15	-1	-1	U	-1	-1	-1	0	1	-1	-1	1	1	14	10	2	3	-1	-1
41aa111	1048	Qty 3 -  - 1-0	2	3	3	2012-04-06	2012-09-12	1-0 	15	-1	-1	U	1.2	-1	-1	0	2	-1	-1	1	1	14	1	6	4	-1	-1
nfa	1049	Qty 3   - 1-0 - Lots of leaf spots 	765	3	3	2012-04-06	2012-09-12	1-0 	15	-1	-1	U	1.2	-1	-1	0	2	-1	-1	1	1	14	1	7	4	-1	-1
83aa1mf	1050	Qty 2   - 1-0	789	2	2	2012-04-06	2012-09-12	1-0 	15	-1	-1	U	1.2	-1	-1	0	2	-1	-1	1	1	14	1	8	4	-1	-1
a502	1051	Qty 2   - 1-0	755	2	2	2012-04-06	2012-09-12	1-0 	15	-1	-1	U	1	-1	-1	0	2	-1	-1	1	1	14	1	9	4	-1	-1
zoss	1052	Qty 2   - 1-0	2	2	2	2012-04-06	2012-09-12	1-0 	15	-1	-1	U	0.7	-1	-1	0	2	-1	-1	1	1	14	1	10	4	-1	-1
83aa2mf	1053	Qty 2   - 1-0 - was 83aa-uo7m-7-14 (7-4)	2	2	2	2012-04-06	2012-09-12	1-0 	15	-1	-1	U	1	-1	-1	0	2	-1	-1	1	1	14	1	11	4	-1	-1
94aa101	1054	Qty 1 Variagated  - 1-0 - Not much variagation, only on N half	528	1	1	2012-04-06	2012-09-12	1-0 	15	-1	-1	U	1	-1	-1	0	2	-1	-1	1	1	14	1	12	4	-1	-1
40aa6mf	1055	Qty1  - 1-0	858	1	0	2012-04-06	2012-09-12	1-0 	15	-1	-1	U	1	-1	-1	0	2	-1	-1	1	1	14	1	13	4	-1	-1
wasp-2013-01-12-ae1	1056	Clone 93AA12, No soak, rep #1, 8 - 10 cm cuttings, 2 week root test	0	8	6	2013-01-12	2013-01-26	DC  	10	4.75	-1	Y	-1	-1	-1	-1	-1	-1	-1	193	166	18	-1	-1	1	-1	-1
wasp-2013-01-12-ae2	1057	Clone 93AA12, No soak, rep #2, 8 - 10 cm cuttings, 2 week root test	0	8	8	2013-01-12	2013-01-26	DC  	10	5	-1	Y	-1	-1	-1	-1	-1	-1	-1	193	166	18	-1	-1	2	-1	-1
nfa	1058	7' tall, leaf spots	3	1	1	2013-04-20	2013-09-21	1-1 	120	-1	-1	U	20	-1	-1	-1	-1	-1	-1	1	1	20	1	3	0	-1	-1
83aa1mf	1059	Nice Diameter	4	2	2	2013-04-20	2013-09-21	1-1 	120	-1	-1	Y	24	-1	-1	-1	-1	-1	-1	1	1	20	1	4	0	-1	-1
a502	1060	0	5	2	2	2013-04-20	2013-09-21	1-1 	120	-1	-1	U	18	-1	-1	-1	-1	-1	-1	1	1	20	1	5	0	-1	-1
c173	1061	0	6	1	1	2013-04-20	2013-09-21	1-1 	120	-1	-1	U	15	-1	-1	-1	-1	-1	-1	1	1	20	1	6	0	-1	-1
zoss	1062	alba like leaves	7	1	1	2013-04-20	2013-09-21	1-1 	120	-1	-1	U	12	-1	-1	-1	-1	-1	-1	1	1	20	1	7	0	-1	-1
83aa2mf	1063	weaker than 83aa1mf (soil?)	8	2	2	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	12	-1	-1	-1	-1	-1	-1	1	1	20	1	8	0	-1	-1
94aa101	1064	Not much variegation	9	1	1	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	12	-1	-1	-1	-1	-1	-1	1	1	20	1	9	0	-1	-1
41aa111	1065	4' tall	10	1	1	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	1	10	0	-1	-1
2b21	1066	0	11	1	1	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	20	1	11	0	-1	-1
2b29	1067	0	12	1	1	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	20	12	12	0	-1	-1
2b26	1068	0	13	1	1	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	11	-1	-1	-1	-1	-1	-1	1	1	20	1	13	0	-1	-1
2b27	1069	0	14	1	1	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	1	14	0	-1	-1
2b3	1070	0	15	1	1	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	12	-1	-1	-1	-1	-1	-1	1	1	20	1	15	0	-1	-1
2b28	1071	0	16	1	1	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	20	1	16	0	-1	-1
2b2	1072	0	17	1	1	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	13	-1	-1	-1	-1	-1	-1	1	1	20	1	17	0	-1	-1
2b2	1073	0	18	1	1	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	12	-1	-1	-1	-1	-1	-1	1	1	20	1	18	0	-1	-1
2b31	1074	0	19	1	1	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	12	-1	-1	-1	-1	-1	-1	1	1	20	1	19	0	-1	-1
a502	1075	0	23	10	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	2	2	0	-1	-1
41aa111	1076	0	24	10	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	2	3	0	-1	-1
83aa2mf	1077	0	25	10	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	2	4	0	-1	-1
83aa2mf	1078	6mm avg dia cuttings	26	10	6	2013-04-20	2013-09-21	DC  	15	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	2	5	0	-1	-1
80aa3mf	1079	0	30	4	3	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	2	9	0	-1	-1
100aa12	1080	1 large whip each stool	31	6	6	2013-04-20	2013-09-21	1-0 	120	-1	-1	Y	9	-1	-1	-1	-1	-1	-1	1	1	20	2	10	0	-1	-1
cag204	1081	4.5' tall	32	1	1	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	16	-1	-1	-1	-1	-1	-1	1	1	20	2	11	0	-1	-1
1cagw02	1082	1 usable whip per stool	33	3	3	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	13	-1	-1	-1	-1	-1	-1	1	1	20	2	12	0	-1	-1
104aa12	1083	0	34	6	6	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	14	-1	-1	-1	-1	-1	-1	1	1	20	2	13	0	-1	-1
101aa11	1084	5' avg height	35	6	6	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	11	-1	-1	-1	-1	-1	-1	1	1	20	2	14	0	-1	-1
100aa11	1085	0	36	6	6	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	13	-1	-1	-1	-1	-1	-1	1	1	20	2	15	0	-1	-1
1cagw03	1086	0	37	4	4	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	15	-1	-1	-1	-1	-1	-1	1	1	20	2	16	0	-1	-1
98aa11	1087	2 whips per stool	38	6	6	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	14	-1	-1	-1	-1	-1	-1	1	1	20	2	17	0	-1	-1
1cagw01	1088	(I cut one whip for FW test)	39	5	5	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	12	-1	-1	-1	-1	-1	-1	1	1	20	2	18	0	-1	-1
103aa11	1089	0	40	6	6	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	20	2	19	0	-1	-1
94aa101	1090	very little variegation 	41	10	9	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	20	3	20	0	-1	-1
nfa	1091	cuttings were 8inch long and 10mm dia	42	10	7	2013-04-20	2013-09-21	1-0 	120	-1	-1	Y	6	-1	-1	-1	-1	-1	-1	1	1	20	3	21	0	-1	-1
83aa1mf	1092	small dia cuttings (5mm)	43	10	5	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	3	22	0	-1	-1
41aa111	1093	0	44	10	4	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	20	3	23	0	-1	-1
83aa1mf	1094	0	45	10	4	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	4	1	0	-1	-1
1cagw01	1095	NICE!	46	10	8	2013-04-20	2013-09-21	1-0 	120	-1	-1	Y	10	-1	-1	-1	-1	-1	-1	1	1	20	4	2	0	-1	-1
2xb	1096	These are ortets, nice!  8inch cuttings taken from 12inch tips.	47	46	32	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	9	-1	-1	-1	-1	-1	-1	1	1	20	4	3	0	-1	-1
1cagw01	1097	NICE!	48	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	12	-1	-1	-1	-1	-1	-1	1	1	20	4	4	0	-1	-1
2xb	1098	9 are selectable	49	36	30	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	7	-1	-1	-1	-1	-1	-1	1	1	20	4	5	0	-1	-1
83aa1mf	1099	0	50	10	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	5	6	0	-1	-1
1xcagw	1100	13 are selectable	51	34	21	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	8	-1	-1	-1	-1	-1	-1	1	1	20	5	7	0	-1	-1
1cagw01	1101	0	52	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	9	-1	-1	-1	-1	-1	-1	1	1	20	5	8	0	-1	-1
2xb	1102	2mm cutting tips, 24 are good	53	64	47	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	6	-1	-1	-1	-1	-1	-1	1	1	20	5	9	0	-1	-1
104aa11	1103	2 have 3 whips/stool	54	7	7	2013-04-20	2013-09-21	1-0 	120	-1	-1	Y	13	-1	-1	-1	-1	-1	-1	1	1	20	5	10	0	-1	-1
92aa11	1104	0	55	6	6	2013-04-20	2013-09-21	1-0 	120	-1	-1	Y	15	-1	-1	-1	-1	-1	-1	1	1	20	5	11	0	-1	-1
93aa11	1105	0	56	6	6	2013-04-20	2013-09-21	1-0 	120	-1	-1	Y	16	-1	-1	-1	-1	-1	-1	1	1	20	5	12	0	-1	-1
97aa12	1106	0	57	6	6	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	14	-1	-1	-1	-1	-1	-1	1	1	20	5	13	0	-1	-1
93aa12	1107	0	58	6	6	2013-04-20	2013-09-21	1-0 	120	-1	-1	Y	19	-1	-1	-1	-1	-1	-1	1	1	20	5	14	0	-1	-1
97aa11	1108	0	59	6	6	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	15	-1	-1	-1	-1	-1	-1	1	1	20	5	15	0	-1	-1
95aa11	1109	0	60	6	6	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	15	-1	-1	-1	-1	-1	-1	1	1	20	5	16	0	-1	-1
dn34	1110	5 inch cuttings from TRC	61	22	15	2013-04-20	2013-09-21	1-0 	120	-1	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	20	6	1	0	-1	-1
98aa11	1111	12 inch cuttings	62	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	20	6	2	0	-1	-1
98aa11	1112	10 inch cuttings	63	10	10	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	6	3	0	-1	-1
dn34	1113	5 inch cuttings	64	22	13	2013-04-20	2013-09-21	DC  	15	-1	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	20	7	1	0	-1	-1
98aa11	1114	planted as 12 inch cuttings	65	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	7	2	0	-1	-1
98aa11	1115	planted as 10 inch cuttings	66	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	7	3	0	-1	-1
1cagw02	1116	planted as 6 inch cuttings (all below)	67	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	6	4	1	-1	-1
93aa11	1117	0	68	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	6	5	1	-1	-1
93aa12	1118	0	69	10	4	2013-04-20	2013-09-21	DC  	15	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	6	6	1	-1	-1
1cagw01	1119	Poor performance due to slow start?	70	10	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	6	7	1	-1	-1
101aa11	1120	0	71	10	10	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	6	-1	-1	-1	-1	-1	-1	1	1	20	6	8	1	-1	-1
100aa12	1121	0	72	10	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	6	9	1	-1	-1
95aa11	1122	0	73	10	9	2013-04-20	2013-09-21	DC  	15	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	6	10	1	-1	-1
1cagw03	1123	0	74	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	6	11	1	-1	-1
92aa11	1124	0	75	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	6	12	2	-1	-1
93aa12	1125	0	76	10	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	6	13	2	-1	-1
104aa11	1126	0	77	10	3	2013-04-20	2013-09-21	DC  	15	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	6	14	2	-1	-1
104aa12	1127	0	78	10	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	6	15	2	-1	-1
97aa12	1128	0	79	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	6	16	2	-1	-1
95aa11	1129	0	80	10	9	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	6	17	2	-1	-1
1cagw03	1130	0	81	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	6	18	2	-1	-1
100aa12	1131	0	82	10	6	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	6	19	2	-1	-1
cag204	1132	0	83	10	3	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	6	20	3	-1	-1
1cagw03	1133	0	84	10	6	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	6	21	3	-1	-1
100aa12	1134	0	85	10	4	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	6	22	3	-1	-1
101aa11	1135	0	86	10	10	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	6	-1	-1	-1	-1	-1	-1	1	1	20	6	23	3	-1	-1
92aa11	1136	0	87	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	6	24	3	-1	-1
93aa12	1137	0	88	10	1	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	6	25	3	-1	-1
103aa11	1138	0	89	10	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	6	26	3	-1	-1
104aa11	1139	0	90	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	6	27	3	-1	-1
97aa11	1140	0	91	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	7	4	1	-1	-1
92aa11	1141	0	92	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	7	5	1	-1	-1
103aa11	1142	0	93	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	7	6	1	-1	-1
104aa11	1143	0	94	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	8	-1	-1	-1	-1	-1	-1	1	1	20	7	7	1	-1	-1
104aa12	1144	0	95	10	6	2013-04-20	2013-09-21	DC  	15	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	7	8	1	-1	-1
97aa12	1145	0	96	10	10	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	8	-1	-1	-1	-1	-1	-1	1	1	20	7	9	1	-1	-1
cag204	1146	0	97	10	1	2013-04-20	2013-09-21	DC  	15	-1	-1	U	3	-1	-1	-1	-1	-1	-1	1	1	20	7	10	1	-1	-1
100aa11	1147	0	98	10	9	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	7	11	1	-1	-1
98aa11	1148	0	99	10	9	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	8	-1	-1	-1	-1	-1	-1	1	1	20	7	12	1	-1	-1
1cagw02	1149	0	100	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	7	13	2	-1	-1
93aa11	1150	0	101	10	9	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	7	14	2	-1	-1
103aa11	1151	0	102	10	3	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	7	15	2	-1	-1
1cagw01	1152	0	103	10	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	7	16	2	-1	-1
cag204	1153	0	104	10	1	2013-04-20	2013-09-21	DC  	15	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	7	17	2	-1	-1
97aa11	1154	0	105	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	7	18	2	-1	-1
98aa11	1155	0	106	10	10	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	7	19	2	-1	-1
100aa11	1156	0	107	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	7	20	2	-1	-1
101aa11	1157	Biased	108	10	10	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	9	-1	-1	-1	-1	-1	-1	1	1	20	7	21	2	-1	-1
97aa11	1158	0	109	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	7	22	3	-1	-1
97aa12	1159	0	110	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	10	-1	-1	-1	-1	-1	-1	1	1	20	7	23	3	-1	-1
100aa11	1160	0	111	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	7	24	3	-1	-1
98aa11	1161	0	112	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	7	25	3	-1	-1
95aa11	1162	0	113	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	7	26	3	-1	-1
93aa11	1163	0	114	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	7	27	3	-1	-1
104aa12	1164	0	115	10	9	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	7	28	3	-1	-1
1cagw01	1165	0	116	10	9	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	8	-1	-1	-1	-1	-1	-1	1	1	20	7	29	3	-1	-1
2b3	1166	0	117	10	6	2013-04-20	2013-09-21	DC  	15	-1	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	20	8	1	0	-1	-1
2b28	1167	0	118	6	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	8	2	0	-1	-1
2b21	1168	0	119	6	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	8	3	0	-1	-1
2b30	1169	0	120	6	4	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	8	4	0	-1	-1
2b7	1170	Nice	121	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	8	-1	-1	-1	-1	-1	-1	1	1	20	8	5	0	-1	-1
2b1	1171	0	122	6	4	2013-04-20	2013-09-21	DC  	15	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	8	6	0	-1	-1
2b9	1172	2 are dead	123	6	4	2013-04-20	2013-09-21	DC  	15	-1	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	20	8	7	0	-1	-1
2b11	1173	0	124	6	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	8	8	0	-1	-1
2b19	1174	0	125	6	5	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	7	-1	-1	-1	-1	-1	-1	1	1	20	8	9	0	-1	-1
2b12	1175	Nice	126	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	5	-1	-1	-1	-1	-1	-1	1	1	20	8	10	0	-1	-1
2b15	1176	Nice	127	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	8	11	0	-1	-1
2b13	1177	0	128	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	7	-1	-1	-1	-1	-1	-1	1	1	20	8	12	0	-1	-1
2b24	1178	0	129	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	8	13	0	-1	-1
2b40	1179	0	130	6	3	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	8	14	0	-1	-1
2b18	1180	0	131	6	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	8	15	0	-1	-1
2b2	1181	0	132	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	8	16	0	-1	-1
98aa11	1182	0	133	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	8	17	4	-1	-1
1cagw03	1183	0	134	10	9	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	8	18	4	-1	-1
100aa12	1184	0	135	10	7	2013-04-20	2013-09-21	DC  	15	-1	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	20	8	19	4	-1	-1
97aa12	1185	0	136	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	8	20	4	-1	-1
92aa11	1186	0	137	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	12	-1	-1	-1	-1	-1	-1	1	1	20	8	21	4	-1	-1
103aa11	1187	0	138	10	6	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	8	22	4	-1	-1
104aa12	1188	0	139	10	9	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	8	23	4	-1	-1
1cagw01	1189	biased	140	10	9	2013-04-20	2013-09-21	DC  	15	-1	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	20	8	24	4	-1	-1
2b21	1190	clone #21 propagated from root shoots	141	17	14	2013-04-20	2013-09-21	RS  	10	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	8	25	0	-1	-1
3aa202	1191	4' wasp 4-14-13	143	1	1	2013-04-20	2013-09-21	WASP	10	-1	-1	Y	8	-1	-1	-1	-1	-1	-1	1	1	20	8	27	0	-1	-1
22xar	1192	20 potential trees to select from	144	42	20	2013-04-20	2013-09-21	SEL 	6	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	8	28	0	-1	-1
2b27	1193	Biased edge in this row	145	6	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	9	1	0	-1	-1
2b4	1194	0	146	6	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	20	9	2	0	-1	-1
2b29	1195	0	147	6	4	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	10	-1	-1	-1	-1	-1	-1	1	1	20	9	3	0	-1	-1
2b31	1196	0	148	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	9	-1	-1	-1	-1	-1	-1	1	1	20	9	4	0	-1	-1
2b26	1197	0	149	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	9	5	0	-1	-1
2b22	1198	0	150	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	10	-1	-1	-1	-1	-1	-1	1	1	20	9	6	0	-1	-1
2b6	1199	0	151	6	5	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	9	7	0	-1	-1
2b8	1200	0	152	6	3	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	9	8	0	-1	-1
2b5	1201	0	153	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	9	9	0	-1	-1
2b25	1202	0	154	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	11	-1	-1	-1	-1	-1	-1	1	1	20	9	10	0	-1	-1
2b23	1203	0	155	6	4	2013-04-20	2013-09-21	DC  	15	-1	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	20	9	11	0	-1	-1
2b17	1204	0	156	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	8	-1	-1	-1	-1	-1	-1	1	1	20	9	12	0	-1	-1
2b16	1205	0	157	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	10	-1	-1	-1	-1	-1	-1	1	1	20	9	13	0	-1	-1
2b20	1206	0	158	6	3	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	9	14	0	-1	-1
2b10	1207	0	159	6	2	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	9	15	0	-1	-1
2b14	1208	0	160	6	6	2013-04-20	2013-09-21	DC  	15	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	9	16	0	-1	-1
95aa11	1209	start rep. 4- row 9	161	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	9	17	4	-1	-1
100aa11	1210	0	162	10	6	2013-04-20	2013-09-21	DC  	15	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	9	18	4	-1	-1
97aa12	1211	0	163	10	9	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	9	19	4	-1	-1
101aa11	1212	0	164	10	9	2013-04-20	2013-09-21	DC  	15	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	9	20	4	-1	-1
93aa12	1213	0	165	10	8	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	9	21	4	-1	-1
93aa11	1214	0	166	10	10	2013-04-20	2013-09-21	DC  	15	-1	-1	Y	8	-1	-1	-1	-1	-1	-1	1	1	20	9	22	4	-1	-1
104aa11	1215	0	167	10	10	2013-04-20	2013-09-21	DC  	15	-1	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	20	9	23	0	-1	-1
2b21	1216	clone 21, 13 plantable	168	13	13	2013-04-20	2013-09-21	RS  	10	-1	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	20	9	24	0	-1	-1
22xar	1217	27 plantable/selectable	170	38	27	2013-04-20	2013-09-21	SEL 	6	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	9	26	0	-1	-1
3xcagc	1218	0	171	90	63	2013-04-20	2013-09-21	SEL 	6	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	10	1	0	-1	-1
5xcagr	1219	0	172	50	37	2013-04-20	2013-09-21	SEL 	6	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	10	2	0	-1	-1
2xrr	1220	0	173	30	23	2013-04-20	2013-09-21	SEL 	6	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	10	3	0	-1	-1
3xcagc	1221	0	174	90	61	2013-04-20	2013-09-21	SEL 	6	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	11	1	0	-1	-1
5xcagr	1222	0	175	70	55	2013-04-20	2013-09-21	SEL 	6	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	11	2	0	-1	-1
2xrr	1223	0	176	40	29	2013-04-20	2013-09-21	SEL 	6	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	11	3	0	-1	-1
105xaa	1224	0	177	40	29	2013-04-20	2013-09-21	SEL 	6	-1	-1	U	6	-1	140	-1	-1	-1	-1	1	1	20	12	1	0	-1	-1
4xacag	1225	0	178	55	41	2013-04-20	2013-09-21	SEL 	6	-1	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	20	12	2	0	-1	-1
105xaa	1226	0	179	40	26	2013-04-20	2013-09-21	SEL 	6	-1	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	20	13	1	0	-1	-1
4xacag	1227	0	180	55	42	2013-04-20	2013-09-21	SEL 	6	-1	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	20	13	2	0	-1	-1
4xgw	1228	Tallest is 50inch, which is the ONLY AG	181	9	5	2013-07-01	2013-09-21	SEL 	6	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	14	1	0	-1	-1
5xgw	1229	0	182	9	7	2013-07-01	2013-09-21	SEL 	6	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	14	2	0	-1	-1
4xgw	1230	Nice, 16 are AG, 1 is GG	184	17	5	2013-07-01	2013-09-21	SEL 	6	-1	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	20	14	4	0	-1	-1
2xgw	1231	tallest is 30inch, all have a leaf rust. Last 2013 tree.	185	4	4	2013-07-01	2013-09-21	SEL 	6	-1	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	20	14	5	0	-1	-1
100aa11	1232	0	0	10	9	2014-04-20	2014-09-14	DC  	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	3	13	3	-1	-1
100aa11	1233	0	0	10	9	2014-04-20	2014-09-14	DC  	15	10	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	4	5	4	-1	-1
100aa12	1234	0	0	10	7	2014-04-20	2014-09-14	DC  	15	7	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	22	3	15	3	-1	-1
100aa12	1235	0	0	10	6	2014-04-20	2014-09-14	DC  	15	7	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	5	5	4	-1	-1
101aa11	1236	Rep 3 - NICE!	0	10	10	2014-04-20	2014-09-14	DC  	15	10	-1	Y	9	-1	-1	-1	-1	-1	-1	1	1	22	2	9	3	-1	-1
101aa11	1237	0	0	10	10	2014-04-20	2014-09-14	DC  	15	10	-1	Y	8	-1	-1	-1	-1	-1	-1	1	1	22	4	3	4	-1	-1
103aa11	1238	0	0	10	6	2014-04-20	2014-09-14	DC  	15	7	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	22	3	17	3	-1	-1
103aa11	1239	0	0	10	5	2014-04-20	2014-09-14	DC  	15	7	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	22	4	8	4	-1	-1
104aa11	1240	0	0	10	4	2014-04-20	2014-09-14	DC  	15	10	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	3	16	3	-1	-1
104aa11	1241	rep 4	0	10	6	2014-04-20	2014-09-14	DC  	15	10	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	5	1	4	-1	-1
104aa12	1242	ZZ=3mm	0	10	10	2014-04-20	2014-09-14	DC  	15	7	-1	Y	6	-1	-1	-1	-1	-1	-1	1	1	22	2	11	3	-1	-1
104aa12	1243	0	0	10	9	2014-04-20	2014-09-14	DC  	15	7	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	4	4	4	-1	-1
105xaa	1244	ZZ>3mm	0	26	22	2014-04-20	2014-09-14	DC  	15	10	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	8	6	8	-1	-1
105xaa	1245	0	0	26	24	2014-04-20	2014-09-14	ODC 	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	9	6	8	-1	-1
106xaa	1246	ZZ>3mm notes2=TallestHeightCm (Leaf Stem variabilities L=1 H=5 in Leaf_score column)	120	16	15	2014-06-28	2014-09-14	SEL 	6	7	-1	U	5	-1	80	-1	2	-1	-1	1	1	22	16	3	10	-1	-1
106xaa	1247	ZZ>3mm	0	16	14	2014-06-28	2014-09-14	SEL 	6	7	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	17	3	10	-1	-1
107xaa	1248	notes2=TallestHeightCm Leaf undersides not as tomentose as most albas	138	34	33	2014-06-28	2014-09-14	SEL 	6	10	-1	U	6	-1	88	-1	3	-1	-1	1	1	22	18	2	10	-1	-1
107xaa	1249	ZZ>3mm	0	34	34	2014-06-28	2014-09-14	SEL 	6	10	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	19	2	10	-1	-1
11xab	1250	ZZ>3mm notes2=TallestHeightCm Leaves mostly lobed to some intermediate.	135	24	20	2014-06-28	2014-09-14	SEL 	6	10	-1	Y	6	-1	101	-1	4	-1	-1	1	1	22	18	3	10	-1	-1
11xab	1251	ZZ>3mm	0	25	24	2014-06-28	2014-09-14	SEL 	6	10	-1	Y	6	-1	-1	-1	-1	-1	-1	1	1	22	19	3	10	-1	-1
11xab	1252	0	0	19	17	2014-06-28	2014-09-14	SEL 	6	10	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	20	1	10	-1	-1
11xab	1253	ZZ>3mm	0	19	18	2014-06-28	2014-09-14	WASP	6	10	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	21	1	10	-1	-1
12xrb	1254	ZZ>3mm notes2=TallestHeightCm Intermediate leaves with variable margins.	110	7	7	2014-06-28	2014-09-14	SEL 	6	3	-1	U	6	-1	89	-1	4	-1	-1	1	1	22	10	8	10	-1	-1
13xgb	1255	ZZ>3mm notes2=TallestHeightCm	137	18	15	2014-06-28	2014-09-14	SEL 	6	7	-1	U	6	-1	102	-1	4	-1	-1	1	1	22	10	13	10	-1	-1
13xgb	1256	ZZ>3mm Has smaller leaves than 18xbg.	0	21	20	2014-06-28	2014-09-14	SEL 	6	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	11	6	10	-1	-1
14xb	1257	Start 2.5 inch spacing.  ZZ>3mm notes2=TallestHeightCm mostly lobed leaves.	142	43	43	2014-06-28	2014-09-14	SEL 	6	7	-1	U	6	-1	113	-1	4	-1	-1	1	1	22	14	1	10	-1	-1
14xb	1258	ZZ>3mm	0	43	43	2014-06-28	2014-09-14	SEL 	6	7	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	15	1	10	-1	-1
15xb	1259	ZZ>3mm	0	7	6	2014-06-28	2014-09-14	SEL 	6	3	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	10	11	10	-1	-1
15xb	1260	Has tallest tree at 15 mm with a 9 mm collar dia. best family collar=11mm ZZ>3mm notes2=TallestHeightCm Intermediate leaves with variable margins. 	156	23	19	2014-06-28	2014-09-14	SEL 	6	7	-1	Y	7	-1	128	-1	3	-1	-1	1	1	22	11	4	10	-1	-1
16xab	1261	ZZ>3mm notes2=TallestHeightCm Lobed leaves.	122	20	20	2014-06-28	2014-09-14	SEL 	6	7	-1	U	5	-1	85	-1	4	-1	-1	1	1	22	16	2	10	-1	-1
16xab	1262	ZZ>3mm	0	20	20	2014-06-28	2014-09-14	SEL 	6	7	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	17	2	10	-1	-1
17xb	1263	ZZ>3mm notes2=TallestHeightCm Intermediate leaves with variable margins.	112	12	7	2014-06-28	2014-09-14	SEL 	6	5	-1	U	6	-1	67	-1	4	-1	-1	1	1	22	11	3	10	-1	-1
18xbg	1264	ZZ>3mm	0	50	47	2014-06-28	2014-09-14	SEL 	6	10	-1	Y	7	-1	-1	-1	-1	-1	-1	1	1	22	10	12	10	-1	-1
18xbg	1265	Leaves have trace yellow spots (not rust) on some leaves.  ZZ>3mm notes2=TallestHeightCm Intermediate characteristics	133	50	50	2014-06-28	2014-09-14	SEL 	6	10	-1	Y	6	-1	107	-1	2	-1	-1	1	1	22	11	5	10	-1	-1
19xgb	1266	ZZ>3mm	0	21	20	2014-06-28	2014-09-14	SEL 	6	7	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	12	4	10	-1	-1
19xgb	1267	All ortets have yellow spots on leaves (not rust).  ZZ>3mm notes2=TallestHeightCm	126	22	20	2014-06-28	2014-09-14	SEL 	6	7	-1	U	6	-1	83	-1	2	-1	-1	1	1	22	13	4	10	-1	-1
1cagw01	1268	(2mm ZZ)	0	4	3	2014-04-20	2014-09-14	DC  	15	10	-1	U	15	-1	-1	-1	-1	-1	-1	1	1	22	1	17	1	-1	-1
1cagw01	1269	0	0	10	6	2014-04-20	2014-09-14	DC  	15	10	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	22	2	5	2	-1	-1
1cagw01	1270	0	0	10	8	2014-04-20	2014-09-14	DC  	15	7	-1	U	6	-1	170	-1	-1	-1	-1	1	1	22	3	6	2	-1	-1
1cagw01	1271	0	0	10	7	2014-04-20	2014-09-14	DC  	15	10	-1	Y	10	-1	-1	-1	-1	-1	-1	1	1	22	3	18	3	-1	-1
1cagw01	1272	0	0	10	9	2014-04-20	2014-09-14	DC  	15	10	-1	Y	10	-1	145	-1	-1	-1	-1	1	1	22	5	7	4	-1	-1
1cagw01	1273	0	0	10	6	2014-04-20	2014-09-14	DC  	15	10	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	6	7	6	-1	-1
1cagw01	1274	0	0	10	9	2014-04-20	2014-09-14	DC  	15	10	-1	Y	9	-1	-1	-1	-1	-1	-1	1	1	22	7	7	6	-1	-1
1cagw02	1275	ZZ=2mm	0	10	8	2014-04-20	2014-09-14	DC  	15	10	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	2	16	3	-1	-1
1cagw02	1276	0	0	10	7	2014-04-20	2014-09-14	DC  	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	4	9	4	-1	-1
1cagw03	1277	0	0	10	9	2014-04-20	2014-09-14	DC  	15	7	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	3	19	3	-1	-1
1cagw03	1278	0	0	10	8	2014-04-20	2014-09-14	DC  	15	10	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	4	6	4	-1	-1
1xbar	1279	notes2=TallestHeightCm Has all leaf shapes/margins, not vigorous.	78	3	3	2014-06-28	2014-09-14	SEL 	6	3	-1	U	4	-1	49	-1	5	-1	-1	1	1	22	10	4	9	-1	-1
1xcagw	1280	Ortets Rep 8. The male may be small tooth due to lack of tomentose similar to 7xbt.	0	5	3	2014-04-20	2014-09-14	DC  	15	10	-1	Y	13	-1	-1	-1	-1	-1	-1	1	1	22	8	1	8	-1	-1
1xcagw	1281	Alba types	0	5	5	2014-04-20	2014-09-14	ODC 	15	5	-1	Y	12	-1	175	-1	-1	-1	-1	1	1	22	9	1	8	-1	-1
20xbs	1282	0	0	10	10	2014-06-28	2014-09-14	SEL 	6	7	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	22	16	4	10	-1	-1
20xbs	1283	All ortets have lobed alba like leaves, tomentose. I expect this to be a mistake.	0	10	8	2014-06-28	2014-09-14	SEL 	6	7	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	17	4	10	-1	-1
20xbs	1284	All ortets have lobed alba like leaves, tomentose. I expect this to be a mistake.	0	29	29	2014-06-28	2014-09-14	SEL 	6	7	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	18	1	10	-1	-1
20xbs	1285	ZZ>3mm notes2=TallestHeightCm Lobed leaves.	149	29	27	2014-06-28	2014-09-14	SEL 	6	7	-1	U	6	-1	80	-1	3	-1	-1	1	1	22	19	1	10	-1	-1
21xba	1286	ZZ>3mm notes2=TallestHeightCm	137	21	20	2014-06-28	2014-09-14	SEL 	6	3	-1	U	6	-1	105	-1	3	-1	-1	1	1	22	10	10	10	-1	-1
22xar	1287	Ramets not ortets	0	10	6	2014-06-28	2014-09-14	DC  	15	10	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	22	3	5	2	-1	-1
22xar	1288	ZZ>3mm	0	20	17	2014-06-28	2014-09-14	DC  	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	8	5	8	-1	-1
22xar	1289	0	0	20	18	2014-06-28	2014-09-14	ODC 	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	9	5	8	-1	-1
22xbg	1290	ZZ>3mm	0	47	45	2014-06-28	2014-09-14	SEL 	6	7	-1	Y	5	-1	-1	-1	-1	-1	-1	1	1	22	14	2	10	-1	-1
22xbg	1291	4 ortets have varying sized leaf spots. One serious.  ZZ>3mm notes2=TallestHeightCm	130	49	48	2014-06-28	2014-09-14	SEL 	6	7	-1	Y	5	-1	90	-1	4	-1	-1	1	1	22	15	2	10	-1	-1
23xba	1292	5 inch spacing, ZZ>3mm 14 have a LOT of Zig Zag, most of which are runts.  	130	37	36	2014-06-28	2014-09-14	SEL 	6	10	-1	U	6	-1	101	-1	4	-1	-1	1	1	22	20	2	10	-1	-1
23xba	1293	5 inch spacing. ZZ>3mm	0	37	36	2014-06-28	2014-09-14	WASP	6	10	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	21	2	10	-1	-1
23xba	1294	14 have a LOT of Zig Zag. most of which are runts.  ZZ>3mm	0	43	33	2014-06-28	2014-09-14	WASP	6	10	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	22	1	10	-1	-1
23xba	1295	ZZ>3mm	0	47	43	2014-06-28	2014-09-14	WASP	6	10	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	22	2	10	-1	-1
2b12	1296	0	0	10	2	2014-04-20	2014-09-14	DC  	15	10	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	22	7	21	7	-1	-1
2b13	1297	zz=2mm	0	10	6	2014-04-20	2014-09-14	DC  	15	7	-1	U	3	-1	-1	-1	-1	-1	-1	1	1	22	7	4	6	-1	-1
2b14	1298	0	0	10	7	2014-04-20	2014-09-14	DC  	15	7	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	4	16	5	-1	-1
2b14	1299	0	0	10	4	2014-04-20	2014-09-14	DC  	15	7	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	22	7	16	7	-1	-1
2b16	1300	0	0	10	4	2014-04-20	2014-09-14	DC  	15	10	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	4	13	5	-1	-1
2b16	1301	0	0	10	4	2014-04-20	2014-09-14	DC  	15	10	-1	U	15	-1	-1	-1	-1	-1	-1	1	1	22	6	16	7	-1	-1
2b16	1302	0	0	10	6	2014-04-20	2014-09-14	DC  	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	7	3	6	-1	-1
2b17	1303	0	0	10	7	2014-04-20	2014-09-14	DC  	15	7	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	22	4	17	5	-1	-1
2b17	1304	0	0	10	6	2014-04-20	2014-09-14	DC  	15	7	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	7	19	7	-1	-1
2b19	1305	0	0	10	7	2014-04-20	2014-09-14	DC  	15	5	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	4	15	5	-1	-1
2b19	1306	ZZ>3mm	0	10	4	2014-04-20	2014-09-14	DC  	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	7	18	7	-1	-1
2b2	1307	0	0	10	5	2014-04-20	2014-09-14	DC  	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	6	6	6	-1	-1
2b2	1308	0	0	10	3	2014-04-20	2014-09-14	DC  	15	5	-1	U	3	-1	-1	-1	-1	-1	-1	1	1	22	6	20	7	-1	-1
2b21	1309	ZZ=2.5mm, Nice!	0	10	10	2014-04-20	2014-09-14	DC  	15	10	-1	Y	10	-1	170	-1	-1	-1	-1	1	1	22	2	4	2	-1	-1
2b21	1310	ZZ=2mm	0	10	8	2014-04-20	2014-09-14	DC  	15	10	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	3	4	2	-1	-1
2b21	1311	zz=2mm	0	10	8	2014-04-20	2014-09-14	DC  	15	10	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	6	5	6	-1	-1
2b21	1312	zz=2mm	0	10	9	2014-04-20	2014-09-14	DC  	15	10	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	22	7	6	6	-1	-1
2b22	1313	0	0	10	7	2014-04-20	2014-09-14	DC  	15	7	-1	U	11	-1	-1	-1	-1	-1	-1	1	1	22	5	14	5	-1	-1
2b22	1314	biased	0	10	7	2014-04-20	2014-09-14	DC  	15	7	-1	U	13	-1	-1	-1	-1	-1	-1	1	1	22	6	14	7	-1	-1
2b24	1315	0	0	10	6	2014-04-20	2014-09-14	DC  	15	7	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	22	4	11	5	-1	-1
2b24	1316	0	0	10	5	2014-04-20	2014-09-14	DC  	15	7	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	6	3	6	-1	-1
2b25	1317	Nice! Rep 5	0	10	7	2014-04-20	2014-09-14	DC  	15	7	-1	Y	11	-1	206	-1	-1	-1	-1	1	1	22	4	10	5	-1	-1
2b25	1318	0	0	10	7	2014-04-20	2014-09-14	DC  	15	7	-1	Y	15	-1	271	-1	-1	-1	-1	1	1	22	5	12	5	-1	-1
2b25	1319	0	0	10	5	2014-04-20	2014-09-14	DC  	15	10	-1	U	13	-1	208	-1	-1	-1	-1	1	1	22	6	18	7	-1	-1
2b26	1320	ZZ>3mm	0	10	5	2014-04-20	2014-09-14	DC  	15	7	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	22	4	12	5	-1	-1
2b26	1321	0	0	10	6	2014-04-20	2014-09-14	DC  	15	10	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	22	6	15	7	-1	-1
2b29	1322	0	0	10	6	2014-04-20	2014-09-14	DC  	15	10	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	4	14	5	-1	-1
2b29	1323	zz=2mm	0	10	6	2014-04-20	2014-09-14	DC  	15	10	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	22	7	14	7	-1	-1
2b3	1324	0	0	10	7	2014-04-20	2014-09-14	DC  	15	10	-1	U	11	-1	-1	-1	-1	-1	-1	1	1	22	6	19	7	-1	-1
2b3	1325	0	0	10	9	2014-04-20	2014-09-14	DC  	15	10	-1	U	11	-1	-1	-1	-1	-1	-1	1	1	22	6	21	7	-1	-1
2b3	1326	zz=2mm	0	10	7	2014-04-20	2014-09-14	DC  	15	10	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	22	7	5	6	-1	-1
2b30	1327	0	0	10	4	2014-04-20	2014-09-14	DC  	15	10	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	6	4	6	-1	-1
2b31	1328	0	0	10	4	2014-04-20	2014-09-14	DC  	15	7	-1	U	11	-1	-1	-1	-1	-1	-1	1	1	22	5	11	5	-1	-1
2b31	1329	0	0	10	4	2014-04-20	2014-09-14	DC  	15	10	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	22	5	16	5	-1	-1
2b31	1330	0	0	10	8	2014-04-20	2014-09-14	DC  	15	10	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	7	2	6	-1	-1
2b31	1331	0	0	3	1	2014-04-20	2014-09-14	ODC 	15	7	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	8	17	8	-1	-1
2b4	1332	0	0	10	8	2014-04-20	2014-09-14	DC  	15	7	-1	Y	9	-1	-1	-1	-1	-1	-1	1	1	22	5	15	5	-1	-1
2b4	1333	0	0	10	5	2014-04-20	2014-09-14	DC  	15	7	-1	U	11	-1	-1	-1	-1	-1	-1	1	1	22	7	15	7	-1	-1
2b4	1334	0	0	10	5	2014-04-20	2014-09-14	DC  	15	10	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	7	20	7	-1	-1
2b41	1335	0	0	10	2	2014-04-20	2014-09-14	DC  	15	10	-1	U	3	-1	-1	-1	-1	-1	-1	1	1	22	6	13	6	-1	-1
2b42	1336	0	0	8	2	2014-04-20	2014-09-14	DC  	15	10	-1	U	13	-1	-1	-1	-1	-1	-1	1	1	22	1	19	2	-1	-1
2b5	1337	0	0	10	5	2014-04-20	2014-09-14	DC  	15	10	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	5	17	5	-1	-1
2b6	1338	0	0	10	8	2014-04-20	2014-09-14	DC  	15	7	-1	Y	9	-1	-1	-1	-1	-1	-1	1	1	22	5	13	5	-1	-1
2b6	1339	zz=2mm	0	10	7	2014-04-20	2014-09-14	DC  	15	5	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	7	17	7	-1	-1
2b7	1340	rep 5	0	10	6	2014-04-20	2014-09-14	DC  	15	7	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	5	10	5	-1	-1
2b7	1341	0	0	10	8	2014-04-20	2014-09-14	DC  	15	10	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	22	6	2	6	-1	-1
2b50	1342	Nice 2014 selection for vigor (301 cm tall).	0	1	1	2014-04-20	2014-09-14	DC  	15	10	-1	Y	18	-1	301	-1	-1	-1	-1	1	1	22	2	1	2	-1	-1
2b51	1343	Nice 2014 selection for dark red fall leaves	0	1	1	2014-04-20	2014-09-14	DC  	15	10	-1	Y	14	-1	216	-1	-1	-1	-1	1	1	22	2	1	2	-1	-1
2rr1	1344	ZZ>3mm	0	8	2	2014-04-20	2014-09-14	DC  	15	5	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	8	13	8	-1	-1
2rr10	1345	0	0	8	0	2014-04-20	2014-09-14	DC  	15	7	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	8	9	8	-1	-1
2rr2	1346	0	0	8	1	2014-04-20	2014-09-14	ODC 	15	7	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	9	12	8	-1	-1
2rr3	1347	0	0	8	2	2014-04-20	2014-09-14	ODC 	15	10	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	22	9	9	8	-1	-1
2rr4	1348	0	0	8	2	2014-04-20	2014-09-14	ODC 	15	5	-1	U	3	-1	-1	-1	-1	-1	-1	1	1	22	9	13	8	-1	-1
2rr6	1349	0	0	8	2	2014-04-20	2014-09-14	ODC 	15	7	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	9	10	8	-1	-1
2rr7	1350	0	0	8	3	2014-04-20	2014-09-14	DC  	15	5	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	22	8	12	8	-1	-1
2rr8	1351	0	0	8	3	2014-04-20	2014-09-14	DC  	15	7	-1	U	3	-1	-1	-1	-1	-1	-1	1	1	22	8	10	8	-1	-1
2rr9	1352	0	0	8	0	2014-04-20	2014-09-14	ODC 	15	10	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	9	11	8	-1	-1
2xb	1353	Ortets. Nice! 5 selections, 2 for ZZ, one is huge!  (was renamed from 2xcag12)	0	22	17	2014-04-20	2014-09-14	DC  	15	10	-1	U	12	-1	-1	-1	-1	-1	-1	1	1	22	2	1	2	-1	-1
2xb	1354	Ortets (was renamed from 2xcag12)	0	21	12	2014-04-20	2014-09-14	DC  	15	5	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	22	2	2	2	-1	-1
2xb	1355	Ortets (was renamed from 2xcag12)	0	18	14	2014-04-20	2014-09-14	DC  	15	5	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	3	3	2	-1	-1
2xrr	1356	Highly variable	0	24	12	2014-04-20	2014-09-14	DC  	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	8	2	8	-1	-1
2xrr	1357	0	0	24	18	2014-04-20	2014-09-14	ODC 	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	9	2	8	-1	-1
3aa202	1358	2013 P4 parent (2 mm ZZ) keep Wasp 4/14	0	1	1	2014-04-20	2014-09-14	WASP	6	10	-1	Y	10	-1	-1	-1	-1	-1	-1	1	1	22	1	9	1	-1	-1
3xcagc	1359	ZZ>3mm	0	17	13	2014-04-20	2014-09-14	DC  	15	10	-1	Y	6	-1	-1	-1	-1	-1	-1	1	1	22	8	4	8	-1	-1
3xcagc	1360	Nice!	0	18	14	2014-04-20	2014-09-14	ODC 	15	10	-1	Y	9	-1	-1	-1	-1	-1	-1	1	1	22	9	4	8	-1	-1
3xrr	1361	ZZ>3mm notes2=TallestHeightCm	118	11	11	2014-04-20	2014-09-14	SEL 	6	3	-1	U	7	-1	78	-1	4	-1	-1	1	1	22	10	9	10	-1	-1
41aa111	1362	P3 Parent	0	2	2	2014-04-20	2014-09-14	1-1 	30	10	-1	U	13	-1	-1	-1	-1	-1	-1	1	1	22	1	12	1	-1	-1
4acag2	1363	0	0	8	5	2014-04-20	2014-09-14	ODC 	15	10	-1	U	12	-1	-1	-1	-1	-1	-1	1	1	22	8	16	8	-1	-1
4acag3	1364	0	0	8	5	2014-04-20	2014-09-14	ODC 	15	7	-1	Y	14	-1	-1	-1	-1	-1	-1	1	1	22	9	14	8	-1	-1
4acag4	1365	Verify Clone ID	0	8	6	2014-04-20	2014-09-14	ODC 	15	10	-1	Y	15	-1	-1	-1	-1	-1	-1	1	1	22	9	17	8	-1	-1
4cag1	1366	ok	0	8	5	2014-04-20	2014-09-14	DC  	15	7	-1	U	3	-1	-1	-1	-1	-1	-1	1	1	22	8	11	8	-1	-1
4gw1	1367	0	0	8	0	2014-04-20	2014-09-14	ODC 	15	7	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	8	15	8	-1	-1
4gw2	1368	0	0	8	0	2014-04-20	2014-09-14	ODC 	15	10	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	8	14	8	-1	-1
4gw3	1369	0	0	8	1	2014-04-20	2014-09-14	ODC 	15	5	-1	U	15	-1	-1	-1	-1	-1	-1	1	1	22	9	15	8	-1	-1
4xacag	1370	0	0	37	27	2014-04-20	2014-09-14	DC  	15	7	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	8	8	8	-1	-1
4xacag	1371	0	0	38	33	2014-04-20	2014-09-14	ODC 	15	10	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	9	8	8	-1	-1
4xgw	1372	Some have zz=5mm. GA types measured only. 	0	8	4	2014-04-20	2014-09-14	DC  	15	10	-1	Y	9	-1	-1	-1	-1	-1	-1	1	1	22	8	3	8	-1	-1
4xgw	1373	ZZ>3mm	0	7	5	2014-04-20	2014-09-14	ODC 	15	10	-1	U	12	-1	-1	-1	-1	-1	-1	1	1	22	9	3	8	-1	-1
4xgw	1374	ZZ>3mm notes2=TallestHeightCm	123	23	19	2014-06-28	2014-09-14	SEL 	6	5	-1	U	5	-1	104	-1	4	-1	-1	1	1	22	12	5	10	-1	-1
4xgw	1375	End 2 inch spacing.  ZZ>3mm	0	22	19	2014-06-28	2014-09-14	SEL 	6	5	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	13	5	10	-1	-1
4xrr	1376	Very diverse, ZZ>3mm notes2=TallestHeightCm	110	6	6	2014-06-28	2014-09-14	SEL 	6	7	-1	U	6	-1	70	-1	5	-1	-1	1	1	22	11	2	10	-1	-1
5xcagr	1377	Ortets	0	10	6	2014-04-20	2014-09-14	DC  	15	10	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	2	3	2	-1	-1
5xcagr	1378	ZZ>3mm	0	39	30	2014-04-20	2014-09-14	DC  	15	7	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	22	8	7	8	-1	-1
5xcagr	1379	0	0	42	36	2014-04-20	2014-09-14	ODC 	15	7	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	9	7	8	-1	-1
5xGW	1380	GA ortets - Poor - P. smithii - discard 	0	3	3	2014-04-20	2014-09-14	DC  	15	5	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	1	8	1	-1	-1
5xrb	1381	Highly variable, ZZ>3mm notes2=TallestHeightCm	128	17	14	2014-06-28	2014-09-14	SEL 	6	7	-1	U	5	-1	60	-1	5	-1	-1	1	1	22	12	3	10	-1	-1
5xrb	1382	notes2=TallestHeightCm	0	16	12	2014-06-28	2014-09-14	SEL 	6	7	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	13	3	10	-1	-1
6xba	1383	ZZ>3mm notes2=TallestHeightCm	115	24	23	2014-06-28	2014-09-14	SEL 	6	7	-1	U	5	-1	82	-1	2	-1	-1	1	1	22	12	2	10	-1	-1
6xba	1384	ZZ>3mm	0	24	23	2014-06-28	2014-09-14	SEL 	6	7	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	13	2	10	-1	-1
7xbt	1385	Many ortets have blotchy yellowing late leaves. ZZ>3mm notes2=TallestHeightCm	141	46	42	2014-06-28	2014-09-14	SEL 	6	10	-1	Y	5	-1	100	-1	3	-1	-1	1	1	22	16	1	10	-1	-1
7xbt	1386	All have green leave undersides, similar to the 1xCAGW aspen types.  	0	46	41	2014-06-28	2014-09-14	SEL 	6	10	-1	Y	6	-1	-1	-1	-1	-1	-1	1	1	22	17	1	10	-1	-1
80aa3mf	1387	P3 Parent (2 mm ZZ)	0	2	2	2014-04-20	2014-09-14	1-0 	30	10	-1	Y	14	-1	-1	-1	-1	-1	-1	1	1	22	1	13	1	-1	-1
80aa3mf	1388	May have Topophysis? WASP started 4/17.	0	4	3	2014-04-20	2014-09-14	WASP	6	5	-1	U	13	-1	-1	-1	-1	-1	-1	1	1	22	10	2	9	-1	-1
82aa3	1389	0	0	10	0	2014-06-28	2014-09-14	WASP	6	5	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	3	1	2	-1	-1
82aa3	1390	May have Topophysis? WASP started 4/14. 	0	1	1	2014-06-28	2014-09-14	WASP	6	5	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	10	5	9	-1	-1
83aa1mf	1391	P3 Parent	0	1	1	2014-04-20	2014-09-14	1-0 	30	10	-1	U	14	-1	-1	-1	-1	-1	-1	1	1	22	1	14	1	-1	-1
83aa1mf	1392	0	0	10	1	2014-04-20	2014-09-14	1-0 	30	10	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	3	10	2	-1	-1
83aa2mf	1393	P3 Parent	0	2	2	2014-04-20	2014-09-14	1-0 	30	10	-1	U	14	-1	-1	-1	-1	-1	-1	1	1	22	1	11	1	-1	-1
83aa565	1394	tiny cuttings	0	10	0	2014-04-20	2014-09-14	DC  	15	3	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	3	7	2	-1	-1
83aa565	1395	small cuttings	0	10	0	2014-04-20	2014-09-14	DC  	15	5	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	3	8	2	-1	-1
83aa5mf	1396	0	0	10	5	2014-04-20	2014-09-14	DC  	15	3	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	3	2	2	-1	-1
83aa85f	1397	Discard? ZZ>3mm	0	6	1	2014-04-20	2014-09-14	ODC 	15	7	-1	U	12	-1	-1	-1	-1	-1	-1	1	1	22	8	18	8	-1	-1
89aa1	1398	0	0	10	0	2014-04-20	2014-09-14	DC  	15	7	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	6	10	6	-1	-1
89aa1	1399	zz=2mm ok	0	10	3	2014-04-20	2014-09-14	DC  	15	10	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	7	13	6	-1	-1
89aa10	1400	0	0	10	2	2014-04-20	2014-09-14	DC  	15	7	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	22	7	8	6	-1	-1
89aa2	1401	0	0	10	0	2014-04-20	2014-09-14	DC  	15	7	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	6	12	6	-1	-1
89aa3	1402	0	0	10	0	2014-04-20	2014-09-14	DC  	15	5	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	7	11	6	-1	-1
89aa4	1403	Early good rooter. ok	0	10	4	2014-04-20	2014-09-14	DC  	15	10	-1	U	6	-1	50	-1	-1	-1	-1	1	1	22	7	10	6	-1	-1
89aa5	1404	was 89xaa10-5	0	10	1	2014-04-20	2014-09-14	DC  	15	7	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	6	8	6	-1	-1
89aa6	1405	0	0	10	0	2014-04-20	2014-09-14	DC  	15	7	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	7	9	6	-1	-1
89aa7	1406	0	0	10	1	2014-04-20	2014-09-14	DC  	15	5	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	22	7	12	6	-1	-1
89aa8	1407	0	0	10	0	2014-04-20	2014-09-14	DC  	15	10	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	6	9	6	-1	-1
89aa9	1408	0	0	10	1	2014-04-20	2014-09-14	DC  	15	7	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	6	11	6	-1	-1
8xbg	1409	ZZ>3mm notes2=TallestHeightCm	119	23	23	2014-06-28	2014-09-14	SEL 	6	7	-1	U	6	-1	90	-1	2	-1	-1	1	1	22	12	1	10	-1	-1
8xbg	1410	ZZ>3mm	0	24	23	2014-06-28	2014-09-14	SEL 	6	7	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	13	1	10	-1	-1
92aa11	1411	ZZ>3mm	0	10	6	2014-04-20	2014-09-14	DC  	15	10	-1	Y	9	-1	-1	-1	-1	-1	-1	1	1	22	2	15	3	-1	-1
92aa11	1412	1st tree in rep is 8'+.  ZZ>3mm	0	10	7	2014-04-20	2014-09-14	DC  	15	10	-1	Y	10	-1	-1	-1	-1	-1	-1	1	1	22	4	2	4	-1	-1
93aa11	1413	0	0	10	7	2014-04-20	2014-09-14	DC  	15	10	-1	U	13	-1	203	-1	-1	-1	-1	1	1	22	2	14	3	-1	-1
93aa11	1414	0	0	10	4	2014-04-20	2014-09-14	DC  	15	10	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	22	4	7	4	-1	-1
93aa12	1415	ZZ=3mm	0	10	5	2014-04-20	2014-09-14	DC  	15	7	-1	Y	6	-1	104	-1	-1	-1	-1	1	1	22	2	13	3	-1	-1
93aa12	1416	0	0	10	7	2014-04-20	2014-09-14	DC  	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	5	2	4	-1	-1
95aa11	1417	0	0	10	10	2014-04-20	2014-09-14	DC  	15	10	-1	U	8	-1	-1	-1	-1	-1	-1	1	1	22	2	10	3	-1	-1
95aa11	1418	0	0	10	9	2014-04-20	2014-09-14	DC  	15	10	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	5	3	4	-1	-1
97aa11	1419	shaded	0	10	6	2014-04-20	2014-09-14	DC  	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	3	20	3	-1	-1
97aa11	1420	Rep 4	0	10	10	2014-04-20	2014-09-14	DC  	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	4	1	4	-1	-1
97aa12	1421	0	0	10	8	2014-04-20	2014-09-14	DC  	15	10	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	22	3	14	3	-1	-1
97aa12	1422	0	0	10	7	2014-04-20	2014-09-14	DC  	15	10	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	5	9	4	-1	-1
98aa11	1423	ZZ=2mm shaded	0	10	5	2014-04-20	2014-09-14	DC  	15	10	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	2	17	3	-1	-1
98aa11	1424	ZZ=2mm Nice!	0	10	9	2014-04-20	2014-09-14	DC  	15	10	-1	Y	7	-1	-1	-1	-1	-1	-1	1	1	22	3	12	3	-1	-1
98aa11	1425	0	0	10	10	2014-04-20	2014-09-14	DC  	15	10	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	5	4	4	-1	-1
98aa11	1426	0	0	10	9	2014-04-20	2014-09-14	DC  	15	10	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	22	5	8	4	-1	-1
9xbr	1427	ZZ>3mm notes2=TallestHeightCm 50/50 lobed to intermediate leaves.	122	4	4	2014-06-28	2014-09-14	SEL 	6	7	-1	U	8	-1	80	-1	5	-1	-1	1	1	22	11	1	10	-1	-1
a502	1428	P1/2/3 Parent	0	3	3	2014-04-20	2014-09-14	1-0 	30	10	-1	U	15	-1	-1	-1	-1	-1	-1	1	1	22	1	10	1	-1	-1
aag2001	1429	May have Topophysis? WASP started 4/2	0	3	3	2014-04-20	2014-09-14	WASP	6	3	-1	U	3	-1	40	-1	-1	-1	-1	1	1	22	10	3	9	-1	-1
agrr1	1430	zz=2mm (verify this on ortet)	0	2	2	2014-04-20	2014-09-14	1-0 	30	10	-1	U	15	-1	89	-1	-1	-1	-1	1	1	22	7	22	7	-1	-1
agrr1	1431	0	0	3	0	2014-04-20	2014-09-14	DC  	15	5	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	7	23	7	-1	-1
c173	1432	3/4 inch collar,Topophysis? Replace? 8 foot tall	0	1	1	2014-04-20	2014-09-14	1-0 	30	10	-1	U	20	-1	-1	-1	-1	-1	-1	1	1	22	1	7	1	-1	-1
c173	1433	0	0	4	0	2014-04-20	2014-09-14	1-0 	30	10	-1	U	0	-1	-1	-1	-1	-1	-1	1	1	22	3	9	2	-1	-1
c173	1434	May have Topophysis? WASP started 4/17.	0	5	4	2014-04-20	2014-09-14	WASP	6	10	-1	U	10	-1	-1	-1	-1	-1	-1	1	1	22	10	1	9	-1	-1
cag204	1435	3 plantable	0	10	0	2014-04-20	2014-09-14	DC  	15	7	-1	U	0	-1	145	-1	-1	-1	-1	1	1	22	2	6	2	-1	-1
cag204	1436	0	0	10	5	2014-04-20	2014-09-14	DC  	15	10	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	2	7	2	-1	-1
dn34	1437	Control clone	0	3	3	2014-04-20	2014-09-14	DC  	15	7	-1	U	6	-1	138	-1	-1	-1	-1	1	1	22	1	18	1	-1	-1
dn34	1438	0	0	19	12	2014-04-20	2014-09-14	DC  	15	7	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	2	8	2	-1	-1
dn34	1439	0	0	10	9	2014-04-20	2014-09-14	DC  	15	7	-1	U	5	-1	-1	-1	-1	-1	-1	1	1	22	2	12	3	-1	-1
dn34	1440	0	0	10	7	2014-04-20	2014-09-14	DC  	15	7	-1	U	6	-1	-1	-1	-1	-1	-1	1	1	22	3	11	2	-1	-1
dn34	1441	0	0	10	9	2014-04-20	2014-09-14	DC  	15	7	-1	U	9	-1	-1	-1	-1	-1	-1	1	1	22	5	6	4	-1	-1
nfa	1442	P3 Parent	0	2	2	2014-04-20	2014-09-14	1-0 	30	10	-1	U	13	-1	-1	-1	-1	-1	-1	1	1	22	1	15	1	-1	-1
plaza	1443	WASP started Topophysis? Replace? ZZ>3mm	0	3	3	2014-06-28	2014-09-14	WASP	6	5	-1	U	7	-1	-1	-1	-1	-1	-1	1	1	22	10	7	9	-1	-1
rr5	1444	0	0	8	5	2014-04-20	2014-09-14	ODC 	15	10	-1	U	4	-1	-1	-1	-1	-1	-1	1	1	22	9	16	8	-1	-1
zoss	1445	rep 6	0	10	1	2014-04-20	2014-09-14	1-0 	30	7	-1	U	3	-1	-1	-1	-1	-1	-1	1	1	22	6	1	6	-1	-1
17XGA24	1446	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	1	1	-1	-1	1
17XGA04	1447	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	25.5	-1	-1	-1	-1	-1	1	1	23	2	1	-1	-1	1
17XGA04	1448	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	63.8	-1	-1	-1	-1	-1	1	1	23	3	1	-1	-1	1
17XGA5	1449	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	4	1	-1	-1	1
82XAA04	1450	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	5	1	-1	-1	1
82XAA04	1451	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	6	1	-1	-1	1
82XAA04	1452	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	69.4	-1	-1	-1	-1	-1	1	1	23	7	1	-1	-1	1
82XAA04	1453	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	1	-1	-1	1
2XT4E04	1454	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	1	-1	-1	1
2XT4E04	1455	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	1	-1	-1	1
2XT4E04	1456	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	1	-1	-1	1
2XT4E04	1457	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	1	-1	-1	1
83XAA04	1458	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	69.4	-1	-1	-1	-1	-1	1	1	23	13	1	-1	-1	1
83XAA04	1459	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	78.2	-1	-1	-1	-1	-1	1	1	23	14	1	-1	-1	1
83XAA04	1460	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	75	-1	-1	-1	-1	-1	1	1	23	15	1	-1	-1	1
83XAA04	1461	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	71	-1	-1	-1	-1	-1	1	1	23	16	1	-1	-1	1
81XAA04	1462	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	17	1	-1	-1	1
81XAA04	1463	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	74.2	-1	-1	-1	-1	-1	1	1	23	18	1	-1	-1	1
81XAA04	1464	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	63	-1	-1	-1	-1	-1	1	1	23	19	1	-1	-1	1
81XAA04	1465	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	20	1	-1	-1	1
NM6	1466	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	21	1	-1	-1	1
80XAA04	1467	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	75	-1	-1	-1	-1	-1	1	1	23	1	2	-1	-1	2
80XAA04	1468	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	54.3	-1	-1	-1	-1	-1	1	1	23	2	2	-1	-1	2
80XAA04	1469	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	51.1	-1	-1	-1	-1	-1	1	1	23	3	2	-1	-1	2
80XAA04	1470	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	4	2	-1	-1	2
84XAA04	1471	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	63.8	-1	-1	-1	-1	-1	1	1	23	5	2	-1	-1	2
84XAA04	1472	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	6	2	-1	-1	2
84XAA04	1473	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	61.4	-1	-1	-1	-1	-1	1	1	23	7	2	-1	-1	2
84XAA04	1474	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	8	2	-1	-1	2
18XAG04	1475	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	9	2	-1	-1	2
18XAG04	1476	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	10	2	-1	-1	2
18XAG04	1477	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	65.4	-1	-1	-1	-1	-1	1	1	23	11	2	-1	-1	2
18XAG04	1478	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	61.4	-1	-1	-1	-1	-1	1	1	23	12	2	-1	-1	2
81XAA04	1479	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	2	-1	-1	2
81XAA04	1480	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	14	2	-1	-1	2
81XAA04	1481	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	15	2	-1	-1	2
81XAA04	1482	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	16	2	-1	-1	2
80XAA04	1483	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	48.7	-1	-1	-1	-1	-1	1	1	23	17	2	-1	-1	2
80XAA04	1484	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	18	2	-1	-1	2
80XAA04	1485	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	68.6	-1	-1	-1	-1	-1	1	1	23	19	2	-1	-1	2
80XAA04	1486	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	63.8	-1	-1	-1	-1	-1	1	1	23	20	2	-1	-1	2
NM6	1487	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	21	2	-1	-1	2
83XAA04	1488	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	71	-1	-1	-1	-1	-1	1	1	23	1	3	-1	-1	3
83XAA04	1489	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	67	-1	-1	-1	-1	-1	1	1	23	2	3	-1	-1	3
83XAA04	1490	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	52.7	-1	-1	-1	-1	-1	1	1	23	3	3	-1	-1	3
83XAA04	1491	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	72.6	-1	-1	-1	-1	-1	1	1	23	4	3	-1	-1	3
1XTE04	1492	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	5	3	-1	-1	3
1XTE04	1493	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	6	3	-1	-1	3
1XTE04	1494	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	7	3	-1	-1	3
1XTE04	1495	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	8	3	-1	-1	3
80XAA04	1496	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	73.4	-1	-1	-1	-1	-1	1	1	23	9	3	-1	-1	3
80XAA04	1497	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	10	3	-1	-1	3
80XAA04	1498	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	3	-1	-1	3
80XAA04	1499	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	80.6	-1	-1	-1	-1	-1	1	1	23	12	3	-1	-1	3
82XAA04	1500	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	56.7	-1	-1	-1	-1	-1	1	1	23	13	3	-1	-1	3
82XAA04	1501	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	58.3	-1	-1	-1	-1	-1	1	1	23	14	3	-1	-1	3
82XAA04	1502	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	15	3	-1	-1	3
82XAA04	1503	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	16	3	-1	-1	3
83XAA04	1504	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	59.8	-1	-1	-1	-1	-1	1	1	23	17	3	-1	-1	3
83XAA04	1505	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	18	3	-1	-1	3
83XAA04	1506	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	19	3	-1	-1	3
83XAA04	1507	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	59	-1	-1	-1	-1	-1	1	1	23	20	3	-1	-1	3
NM6	1508	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	70.2	-1	-1	-1	-1	-1	1	1	23	21	3	-1	-1	3
85XAA04	1509	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	1	4	-1	-1	4
85XAA04	1510	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	2	4	-1	-1	4
85XAA04	1511	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	3	4	-1	-1	4
85XAA04	1512	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	4	-1	-1	4
18XAG04	1513	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	5	4	-1	-1	4
18XAG04	1514	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	6	4	-1	-1	4
18XAG04	1515	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	7	4	-1	-1	4
18XAG04	1516	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	52.7	-1	-1	-1	-1	-1	1	1	23	8	4	-1	-1	4
85XAA04	1517	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	14.4	-1	-1	-1	-1	-1	1	1	23	9	4	-1	-1	4
85XAA04	1518	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	10	4	-1	-1	4
85XAA04	1519	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	4	-1	-1	4
85XAA04	1520	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	4	-1	-1	4
84XAA04	1521	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	13	4	-1	-1	4
84XAA04	1522	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	4	-1	-1	4
84XAA04	1523	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	56.7	-1	-1	-1	-1	-1	1	1	23	15	4	-1	-1	4
84XAA04	1524	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	61.4	-1	-1	-1	-1	-1	1	1	23	16	4	-1	-1	4
82XAA04	1525	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	17	4	-1	-1	4
82XAA04	1526	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	67	-1	-1	-1	-1	-1	1	1	23	18	4	-1	-1	4
82XAA04	1527	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	48.7	-1	-1	-1	-1	-1	1	1	23	19	4	-1	-1	4
82XAA04	1528	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	20	4	-1	-1	4
NM6	1529	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	61.4	-1	-1	-1	-1	-1	1	1	23	21	4	-1	-1	4
81XAA04	1530	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	1	5	-1	-1	5
81XAA04	1531	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	55.1	-1	-1	-1	-1	-1	1	1	23	2	5	-1	-1	5
81XAA04	1532	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	3	5	-1	-1	5
81XAA04	1533	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	81.4	-1	-1	-1	-1	-1	1	1	23	4	5	-1	-1	5
2XT4E04	1534	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	5	5	-1	-1	5
2XT4E04	1535	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	5	-1	-1	5
2XT4E04	1536	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	5	-1	-1	5
2XT4E04	1537	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	5	-1	-1	5
84XAA04	1538	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	9	5	-1	-1	5
84XAA04	1539	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	10	5	-1	-1	5
84XAA04	1540	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	77.4	-1	-1	-1	-1	-1	1	1	23	11	5	-1	-1	5
84XAA04	1541	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	66.2	-1	-1	-1	-1	-1	1	1	23	12	5	-1	-1	5
17XGA04	1542	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	13	5	-1	-1	5
17XGA04	1543	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	14	5	-1	-1	5
17XGA04	1544	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	15	5	-1	-1	5
17XGA04	1545	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	16	5	-1	-1	5
85XAA04	1546	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	17	5	-1	-1	5
85XAA04	1547	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	18	5	-1	-1	5
85XAA04	1548	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	19	5	-1	-1	5
85XAA04	1549	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	20	5	-1	-1	5
NM6	1550	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	55.1	-1	-1	-1	-1	-1	1	1	23	21	5	-1	-1	5
81XAA04	1551	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	73.4	-1	-1	-1	-1	-1	1	1	23	1	6	-1	-1	6
81XAA04	1552	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	2	6	-1	-1	6
81XAA04	1553	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	59.8	-1	-1	-1	-1	-1	1	1	23	3	6	-1	-1	6
81XAA04	1554	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	6	-1	-1	6
82XAA04	1555	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	5	6	-1	-1	6
82XAA04	1556	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	63	-1	-1	-1	-1	-1	1	1	23	6	6	-1	-1	6
82XAA04	1557	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	55.1	-1	-1	-1	-1	-1	1	1	23	7	6	-1	-1	6
82XAA04	1558	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	48.7	-1	-1	-1	-1	-1	1	1	23	8	6	-1	-1	6
18XAG04	1559	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	9	6	-1	-1	6
18XAG04	1560	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	57.5	-1	-1	-1	-1	-1	1	1	23	10	6	-1	-1	6
18XAG04	1561	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	10.4	-1	-1	-1	-1	-1	1	1	23	11	6	-1	-1	6
18XAG04	1562	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	12	6	-1	-1	6
1XTE04	1563	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	6	-1	-1	6
1XTE04	1564	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	6	-1	-1	6
1XTE04	1565	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	6	-1	-1	6
1XTE04	1566	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	16	6	-1	-1	6
82XAA04	1567	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	17	6	-1	-1	6
82XAA04	1568	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	54.3	-1	-1	-1	-1	-1	1	1	23	18	6	-1	-1	6
82XAA04	1569	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	48.7	-1	-1	-1	-1	-1	1	1	23	19	6	-1	-1	6
82XAA04	1570	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	55.9	-1	-1	-1	-1	-1	1	1	23	20	6	-1	-1	6
NM6	1571	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	59.8	-1	-1	-1	-1	-1	1	1	23	21	6	-1	-1	6
83XAA04	1572	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	67.8	-1	-1	-1	-1	-1	1	1	23	1	7	-1	-1	7
83XAA04	1573	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	64.6	-1	-1	-1	-1	-1	1	1	23	2	7	-1	-1	7
83XAA04	1574	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	59	-1	-1	-1	-1	-1	1	1	23	3	7	-1	-1	7
83XAA04	1575	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	65.4	-1	-1	-1	-1	-1	1	1	23	4	7	-1	-1	7
2XT4E04	1576	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	5	7	-1	-1	7
2XT4E04	1577	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	7	-1	-1	7
2XT4E04	1578	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	7	7	-1	-1	7
2XT4E04	1579	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	8	7	-1	-1	7
17XGA04	1580	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	9	7	-1	-1	7
17XGA04	1581	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	10	7	-1	-1	7
17XGA04	1582	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	11	7	-1	-1	7
17XGA04	1583	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	7	-1	-1	7
83XAA04	1584	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	71	-1	-1	-1	-1	-1	1	1	23	13	7	-1	-1	7
83XAA04	1585	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	59.8	-1	-1	-1	-1	-1	1	1	23	14	7	-1	-1	7
83XAA04	1586	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	65.4	-1	-1	-1	-1	-1	1	1	23	15	7	-1	-1	7
83XAA04	1587	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	79	-1	-1	-1	-1	-1	1	1	23	16	7	-1	-1	7
81XAA04	1588	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	17	7	-1	-1	7
81XAA04	1589	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	18	7	-1	-1	7
81XAA04	1590	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	35.9	-1	-1	-1	-1	-1	1	1	23	19	7	-1	-1	7
81XAA04	1591	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	63.8	-1	-1	-1	-1	-1	1	1	23	20	7	-1	-1	7
85XAA04	1592	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	21	7	-1	-1	7
1XTE04	1593	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	1	8	-1	-1	8
1XTE04	1594	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	8	-1	-1	8
1XTE04	1595	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	12	-1	-1	-1	-1	-1	1	1	23	3	8	-1	-1	8
1XTE04	1596	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	4	8	-1	-1	8
18XAG04	1597	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	5	8	-1	-1	8
18XAG04	1598	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	6	8	-1	-1	8
18XAG04	1599	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	7	8	-1	-1	8
18XAG04	1600	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	42.3	-1	-1	-1	-1	-1	1	1	23	8	8	-1	-1	8
82XAA04	1601	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	58.3	-1	-1	-1	-1	-1	1	1	23	9	8	-1	-1	8
82XAA04	1602	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	10	8	-1	-1	8
82XAA04	1603	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	56.7	-1	-1	-1	-1	-1	1	1	23	11	8	-1	-1	8
82XAA04	1604	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	12	8	-1	-1	8
81XAA04	1605	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	13	8	-1	-1	8
81XAA04	1606	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	14	8	-1	-1	8
81XAA04	1607	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	8	-1	-1	8
81XAA04	1608	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	16	8	-1	-1	8
84XAA04	1609	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	48.7	-1	-1	-1	-1	-1	1	1	23	17	8	-1	-1	8
84XAA04	1610	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	52.7	-1	-1	-1	-1	-1	1	1	23	18	8	-1	-1	8
84XAA04	1611	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	19	8	-1	-1	8
84XAA04	1612	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	35.9	-1	-1	-1	-1	-1	1	1	23	20	8	-1	-1	8
85XAA04	1613	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	24.7	-1	-1	-1	-1	-1	1	1	23	21	8	-1	-1	8
85XAA04	1614	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	1	9	-1	-1	9
85XAA04	1615	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	9	-1	-1	9
85XAA04	1616	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	3	9	-1	-1	9
85XAA04	1617	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	9	-1	-1	9
80XAA04	1618	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	68.6	-1	-1	-1	-1	-1	1	1	23	5	9	-1	-1	9
80XAA04	1619	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	69.4	-1	-1	-1	-1	-1	1	1	23	6	9	-1	-1	9
80XAA04	1620	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	59.8	-1	-1	-1	-1	-1	1	1	23	7	9	-1	-1	9
80XAA04	1621	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	74.2	-1	-1	-1	-1	-1	1	1	23	8	9	-1	-1	9
84XAA04	1622	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	9	9	-1	-1	9
84XAA04	1623	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	57.5	-1	-1	-1	-1	-1	1	1	23	10	9	-1	-1	9
84XAA04	1624	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	11	9	-1	-1	9
84XAA04	1625	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	12	9	-1	-1	9
80XAA04	1626	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	57.5	-1	-1	-1	-1	-1	1	1	23	13	9	-1	-1	9
80XAA04	1627	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	54.3	-1	-1	-1	-1	-1	1	1	23	14	9	-1	-1	9
80XAA04	1628	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	52.7	-1	-1	-1	-1	-1	1	1	23	15	9	-1	-1	9
80XAA04	1629	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	16	9	-1	-1	9
83XAA04	1630	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	67	-1	-1	-1	-1	-1	1	1	23	17	9	-1	-1	9
83XAA04	1631	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	18	9	-1	-1	9
83XAA04	1632	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	62.2	-1	-1	-1	-1	-1	1	1	23	19	9	-1	-1	9
83XAA04	1633	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	84.6	-1	-1	-1	-1	-1	1	1	23	20	9	-1	-1	9
85XAA04	1634	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	21	9	-1	-1	9
84XAA04	1635	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	74.2	-1	-1	-1	-1	-1	1	1	23	1	10	-1	-1	10
84XAA04	1636	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	10	-1	-1	10
84XAA04	1637	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	3	10	-1	-1	10
84XAA04	1638	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	71.8	-1	-1	-1	-1	-1	1	1	23	4	10	-1	-1	10
17XGA04	1639	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	5	10	-1	-1	10
17XGA04	1640	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	6	10	-1	-1	10
17XGA04	1641	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	7	10	-1	-1	10
17XGA04	1642	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	8	10	-1	-1	10
2XT4E04	1643	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	9	10	-1	-1	10
2XT4E04	1644	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	10	-1	-1	10
2XT4E04	1645	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	11	10	-1	-1	10
2XT4E04	1646	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	10	-1	-1	10
85XAA04	1647	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	16	-1	-1	-1	-1	-1	1	1	23	13	10	-1	-1	10
85XAA04	1648	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	10	-1	-1	10
85XAA04	1649	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	10	-1	-1	10
85XAA04	1650	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	16	10	-1	-1	10
80XAA04	1651	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	63	-1	-1	-1	-1	-1	1	1	23	17	10	-1	-1	10
80XAA04	1652	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	18	10	-1	-1	10
80XAA04	1653	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	19	10	-1	-1	10
80XAA04	1654	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	20	10	-1	-1	10
85XAA04	1655	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	21	10	-1	-1	10
NM6	1656	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	1	11	-1	-1	11
NM6	1657	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	62.2	-1	-1	-1	-1	-1	1	1	23	2	11	-1	-1	11
NM6	1658	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	59	-1	-1	-1	-1	-1	1	1	23	3	11	-1	-1	11
NM6	1659	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	42.3	-1	-1	-1	-1	-1	1	1	23	4	11	-1	-1	11
NM6	1660	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	5	11	-1	-1	11
NM6	1661	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	48.7	-1	-1	-1	-1	-1	1	1	23	6	11	-1	-1	11
NM6	1662	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	7	11	-1	-1	11
NM6	1663	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	73.4	-1	-1	-1	-1	-1	1	1	23	8	11	-1	-1	11
NM6	1664	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	11	-1	-1	11
NM6	1665	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	60.6	-1	-1	-1	-1	-1	1	1	23	10	11	-1	-1	11
NM6	1666	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	61.4	-1	-1	-1	-1	-1	1	1	23	11	11	-1	-1	11
NM6	1667	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	66.2	-1	-1	-1	-1	-1	1	1	23	12	11	-1	-1	11
NM6	1668	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	13	11	-1	-1	11
NM6	1669	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	14	11	-1	-1	11
NM6	1670	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	15	11	-1	-1	11
NM6	1671	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	16	11	-1	-1	11
NM6	1672	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	58.3	-1	-1	-1	-1	-1	1	1	23	17	11	-1	-1	11
NM6	1673	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	51.1	-1	-1	-1	-1	-1	1	1	23	18	11	-1	-1	11
NM6	1674	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	19	11	-1	-1	11
NM6	1675	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	20	11	-1	-1	11
NM6	1676	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	52.7	-1	-1	-1	-1	-1	1	1	23	21	11	-1	-1	11
NM6	1677	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	66.2	-1	-1	-1	-1	-1	1	1	23	1	12	-1	-1	12
NM6	1678	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	65.4	-1	-1	-1	-1	-1	1	1	23	2	12	-1	-1	12
NM6	1679	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	51.1	-1	-1	-1	-1	-1	1	1	23	3	12	-1	-1	12
NM6	1680	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	51.1	-1	-1	-1	-1	-1	1	1	23	4	12	-1	-1	12
NM6	1681	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	60.6	-1	-1	-1	-1	-1	1	1	23	5	12	-1	-1	12
NM6	1682	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	66.2	-1	-1	-1	-1	-1	1	1	23	6	12	-1	-1	12
NM6	1683	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	67	-1	-1	-1	-1	-1	1	1	23	7	12	-1	-1	12
NM6	1684	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	67	-1	-1	-1	-1	-1	1	1	23	8	12	-1	-1	12
NM6	1685	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	58.3	-1	-1	-1	-1	-1	1	1	23	9	12	-1	-1	12
NM6	1686	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	10	12	-1	-1	12
NM6	1687	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	66.2	-1	-1	-1	-1	-1	1	1	23	11	12	-1	-1	12
NM6	1688	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	12	12	-1	-1	12
NM6	1689	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	25.5	-1	-1	-1	-1	-1	1	1	23	13	12	-1	-1	12
NM6	1690	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	58.3	-1	-1	-1	-1	-1	1	1	23	14	12	-1	-1	12
NM6	1691	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	15	12	-1	-1	12
NM6	1692	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	16	12	-1	-1	12
NM6	1693	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	17	12	-1	-1	12
NM6	1694	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	18	12	-1	-1	12
NM6	1695	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	42.3	-1	-1	-1	-1	-1	1	1	23	19	12	-1	-1	12
NM6	1696	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	71	-1	-1	-1	-1	-1	1	1	23	20	12	-1	-1	12
NM6	1697	MI aspen field trial	-1	1	-1	2005-05-15	2013-10-10	1-0 	45	-1	-1	U	-1	64.6	-1	-1	-1	-1	-1	1	1	23	21	12	-1	-1	12
17XGA24	1698	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	1	1	-1	-1	1
17XGA04	1699	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	2	1	-1	-1	1
17XGA04	1700	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	57.5	-1	-1	-1	-1	-1	1	1	23	3	1	-1	-1	1
17XGA5	1701	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	4	1	-1	-1	1
82XAA04	1702	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	5	1	-1	-1	1
82XAA04	1703	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	6	1	-1	-1	1
82XAA04	1704	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	59.8	-1	-1	-1	-1	-1	1	1	23	7	1	-1	-1	1
82XAA04	1705	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	1	-1	-1	1
2XT4E04	1706	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	1	-1	-1	1
2XT4E04	1707	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	1	-1	-1	1
2XT4E04	1708	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	1	-1	-1	1
2XT4E04	1709	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	1	-1	-1	1
83XAA04	1710	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	59.8	-1	-1	-1	-1	-1	1	1	23	13	1	-1	-1	1
83XAA04	1711	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	67.8	-1	-1	-1	-1	-1	1	1	23	14	1	-1	-1	1
83XAA04	1712	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	67.8	-1	-1	-1	-1	-1	1	1	23	15	1	-1	-1	1
83XAA04	1713	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	63	-1	-1	-1	-1	-1	1	1	23	16	1	-1	-1	1
81XAA04	1714	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	17	1	-1	-1	1
81XAA04	1715	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	66.2	-1	-1	-1	-1	-1	1	1	23	18	1	-1	-1	1
81XAA04	1716	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	56.7	-1	-1	-1	-1	-1	1	1	23	19	1	-1	-1	1
81XAA04	1717	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	20	1	-1	-1	1
NM6	1718	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	21	1	-1	-1	1
80XAA04	1719	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	66.2	-1	-1	-1	-1	-1	1	1	23	1	2	-1	-1	2
80XAA04	1720	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	2	2	-1	-1	2
80XAA04	1721	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	3	2	-1	-1	2
80XAA04	1722	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	4	2	-1	-1	2
84XAA04	1723	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	55.1	-1	-1	-1	-1	-1	1	1	23	5	2	-1	-1	2
84XAA04	1724	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	6	2	-1	-1	2
84XAA04	1725	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	52.7	-1	-1	-1	-1	-1	1	1	23	7	2	-1	-1	2
84XAA04	1726	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	8	2	-1	-1	2
18XAG04	1727	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	9	2	-1	-1	2
18XAG04	1728	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	10	2	-1	-1	2
18XAG04	1729	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	59	-1	-1	-1	-1	-1	1	1	23	11	2	-1	-1	2
18XAG04	1730	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	56.7	-1	-1	-1	-1	-1	1	1	23	12	2	-1	-1	2
81XAA04	1731	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	2	-1	-1	2
81XAA04	1732	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	14	2	-1	-1	2
81XAA04	1733	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	15	2	-1	-1	2
81XAA04	1734	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	16	2	-1	-1	2
80XAA04	1735	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	17	2	-1	-1	2
80XAA04	1736	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	18	2	-1	-1	2
80XAA04	1737	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	65.4	-1	-1	-1	-1	-1	1	1	23	19	2	-1	-1	2
80XAA04	1738	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	54.3	-1	-1	-1	-1	-1	1	1	23	20	2	-1	-1	2
NM6	1739	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	21	2	-1	-1	2
83XAA04	1740	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	59.8	-1	-1	-1	-1	-1	1	1	23	1	3	-1	-1	3
83XAA04	1741	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	64.6	-1	-1	-1	-1	-1	1	1	23	2	3	-1	-1	3
83XAA04	1742	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	3	3	-1	-1	3
83XAA04	1743	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	68.6	-1	-1	-1	-1	-1	1	1	23	4	3	-1	-1	3
1XTE04	1744	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	5	3	-1	-1	3
1XTE04	1745	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	6	3	-1	-1	3
1XTE04	1746	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	7	3	-1	-1	3
1XTE04	1747	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	8	3	-1	-1	3
80XAA04	1748	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	68.6	-1	-1	-1	-1	-1	1	1	23	9	3	-1	-1	3
80XAA04	1749	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	10	3	-1	-1	3
80XAA04	1750	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	3	-1	-1	3
80XAA04	1751	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	75	-1	-1	-1	-1	-1	1	1	23	12	3	-1	-1	3
82XAA04	1752	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	13	3	-1	-1	3
82XAA04	1753	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	14	3	-1	-1	3
82XAA04	1754	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	15	3	-1	-1	3
82XAA04	1755	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	16	3	-1	-1	3
83XAA04	1756	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	56.7	-1	-1	-1	-1	-1	1	1	23	17	3	-1	-1	3
83XAA04	1757	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	51.1	-1	-1	-1	-1	-1	1	1	23	18	3	-1	-1	3
83XAA04	1758	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	19	3	-1	-1	3
83XAA04	1759	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	52.7	-1	-1	-1	-1	-1	1	1	23	20	3	-1	-1	3
NM6	1760	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	67.8	-1	-1	-1	-1	-1	1	1	23	21	3	-1	-1	3
85XAA04	1761	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	1	4	-1	-1	4
85XAA04	1762	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	2	4	-1	-1	4
85XAA04	1763	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	3	4	-1	-1	4
85XAA04	1764	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	4	-1	-1	4
18XAG04	1765	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	5	4	-1	-1	4
18XAG04	1766	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	6	4	-1	-1	4
18XAG04	1767	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	7	4	-1	-1	4
18XAG04	1768	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	51.1	-1	-1	-1	-1	-1	1	1	23	8	4	-1	-1	4
85XAA04	1769	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	14.4	-1	-1	-1	-1	-1	1	1	23	9	4	-1	-1	4
85XAA04	1770	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	10	4	-1	-1	4
85XAA04	1771	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	4	-1	-1	4
85XAA04	1772	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	4	-1	-1	4
84XAA04	1773	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	13	4	-1	-1	4
84XAA04	1774	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	4	-1	-1	4
84XAA04	1775	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	54.3	-1	-1	-1	-1	-1	1	1	23	15	4	-1	-1	4
84XAA04	1776	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	60.6	-1	-1	-1	-1	-1	1	1	23	16	4	-1	-1	4
82XAA04	1777	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	17	4	-1	-1	4
82XAA04	1778	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	60.6	-1	-1	-1	-1	-1	1	1	23	18	4	-1	-1	4
82XAA04	1779	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	19	4	-1	-1	4
82XAA04	1780	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	20	4	-1	-1	4
NM6	1781	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	55.9	-1	-1	-1	-1	-1	1	1	23	21	4	-1	-1	4
81XAA04	1782	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	1	5	-1	-1	5
81XAA04	1783	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	2	5	-1	-1	5
81XAA04	1784	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	3	5	-1	-1	5
81XAA04	1785	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	78.2	-1	-1	-1	-1	-1	1	1	23	4	5	-1	-1	5
2XT4E04	1786	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	5	5	-1	-1	5
2XT4E04	1787	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	5	-1	-1	5
2XT4E04	1788	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	5	-1	-1	5
2XT4E04	1789	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	5	-1	-1	5
84XAA04	1790	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	9	5	-1	-1	5
84XAA04	1791	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	10	5	-1	-1	5
84XAA04	1792	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	68.6	-1	-1	-1	-1	-1	1	1	23	11	5	-1	-1	5
84XAA04	1793	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	56.7	-1	-1	-1	-1	-1	1	1	23	12	5	-1	-1	5
17XGA04	1794	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	13	5	-1	-1	5
17XGA04	1795	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	14	5	-1	-1	5
17XGA04	1796	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	15	5	-1	-1	5
17XGA04	1797	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	16	5	-1	-1	5
85XAA04	1798	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	17	5	-1	-1	5
85XAA04	1799	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	18	5	-1	-1	5
85XAA04	1800	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	19	5	-1	-1	5
85XAA04	1801	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	20	5	-1	-1	5
NM6	1802	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	54.3	-1	-1	-1	-1	-1	1	1	23	21	5	-1	-1	5
81XAA04	1803	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	71	-1	-1	-1	-1	-1	1	1	23	1	6	-1	-1	6
81XAA04	1804	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	2	6	-1	-1	6
81XAA04	1805	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	3	6	-1	-1	6
81XAA04	1806	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	6	-1	-1	6
82XAA04	1807	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	5	6	-1	-1	6
82XAA04	1808	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	61.4	-1	-1	-1	-1	-1	1	1	23	6	6	-1	-1	6
82XAA04	1809	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	52.7	-1	-1	-1	-1	-1	1	1	23	7	6	-1	-1	6
82XAA04	1810	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	42.3	-1	-1	-1	-1	-1	1	1	23	8	6	-1	-1	6
18XAG04	1811	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	9	6	-1	-1	6
18XAG04	1812	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	10	6	-1	-1	6
18XAG04	1813	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	10.4	-1	-1	-1	-1	-1	1	1	23	11	6	-1	-1	6
18XAG04	1814	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	12	6	-1	-1	6
1XTE04	1815	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	6	-1	-1	6
1XTE04	1816	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	6	-1	-1	6
1XTE04	1817	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	6	-1	-1	6
1XTE04	1818	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	16	6	-1	-1	6
82XAA04	1819	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	17	6	-1	-1	6
82XAA04	1820	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	48.7	-1	-1	-1	-1	-1	1	1	23	18	6	-1	-1	6
82XAA04	1821	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	19	6	-1	-1	6
82XAA04	1822	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	20	6	-1	-1	6
NM6	1823	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	58.3	-1	-1	-1	-1	-1	1	1	23	21	6	-1	-1	6
83XAA04	1824	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	58.3	-1	-1	-1	-1	-1	1	1	23	1	7	-1	-1	7
83XAA04	1825	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	61.4	-1	-1	-1	-1	-1	1	1	23	2	7	-1	-1	7
83XAA04	1826	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	3	7	-1	-1	7
83XAA04	1827	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	62.2	-1	-1	-1	-1	-1	1	1	23	4	7	-1	-1	7
2XT4E04	1828	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	6.4	-1	-1	-1	-1	-1	1	1	23	5	7	-1	-1	7
2XT4E04	1829	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	7	-1	-1	7
2XT4E04	1830	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	7	7	-1	-1	7
2XT4E04	1831	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	8	7	-1	-1	7
17XGA04	1832	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	9	7	-1	-1	7
17XGA04	1833	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	10	7	-1	-1	7
17XGA04	1834	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	11	7	-1	-1	7
17XGA04	1835	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	7	-1	-1	7
83XAA04	1836	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	67	-1	-1	-1	-1	-1	1	1	23	13	7	-1	-1	7
83XAA04	1837	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	57.5	-1	-1	-1	-1	-1	1	1	23	14	7	-1	-1	7
83XAA04	1838	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	59.8	-1	-1	-1	-1	-1	1	1	23	15	7	-1	-1	7
83XAA04	1839	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	70.2	-1	-1	-1	-1	-1	1	1	23	16	7	-1	-1	7
81XAA04	1840	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	17	7	-1	-1	7
81XAA04	1841	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	18	7	-1	-1	7
81XAA04	1842	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	35.9	-1	-1	-1	-1	-1	1	1	23	19	7	-1	-1	7
81XAA04	1843	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	59.8	-1	-1	-1	-1	-1	1	1	23	20	7	-1	-1	7
85XAA04	1844	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	24.7	-1	-1	-1	-1	-1	1	1	23	21	7	-1	-1	7
1XTE04	1845	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	1	8	-1	-1	8
1XTE04	1846	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	8	-1	-1	8
1XTE04	1847	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	12	-1	-1	-1	-1	-1	1	1	23	3	8	-1	-1	8
1XTE04	1848	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	4	8	-1	-1	8
18XAG04	1849	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	5	8	-1	-1	8
18XAG04	1850	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	6	8	-1	-1	8
18XAG04	1851	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	7	8	-1	-1	8
18XAG04	1852	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	42.3	-1	-1	-1	-1	-1	1	1	23	8	8	-1	-1	8
82XAA04	1853	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	9	8	-1	-1	8
82XAA04	1854	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	10	8	-1	-1	8
82XAA04	1855	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	55.1	-1	-1	-1	-1	-1	1	1	23	11	8	-1	-1	8
82XAA04	1856	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	12	8	-1	-1	8
81XAA04	1857	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	13	8	-1	-1	8
81XAA04	1858	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	41.5	-1	-1	-1	-1	-1	1	1	23	14	8	-1	-1	8
81XAA04	1859	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	8	-1	-1	8
81XAA04	1860	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	16	8	-1	-1	8
84XAA04	1861	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	17	8	-1	-1	8
84XAA04	1862	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	18	8	-1	-1	8
84XAA04	1863	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	19	8	-1	-1	8
84XAA04	1864	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	20	8	-1	-1	8
85XAA04	1865	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	24.7	-1	-1	-1	-1	-1	1	1	23	21	8	-1	-1	8
85XAA04	1866	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	8.8	-1	-1	-1	-1	-1	1	1	23	1	9	-1	-1	9
85XAA04	1867	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	2	9	-1	-1	9
85XAA04	1868	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	3	9	-1	-1	9
85XAA04	1869	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	9	-1	-1	9
80XAA04	1870	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	62.2	-1	-1	-1	-1	-1	1	1	23	5	9	-1	-1	9
80XAA04	1871	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	63	-1	-1	-1	-1	-1	1	1	23	6	9	-1	-1	9
80XAA04	1872	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	57.5	-1	-1	-1	-1	-1	1	1	23	7	9	-1	-1	9
80XAA04	1873	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	69.4	-1	-1	-1	-1	-1	1	1	23	8	9	-1	-1	9
84XAA04	1874	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	9	9	-1	-1	9
84XAA04	1875	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	10	9	-1	-1	9
84XAA04	1876	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	11	9	-1	-1	9
84XAA04	1877	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	12	9	-1	-1	9
80XAA04	1878	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	52.7	-1	-1	-1	-1	-1	1	1	23	13	9	-1	-1	9
80XAA04	1879	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	14	9	-1	-1	9
80XAA04	1880	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	15	9	-1	-1	9
80XAA04	1881	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	16	9	-1	-1	9
83XAA04	1882	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	60.6	-1	-1	-1	-1	-1	1	1	23	17	9	-1	-1	9
83XAA04	1883	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	18	9	-1	-1	9
83XAA04	1884	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	57.5	-1	-1	-1	-1	-1	1	1	23	19	9	-1	-1	9
83XAA04	1885	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	78.2	-1	-1	-1	-1	-1	1	1	23	20	9	-1	-1	9
85XAA04	1886	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	16.8	-1	-1	-1	-1	-1	1	1	23	21	9	-1	-1	9
84XAA04	1887	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	64.6	-1	-1	-1	-1	-1	1	1	23	1	10	-1	-1	10
84XAA04	1888	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	9.6	-1	-1	-1	-1	-1	1	1	23	2	10	-1	-1	10
84XAA04	1889	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	41.5	-1	-1	-1	-1	-1	1	1	23	3	10	-1	-1	10
84XAA04	1890	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	64.6	-1	-1	-1	-1	-1	1	1	23	4	10	-1	-1	10
17XGA04	1891	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	5	10	-1	-1	10
17XGA04	1892	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	6	10	-1	-1	10
17XGA04	1893	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	7	10	-1	-1	10
17XGA04	1894	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	8	10	-1	-1	10
2XT4E04	1895	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	9	10	-1	-1	10
2XT4E04	1896	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	10	-1	-1	10
2XT4E04	1897	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	11	10	-1	-1	10
2XT4E04	1898	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	10	-1	-1	10
85XAA04	1899	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	16	-1	-1	-1	-1	-1	1	1	23	13	10	-1	-1	10
85XAA04	1900	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	10	-1	-1	10
85XAA04	1901	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	10	-1	-1	10
85XAA04	1902	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	10.4	-1	-1	-1	-1	-1	1	1	23	16	10	-1	-1	10
80XAA04	1903	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	55.1	-1	-1	-1	-1	-1	1	1	23	17	10	-1	-1	10
80XAA04	1904	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	18	10	-1	-1	10
80XAA04	1905	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	19	10	-1	-1	10
80XAA04	1906	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	20	10	-1	-1	10
85XAA04	1907	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	4	-1	-1	-1	-1	-1	1	1	23	21	10	-1	-1	10
NM6	1908	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	1	11	-1	-1	11
NM6	1909	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	58.3	-1	-1	-1	-1	-1	1	1	23	2	11	-1	-1	11
NM6	1910	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	59	-1	-1	-1	-1	-1	1	1	23	3	11	-1	-1	11
NM6	1911	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	4	11	-1	-1	11
NM6	1912	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	5	11	-1	-1	11
NM6	1913	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	6	11	-1	-1	11
NM6	1914	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	7	11	-1	-1	11
NM6	1915	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	71	-1	-1	-1	-1	-1	1	1	23	8	11	-1	-1	11
NM6	1916	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	11	-1	-1	11
NM6	1917	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	55.1	-1	-1	-1	-1	-1	1	1	23	10	11	-1	-1	11
NM6	1918	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	11	11	-1	-1	11
NM6	1919	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	62.2	-1	-1	-1	-1	-1	1	1	23	12	11	-1	-1	11
NM6	1920	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	13	11	-1	-1	11
NM6	1921	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	14	11	-1	-1	11
NM6	1922	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	15	11	-1	-1	11
NM6	1923	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	16	11	-1	-1	11
NM6	1924	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	55.1	-1	-1	-1	-1	-1	1	1	23	17	11	-1	-1	11
NM6	1925	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	51.1	-1	-1	-1	-1	-1	1	1	23	18	11	-1	-1	11
NM6	1926	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	19	11	-1	-1	11
NM6	1927	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	42.3	-1	-1	-1	-1	-1	1	1	23	20	11	-1	-1	11
NM6	1928	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	21	11	-1	-1	11
NM6	1929	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	63.8	-1	-1	-1	-1	-1	1	1	23	1	12	-1	-1	12
NM6	1930	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	57.5	-1	-1	-1	-1	-1	1	1	23	2	12	-1	-1	12
NM6	1931	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	3	12	-1	-1	12
NM6	1932	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	4	12	-1	-1	12
NM6	1933	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	5	12	-1	-1	12
NM6	1934	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	66.2	-1	-1	-1	-1	-1	1	1	23	6	12	-1	-1	12
NM6	1935	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	65.4	-1	-1	-1	-1	-1	1	1	23	7	12	-1	-1	12
NM6	1936	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	8	12	-1	-1	12
NM6	1937	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	9	12	-1	-1	12
NM6	1938	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	10	12	-1	-1	12
NM6	1939	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	61.4	-1	-1	-1	-1	-1	1	1	23	11	12	-1	-1	12
NM6	1940	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	12	12	-1	-1	12
NM6	1941	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	13	12	-1	-1	12
NM6	1942	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	54.3	-1	-1	-1	-1	-1	1	1	23	14	12	-1	-1	12
NM6	1943	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	15	12	-1	-1	12
NM6	1944	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	16	12	-1	-1	12
NM6	1945	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	17	12	-1	-1	12
NM6	1946	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	41.5	-1	-1	-1	-1	-1	1	1	23	18	12	-1	-1	12
NM6	1947	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	19	12	-1	-1	12
NM6	1948	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	71	-1	-1	-1	-1	-1	1	1	23	20	12	-1	-1	12
NM6	1949	MI aspen field trial	-1	1	-1	2005-05-15	2012-10-10	1-0 	45	-1	-1	U	-1	59	-1	-1	-1	-1	-1	1	1	23	21	12	-1	-1	12
17XGA24	1950	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	1	1	-1	-1	1
17XGA04	1951	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	1	-1	-1	1
17XGA04	1952	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	3	1	-1	-1	1
17XGA5	1953	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	1	-1	-1	1
82XAA04	1954	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	5	1	-1	-1	1
82XAA04	1955	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	1	-1	-1	1
82XAA04	1956	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	1	-1	-1	1
82XAA04	1957	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	1	-1	-1	1
2XT4E04	1958	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	1	-1	-1	1
2XT4E04	1959	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	1	-1	-1	1
2XT4E04	1960	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	1	-1	-1	1
2XT4E04	1961	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	1	-1	-1	1
83XAA04	1962	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	54.3	-1	-1	-1	-1	-1	1	1	23	13	1	-1	-1	1
83XAA04	1963	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	61.4	-1	-1	-1	-1	-1	1	1	23	14	1	-1	-1	1
83XAA04	1964	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	61.4	-1	-1	-1	-1	-1	1	1	23	15	1	-1	-1	1
83XAA04	1965	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	55.1	-1	-1	-1	-1	-1	1	1	23	16	1	-1	-1	1
81XAA04	1966	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	17	1	-1	-1	1
81XAA04	1967	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	18	1	-1	-1	1
81XAA04	1968	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	19	1	-1	-1	1
81XAA04	1969	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	20	1	-1	-1	1
NM6	1970	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	21	1	-1	-1	1
80XAA04	1971	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	61.4	-1	-1	-1	-1	-1	1	1	23	1	2	-1	-1	2
80XAA04	1972	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	2	2	-1	-1	2
80XAA04	1973	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	41.5	-1	-1	-1	-1	-1	1	1	23	3	2	-1	-1	2
80XAA04	1974	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	4	2	-1	-1	2
84XAA04	1975	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	5	2	-1	-1	2
84XAA04	1976	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	2	-1	-1	2
84XAA04	1977	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	2	-1	-1	2
84XAA04	1978	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	2	-1	-1	2
18XAG04	1979	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	2	-1	-1	2
18XAG04	1980	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	2	-1	-1	2
18XAG04	1981	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	2	-1	-1	2
18XAG04	1982	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	2	-1	-1	2
81XAA04	1983	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	2	-1	-1	2
81XAA04	1984	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	2	-1	-1	2
81XAA04	1985	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	2	-1	-1	2
81XAA04	1986	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	16	2	-1	-1	2
80XAA04	1987	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	17	2	-1	-1	2
80XAA04	1988	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	18	2	-1	-1	2
80XAA04	1989	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	59.8	-1	-1	-1	-1	-1	1	1	23	19	2	-1	-1	2
80XAA04	1990	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	20	2	-1	-1	2
NM6	1991	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	16	-1	-1	-1	-1	-1	1	1	23	21	2	-1	-1	2
83XAA04	1992	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	57.5	-1	-1	-1	-1	-1	1	1	23	1	3	-1	-1	3
83XAA04	1993	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	57.5	-1	-1	-1	-1	-1	1	1	23	2	3	-1	-1	3
83XAA04	1994	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	3	3	-1	-1	3
83XAA04	1995	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	60.6	-1	-1	-1	-1	-1	1	1	23	4	3	-1	-1	3
1XTE04	1996	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	5	3	-1	-1	3
1XTE04	1997	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	3	-1	-1	3
1XTE04	1998	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	3	-1	-1	3
1XTE04	1999	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	3	-1	-1	3
80XAA04	2000	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	63	-1	-1	-1	-1	-1	1	1	23	9	3	-1	-1	3
80XAA04	2001	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	10	3	-1	-1	3
80XAA04	2002	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	11	3	-1	-1	3
80XAA04	2003	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	67	-1	-1	-1	-1	-1	1	1	23	12	3	-1	-1	3
82XAA04	2004	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	3	-1	-1	3
82XAA04	2005	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	3	-1	-1	3
82XAA04	2006	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	3	-1	-1	3
82XAA04	2007	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	16	3	-1	-1	3
83XAA04	2008	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	17	3	-1	-1	3
83XAA04	2009	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	18	3	-1	-1	3
83XAA04	2010	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	19	3	-1	-1	3
83XAA04	2011	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	20	3	-1	-1	3
NM6	2012	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	21	3	-1	-1	3
85XAA04	2013	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	1	4	-1	-1	4
85XAA04	2014	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	4	-1	-1	4
85XAA04	2015	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	3	4	-1	-1	4
85XAA04	2016	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	4	-1	-1	4
18XAG04	2017	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	5	4	-1	-1	4
18XAG04	2018	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	4	-1	-1	4
18XAG04	2019	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	4	-1	-1	4
18XAG04	2020	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	4	-1	-1	4
85XAA04	2021	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	4	-1	-1	4
85XAA04	2022	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	4	-1	-1	4
85XAA04	2023	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	4	-1	-1	4
85XAA04	2024	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	4	-1	-1	4
84XAA04	2025	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	4	-1	-1	4
84XAA04	2026	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	4	-1	-1	4
84XAA04	2027	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	4	-1	-1	4
84XAA04	2028	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	16	4	-1	-1	4
82XAA04	2029	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	17	4	-1	-1	4
82XAA04	2030	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	18	4	-1	-1	4
82XAA04	2031	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	19	4	-1	-1	4
82XAA04	2032	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	20	4	-1	-1	4
NM6	2033	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	21	4	-1	-1	4
81XAA04	2034	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	1	5	-1	-1	5
81XAA04	2035	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	5	-1	-1	5
81XAA04	2036	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	3	5	-1	-1	5
81XAA04	2037	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	5	-1	-1	5
2XT4E04	2038	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	5	5	-1	-1	5
2XT4E04	2039	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	5	-1	-1	5
2XT4E04	2040	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	5	-1	-1	5
2XT4E04	2041	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	5	-1	-1	5
84XAA04	2042	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	5	-1	-1	5
84XAA04	2043	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	5	-1	-1	5
84XAA04	2044	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	5	-1	-1	5
84XAA04	2045	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	5	-1	-1	5
17XGA04	2046	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	5	-1	-1	5
17XGA04	2047	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	5	-1	-1	5
17XGA04	2048	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	5	-1	-1	5
17XGA04	2049	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	16	5	-1	-1	5
85XAA04	2050	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	17	5	-1	-1	5
85XAA04	2051	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	18	5	-1	-1	5
85XAA04	2052	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	19	5	-1	-1	5
85XAA04	2053	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	20	5	-1	-1	5
NM6	2054	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	21	5	-1	-1	5
81XAA04	2055	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	1	6	-1	-1	6
81XAA04	2056	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	6	-1	-1	6
81XAA04	2057	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	3	6	-1	-1	6
81XAA04	2058	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	6	-1	-1	6
82XAA04	2059	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	5	6	-1	-1	6
82XAA04	2060	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	6	-1	-1	6
82XAA04	2061	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	6	-1	-1	6
82XAA04	2062	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	6	-1	-1	6
18XAG04	2063	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	6	-1	-1	6
18XAG04	2064	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	6	-1	-1	6
18XAG04	2065	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	6	-1	-1	6
18XAG04	2066	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	6	-1	-1	6
1XTE04	2067	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	6	-1	-1	6
1XTE04	2068	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	6	-1	-1	6
1XTE04	2069	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	6	-1	-1	6
1XTE04	2070	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	16	6	-1	-1	6
82XAA04	2071	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	17	6	-1	-1	6
82XAA04	2072	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	18	6	-1	-1	6
82XAA04	2073	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	19	6	-1	-1	6
82XAA04	2074	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	20	6	-1	-1	6
NM6	2075	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	35.9	-1	-1	-1	-1	-1	1	1	23	21	6	-1	-1	6
83XAA04	2076	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	1	7	-1	-1	7
83XAA04	2077	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	2	7	-1	-1	7
83XAA04	2078	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	67.8	-1	-1	-1	-1	-1	1	1	23	3	7	-1	-1	7
83XAA04	2079	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	55.9	-1	-1	-1	-1	-1	1	1	23	4	7	-1	-1	7
2XT4E04	2080	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	5	7	-1	-1	7
2XT4E04	2081	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	7	-1	-1	7
2XT4E04	2082	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	7	-1	-1	7
2XT4E04	2083	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	7	-1	-1	7
17XGA04	2084	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	7	-1	-1	7
17XGA04	2085	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	7	-1	-1	7
17XGA04	2086	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	7	-1	-1	7
17XGA04	2087	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	7	-1	-1	7
83XAA04	2088	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	61.4	-1	-1	-1	-1	-1	1	1	23	13	7	-1	-1	7
83XAA04	2089	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	14	7	-1	-1	7
83XAA04	2090	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	58.3	-1	-1	-1	-1	-1	1	1	23	15	7	-1	-1	7
83XAA04	2091	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	62.2	-1	-1	-1	-1	-1	1	1	23	16	7	-1	-1	7
81XAA04	2092	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	17	7	-1	-1	7
81XAA04	2093	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	18	7	-1	-1	7
81XAA04	2094	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	19	7	-1	-1	7
81XAA04	2095	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	20	7	-1	-1	7
85XAA04	2096	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	21	7	-1	-1	7
1XTE04	2097	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	1	8	-1	-1	8
1XTE04	2098	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	8	-1	-1	8
1XTE04	2099	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	3	8	-1	-1	8
1XTE04	2100	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	8	-1	-1	8
18XAG04	2101	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	5	8	-1	-1	8
18XAG04	2102	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	8	-1	-1	8
18XAG04	2103	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	8	-1	-1	8
18XAG04	2104	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	8	-1	-1	8
82XAA04	2105	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	8	-1	-1	8
82XAA04	2106	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	8	-1	-1	8
82XAA04	2107	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	8	-1	-1	8
82XAA04	2108	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	8	-1	-1	8
81XAA04	2109	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	8	-1	-1	8
81XAA04	2110	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	8	-1	-1	8
81XAA04	2111	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	8	-1	-1	8
81XAA04	2112	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	16	8	-1	-1	8
84XAA04	2113	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	17	8	-1	-1	8
84XAA04	2114	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	18	8	-1	-1	8
84XAA04	2115	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	19	8	-1	-1	8
84XAA04	2116	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	20	8	-1	-1	8
85XAA04	2117	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	21	8	-1	-1	8
85XAA04	2118	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	1	9	-1	-1	9
85XAA04	2119	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	9	-1	-1	9
85XAA04	2120	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	3	9	-1	-1	9
85XAA04	2121	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	9	-1	-1	9
80XAA04	2122	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	57.5	-1	-1	-1	-1	-1	1	1	23	5	9	-1	-1	9
80XAA04	2123	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	58.3	-1	-1	-1	-1	-1	1	1	23	6	9	-1	-1	9
80XAA04	2124	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	7	9	-1	-1	9
80XAA04	2125	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	61.4	-1	-1	-1	-1	-1	1	1	23	8	9	-1	-1	9
84XAA04	2126	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	9	-1	-1	9
84XAA04	2127	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	9	-1	-1	9
84XAA04	2128	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	9	-1	-1	9
84XAA04	2129	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	9	-1	-1	9
80XAA04	2130	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	13	9	-1	-1	9
80XAA04	2131	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	14	9	-1	-1	9
80XAA04	2132	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	42.3	-1	-1	-1	-1	-1	1	1	23	15	9	-1	-1	9
80XAA04	2133	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	16	9	-1	-1	9
83XAA04	2134	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	56.7	-1	-1	-1	-1	-1	1	1	23	17	9	-1	-1	9
83XAA04	2135	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	18	9	-1	-1	9
83XAA04	2136	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	19	9	-1	-1	9
83XAA04	2137	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	59.8	-1	-1	-1	-1	-1	1	1	23	20	9	-1	-1	9
85XAA04	2138	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	21	9	-1	-1	9
84XAA04	2139	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	1	10	-1	-1	10
84XAA04	2140	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	10	-1	-1	10
84XAA04	2141	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	3	10	-1	-1	10
84XAA04	2142	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	10	-1	-1	10
17XGA04	2143	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	5	10	-1	-1	10
17XGA04	2144	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	10	-1	-1	10
17XGA04	2145	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	10	-1	-1	10
17XGA04	2146	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	10	-1	-1	10
2XT4E04	2147	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	10	-1	-1	10
2XT4E04	2148	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	10	-1	-1	10
2XT4E04	2149	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	10	-1	-1	10
2XT4E04	2150	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	10	-1	-1	10
85XAA04	2151	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	10	-1	-1	10
85XAA04	2152	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	10	-1	-1	10
85XAA04	2153	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	10	-1	-1	10
85XAA04	2154	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	16	10	-1	-1	10
80XAA04	2155	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	17	10	-1	-1	10
80XAA04	2156	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	18	10	-1	-1	10
80XAA04	2157	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	35.9	-1	-1	-1	-1	-1	1	1	23	19	10	-1	-1	10
80XAA04	2158	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	24.7	-1	-1	-1	-1	-1	1	1	23	20	10	-1	-1	10
85XAA04	2159	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	21	10	-1	-1	10
NM6	2160	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	1	11	-1	-1	11
NM6	2161	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	2	11	-1	-1	11
NM6	2162	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	3	11	-1	-1	11
NM6	2163	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	35.9	-1	-1	-1	-1	-1	1	1	23	4	11	-1	-1	11
NM6	2164	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	5	11	-1	-1	11
NM6	2165	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	6	11	-1	-1	11
NM6	2166	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	7	11	-1	-1	11
NM6	2167	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	64.6	-1	-1	-1	-1	-1	1	1	23	8	11	-1	-1	11
NM6	2168	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	11	-1	-1	11
NM6	2169	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	10	11	-1	-1	11
NM6	2170	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	11	11	-1	-1	11
NM6	2171	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	60.6	-1	-1	-1	-1	-1	1	1	23	12	11	-1	-1	11
NM6	2172	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	13	11	-1	-1	11
NM6	2173	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	14	11	-1	-1	11
NM6	2174	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	15	11	-1	-1	11
NM6	2175	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	16	11	-1	-1	11
NM6	2176	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	17	11	-1	-1	11
NM6	2177	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	18	11	-1	-1	11
NM6	2178	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	19	11	-1	-1	11
NM6	2179	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	42.3	-1	-1	-1	-1	-1	1	1	23	20	11	-1	-1	11
NM6	2180	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	21	11	-1	-1	11
NM6	2181	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	1	12	-1	-1	12
NM6	2182	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	53.5	-1	-1	-1	-1	-1	1	1	23	2	12	-1	-1	12
NM6	2183	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	42.3	-1	-1	-1	-1	-1	1	1	23	3	12	-1	-1	12
NM6	2184	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	4	12	-1	-1	12
NM6	2185	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	5	12	-1	-1	12
NM6	2186	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	55.9	-1	-1	-1	-1	-1	1	1	23	6	12	-1	-1	12
NM6	2187	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	7	12	-1	-1	12
NM6	2188	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	8	12	-1	-1	12
NM6	2189	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	9	12	-1	-1	12
NM6	2190	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	10	12	-1	-1	12
NM6	2191	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	62.2	-1	-1	-1	-1	-1	1	1	23	11	12	-1	-1	12
NM6	2192	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	12	12	-1	-1	12
NM6	2193	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	13	12	-1	-1	12
NM6	2194	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	14	12	-1	-1	12
NM6	2195	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	15	12	-1	-1	12
NM6	2196	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	16	12	-1	-1	12
NM6	2197	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	17	12	-1	-1	12
NM6	2198	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	18	12	-1	-1	12
NM6	2199	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	19	12	-1	-1	12
NM6	2200	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	55.9	-1	-1	-1	-1	-1	1	1	23	20	12	-1	-1	12
NM6	2201	MI aspen field trial	-1	1	-1	2005-05-15	2011-10-10	1-0 	45	-1	-1	U	-1	59	-1	-1	-1	-1	-1	1	1	23	21	12	-1	-1	12
17XGA24	2202	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	1	1	-1	-1	1
17XGA04	2203	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	16	-1	-1	-1	-1	-1	1	1	23	2	1	-1	-1	1
17XGA04	2204	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	3	1	-1	-1	1
17XGA5	2205	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	4	1	-1	-1	1
82XAA04	2206	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	5	1	-1	-1	1
82XAA04	2207	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	6	1	-1	-1	1
82XAA04	2208	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	7	1	-1	-1	1
82XAA04	2209	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	10.4	-1	-1	-1	-1	-1	1	1	23	8	1	-1	-1	1
2XT4E04	2210	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	1	-1	-1	1
2XT4E04	2211	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	1	-1	-1	1
2XT4E04	2212	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	1	-1	-1	1
2XT4E04	2213	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	1	-1	-1	1
83XAA04	2214	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	13	1	-1	-1	1
83XAA04	2215	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	51.1	-1	-1	-1	-1	-1	1	1	23	14	1	-1	-1	1
83XAA04	2216	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	52.7	-1	-1	-1	-1	-1	1	1	23	15	1	-1	-1	1
83XAA04	2217	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	16	1	-1	-1	1
81XAA04	2218	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	17	1	-1	-1	1
81XAA04	2219	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	18	1	-1	-1	1
81XAA04	2220	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	19	1	-1	-1	1
81XAA04	2221	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	20	1	-1	-1	1
NM6	2222	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	21	1	-1	-1	1
80XAA04	2223	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	51.1	-1	-1	-1	-1	-1	1	1	23	1	2	-1	-1	2
80XAA04	2224	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	2	2	-1	-1	2
80XAA04	2225	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	3	2	-1	-1	2
80XAA04	2226	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	4	2	-1	-1	2
84XAA04	2227	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	5	2	-1	-1	2
84XAA04	2228	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	6	2	-1	-1	2
84XAA04	2229	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	7	2	-1	-1	2
84XAA04	2230	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	8	2	-1	-1	2
18XAG04	2231	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	24.7	-1	-1	-1	-1	-1	1	1	23	9	2	-1	-1	2
18XAG04	2232	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	10	2	-1	-1	2
18XAG04	2233	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	11	2	-1	-1	2
18XAG04	2234	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	12	2	-1	-1	2
81XAA04	2235	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	2	-1	-1	2
81XAA04	2236	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	14	2	-1	-1	2
81XAA04	2237	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	18.4	-1	-1	-1	-1	-1	1	1	23	15	2	-1	-1	2
81XAA04	2238	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	16	2	-1	-1	2
80XAA04	2239	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	17	2	-1	-1	2
80XAA04	2240	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	18	2	-1	-1	2
80XAA04	2241	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	19	2	-1	-1	2
80XAA04	2242	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	20	2	-1	-1	2
NM6	2243	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	18.4	-1	-1	-1	-1	-1	1	1	23	21	2	-1	-1	2
83XAA04	2244	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	1	3	-1	-1	3
83XAA04	2245	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	2	3	-1	-1	3
83XAA04	2246	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	3	3	-1	-1	3
83XAA04	2247	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	55.1	-1	-1	-1	-1	-1	1	1	23	4	3	-1	-1	3
1XTE04	2248	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	5	3	-1	-1	3
1XTE04	2249	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	6	3	-1	-1	3
1XTE04	2250	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	7	3	-1	-1	3
1XTE04	2251	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	8	3	-1	-1	3
80XAA04	2252	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	54.3	-1	-1	-1	-1	-1	1	1	23	9	3	-1	-1	3
80XAA04	2253	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	10	3	-1	-1	3
80XAA04	2254	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	11	3	-1	-1	3
80XAA04	2255	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	56.7	-1	-1	-1	-1	-1	1	1	23	12	3	-1	-1	3
82XAA04	2256	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	13	3	-1	-1	3
82XAA04	2257	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	41.5	-1	-1	-1	-1	-1	1	1	23	14	3	-1	-1	3
82XAA04	2258	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	15	3	-1	-1	3
82XAA04	2259	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	16	3	-1	-1	3
83XAA04	2260	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	17	3	-1	-1	3
83XAA04	2261	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	18	3	-1	-1	3
83XAA04	2262	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	19	3	-1	-1	3
83XAA04	2263	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	20	3	-1	-1	3
NM6	2264	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	21	3	-1	-1	3
85XAA04	2265	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	1	4	-1	-1	4
85XAA04	2266	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	2	4	-1	-1	4
85XAA04	2267	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	3.2	-1	-1	-1	-1	-1	1	1	23	3	4	-1	-1	4
85XAA04	2268	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	1.6	-1	-1	-1	-1	-1	1	1	23	4	4	-1	-1	4
18XAG04	2269	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	5	4	-1	-1	4
18XAG04	2270	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	6	4	-1	-1	4
18XAG04	2271	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	7	4	-1	-1	4
18XAG04	2272	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	8	4	-1	-1	4
85XAA04	2273	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	12.8	-1	-1	-1	-1	-1	1	1	23	9	4	-1	-1	4
85XAA04	2274	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	10	4	-1	-1	4
85XAA04	2275	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	4.8	-1	-1	-1	-1	-1	1	1	23	11	4	-1	-1	4
85XAA04	2276	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	5.6	-1	-1	-1	-1	-1	1	1	23	12	4	-1	-1	4
84XAA04	2277	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	13	4	-1	-1	4
84XAA04	2278	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	4	-1	-1	4
84XAA04	2279	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	15	4	-1	-1	4
84XAA04	2280	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	16	4	-1	-1	4
82XAA04	2281	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	17	4	-1	-1	4
82XAA04	2282	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	18	4	-1	-1	4
82XAA04	2283	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	19	4	-1	-1	4
82XAA04	2284	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	42.3	-1	-1	-1	-1	-1	1	1	23	20	4	-1	-1	4
NM6	2285	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	21	4	-1	-1	4
81XAA04	2286	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	1	5	-1	-1	5
81XAA04	2287	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	2	5	-1	-1	5
81XAA04	2288	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	3	5	-1	-1	5
81XAA04	2289	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	64.6	-1	-1	-1	-1	-1	1	1	23	4	5	-1	-1	5
2XT4E04	2290	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	5	5	-1	-1	5
2XT4E04	2291	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	5	-1	-1	5
2XT4E04	2292	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	5	-1	-1	5
2XT4E04	2293	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	8	5	-1	-1	5
84XAA04	2294	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	25.5	-1	-1	-1	-1	-1	1	1	23	9	5	-1	-1	5
84XAA04	2295	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	10	5	-1	-1	5
84XAA04	2296	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	55.1	-1	-1	-1	-1	-1	1	1	23	11	5	-1	-1	5
84XAA04	2297	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	12	5	-1	-1	5
17XGA04	2298	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	16	-1	-1	-1	-1	-1	1	1	23	13	5	-1	-1	5
17XGA04	2299	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	14	5	-1	-1	5
17XGA04	2300	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	15	5	-1	-1	5
17XGA04	2301	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	16	5	-1	-1	5
85XAA04	2302	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	4	-1	-1	-1	-1	-1	1	1	23	17	5	-1	-1	5
85XAA04	2303	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	18	5	-1	-1	5
85XAA04	2304	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	19	5	-1	-1	5
85XAA04	2305	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	20	5	-1	-1	5
NM6	2306	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	21	5	-1	-1	5
81XAA04	2307	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	54.3	-1	-1	-1	-1	-1	1	1	23	1	6	-1	-1	6
81XAA04	2308	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	2	6	-1	-1	6
81XAA04	2309	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	41.5	-1	-1	-1	-1	-1	1	1	23	3	6	-1	-1	6
81XAA04	2310	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	6	-1	-1	6
82XAA04	2311	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	5	6	-1	-1	6
82XAA04	2312	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	6	6	-1	-1	6
82XAA04	2313	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	7	6	-1	-1	6
82XAA04	2314	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	8	6	-1	-1	6
18XAG04	2315	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	9	6	-1	-1	6
18XAG04	2316	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	41.5	-1	-1	-1	-1	-1	1	1	23	10	6	-1	-1	6
18XAG04	2317	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	9.6	-1	-1	-1	-1	-1	1	1	23	11	6	-1	-1	6
18XAG04	2318	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	12	6	-1	-1	6
1XTE04	2319	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	6	-1	-1	6
1XTE04	2320	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	6	-1	-1	6
1XTE04	2321	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	6	-1	-1	6
1XTE04	2322	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	16	-1	-1	-1	-1	-1	1	1	23	16	6	-1	-1	6
82XAA04	2323	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	17	6	-1	-1	6
82XAA04	2324	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	18	6	-1	-1	6
82XAA04	2325	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	19	6	-1	-1	6
82XAA04	2326	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	20	6	-1	-1	6
NM6	2327	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	21	6	-1	-1	6
83XAA04	2328	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	1	7	-1	-1	7
83XAA04	2329	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	48.7	-1	-1	-1	-1	-1	1	1	23	2	7	-1	-1	7
83XAA04	2330	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	3	7	-1	-1	7
83XAA04	2331	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	4	7	-1	-1	7
2XT4E04	2332	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	5.6	-1	-1	-1	-1	-1	1	1	23	5	7	-1	-1	7
2XT4E04	2333	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	7	-1	-1	7
2XT4E04	2334	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	7	7	-1	-1	7
2XT4E04	2335	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	8	7	-1	-1	7
17XGA04	2336	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	9	7	-1	-1	7
17XGA04	2337	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	10	7	-1	-1	7
17XGA04	2338	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	11	7	-1	-1	7
17XGA04	2339	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	7	-1	-1	7
83XAA04	2340	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	55.1	-1	-1	-1	-1	-1	1	1	23	13	7	-1	-1	7
83XAA04	2341	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	14	7	-1	-1	7
83XAA04	2342	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	15	7	-1	-1	7
83XAA04	2343	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	56.7	-1	-1	-1	-1	-1	1	1	23	16	7	-1	-1	7
81XAA04	2344	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	5.6	-1	-1	-1	-1	-1	1	1	23	17	7	-1	-1	7
81XAA04	2345	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	18	7	-1	-1	7
81XAA04	2346	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	19	7	-1	-1	7
81XAA04	2347	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	20	7	-1	-1	7
85XAA04	2348	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	21	7	-1	-1	7
1XTE04	2349	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	14.4	-1	-1	-1	-1	-1	1	1	23	1	8	-1	-1	8
1XTE04	2350	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	8	-1	-1	8
1XTE04	2351	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	7.2	-1	-1	-1	-1	-1	1	1	23	3	8	-1	-1	8
1XTE04	2352	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	4	8	-1	-1	8
18XAG04	2353	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	5	8	-1	-1	8
18XAG04	2354	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	6	8	-1	-1	8
18XAG04	2355	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	7	8	-1	-1	8
18XAG04	2356	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	8	8	-1	-1	8
82XAA04	2357	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	9	8	-1	-1	8
82XAA04	2358	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	10	8	-1	-1	8
82XAA04	2359	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	11	8	-1	-1	8
82XAA04	2360	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	35.9	-1	-1	-1	-1	-1	1	1	23	12	8	-1	-1	8
81XAA04	2361	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	35.9	-1	-1	-1	-1	-1	1	1	23	13	8	-1	-1	8
81XAA04	2362	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	14	8	-1	-1	8
81XAA04	2363	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	8	-1	-1	8
81XAA04	2364	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	16	8	-1	-1	8
84XAA04	2365	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	17	8	-1	-1	8
84XAA04	2366	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	18	8	-1	-1	8
84XAA04	2367	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	19	8	-1	-1	8
84XAA04	2368	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	24.7	-1	-1	-1	-1	-1	1	1	23	20	8	-1	-1	8
85XAA04	2369	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	16.8	-1	-1	-1	-1	-1	1	1	23	21	8	-1	-1	8
85XAA04	2370	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	7.2	-1	-1	-1	-1	-1	1	1	23	1	9	-1	-1	9
85XAA04	2371	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	2	9	-1	-1	9
85XAA04	2372	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	3	9	-1	-1	9
85XAA04	2373	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	9	-1	-1	9
80XAA04	2374	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	5	9	-1	-1	9
80XAA04	2375	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	6	9	-1	-1	9
80XAA04	2376	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	7	9	-1	-1	9
80XAA04	2377	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	54.3	-1	-1	-1	-1	-1	1	1	23	8	9	-1	-1	9
84XAA04	2378	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	9	9	-1	-1	9
84XAA04	2379	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	10	9	-1	-1	9
84XAA04	2380	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	11	9	-1	-1	9
84XAA04	2381	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	12	9	-1	-1	9
80XAA04	2382	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	13	9	-1	-1	9
80XAA04	2383	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	14	9	-1	-1	9
80XAA04	2384	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	15	9	-1	-1	9
80XAA04	2385	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	16	9	-1	-1	9
83XAA04	2386	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	51.9	-1	-1	-1	-1	-1	1	1	23	17	9	-1	-1	9
83XAA04	2387	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	18	9	-1	-1	9
83XAA04	2388	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	19	9	-1	-1	9
83XAA04	2389	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	57.5	-1	-1	-1	-1	-1	1	1	23	20	9	-1	-1	9
85XAA04	2390	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	12.8	-1	-1	-1	-1	-1	1	1	23	21	9	-1	-1	9
84XAA04	2391	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	49.5	-1	-1	-1	-1	-1	1	1	23	1	10	-1	-1	10
84XAA04	2392	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	7.2	-1	-1	-1	-1	-1	1	1	23	2	10	-1	-1	10
84XAA04	2393	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	3	10	-1	-1	10
84XAA04	2394	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	48.7	-1	-1	-1	-1	-1	1	1	23	4	10	-1	-1	10
17XGA04	2395	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	5	10	-1	-1	10
17XGA04	2396	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	24.7	-1	-1	-1	-1	-1	1	1	23	6	10	-1	-1	10
17XGA04	2397	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	7	10	-1	-1	10
17XGA04	2398	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	8	10	-1	-1	10
2XT4E04	2399	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	9	10	-1	-1	10
2XT4E04	2400	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	10	-1	-1	10
2XT4E04	2401	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	11	10	-1	-1	10
2XT4E04	2402	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	10	-1	-1	10
85XAA04	2403	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	14.4	-1	-1	-1	-1	-1	1	1	23	13	10	-1	-1	10
85XAA04	2404	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	10	-1	-1	10
85XAA04	2405	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	10	-1	-1	10
85XAA04	2406	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	14.4	-1	-1	-1	-1	-1	1	1	23	16	10	-1	-1	10
80XAA04	2407	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	17	10	-1	-1	10
80XAA04	2408	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	18	10	-1	-1	10
80XAA04	2409	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	19	10	-1	-1	10
80XAA04	2410	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	20	10	-1	-1	10
85XAA04	2411	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	3.2	-1	-1	-1	-1	-1	1	1	23	21	10	-1	-1	10
NM6	2412	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	1	11	-1	-1	11
NM6	2413	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	2	11	-1	-1	11
NM6	2414	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	3	11	-1	-1	11
NM6	2415	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	4	11	-1	-1	11
NM6	2416	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	5	11	-1	-1	11
NM6	2417	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	41.5	-1	-1	-1	-1	-1	1	1	23	6	11	-1	-1	11
NM6	2418	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	41.5	-1	-1	-1	-1	-1	1	1	23	7	11	-1	-1	11
NM6	2419	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	56.7	-1	-1	-1	-1	-1	1	1	23	8	11	-1	-1	11
NM6	2420	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	11	-1	-1	11
NM6	2421	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	10	11	-1	-1	11
NM6	2422	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	11	11	-1	-1	11
NM6	2423	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	12	11	-1	-1	11
NM6	2424	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	13	11	-1	-1	11
NM6	2425	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	14	11	-1	-1	11
NM6	2426	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	15	11	-1	-1	11
NM6	2427	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	16	11	-1	-1	11
NM6	2428	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	17	11	-1	-1	11
NM6	2429	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	18	11	-1	-1	11
NM6	2430	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	19	11	-1	-1	11
NM6	2431	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	20	11	-1	-1	11
NM6	2432	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	21	11	-1	-1	11
NM6	2433	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	1	12	-1	-1	12
NM6	2434	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	42.3	-1	-1	-1	-1	-1	1	1	23	2	12	-1	-1	12
NM6	2435	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	3	12	-1	-1	12
NM6	2436	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	4	12	-1	-1	12
NM6	2437	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	5	12	-1	-1	12
NM6	2438	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	50.3	-1	-1	-1	-1	-1	1	1	23	6	12	-1	-1	12
NM6	2439	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	48.7	-1	-1	-1	-1	-1	1	1	23	7	12	-1	-1	12
NM6	2440	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	8	12	-1	-1	12
NM6	2441	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	9	12	-1	-1	12
NM6	2442	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	10	12	-1	-1	12
NM6	2443	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	11	12	-1	-1	12
NM6	2444	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	12	12	-1	-1	12
NM6	2445	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	13	12	-1	-1	12
NM6	2446	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	14	12	-1	-1	12
NM6	2447	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	15	12	-1	-1	12
NM6	2448	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	16	12	-1	-1	12
NM6	2449	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	25.5	-1	-1	-1	-1	-1	1	1	23	17	12	-1	-1	12
NM6	2450	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	18	12	-1	-1	12
NM6	2451	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	19	12	-1	-1	12
NM6	2452	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	47.1	-1	-1	-1	-1	-1	1	1	23	20	12	-1	-1	12
NM6	2453	MI aspen field trial	-1	1	-1	2005-05-15	2010-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	21	12	-1	-1	12
17XGA24	2454	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	1	1	-1	-1	1
17XGA04	2455	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	2	1	-1	-1	1
17XGA04	2456	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	3	1	-1	-1	1
17XGA5	2457	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	4	1	-1	-1	1
82XAA04	2458	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	5	1	-1	-1	1
82XAA04	2459	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	6	1	-1	-1	1
82XAA04	2460	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	35.9	-1	-1	-1	-1	-1	1	1	23	7	1	-1	-1	1
82XAA04	2461	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	10.4	-1	-1	-1	-1	-1	1	1	23	8	1	-1	-1	1
2XT4E04	2462	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	1	-1	-1	1
2XT4E04	2463	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	1	-1	-1	1
2XT4E04	2464	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	1	-1	-1	1
2XT4E04	2465	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	1	-1	-1	1
83XAA04	2466	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	13	1	-1	-1	1
83XAA04	2467	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	41.5	-1	-1	-1	-1	-1	1	1	23	14	1	-1	-1	1
83XAA04	2468	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	15	1	-1	-1	1
83XAA04	2469	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	16	1	-1	-1	1
81XAA04	2470	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	17	1	-1	-1	1
81XAA04	2471	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	18	1	-1	-1	1
81XAA04	2472	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	19	1	-1	-1	1
81XAA04	2473	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	20	1	-1	-1	1
NM6	2474	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	21	1	-1	-1	1
80XAA04	2475	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	42.3	-1	-1	-1	-1	-1	1	1	23	1	2	-1	-1	2
80XAA04	2476	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	2	2	-1	-1	2
80XAA04	2477	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	3	2	-1	-1	2
80XAA04	2478	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	16.8	-1	-1	-1	-1	-1	1	1	23	4	2	-1	-1	2
84XAA04	2479	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	5	2	-1	-1	2
84XAA04	2480	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	6	2	-1	-1	2
84XAA04	2481	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	7	2	-1	-1	2
84XAA04	2482	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	8	2	-1	-1	2
18XAG04	2483	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	9	2	-1	-1	2
18XAG04	2484	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	10	2	-1	-1	2
18XAG04	2485	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	11	2	-1	-1	2
18XAG04	2486	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	12	2	-1	-1	2
81XAA04	2487	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	2	-1	-1	2
81XAA04	2488	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	14	2	-1	-1	2
81XAA04	2489	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	16.8	-1	-1	-1	-1	-1	1	1	23	15	2	-1	-1	2
81XAA04	2490	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	16	2	-1	-1	2
80XAA04	2491	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	17	2	-1	-1	2
80XAA04	2492	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	18	2	-1	-1	2
80XAA04	2493	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	46.3	-1	-1	-1	-1	-1	1	1	23	19	2	-1	-1	2
80XAA04	2494	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	20	2	-1	-1	2
NM6	2495	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	14.4	-1	-1	-1	-1	-1	1	1	23	21	2	-1	-1	2
83XAA04	2496	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	1	3	-1	-1	3
83XAA04	2497	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	2	3	-1	-1	3
83XAA04	2498	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	35.9	-1	-1	-1	-1	-1	1	1	23	3	3	-1	-1	3
83XAA04	2499	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	45.5	-1	-1	-1	-1	-1	1	1	23	4	3	-1	-1	3
1XTE04	2500	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	5	3	-1	-1	3
1XTE04	2501	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	6	3	-1	-1	3
1XTE04	2502	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	7	3	-1	-1	3
1XTE04	2503	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	8	3	-1	-1	3
80XAA04	2504	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	9	3	-1	-1	3
80XAA04	2505	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	24.7	-1	-1	-1	-1	-1	1	1	23	10	3	-1	-1	3
80XAA04	2506	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	11	3	-1	-1	3
80XAA04	2507	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	12	3	-1	-1	3
82XAA04	2508	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	13	3	-1	-1	3
82XAA04	2509	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	14	3	-1	-1	3
82XAA04	2510	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	15	3	-1	-1	3
82XAA04	2511	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	16	3	-1	-1	3
83XAA04	2512	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	17	3	-1	-1	3
83XAA04	2513	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	18	3	-1	-1	3
83XAA04	2514	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	19	3	-1	-1	3
83XAA04	2515	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	20	3	-1	-1	3
NM6	2516	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	40.7	-1	-1	-1	-1	-1	1	1	23	21	3	-1	-1	3
85XAA04	2517	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	1	4	-1	-1	4
85XAA04	2518	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	2	4	-1	-1	4
85XAA04	2519	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	3.2	-1	-1	-1	-1	-1	1	1	23	3	4	-1	-1	4
85XAA04	2520	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	1.6	-1	-1	-1	-1	-1	1	1	23	4	4	-1	-1	4
18XAG04	2521	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	5	4	-1	-1	4
18XAG04	2522	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	24.7	-1	-1	-1	-1	-1	1	1	23	6	4	-1	-1	4
18XAG04	2523	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	7	4	-1	-1	4
18XAG04	2524	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	8	4	-1	-1	4
85XAA04	2525	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	11.2	-1	-1	-1	-1	-1	1	1	23	9	4	-1	-1	4
85XAA04	2526	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	10	4	-1	-1	4
85XAA04	2527	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	3.2	-1	-1	-1	-1	-1	1	1	23	11	4	-1	-1	4
85XAA04	2528	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	4.8	-1	-1	-1	-1	-1	1	1	23	12	4	-1	-1	4
84XAA04	2529	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	24.7	-1	-1	-1	-1	-1	1	1	23	13	4	-1	-1	4
84XAA04	2530	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	4	-1	-1	4
84XAA04	2531	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	15	4	-1	-1	4
84XAA04	2532	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	16	4	-1	-1	4
82XAA04	2533	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	17	4	-1	-1	4
82XAA04	2534	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	18	4	-1	-1	4
82XAA04	2535	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	19	4	-1	-1	4
82XAA04	2536	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	20	4	-1	-1	4
NM6	2537	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	21	4	-1	-1	4
81XAA04	2538	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	1	5	-1	-1	5
81XAA04	2539	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	2	5	-1	-1	5
81XAA04	2540	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	3	5	-1	-1	5
81XAA04	2541	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	52.7	-1	-1	-1	-1	-1	1	1	23	4	5	-1	-1	5
2XT4E04	2542	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	8.8	-1	-1	-1	-1	-1	1	1	23	5	5	-1	-1	5
2XT4E04	2543	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	5	-1	-1	5
2XT4E04	2544	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	5	-1	-1	5
2XT4E04	2545	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	8.8	-1	-1	-1	-1	-1	1	1	23	8	5	-1	-1	5
84XAA04	2546	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	9	5	-1	-1	5
84XAA04	2547	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	10	5	-1	-1	5
84XAA04	2548	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	41.5	-1	-1	-1	-1	-1	1	1	23	11	5	-1	-1	5
84XAA04	2549	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	12	5	-1	-1	5
17XGA04	2550	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	13	5	-1	-1	5
17XGA04	2551	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	14	5	-1	-1	5
17XGA04	2552	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	15	5	-1	-1	5
17XGA04	2553	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	16	5	-1	-1	5
85XAA04	2554	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	4	-1	-1	-1	-1	-1	1	1	23	17	5	-1	-1	5
85XAA04	2555	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	18	5	-1	-1	5
85XAA04	2556	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	11.2	-1	-1	-1	-1	-1	1	1	23	19	5	-1	-1	5
85XAA04	2557	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	3.2	-1	-1	-1	-1	-1	1	1	23	20	5	-1	-1	5
NM6	2558	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	35.9	-1	-1	-1	-1	-1	1	1	23	21	5	-1	-1	5
81XAA04	2559	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	1	6	-1	-1	6
81XAA04	2560	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	2	6	-1	-1	6
81XAA04	2561	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	3	6	-1	-1	6
81XAA04	2562	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	8	-1	-1	-1	-1	-1	1	1	23	4	6	-1	-1	6
82XAA04	2563	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	5	6	-1	-1	6
82XAA04	2564	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	35.9	-1	-1	-1	-1	-1	1	1	23	6	6	-1	-1	6
82XAA04	2565	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	7	6	-1	-1	6
82XAA04	2566	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	8	6	-1	-1	6
18XAG04	2567	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	12	-1	-1	-1	-1	-1	1	1	23	9	6	-1	-1	6
18XAG04	2568	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	10	6	-1	-1	6
18XAG04	2569	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	7.2	-1	-1	-1	-1	-1	1	1	23	11	6	-1	-1	6
18XAG04	2570	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	12	6	-1	-1	6
1XTE04	2571	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	6	-1	-1	6
1XTE04	2572	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	6	-1	-1	6
1XTE04	2573	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	6	-1	-1	6
1XTE04	2574	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	16	6	-1	-1	6
82XAA04	2575	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	17	6	-1	-1	6
82XAA04	2576	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	18	6	-1	-1	6
82XAA04	2577	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	19	6	-1	-1	6
82XAA04	2578	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	20	6	-1	-1	6
NM6	2579	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	21	6	-1	-1	6
83XAA04	2580	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	1	7	-1	-1	7
83XAA04	2581	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	2	7	-1	-1	7
83XAA04	2582	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	3	7	-1	-1	7
83XAA04	2583	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	4	7	-1	-1	7
2XT4E04	2584	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	4	-1	-1	-1	-1	-1	1	1	23	5	7	-1	-1	7
2XT4E04	2585	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	7	-1	-1	7
2XT4E04	2586	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	16	-1	-1	-1	-1	-1	1	1	23	7	7	-1	-1	7
2XT4E04	2587	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	16	-1	-1	-1	-1	-1	1	1	23	8	7	-1	-1	7
17XGA04	2588	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	9	7	-1	-1	7
17XGA04	2589	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	16	-1	-1	-1	-1	-1	1	1	23	10	7	-1	-1	7
17XGA04	2590	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	16.8	-1	-1	-1	-1	-1	1	1	23	11	7	-1	-1	7
17XGA04	2591	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	2.4	-1	-1	-1	-1	-1	1	1	23	12	7	-1	-1	7
83XAA04	2592	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	42.3	-1	-1	-1	-1	-1	1	1	23	13	7	-1	-1	7
83XAA04	2593	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	14	7	-1	-1	7
83XAA04	2594	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	41.5	-1	-1	-1	-1	-1	1	1	23	15	7	-1	-1	7
83XAA04	2595	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	16	7	-1	-1	7
81XAA04	2596	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	5.6	-1	-1	-1	-1	-1	1	1	23	17	7	-1	-1	7
81XAA04	2597	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	18	7	-1	-1	7
81XAA04	2598	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	24.7	-1	-1	-1	-1	-1	1	1	23	19	7	-1	-1	7
81XAA04	2599	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	20	7	-1	-1	7
85XAA04	2600	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	21	7	-1	-1	7
1XTE04	2601	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	10.4	-1	-1	-1	-1	-1	1	1	23	1	8	-1	-1	8
1XTE04	2602	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	8	-1	-1	8
1XTE04	2603	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	5.6	-1	-1	-1	-1	-1	1	1	23	3	8	-1	-1	8
1XTE04	2604	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	11.2	-1	-1	-1	-1	-1	1	1	23	4	8	-1	-1	8
18XAG04	2605	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	5	8	-1	-1	8
18XAG04	2606	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	6	8	-1	-1	8
18XAG04	2607	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	14.4	-1	-1	-1	-1	-1	1	1	23	7	8	-1	-1	8
18XAG04	2608	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	8	8	-1	-1	8
82XAA04	2609	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	9	8	-1	-1	8
82XAA04	2610	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	10	8	-1	-1	8
82XAA04	2611	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	11	8	-1	-1	8
82XAA04	2612	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	12	8	-1	-1	8
81XAA04	2613	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	13	8	-1	-1	8
81XAA04	2614	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	14	8	-1	-1	8
81XAA04	2615	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	8	-1	-1	8
81XAA04	2616	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	16	8	-1	-1	8
84XAA04	2617	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	17	8	-1	-1	8
84XAA04	2618	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	18	8	-1	-1	8
84XAA04	2619	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	14.4	-1	-1	-1	-1	-1	1	1	23	19	8	-1	-1	8
84XAA04	2620	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	20	8	-1	-1	8
85XAA04	2621	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	21	8	-1	-1	8
85XAA04	2622	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	6.4	-1	-1	-1	-1	-1	1	1	23	1	9	-1	-1	9
85XAA04	2623	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	12	-1	-1	-1	-1	-1	1	1	23	2	9	-1	-1	9
85XAA04	2624	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	1.6	-1	-1	-1	-1	-1	1	1	23	3	9	-1	-1	9
85XAA04	2625	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	9	-1	-1	9
80XAA04	2626	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	5	9	-1	-1	9
80XAA04	2627	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	6	9	-1	-1	9
80XAA04	2628	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	7	9	-1	-1	9
80XAA04	2629	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	8	9	-1	-1	9
84XAA04	2630	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	9	9	-1	-1	9
84XAA04	2631	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	10	9	-1	-1	9
84XAA04	2632	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	18.4	-1	-1	-1	-1	-1	1	1	23	11	9	-1	-1	9
84XAA04	2633	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	14.4	-1	-1	-1	-1	-1	1	1	23	12	9	-1	-1	9
80XAA04	2634	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	13	9	-1	-1	9
80XAA04	2635	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	14	9	-1	-1	9
80XAA04	2636	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	15	9	-1	-1	9
80XAA04	2637	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	16	9	-1	-1	9
83XAA04	2638	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	17	9	-1	-1	9
83XAA04	2639	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	18	9	-1	-1	9
83XAA04	2640	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	19	9	-1	-1	9
83XAA04	2641	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	44.7	-1	-1	-1	-1	-1	1	1	23	20	9	-1	-1	9
85XAA04	2642	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	11.2	-1	-1	-1	-1	-1	1	1	23	21	9	-1	-1	9
84XAA04	2643	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	1	10	-1	-1	10
84XAA04	2644	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	6.4	-1	-1	-1	-1	-1	1	1	23	2	10	-1	-1	10
84XAA04	2645	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	3	10	-1	-1	10
84XAA04	2646	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	4	10	-1	-1	10
17XGA04	2647	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	25.5	-1	-1	-1	-1	-1	1	1	23	5	10	-1	-1	10
17XGA04	2648	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	6	10	-1	-1	10
17XGA04	2649	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	7	10	-1	-1	10
17XGA04	2650	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	8	10	-1	-1	10
2XT4E04	2651	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	9	10	-1	-1	10
2XT4E04	2652	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	10	-1	-1	10
2XT4E04	2653	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	11	10	-1	-1	10
2XT4E04	2654	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	10	-1	-1	10
85XAA04	2655	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	11.2	-1	-1	-1	-1	-1	1	1	23	13	10	-1	-1	10
85XAA04	2656	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	10	-1	-1	10
85XAA04	2657	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	5.6	-1	-1	-1	-1	-1	1	1	23	15	10	-1	-1	10
85XAA04	2658	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	8	-1	-1	-1	-1	-1	1	1	23	16	10	-1	-1	10
80XAA04	2659	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	17	10	-1	-1	10
80XAA04	2660	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	7.2	-1	-1	-1	-1	-1	1	1	23	18	10	-1	-1	10
80XAA04	2661	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	19	10	-1	-1	10
80XAA04	2662	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	20	10	-1	-1	10
85XAA04	2663	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	3.2	-1	-1	-1	-1	-1	1	1	23	21	10	-1	-1	10
NM6	2664	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	1	11	-1	-1	11
NM6	2665	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	2	11	-1	-1	11
NM6	2666	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	3	11	-1	-1	11
NM6	2667	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	25.5	-1	-1	-1	-1	-1	1	1	23	4	11	-1	-1	11
NM6	2668	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	5	11	-1	-1	11
NM6	2669	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	6	11	-1	-1	11
NM6	2670	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	7	11	-1	-1	11
NM6	2671	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	47.9	-1	-1	-1	-1	-1	1	1	23	8	11	-1	-1	11
NM6	2672	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	11	-1	-1	11
NM6	2673	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	10	11	-1	-1	11
NM6	2674	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	11	11	-1	-1	11
NM6	2675	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	12	11	-1	-1	11
NM6	2676	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	13	11	-1	-1	11
NM6	2677	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	12	-1	-1	-1	-1	-1	1	1	23	14	11	-1	-1	11
NM6	2678	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	15	11	-1	-1	11
NM6	2679	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	16	11	-1	-1	11
NM6	2680	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	36.7	-1	-1	-1	-1	-1	1	1	23	17	11	-1	-1	11
NM6	2681	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	18	11	-1	-1	11
NM6	2682	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	19	11	-1	-1	11
NM6	2683	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	20	11	-1	-1	11
NM6	2684	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	21	11	-1	-1	11
NM6	2685	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	1	12	-1	-1	12
NM6	2686	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	2	12	-1	-1	12
NM6	2687	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	3	12	-1	-1	12
NM6	2688	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	4	12	-1	-1	12
NM6	2689	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	5	12	-1	-1	12
NM6	2690	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	43.1	-1	-1	-1	-1	-1	1	1	23	6	12	-1	-1	12
NM6	2691	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	7	12	-1	-1	12
NM6	2692	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	8	12	-1	-1	12
NM6	2693	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	9	12	-1	-1	12
NM6	2694	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	10	12	-1	-1	12
NM6	2695	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	11	12	-1	-1	12
NM6	2696	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	12	12	-1	-1	12
NM6	2697	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	9.6	-1	-1	-1	-1	-1	1	1	23	13	12	-1	-1	12
NM6	2698	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	14	12	-1	-1	12
NM6	2699	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	15	12	-1	-1	12
NM6	2700	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	16	12	-1	-1	12
NM6	2701	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	17	12	-1	-1	12
NM6	2702	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	18	12	-1	-1	12
NM6	2703	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	19	12	-1	-1	12
NM6	2704	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	20	12	-1	-1	12
NM6	2705	MI aspen field trial	-1	1	-1	2005-05-15	2009-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	21	12	-1	-1	12
17XGA24	2706	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	18.4	-1	-1	-1	-1	-1	1	1	23	1	1	-1	-1	1
17XGA04	2707	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	10.4	-1	-1	-1	-1	-1	1	1	23	2	1	-1	-1	1
17XGA04	2708	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	3	1	-1	-1	1
17XGA5	2709	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	4	1	-1	-1	1
82XAA04	2710	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	5	1	-1	-1	1
82XAA04	2711	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	14.4	-1	-1	-1	-1	-1	1	1	23	6	1	-1	-1	1
82XAA04	2712	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	7	1	-1	-1	1
82XAA04	2713	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	10.4	-1	-1	-1	-1	-1	1	1	23	8	1	-1	-1	1
2XT4E04	2714	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	1	-1	-1	1
2XT4E04	2715	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	1	-1	-1	1
2XT4E04	2716	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	11	1	-1	-1	1
2XT4E04	2717	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	1	-1	-1	1
83XAA04	2718	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	13	1	-1	-1	1
83XAA04	2719	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	14	1	-1	-1	1
83XAA04	2720	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	39.1	-1	-1	-1	-1	-1	1	1	23	15	1	-1	-1	1
83XAA04	2721	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	16	1	-1	-1	1
81XAA04	2722	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	17	1	-1	-1	1
81XAA04	2723	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	18	1	-1	-1	1
81XAA04	2724	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	19	1	-1	-1	1
81XAA04	2725	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	20	1	-1	-1	1
NM6	2726	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	21	1	-1	-1	1
80XAA04	2727	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	1	2	-1	-1	2
80XAA04	2728	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	2	2	-1	-1	2
80XAA04	2729	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	3	2	-1	-1	2
80XAA04	2730	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	4	2	-1	-1	2
84XAA04	2731	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	5	2	-1	-1	2
84XAA04	2732	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	6	2	-1	-1	2
84XAA04	2733	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	7	2	-1	-1	2
84XAA04	2734	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	16	-1	-1	-1	-1	-1	1	1	23	8	2	-1	-1	2
18XAG04	2735	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	16.8	-1	-1	-1	-1	-1	1	1	23	9	2	-1	-1	2
18XAG04	2736	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	10	2	-1	-1	2
18XAG04	2737	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	11	2	-1	-1	2
18XAG04	2738	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	12	2	-1	-1	2
81XAA04	2739	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	13	2	-1	-1	2
81XAA04	2740	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	18.4	-1	-1	-1	-1	-1	1	1	23	14	2	-1	-1	2
81XAA04	2741	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	12.8	-1	-1	-1	-1	-1	1	1	23	15	2	-1	-1	2
81XAA04	2742	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	16	2	-1	-1	2
80XAA04	2743	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	17	2	-1	-1	2
80XAA04	2744	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	18	2	-1	-1	2
80XAA04	2745	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	39.9	-1	-1	-1	-1	-1	1	1	23	19	2	-1	-1	2
80XAA04	2746	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	20	2	-1	-1	2
NM6	2747	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	10.4	-1	-1	-1	-1	-1	1	1	23	21	2	-1	-1	2
83XAA04	2748	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	1	3	-1	-1	3
83XAA04	2749	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	2	3	-1	-1	3
83XAA04	2750	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	3	3	-1	-1	3
83XAA04	2751	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	35.1	-1	-1	-1	-1	-1	1	1	23	4	3	-1	-1	3
1XTE04	2752	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	5	3	-1	-1	3
1XTE04	2753	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	14.4	-1	-1	-1	-1	-1	1	1	23	6	3	-1	-1	3
1XTE04	2754	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	18.4	-1	-1	-1	-1	-1	1	1	23	7	3	-1	-1	3
1XTE04	2755	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	8	3	-1	-1	3
80XAA04	2756	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	9	3	-1	-1	3
80XAA04	2757	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	10	3	-1	-1	3
80XAA04	2758	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	18.4	-1	-1	-1	-1	-1	1	1	23	11	3	-1	-1	3
80XAA04	2759	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	35.9	-1	-1	-1	-1	-1	1	1	23	12	3	-1	-1	3
82XAA04	2760	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	13	3	-1	-1	3
82XAA04	2761	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	14	3	-1	-1	3
82XAA04	2762	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	15	3	-1	-1	3
82XAA04	2763	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	16	3	-1	-1	3
83XAA04	2764	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	17	3	-1	-1	3
83XAA04	2765	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	18	3	-1	-1	3
83XAA04	2766	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	19	3	-1	-1	3
83XAA04	2767	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	20	3	-1	-1	3
NM6	2768	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	21	3	-1	-1	3
85XAA04	2769	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	1	4	-1	-1	4
85XAA04	2770	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	18.4	-1	-1	-1	-1	-1	1	1	23	2	4	-1	-1	4
85XAA04	2771	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	2.4	-1	-1	-1	-1	-1	1	1	23	3	4	-1	-1	4
85XAA04	2772	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0.8	-1	-1	-1	-1	-1	1	1	23	4	4	-1	-1	4
18XAG04	2773	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	5	4	-1	-1	4
18XAG04	2774	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	18.4	-1	-1	-1	-1	-1	1	1	23	6	4	-1	-1	4
18XAG04	2775	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	7	4	-1	-1	4
18XAG04	2776	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	8	4	-1	-1	4
85XAA04	2777	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	10.4	-1	-1	-1	-1	-1	1	1	23	9	4	-1	-1	4
85XAA04	2778	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	10	4	-1	-1	4
85XAA04	2779	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	3.2	-1	-1	-1	-1	-1	1	1	23	11	4	-1	-1	4
85XAA04	2780	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	4.8	-1	-1	-1	-1	-1	1	1	23	12	4	-1	-1	4
84XAA04	2781	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	13	4	-1	-1	4
84XAA04	2782	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	4	-1	-1	4
84XAA04	2783	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	25.5	-1	-1	-1	-1	-1	1	1	23	15	4	-1	-1	4
84XAA04	2784	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	16	4	-1	-1	4
82XAA04	2785	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	16.8	-1	-1	-1	-1	-1	1	1	23	17	4	-1	-1	4
82XAA04	2786	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	18	4	-1	-1	4
82XAA04	2787	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	19	4	-1	-1	4
82XAA04	2788	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	20	4	-1	-1	4
NM6	2789	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	25.5	-1	-1	-1	-1	-1	1	1	23	21	4	-1	-1	4
81XAA04	2790	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	12.8	-1	-1	-1	-1	-1	1	1	23	1	5	-1	-1	5
81XAA04	2791	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	2	5	-1	-1	5
81XAA04	2792	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	3	5	-1	-1	5
81XAA04	2793	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	43.9	-1	-1	-1	-1	-1	1	1	23	4	5	-1	-1	5
2XT4E04	2794	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	7.2	-1	-1	-1	-1	-1	1	1	23	5	5	-1	-1	5
2XT4E04	2795	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	5	-1	-1	5
2XT4E04	2796	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	7	5	-1	-1	5
2XT4E04	2797	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	7.2	-1	-1	-1	-1	-1	1	1	23	8	5	-1	-1	5
84XAA04	2798	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	9	5	-1	-1	5
84XAA04	2799	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	10	5	-1	-1	5
84XAA04	2800	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	11	5	-1	-1	5
84XAA04	2801	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	12	5	-1	-1	5
17XGA04	2802	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	11.2	-1	-1	-1	-1	-1	1	1	23	13	5	-1	-1	5
17XGA04	2803	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	14.4	-1	-1	-1	-1	-1	1	1	23	14	5	-1	-1	5
17XGA04	2804	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	15	5	-1	-1	5
17XGA04	2805	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	25.5	-1	-1	-1	-1	-1	1	1	23	16	5	-1	-1	5
85XAA04	2806	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	4	-1	-1	-1	-1	-1	1	1	23	17	5	-1	-1	5
85XAA04	2807	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	18	5	-1	-1	5
85XAA04	2808	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	8.8	-1	-1	-1	-1	-1	1	1	23	19	5	-1	-1	5
85XAA04	2809	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	3.2	-1	-1	-1	-1	-1	1	1	23	20	5	-1	-1	5
NM6	2810	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	21	5	-1	-1	5
81XAA04	2811	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	1	6	-1	-1	6
81XAA04	2812	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	2	6	-1	-1	6
81XAA04	2813	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	3	6	-1	-1	6
81XAA04	2814	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	8	-1	-1	-1	-1	-1	1	1	23	4	6	-1	-1	6
82XAA04	2815	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	5	6	-1	-1	6
82XAA04	2816	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	6	6	-1	-1	6
82XAA04	2817	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	7	6	-1	-1	6
82XAA04	2818	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	8	6	-1	-1	6
18XAG04	2819	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	8	-1	-1	-1	-1	-1	1	1	23	9	6	-1	-1	6
18XAG04	2820	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	10	6	-1	-1	6
18XAG04	2821	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	5.6	-1	-1	-1	-1	-1	1	1	23	11	6	-1	-1	6
18XAG04	2822	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	16.8	-1	-1	-1	-1	-1	1	1	23	12	6	-1	-1	6
1XTE04	2823	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	1.6	-1	-1	-1	-1	-1	1	1	23	13	6	-1	-1	6
1XTE04	2824	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	4	-1	-1	-1	-1	-1	1	1	23	14	6	-1	-1	6
1XTE04	2825	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	6	-1	-1	6
1XTE04	2826	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	10.4	-1	-1	-1	-1	-1	1	1	23	16	6	-1	-1	6
82XAA04	2827	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	17	6	-1	-1	6
82XAA04	2828	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	18	6	-1	-1	6
82XAA04	2829	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	19	6	-1	-1	6
82XAA04	2830	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	20	6	-1	-1	6
NM6	2831	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	21	6	-1	-1	6
83XAA04	2832	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	28.7	-1	-1	-1	-1	-1	1	1	23	1	7	-1	-1	7
83XAA04	2833	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	2	7	-1	-1	7
83XAA04	2834	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	3	7	-1	-1	7
83XAA04	2835	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	4	7	-1	-1	7
2XT4E04	2836	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	4	-1	-1	-1	-1	-1	1	1	23	5	7	-1	-1	7
2XT4E04	2837	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	6	7	-1	-1	7
2XT4E04	2838	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	12	-1	-1	-1	-1	-1	1	1	23	7	7	-1	-1	7
2XT4E04	2839	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	16	-1	-1	-1	-1	-1	1	1	23	8	7	-1	-1	7
17XGA04	2840	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	16	-1	-1	-1	-1	-1	1	1	23	9	7	-1	-1	7
17XGA04	2841	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	12	-1	-1	-1	-1	-1	1	1	23	10	7	-1	-1	7
17XGA04	2842	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	16.8	-1	-1	-1	-1	-1	1	1	23	11	7	-1	-1	7
17XGA04	2843	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	2.4	-1	-1	-1	-1	-1	1	1	23	12	7	-1	-1	7
83XAA04	2844	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	13	7	-1	-1	7
83XAA04	2845	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	14	7	-1	-1	7
83XAA04	2846	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	15	7	-1	-1	7
83XAA04	2847	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	16	7	-1	-1	7
81XAA04	2848	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	5.6	-1	-1	-1	-1	-1	1	1	23	17	7	-1	-1	7
81XAA04	2849	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	18	7	-1	-1	7
81XAA04	2850	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	19	7	-1	-1	7
81XAA04	2851	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	20	7	-1	-1	7
85XAA04	2852	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	12.8	-1	-1	-1	-1	-1	1	1	23	21	7	-1	-1	7
1XTE04	2853	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	8	-1	-1	-1	-1	-1	1	1	23	1	8	-1	-1	8
1XTE04	2854	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	2	8	-1	-1	8
1XTE04	2855	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	4.8	-1	-1	-1	-1	-1	1	1	23	3	8	-1	-1	8
1XTE04	2856	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	8	-1	-1	-1	-1	-1	1	1	23	4	8	-1	-1	8
18XAG04	2857	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	18.4	-1	-1	-1	-1	-1	1	1	23	5	8	-1	-1	8
18XAG04	2858	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	9.6	-1	-1	-1	-1	-1	1	1	23	6	8	-1	-1	8
18XAG04	2859	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	12	-1	-1	-1	-1	-1	1	1	23	7	8	-1	-1	8
18XAG04	2860	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	8	8	-1	-1	8
82XAA04	2861	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	9	8	-1	-1	8
82XAA04	2862	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	10	8	-1	-1	8
82XAA04	2863	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	11	8	-1	-1	8
82XAA04	2864	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	12	8	-1	-1	8
81XAA04	2865	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	13	8	-1	-1	8
81XAA04	2866	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	14	8	-1	-1	8
81XAA04	2867	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	15	8	-1	-1	8
81XAA04	2868	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	16	8	-1	-1	8
84XAA04	2869	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	17	8	-1	-1	8
84XAA04	2870	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	18	8	-1	-1	8
84XAA04	2871	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	14.4	-1	-1	-1	-1	-1	1	1	23	19	8	-1	-1	8
84XAA04	2872	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	18.4	-1	-1	-1	-1	-1	1	1	23	20	8	-1	-1	8
85XAA04	2873	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	11.2	-1	-1	-1	-1	-1	1	1	23	21	8	-1	-1	8
85XAA04	2874	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	5.6	-1	-1	-1	-1	-1	1	1	23	1	9	-1	-1	9
85XAA04	2875	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	12	-1	-1	-1	-1	-1	1	1	23	2	9	-1	-1	9
85XAA04	2876	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	1.6	-1	-1	-1	-1	-1	1	1	23	3	9	-1	-1	9
85XAA04	2877	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	4	9	-1	-1	9
80XAA04	2878	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	34.3	-1	-1	-1	-1	-1	1	1	23	5	9	-1	-1	9
80XAA04	2879	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	30.3	-1	-1	-1	-1	-1	1	1	23	6	9	-1	-1	9
80XAA04	2880	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	7	9	-1	-1	9
80XAA04	2881	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	37.5	-1	-1	-1	-1	-1	1	1	23	8	9	-1	-1	9
84XAA04	2882	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	9	9	-1	-1	9
84XAA04	2883	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	10	9	-1	-1	9
84XAA04	2884	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	16.8	-1	-1	-1	-1	-1	1	1	23	11	9	-1	-1	9
84XAA04	2885	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	11.2	-1	-1	-1	-1	-1	1	1	23	12	9	-1	-1	9
80XAA04	2886	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	13	9	-1	-1	9
80XAA04	2887	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	24.7	-1	-1	-1	-1	-1	1	1	23	14	9	-1	-1	9
80XAA04	2888	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	15	9	-1	-1	9
80XAA04	2889	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	16	9	-1	-1	9
83XAA04	2890	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	17	9	-1	-1	9
83XAA04	2891	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	18	9	-1	-1	9
83XAA04	2892	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	19	9	-1	-1	9
83XAA04	2893	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	33.5	-1	-1	-1	-1	-1	1	1	23	20	9	-1	-1	9
85XAA04	2894	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	9.6	-1	-1	-1	-1	-1	1	1	23	21	9	-1	-1	9
84XAA04	2895	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	25.5	-1	-1	-1	-1	-1	1	1	23	1	10	-1	-1	10
84XAA04	2896	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	8	-1	-1	-1	-1	-1	1	1	23	2	10	-1	-1	10
84XAA04	2897	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	18.4	-1	-1	-1	-1	-1	1	1	23	3	10	-1	-1	10
84XAA04	2898	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	29.5	-1	-1	-1	-1	-1	1	1	23	4	10	-1	-1	10
17XGA04	2899	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	22.3	-1	-1	-1	-1	-1	1	1	23	5	10	-1	-1	10
17XGA04	2900	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	6	10	-1	-1	10
17XGA04	2901	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	7	10	-1	-1	10
17XGA04	2902	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	8	10	-1	-1	10
2XT4E04	2903	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	9	10	-1	-1	10
2XT4E04	2904	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	10	10	-1	-1	10
2XT4E04	2905	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	11	10	-1	-1	10
2XT4E04	2906	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	12	10	-1	-1	10
85XAA04	2907	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	8	-1	-1	-1	-1	-1	1	1	23	13	10	-1	-1	10
85XAA04	2908	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	14	10	-1	-1	10
85XAA04	2909	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	5.6	-1	-1	-1	-1	-1	1	1	23	15	10	-1	-1	10
85XAA04	2910	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	8	-1	-1	-1	-1	-1	1	1	23	16	10	-1	-1	10
80XAA04	2911	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	17	10	-1	-1	10
80XAA04	2912	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	7.2	-1	-1	-1	-1	-1	1	1	23	18	10	-1	-1	10
80XAA04	2913	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	19	10	-1	-1	10
80XAA04	2914	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	13.6	-1	-1	-1	-1	-1	1	1	23	20	10	-1	-1	10
85XAA04	2915	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	3.2	-1	-1	-1	-1	-1	1	1	23	21	10	-1	-1	10
NM6	2916	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	1	11	-1	-1	11
NM6	2917	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	2	11	-1	-1	11
NM6	2918	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	3	11	-1	-1	11
NM6	2919	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	20.7	-1	-1	-1	-1	-1	1	1	23	4	11	-1	-1	11
NM6	2920	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	5	11	-1	-1	11
NM6	2921	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	6	11	-1	-1	11
NM6	2922	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	7	11	-1	-1	11
NM6	2923	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	38.3	-1	-1	-1	-1	-1	1	1	23	8	11	-1	-1	11
NM6	2924	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	0	-1	-1	-1	-1	-1	1	1	23	9	11	-1	-1	11
NM6	2925	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	26.3	-1	-1	-1	-1	-1	1	1	23	10	11	-1	-1	11
NM6	2926	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	11	11	-1	-1	11
NM6	2927	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	12	11	-1	-1	11
NM6	2928	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	12	-1	-1	-1	-1	-1	1	1	23	13	11	-1	-1	11
NM6	2929	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	6.4	-1	-1	-1	-1	-1	1	1	23	14	11	-1	-1	11
NM6	2930	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	16.8	-1	-1	-1	-1	-1	1	1	23	15	11	-1	-1	11
NM6	2931	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	16	11	-1	-1	11
NM6	2932	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	17	11	-1	-1	11
NM6	2933	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	25.5	-1	-1	-1	-1	-1	1	1	23	18	11	-1	-1	11
NM6	2934	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	19	11	-1	-1	11
NM6	2935	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	20	11	-1	-1	11
NM6	2936	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	12	-1	-1	-1	-1	-1	1	1	23	21	11	-1	-1	11
NM6	2937	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	24.7	-1	-1	-1	-1	-1	1	1	23	1	12	-1	-1	12
NM6	2938	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.1	-1	-1	-1	-1	-1	1	1	23	2	12	-1	-1	12
NM6	2939	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	3	12	-1	-1	12
NM6	2940	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	19.9	-1	-1	-1	-1	-1	1	1	23	4	12	-1	-1	12
NM6	2941	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.9	-1	-1	-1	-1	-1	1	1	23	5	12	-1	-1	12
NM6	2942	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	32.7	-1	-1	-1	-1	-1	1	1	23	6	12	-1	-1	12
NM6	2943	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.9	-1	-1	-1	-1	-1	1	1	23	7	12	-1	-1	12
NM6	2944	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	27.9	-1	-1	-1	-1	-1	1	1	23	8	12	-1	-1	12
NM6	2945	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	19.2	-1	-1	-1	-1	-1	1	1	23	9	12	-1	-1	12
NM6	2946	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	11.2	-1	-1	-1	-1	-1	1	1	23	10	12	-1	-1	12
NM6	2947	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	31.1	-1	-1	-1	-1	-1	1	1	23	11	12	-1	-1	12
NM6	2948	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	10.4	-1	-1	-1	-1	-1	1	1	23	12	12	-1	-1	12
NM6	2949	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	5.6	-1	-1	-1	-1	-1	1	1	23	13	12	-1	-1	12
NM6	2950	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	23.1	-1	-1	-1	-1	-1	1	1	23	14	12	-1	-1	12
NM6	2951	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	15.2	-1	-1	-1	-1	-1	1	1	23	15	12	-1	-1	12
NM6	2952	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	10.4	-1	-1	-1	-1	-1	1	1	23	16	12	-1	-1	12
NM6	2953	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	12.8	-1	-1	-1	-1	-1	1	1	23	17	12	-1	-1	12
NM6	2954	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	16	-1	-1	-1	-1	-1	1	1	23	18	12	-1	-1	12
NM6	2955	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	12.8	-1	-1	-1	-1	-1	1	1	23	19	12	-1	-1	12
NM6	2956	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	21.5	-1	-1	-1	-1	-1	1	1	23	20	12	-1	-1	12
NM6	2957	MI aspen field trial	-1	1	-1	2005-05-15	2008-10-10	1-0 	45	-1	-1	U	-1	17.6	-1	-1	-1	-1	-1	1	1	23	21	12	-1	-1	12
\.


--
-- Name: test_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('test_detail_id_seq', 1, false);


--
-- Data for Name: test_spec; Type: TABLE DATA; Schema: public; Owner: user
--

COPY test_spec (test_spec_key, id, notes, activity_type, test_type, research_hypothesis, null_hypothesis, reject_null_hypothesis, web_protocol, web_url, web_photos, test_start_date, id_site) FROM stdin;
TBD	1	To Be Determined	0	0	0	0	0	0	0	0	1111-11-11	1
NA	2	Does Not Apply	0	0	0	0	0	0	0	0	1111-11-11	2
2008-bell-nursery	3	2008-bell-nursery results	EVENT	nursery	The control clones indicate that the nursery results are consistent.	The control clones indicate that the nursery results are NOT consistent.	0	0	0	0	2008-04-04	3
2008-costa-nursery	4	2008-costa-nursery results	EVENT	nursery	The control clones indicate that the nursery results are consistent.	The control clones indicate that the nursery results are NOT consistent.	0	0	0	0	2008-04-04	4
2009-bell-nursery	5	2009-bell-nursery results	EVENT	nursery	The control clones indicate that the nursery results are consistent.	The control clones indicate that the nursery results are NOT consistent.	0	0	0	0	2009-04-04	3
2009-costa-nursery	6	2009-costa-nursery results	EVENT	nursery	The control clones indicate that the nursery results are consistent.	The control clones indicate that the nursery results are NOT consistent.	0	0	0	0	2009-04-04	4
2010-bell-nursery	7	2010-bell-nursery results	EVENT	nursery	The control clones indicate that the nursery results are consistent.	The control clones indicate that the nursery results are NOT consistent.	0	0	0	0	2010-03-25	3
2010-dykema-nursery	8	2010-dykema-nursery results	EVENT	nursery	The control clones indicate that the nursery results are consistent.	The control clones indicate that the nursery results are NOT consistent.	0	0	0	0	2010-03-25	5
2011-bell-nursery	13	2011-bell-nursery	EVENT	nursery	The control clones indicate that the nursery results are consistent.	The control clones indicate that the nursery results are NOT consistent.	0	0	0	0	2011-04-08	3
2012-bell-nursery	14	2012-bell-nursery	EVENT	nursery	The control clones indicate that the nursery results are consistent.	The control clones indicate that the nursery results are NOT consistent.	0	0	0	0	2012-04-06	3
2012-2xCAG12-Cross	15	2012-2xCAG12-Cross	EVENT	breeding	The 2xCAG12 cross will have selections that yield more biomass than CAG204, root from cuttings, have straighter form and be fertile or infertile.	0	0	0	0	0	2012-02-12	3
2011-1xCAGW-Cross	16	2011-1xCAGW-Cross	EVENT	breeding	The 1xCAGW cross will have similar aspen to alba like seedling ratios as the CAG204 x AE42 cross.	0	0	0	0	0	2012-03-14	3
2011-RNE-PolePlanting	17	2011-RNE-PolePlanting	TRIAL	field-planting	The rootable aspen materials may have similar survival rates as poles planted on good field sites as the same stock in nursery as with 6 cuttings.	0	0	0	0	0	2011-11-05	7
WASP-2013-A	18	WASP-2013-A	TRIAL	propagation	The Willow and Water Soak treatments will show an increase in rooting compared to the No Soak control.	0	0	0	0	0	2013-01-12	6
2013-breeding	19	2013-breeding	EVENT	breeding	The 2013 aspen crosses will meet the expectations set within the POC breeding strategy.	0	0	0	0	0	2013-03-19	6
2013-bell-nursery	20	2013-bell-nursery	EVENT	nursery	The control clones indicate that the nursery results are consistent.	The control clones indicate that the nursery results are NOT consistent.	0	0	0	0	2013-04-20	3
2014-breeding	21	2014-breeding	EVENT	breeding	The 2014 aspen crosses will meet the expectations set within the POC breeding strategy.	0	0	0	0	0	2014-03-19	6
2014-bell-nursery	22	2014-bell-nursery	EVENT	nursery	The control clones indicate that the nursery results are consistent.	The control clones indicate that the nursery results are NOT consistent.	0	0	0	0	2014-04-20	3
2005-MI-FieldTrial	23	2005-MI-FieldTrial	TRIAL	field-trial	0	0	0	0	0	0	2005-05-15	8
\.


--
-- Name: test_spec_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('test_spec_id_seq', 1, false);


--
-- Name: family_family_key_key; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY family
    ADD CONSTRAINT family_family_key_key UNIQUE (family_key);


--
-- Name: family_pk; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY family
    ADD CONSTRAINT family_pk PRIMARY KEY (id);


--
-- Name: journal_pk; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY journal
    ADD CONSTRAINT journal_pk PRIMARY KEY (id);


--
-- Name: pedigree_path_key; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY pedigree
    ADD CONSTRAINT pedigree_path_key UNIQUE (path);


--
-- Name: plant_pk; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY plant
    ADD CONSTRAINT plant_pk PRIMARY KEY (id);


--
-- Name: plant_plant_key_key; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY plant
    ADD CONSTRAINT plant_plant_key_key UNIQUE (plant_key);


--
-- Name: site_location_code_key; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_location_code_key UNIQUE (location_code);


--
-- Name: site_pk; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_pk PRIMARY KEY (id);


--
-- Name: site_site_key_key; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY site
    ADD CONSTRAINT site_site_key_key UNIQUE (site_key);


--
-- Name: taxa_pk; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY taxa
    ADD CONSTRAINT taxa_pk PRIMARY KEY (id);


--
-- Name: taxa_taxa_key_key; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY taxa
    ADD CONSTRAINT taxa_taxa_key_key UNIQUE (taxa_key);


--
-- Name: test_detail_pk; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY test_detail
    ADD CONSTRAINT test_detail_pk PRIMARY KEY (id);


--
-- Name: test_spec_pk; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY test_spec
    ADD CONSTRAINT test_spec_pk PRIMARY KEY (id);


--
-- Name: test_spec_test_spec_key_key; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY test_spec
    ADD CONSTRAINT test_spec_test_spec_key_key UNIQUE (test_spec_key);


--
-- Name: family_id_taxa_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY family
    ADD CONSTRAINT family_id_taxa_fk FOREIGN KEY (id_taxa) REFERENCES taxa(id);


--
-- Name: journal_id_family_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY journal
    ADD CONSTRAINT journal_id_family_fk FOREIGN KEY (id_plant) REFERENCES plant(id);


--
-- Name: journal_id_plant_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY journal
    ADD CONSTRAINT journal_id_plant_fk FOREIGN KEY (id_family) REFERENCES family(id);


--
-- Name: journal_id_site_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY journal
    ADD CONSTRAINT journal_id_site_fk FOREIGN KEY (id_site) REFERENCES site(id);


--
-- Name: journal_id_test_spec_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY journal
    ADD CONSTRAINT journal_id_test_spec_fk FOREIGN KEY (id_test_spec) REFERENCES test_spec(id);


--
-- Name: plant_id_family_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY plant
    ADD CONSTRAINT plant_id_family_fk FOREIGN KEY (id_family) REFERENCES family(id);


--
-- Name: plant_id_taxa_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY plant
    ADD CONSTRAINT plant_id_taxa_fk FOREIGN KEY (id_taxa) REFERENCES taxa(id);


--
-- Name: test_detail_id_family_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY test_detail
    ADD CONSTRAINT test_detail_id_family_fk FOREIGN KEY (id_plant) REFERENCES plant(id);


--
-- Name: test_detail_id_plant_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY test_detail
    ADD CONSTRAINT test_detail_id_plant_fk FOREIGN KEY (id_family) REFERENCES family(id);


--
-- Name: test_detail_id_test_spec_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY test_detail
    ADD CONSTRAINT test_detail_id_test_spec_fk FOREIGN KEY (id_test_spec) REFERENCES test_spec(id);


--
-- Name: test_spec_id_site_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY test_spec
    ADD CONSTRAINT test_spec_id_site_fk FOREIGN KEY (id_site) REFERENCES site(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

