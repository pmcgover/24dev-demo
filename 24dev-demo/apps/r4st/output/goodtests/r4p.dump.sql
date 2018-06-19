--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.7
-- Dumped by pg_dump version 9.5.7

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
    seed_germ_percent numeric DEFAULT '-1'::numeric NOT NULL,
    seed_germ_date date DEFAULT '1111-11-11'::date NOT NULL,
    cross_date date DEFAULT '1111-11-11'::date NOT NULL,
    project_phase numeric DEFAULT '-1'::numeric NOT NULL,
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
    ploidy_n integer DEFAULT '-1'::integer NOT NULL,
    date_aquired date DEFAULT '1111-11-11'::date NOT NULL,
    alba_class character varying(3) DEFAULT 'U'::character varying NOT NULL,
    id_taxa integer NOT NULL,
    id_family integer NOT NULL,
    web_photos character varying DEFAULT '0'::character varying NOT NULL,
    web_url character varying DEFAULT '0'::character varying NOT NULL,
    CONSTRAINT plant_alba_class_check CHECK (((alba_class)::text = ANY ((ARRAY['U'::character varying, 'A'::character varying, 'AH'::character varying, 'ASH'::character varying, 'ASA'::character varying, 'ASO'::character varying, 'H'::character varying, 'C'::character varying])::text[]))),
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
    f.seed_germ_percent,
    f.seed_germ_date,
    f.cross_date,
    f.project_phase,
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
-- Name: avw_family_phase_seed_germ_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avw_family_phase_seed_germ_summary AS
 SELECT f.project_phase,
    count(f.*) AS number_of_families_per_project_phase,
    count(DISTINCT f.female_parent) AS count_unique_female_parents,
    count(DISTINCT f.male_parent) AS count_unique_male_parents,
    count(DISTINCT f.taxa_key) AS count_unique_taxa_species,
    trunc(avg(f.seed_germ_percent), 2) AS avg_seed_germ_percent
   FROM avw_family f
  WHERE (f.seed_germ_percent > ('-1'::integer)::numeric)
  GROUP BY f.project_phase
  ORDER BY f.project_phase;


ALTER TABLE avw_family_phase_seed_germ_summary OWNER TO "user";

--
-- Name: avw_family_phase_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avw_family_phase_summary AS
 SELECT f.project_phase,
    count(f.*) AS number_of_families_per_project_phase,
    count(DISTINCT f.female_parent) AS count_unique_female_parents,
    count(DISTINCT f.male_parent) AS count_unique_male_parents,
    count(DISTINCT f.taxa_key) AS count_unique_taxa_species,
    sum(pt.is_plus_family) AS sum_of_plus_trees
   FROM avw_family f,
    ( SELECT avw_family.family_key,
            avw_family.id,
                CASE
                    WHEN (avw_family.is_plus = 'Y'::bpchar) THEN 1
                    WHEN (avw_family.is_plus = 'N'::bpchar) THEN 0
                    ELSE 0
                END AS is_plus_family
           FROM avw_family) pt
  WHERE ((f.project_phase <> ('-1'::integer)::numeric) AND ((f.family_key)::text = (pt.family_key)::text) AND (f.id = pt.id))
  GROUP BY f.project_phase
  ORDER BY f.project_phase;


ALTER TABLE avw_family_phase_summary OWNER TO "user";

--
-- Name: field_trial; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE field_trial (
    field_trial_key character varying(50) DEFAULT '0'::character varying NOT NULL,
    id integer NOT NULL,
    notes character varying DEFAULT '0'::character varying NOT NULL,
    notes2 character varying DEFAULT '0'::character varying NOT NULL,
    notes3 character varying DEFAULT '0'::character varying NOT NULL,
    planted_order numeric DEFAULT '-1'::numeric NOT NULL,
    live_quantity numeric DEFAULT '-1'::numeric NOT NULL,
    is_plus_ynu character(1) DEFAULT '0'::bpchar,
    live_dbh_cm numeric DEFAULT '-1'::numeric NOT NULL,
    live_height_cm numeric DEFAULT '-1'::numeric NOT NULL,
    leaf_score integer DEFAULT '-1'::integer NOT NULL,
    canker_score integer DEFAULT '-1'::integer NOT NULL,
    tree_spacing_ft character(4) DEFAULT 'U'::bpchar NOT NULL,
    row_nbr numeric DEFAULT '-1'::numeric NOT NULL,
    column_nbr numeric DEFAULT '-1'::numeric NOT NULL,
    replication_nbr integer DEFAULT '-1'::integer NOT NULL,
    plot_nbr integer DEFAULT '-1'::integer NOT NULL,
    block_nbr integer DEFAULT '-1'::integer NOT NULL,
    id_test_spec integer NOT NULL,
    id_site integer NOT NULL,
    CONSTRAINT field_trial_canker_score_check CHECK ((canker_score < 6)),
    CONSTRAINT field_trial_is_plus_ynu_check CHECK ((is_plus_ynu = ANY (ARRAY['Y'::bpchar, 'N'::bpchar, 'U'::bpchar, '0'::bpchar]))),
    CONSTRAINT field_trial_leaf_score_check CHECK ((leaf_score < 6)),
    CONSTRAINT field_trial_tree_spacing_ft_check CHECK ((tree_spacing_ft = ANY (ARRAY['U'::bpchar, 'NA'::bpchar, 'MIX'::bpchar, '4x4'::bpchar, '4x6'::bpchar, '8x7'::bpchar, '8x8'::bpchar, '9x9'::bpchar, '8x10'::bpchar])))
);


ALTER TABLE field_trial OWNER TO "user";

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
    stock_type character(6) DEFAULT 'U'::bpchar NOT NULL,
    stock_length_cm numeric DEFAULT '-1'::numeric NOT NULL,
    stock_collar_dia_mm numeric DEFAULT '-1'::numeric NOT NULL,
    research_hypothesis character varying DEFAULT '0'::character varying NOT NULL,
    web_protocol character varying DEFAULT '0'::character varying NOT NULL,
    web_url character varying DEFAULT '0'::character varying NOT NULL,
    web_photos character varying DEFAULT '0'::character varying NOT NULL,
    test_start_date date DEFAULT '1111-11-11'::date NOT NULL,
    id_site integer NOT NULL,
    CONSTRAINT test_spec_activity_type_check CHECK (((activity_type)::text = ANY ((ARRAY['0'::character varying, 'TRIAL'::character varying, 'EVENT'::character varying])::text[]))),
    CONSTRAINT test_spec_stock_type_check CHECK ((stock_type = ANY (ARRAY['U'::bpchar, 'NA'::bpchar, 'MIX'::bpchar, 'WHIP'::bpchar, 'WASP'::bpchar, 'DC'::bpchar, 'MS'::bpchar, 'SEL'::bpchar, '1-0'::bpchar, '1-1'::bpchar, '1-2'::bpchar]))),
    CONSTRAINT test_spec_test_type_check CHECK (((test_type)::text = ANY ((ARRAY['0'::character varying, 'nursery'::character varying, 'breeding'::character varying, 'propagation'::character varying, 'archive-planting'::character varying, 'family-trial'::character varying, 'clonal-trial'::character varying, 'gpft'::character varying])::text[])))
);


ALTER TABLE test_spec OWNER TO "user";

--
-- Name: avw_field_trial; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avw_field_trial AS
 SELECT ft.field_trial_key,
    ft.id,
    ft.notes,
    ft.notes2,
    ft.notes3,
    ft.planted_order,
    ft.live_quantity,
    ft.is_plus_ynu,
    ft.live_dbh_cm,
    ft.live_height_cm,
    ft.leaf_score,
    ft.canker_score,
    ts.test_type,
    ts.stock_type,
    ts.stock_length_cm,
    ts.stock_collar_dia_mm,
    ft.tree_spacing_ft,
    ft.row_nbr,
    ft.column_nbr,
    ft.replication_nbr,
    ft.plot_nbr,
    ft.block_nbr,
    ts.test_spec_key,
    s.site_key,
    ft.id_test_spec,
    ft.id_site
   FROM field_trial ft,
    test_spec ts,
    site s
  WHERE ((ft.id_test_spec = ts.id) AND (ft.id_site = s.id));


ALTER TABLE avw_field_trial OWNER TO "user";

--
-- Name: split_wood_tests; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE split_wood_tests (
    swt_key character varying(50) DEFAULT '0'::character varying NOT NULL,
    id integer NOT NULL,
    notes character varying DEFAULT '0'::character varying NOT NULL,
    notes2 character varying DEFAULT '0'::character varying NOT NULL,
    cutting_order numeric DEFAULT '-1'::numeric NOT NULL,
    stem_dia_small_end_mm numeric DEFAULT '-1'::numeric NOT NULL,
    length_of_split_in numeric DEFAULT '-1'::numeric NOT NULL,
    grain_pull_force_lb numeric DEFAULT '-1'::numeric NOT NULL,
    undulation_level integer DEFAULT '-1'::integer NOT NULL,
    gpf_test_set character(1) DEFAULT 'N'::bpchar NOT NULL,
    replication_nbr integer DEFAULT '-1'::integer NOT NULL,
    id_test_spec integer NOT NULL,
    CONSTRAINT split_wood_tests_gpf_test_set_check CHECK ((gpf_test_set = ANY (ARRAY['Y'::bpchar, 'N'::bpchar]))),
    CONSTRAINT split_wood_tests_undulation_level_check CHECK ((undulation_level < 4))
);


ALTER TABLE split_wood_tests OWNER TO "user";

--
-- Name: avw_gpf_split_wood_tests; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avw_gpf_split_wood_tests AS
 SELECT s.swt_key,
    s.id,
    s.notes,
    s.notes2,
    s.cutting_order,
    s.stem_dia_small_end_mm,
    s.length_of_split_in,
    s.grain_pull_force_lb,
    s.undulation_level,
    s.gpf_test_set,
    s.replication_nbr,
    s.id_test_spec,
    ts.test_spec_key
   FROM split_wood_tests s,
    test_spec ts
  WHERE ((s.id_test_spec = ts.id) AND (s.gpf_test_set = 'Y'::bpchar));


ALTER TABLE avw_gpf_split_wood_tests OWNER TO "user";

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
    p.alba_class,
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
    notes3 character varying DEFAULT '0'::character varying NOT NULL,
    planted_order numeric DEFAULT '-1'::numeric NOT NULL,
    selection_type character(1) DEFAULT 'U'::bpchar NOT NULL,
    start_quantity numeric DEFAULT '-1'::numeric NOT NULL,
    end_quantity numeric DEFAULT '-1'::numeric NOT NULL,
    this_start_date date DEFAULT '1111-11-11'::date NOT NULL,
    score_date date DEFAULT '1111-11-11'::date NOT NULL,
    stock_type character(6) DEFAULT 'U'::bpchar NOT NULL,
    stock_length_cm numeric DEFAULT '-1'::numeric NOT NULL,
    stock_dia_mm numeric DEFAULT '-1'::numeric NOT NULL,
    is_plus_ynu character(1) DEFAULT '0'::bpchar,
    collar_median_dia_mm numeric DEFAULT '-1'::numeric NOT NULL,
    collar_1_1_median_dia numeric DEFAULT '-1'::numeric NOT NULL,
    stool_collar_median_dia_mm numeric DEFAULT '-1'::numeric NOT NULL,
    field_cuttings_ft numeric DEFAULT '-1'::numeric NOT NULL,
    height_cm numeric DEFAULT '-1'::numeric NOT NULL,
    leaf_score integer DEFAULT '-1'::integer NOT NULL,
    id_test_spec integer NOT NULL,
    row_nbr numeric DEFAULT '-1'::numeric NOT NULL,
    column_nbr numeric DEFAULT '-1'::numeric NOT NULL,
    replication_nbr integer DEFAULT '-1'::integer NOT NULL,
    plot_nbr integer DEFAULT '-1'::integer NOT NULL,
    block_nbr integer DEFAULT '-1'::integer NOT NULL,
    CONSTRAINT test_detail_is_plus_ynu_check CHECK ((is_plus_ynu = ANY (ARRAY['Y'::bpchar, 'N'::bpchar, 'U'::bpchar, '0'::bpchar]))),
    CONSTRAINT test_detail_leaf_score_check CHECK ((leaf_score < 6)),
    CONSTRAINT test_detail_selection_type_check CHECK ((selection_type = ANY (ARRAY['U'::bpchar, 'P'::bpchar, 'S'::bpchar, 'T'::bpchar, 'F'::bpchar, 'R'::bpchar, 'D'::bpchar]))),
    CONSTRAINT test_detail_stock_type_check CHECK ((stock_type = ANY (ARRAY['U'::bpchar, 'ASP'::bpchar, 'SASP'::bpchar, 'WASP'::bpchar, 'DC'::bpchar, 'ODC'::bpchar, 'FDC'::bpchar, 'MS'::bpchar, 'RS'::bpchar, 'RTL'::bpchar, 'SEL'::bpchar, '1-0'::bpchar, '1-1'::bpchar])))
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
    td.notes3,
    td.planted_order,
    td.selection_type,
    td.start_quantity,
    td.end_quantity,
    td.this_start_date,
    td.score_date,
    td.stock_type,
    td.stock_length_cm,
    td.stock_dia_mm,
    td.is_plus_ynu,
    td.collar_median_dia_mm,
    td.stool_collar_median_dia_mm,
    td.field_cuttings_ft,
    td.height_cm,
    td.leaf_score,
    ts.test_spec_key,
    td.row_nbr,
    td.column_nbr,
    td.replication_nbr,
    td.plot_nbr,
    td.block_nbr
   FROM test_detail td,
    test_spec ts
  WHERE (td.id_test_spec = ts.id);


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
    ts.stock_type,
    ts.stock_length_cm,
    ts.stock_collar_dia_mm,
    ts.research_hypothesis,
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
-- Name: avx_female_parent_germination_rates; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avx_female_parent_germination_rates AS
 SELECT f.female_parent,
    count(f.female_parent) AS count_of_this_female,
    trunc(avg(f.seed_germ_percent), 2) AS avg_seed_germ_percent_females,
    trunc(max(f.seed_germ_percent), 2) AS max_seed_germ_percent_females,
    trunc(min(f.seed_germ_percent), 2) AS min_seed_germ_percent_females,
    p.alba_class,
    min(p.is_plus) AS is_plus,
    min(p.is_from_wild) AS is_from_wild
   FROM avw_family f,
    ( SELECT plant.plant_key,
            plant.alba_class,
            plant.is_plus,
            plant.is_from_wild
           FROM plant
          WHERE (plant.id <> ALL (ARRAY[1, 2]))) p
  WHERE ((f.seed_germ_percent > ('-1'::integer)::numeric) AND ((f.female_parent)::text = (p.plant_key)::text) AND (f.id <> ALL (ARRAY[1, 2])))
  GROUP BY f.female_parent, p.alba_class
  ORDER BY (trunc(avg(f.seed_germ_percent), 2)) DESC;


ALTER TABLE avx_female_parent_germination_rates OWNER TO "user";

--
-- Name: avx_female_parent_germination_rate_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avx_female_parent_germination_rate_summary AS
 SELECT avx_female_parent_germination_rates.alba_class AS alba_class_female,
        CASE
            WHEN ((avx_female_parent_germination_rates.alba_class)::text = 'U'::text) THEN 'Unknown, like Unknown female parentage'::text
            WHEN ((avx_female_parent_germination_rates.alba_class)::text = 'A'::text) THEN 'Alba, 100% P. alba'::text
            WHEN ((avx_female_parent_germination_rates.alba_class)::text = 'H'::text) THEN 'Hybrid, with 50% P. alba'::text
            WHEN ((avx_female_parent_germination_rates.alba_class)::text = 'AH'::text) THEN 'Alba Hybrid, with > 50% P. alba'::text
            WHEN ((avx_female_parent_germination_rates.alba_class)::text = 'ASH'::text) THEN 'Aspen Hybrid, with < 50% P. alba'::text
            WHEN ((avx_female_parent_germination_rates.alba_class)::text = 'ASA'::text) THEN 'Aspen American, native American aspen'::text
            WHEN ((avx_female_parent_germination_rates.alba_class)::text = 'ASO'::text) THEN 'Aspen Other, with 0% P. alba, (eg, P. tremula)'::text
            WHEN ((avx_female_parent_germination_rates.alba_class)::text = 'C'::text) THEN 'Control, with 0% P. alba'::text
            ELSE 'NA'::text
        END AS alba_class_female_descriptions,
    count(avx_female_parent_germination_rates.count_of_this_female) AS number_of_unique_females,
    sum(avx_female_parent_germination_rates.count_of_this_female) AS sum_of_females,
    trunc(avg(avx_female_parent_germination_rates.avg_seed_germ_percent_females), 2) AS avg_seed_germ_female_parents,
    max(avx_female_parent_germination_rates.max_seed_germ_percent_females) AS max_germ_female_parents,
    min(avx_female_parent_germination_rates.min_seed_germ_percent_females) AS min_germ_female_parents
   FROM avx_female_parent_germination_rates
  GROUP BY avx_female_parent_germination_rates.alba_class
  ORDER BY (trunc(avg(avx_female_parent_germination_rates.avg_seed_germ_percent_females), 2)) DESC;


ALTER TABLE avx_female_parent_germination_rate_summary OWNER TO "user";

--
-- Name: avx_male_parent_germination_rates; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avx_male_parent_germination_rates AS
 SELECT f.male_parent,
    count(f.male_parent) AS count_of_this_male,
    trunc(avg(f.seed_germ_percent), 2) AS avg_seed_germ_percent_males,
    trunc(max(f.seed_germ_percent), 2) AS max_seed_germ_percent_males,
    trunc(min(f.seed_germ_percent), 2) AS min_seed_germ_percent_males,
    p.alba_class,
    min(p.is_plus) AS is_plus,
    min(p.is_from_wild) AS is_from_wild
   FROM avw_family f,
    ( SELECT plant.plant_key,
            plant.alba_class,
            plant.is_plus,
            plant.is_from_wild
           FROM plant
          WHERE (plant.id <> ALL (ARRAY[1, 2]))) p
  WHERE ((f.seed_germ_percent > ('-1'::integer)::numeric) AND ((f.male_parent)::text = (p.plant_key)::text) AND (f.id <> ALL (ARRAY[1, 2])))
  GROUP BY f.male_parent, p.alba_class
  ORDER BY (trunc(avg(f.seed_germ_percent), 2)) DESC;


ALTER TABLE avx_male_parent_germination_rates OWNER TO "user";

--
-- Name: avx_male_parent_germination_rate_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW avx_male_parent_germination_rate_summary AS
 SELECT avx_male_parent_germination_rates.alba_class AS alba_class_male,
        CASE
            WHEN ((avx_male_parent_germination_rates.alba_class)::text = 'U'::text) THEN 'Unknown, like Open Pollinated or Undetermined'::text
            WHEN ((avx_male_parent_germination_rates.alba_class)::text = 'A'::text) THEN 'Alba, 100% P. alba'::text
            WHEN ((avx_male_parent_germination_rates.alba_class)::text = 'H'::text) THEN 'Hybrid, with 50% P. alba'::text
            WHEN ((avx_male_parent_germination_rates.alba_class)::text = 'AH'::text) THEN 'Alba Hybrid, with > 50% P. alba'::text
            WHEN ((avx_male_parent_germination_rates.alba_class)::text = 'ASH'::text) THEN 'Aspen Hybrid, with < 50% P. alba'::text
            WHEN ((avx_male_parent_germination_rates.alba_class)::text = 'ASA'::text) THEN 'Aspen American, native American aspen'::text
            WHEN ((avx_male_parent_germination_rates.alba_class)::text = 'ASO'::text) THEN 'Aspen Other, with 0% P. alba, (eg, P. tremula)'::text
            WHEN ((avx_male_parent_germination_rates.alba_class)::text = 'C'::text) THEN 'Control, with 0% P. alba'::text
            ELSE 'NA'::text
        END AS alba_class_male_descriptions,
    count(avx_male_parent_germination_rates.count_of_this_male) AS number_of_unique_males,
    sum(avx_male_parent_germination_rates.count_of_this_male) AS sum_of_males,
    trunc(avg(avx_male_parent_germination_rates.avg_seed_germ_percent_males), 2) AS avg_seed_germ_male_parents,
    max(avx_male_parent_germination_rates.max_seed_germ_percent_males) AS max_germ_male_parents,
    min(avx_male_parent_germination_rates.min_seed_germ_percent_males) AS min_germ_male_parents
   FROM avx_male_parent_germination_rates
  GROUP BY avx_male_parent_germination_rates.alba_class
  ORDER BY (trunc(avg(avx_male_parent_germination_rates.avg_seed_germ_percent_males), 2)) DESC;


ALTER TABLE avx_male_parent_germination_rate_summary OWNER TO "user";

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
-- Name: field_trial_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE field_trial_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE field_trial_id_seq OWNER TO "user";

--
-- Name: field_trial_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE field_trial_id_seq OWNED BY field_trial.id;


--
-- Name: gpf1_split_wood_tests_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW gpf1_split_wood_tests_summary AS
 SELECT avw_gpf_split_wood_tests.swt_key,
    count(avw_gpf_split_wood_tests.replication_nbr) AS count_of_replications,
    min(avw_gpf_split_wood_tests.stem_dia_small_end_mm) AS min_stem_dia_small_end_mm,
    max(avw_gpf_split_wood_tests.stem_dia_small_end_mm) AS max_stem_dia_small_end_mm,
    trunc(avg(avw_gpf_split_wood_tests.stem_dia_small_end_mm), 2) AS avg_stem_dia_small_end_mm,
    trunc(avg(avw_gpf_split_wood_tests.length_of_split_in), 2) AS avg_length_of_split_in,
    min(avw_gpf_split_wood_tests.grain_pull_force_lb) AS min_grain_pull_force_lb,
    max(avw_gpf_split_wood_tests.grain_pull_force_lb) AS max_grain_pull_force_lb,
    trunc(stddev_samp(avw_gpf_split_wood_tests.grain_pull_force_lb), 2) AS sample_stdev_grain_pull_force_lb,
    trunc(avg(avw_gpf_split_wood_tests.grain_pull_force_lb), 2) AS avg_grain_pull_force_lb,
    trunc(avg(avw_gpf_split_wood_tests.undulation_level), 2) AS avg_undulation_level,
    max(avw_gpf_split_wood_tests.undulation_level) AS max_undulation_level,
    trunc((avg(avw_gpf_split_wood_tests.stem_dia_small_end_mm) / avg(avw_gpf_split_wood_tests.grain_pull_force_lb)), 2) AS diameter_per_pound
   FROM avw_gpf_split_wood_tests
  GROUP BY avw_gpf_split_wood_tests.swt_key, avw_gpf_split_wood_tests.replication_nbr
  ORDER BY avw_gpf_split_wood_tests.swt_key, avw_gpf_split_wood_tests.replication_nbr;


ALTER TABLE gpf1_split_wood_tests_summary OWNER TO "user";

--
-- Name: gpf2_split_wood_tests_undulation; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW gpf2_split_wood_tests_undulation AS
 SELECT count(gpf1_split_wood_tests_summary.swt_key) AS count_of_undulation_samples,
    count(DISTINCT gpf1_split_wood_tests_summary.swt_key) AS count_of_undulation_clones,
    trunc(avg(gpf1_split_wood_tests_summary.avg_stem_dia_small_end_mm), 2) AS avg_stem_dia_small_end_mm,
    trunc(avg(gpf1_split_wood_tests_summary.avg_length_of_split_in), 2) AS avg_length_of_split_in,
    trunc(avg(gpf1_split_wood_tests_summary.avg_grain_pull_force_lb), 2) AS avg_grain_pull_force_lb,
    trunc(avg(gpf1_split_wood_tests_summary.sample_stdev_grain_pull_force_lb), 2) AS avg_sample_stdev_grain_pull_force_lb,
    trunc(avg(gpf1_split_wood_tests_summary.diameter_per_pound), 2) AS diameter_per_pound,
    trunc(avg(gpf1_split_wood_tests_summary.avg_undulation_level), 2) AS avg_undulation_level
   FROM gpf1_split_wood_tests_summary
  GROUP BY gpf1_split_wood_tests_summary.avg_undulation_level
  ORDER BY (trunc(avg(gpf1_split_wood_tests_summary.avg_undulation_level), 2)) DESC;


ALTER TABLE gpf2_split_wood_tests_undulation OWNER TO "user";

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
-- Name: split_wood_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE split_wood_tests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE split_wood_tests_id_seq OWNER TO "user";

--
-- Name: split_wood_tests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE split_wood_tests_id_seq OWNED BY split_wood_tests.id;


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
-- Name: u07m_2013; Type: TABLE; Schema: public; Owner: user
--

CREATE TABLE u07m_2013 (
    id integer NOT NULL,
    dbh numeric NOT NULL,
    dbh_rank integer NOT NULL,
    name character varying NOT NULL,
    area_index numeric NOT NULL,
    sum_dbh_ratio2_cd numeric NOT NULL,
    sdbh_x_cavg numeric NOT NULL
);


ALTER TABLE u07m_2013 OWNER TO "user";

--
-- Name: u07m_2013_id_seq; Type: SEQUENCE; Schema: public; Owner: user
--

CREATE SEQUENCE u07m_2013_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE u07m_2013_id_seq OWNER TO "user";

--
-- Name: u07m_2013_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: user
--

ALTER SEQUENCE u07m_2013_id_seq OWNED BY u07m_2013.id;


--
-- Name: v1_field_trial_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW v1_field_trial_summary AS
 SELECT ft.field_trial_key,
    ft.test_spec_key,
    ft.site_key,
    ft.id_test_spec,
    ft.id_site,
    ft.replication_nbr,
    ft.block_nbr,
    sum(ft.live_quantity) AS sum_live_quantity,
    sum(pt.is_plus_tree) AS sum_plus_trees,
    trunc(avg(ft.live_dbh_cm), 2) AS avg_dbh_cm,
    trunc(avg(ft.leaf_score), 2) AS avg_leaf_score,
    trunc(((((sum(pt.is_plus_tree))::numeric * 0.3) + (avg(ft.live_dbh_cm) * 0.5)) + (avg(ft.leaf_score) * 0.2)), 2) AS sum_plus_dbh_leafscore
   FROM avw_field_trial ft,
    ( SELECT field_trial.field_trial_key,
            field_trial.id,
                CASE
                    WHEN (field_trial.is_plus_ynu = 'Y'::bpchar) THEN 1
                    WHEN (field_trial.is_plus_ynu = 'N'::bpchar) THEN '-1'::integer
                    ELSE 0
                END AS is_plus_tree
           FROM field_trial) pt
  WHERE (((ft.field_trial_key)::text = (pt.field_trial_key)::text) AND (ft.id = pt.id))
  GROUP BY ft.field_trial_key, ft.test_spec_key, ft.site_key, ft.replication_nbr, ft.block_nbr, ft.id_test_spec, ft.id_site
  ORDER BY (trunc(((((sum(pt.is_plus_tree))::numeric * 0.3) + (avg(ft.live_dbh_cm) * 0.5)) + (avg(ft.leaf_score) * 0.2)), 2)) DESC;


ALTER TABLE v1_field_trial_summary OWNER TO "user";

--
-- Name: v2_field_trial_2016_planting; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW v2_field_trial_2016_planting AS
 SELECT v1_field_trial_summary.field_trial_key,
    v1_field_trial_summary.sum_live_quantity,
    v1_field_trial_summary.sum_plus_trees,
    v1_field_trial_summary.avg_dbh_cm,
    v1_field_trial_summary.avg_leaf_score,
    v1_field_trial_summary.sum_plus_dbh_leafscore,
    dense_rank() OVER (ORDER BY v1_field_trial_summary.sum_plus_dbh_leafscore DESC) AS ranked_score_16,
    v1_field_trial_summary.replication_nbr,
    v1_field_trial_summary.test_spec_key
   FROM v1_field_trial_summary
  WHERE (((v1_field_trial_summary.test_spec_key)::text = '2017-PostNE-West-Measured'::text) AND (v1_field_trial_summary.block_nbr = 1))
  ORDER BY v1_field_trial_summary.sum_plus_dbh_leafscore DESC;


ALTER TABLE v2_field_trial_2016_planting OWNER TO "user";

--
-- Name: v3_field_trial_2017_planting; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW v3_field_trial_2017_planting AS
 SELECT v1_field_trial_summary.field_trial_key,
    v1_field_trial_summary.sum_live_quantity,
    v1_field_trial_summary.sum_plus_trees,
    v1_field_trial_summary.avg_dbh_cm,
    v1_field_trial_summary.avg_leaf_score,
    v1_field_trial_summary.sum_plus_dbh_leafscore,
    dense_rank() OVER (ORDER BY v1_field_trial_summary.sum_plus_dbh_leafscore DESC) AS ranked_score_17,
    v1_field_trial_summary.replication_nbr,
    v1_field_trial_summary.test_spec_key
   FROM v1_field_trial_summary
  WHERE (((v1_field_trial_summary.test_spec_key)::text = '2017-PostNE-West-Measured'::text) AND (v1_field_trial_summary.block_nbr = 2))
  ORDER BY v1_field_trial_summary.sum_plus_dbh_leafscore DESC;


ALTER TABLE v3_field_trial_2017_planting OWNER TO "user";

--
-- Name: v4_field_trial_ranked_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW v4_field_trial_ranked_summary AS
 SELECT v1_field_trial_summary.field_trial_key,
    v1_field_trial_summary.sum_live_quantity,
    v1_field_trial_summary.sum_plus_trees,
    v1_field_trial_summary.avg_dbh_cm,
    v1_field_trial_summary.avg_leaf_score,
    v1_field_trial_summary.sum_plus_dbh_leafscore,
    v1_field_trial_summary.id_test_spec,
    dense_rank() OVER (PARTITION BY v1_field_trial_summary.replication_nbr ORDER BY v1_field_trial_summary.sum_plus_dbh_leafscore DESC) AS ranked_reps,
    dense_rank() OVER (PARTITION BY v1_field_trial_summary.block_nbr ORDER BY v1_field_trial_summary.sum_plus_dbh_leafscore DESC) AS ranked_blocks,
    dense_rank() OVER (PARTITION BY v1_field_trial_summary.block_nbr, v1_field_trial_summary.id_test_spec ORDER BY v1_field_trial_summary.sum_plus_dbh_leafscore DESC) AS ranked_blocks_specs,
    dense_rank() OVER (PARTITION BY v1_field_trial_summary.block_nbr, v1_field_trial_summary.replication_nbr ORDER BY v1_field_trial_summary.sum_plus_dbh_leafscore DESC) AS ranked_blocks_reps,
    v1_field_trial_summary.replication_nbr,
    v1_field_trial_summary.block_nbr,
    v1_field_trial_summary.test_spec_key
   FROM v1_field_trial_summary
  ORDER BY v1_field_trial_summary.sum_plus_dbh_leafscore DESC;


ALTER TABLE v4_field_trial_ranked_summary OWNER TO "user";

--
-- Name: v5_field_trial_tree_shelter_2017; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW v5_field_trial_tree_shelter_2017 AS
 SELECT ft.field_trial_key,
    ft.id,
    ft.notes,
    ft.notes2 AS test_name,
    ft.notes3 AS tube_sleeve_control,
    ft.planted_order,
    ft.live_quantity,
    ft.is_plus_ynu,
    ft.live_dbh_cm,
    ft.live_height_cm,
    ft.leaf_score,
    ft.canker_score,
    ts.test_type,
    ts.stock_type,
    ts.stock_length_cm,
    ts.stock_collar_dia_mm,
    ft.tree_spacing_ft,
    ft.row_nbr,
    ft.column_nbr,
    ft.replication_nbr,
    ft.plot_nbr,
    ft.block_nbr,
    ts.test_spec_key,
    s.site_key,
    ft.id_test_spec,
    ft.id_site
   FROM field_trial ft,
    test_spec ts,
    site s
  WHERE ((ft.id_test_spec = ts.id) AND (ft.id_site = s.id) AND (ft.id_site = ANY (ARRAY[12, 13])));


ALTER TABLE v5_field_trial_tree_shelter_2017 OWNER TO "user";

--
-- Name: va1_master_test_detail; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW va1_master_test_detail AS
 SELECT td.test_detail_key,
    td.id,
    td.notes,
    td.notes2,
    td.notes3,
    td.planted_order,
    td.selection_type,
    td.stock_type,
    td.start_quantity,
    td.end_quantity,
    td.stock_dia_mm,
    td.height_cm,
    td.leaf_score,
    td.stock_length_cm,
    td.collar_median_dia_mm,
    td.stool_collar_median_dia_mm,
    td.field_cuttings_ft,
    trunc((td.end_quantity / td.start_quantity), 2) AS survival_rate,
    (trunc((td.end_quantity / td.start_quantity), 2) * td.collar_median_dia_mm) AS vigor_survival,
    (trunc((td.end_quantity / td.start_quantity), 2) * td.stool_collar_median_dia_mm) AS stool_vigor_survival,
    td.is_plus_ynu,
        CASE
            WHEN (td.is_plus_ynu = 'Y'::bpchar) THEN 1
            ELSE 0
        END AS is_plus_tree,
    ts.test_spec_key,
    ts.test_type,
    td.row_nbr,
    td.column_nbr,
    td.replication_nbr,
    td.plot_nbr,
    date_part('isoyear'::text, td.this_start_date) AS year
   FROM test_detail td,
    test_spec ts
  WHERE ((lower((td.notes)::text) !~~ lower('%willow%'::text)) AND (td.id_test_spec = ts.id))
  ORDER BY (trunc((td.end_quantity / td.start_quantity), 2) * td.collar_median_dia_mm) DESC;


ALTER TABLE va1_master_test_detail OWNER TO "user";

--
-- Name: va2_nursery_stocktype_test_detail; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW va2_nursery_stocktype_test_detail AS
 SELECT va1_master_test_detail.test_detail_key,
    va1_master_test_detail.stock_type,
    count(va1_master_test_detail.replication_nbr) AS nbr_of_replications,
    sum(va1_master_test_detail.start_quantity) AS sum_of_start_qty,
    sum(va1_master_test_detail.end_quantity) AS sum_of_end_qty,
    sum(va1_master_test_detail.is_plus_tree) AS sum_of_plus_trees,
    count(DISTINCT va1_master_test_detail.year) AS nbr_of_years,
    trunc(avg(va1_master_test_detail.survival_rate), 2) AS avg_survival_rate,
    trunc(avg(va1_master_test_detail.stock_dia_mm), 2) AS avg_stock_dia_mm,
    trunc(avg(va1_master_test_detail.height_cm), 2) AS avg_heigth_cm,
    trunc(avg(va1_master_test_detail.stock_length_cm), 2) AS avg_length_cm,
    trunc(avg(va1_master_test_detail.collar_median_dia_mm), 2) AS avg_collar_median_dia_mm,
    trunc(avg(va1_master_test_detail.stool_collar_median_dia_mm), 2) AS avg_stool_collar_mm,
    sum(va1_master_test_detail.field_cuttings_ft) AS sum_of_field_cuttings_ft,
    trunc(avg(va1_master_test_detail.field_cuttings_ft), 2) AS avg_field_cuttings_ft,
    trunc(avg(va1_master_test_detail.stool_vigor_survival), 2) AS avg_stool_vigor_survival,
        CASE
            WHEN (trunc(avg(va1_master_test_detail.vigor_survival), 2) > (0)::numeric) THEN trunc(avg(va1_master_test_detail.vigor_survival), 2)
            ELSE (0)::numeric
        END AS avg_vigor_survival,
    (trunc(avg(va1_master_test_detail.vigor_survival), 2) + (sum(va1_master_test_detail.is_plus_tree))::numeric) AS vigorsurvival_plus_plustrees,
    (trunc(avg(va1_master_test_detail.stool_vigor_survival), 2) + trunc(avg(va1_master_test_detail.field_cuttings_ft), 2)) AS stoolvs_plus_fcuttings,
    (trunc(avg(va1_master_test_detail.vigor_survival), 2) + trunc(avg(va1_master_test_detail.field_cuttings_ft), 2)) AS vigorsurvival_plus_fcuttings
   FROM va1_master_test_detail
  WHERE ((va1_master_test_detail.test_type)::text = 'nursery'::text)
  GROUP BY va1_master_test_detail.test_detail_key, va1_master_test_detail.stock_type
  ORDER BY (trunc(avg(va1_master_test_detail.vigor_survival), 2) + trunc(avg(va1_master_test_detail.field_cuttings_ft), 2)) DESC;


ALTER TABLE va2_nursery_stocktype_test_detail OWNER TO "user";

--
-- Name: va2_all_nursery_rankings; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW va2_all_nursery_rankings AS
 SELECT v1.test_detail_key,
    (((max(v2.ms_rank) || max(v2.dc_rank)) || max(v2.dc_reps)) || max(v2.dc_srate)) AS all_ms_dc_rankings
   FROM va2_nursery_stocktype_test_detail v1,
    ( SELECT va2_nursery_stocktype_test_detail.test_detail_key,
            va2_nursery_stocktype_test_detail.stock_type,
            ((va2_nursery_stocktype_test_detail.test_detail_key)::text ||
                CASE
                    WHEN (va2_nursery_stocktype_test_detail.stock_type = 'MS'::bpchar) THEN ('~rankms='::text || trunc(va2_nursery_stocktype_test_detail.stoolvs_plus_fcuttings, 1))
                    ELSE NULL::text
                END) AS ms_rank,
                CASE
                    WHEN (va2_nursery_stocktype_test_detail.stock_type = 'DC'::bpchar) THEN ('_rankdc='::text || trunc(va2_nursery_stocktype_test_detail.vigorsurvival_plus_fcuttings, 1))
                    ELSE NULL::text
                END AS dc_rank,
                CASE
                    WHEN (va2_nursery_stocktype_test_detail.stock_type = 'DC'::bpchar) THEN ('_dcreps='::text || va2_nursery_stocktype_test_detail.nbr_of_replications)
                    ELSE NULL::text
                END AS dc_reps,
                CASE
                    WHEN (va2_nursery_stocktype_test_detail.stock_type = 'DC'::bpchar) THEN ('_dcsrate='::text || trunc(va2_nursery_stocktype_test_detail.avg_survival_rate, 2))
                    ELSE NULL::text
                END AS dc_srate
           FROM va2_nursery_stocktype_test_detail) v2
  WHERE (((v1.test_detail_key)::text = (v2.test_detail_key)::text) AND (v1.stock_type = v2.stock_type))
  GROUP BY v1.test_detail_key
  ORDER BY v1.test_detail_key;


ALTER TABLE va2_all_nursery_rankings OWNER TO "user";

--
-- Name: va3_nursery_summary_test_detail; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW va3_nursery_summary_test_detail AS
 SELECT va1_master_test_detail.test_detail_key,
    count(va1_master_test_detail.replication_nbr) AS nbr_of_replications,
    count(DISTINCT va1_master_test_detail.stock_type) AS nbr_of_stock_types,
    count(DISTINCT va1_master_test_detail.year) AS nbr_of_years,
    sum(va1_master_test_detail.start_quantity) AS sum_of_start_qty,
    sum(va1_master_test_detail.end_quantity) AS sum_of_end_qty,
    sum(va1_master_test_detail.is_plus_tree) AS sum_of_plus_trees,
    trunc(avg(va1_master_test_detail.survival_rate), 2) AS avg_survival_rate,
    trunc(avg(va1_master_test_detail.stock_dia_mm), 2) AS avg_stock_dia_mm,
    trunc(avg(va1_master_test_detail.height_cm), 2) AS avg_heigth_cm,
    trunc(avg(va1_master_test_detail.collar_median_dia_mm), 2) AS avg_collar_median_dia_mm,
    trunc(avg(va1_master_test_detail.stool_collar_median_dia_mm), 2) AS avg_stool_collar_mm,
    sum(va1_master_test_detail.field_cuttings_ft) AS sum_of_field_cuttings_ft,
    trunc(avg(va1_master_test_detail.field_cuttings_ft), 2) AS avg_field_cuttings_ft,
    trunc(avg(va1_master_test_detail.stool_vigor_survival), 2) AS avg_stool_vigor_survival,
        CASE
            WHEN (trunc(avg(va1_master_test_detail.vigor_survival), 2) > (0)::numeric) THEN trunc(avg(va1_master_test_detail.vigor_survival), 2)
            ELSE (0)::numeric
        END AS avg_vigor_survival,
    (trunc(avg(va1_master_test_detail.vigor_survival), 2) + (sum(va1_master_test_detail.is_plus_tree))::numeric) AS vigorsurvival_plus_plustrees,
    (trunc(avg(va1_master_test_detail.stool_vigor_survival), 2) + trunc(avg(va1_master_test_detail.field_cuttings_ft), 2)) AS stoolvs_plus_fcuttings,
    (trunc(avg(va1_master_test_detail.vigor_survival), 2) + trunc(avg(va1_master_test_detail.field_cuttings_ft), 2)) AS vigorsurvival_plus_fcuttings
   FROM va1_master_test_detail
  WHERE ((va1_master_test_detail.test_type)::text = 'nursery'::text)
  GROUP BY va1_master_test_detail.test_detail_key
  ORDER BY (trunc(avg(va1_master_test_detail.vigor_survival), 2) + trunc(avg(va1_master_test_detail.field_cuttings_ft), 2)) DESC;


ALTER TABLE va3_nursery_summary_test_detail OWNER TO "user";

--
-- Name: va4_nursery_dormant_cutting_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW va4_nursery_dormant_cutting_summary AS
 SELECT va1_master_test_detail.test_detail_key,
    va1_master_test_detail.stock_type,
    count(va1_master_test_detail.replication_nbr) AS nbr_of_replications,
    count(DISTINCT va1_master_test_detail.year) AS nbr_of_years,
    sum(va1_master_test_detail.start_quantity) AS sum_of_start_qty,
    sum(va1_master_test_detail.end_quantity) AS sum_of_end_qty,
    sum(va1_master_test_detail.is_plus_tree) AS sum_of_plus_trees,
    trunc(avg(va1_master_test_detail.survival_rate), 2) AS avg_survival_rate,
    trunc(avg(va1_master_test_detail.stock_dia_mm), 2) AS avg_stock_dia_mm,
    trunc(avg(va1_master_test_detail.collar_median_dia_mm), 2) AS avg_collar_median_dia_mm,
    sum(va1_master_test_detail.field_cuttings_ft) AS sum_of_field_cuttings_ft,
    trunc(avg(va1_master_test_detail.field_cuttings_ft), 2) AS avg_field_cuttings_ft,
    trunc(avg(va1_master_test_detail.stool_vigor_survival), 2) AS avg_stool_vigor_survival,
        CASE
            WHEN (trunc(avg(va1_master_test_detail.vigor_survival), 2) > (0)::numeric) THEN trunc(avg(va1_master_test_detail.vigor_survival), 2)
            ELSE (0)::numeric
        END AS avg_vigor_survival,
    (trunc(avg(va1_master_test_detail.vigor_survival), 2) + (sum(va1_master_test_detail.is_plus_tree))::numeric) AS vigorsurvival_plus_plustrees,
    (trunc(avg(va1_master_test_detail.stool_vigor_survival), 2) + trunc(avg(va1_master_test_detail.field_cuttings_ft), 2)) AS stoolvs_plus_fcuttings,
    (trunc(avg(va1_master_test_detail.vigor_survival), 2) + trunc(avg(va1_master_test_detail.field_cuttings_ft), 2)) AS vigorsurvival_plus_fcuttings
   FROM va1_master_test_detail
  WHERE (((va1_master_test_detail.test_type)::text = 'nursery'::text) AND (va1_master_test_detail.stock_type = ANY (ARRAY['DC'::bpchar, 'FDC'::bpchar, 'ODC'::bpchar])))
  GROUP BY va1_master_test_detail.test_detail_key, va1_master_test_detail.stock_type
  ORDER BY (trunc(avg(va1_master_test_detail.vigor_survival), 2) + trunc(avg(va1_master_test_detail.field_cuttings_ft), 2)) DESC;


ALTER TABLE va4_nursery_dormant_cutting_summary OWNER TO "user";

--
-- Name: vw_2004_nursery_seedling_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw_2004_nursery_seedling_summary AS
 SELECT avw_test_detail.test_detail_key,
    min((avw_test_detail.notes)::text) AS min_notes,
    count(avw_test_detail.test_detail_key) AS count_test_detail_key,
    sum(avw_test_detail.start_quantity) AS sum_start_quantity,
    sum(avw_test_detail.end_quantity) AS sum_end_quantity,
    trunc((sum(avw_test_detail.end_quantity) / sum(avw_test_detail.start_quantity)), 2) AS survival_rate,
    sum(avw_test_detail.stock_dia_mm) AS sum_stock_dia_mm,
    trunc(avg(NULLIF(avw_test_detail.stock_dia_mm, (0)::numeric)), 2) AS avg_dia_mm,
    sum(avw_test_detail.height_cm) AS sum_height_cm,
    trunc(avg(NULLIF(avw_test_detail.height_cm, (0)::numeric)), 2) AS avg_height_cm,
    trunc(((sum(avw_test_detail.end_quantity) / sum(avw_test_detail.start_quantity)) * avg(NULLIF(avw_test_detail.height_cm, (0)::numeric))), 2) AS avg_height_times_survivalrate,
    trunc(((sum(avw_test_detail.end_quantity) / sum(avw_test_detail.start_quantity)) * avg(NULLIF(avw_test_detail.stock_dia_mm, (0)::numeric))), 2) AS avg_diameter_times_survivalrate,
    min(avw_test_detail.replication_nbr) AS min_rep_nbr,
    min(avw_test_detail.stock_type) AS min_stock_type
   FROM avw_test_detail
  WHERE ((avw_test_detail.test_spec_key)::text = '2004-bell-nursery-hgt-dia-meas'::text)
  GROUP BY avw_test_detail.test_detail_key
  ORDER BY (trunc(((sum(avw_test_detail.end_quantity) / sum(avw_test_detail.start_quantity)) * avg(NULLIF(avw_test_detail.height_cm, (0)::numeric))), 2)) DESC;


ALTER TABLE vw_2004_nursery_seedling_summary OWNER TO "user";

--
-- Name: vw_2017_1_nursery; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw_2017_1_nursery AS
 SELECT td.test_detail_key,
    td.id,
    td.notes,
    td.notes2 AS ranks_2017,
    td.notes3 AS rank_class,
    td.planted_order,
    td.selection_type,
    td.stock_type,
    td.stock_length_cm,
    td.stock_dia_mm,
    td.start_quantity,
    td.end_quantity,
    td.field_cuttings_ft,
    td.collar_median_dia_mm,
    td.stool_collar_median_dia_mm,
    trunc((td.end_quantity / td.start_quantity), 2) AS survival_rate,
    (trunc((td.end_quantity / td.start_quantity), 2) * td.collar_median_dia_mm) AS vigor_survival,
    (trunc((td.end_quantity / td.start_quantity), 2) * td.stool_collar_median_dia_mm) AS stool_vigor_survival,
    td.is_plus_ynu,
        CASE
            WHEN (td.is_plus_ynu = 'Y'::bpchar) THEN 1
            ELSE 0
        END AS is_plus_tree,
    td.row_nbr,
    td.column_nbr,
    td.replication_nbr,
    td.block_nbr
   FROM test_detail td,
    test_spec ts
  WHERE ((td.id_test_spec = ts.id) AND ((ts.test_spec_key)::text = '2017-bell-nursery'::text))
  ORDER BY (trunc((td.end_quantity / td.start_quantity), 2) * td.collar_median_dia_mm) DESC;


ALTER TABLE vw_2017_1_nursery OWNER TO "user";

--
-- Name: vw_2017_2_nursery_key_stock_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw_2017_2_nursery_key_stock_summary AS
 SELECT DISTINCT vw_2017_1_nursery.test_detail_key,
    vw_2017_1_nursery.stock_type,
    min(vw_2017_1_nursery.id) AS id_order,
    min((vw_2017_1_nursery.rank_class)::text) AS rank_class,
        CASE
            WHEN (min(vw_2017_1_nursery.selection_type) = 'P'::bpchar) THEN 'Primary - Elite'::text
            WHEN (min(vw_2017_1_nursery.selection_type) = 'S'::bpchar) THEN 'Secondary - Archive'::text
            WHEN (min(vw_2017_1_nursery.selection_type) = 'T'::bpchar) THEN 'Tertiary - Parent'::text
            WHEN (min(vw_2017_1_nursery.selection_type) = 'F'::bpchar) THEN 'Family - Retest'::text
            WHEN (min(vw_2017_1_nursery.selection_type) = 'R'::bpchar) THEN 'Retest - Clone'::text
            WHEN (min(vw_2017_1_nursery.selection_type) = 'U'::bpchar) THEN 'Unknown'::text
            WHEN (min(vw_2017_1_nursery.selection_type) = 'D'::bpchar) THEN 'Discard'::text
            ELSE 'ERROR - Mislabeled'::text
        END AS selection_type,
    count(vw_2017_1_nursery.replication_nbr) AS nbr_of_replications,
    sum(vw_2017_1_nursery.start_quantity) AS sum_of_start_qty,
    sum(vw_2017_1_nursery.end_quantity) AS sum_of_end_qty,
    sum(vw_2017_1_nursery.field_cuttings_ft) AS sum_field_cuttings,
    sum(vw_2017_1_nursery.is_plus_tree) AS sum_of_plus_trees,
    trunc(avg(vw_2017_1_nursery.survival_rate), 2) AS avg_survival_rate,
    trunc(avg(vw_2017_1_nursery.vigor_survival), 2) AS avg_vigor_survival_rate,
    trunc(avg(vw_2017_1_nursery.stool_vigor_survival), 2) AS avg_stool_vigor_survival_rate,
    trunc(avg(vw_2017_1_nursery.stock_dia_mm), 2) AS avg_stock_dia_mm,
    trunc(avg(vw_2017_1_nursery.collar_median_dia_mm), 2) AS avg_collar_median_dia_mm,
    trunc(avg(vw_2017_1_nursery.stool_collar_median_dia_mm), 2) AS avg_stool_collar_mm,
    trunc((avg(vw_2017_1_nursery.stool_vigor_survival) + (avg(vw_2017_1_nursery.field_cuttings_ft) * ((count(vw_2017_1_nursery.replication_nbr))::numeric * 0.1))), 2) AS stools_cut_fcut_reps,
    trunc((avg(vw_2017_1_nursery.vigor_survival) + (avg(vw_2017_1_nursery.field_cuttings_ft) * ((count(vw_2017_1_nursery.replication_nbr))::numeric * 0.1))), 2) AS cut_fcut_reps
   FROM vw_2017_1_nursery
  GROUP BY vw_2017_1_nursery.test_detail_key, vw_2017_1_nursery.stock_type
  ORDER BY (trunc((avg(vw_2017_1_nursery.vigor_survival) + (avg(vw_2017_1_nursery.field_cuttings_ft) * ((count(vw_2017_1_nursery.replication_nbr))::numeric * 0.1))), 2)) DESC;


ALTER TABLE vw_2017_2_nursery_key_stock_summary OWNER TO "user";

--
-- Name: vw_2017_3_nursery_stock_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw_2017_3_nursery_stock_summary AS
 SELECT vw_2017_2_nursery_key_stock_summary.stock_type,
    count(vw_2017_2_nursery_key_stock_summary.stock_type) AS stock_type_count,
    sum(vw_2017_2_nursery_key_stock_summary.sum_of_start_qty) AS planted_trees,
    sum(vw_2017_2_nursery_key_stock_summary.sum_of_end_qty) AS available_trees,
    sum(vw_2017_2_nursery_key_stock_summary.sum_field_cuttings) AS field_grade_cuttings,
    sum(vw_2017_2_nursery_key_stock_summary.sum_of_plus_trees) AS plus_trees,
    trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_survival_rate), 2) AS avg_survival_rate,
        CASE
            WHEN (trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_stock_dia_mm), 2) > (0)::numeric) THEN trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_stock_dia_mm), 2)
            ELSE NULL::numeric
        END AS avg_stock_dia_mm,
        CASE
            WHEN (trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_collar_median_dia_mm), 2) > (0)::numeric) THEN trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_collar_median_dia_mm), 2)
            ELSE NULL::numeric
        END AS avg_1_0_collar_median_dia_mm,
        CASE
            WHEN (trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_stool_collar_mm), 2) > (0)::numeric) THEN trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_stool_collar_mm), 2)
            ELSE NULL::numeric
        END AS avg_stool_collar_median_dia_mm
   FROM vw_2017_2_nursery_key_stock_summary
  GROUP BY vw_2017_2_nursery_key_stock_summary.stock_type
  ORDER BY (count(vw_2017_2_nursery_key_stock_summary.stock_type)) DESC;


ALTER TABLE vw_2017_3_nursery_stock_summary OWNER TO "user";

--
-- Name: vw_2017_4_nursery_action_stock_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw_2017_4_nursery_action_stock_summary AS
 SELECT vw_2017_2_nursery_key_stock_summary.selection_type,
    vw_2017_2_nursery_key_stock_summary.stock_type,
    count(vw_2017_2_nursery_key_stock_summary.stock_type) AS stock_type_count,
    sum(vw_2017_2_nursery_key_stock_summary.sum_of_start_qty) AS planted_trees,
    sum(vw_2017_2_nursery_key_stock_summary.sum_of_end_qty) AS available_trees,
    sum(vw_2017_2_nursery_key_stock_summary.sum_field_cuttings) AS field_grade_cuttings,
    sum(vw_2017_2_nursery_key_stock_summary.sum_of_plus_trees) AS plus_trees,
    trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_survival_rate), 2) AS avg_survival_rate,
        CASE
            WHEN (trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_stock_dia_mm), 2) > (0)::numeric) THEN trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_stock_dia_mm), 2)
            ELSE NULL::numeric
        END AS avg_stock_dia_mm,
        CASE
            WHEN (trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_stool_collar_mm), 2) > (0)::numeric) THEN trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_stool_collar_mm), 2)
            ELSE NULL::numeric
        END AS avg_stool_collar_median_dia_mm,
        CASE
            WHEN (trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_collar_median_dia_mm), 2) > (0)::numeric) THEN trunc(avg(vw_2017_2_nursery_key_stock_summary.avg_collar_median_dia_mm), 2)
            ELSE NULL::numeric
        END AS avg_1_0_collar_median_dia_mm
   FROM vw_2017_2_nursery_key_stock_summary
  GROUP BY vw_2017_2_nursery_key_stock_summary.selection_type, vw_2017_2_nursery_key_stock_summary.stock_type
  ORDER BY vw_2017_2_nursery_key_stock_summary.selection_type DESC;


ALTER TABLE vw_2017_4_nursery_action_stock_summary OWNER TO "user";

--
-- Name: vw_2017_5_nursery_field_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw_2017_5_nursery_field_summary AS
 SELECT ss.test_detail_key,
    ss.stock_type,
    ss.id_order,
    ss.rank_class,
    ss.selection_type,
    ss.nbr_of_replications,
    ss.sum_of_start_qty,
    ss.sum_of_end_qty,
    ss.sum_field_cuttings,
    ss.sum_of_plus_trees,
    ss.avg_survival_rate,
    ss.avg_stock_dia_mm,
    ss.avg_collar_median_dia_mm,
    ss.avg_stool_collar_mm,
    ss.stools_cut_fcut_reps,
    ss.cut_fcut_reps,
        CASE
            WHEN (ss.stock_type = 'MS'::bpchar) THEN dense_rank() OVER (ORDER BY ss.stools_cut_fcut_reps DESC)
            ELSE '-1'::bigint
        END AS stool_rank,
        CASE
            WHEN (ss.stock_type = 'DC'::bpchar) THEN dense_rank() OVER (ORDER BY ss.cut_fcut_reps DESC)
            ELSE '-1'::bigint
        END AS dc_rank,
        CASE
            WHEN (ft.archived_trees IS NULL) THEN (0)::numeric
            ELSE ft.archived_trees
        END AS archived_trees,
    (((((((((ss.test_detail_key)::text || '~rankms= '::text) ||
        CASE
            WHEN (ss.stock_type = 'MS'::bpchar) THEN dense_rank() OVER (ORDER BY ss.stools_cut_fcut_reps DESC)
            ELSE '-1'::bigint
        END) || '_rankdc= '::text) ||
        CASE
            WHEN (ss.stock_type = 'DC'::bpchar) THEN dense_rank() OVER (ORDER BY ss.cut_fcut_reps DESC)
            ELSE '-1'::bigint
        END) || '_reps='::text) || ss.nbr_of_replications) || '_srate='::text) || trunc(ss.avg_survival_rate, 2)) AS ms_dc_rankings_2017,
    ((((nr.all_ms_dc_rankings || '_archived='::text) || ft.archived_trees) || '_field_score='::text) || fts.sum_score) AS all_ms_dc_archived_score
   FROM (((vw_2017_2_nursery_key_stock_summary ss
     LEFT JOIN ( SELECT avw_field_trial.field_trial_key,
            sum(avw_field_trial.live_quantity) AS archived_trees
           FROM avw_field_trial
          WHERE (avw_field_trial.id_test_spec = 30)
          GROUP BY avw_field_trial.field_trial_key) ft ON (((ss.test_detail_key)::text = (ft.field_trial_key)::text)))
     LEFT JOIN ( SELECT va2_all_nursery_rankings.test_detail_key,
            va2_all_nursery_rankings.all_ms_dc_rankings
           FROM va2_all_nursery_rankings) nr ON (((ss.test_detail_key)::text = (nr.test_detail_key)::text)))
     LEFT JOIN ( SELECT v1_field_trial_summary.field_trial_key,
            sum(v1_field_trial_summary.sum_plus_dbh_leafscore) AS sum_score
           FROM v1_field_trial_summary
          WHERE (v1_field_trial_summary.id_test_spec = 30)
          GROUP BY v1_field_trial_summary.field_trial_key) fts ON (((ss.test_detail_key)::text = (fts.field_trial_key)::text)))
  ORDER BY ss.cut_fcut_reps DESC;


ALTER TABLE vw_2017_5_nursery_field_summary OWNER TO "user";

--
-- Name: vw_2017_6_nursery_summary_by_rep_nbr; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw_2017_6_nursery_summary_by_rep_nbr AS
 SELECT min((a.test_detail_key)::text) AS min_test_detail,
    b.notes,
    a.replication_nbr,
    min(a.stock_type) AS min_stock_type,
    min(a.selection_type) AS min_selection_type,
    trunc(avg(a.leaf_score), 2) AS avg_leaf_score,
    sum(a.start_quantity) AS sum_start_qty,
    sum(a.end_quantity) AS sum_end_qty,
    trunc((sum(a.end_quantity) / sum(a.start_quantity)), 2) AS survival_rate,
    trunc(avg(a.stock_dia_mm), 2) AS avg_stock_dia_mm,
    trunc(avg(a.stock_length_cm), 2) AS avg_stock_length_cm,
    trunc(avg(a.collar_median_dia_mm), 2) AS avg_collar_median_dia_mm,
    trunc(avg(a.stool_collar_median_dia_mm), 2) AS avg_stool_collar_median_dia_mm,
    trunc(avg(a.vigor_survival), 2) AS avg_vigor_survival,
    trunc(avg(a.stool_vigor_survival), 2) AS avg_stool_vigor_survival,
    sum(a.is_plus_tree) AS sum_of_plus_trees,
    sum(a.field_cuttings_ft) AS sum_of_field_cuttings_ft
   FROM va1_master_test_detail a,
    ( SELECT va1_master_test_detail.replication_nbr,
            va1_master_test_detail.notes
           FROM va1_master_test_detail
          WHERE ((va1_master_test_detail.year = '2017'::double precision) AND ((va1_master_test_detail.test_type)::text = 'nursery'::text) AND (va1_master_test_detail.plot_nbr > 0))) b
  WHERE ((a.year = '2017'::double precision) AND ((a.test_type)::text = 'nursery'::text) AND (a.replication_nbr = b.replication_nbr))
  GROUP BY a.replication_nbr, b.notes
  ORDER BY a.replication_nbr;


ALTER TABLE vw_2017_6_nursery_summary_by_rep_nbr OWNER TO "user";

--
-- Name: vw_2017_7_stock; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw_2017_7_stock AS
 SELECT vw_2017_5_nursery_field_summary.test_detail_key,
    vw_2017_5_nursery_field_summary.rank_class,
    vw_2017_5_nursery_field_summary.selection_type,
    vw_2017_5_nursery_field_summary.stock_type,
    vw_2017_5_nursery_field_summary.nbr_of_replications,
    vw_2017_5_nursery_field_summary.sum_field_cuttings,
    vw_2017_5_nursery_field_summary.sum_of_plus_trees,
    vw_2017_5_nursery_field_summary.avg_survival_rate,
    vw_2017_5_nursery_field_summary.avg_stock_dia_mm,
    vw_2017_5_nursery_field_summary.archived_trees,
    vw_2017_5_nursery_field_summary.dc_rank
   FROM vw_2017_5_nursery_field_summary
  ORDER BY vw_2017_5_nursery_field_summary.dc_rank;


ALTER TABLE vw_2017_7_stock OWNER TO "user";

--
-- Name: vw_2017_8_stock_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw_2017_8_stock_summary AS
 SELECT vw_2017_7_stock.selection_type,
    count(vw_2017_7_stock.test_detail_key) AS count_of_selection_types,
    trunc(avg(vw_2017_7_stock.nbr_of_replications), 2) AS avg_replications,
    trunc(avg(vw_2017_7_stock.sum_field_cuttings), 2) AS avg_field_grade_cuttings,
    trunc(sum(vw_2017_7_stock.sum_field_cuttings), 0) AS sum_of_field_grade_cuttings,
    trunc(avg(vw_2017_7_stock.avg_survival_rate), 2) AS avg_survival_rate,
    trunc(avg(vw_2017_7_stock.avg_stock_dia_mm), 2) AS avg_stock_dia_mm,
    trunc(sum(vw_2017_7_stock.sum_of_plus_trees), 0) AS sum_of_plus_trees,
    sum(vw_2017_7_stock.archived_trees) AS sum_of_archived_trees
   FROM vw_2017_7_stock
  GROUP BY vw_2017_7_stock.selection_type
  ORDER BY (trunc(avg(vw_2017_7_stock.avg_survival_rate), 2)) DESC;


ALTER TABLE vw_2017_8_stock_summary OWNER TO "user";

--
-- Name: vw_2017_9_te_law_test; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw_2017_9_te_law_test AS
 SELECT td.test_detail_key,
    td.id,
    td.notes,
    td.planted_order,
    td.selection_type,
    td.stock_type,
    td.stock_length_cm,
    td.stock_dia_mm,
    td.start_quantity,
    td.end_quantity,
    td.field_cuttings_ft AS onefoot_cuttings,
    td.stool_collar_median_dia_mm,
    trunc((td.end_quantity / td.start_quantity), 2) AS survival_rate,
    (trunc((td.end_quantity / td.start_quantity), 2) * td.stool_collar_median_dia_mm) AS stool_vigor_survival,
    (trunc((td.end_quantity / td.start_quantity), 2) * td.field_cuttings_ft) AS onefoot_cuttings_survival,
    td.is_plus_ynu,
        CASE
            WHEN (td.is_plus_ynu = 'Y'::bpchar) THEN 1
            ELSE 0
        END AS is_plus_tree,
    td.row_nbr,
    td.column_nbr,
    td.replication_nbr,
    td.block_nbr
   FROM test_detail td,
    test_spec ts
  WHERE ((td.id_test_spec = ts.id) AND ((ts.test_spec_key)::text = '2017-bell-nursery'::text) AND ((td.test_detail_key)::text ~~ 'te%'::text))
  ORDER BY (trunc((td.end_quantity / td.start_quantity), 2) * td.field_cuttings_ft) DESC;


ALTER TABLE vw_2017_9_te_law_test OWNER TO "user";

--
-- Name: vw_u07m_2013; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vw_u07m_2013 AS
 SELECT u07m_2013.name,
    count(
        CASE
            WHEN (u07m_2013.dbh > (0)::numeric) THEN u07m_2013.dbh
            ELSE NULL::numeric
        END) AS count_live_trees,
    round(avg(u07m_2013.dbh_rank), 2) AS avg_dbh_rank,
    round(avg(u07m_2013.area_index), 2) AS avg_area_index,
    round(avg(u07m_2013.sum_dbh_ratio2_cd), 2) AS avg_dbh_ratio2_cd,
    round(avg(u07m_2013.sdbh_x_cavg), 2) AS avg_sdbh_x_cavg,
    round(stddev(u07m_2013.dbh_rank), 2) AS stdev_dbh_rank,
    round(stddev(u07m_2013.area_index), 2) AS stdev_area_index,
    round(stddev(u07m_2013.sum_dbh_ratio2_cd), 2) AS stev_dbh_ratio2_cd,
    round(stddev(u07m_2013.sdbh_x_cavg), 2) AS stdev_sdbh_x_cavg
   FROM u07m_2013
  GROUP BY u07m_2013.name
  ORDER BY (avg(u07m_2013.sdbh_x_cavg)) DESC;


ALTER TABLE vw_u07m_2013 OWNER TO "user";

--
-- Name: vwa_2017_10_te_law_test_summary; Type: VIEW; Schema: public; Owner: user
--

CREATE VIEW vwa_2017_10_te_law_test_summary AS
 SELECT min((vw_2017_9_te_law_test.test_detail_key)::text) AS min_test_detail_key,
    min((vw_2017_9_te_law_test.notes)::text) AS test_description,
    trunc(avg(vw_2017_9_te_law_test.stock_length_cm), 1) AS avg_planted_stock_length_cm,
    trunc(avg(vw_2017_9_te_law_test.stock_dia_mm), 1) AS avg_planted_stock_dia_mm,
    sum(vw_2017_9_te_law_test.start_quantity) AS sum_start_qty,
    sum(vw_2017_9_te_law_test.end_quantity) AS sum_end_qty,
    trunc(avg(vw_2017_9_te_law_test.onefoot_cuttings), 1) AS avg_onefoot_cuttings,
    sum(vw_2017_9_te_law_test.onefoot_cuttings) AS sum_onefoot_cuttings,
    trunc(avg(vw_2017_9_te_law_test.stool_collar_median_dia_mm), 1) AS stool_collar_median_dia_mm,
    trunc(avg(vw_2017_9_te_law_test.survival_rate), 1) AS avg_survival_rate,
    trunc(avg(vw_2017_9_te_law_test.stool_vigor_survival), 1) AS avg_stool_vigor_survival,
    trunc(avg(vw_2017_9_te_law_test.onefoot_cuttings_survival), 1) AS avg_onefoot_cuttings_survival,
    sum(vw_2017_9_te_law_test.is_plus_tree) AS sum_is_plus_tree
   FROM vw_2017_9_te_law_test
  GROUP BY vw_2017_9_te_law_test.block_nbr
  ORDER BY (trunc(avg(vw_2017_9_te_law_test.onefoot_cuttings_survival), 1)) DESC;


ALTER TABLE vwa_2017_10_te_law_test_summary OWNER TO "user";

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY family ALTER COLUMN id SET DEFAULT nextval('family_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY field_trial ALTER COLUMN id SET DEFAULT nextval('field_trial_id_seq'::regclass);


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

ALTER TABLE ONLY split_wood_tests ALTER COLUMN id SET DEFAULT nextval('split_wood_tests_id_seq'::regclass);


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
-- Name: id; Type: DEFAULT; Schema: public; Owner: user
--

ALTER TABLE ONLY u07m_2013 ALTER COLUMN id SET DEFAULT nextval('u07m_2013_id_seq'::regclass);


--
-- Data for Name: family; Type: TABLE DATA; Schema: public; Owner: user
--

COPY family (family_key, id, notes, female_plant_id, male_plant_id, seed_notes, form_fnmwu, is_plus, is_root, seeds_in_storage, seed_germ_percent, seed_germ_date, cross_date, project_phase, id_taxa, web_photos, web_url) FROM stdin;
TBD	1	To Be Determined	1	1	0	U	U	0	-1	-1	1111-11-11	1111-11-11	-1	2	0	0
NA	2	Does Not Apply	1	1	0	U	U	0	-1	-1	1111-11-11	1111-11-11	-1	2	0	0
17XGA04	33	Female is sibling to GG101.  Male is sibling to AA4101. Reciprocal is 18xAG04.	48	35	0	U	U	0	0	0.35	2004-04-23	2004-04-01	2	7	0	0
18XAG04	34	Female is sibling to AA4102 .  Male is sibling to GG102.  Reciprocal is 17xGA04.	34	49	0	U	U	0	0	0.35	2004-04-23	2004-04-01	2	6	0	0
21XAAG91	58	0	41	56	0	U	U	0	0	-1	1111-11-11	1991-04-01	1.2	26	0	0
42XAA91	90	Open pollinated seed from one selected tree from the Serbia region of Yugoslavia.  I received a huge amount of seed (~15,000), about 50% viable.. 7 trees at RNE, ISU planted 24.	2	163	0	U	U	0	0	0.5	1111-11-11	1991-04-01	1.2	3	0	0
53XAA92	102	0	27	24	0	U	U	0	0	-1	1111-11-11	1992-04-01	1.2	3	0	0
68XAA93	120	Fall-09 Observed a nice specimen at RNE on SW end.  It is a 3 bole tree with no observed BLD in 09.  Should be an interesting clone, since it has no A502 and 14 males was known for its size	27	14	0	U	U	0	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
69XAA93	121	FAILED - no seedlings	27	13	0	U	U	0	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
70XAA93	123	Fall-09 Observed a nice single bole border specimen at RNE on SW end.  No observed BLD in 09.  Should be an interesting clone, since it has no A502 and the 15 male parent was selected from an Italian plantation so it may have good rooting...	27	15	0	U	U	0	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
71XAA93	124	FAILED - no seedlings	27	16	0	U	U	0	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
72XAA93	125	FAILED - no seedlings	27	17	0	U	U	0	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
73XAA93	126	FAILED - no seedlings	27	19	0	U	U	0	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
76XAA02	129	1-0 stock seems vigorous in nursery.  About 50% should be fastigate. Rooting: 2003 - 26 of 68 (38%) rooted 100%, Tag Results: Red=5, Yellow=21, Black=12	11	33	0	U	U	0	0	-1	1111-11-11	2002-04-01	2	3	0	0
77XAA02	130	1-0 stock seems vigorous in nursery. About 50% should be fastigate. Female parent is (4 x Bolleana). Female is not a good rooter (0/40 in 04) Rooting: 2003-18 of 45(40%) rooted 100% Rooting Tag Results: Red=2, Yellow=16, Black=5  	34	33	0	U	U	0	0	-1	1111-11-11	2002-04-01	2	3	0	0
78XAA02	131	FYI: this should not be an AA cross. Female is from the family 20xAAG91 (A266 x AG Crandon (ortet is @ RNE - 8th tree from south - dead in 04), male is good rooter but weak.  18 seedlings survived, only 9 were plantable.  This family showed a lot of variation.  	43	33	Flowers fertilized on 3-16-02 and seed of poor quality harvested on 4-14-02.  Planted seed on 4-17-02 in a 1/2 flat and planted in nursery on 6-01-02. Only 18 seedlings survived and 9 were useable, tallest was 3 inches, a LOT of seedling variation.  	U	U	0	0	0.13	1111-11-11	2002-04-01	2	42	0	0
79XAA03	132	Males is from the family of 4 x Bolleana.  Flowers were fertilized 4/9/03, Seeds harvested 4/25/03.  14 trees vigorous, uniform trees survived.  Same cross as 83xAA04.	11	35	0	U	U	0	0	-1	1111-11-11	2003-04-01	2	3	0	0
80XAA04	137	Female parent has good vigor, poor form and rooting.	46	35	0	U	U	0	0	0.32	2004-04-23	2004-04-01	2	3	0	0
81XAA04	138	Female parent has good vigor, poor rooting, and poor form.	41	35	0	U	U	0	0	0.35	2004-04-23	2004-04-01	2	3	0	0
82XAA04	139	Female parent has good vigor, good form, poor rooting.	44	35	0	U	Y	0	0	0.69	2004-04-23	2004-04-01	2	3	0	0
83XAA04	140	Female parent has fair vigor, form and rooting.  Nine year field trials in Northern MI show good vigor and rooting.	11	35	0	U	Y	0	0	0.69	2004-04-23	2004-04-01	2	3	0	0
84XAA04	141	Female parent has good vigor, some rooting potential, and poor form.	47	35	0	U	Y	0	0	0.69	2004-04-23	2004-04-01	2	3	0	0
85XAA04	142	Inbred cross. Both parents have great form, fair vigor. Male has some rooting.	34	35	0	U	U	0	0	0.32	2004-04-23	2004-04-01	2	3	0	0
92XAA10	152	Fair flower set, may have fertilized too early, or pollen issues. There was some rooting via PIP for the male, 133. Priority set at seed harvest is Medium, since progeny may have fair form, vigor, durability but poor rooting.	138	133	0	U	U	0	0	0.77	2010-06-02	2010-04-01	3	3	0	0
89XAA10	153	OK flower set, 138 had huge flowers, may need to fert when longer than 1/2.  Priority set at seed harvest is Medium, since progeny may have fair form, vigor, durability but poor rooting.	138	8	0	U	U	0	0	0.71	2010-06-02	2010-04-01	3	3	0	0
91XAA10	154	Fair flower set, poorest for this female.  Priority set at seed harvest is High, since progeny may have vigorous individuals with fair form, durability but poor rooting.	138	19	0	U	U	0	0	0.43	2010-06-02	2010-04-01	3	3	0	0
98XAA10	155	Priority set at seed harvest set at High since progeny may have vigorous, good rooting individuals with fair form and durability. 	141	144	0	U	U	0	0	0.34	2010-06-02	2010-04-01	3	3	0	0
101XAA10	156	Priority set at seed harvest set at High since progeny may have vigorous, durable individuals but with poor form and rooting. 	141	19	0	U	U	0	0	0.07	2010-06-02	2010-04-01	3	3	0	0
9XTG93	149	0	149	60	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	5	0	0
99XAA10	157	Priority set at seed harvest set at Medium, since progeny may have fair formed, vigorous and rooting individuals 	141	35	0	U	U	0	0	0.5	2010-06-02	2010-04-01	3	3	0	0
100XAA10	158	Pollinated 6 flowers from top to bottom with the minimal pollen collected from 2 male catkins (4 produced seed).  Planted a 1/2 flat on 4/11 as the branch died early and flowers started rotting.  About 1/3 of the seed was small. Priority set at seed harvest set at High since progeny may have vigorous, good rooting individuals with fair form and durability.   Expect rooting to be better than 98xA4 family.	141	143	0	U	Y	0	0	0.28	2010-06-02	2010-04-01	3	3	0	0
97XAA10	159	Set priority at seed harvest to High since progeny may have vigorous, well formed and durable individuals but with poor rooting.	142	19	0	U	U	0	0	0.53	2010-06-02	2010-04-01	3	3	0	0
96XAA10	160	Set priority at seed harvest to Medium since progeny may have fair formed, durable and vigorous individuals, but with with poor rooting.	142	133	0	U	U	0	0	0.39	2010-06-02	2010-04-01	3	3	0	0
94XAA10	161	Set priority at seed harvest to Medium since progeny may have fair formed, durable and vigorous individuals, but with with poor rooting.	142	8	0	U	U	0	0	0.71	2010-06-02	2010-04-01	3	3	0	0
95XAA10	162	Set priority at seed harvest to Medium since progeny may have fair formed, durable and vigorous individuals, but with with poor rooting.	140	133	0	U	U	0	0	0.28	2010-06-02	2010-04-01	3	3	0	0
88XAA10	163	Set priority at seed harvest to Medium since progeny may have fair formed, durable and vigorous individuals, but with with poor rooting.	140	8	0	U	U	0	0	0.89	2010-06-02	2010-04-01	3	3	0	0
87XAA10	164	Set priority at seed harvest to Medium, since progeny may have fair formed individuals with unknown vigor and durability... Note that both parents of this cross share the same well formed and poor rooting female parent, 4.	140	35	0	U	U	0	0	0.21	2010-06-02	2010-04-01	3	3	0	0
90XAA10	165	Priority set at seed harvest to High since progeny may have vigorous, durable individuals but with fair form and poor rooting. 	140	19	0	U	U	0	0	0.86	2010-06-02	2010-04-01	3	3	0	0
93XAA10	166	This cross has same parents as 83xAA04. Produced about 20,000 seeds.   Priority set at seed harvest set at High since progeny may have vigorous, good rooting individuals with fair form and durability. See MSU field results for their U07m site.	11	35	0	U	Y	0	0	0.71	2010-06-02	2010-04-01	3	3	0	0
102XAA10	168	Set priority at seed harvest to Medium since progeny may have vigorous, durable individuals but with poor form and rooting.	134	19	0	U	U	0	0	0.05	2010-06-02	2010-04-01	3	3	0	0
104XAA10	169	Set priority at seed harvest to High since progeny may have vigorous, durable individuals with fair form and rooting.	134	144	0	U	Y	0	0	0.45	2010-06-02	2010-04-01	3	3	0	0
103XAA10	170	Set priority at seed harvest to High since progeny may have vigorous, durable individuals with fair form and poor rooting.	139	19	0	U	U	0	0	0.51	2010-06-02	2010-04-01	3	3	0	0
1XBW	171	Renamed from 1XCAGW. Collected Wind pollinated branches of CAG204 on 4/23/11, McGovern planted seed in 2012.  It appeared that these flowers were receptive quite early, perhaps earlier than native P. grandidentata.  My guess is that the males are tremuloides and maybe nearby 3xAA materials.   Collected from 3 branches, 1 had 2 catkins with 500 counted seeds.  The others had 5 catkins each.  I think each branch could support 4 catkins.   Observed from 174 seedlings that about 70% were P. Alba types and 30% were aspen types.	66	163	Fair to good, very heavy seed set for OP.	U	Y	0	1000	-1	1111-11-11	2011-05-14	3	14	0	0
1XAW	172	Collected Wind pollinated branches of 83AA310 on 4/23/11.  It appeared that these flowers were receptive later than CAG204, perhaps the same as native P. grandidentata. 	162	163	poor	U	U	0	0	0.5	1111-11-11	2011-05-14	3	33	0	0
2XB	173	A double hybrid that may exploit the vigor and durability of C173 and the straight form, vigor and durability of AG15.  Seed collected from 4/3/12 to 4/5/12.  Originally named 2xCAG12 changed on 9/30/14 to conform to new naming convention.	179	26	C173 had Fair to good seed set but seed had to be manually pulled.   I sampled 188 seeds planted on 4/4 and counted 120 viable seedlings.  Estimated germination after 4 days is 64%. 	U	Y	0	500	0.64	2012-04-05	2012-03-03	3	15	0	0
2XGW	175	Collected Wind pollinated branches 1 week before pollination - 5/4/13.  Nice formed female but likely not too many male bigtooths for full pollination. 	201	163	Poor bigtooth germination - perhaps related to the sparse seedset of the catkins (few of males in the area).	U	U	0	500	0.1	2013-06-01	2013-05-04	3	34	0	0
3XGW	176	Collected Wind pollinated branches 1 week before pollination - 5/4/13.  Nice formed female but likely not too many male bigtooths for full pollination. 	202	163	Poor bigtooth germination - perhaps related to the sparse seedset of the catkins (few of males in the area).  All seedlings failed in 2013 via short 288 cell flats at Bell.	U	U	0	500	0.05	2013-06-01	2013-05-24	3	34	0	0
5XGW	177	Collected Wind pollinated branches - After pollination and fully ripe on 5/24/13.  The area had lots of male bigtooths.	203	163	Best bigtooth germination - perhaps related to the full seedset of the catkins (lots of males in the area).	U	U	0	2000	0.9	2013-06-01	2013-05-24	3	34	0	0
2XRR	178	While most progeny seedlings have intermediate alba/aspen stem/leaf traits, a significant portion have more aspen traits. This seedlot had 63% germination, the smallest of all 2013 crosses.	199	61	Seedlings had a 48/100 useable count - ranking sixth out of the 6 crosses.  They started very slow!	U	U	0	500	0.63	2013-05-10	2013-04-28	3	35	0	0
22XAR	179	Both parents are vigorous and well formed. Most progeny seedlings have intermediate leaf shapes. Seedlings had leaf spots at Rakers.	204	61	Seedlings had a 61/100 useable count - ranking fith out of the 6 crosses.	U	U	0	500	0.77	2013-05-10	2013-05-07	3	26	0	0
105XAA	182	Progeny seedlings have alba leaf traits.  	204	19	Seedlings had a 65/100 useable count - ranking third out of the 6 crosses.	U	Y	0	500	0.7	2013-05-10	2013-05-07	3	3	0	0
106XAA	183	Parents: 83AA565 x NFA, Progeny expectations: VDRF, Priority: High. 83AA565 may have VRF, and flowered at 5yrs.	205	19	Fair	U	U	0	1000	0.33	2014-06-02	2014-05-12	4	3	0	0
107XAA	184	Parents: 30AA5MF x 80AA3MF, Progeny expectations: VDRF, Priority: H.  The female flowers were small and weak - bad branches?	141	182	Good. 2014 batch had small green seeds.	U	U	0	400	0.61	2014-06-02	2014-05-12	4	3	0	0
13XGB	188	Parents: gg102 x CAG177, Progeny expectations: VDRF, Priority: Med.  Compare with the U07m GAs with gg102 that did poorly.	48	65	fair	U	U	0	500	0.31	2014-06-02	2014-05-12	4	21	0	0
15XB	190	Parents: C173 x 9AG105, Progeny expectations: VDRF, Priority: Med. Compare to 3xRR, 9xBr, 5xRB	179	200	good	U	U	0	1200	0.24	2014-06-02	2014-05-12	4	15	0	0
16XAB	191	Parents: 83AA565 x CAG177, Progeny expectations: VDRF, Priority: High. 83AA565 may have VRF, and flowered at 5yrs.	205	65	fair	U	U	0	700	0.35	2014-06-02	2014-05-12	4	19	0	0
17XB	192	Parents: Plaza x 4AE1, Progeny expectations: VDRF, Priority: High.  This B is unrelated to CAG204 or CAG177. Planted 10 seedlings from Rakers.	207	213	very poor, did not seem viable. 	U	U	0	0	0.09	2014-06-02	2014-05-12	4	15	0	0
1XBAR	195	Parents: CAG204 x AAG2001, Progeny expectations: VDR, Priority: High.  AAG2001 is a vigorous & variable hybrid with Crandon and A266 parentage.	66	42	poor	U	U	0	0	0	2014-06-02	2014-05-12	4	39	0	0
20XBS	196	Parents: CAG204 x 4TG1, Progeny expectations: VDRF, Priority: High.  4TG1 is the best McGovern smithii 	66	214	good	U	Y	0	200	0.87	2014-06-02	2014-05-12	4	20	0	0
21XBA	197	Parents: CAG204 x 80AA3MF, Progeny expectations: VDRF, Priority: High.  80AA3MF is vigorous but a poor rooter	66	182	poor	U	U	0	0	0.27	2014-06-02	2014-05-12	4	20	0	0
23XBA	199	Parents: CAG204 x 82AA3, Progeny expectations: VDRF, Priority: High.  82AA3 is a plus tree male alba from MBP GR site.  14 of the 130 seedlings (9%) have a pronounced curly stem tip habit. 	66	208	fair	U	Y	0	1100	0.61	2014-06-02	2014-05-12	4	20	0	0
3XRR	200	Parents: Plaza x 9AG105, Progeny expectations: VDRF, Priority: High. How will RR families compare to B families?	207	200	fair	U	U	0	0	0.1	2014-06-02	2014-05-12	4	35	0	0
4XGW	201	Parents: gg102 x Wind, Progeny Expectations: ?.  Priority: High. Seed produced late in 2013, but did not send to Rakers until 2014.  Most are GA types (from RNE), from 2013. Compare to U07m low performing GA/AGs. 	48	163	poor	U	U	0	300	0.34	2014-06-02	2013-05-24	3	34	0	0
5XRB	203	Parents: 9AG105 x CAG177, Progeny Expectations: VDRF, Priority: High.  9AG105 is bisexual, compare to reciprocal 9xBR.	200	65	fair 	U	U	0	300	0.35	2014-06-02	2014-05-12	4	38	0	0
8XBG	206	Parents: CAG204 x gg101, Progeny Expectations: VDRF, Priority: Med.  Compare to AGs with gg101 that did poorly in U07M 	66	49	fair	U	Y	0	1200	0.37	2014-06-02	2014-05-12	4	22	0	0
9XBR	207	Parents: CAG204 x 9AG105, Progeny Expectations: VDRF, Priority: High.  9AG105 is bisexual, compare to 5xRB	66	200	fair 	U	U	0	0	0.04	2014-06-02	2014-05-12	4	37	0	0
1XARG	208	The female is a vigorous performer at CSSE and Minnesota at age 11. The GG12 male is a well formed, highly figured wild P. Grandidentata ~40 year old tree near SE Grand Rapids. This cross should help show how fertile the AAG backcross is to native bigtooth. Progeny is expected to be highly variable with poor seed viability and some clones may have figured wood.  Progeny Expectations=G	43	220	The fertilized aag2002 flowers were sparce but appeared healthy with healthy/full ovaries. Started fertilized flowers at 1/2 inch.	U	U	0	200	0.05	2016-05-16	2016-04-18	4	28	https://drive.google.com/open?id=0B7-SwoTVeWFaV2lsbXdkQkVRN0U	0
2XARW	209	The female is a vigorous performer at CSSE and Minnesota at age 11 and the male is the Wind. The open pollinated branches were harvested on 4/19 after the catkins were fertilized. This cross should help show how fertile the AAG backcross is to native area native aspens and other plantation aspens at the CSSE site. Progeny is expected to be highly variable with poor seed viability.  Progeny Expectations=None	43	163	The fertilized aag2002 flowers were very sparce (more than 1xARG) with much less ovaries. Seven 4-5 foot branches were harvested and the catkins were thinned down to about 40 before seed was harvested. About 200 seeds were collected on 5/4/16	U	U	0	200	0.06	2016-05-16	2016-05-03	4	40	https://drive.google.com/open?id=0B7-SwoTVeWFaV2lsbXdkQkVRN0U	0
6XGG	210	The female is a vigorous performing bigtooth 1xGG ortet at RNE at age 24 and used in many crosses. The GG12 male is a well formed, highly figured wild P. Grandidentata ~40 year old tree near SE Grand Rapids. This GG cross may produce highly figured native selections. Perhaps the progeny could be mated with other figured GG selections having different figure to produce a variety of different figure patterns.  Progeny Expectations=FG	48	220	The fertilized gg102 flowers were dense and appeared healthy/full ovaries. Started fertilizing flowers at 1/2 inch long, noted a range of receptivity both on each flower and on the branches. Best time to start fertilizing may be when flower is 1 inch long.	U	Y	0	2000	0.44	2016-05-16	2016-04-17	4	10	https://drive.google.com/open?id=0B7-SwoTVeWFaV2lsbXdkQkVRN0U	0
2XAC91	217	All seed failed.	9	64	Seed failed	U	U	Y	0	0	1111-11-11	1991-04-01	1.2	29	0	0
24XAA91	216	Poor seed, likely failed.	22	23	0	U	U	Y	0	0	1111-11-11	1991-04-01	1.2	3	0	0
19XAA91	215	Pollen from Korea via Dr. Eui Rae Noh of Suwon South Korea from albas originating from Italy. One seedling was produced.	9	315	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
24XR	211	The female is a vigorous performer at CSSE at age 11. The GG12 male is a well formed, highly figured wild P. Grandidentata ~40 year old tree near SE Grand Rapids.  Progeny Expectations=VFG. No seedlings survived at Rakers.	221	220	The fertilized 82aa4 flowers were somewhat sparce but weak with weak/small ovaries. Perhaps flowers were fertilzed too early (@ 1/2 inch) but should be ~1 inch. About 45 seeds were produced from this cross.	U	U	0	0	0.01	2016-04-19	2016-04-19	4	16	https://drive.google.com/open?id=0B7-SwoTVeWFaV2lsbXdkQkVRN0U	0
25XR	212	The female is a vigorous, well formed ortet at CSSE at age 11, perhaps the best 83x on that site. The GG12 male is a well formed, highly figured wild P. Grandidentata ~40 year old tree near SE Grand Rapids. This AG cross may produce vigorous, good rooting figured aspen selections, which could also make better rooting progeny when mated with a P. Canescens (eg. C173). It is the highest priority 2016 cross.  Progeny Expectations=VDRFG	162	220	The fertilized 83aa301 flowers were dense and appeared healthy/full ovaries. Started fertilizing flowers at 1/2 inch.	U	Y	0	2000	0.84	2016-04-17	2016-04-17	4	16	https://drive.google.com/open?id=0B7-SwoTVeWFaV2lsbXdkQkVRN0U	0
3XAAE07	239	The male is Grober and is for Purdue only.  Sent about 20,250 seeds of questionable germination to Dr.Rick Meilan and Youran Fan on 4/15/2007.  	11	332	Questionable germination results due to using MiracleGro peat moss that has fertilizer and kills the meristem.  Estimated germination to be 30% as that was the highest test result and previous crosses were 45%.	U	U	Y	0	0.3	2007-04-16	2007-04-15	2	9	0	0
6XAGA90	238	Seed and cross failed.	324	5	Seed and cross failed.	U	U	Y	0	0	1111-11-11	1990-04-01	1.1	27	0	0
5XAGA90	237	Seed and cross failed.	323	5	Seed and cross failed.	U	U	Y	0	0	1111-11-11	1990-04-01	1.1	27	0	0
16XGA92	236	Seed and cross failed.	318	24	Seed and cross failed.	U	U	Y	0	0	1111-11-11	1992-04-01	1.2	7	0	0
23XAAG92	235	Seed and cross failed.	29	319	Seed and cross failed.	U	U	Y	0	0	1111-11-11	1992-04-01	1.2	26	0	0
22XAAG92	234	Seed and cross failed.	9	319	Seed and cross failed.	U	U	Y	0	0	1111-11-11	1992-04-01	1.2	26	0	0
52XAA92	233	Seed and cross failed.	29	320	Seed and cross failed.	U	U	Y	0	0	1111-11-11	1992-04-01	1.2	3	0	0
51XAA92	232	Seed and cross failed.	29	23	Seed and cross failed.	U	U	Y	0	0	1111-11-11	1992-04-01	1.2	3	0	0
49XAA92	231	Seed and cross failed.	12	320	Seed and cross failed.	U	U	Y	0	0	1111-11-11	1992-04-01	1.2	3	0	0
48XAA92	230	Seed and cross failed.	12	23	Seed and cross failed.	U	U	Y	0	0	1111-11-11	1992-04-01	1.2	3	0	0
5XTG91	229	Cross failed 	67	316	Cross failed 	U	U	Y	0	0	1111-11-11	1991-04-01	1.2	5	0	0
6XTG91	228	0	67	317	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	5	0	0
37XAA91	227	Fair seed quality, but may not have been planted.	30	21	Fair seed quality	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
18XGAA91	226	Poor seed, failed	59	21	Poor seed, failed	U	U	Y	0	0	1111-11-11	1991-04-01	1.2	27	0	0
7XAG91	225	Poor seed, failed	57	21	Poor seed, failed	U	U	Y	0	0	1111-11-11	1991-04-01	1.2	6	0	0
2XAGC91	224	Poor seed, failed	57	64	Poor seed, failed	U	U	Y	0	0	1111-11-11	1991-04-01	1.2	30	0	0
3XEA91	223	Poor seed, failed	72	23	0	U	U	Y	0	0	1111-11-11	1991-04-01	1.2	25	0	0
2XEG91	222	Poor seed, failed	72	50	0	U	U	Y	0	0	1111-11-11	1991-04-01	1.2	23	0	0
6XGA91	221	very poor seed, not planted	51	6	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	7	0	http://pmcgovern.us/r4stdb/dbkiss.php
5XGA91	220	very poor seed, not planted	51	7	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	7	0	0
2XGG91	219	0	51	317	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	10	0	0
2XEA91	218	Poor seed, failed	72	7	0	U	U	Y	0	0	1111-11-11	1991-04-01	1.2	25	0	0
18XAA91	214	Poor seed.	9	314	Poor seed.	U	U	Y	0	0	1111-11-11	1991-04-01	1.2	6	0	0
10XAGA91	213	Poor seed, failed cross.	56	21	Poor seed, failed cross.	U	U	Y	0	0	1111-11-11	1991-04-01	1.2	27	0	0
7XBT	205	Parents: CAG204 x ST11, Progeny Expectations: VDRF, Priority: Med.  Compare to BG families.	66	209	good	U	U	Y	200	0.88	2014-06-02	2014-05-12	4	41	0	0
6XBA	204	Parents: CAG204 x NFA, Progeny Expectations: VDR, Priority: Med. NFA is vigorous but in many crosses	66	19	fair	U	U	Y	300	0.41	2014-06-02	2014-05-12	4	20	0	0
4XRR	202	Parents: Plaza x AGRR1, Progeny Expectations: VDRFG, Priority: High.  How will RR families compare to B families?	207	61	poor	U	U	Y	600	0.06	2014-06-02	2014-05-12	4	35	0	0
22XBG	198	Parents: CAG204 x G4, Progeny expectations: VDRF, Priority: Med. G4 has good form, many flowers.	66	210	good	U	U	Y	800	0.76	2014-06-02	2014-05-12	4	22	0	0
19XGB	194	Parents: G5 x CAG177, Progeny expectations: VDRFG, Priority: High. G5 may have  Figured Wood.	211	65	poor	U	U	Y	0	0.33	2014-06-02	2014-05-12	4	21	0	0
18XBG	193	Parents: CAG204 x G6, Progeny expectations: VDRFG, Priority: High.  G6 has Figured Wood from UP Michigan.	66	212	good	U	U	Y	1300	0.38	2014-06-02	2014-05-12	4	22	0	0
14XB	189	Parents: C173 x AGRR1, Progeny expectations: VDRFG, Priority: High. AGRR1 has low figured wood but good veneer peeling qualities.	179	61	good	U	U	Y	500	0.63	2014-06-02	2014-05-12	4	15	0	0
12XRB	187	Parents: Plaza x CAG177. Progeny expectations: VDRF. Priority: Med. Compare to 3xRR.	207	65	fair	U	U	Y	300	0.08	2014-06-02	2014-05-12	4	38	0	0
11XAB	186	Parents: A266 x CAG177, A266 female is vigorous, CAG177 male has good form/rooting.  Progeny expectations: VDR, Priority: High.	9	65	fair 	U	U	Y	0	0.67	2014-06-02	2014-05-12	4	19	0	0
10XBR	185	Parents: CAG204 x AGRR1, Progeny expectations: VDRFG, Priority: High, (may have figured progeny). 	66	61	Fair. Seed not sent to Rakers in 2014,since its the same cross as 5xCAGR.	U	U	Y	200	0	2014-06-02	2014-05-12	4	37	0	0
5XCAGR	181	Progeny seedlings have itnermediate alba/aspen leaf traits.  	66	61	Seedlings had a 81/100 useable count - ranking second out of the 6 crosses.	U	U	Y	500	0.85	2013-05-10	2013-04-21	3	37	0	0
4XACAG	180	The male parent CAG177 was thought to be sterile but this cross proves it is fertile.  Progeny seedlings show intermediate leaf traits, good vigor and uniformity.  	11	65	Seedlings had a 64/100 useable count - ranking fourth out of the 6 crosses.	U	U	Y	500	0.7	2013-05-10	2013-04-13	3	19	0	0
3XBC	174	Renamed from 3XCAGC - Progeny seedlings exhibit intermediate leaf and tomentose characteristics, but may have more CAG204 wider leaves than 5xCAGR.	66	63	Seedlings had a 87/100 useable count - ranking first out of the 6 crosses. 3xCAGC seedlings had the best 2013 seedling quality at Rakers. 	U	U	Y	500	0.92	2013-05-10	2013-04-14	3	36	0	0
86XAA10	167	Priority set at seed harvest set at High since progeny may have vigorous, individuals with fair form, rooting and durability.	11	19	0	U	U	Y	0	0.78	2010-06-02	2010-04-01	3	3	0	0
2XAAE06	151	The male is Grober and is for Purdue only.  Summary from: Ran on 5/17/06: 3052 seedlings grown at Purdue after 25 days.  The germination ratio should be 44.67%.  	11	332	0	U	U	Y	0	0.45	2005-05-17	2006-04-01	2	9	0	0
1XAAE05	150	The male is Grober and is for Purdue only. 	11	332	Probably had the same seed germination as 2XAAE06 but did not confirm.	U	U	Y	0	-1	1111-11-11	2005-04-01	2	9	0	0
9XAGA91	148	0	57	7	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	27	0	0
9XAG91	147	22 trees planted at RNE (well drained, fertile site) in 1992.  These are biased trees since 2 nearby rows are dead?  Trees show variation for vigor, form and annual BLD infection.  Scored the 21 surviving trees for BLD (0-3 0=none, 3=high).   One tree (#3 from South) did not have any BLD in 4 scored years: 2002, 2004, 2005, 2009. However this tree scored a 1 in 1996. Noted 2 zero BLD 9xAG91 trees in 2002, 4 zero BLD trees in 2009.	30	50	0	U	Y	Y	0	-1	1111-11-11	1991-04-01	1.2	6	0	0
9XAA90	146	Ranked #2 at MSU Escanaba at age 10 (6.3 dia)	9	5	0	U	Y	Y	0	-1	1111-11-11	1990-04-01	1.1	3	0	0
8XAGA91	145	One tree planted at RNE, which has excellent form, but bld too (2009).	57	64	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	27	0	0
8XAG91	144	2 different color seed batches were noticed. Seed batch collected on 4/10/91 was red colored. Batch collected on 4/14/91 was white colored. Concerned if batch was mixed with 21xaa9??  	11	50	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	6	0	0
8XAA90	143	Notes indicate good performance at ISU on 8/5/99. Ranked #18 at MSU (5 dia) but is same cross as 32xaa91(#2 rank) and both of these crosses did the same at PMG's RNE site.  This clone was considered a “Generalist” clone in the paper:  “Biomass and Genotype × Environment Interactions of Populus Energy Crops in the Midwestern United States”.  20 planted at RNE.	9	7	0	W	Y	Y	0	-1	1111-11-11	1990-04-01	1.1	3	0	0
7XTG93	136	0	74	60	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	5	0	0
7XGA91	135	0	51	23	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	7	0	0
7XAGA91	134	0	57	21	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	27	0	0
7XAA90	133	A lot of seed was produced.  This family did quite well at 10 yrs at MSU's Escanaba site (#2 rank @ 6.3 avg dia)	9	8	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	3	0	0
75XAA95	128	Sent seed to Fred Eales of Wyoming.	9	23	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
74XAA95	127	Sent seed to Fred Eales of Wyoming.	25	23	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
6XAA89	122	1 seed survived. Planted at CSSE. Poor form fair vigor.	9	5	0	U	U	Y	0	-1	1111-11-11	1989-04-01	1.1	3	0	0
67XAA93	119	FAILED - no seedlings	11	19	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
66XAA93	118	0	11	18	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
65XAA93	117	0	11	17	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
64XAA93	116	FAILED - no seedlings	11	16	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
63XAA93	115	0	11	15	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
62XAA93	114	8/31/09: Found one really nice tree at RNE (2009). Quite vigorous, reasonable form.  No observed BLD.	11	13	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
61XAA93	113	0	11	14	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
60XAA93	112	0	9	19	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
5XTG93	111	0	67	50	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	5	0	0
5XAE91	110	0	30	73	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	9	0	0
5XAA89	109	This family has interesting traits, vigorous, variability.  2 selections are aa510, aa511 that have some rootability. Does not appear to be durable. Planted at ISU, CSSE, HCRA	11	23	0	U	Y	Y	0	0.4	1111-11-11	1989-04-01	1.1	3	0	0
59XAA93	108	0	9	18	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
58XAA93	107	The Male Pollen is from Itally.	9	17	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
57XAA93	106	The Male Pollen is from Itally.	9	16	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
56XAA93	105	The Male Pollen is from Itally.	9	15	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
55XAA93	104	FAILED - no seedlings	9	13	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
54XAA93	103	The Male Pollen is from Itally.	9	14	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	3	0	0
50XAA92	101	0	29	24	0	U	U	Y	0	-1	1111-11-11	1992-04-01	1.2	3	0	0
4XTG91	100	Trees planted at RNE (12), SLSE (7), Vogel Center in 1992 and 64 grown at DNR.  This cross attempted to replicate the #1 MSU P. smithii cross at Water Quality.  Produced 200+- seeds of good viability.  One selection planted in 1992 at MSUs UP site. 	67	50	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	5	0	0
4XAGA90	99	Female is arenaAG by the GR Stadium Arena on NE side.	322	5	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	27	0	0
4XAG90	98	0	20	52	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	6	0	0
4XAE91	97	0	4	73	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	9	0	0
4XAA89	96	Female parent is A316  from Canada. Planted 11 at CS and HCRest area.  8/22/09: Runts at CS, at least 2 good ones at HCR, will test for rooting.	325	23	0	U	Y	Y	0	0.45	1111-11-11	1989-04-01	1.1	3	0	0
47XAA92	95	0	12	24	0	U	U	Y	0	-1	1111-11-11	1992-04-01	1.2	3	0	0
46XAA92	94	Same as 1xaa85, 2xaa88, 75xaa95	9	23	0	U	U	Y	0	-1	1111-11-11	1992-04-01	1.2	3	0	0
45XAA92	93	The Male Tanaro pollen is from Italy and needs to be added	9	321	0	U	U	Y	0	-1	1111-11-11	1992-04-01	1.2	3	0	0
44XAA92	92	The Male Tevere2 pollen is from Italy and needs to be added...	9	320	0	U	U	Y	0	-1	1111-11-11	1992-04-01	1.2	3	0	0
43XAA92	91	0	9	24	0	U	U	Y	0	-1	1111-11-11	1992-04-01	1.2	3	0	0
41XAA91	88	A very diverse, heterozygous population.  50/50 wide/fastigate. Fastigate trees weak, wide trees have good form/vigor.  Ranked #18 at MSU's Escanaba site at age 10 (5.0). Male is fastigate Bolleana.  PMG planted 75 at RNE.  2 have very good form.	4	3	0	U	Y	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
40XAA91	87	Ranked #8 at MSU's Escanaba site at age 10 (5.9).	4	6	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
3XTG90	86	0	69	53	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	5	0	0
3XAGA90	85	0	56	7	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	27	0	0
3XAG90	84	0	29	52	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	6	0	0
3XAA89	83	Planted 6 at Cedar Springs & 131. Frequent dieback for several years perhaps frost injury related.  Later it resprouted, trees grew dense, tall and straight. Notes inidate A10 held a lot of seed and had very good germination.. Planted at ISU, CSSE, HCRA.	4	23	0	U	Y	Y	0	0.7	1111-11-11	1989-04-01	1.1	3	0	0
39XAA91	82	The PCA2 flowers were purposefully or mistakenly pollinated with a mix of these males:  Yugo2, Turkey2, PA092	30	10	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
36XAA91	81	Only 11 trees survived.  All  planted at PMG's RNE site.  An interesting, variable family.	11	21	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
35XAA91	80	Ranked #11 at MSU's Escanaba site at age 10 (5.6).	30	23	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
33XAA91	79	Ranked #30 at MSU's Escanaba site at age 10 (4.6). Same as 3xaa89	4	23	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
32XAA91	78	Ranked #2 at MSU's Escanaba site at age 10 (6.3). 	9	7	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
31XAA91	77	Ranked #14 at MSU's Escanaba site at age 10 (5.3). 	9	64	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
30XAA91	76	Ranked #2 at MSU's Escanaba site at age 10 (6.3) with very consistent performance across all reps.  Trees are vigorous, have poor form & possible rooting potential.  47 selection 10% rooting (4/40) in 2004.	30	6	0	U	Y	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
2XTG90	75	0	67	52	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	5	0	0
2XT4E04	74	The male is a tetraploid from Michigan Tree Improvement Center.	45	40	0	U	U	Y	0	0.38	2004-04-23	2004-04-01	2	32	0	0
2XGT91	73	0	51	68	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	4	0	0
2XGAG91	72	0	59	317	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	28	0	0
2XGAE91	71	0	59	73	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	31	0	0
2XGA88	70	Female parent is seitsmabt (8 and Knapp St)	334	23	0	U	U	Y	0	-1	1111-11-11	1988-04-01	1.1	7	0	0
2XAGA90	69	0	56	5	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	27	0	0
2XAG90	68	0	9	52	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	6	0	0
2XAAG88	67	0	9	60	0	U	U	Y	0	-1	1111-11-11	1988-04-01	1.1	26	0	0
2XAA88	66	Vigorous, poor form.  Listed in annual report 1989-90 Hall, Hart, McNabb as #2 rated for growth.	9	23	0	U	Y	Y	0	-1	1111-11-11	1988-04-01	1.1	3	0	0
29XAA91	65	0	9	10	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
28XAA91	64	3 is Bolleana, 1/2 of progeny will be fastigate.	9	3	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
27XAA91	63	0	4	7	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
26XAA91	62	0	30	3	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
25XAA91	61	0	9	28	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
23XAA91	60	Ranked #7 at MSU's Escanaba site at age 10 (6.2).  11/1/03 Observations at RNE: Big tree, bad form, no BLD. Still had leaves on (late leaf drop).	30	7	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
22XAA91	59	Ranked #10 at MSU's Escanaba site at age 10 (5.8)	11	7	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
21XAA91	57	Male is fastigate Bolleana.  Progeny is 1/2 fastigate. Some of these seedlings have fairly good rooting (AA2101). 	11	3	0	U	Y	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
20XAAG91	56	Some individuals are quite vigourous - made 3 selections.  Made crosses with these selections which were very dificult. Very few survivors, mostly runts?  Trees planted at DNR (45), ISU (38), MSU (32?), MBP (15 at RNE, 8 at SLSE).   Two selections at RNE (eg AAG2001) and one at SLSE (AAG2002)	9	56	0	U	U	Y	0	0.95	1111-11-11	1991-04-01	1.2	26	0	0
20XAA91	55	Ranked #14 at MSU's Escanaba site at age 10 (5.3)	9	21	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
1XTT91	54	0	67	68	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	11	0	0
1XTG90	53	0	67	53	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	5	0	0
1XTE04	52	The male, TA483 is from Michigan Tree Improvement Center.	45	333	0	U	U	Y	0	0.35	1111-11-11	2004-04-01	2	32	0	0
1XT4E04	51	The male is a tetraploid from Michigan Tree Improvement Center.	75	40	0	U	U	Y	0	0.45	2004-04-23	2004-04-01	2	32	0	0
1XGT90	50	This is actually a backcross to bigtooth since st3 is likely a P.smithii	54	70	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	4	0	0
1XGG91	49	Produced about 3000 seeds. Rakers grew  the seedlings. Sent about 700 seeds to Yugoslavia. DNR grew about 700 trees. The seedlings were so small they had to plant them as 1-1 stock. PMG planted 32 at RNE. 	51	50	0	U	Y	Y	0	-1	1111-11-11	1991-04-01	1.2	10	0	0
1XGE91	48	Nice vigorous trees, some with good form.  14 planted at RNE.	51	73	500+ seeds produced	U	Y	Y	0	-1	1111-11-11	1991-04-01	1.2	24	0	0
1XGAG91	47	0	51	60	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	28	0	0
1XGAAG91	46	0	59	60	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	27	0	0
1XGA84	45	Female is a bigtooth from Jerry Seitsma's Orchard (Knapp/8 in GR,MI) Poor rooter, fair vigor, form?  	334	23	0	U	U	Y	0	-1	1111-11-11	1984-04-01	-1	7	0	0
1XEE91	44	Nice vigorous trees.  All 14 are dead at RRNE at age 12.  The issue eemed to spread from South to North.	72	73	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	12	0	0
1XAT90	43	This is misnamed.  The male parent is a wild P. smithii.  Should be 1xatg90.  	20	70	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	9	0	0
1XAGE91	42	0	57	73	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	31	0	0
1XAGC91	41	0	56	64	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	30	0	0
1XAGA88	40	0	57	23	0	U	U	Y	0	-1	1111-11-11	1988-04-01	1.1	27	0	0
1XAG88	39	0	9	52	0	U	U	Y	0	-1	1111-11-11	1988-04-01	1.1	6	0	0
1XAE91	38	0	9	73	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	9	0	0
1XAC91	37	0	4	64	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	29	0	0
1XAAG88	36	0	9	56	0	U	U	Y	0	-1	1111-11-11	1988-04-01	1.1	26	0	0
19XAAG91	35	0	30	60	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	26	0	0
17XAAG91	32	0	4	60	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	26	0	0
17XAA91	31	0	4	21	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
16XAG93	30	0	11	55	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	6	0	0
16XAAG91	29	0	11	60	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	26	0	0
16XAA91	28	0	4	10	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	3	0	0
15XTG93	27	0	152	60	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	5	0	0
15XAGA91	26	0	57	23	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	27	0	0
15XAG91	25	Performed well at FBIC	4	50	0	U	Y	Y	0	-1	1111-11-11	1991-04-01	1.2	6	0	0
15XAA90	24	30 seedlings grown at ISU. 24 planted at MSU in 1992.	20	7	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	3	0	0
14XTG93	23	0	151	55	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	5	0	0
14XGAA91	22	0	59	23	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	27	0	0
14XAG91	21	Male parent is m1bt - Need to research that parent	4	1	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	6	0	0
14XAA90	20	17 seedlings grown at ISU. 12 planted at PMG's RNE in 1992.	20	5	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	3	0	0
13XTG93	19	0	151	60	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	5	0	0
13XGAG91	18	0	59	50	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	28	0	0
13XAG91	17	Male parent is btshelby - Need to research that parent	4	1	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	6	0	0
13XAA90	16	Ranked 30th at MSU's Escanaba 10 growth @ 4.6	29	7	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	3	0	0
12XTG93	15	0	150	55	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	5	0	0
12XGAA91	14	0	59	7	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	27	0	0
12XAG91	13	0	9	60	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	6	0	0
12XAA90	12	Good performance at ISU noted on 8/5/99.  May have rooting potential.	29	8	0	U	Y	Y	0	-1	1111-11-11	1990-04-01	1.1	3	0	0
11XTG93	11	0	150	60	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	5	0	0
11XAAG91	10	This clone was considered a “Specialist” clone in the paper:  “Biomass and Genotype × Environment Interactions of Populus Energy Crops in the Midwestern United States”. Planted 18 at RNE.	9	60	0	U	Y	Y	0	-1	1111-11-11	1991-04-01	1.2	26	0	0
11XAA90	9	All seed failed.	39	7	All seed failed.	U	U	Y	0	0	1111-11-11	1990-04-01	1.1	3	0	0
10XTG93	8	0	149	50	0	U	U	Y	0	-1	1111-11-11	1993-04-01	1.2	5	0	0
10XGA91	7	0	51	21	0	U	U	Y	0	-1	1111-11-11	1991-04-01	1.2	7	0	0
2XA4E05	6	Poor seed set, perhaps pollinated too early (2/9/05) Harvested about 200 seeds on 3/6/05.  All of these trees had a chlorotic leaf condition that may be serious...	9	40	0	U	U	Y	0	-1	1111-11-11	2005-04-01	2	9	0	0
1XA4E05	5	Poor seed set, perhaps pollinated too early (2/9/05) planted 130 seeds  indoors on 3/5/05.  Performed a PIP test.  All but 1 rooted.  The #8 test tree had weak rooting on 2 cuttings.  All of these trees had a chlorotic leaf condition that may be serious...  Observed poor performance/survivabity at CSSE and most have a root crown fungus issue	11	40	0	U	U	Y	0	-1	1111-11-11	2005-04-01	2	9	0	0
10XAA90	4	Only 4 seedlings from ISU were grown and planted at PMG's RNE	39	5	0	U	U	Y	0	-1	1111-11-11	1990-04-01	1.1	3	0	0
1XAA85	3	About 15 seedlings produced. ISU had good observations with this family. A 1992 female selection 27 had good form/vigor but lots of branch canker typical of some albas.	9	23	0	W	U	Y	0	-1	1111-11-11	1985-04-01	1.1	3	0	http://pmcgovern.us/r4stdb/dbkiss.php
\.


--
-- Name: family_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('family_id_seq', 1, false);


--
-- Data for Name: field_trial; Type: TABLE DATA; Schema: public; Owner: user
--

COPY field_trial (field_trial_key, id, notes, notes2, notes3, planted_order, live_quantity, is_plus_ynu, live_dbh_cm, live_height_cm, leaf_score, canker_score, tree_spacing_ft, row_nbr, column_nbr, replication_nbr, plot_nbr, block_nbr, id_test_spec, id_site) FROM stdin;
TBD	-1	Dummy record used for id_prev_test_detail null values	1	0	-1	-1	0	-1	-1	-1	-1	U   	-1	-1	-1	-1	-1	2	2
TBD	1	To Be Determined	1	0	-1	-1	0	-1	-1	-1	-1	U   	-1	-1	-1	-1	-1	2	2
NA	2	Does Not Apply	2	0	-1	-1	0	-1	-1	-1	-1	U   	-1	-1	-1	-1	-1	2	2
gg8	4	Notes - PostNE - WEST Edge (Rows WtoE)  Planted with JRM (1.25/gallon).  aka clone E4	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	1	-1	1	1	25	9
4gw10	5	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	2	-1	1	1	25	9
2bg7	6	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	3	-1	1	1	25	9
16ab2	7	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	4	-1	1	1	25	9
4gw13	8	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	5	-1	1	1	25	9
20bs7	9	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	6	-1	1	1	25	9
20bs3	10	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	7	-1	1	1	25	9
16ab3	11	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	8	-1	1	1	25	9
4acag7	12	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	9	-1	1	1	25	9
80aa3mf	13	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	10	-1	1	1	25	9
80aa3mf	14	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	11	-1	1	1	25	9
89aa1	15	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	12	-1	1	1	25	9
89aa1	16	No JRM	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	13	-1	1	1	25	9
2b22	17	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	14	-1	1	1	25	9
2b25	18	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	15	-1	1	1	25	9
dn34	19	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	16	-1	1	1	25	9
dn34	20	No JRM	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	17	-1	1	1	25	9
dn34	21	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	18	-1	1	1	25	9
dn34	22	No JRM	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	19	-1	1	1	25	9
dn34	23	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	20	-1	1	1	25	9
1bw6	24	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	21	-1	1	1	25	9
1bw6	25	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	22	-1	1	1	25	9
105aa5	26	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	23	-1	1	1	25	9
105aa5	27	No JRM	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	24	-1	1	1	25	9
1bw1	28	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	25	-1	1	1	25	9
20bs1	29	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	26	-1	1	1	25	9
1bw1	30	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	27	-1	1	1	25	9
97aa11	31	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	28	-1	1	1	25	9
3cagc3	32	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	29	-1	1	1	25	9
4acag9	33	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	30	-1	1	1	25	9
4acag9	34	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	31	-1	1	1	25	9
92aa11	35	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	32	-1	1	1	25	9
92aa11	36	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	33	-1	1	1	25	9
2b6	37	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	34	-1	1	1	25	9
2b6	38	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	35	-1	1	1	25	9
4acag4	39	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	36	-1	1	1	25	9
4acag4	40	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	37	-1	1	1	25	9
101aa11	41	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	38	-1	1	1	25	9
101aa11	42	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	39	-1	1	1	25	9
101aa11	43	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	40	-1	1	1	25	9
2b4	44	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	41	-1	1	1	25	9
2b64	45	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	42	-1	1	1	25	9
2b50	46	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	43	-1	1	1	25	9
2b62	47	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	44	-1	1	1	25	9
c173	48	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	45	-1	1	1	25	9
c173	49	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	46	-1	1	1	25	9
c173	50	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	47	-1	1	1	25	9
98aa11	51	Planted with JRM (1.25/gallon), Whip with 1 inch roots	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	48	-1	1	1	25	9
98aa11	52	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	49	-1	1	1	25	9
98aa11	53	Planted with JRM (1.25/gallon), Whip with 1 inch roots	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	50	-1	1	1	25	9
101aa11	54	Planted with JRM (1.25/gallon), Whip with 1 inch roots	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	51	-1	1	1	25	9
101aa11	55	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	52	-1	1	1	25	9
101aa11	56	Planted with JRM (1.25/gallon), Whip with 1 inch roots	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	1	53	-1	1	1	25	9
98aa11	287	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	60	-1	44	2	27	9
105aa3	57	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	54	-1	1	1	25	9
16ab7	58	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	55	-1	1	1	25	9
105aa5	59	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	1	56	-1	1	1	25	9
4gw11	60	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	1	-1	2	1	25	9
2b73	61	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	2	-1	2	1	25	9
4gw12	62	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	3	-1	2	1	25	9
2b68	63	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	4	-1	2	1	25	9
16ab4	64	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	5	-1	2	1	25	9
16ab8	65	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	6	-1	2	1	25	9
20bs9	66	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	7	-1	2	1	25	9
16ab1	67	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	8	-1	2	1	25	9
98aa11	68	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	9	-1	2	1	25	9
98aa11	69	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	10	-1	2	1	25	9
98aa11	70	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	11	-1	2	1	25	9
98aa11	71	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	12	-1	2	1	25	9
2b29	72	No JRM - May have figured wood	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	13	-1	2	1	25	9
97aa11	73	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	14	-1	2	1	25	9
zoss	74	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	15	-1	2	1	25	9
2b6	75	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	16	-1	2	1	25	9
100aa12	76	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	17	-1	2	1	25	9
95aa11	77	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	18	-1	2	1	25	9
95aa11	78	No JRM	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	19	-1	2	1	25	9
105aa3	79	No JRM - whips with small roots	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	20	-1	2	1	25	9
105aa3	80	No JRM - whips with small roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	21	-1	2	1	25	9
14b7	81	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	22	-1	2	1	25	9
105aa3	82	No JRM	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	23	-1	2	1	25	9
105aa3	83	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	24	-1	2	1	25	9
zoss	84	No JRM	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	25	-1	2	1	25	9
zoss	85	No JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	26	-1	2	1	25	9
2b3	86	100% 2b3 has JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	27	-1	2	1	25	9
2b3	87	Lost tag, verify. Has JRM	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	28	-1	2	1	25	9
2b3	88	Lost tag, verify. Has JRM	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	29	-1	2	1	25	9
2b25	89	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	30	-1	2	1	25	9
2b25	90	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	31	-1	2	1	25	9
100aa11	91	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	32	-1	2	1	25	9
100aa11	92	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	33	-1	2	1	25	9
100aa11	93	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	34	-1	2	1	25	9
100aa12	94	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	35	-1	2	1	25	9
100aa12	95	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	36	-1	2	1	25	9
97aa12	96	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	37	-1	2	1	25	9
97aa12	97	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	38	-1	2	1	25	9
2b71	98	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	39	-1	2	1	25	9
2b22	99	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	40	-1	2	1	25	9
2b22	100	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	41	-1	2	1	25	9
2b22	101	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	42	-1	2	1	25	9
cag204	102	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	43	-1	2	1	25	9
2b21	103	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	44	-1	2	1	25	9
2b21	104	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	45	-1	2	1	25	9
2b6	105	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	46	-1	2	1	25	9
2b6	106	Planted with JRM (1.25/gallon), Whip with 1 inch roots	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	47	-1	2	1	25	9
2b6	107	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	48	-1	2	1	25	9
2b25	108	whip - 1 inch roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	49	-1	2	1	25	9
2b3	109	Planted with JRM (1.25/gallon), has good roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	50	-1	2	1	25	9
2b3	110	Planted with JRM (1.25/gallon), has good roots	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	51	-1	2	1	25	9
2b3	111	Planted with JRM (1.25/gallon), has good roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	52	-1	2	1	25	9
2b21	112	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	53	-1	2	1	25	9
2b21	113	Planted with JRM (1.25/gallon), Whip with 1 inch roots	Thin later	0	-1	1	U	1	-1	-1	-1	4x6 	2	54	-1	2	1	25	9
2b21	114	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	55	-1	2	1	25	9
2b21	115	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	55	-1	2	1	25	9
gg8	116	Notes - PostNE - WEST Edge (Rows WtoE) Planted with JRM (1.25/gallon).  aka clone E4	Start 2016 Measure	Dead	-1	0	U	0	-1	-1	-1	4x6 	1	1	-1	1	1	26	9
4gw10	117	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2	-1	-1	-1	4x6 	1	2	-1	1	1	26	9
2bg7	118	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.1	-1	-1	-1	4x6 	1	3	-1	1	1	26	9
16ab2	119	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.4	-1	-1	-1	4x6 	1	4	-1	1	1	26	9
4gw13	120	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.2	-1	-1	-1	4x6 	1	5	-1	1	1	26	9
20bs7	121	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1.9	-1	-1	-1	4x6 	1	6	-1	1	1	26	9
20bs3	122	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.6	-1	-1	-1	4x6 	1	7	-1	1	1	26	9
16ab3	123	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.6	-1	-1	-1	4x6 	1	8	-1	1	1	26	9
4acag7	124	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.3	-1	-1	-1	4x6 	1	9	-1	1	1	26	9
80aa3mf	125	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.8	-1	-1	-1	4x6 	1	10	-1	1	1	26	9
80aa3mf	126	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	2.9	-1	-1	-1	4x6 	1	11	-1	1	1	26	9
89aa1	127	No JRM	0	0	-1	1	U	2.1	-1	-1	-1	4x6 	1	12	-1	1	1	26	9
89aa1	128	No JRM	Thin later	0	-1	1	U	2.3	-1	-1	-1	4x6 	1	13	-1	1	1	26	9
2b22	129	No JRM	0	0	-1	1	U	2	-1	-1	-1	4x6 	1	14	-1	1	1	26	9
2b25	130	No JRM	0	0	-1	1	U	1.8	-1	-1	-1	4x6 	1	15	-1	1	1	26	9
dn34	131	No JRM	2017 get whips	0	-1	1	U	2.9	-1	-1	-1	4x6 	1	16	-1	1	1	26	9
dn34	132	No JRM	2017 get whips, thin later	0	-1	1	U	2.7	-1	-1	-1	4x6 	1	17	-1	1	1	26	9
dn34	133	No JRM	2017 get whips	0	-1	1	U	2.7	-1	-1	-1	4x6 	1	18	-1	1	1	26	9
dn34	134	No JRM	2017 get whips, thin later	Deer broke stem	-1	1	U	1.8	-1	-1	-1	4x6 	1	19	-1	1	1	26	9
dn34	135	No JRM	2017 get whips	0	-1	1	U	2.6	-1	-1	-1	4x6 	1	20	-1	1	1	26	9
1bw6	136	No JRM	0	0	-1	1	U	2.8	-1	-1	-1	4x6 	1	21	-1	1	1	26	9
1bw6	137	No JRM	0	0	-1	1	U	2.1	-1	-1	-1	4x6 	1	22	-1	1	1	26	9
105aa5	138	No JRM	0	0	-1	1	U	2.3	-1	-1	-1	4x6 	1	23	-1	1	1	26	9
105aa5	139	No JRM	Thin later	0	-1	1	U	2	-1	-1	-1	4x6 	1	24	-1	1	1	26	9
1bw1	140	Planted with JRM (1.25/gallon)	2017 get whips	0	-1	1	U	1.6	-1	-1	-1	4x6 	1	25	-1	1	1	26	9
20bs1	141	Planted with JRM (1.25/gallon)	2017 get whips	0	-1	1	U	3.4	-1	-1	-1	4x6 	1	26	-1	1	1	26	9
1bw1	142	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1.6	-1	-1	-1	4x6 	1	27	-1	1	1	26	9
97aa11	143	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	2.2	-1	-1	-1	4x6 	1	28	-1	1	1	26	9
3cagc3	144	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.9	-1	-1	-1	4x6 	1	29	-1	1	1	26	9
4acag9	145	Planted with JRM (1.25/gallon)	0	0	-1	1	U	3.2	-1	-1	-1	4x6 	1	30	-1	1	1	26	9
4acag9	146	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.8	-1	-1	-1	4x6 	1	31	-1	1	1	26	9
92aa11	147	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	2.5	-1	-1	-1	4x6 	1	32	-1	1	1	26	9
92aa11	148	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.4	-1	-1	-1	4x6 	1	33	-1	1	1	26	9
2b6	149	Planted with JRM (1.25/gallon)	2017 get whips, thin later	0	-1	1	U	1.7	-1	-1	-1	4x6 	1	34	-1	1	1	26	9
2b6	150	Planted with JRM (1.25/gallon)	2017 get whips, thin later	0	-1	1	U	1.4	-1	-1	-1	4x6 	1	35	-1	1	1	26	9
4acag4	151	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2	-1	-1	-1	4x6 	1	36	-1	1	1	26	9
4acag4	152	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2	-1	-1	-1	4x6 	1	37	-1	1	1	26	9
101aa11	153	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	2.4	-1	-1	-1	4x6 	1	38	-1	1	1	26	9
101aa11	154	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.5	-1	-1	-1	4x6 	1	39	-1	1	1	26	9
101aa11	155	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	2.7	-1	-1	-1	4x6 	1	40	-1	1	1	26	9
2b4	156	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.5	-1	-1	-1	4x6 	1	41	-1	1	1	26	9
2b64	157	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.6	-1	-1	-1	4x6 	1	42	-1	1	1	26	9
2b50	158	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2	-1	-1	-1	4x6 	1	43	-1	1	1	26	9
2b62	159	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1.7	-1	-1	-1	4x6 	1	44	-1	1	1	26	9
c173	160	Planted with JRM (1.25/gallon)	2017 get whips	0	-1	1	U	2.7	-1	-1	-1	4x6 	1	45	-1	1	1	26	9
c173	161	Planted with JRM (1.25/gallon)	2017 get whips, thin later	0	-1	1	U	2	-1	-1	-1	4x6 	1	46	-1	1	1	26	9
c173	162	Planted with JRM (1.25/gallon)	2017 get whips	0	-1	1	U	2.3	-1	-1	-1	4x6 	1	47	-1	1	1	26	9
98aa11	163	Planted with JRM (1.25/gallon), Whip with 1 inch roots	Thin later	0	-1	1	U	1.6	-1	-1	-1	4x6 	1	48	-1	1	1	26	9
98aa11	164	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1.4	-1	-1	-1	4x6 	1	49	-1	1	1	26	9
98aa11	165	Planted with JRM (1.25/gallon), Whip with 1 inch roots	Thin later	0	-1	1	U	1.6	-1	-1	-1	4x6 	1	50	-1	1	1	26	9
101aa11	166	Planted with JRM (1.25/gallon), Whip with 1 inch roots	Thin later	0	-1	1	U	2.2	-1	-1	-1	4x6 	1	51	-1	1	1	26	9
101aa11	167	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1.7	-1	-1	-1	4x6 	1	52	-1	1	1	26	9
101aa11	168	Planted with JRM (1.25/gallon), Whip with 1 inch roots	Thin later	0	-1	1	U	1.8	-1	-1	-1	4x6 	1	53	-1	1	1	26	9
105aa3	169	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1.7	-1	-1	-1	4x6 	1	54	-1	1	1	26	9
16ab7	170	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	2.1	-1	-1	-1	4x6 	1	55	-1	1	1	26	9
105aa5	171	Planted with JRM (1.25/gallon), Whip with 1 inch roots	0	0	-1	1	U	1.6	-1	-1	-1	4x6 	1	56	-1	1	1	26	9
4gw11	172	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.3	-1	-1	-1	4x6 	2	1	-1	2	1	26	9
2b73	173	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2	-1	-1	-1	4x6 	2	2	-1	2	1	26	9
4gw12	174	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.2	-1	-1	-1	4x6 	2	3	-1	2	1	26	9
2b68	175	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1.9	-1	-1	-1	4x6 	2	4	-1	2	1	26	9
16ab4	176	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.2	-1	-1	-1	4x6 	2	5	-1	2	1	26	9
16ab8	177	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.4	-1	-1	-1	4x6 	2	6	-1	2	1	26	9
20bs9	178	Planted with JRM (1.25/gallon)	0	0	-1	1	U	3.6	-1	-1	-1	4x6 	2	7	-1	2	1	26	9
16ab1	179	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.7	-1	-1	-1	4x6 	2	8	-1	2	1	26	9
98aa11	180	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	2.7	-1	-1	-1	4x6 	2	9	-1	2	1	26	9
98aa11	181	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.9	-1	-1	-1	4x6 	2	10	-1	2	1	26	9
98aa11	182	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	2.6	-1	-1	-1	4x6 	2	11	-1	2	1	26	9
98aa11	183	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	2.5	-1	-1	-1	4x6 	2	12	-1	2	1	26	9
2b29	184	No JRM - May have figured wood	2017 get whips	0	-1	1	U	2.8	-1	-1	-1	4x6 	2	13	-1	2	1	26	9
97aa11	185	No JRM	0	0	-1	1	U	2.7	-1	-1	-1	4x6 	2	14	-1	2	1	26	9
zoss	186	No JRM	0	0	-1	1	U	1.7	-1	-1	-1	4x6 	2	15	-1	2	1	26	9
2b6	187	No JRM	0	0	-1	1	U	1.3	-1	-1	-1	4x6 	2	16	-1	2	1	26	9
100aa12	188	No JRM	0	0	-1	1	U	2.8	-1	-1	-1	4x6 	2	17	-1	2	1	26	9
95aa11	189	No JRM	0	0	-1	1	U	2.5	-1	-1	-1	4x6 	2	18	-1	2	1	26	9
95aa11	190	No JRM	Thin later	0	-1	1	U	2.1	-1	-1	-1	4x6 	2	19	-1	2	1	26	9
105aa3	191	No JRM - whips with small roots	Thin later	0	-1	1	U	1.4	-1	-1	-1	4x6 	2	20	-1	2	1	26	9
105aa3	192	No JRM - whips with small roots	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	21	-1	2	1	26	9
14b7	193	No JRM	2017 get whips	0	-1	1	U	2	-1	-1	-1	4x6 	2	22	-1	2	1	26	9
105aa3	194	No JRM	Thin later	0	-1	1	U	2.3	-1	-1	-1	4x6 	2	23	-1	2	1	26	9
105aa3	195	No JRM	0	0	-1	1	U	2	-1	-1	-1	4x6 	2	24	-1	2	1	26	9
zoss	196	No JRM	Thin later	0	-1	1	U	1.6	-1	-1	-1	4x6 	2	25	-1	2	1	26	9
zoss	197	No JRM	0	0	-1	1	U	0.9	-1	-1	-1	4x6 	2	26	-1	2	1	26	9
2b3	198	100% 2b3 has JRM	2017 get whips	0	-1	1	U	1.8	-1	-1	-1	4x6 	2	27	-1	2	1	26	9
2b3	199	Lost tag, verify. Has JRM	2017 get whips, thin later	0	-1	1	U	1.3	-1	-1	-1	4x6 	2	28	-1	2	1	26	9
2b3	200	Lost tag, verify. Has JRM	2017 get whips	0	-1	1	U	1.5	-1	-1	-1	4x6 	2	29	-1	2	1	26	9
2b25	201	Planted with JRM (1.25/gallon)	2017 get whips	0	-1	1	U	2	-1	-1	-1	4x6 	2	30	-1	2	1	26	9
2b25	202	Planted with JRM (1.25/gallon)	2017 get whips, thin later	0	-1	1	U	1.9	-1	-1	-1	4x6 	2	31	-1	2	1	26	9
100aa11	203	Planted with JRM (1.25/gallon)	2017 get whips	0	-1	1	U	3.6	-1	-1	-1	4x6 	2	32	-1	2	1	26	9
100aa11	204	Planted with JRM (1.25/gallon)	2017 get whips, thin later	0	-1	1	U	3.3	-1	-1	-1	4x6 	2	33	-1	2	1	26	9
100aa11	205	Planted with JRM (1.25/gallon)	2017 get whips	0	-1	1	U	3.4	-1	-1	-1	4x6 	2	34	-1	2	1	26	9
100aa12	206	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	3.1	-1	-1	-1	4x6 	2	35	-1	2	1	26	9
100aa12	207	Planted with JRM (1.25/gallon)	0	0	-1	1	U	3.2	-1	-1	-1	4x6 	2	36	-1	2	1	26	9
97aa12	208	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	2.7	-1	-1	-1	4x6 	2	37	-1	2	1	26	9
97aa12	209	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	2.5	-1	-1	-1	4x6 	2	38	-1	2	1	26	9
2b71	210	Planted with JRM (1.25/gallon)	2017 get whips	0	-1	1	U	1.5	-1	-1	-1	4x6 	2	39	-1	2	1	26	9
2b22	211	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.5	-1	-1	-1	4x6 	2	40	-1	2	1	26	9
2b22	212	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1.9	-1	-1	-1	4x6 	2	41	-1	2	1	26	9
2b22	213	Planted with JRM (1.25/gallon)	0	0	-1	1	U	2.3	-1	-1	-1	4x6 	2	42	-1	2	1	26	9
cag204	214	Planted with JRM (1.25/gallon)	2017 get whips	0	-1	1	U	2	-1	-1	-1	4x6 	2	43	-1	2	1	26	9
2b21	215	Planted with JRM (1.25/gallon)	0	0	-1	1	U	1.5	-1	-1	-1	4x6 	2	44	-1	2	1	26	9
2b21	216	Planted with JRM (1.25/gallon)	Thin later	0	-1	1	U	1.2	-1	-1	-1	4x6 	2	45	-1	2	1	26	9
2b6	217	Planted with JRM (1.25/gallon), Whip with 1 inch roots	2017 get whips	0	-1	1	U	1.3	-1	-1	-1	4x6 	2	46	-1	2	1	26	9
2b6	218	Planted with JRM (1.25/gallon), Whip with 1 inch roots	2017 get whips, thin later	0	-1	1	U	1.1	-1	-1	-1	4x6 	2	47	-1	2	1	26	9
2b6	219	Planted with JRM (1.25/gallon), Whip with 1 inch roots	2017 get whips	0	-1	1	U	1	-1	-1	-1	4x6 	2	48	-1	2	1	26	9
2b25	220	whip - 1 inch roots	0	0	-1	1	U	1.3	-1	-1	-1	4x6 	2	49	-1	2	1	26	9
2b3	221	Planted with JRM (1.25/gallon), has good roots	0	0	-1	1	U	1.4	-1	-1	-1	4x6 	2	50	-1	2	1	26	9
2b3	222	Planted with JRM (1.25/gallon), has good roots	Thin later	0	-1	1	U	1.2	-1	-1	-1	4x6 	2	51	-1	2	1	26	9
2b3	223	Planted with JRM (1.25/gallon), has good roots	0	0	-1	1	U	1.1	-1	-1	-1	4x6 	2	52	-1	2	1	26	9
2b21	224	Planted with JRM (1.25/gallon), Whip with 1 inch roots	2017 get whips	0	-1	1	U	1.3	-1	-1	-1	4x6 	2	53	-1	2	1	26	9
2b21	225	Planted with JRM (1.25/gallon), Whip with 1 inch roots	2017 get whips, thin later	0	-1	1	U	0.8	-1	-1	-1	4x6 	2	54	-1	2	1	26	9
2b21	226	Planted with JRM (1.25/gallon), Whip with 1 inch roots	2017 get whips	0	-1	1	U	0.7	-1	-1	-1	4x6 	2	55	-1	2	1	26	9
2b21	227	Planted with JRM (1.25/gallon), Whip with 1 inch roots	2017 get whips	0	-1	1	U	1.2	-1	-1	-1	4x6 	2	55	-1	2	1	26	9
gg8	228	Notes - PostNE - WEST Edge (Rows WtoE) aka clone E4	Start: 2017-PostNE-West-Planting	Dead	-1	0	U	0	-1	-1	-1	4x6 	1	1	-1	1	1	27	9
4gw10	229	0	0	0	-1	1	U	2	-1	-1	-1	4x6 	1	2	-1	2	1	27	9
2bg7	230	0	0	0	-1	1	U	2.1	-1	-1	-1	4x6 	1	3	-1	3	1	27	9
16ab2	231	0	0	0	-1	1	U	2.4	-1	-1	-1	4x6 	1	4	-1	4	1	27	9
4gw13	232	0	0	0	-1	1	U	2.2	-1	-1	-1	4x6 	1	5	-1	5	1	27	9
20bs7	233	0	0	0	-1	1	U	1.9	-1	-1	-1	4x6 	1	6	-1	6	1	27	9
20bs3	234	0	0	0	-1	1	U	2.6	-1	-1	-1	4x6 	1	7	-1	7	1	27	9
16ab3	235	0	0	0	-1	1	U	2.6	-1	-1	-1	4x6 	1	8	-1	8	1	27	9
4ab7	236	0	0	0	-1	1	U	2.3	-1	-1	-1	4x6 	1	9	-1	9	1	27	9
80aa3mf	237	0	0	0	-1	1	U	2.8	-1	-1	-1	4x6 	1	10	-1	10	1	27	9
80aa3mf	238	0	Thin later	0	-1	1	U	2.9	-1	-1	-1	4x6 	1	11	-1	10	1	27	9
89aa1	239	0	0	0	-1	1	U	2.1	-1	-1	-1	4x6 	1	12	-1	11	1	27	9
89aa1	240	0	Thin later	0	-1	1	U	2.3	-1	-1	-1	4x6 	1	13	-1	11	1	27	9
2b22	241	0	0	0	-1	1	U	2	-1	-1	-1	4x6 	1	14	-1	12	1	27	9
2b25	242	0	0	0	-1	1	U	1.8	-1	-1	-1	4x6 	1	15	-1	13	1	27	9
dn34	243	0	2017 get whips	0	-1	1	U	2.9	-1	-1	-1	4x6 	1	16	-1	17	1	27	9
dn34	244	0	2017 get whips, thin later	0	-1	1	U	2.7	-1	-1	-1	4x6 	1	17	-1	17	1	27	9
dn34	245	0	2017 get whips	0	-1	1	U	2.7	-1	-1	-1	4x6 	1	18	-1	17	1	27	9
dn34	246	0	2017 get whips, thin later	Deer broke stem	-1	1	U	1.8	-1	-1	-1	4x6 	1	19	-1	17	1	27	9
dn34	247	0	2017 get whips	0	-1	1	U	2.6	-1	-1	-1	4x6 	1	20	-1	17	1	27	9
1bw6	248	0	0	0	-1	1	U	2.8	-1	-1	-1	4x6 	1	21	-1	18	1	27	9
1bw6	249	0	0	0	-1	1	U	2.1	-1	-1	-1	4x6 	1	22	-1	18	1	27	9
105aa5	250	0	0	0	-1	1	U	2.3	-1	-1	-1	4x6 	1	23	-1	19	1	27	9
105aa5	251	0	Thin later	0	-1	1	U	2	-1	-1	-1	4x6 	1	24	-1	19	1	27	9
1bw1	252	0	2017 get whips	0	-1	1	U	1.6	-1	-1	-1	4x6 	1	25	-1	20	1	27	9
20bs1	253	0	2017 get whips	0	-1	1	U	3.4	-1	-1	-1	4x6 	1	26	-1	21	1	27	9
1bw1	254	0	0	0	-1	1	U	1.6	-1	-1	-1	4x6 	1	27	-1	22	1	27	9
97aa11	255	0	Thin later	0	-1	1	U	2.2	-1	-1	-1	4x6 	1	28	-1	24	1	27	9
3bc3	256	0	0	0	-1	1	U	2.9	-1	-1	-1	4x6 	1	29	-1	25	1	27	9
4ab9	257	0	0	0	-1	1	U	3.2	-1	-1	-1	4x6 	1	30	-1	26	1	27	9
4ab9	258	0	0	0	-1	1	U	2.8	-1	-1	-1	4x6 	1	31	-1	26	1	27	9
92aa11	259	0	Thin later	0	-1	1	U	2.5	-1	-1	-1	4x6 	1	32	-1	27	1	27	9
92aa11	260	0	0	0	-1	1	U	2.4	-1	-1	-1	4x6 	1	33	-1	27	1	27	9
2b6	261	0	2017 get whips, thin later	0	-1	1	U	1.7	-1	-1	-1	4x6 	1	34	-1	28	1	27	9
2b6	262	0	2017 get whips, thin later	0	-1	1	U	1.4	-1	-1	-1	4x6 	1	35	-1	28	1	27	9
4ab4	263	0	0	0	-1	1	U	2	-1	-1	-1	4x6 	1	36	-1	29	1	27	9
4ab4	264	0	0	0	-1	1	U	2	-1	-1	-1	4x6 	1	37	-1	29	1	27	9
101aa11	265	0	Thin later	0	-1	1	U	2.4	-1	-1	-1	4x6 	1	38	-1	30	1	27	9
101aa11	266	0	0	0	-1	1	U	2.5	-1	-1	-1	4x6 	1	39	-1	30	1	27	9
101aa11	267	0	Thin later	0	-1	1	U	2.7	-1	-1	-1	4x6 	1	40	-1	30	1	27	9
2b4	268	0	0	0	-1	1	U	2.5	-1	-1	-1	4x6 	1	41	-1	31	1	27	9
2b64	269	0	0	0	-1	1	U	2.6	-1	-1	-1	4x6 	1	42	-1	32	1	27	9
2b50	270	0	0	0	-1	1	U	2	-1	-1	-1	4x6 	1	43	-1	33	1	27	9
2b62	271	0	0	0	-1	1	U	1.7	-1	-1	-1	4x6 	1	44	-1	34	1	27	9
c173	272	0	2017 get whips	0	-1	1	U	2.7	-1	-1	-1	4x6 	1	45	-1	35	1	27	9
c173	273	0	2017 get whips, thin later	0	-1	1	U	2	-1	-1	-1	4x6 	1	46	-1	35	1	27	9
c173	274	0	2017 get whips	0	-1	1	U	2.3	-1	-1	-1	4x6 	1	47	-1	35	1	27	9
98aa11	275	0	Thin later	0	-1	1	U	1.6	-1	-1	-1	4x6 	1	48	-1	36	1	27	9
98aa11	276	0	0	0	-1	1	U	1.4	-1	-1	-1	4x6 	1	49	-1	36	1	27	9
98aa11	277	0	Thin later	0	-1	1	U	1.6	-1	-1	-1	4x6 	1	50	-1	36	1	27	9
101aa11	278	0	Thin later	0	-1	1	U	2.2	-1	-1	-1	4x6 	1	51	-1	37	1	27	9
101aa11	279	0	0	0	-1	1	U	1.7	-1	-1	-1	4x6 	1	52	-1	37	1	27	9
101aa11	280	0	Thin later	0	-1	1	U	1.8	-1	-1	-1	4x6 	1	53	-1	37	1	27	9
105aa3	281	0	0	0	-1	1	U	1.7	-1	-1	-1	4x6 	1	54	-1	38	1	27	9
16ab7	282	0	0	0	-1	1	U	2.1	-1	-1	-1	4x6 	1	55	-1	39	1	27	9
105aa5	283	0	0	0	-1	1	U	1.6	-1	-1	-1	4x6 	1	56	-1	40	1	27	9
4gw11	284	Start 2017 row 1 secondary planting	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	57	-1	41	2	27	9
zoss	285	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	58	-1	42	2	27	9
2b66	286	0	0	0	-1	1	U	0.8	-1	-1	-1	8x10	1	59	-1	43	2	27	9
14b16	288	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	61	-1	45	2	27	9
14b16	289	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	62	-1	45	2	27	9
15b5	290	0	0	0	-1	1	U	0.9	-1	-1	-1	8x10	1	63	-1	46	2	27	9
19gb1	291	0	0	0	-1	1	U	0.8	-1	-1	-1	8x10	1	64	-1	47	2	27	9
14b18	292	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	65	-1	48	2	27	9
16ab1	293	0	0	0	-1	1	U	1.9	-1	-1	-1	8x10	1	66	-1	49	2	27	9
14b6	294	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	67	-1	50	2	27	9
18bg17	295	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	68	-1	51	2	27	9
14b14	296	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	69	-1	52	2	27	9
14b30	297	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	70	-1	53	2	27	9
2b24	298	0	0	0	-1	1	U	0.1	-1	-1	-1	8x10	1	71	-1	54	2	27	9
15b14	299	0	0	0	-1	1	U	1.9	-1	-1	-1	8x10	1	72	-1	55	2	27	9
19gb9	300	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	73	-1	56	2	27	9
2b7	301	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	74	-1	57	2	27	9
14b13	302	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	75	-1	58	2	27	9
15b8	303	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	76	-1	59	2	27	9
15b11	304	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	77	-1	60	2	27	9
14b11	305	End of Row 1, Secondary trees	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	78	-1	61	2	27	9
4gw11	306	0	0	Start row 2, secondary trees	-1	1	U	2.3	-1	-1	-1	4x6 	2	1	-1	1	1	27	9
2b73	307	0	0	0	-1	1	U	2	-1	-1	-1	4x6 	2	2	-1	2	1	27	9
4gw12	308	0	0	0	-1	1	U	2.2	-1	-1	-1	4x6 	2	3	-1	3	1	27	9
2b68	309	0	0	0	-1	1	U	1.9	-1	-1	-1	4x6 	2	4	-1	4	1	27	9
16ab4	310	0	0	0	-1	1	U	2.2	-1	-1	-1	4x6 	2	5	-1	5	1	27	9
16ab8	311	0	0	0	-1	1	U	2.4	-1	-1	-1	4x6 	2	6	-1	6	1	27	9
20bs9	312	0	0	0	-1	1	U	3.6	-1	-1	-1	4x6 	2	7	-1	7	1	27	9
16ab1	313	0	0	0	-1	1	U	2.7	-1	-1	-1	4x6 	2	8	-1	8	1	27	9
98aa11	314	0	Thin later	0	-1	1	U	2.7	-1	-1	-1	4x6 	2	9	-1	9	1	27	9
98aa11	315	0	0	0	-1	1	U	2.9	-1	-1	-1	4x6 	2	10	-1	9	1	27	9
98aa11	316	0	Thin later	0	-1	1	U	2.6	-1	-1	-1	4x6 	2	11	-1	11	1	27	9
98aa11	317	0	Thin later	0	-1	1	U	2.5	-1	-1	-1	4x6 	2	12	-1	11	1	27	9
2b29	318	0	2017 get whips	0	-1	1	U	2.8	-1	-1	-1	4x6 	2	13	-1	12	1	27	9
97aa11	319	0	0	0	-1	1	U	2.7	-1	-1	-1	4x6 	2	14	-1	13	1	27	9
zoss	320	0	0	0	-1	1	U	1.7	-1	-1	-1	4x6 	2	15	-1	14	1	27	9
2b6	321	0	0	0	-1	1	U	1.3	-1	-1	-1	4x6 	2	16	-1	15	1	27	9
100aa12	322	0	0	0	-1	1	U	2.8	-1	-1	-1	4x6 	2	17	-1	16	1	27	9
95aa11	323	0	0	0	-1	1	U	2.5	-1	-1	-1	4x6 	2	18	-1	17	1	27	9
95aa11	324	0	Thin later	0	-1	1	U	2.1	-1	-1	-1	4x6 	2	19	-1	17	1	27	9
105aa3	325	0	Thin later	0	-1	1	U	1.4	-1	-1	-1	4x6 	2	20	-1	18	1	27	9
105aa3	326	0	0	0	-1	1	U	1	-1	-1	-1	4x6 	2	21	-1	18	1	27	9
14b7	327	0	2017 get whips	0	-1	1	U	2	-1	-1	-1	4x6 	2	22	-1	19	1	27	9
105aa3	328	0	Thin later	0	-1	1	U	2.3	-1	-1	-1	4x6 	2	23	-1	20	1	27	9
105aa3	329	0	0	0	-1	1	U	2	-1	-1	-1	4x6 	2	24	-1	20	1	27	9
zoss	330	0	Thin later	0	-1	1	U	1.6	-1	-1	-1	4x6 	2	25	-1	25	1	27	9
zoss	331	0	0	0	-1	1	U	0.9	-1	-1	-1	4x6 	2	26	-1	25	1	27	9
2b3	332	0	2017 get whips	0	-1	1	U	1.8	-1	-1	-1	4x6 	2	27	-1	26	1	27	9
2b3	333	0	2017 get whips, thin later	0	-1	1	U	1.3	-1	-1	-1	4x6 	2	28	-1	26	1	27	9
2b3	334	0	2017 get whips	0	-1	1	U	1.5	-1	-1	-1	4x6 	2	29	-1	26	1	27	9
2b25	335	0	2017 get whips	0	-1	1	U	2	-1	-1	-1	4x6 	2	30	-1	27	1	27	9
2b25	336	0	2017 get whips, thin later	0	-1	1	U	1.9	-1	-1	-1	4x6 	2	31	-1	27	1	27	9
100aa11	337	0	2017 get whips	0	-1	1	U	3.6	-1	-1	-1	4x6 	2	32	-1	28	1	27	9
100aa11	338	0	2017 get whips, thin later	0	-1	1	U	3.3	-1	-1	-1	4x6 	2	33	-1	28	1	27	9
100aa11	339	0	2017 get whips	0	-1	1	U	3.4	-1	-1	-1	4x6 	2	34	-1	28	1	27	9
100aa12	340	0	Thin later	0	-1	1	U	3.1	-1	-1	-1	4x6 	2	35	-1	29	1	27	9
100aa12	341	0	0	0	-1	1	U	3.2	-1	-1	-1	4x6 	2	36	-1	29	1	27	9
97aa12	342	0	Thin later	0	-1	1	U	2.7	-1	-1	-1	4x6 	2	37	-1	30	1	27	9
97aa12	343	0	Thin later	0	-1	1	U	2.5	-1	-1	-1	4x6 	2	38	-1	30	1	27	9
2b71	344	0	2017 get whips	0	-1	1	U	1.5	-1	-1	-1	4x6 	2	39	-1	31	1	27	9
2b22	345	0	0	0	-1	1	U	2.5	-1	-1	-1	4x6 	2	40	-1	32	1	27	9
2b22	346	0	Thin later	0	-1	1	U	1.9	-1	-1	-1	4x6 	2	41	-1	32	1	27	9
2b22	347	0	0	0	-1	1	U	2.3	-1	-1	-1	4x6 	2	42	-1	32	1	27	9
cag204	348	0	2017 get whips	0	-1	1	U	2	-1	-1	-1	4x6 	2	43	-1	33	1	27	9
2b21	349	0	0	0	-1	1	U	1.5	-1	-1	-1	4x6 	2	44	-1	34	1	27	9
2b21	350	0	Thin later	0	-1	1	U	1.2	-1	-1	-1	4x6 	2	45	-1	34	1	27	9
2b6	351	0	2017 get whips	0	-1	1	U	1.3	-1	-1	-1	4x6 	2	46	-1	35	1	27	9
2b6	352	0	2017 get whips, thin later	0	-1	1	U	1.1	-1	-1	-1	4x6 	2	47	-1	35	1	27	9
2b6	353	0	2017 get whips	0	-1	1	U	1	-1	-1	-1	4x6 	2	48	-1	35	1	27	9
2b25	354	whip – had 1 inch roots	0	0	-1	1	U	1.3	-1	-1	-1	4x6 	2	49	-1	36	1	27	9
2b3	355	0	0	0	-1	1	U	1.4	-1	-1	-1	4x6 	2	50	-1	37	1	27	9
2b3	356	0	Thin later	0	-1	1	U	1.2	-1	-1	-1	4x6 	2	51	-1	37	1	27	9
2b3	357	0	0	0	-1	1	U	1.1	-1	-1	-1	4x6 	2	52	-1	37	1	27	9
2b21	358	0	2017 get whips	0	-1	1	U	1.3	-1	-1	-1	4x6 	2	53	-1	38	1	27	9
2b21	359	0	2017 get whips, thin later	0	-1	1	U	0.8	-1	-1	-1	4x6 	2	54	-1	38	1	27	9
2b21	360	0	2017 get whips	0	-1	1	U	0.7	-1	-1	-1	4x6 	2	55	-1	38	1	27	9
2b21	361	0	2017 get whips	0	-1	1	U	1.2	-1	-1	-1	4x6 	2	56	-1	38	1	27	9
93aa11	362	Start 2017 row 2 secondary planting	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	57	-1	39	1	27	9
93aa11	363	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	58	-1	39	1	27	9
2b80	364	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	59	-1	40	1	27	9
8bg8	365	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	60	-1	41	1	27	9
6ba2	366	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	61	-1	42	1	27	9
2b55	367	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	62	-1	43	1	27	9
4ab9	368	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	63	-1	44	1	27	9
8bg21	369	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	64	-1	45	1	27	9
2b67	370	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	65	-1	46	1	27	9
2b63	371	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	66	-1	47	1	27	9
2b68	372	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	67	-1	48	1	27	9
3bc4	373	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	68	-1	49	1	27	9
aag2001	374	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	69	-1	50	1	27	9
aag2001	375	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	70	-1	50	1	27	9
7bt7	376	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	71	-1	51	1	27	9
83aa70	377	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	72	-1	52	1	27	9
ae3	378	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	73	-1	53	1	27	9
ae3	379	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	74	-1	53	1	27	9
2b62	380	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	75	-1	54	1	27	9
aa4102	381	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	76	-1	55	1	27	9
aa4102	382	0	0	0	-1	1	U	0.4	-1	-1	-1	8x10	2	77	-1	55	1	27	9
92aa11	383	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	78	-1	56	1	27	9
3bc5	384	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	79	-1	57	1	27	9
tc72	385	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	80	-1	58	1	27	9
tc72	386	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	81	-1	58	1	27	9
14b19	387	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	82	-1	59	1	27	9
14b4	388	End of Row 2, Secondary trees	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	83	-1	60	1	27	9
dn34	389	Start 2017 row 3 Primary clones	Woven textile with 2 halves, plastic staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	1	-1	1	2	27	9
dn34	390	0	Woven textile with 2 halves, plastic staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	2	-1	1	2	27	9
dn34	391	0	Woven textile with 2 halves, plastic staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	3	-1	1	2	27	9
4ab4	392	0	Woven textile with 2 halves, plastic staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	4	-1	2	2	27	9
4ab4	393	0	Woven textile with 2 halves, plastic staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	5	-1	2	2	27	9
cag204	394	0	Woven textile with 2 halves, plastic staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	6	-1	3	2	27	9
5br3	395	0	Woven textile with 2 halves, plastic staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	7	-1	4	2	27	9
5br3	396	0	Woven textile with 2 halves, plastic staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	8	-1	4	2	27	9
8bg3	397	0	Woven textile with 2 halves, plastic staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	9	-1	3	2	27	9
8bg3	398	0	Woven textile with 2 halves, plastic staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	10	-1	3	2	27	9
2b52	399	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	11	-1	4	2	27	9
2b52	400	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	12	-1	4	2	27	9
2b55	401	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	13	-1	5	2	27	9
2b55	402	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	14	-1	5	2	27	9
18bg19	403	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	15	-1	6	2	27	9
18bg19	404	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	16	-1	6	2	27	9
3bc1	405	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	17	-1	7	2	27	9
3bc1	406	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	18	-1	7	2	27	9
2b3	407	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	19	-1	8	2	27	9
2b3	408	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	20	-1	8	2	27	9
2b25	409	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	21	-1	9	2	27	9
2b25	410	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	22	-1	9	2	27	9
11ab10	411	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	23	-1	10	2	27	9
11ab10	412	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	24	-1	10	2	27	9
11ab22	413	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	25	-1	11	2	27	9
11ab22	414	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	26	-1	11	2	27	9
14b7	415	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	27	-1	12	2	27	9
14b7	416	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	28	-1	12	2	27	9
14b21	417	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	29	-1	13	2	27	9
14b21	418	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	30	-1	13	2	27	9
14b10	419	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	31	-1	14	2	27	9
14b10	420	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	32	-1	14	2	27	9
16ab8	421	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	33	-1	15	2	27	9
16ab8	422	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	34	-1	15	2	27	9
23ba11	423	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	35	-1	16	2	27	9
23ba11	424	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	36	-1	16	2	27	9
100aa12	425	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	37	-1	17	2	27	9
100aa12	426	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	38	-1	17	2	27	9
105aa3	427	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	39	-1	18	2	27	9
105aa3	428	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	40	-1	18	2	27	9
106aa7	429	End of Row 3, Primary trees	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	41	-1	19	2	27	9
2b29	430	Start row 3, Secondary trees	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	42	-1	20	2	27	9
2b29	431	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	43	-1	20	2	27	9
14b30	432	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	44	-1	21	2	27	9
2b4	433	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	45	-1	22	2	27	9
2b4	434	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	46	-1	22	2	27	9
22bg8	435	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	47	-1	23	2	27	9
14b17	436	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	48	-1	24	2	27	9
23ba5	437	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	49	-1	25	2	27	9
11ab11	438	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	50	-1	26	2	27	9
106aa3	439	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	51	-1	27	2	27	9
22bg7	440	End of Row 3, Secondary trees	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	3	52	-1	28	2	27	9
dn34	441	Start 2017 row 4 Primary clones	Woven textile with 2 halves, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	1	-1	1	2	27	9
dn34	442	0	Woven textile with 2 halves, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	2	-1	1	2	27	9
dn34	443	0	Woven textile with 2 halves, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	3	-1	1	2	27	9
7bt1	444	0	Woven textile with 2 halves, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	4	-1	2	2	27	9
7bt1	445	0	Woven textile with 2 halves, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	5	-1	2	2	27	9
3bc3	446	0	Woven textile with 2 halves, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	6	-1	3	2	27	9
3bc3	447	0	Woven textile with 2 halves, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	7	-1	3	2	27	9
8bg9	448	0	Woven textile with 2 halves, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	8	-1	4	2	27	9
8bg9	449	0	Woven textile with 2 halves, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	9	-1	4	2	27	9
2b6	450	0	Woven textile with 2 halves, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	10	-1	5	2	27	9
2b6	451	0	Woven textile with 2 halves, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	11	-1	5	2	27	9
8gb2	452	0	Non-Woven textile folded, ss staples	0	-1	1	U	0.7	-1	-1	-1	8x10	4	12	-1	6	2	27	9
8gb2	453	0	Non-Woven textile folded, ss staples	0	-1	1	U	0.5	-1	-1	-1	8x10	4	13	-1	6	2	27	9
2b71	454	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	14	-1	7	2	27	9
2b71	455	0	Non-Woven textile folded, ss staples	0	-1	1	U	0.8	-1	-1	-1	8x10	4	15	-1	7	2	27	9
18bg2	456	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	16	-1	8	2	27	9
18bg2	457	0	Non-Woven textile folded, ss staples	0	-1	1	U	0.8	-1	-1	-1	8x10	4	17	-1	8	2	27	9
18bg25	458	0	Non-Woven textile folded, ss staples	0	-1	1	U	0.8	-1	-1	-1	8x10	4	18	-1	9	2	27	9
18bg25	459	0	Non-Woven textile folded, ss staples	0	-1	1	U	0.8	-1	-1	-1	8x10	4	19	-1	9	2	27	9
2b21	460	0	Non-Woven textile folded, ss staples	0	-1	1	U	0.6	-1	-1	-1	8x10	4	20	-1	10	2	27	9
2b21	461	0	Non-Woven textile folded, ss staples	0	-1	1	U	0.8	-1	-1	-1	8x10	4	21	-1	10	2	27	9
a502	462	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	22	-1	11	2	27	9
1bw6	463	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	23	-1	12	2	27	9
1bw6	464	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	24	-1	12	2	27	9
23ba15	465	0	Non-Woven textile folded, ss staples	0	-1	1	U	1	-1	-1	-1	8x10	4	25	-1	13	2	27	9
23ba15	466	0	Non-Woven textile folded, ss staples	0	-1	1	U	1	-1	-1	-1	8x10	4	26	-1	13	2	27	9
22bg1	467	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	27	-1	14	2	27	9
22bg1	468	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	28	-1	14	2	27	9
23ba18	469	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	29	-1	15	2	27	9
23ba18	470	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	30	-1	15	2	27	9
14b31	471	0	Non-Woven textile folded, ss staples	0	-1	1	U	0.8	-1	-1	-1	8x10	4	31	-1	16	2	27	9
14b31	472	0	Non-Woven textile folded, ss staples	0	-1	1	U	0.7	-1	-1	-1	8x10	4	32	-1	16	2	27	9
20bs1	473	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	33	-1	17	2	27	9
20bs1	474	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	34	-1	17	2	27	9
23ba10	475	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	35	-1	18	2	27	9
23ba10	476	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	36	-1	18	2	27	9
105aa5	477	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	37	-1	19	2	27	9
105aa5	478	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	38	-1	19	2	27	9
100aa11	479	0	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	39	-1	20	2	27	9
100aa11	480	End of Row 4, Primary trees	Non-Woven textile folded, ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	40	-1	20	2	27	9
gg7	481	Start row 4, Secondary planting	One folded piece woven textile with ss staples	House FW clone	-1	1	U	-1	-1	-1	-1	8x10	4	50	-1	21	2	27	9
gg7	482	0	One folded piece woven textile with ss staples	House FW clone	-1	1	U	-1	-1	-1	-1	8x10	4	51	-1	21	2	27	9
gg7	483	0	One folded piece woven textile with ss staples	House FW clone	-1	1	U	-1	-1	-1	-1	8x10	4	52	-1	21	2	27	9
23ba2	484	0	One folded piece woven textile with ss staples	curly stem	-1	1	U	0.7	-1	-1	-1	8x10	4	53	-1	22	2	27	9
104aa12	485	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	54	-1	23	2	27	9
20bs6	486	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	55	-1	24	2	27	9
20bs8	487	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	56	-1	25	2	27	9
11ab3	488	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	57	-1	26	2	27	9
106aa1	489	0	One folded piece woven textile with ss staples	0	-1	1	U	1.9	-1	-1	-1	8x10	4	58	-1	27	2	27	9
20bs5	490	0	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	59	-1	28	2	27	9
107aa7	491	End of Row 4, Secondary trees	One folded piece woven textile with ss staples	0	-1	1	U	-1	-1	-1	-1	8x10	4	60	-1	29	2	27	9
82xaa04	492	Start CSNE site, planted about 4/16/2005:   row 1 on SE site corner. High stem taper.	0	0	-1	1	U	39.6	-1	4	-1	8x8 	1	1	-1	1	1	29	10
82xaa04	493	0	0	0	-1	1	U	16.2	-1	4	-1	8x8 	1	2	-1	1	1	29	10
82xaa04	494	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	1	3	-1	1	1	29	10
82xaa04	495	High stem taper.	0	0	-1	1	U	32.3	-1	4	-1	8x8 	1	4	-1	1	1	29	10
dn34	496	Earlier Leaf Drop (ELD)	0	0	-1	1	U	17.8	-1	4	-1	8x8 	1	5	-1	1	1	29	10
82xaa04	497	Nice form	0	0	-1	1	Y	26.7	-1	4	-1	8x8 	1	6	-1	1	1	29	10
82xaa04	498	0	0	0	-1	1	U	20.2	-1	4	-1	8x8 	1	7	-1	1	1	29	10
82xaa04	499	Healed basal defect.	0	0	-1	1	U	22.6	-1	4	-1	8x8 	1	8	-1	1	1	29	10
82xaa04	500	0	0	0	-1	1	U	24.3	-1	4	-1	8x8 	1	9	-1	1	1	29	10
82xaa04	501	0	0	0	-1	0	U	0	-1	4	-1	8x8 	1	10	-1	1	1	29	10
dn34	502	ELD	0	0	-1	1	U	27.5	-1	4	-1	8x8 	1	11	-1	1	1	29	10
crandon	503	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	2	1	-1	1	1	29	10
autumnolive	504	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	2	2	-1	1	1	29	10
crandon	505	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	2	3	-1	1	1	29	10
autumnolive	506	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	2	4	-1	1	1	29	10
crandon	507	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	2	5	-1	1	1	29	10
autumnolive	508	Largest AO stem	0	0	-1	1	U	11.3	-1	3	-1	8x8 	2	6	-1	1	1	29	10
crandon	509	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	2	7	-1	1	1	29	10
autumnolive	510	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	2	8	-1	1	1	29	10
crandon	511	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	2	9	-1	1	1	29	10
autumnolive	512	0	0	0	-1	1	U	12.1	-1	4	-1	8x8 	2	10	-1	1	1	29	10
83xaa04	513	0	0	0	-1	1	U	13.7	-1	4	-1	8x8 	3	1	-1	1	1	29	10
83xaa04	514	Possible BLD?	0	0	-1	1	U	17	-1	3	-1	8x8 	3	2	-1	1	1	29	10
83xaa04	515	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	3	3	-1	1	1	29	10
83xaa04	516	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	3	4	-1	1	1	29	10
83xaa04	517	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	3	5	-1	1	1	29	10
83xaa04	518	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	3	6	-1	1	1	29	10
83xaa04	519	0	0	0	-1	1	U	16.2	-1	4	-1	8x8 	3	7	-1	1	1	29	10
83xaa04	520	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	3	8	-1	1	1	29	10
83xaa04	521	0	0	0	-1	1	U	20.2	-1	4	-1	8x8 	3	9	-1	1	1	29	10
83xaa04	522	Weak tree	0	0	-1	1	U	12.1	-1	3	-1	8x8 	3	10	-1	1	1	29	10
84xaa04	523	4 stems	0	0	-1	1	U	17	-1	4	-1	8x8 	4	1	-1	1	1	29	10
84xaa04	524	3 stems	0	0	-1	1	U	14.6	-1	4	-1	8x8 	4	2	-1	1	1	29	10
84xaa04	525	0	0	0	-1	1	U	21.8	-1	4	-1	8x8 	4	3	-1	1	1	29	10
84xaa04	526	0	0	0	-1	0	U	0	-1	-1	-1	8x8 	4	4	-1	1	1	29	10
84xaa04	527	0	0	0	-1	1	U	7.3	-1	3	-1	8x8 	4	5	-1	1	1	29	10
84xaa04	528	0	0	0	-1	1	U	12.9	-1	4	-1	8x8 	4	6	-1	1	1	29	10
84xaa04	529	0	0	0	-1	1	U	17	-1	3	-1	8x8 	4	7	-1	1	1	29	10
84xaa04	530	0	0	0	-1	1	Y	25.9	-1	4	-1	8x8 	4	8	-1	1	1	29	10
84xaa04	531	Nice form, best tree on site, possible female.  Should select this as clone: 84aa1	1	1	-1	1	Y	34	-1	4	-1	8x8 	4	9	-1	1	1	29	10
84xaa04	532	End CSNE site: row 4 on NW site corner. Crooked tree	1	1	-1	1	Y	29.1	-1	4	-1	8x8 	4	10	-1	1	1	29	10
gg8	533	PostNE - WEST Edge (Rows WtoE) - Start: 2017-PostNE-West-Measurement	dead	0	-1	0	U	0	-1	-1	-1	4x6 	1	1	1	1	1	30	9
4gw10	534	0	0	0	-1	1	U	4.6	-1	4	-1	4x6 	1	2	1	2	1	30	9
2bg7	535	0	0	0	-1	1	U	4.4	-1	5	-1	4x6 	1	3	1	3	1	30	9
16ab2	536	Early Leaf Drop (ELD)	0	0	-1	1	U	4.3	-1	2	-1	4x6 	1	4	1	4	1	30	9
4gw13	537	0	0	0	-1	1	U	5	-1	4	-1	4x6 	1	5	1	5	1	30	9
20bs7	538	ELD	0	0	-1	1	U	4.5	-1	4	-1	4x6 	1	6	1	6	1	30	9
20bs3	539	0	0	0	-1	1	U	4.6	-1	5	-1	4x6 	1	7	1	7	1	30	9
16ab3	540	ELD	0	0	-1	1	U	3.8	-1	3	-1	4x6 	1	8	1	8	1	30	9
4ab7	541	ELD, Branchy	0	0	-1	1	N	3.9	-1	3	-1	4x6 	1	9	1	9	1	30	9
80aa3mf	542	0	0	0	-1	1	U	5.2	-1	5	-1	4x6 	1	10	1	10	1	30	9
80aa3mf	543	0	Thin later	0	-1	1	U	5	-1	5	-1	4x6 	1	11	1	10	1	30	9
89aa1	544	Crooked form	0	0	-1	1	U	4.5	-1	5	-1	4x6 	1	12	1	11	1	30	9
89aa1	545	Crooked form	Thin later	0	-1	1	U	4.4	-1	4	-1	4x6 	1	13	1	11	1	30	9
2b22	546	leaf miners	0	0	-1	1	U	4.7	-1	4	-1	4x6 	1	14	1	12	1	30	9
2b25	547	ELD	0	0	-1	1	U	4.2	-1	5	-1	4x6 	1	15	1	13	1	30	9
dn34	548	ELD	2017 get whips	0	-1	1	U	5.5	-1	3	-1	4x6 	1	16	1	17	1	30	9
dn34	549	ELD	2017 get whips, thin later	0	-1	1	U	5.3	-1	3	-1	4x6 	1	17	1	17	1	30	9
dn34	550	ELD	2017 get whips	0	-1	1	U	4.8	-1	3	-1	4x6 	1	18	1	17	1	30	9
dn34	551	ELD	2017 get whips, thin later	animal	-1	1	U	3.6	-1	3	-1	4x6 	1	19	1	17	1	30	9
dn34	552	ELD	2017 get whips	0	-1	1	U	5.1	-1	3	-1	4x6 	1	20	1	17	1	30	9
1bw6	553	ELD	0	0	-1	1	U	4.8	-1	5	-1	4x6 	1	21	1	18	1	30	9
1bw6	554	ELD	0	0	-1	1	U	3.3	-1	5	-1	4x6 	1	22	1	18	1	30	9
105aa5	555	0	0	0	-1	1	U	4.5	-1	4	-1	4x6 	1	23	1	19	1	30	9
105aa5	556	0	Thin later	0	-1	1	U	4.3	-1	4	-1	4x6 	1	24	1	19	1	30	9
1bw1	557	dry stem canker	2017 get whips	0	-1	1	N	3.8	-1	4	-1	4x6 	1	25	1	20	1	30	9
20bs1	558	bursting sleeve (why N score?, form?)	2017 get whips	0	-1	1	U	6.6	-1	4	-1	4x6 	1	26	1	21	1	30	9
1bw1	559	0	0	0	-1	1	U	4	-1	4	-1	4x6 	1	27	1	22	1	30	9
97aa11	560	0	Thin later	0	-1	1	U	4.3	-1	4	-1	4x6 	1	28	1	24	1	30	9
3bc3	561	0	0	0	-1	1	U	4.6	-1	4	-1	4x6 	1	29	1	25	1	30	9
4ab9	562	bursting sleeve	0	0	-1	1	U	5.6	-1	4	-1	4x6 	1	30	1	26	1	30	9
4ab9	563	0	0	0	-1	1	U	5.2	-1	4	-1	4x6 	1	31	1	26	1	30	9
92aa11	564	0	Thin later	0	-1	1	U	4.7	-1	4	-1	4x6 	1	32	1	27	1	30	9
92aa11	565	0	0	0	-1	1	U	4.7	-1	4	-1	4x6 	1	33	1	27	1	30	9
2b6	566	0	2017 get whips, thin later	0	-1	1	U	3.6	-1	5	-1	4x6 	1	34	1	28	1	30	9
2b6	567	ELD	2017 get whips, thin later	0	-1	1	U	3.2	-1	4	-1	4x6 	1	35	1	28	1	30	9
4ab4	568	ELD	0	0	-1	1	U	3.4	-1	3	-1	4x6 	1	36	1	29	1	30	9
4ab4	569	0	0	0	-1	1	U	3.8	-1	3	-1	4x6 	1	37	1	29	1	30	9
101aa11	570	0	Thin later	0	-1	1	U	4.2	-1	4	-1	4x6 	1	38	1	30	1	30	9
101aa11	571	0	0	0	-1	1	U	4.5	-1	4	-1	4x6 	1	39	1	30	1	30	9
101aa11	572	0	Thin later	0	-1	1	U	4.4	-1	4	-1	4x6 	1	40	1	30	1	30	9
2b4	573	0	0	0	-1	1	U	4.2	-1	4	-1	4x6 	1	41	1	31	1	30	9
2b64	574	0	0	0	-1	1	U	3.9	-1	5	-1	4x6 	1	42	1	32	1	30	9
2b50	575	0	0	0	-1	1	U	3.7	-1	4	-1	4x6 	1	43	1	33	1	30	9
2b62	576	ELD	0	0	-1	1	U	3.5	-1	4	-1	4x6 	1	44	1	34	1	30	9
c173	577	0	2017 get whips	0	-1	1	U	4.3	-1	4	-1	4x6 	1	45	1	35	1	30	9
c173	578	0	2017 get whips, thin later	0	-1	1	U	3.9	-1	4	-1	4x6 	1	46	1	35	1	30	9
c173	579	0	2017 get whips	0	-1	1	U	4	-1	4	-1	4x6 	1	47	1	35	1	30	9
98aa11	580	good form	Thin later	0	-1	1	U	3.8	-1	4	-1	4x6 	1	48	1	36	1	30	9
98aa11	581	0	0	0	-1	1	U	3.6	-1	4	-1	4x6 	1	49	1	36	1	30	9
98aa11	582	0	Thin later	0	-1	1	U	4	-1	4	-1	4x6 	1	50	1	36	1	30	9
101aa11	583	0	Thin later	0	-1	1	U	3.6	-1	3	-1	4x6 	1	51	1	37	1	30	9
101aa11	584	0	0	0	-1	1	U	3.5	-1	3	-1	4x6 	1	52	1	37	1	30	9
101aa11	585	0	Thin later	0	-1	1	U	3.8	-1	3	-1	4x6 	1	53	1	37	1	30	9
105aa3	586	0	0	0	-1	1	U	4.1	-1	4	-1	4x6 	1	54	1	38	1	30	9
16ab7	587	ELD	0	0	-1	1	U	4.4	-1	3	-1	4x6 	1	55	1	39	1	30	9
105aa5	588	0	0	0	-1	1	U	4.1	-1	5	-1	4x6 	1	56	1	40	1	30	9
4gw11	589	Start 2017 row 1 secondary planting	0	0	-1	1	U	2.1	-1	4	-1	8x10	1	57	1	41	2	30	9
zoss	590	0	0	0	-1	1	U	1.7	-1	4	-1	8x10	1	58	1	42	2	30	9
2b66	591	0	0	0	-1	1	U	1.2	-1	4	-1	8x10	1	59	1	43	2	30	9
98aa11	592	0	0	0	-1	1	Y	1.9	-1	4	-1	8x10	1	60	1	44	2	30	9
14b16	593	0	0	0	-1	1	Y	2.2	-1	4	-1	8x10	1	61	1	45	2	30	9
13gb6	594	Was incorrectly labeled 14b16	0	0	-1	1	U	1.1	-1	4	-1	8x10	1	62	1	45	2	30	9
15b5	595	0	0	0	-1	1	U	1.2	-1	4	-1	8x10	1	63	1	46	2	30	9
19gb1	596	0	0	0	-1	1	U	1.4	-1	3	-1	8x10	1	64	1	47	2	30	9
14b18	597	Leaf specks	0	0	-1	1	Y	1.7	-1	4	-1	8x10	1	65	1	48	2	30	9
16ab1	598	ELD	0	0	-1	1	U	2.5	-1	4	-1	8x10	1	66	1	49	2	30	9
14b6	599	0	0	0	-1	1	U	1.8	-1	4	-1	8x10	1	67	1	50	2	30	9
18bg17	600	0	0	0	-1	1	Y	1.8	-1	4	-1	8x10	1	68	1	51	2	30	9
14b14	601	Nice!	0	0	-1	1	Y	2	-1	4	-1	8x10	1	69	1	52	2	30	9
14b30	602	0	0	0	-1	1	U	1.8	-1	4	-1	8x10	1	70	1	53	2	30	9
2b24	603	0	0	0	-1	1	U	1.3	-1	4	-1	8x10	1	71	1	54	2	30	9
15b14	604	0	0	0	-1	1	U	1.8	-1	3	-1	8x10	1	72	1	55	2	30	9
19gb9	605	0	0	0	-1	1	U	1.4	-1	3	-1	8x10	1	73	1	56	2	30	9
2b7	606	0	0	0	-1	1	U	1.4	-1	4	-1	8x10	1	74	1	57	2	30	9
14b13	607	0	0	0	-1	1	U	1.5	-1	4	-1	8x10	1	75	1	58	2	30	9
15b8	608	ELD	0	0	-1	1	U	1.2	-1	4	-1	8x10	1	76	1	59	2	30	9
15b11	609	ELD	0	0	-1	1	U	1.4	-1	4	-1	8x10	1	77	1	60	2	30	9
14b11	610	End of Row 1, Secondary trees	0	0	-1	1	U	1.5	-1	4	-1	8x10	1	78	1	61	2	30	9
4gw11	611	Start row 2, secondary trees	0	0	-1	1	U	3.9	-1	4	-1	4x6 	2	1	2	1	1	30	9
2b73	612	ELD - May be tallest tree, with 12 feet of growth in 2017.	0	0	-1	1	Y	4.3	-1	4	-1	4x6 	2	2	2	2	1	30	9
4gw12	613	0	0	0	-1	1	U	4.5	-1	4	-1	4x6 	2	3	2	3	1	30	9
2b68	614	0	0	0	-1	1	U	4.1	-1	4	-1	4x6 	2	4	2	4	1	30	9
16ab4	615	ELD	0	0	-1	1	U	4.3	-1	3	-1	4x6 	2	5	2	5	1	30	9
16ab8	616	bursting sleeve	0	0	-1	1	Y	4.9	-1	4	-1	4x6 	2	6	2	6	1	30	9
20bs9	617	branchy, buck rubbed, sprouty	0	0	-1	1	U	5.6	-1	5	-1	4x6 	2	7	2	7	1	30	9
16ab1	618	ELD	0	0	-1	1	U	4.3	-1	3	-1	4x6 	2	8	2	8	1	30	9
98aa11	619	0	Thin later	0	-1	1	Y	6	-1	4	-1	4x6 	2	9	2	9	1	30	9
98aa11	620	0	0	0	-1	1	Y	5.2	-1	4	-1	4x6 	2	10	2	9	1	30	9
98aa11	621	0	Thin later	0	-1	1	Y	5.5	-1	4	-1	4x6 	2	11	2	11	1	30	9
98aa11	622	ELD	Thin later	0	-1	1	U	4.7	-1	4	-1	4x6 	2	12	2	11	1	30	9
2b29	623	buck rubbed	2017 get whips	animal	-1	1	U	1.9	-1	4	-1	4x6 	2	13	2	12	1	30	9
97aa11	624	0	0	0	-1	1	U	5	-1	4	-1	4x6 	2	14	2	13	1	30	9
zoss	625	0	0	0	-1	1	U	3.8	-1	4	-1	4x6 	2	15	2	14	1	30	9
2b6	626	0	0	0	-1	1	U	3.3	-1	4	-1	4x6 	2	16	2	15	1	30	9
100aa12	627	0	0	0	-1	1	U	5	-1	4	-1	4x6 	2	17	2	16	1	30	9
95aa11	628	branchy	0	0	-1	1	U	4.5	-1	4	-1	4x6 	2	18	2	17	1	30	9
95aa11	629	branchy	Thin later	0	-1	1	U	4.8	-1	4	-1	4x6 	2	19	2	17	1	30	9
105aa3	630	ELD, branchy	Thin later	0	-1	1	U	3.8	-1	4	-1	4x6 	2	20	2	18	1	30	9
105aa3	631	branchy	0	0	-1	1	U	3.9	-1	4	-1	4x6 	2	21	2	18	1	30	9
14b7	632	0	2017 get whips	0	-1	1	U	4.5	-1	4	-1	4x6 	2	22	2	19	1	30	9
105aa3	633	0	Thin later	0	-1	1	U	4.7	-1	4	-1	4x6 	2	23	2	20	1	30	9
105aa3	634	0	0	0	-1	1	U	4.1	-1	4	-1	4x6 	2	24	2	20	1	30	9
zoss	635	branchy	Thin later	0	-1	1	U	3.8	-1	4	-1	4x6 	2	25	2	25	1	30	9
zoss	636	branchy	0	0	-1	1	U	3.4	-1	4	-1	4x6 	2	26	2	25	1	30	9
2b3	637	0	2017 get whips	0	-1	1	N	4.2	-1	4	-1	4x6 	2	27	2	26	1	30	9
2b3	638	branch tree top, leaf spots	2017 get whips, thin later	0	-1	1	N	4.6	-1	4	-1	4x6 	2	28	2	26	1	30	9
2b3	639	branch tree top, leaf spots. 2017 FW split figured wood sample	2017 get whips	0	-1	1	N	5.2	-1	4	-1	4x6 	2	29	2	26	1	30	9
2b25	640	branch tree top, leaf spots	2017 get whips	0	-1	1	U	5.3	-1	4	-1	4x6 	2	30	2	27	1	30	9
2b25	641	0	2017 get whips, thin later	0	-1	1	U	4.4	-1	4	-1	4x6 	2	31	2	27	1	30	9
100aa11	642	0	2017 get whips	0	-1	1	Y	6.1	-1	5	-1	4x6 	2	32	2	28	1	30	9
100aa11	643	0	2017 get whips, thin later	0	-1	1	Y	5.8	-1	5	-1	4x6 	2	33	2	28	1	30	9
100aa11	644	branchy	2017 get whips	0	-1	1	Y	5.3	-1	5	-1	4x6 	2	34	2	28	1	30	9
100aa12	645	0	Thin later	0	-1	1	Y	5.5	-1	5	-1	4x6 	2	35	2	29	1	30	9
100aa12	646	0	0	0	-1	1	Y	5.2	-1	5	-1	4x6 	2	36	2	29	1	30	9
97aa12	647	0	Thin later	0	-1	1	U	4.6	-1	5	-1	4x6 	2	37	2	30	1	30	9
97aa12	648	0	Thin later	0	-1	1	U	4.5	-1	5	-1	4x6 	2	38	2	30	1	30	9
2b71	649	0	2017 get whips	0	-1	1	U	3.7	-1	4	-1	4x6 	2	39	2	31	1	30	9
2b22	650	Nice! good clone	0	0	-1	1	Y	5	-1	4	-1	4x6 	2	40	2	32	1	30	9
2b22	651	0	Thin later	0	-1	1	U	4.2	-1	4	-1	4x6 	2	41	2	32	1	30	9
2b22	652	0	0	0	-1	1	U	4.6	-1	4	-1	4x6 	2	42	2	32	1	30	9
cag204	653	ELD	2017 get whips	0	-1	1	U	4.4	-1	4	-1	4x6 	2	43	2	33	1	30	9
2b21	654	ELD, leaf bug issues	0	0	-1	1	N	2.7	-1	3	-1	4x6 	2	44	2	34	1	30	9
2b21	655	ELD, leaf bug issues	Thin later	0	-1	1	N	2.7	-1	3	-1	4x6 	2	45	2	34	1	30	9
2b6	656	0	2017 get whips	0	-1	1	U	2.9	-1	4	-1	4x6 	2	46	2	35	1	30	9
2b6	657	0	2017 get whips, thin later	0	-1	1	U	2.9	-1	4	-1	4x6 	2	47	2	35	1	30	9
2b6	658	0	2017 get whips	0	-1	1	U	2.9	-1	4	-1	4x6 	2	48	2	35	1	30	9
2b25	659	whip with 1 inch roots	0	0	-1	1	Y	3.9	-1	5	-1	4x6 	2	49	2	36	1	30	9
2b3	660	0	0	0	-1	1	U	3.8	-1	4	-1	4x6 	2	50	2	37	1	30	9
2b3	661	0	Thin later	0	-1	1	U	3.8	-1	4	-1	4x6 	2	51	2	37	1	30	9
2b3	662	ELD	0	0	-1	1	U	3.3	-1	4	-1	4x6 	2	52	2	37	1	30	9
2b21	663	buggy, branchy	2017 get whips	0	-1	1	N	2.8	-1	4	-1	4x6 	2	53	2	38	1	30	9
2b21	664	0	2017 get whips, thin later	0	-1	1	N	2.6	-1	3	-1	4x6 	2	54	2	38	1	30	9
2b21	665	0	2017 get whips	0	-1	1	N	2.2	-1	3	-1	4x6 	2	55	2	38	1	30	9
2b21	666	0	2017 get whips	0	-1	1	N	3.3	-1	3	-1	4x6 	2	56	2	38	1	30	9
93aa11	667	Start 2017 row 2 secondary planting, buggy	0	0	-1	1	U	3.2	-1	3	-1	8x10	2	57	2	39	1	30	9
93aa11	668	buggy	0	0	-1	1	U	3.7	-1	4	-1	8x10	2	58	2	39	1	30	9
2b80	669	0	0	0	-1	1	Y	2.6	-1	5	-1	8x10	2	59	2	40	1	30	9
8bg8	670	0	0	0	-1	1	U	2.6	-1	4	-1	8x10	2	60	2	41	1	30	9
6ba2	671	0	0	0	-1	1	U	3.1	-1	4	-1	8x10	2	61	2	42	1	30	9
2b55	672	0	0	0	-1	1	U	1.7	-1	4	-1	8x10	2	62	2	43	1	30	9
4ab9	673	0	0	0	-1	1	Y	1.8	-1	4	-1	8x10	2	63	2	44	1	30	9
8bg21	674	0	0	0	-1	1	U	1.4	-1	5	-1	8x10	2	64	2	45	1	30	9
2b67	675	0	0	0	-1	1	Y	1.8	-1	5	-1	8x10	2	65	2	46	1	30	9
2b63	676	0	0	0	-1	1	U	2.1	-1	4	-1	8x10	2	66	2	47	1	30	9
2b68	677	buggy leaves	0	0	-1	1	U	1.5	-1	4	-1	8x10	2	67	2	48	1	30	9
3bc4	678	0	0	0	-1	1	Y	1.9	-1	5	-1	8x10	2	68	2	49	1	30	9
aag2001	679	0	0	0	-1	1	U	1.4	-1	5	-1	8x10	2	69	2	50	1	30	9
aag2001	680	0	0	0	-1	1	U	1.5	-1	5	-1	8x10	2	70	2	50	1	30	9
7bt7	681	0	0	0	-1	1	U	1.2	-1	4	-1	8x10	2	71	2	51	1	30	9
83aa70	682	0	0	0	-1	1	U	1.5	-1	3	-1	8x10	2	72	2	52	1	30	9
ae3	683	0	0	0	-1	1	U	1.5	-1	4	-1	8x10	2	73	2	53	1	30	9
ae3	684	0	0	0	-1	1	U	0.6	-1	2	-1	8x10	2	74	2	53	1	30	9
2b62	685	ELD	0	0	-1	1	U	1.9	-1	4	-1	8x10	2	75	2	54	1	30	9
aa4102	686	0	0	0	-1	1	U	1.3	-1	3	-1	8x10	2	76	2	55	1	30	9
aa4102	687	deer (something) broke stem at ground level	0	animal	-1	1	U	0.4	-1	3	-1	8x10	2	77	2	55	1	30	9
92aa11	688	0	0	0	-1	1	U	1.7	-1	4	-1	8x10	2	78	2	56	1	30	9
3bc5	689	ELD	0	0	-1	1	U	1.5	-1	4	-1	8x10	2	79	2	57	1	30	9
tc72	690	0	0	0	-1	1	U	0.8	-1	5	-1	8x10	2	80	2	58	1	30	9
tc72	691	deer broken	0	animal	-1	1	U	0.4	-1	4	-1	8x10	2	81	2	58	1	30	9
14b19	692	0	0	0	-1	1	U	1.3	-1	4	-1	8x10	2	82	2	59	1	30	9
14b4	693	End of Row 2, Secondary trees	0	0	-1	1	U	1.8	-1	4	-1	8x10	2	83	2	60	1	30	9
dn34	694	Start 2017 row 3 Primary clones	0	0	-1	1	U	1.5	-1	3	-1	8x10	3	1	3	1	2	30	9
dn34	695	0	0	0	-1	1	U	1.5	-1	3	-1	8x10	3	2	3	1	2	30	9
dn34	696	0	0	0	-1	1	U	1.4	-1	3	-1	8x10	3	3	3	1	2	30	9
4ab4	697	ELD	0	0	-1	1	U	1.8	-1	4	-1	8x10	3	4	3	2	2	30	9
4ab4	698	ELD	0	0	-1	1	U	2	-1	4	-1	8x10	3	5	3	2	2	30	9
cag204	699	0	0	0	-1	1	U	1.4	-1	5	-1	8x10	3	6	3	3	2	30	9
5br3	700	0	0	0	-1	1	U	1.1	-1	3	-1	8x10	3	7	3	4	2	30	9
5br3	701	0	0	0	-1	1	U	1	-1	4	-1	8x10	3	8	3	4	2	30	9
8bg3	702	0	0	0	-1	1	Y	1.7	-1	5	-1	8x10	3	9	3	3	2	30	9
8bg3	703	0	0	0	-1	1	Y	1.8	-1	5	-1	8x10	3	10	3	3	2	30	9
2b52	704	0	0	0	-1	1	U	1.8	-1	4	-1	8x10	3	11	3	4	2	30	9
2b52	705	0	0	0	-1	1	U	1.4	-1	4	-1	8x10	3	12	3	4	2	30	9
2b55	706	Deer broken	0	animal	-1	0	U	0	-1	-1	-1	8x10	3	13	3	5	2	30	9
2b55	707	0	0	0	-1	1	U	1.4	-1	4	-1	8x10	3	14	3	5	2	30	9
18bg19	708	leaf spot	0	0	-1	1	N	1.3	-1	3	-1	8x10	3	15	3	6	2	30	9
18bg19	709	leaf spot	0	0	-1	1	N	1.5	-1	3	-1	8x10	3	16	3	6	2	30	9
3bc1	710	0	0	0	-1	1	Y	2	-1	5	-1	8x10	3	17	3	7	2	30	9
3bc1	711	0	0	0	-1	1	U	1.5	-1	4	-1	8x10	3	18	3	7	2	30	9
2b3	712	0	0	0	-1	1	U	1.9	-1	5	-1	8x10	3	19	3	8	2	30	9
2b3	713	0	0	0	-1	1	U	1.9	-1	4	-1	8x10	3	20	3	8	2	30	9
2b25	714	0	0	0	-1	1	Y	2.1	-1	5	-1	8x10	3	21	3	9	2	30	9
2b25	715	0	0	0	-1	1	Y	2.1	-1	5	-1	8x10	3	22	3	9	2	30	9
11ab10	716	wide form, bad leaves	0	0	-1	1	U	2.6	-1	4	-1	8x10	3	23	3	10	2	30	9
11ab10	717	wide form, bad leaves	0	0	-1	1	Y	3	-1	4	-1	8x10	3	24	3	10	2	30	9
11ab22	718	0	0	0	-1	1	Y	3	-1	4	-1	8x10	3	25	3	11	2	30	9
11ab22	719	0	0	0	-1	1	Y	2.4	-1	4	-1	8x10	3	26	3	11	2	30	9
14b7	720	wide form	0	0	-1	1	Y	2	-1	4	-1	8x10	3	27	3	12	2	30	9
14b7	721	wide form	0	0	-1	1	Y	2	-1	4	-1	8x10	3	28	3	12	2	30	9
14b21	722	0	0	0	-1	1	Y	1.9	-1	4	-1	8x10	3	29	3	13	2	30	9
14b21	723	0	0	0	-1	1	Y	2	-1	4	-1	8x10	3	30	3	13	2	30	9
14b10	724	0	0	0	-1	1	U	1.7	-1	4	-1	8x10	3	31	3	14	2	30	9
14b10	725	0	0	0	-1	1	U	1.2	-1	4	-1	8x10	3	32	3	14	2	30	9
16ab8	726	0	0	0	-1	1	U	1.7	-1	4	-1	8x10	3	33	3	15	2	30	9
16ab8	727	Note bare root whip planted after this tree; col=34.5, Leaf=4, DBH=1.8 	0	0	-1	1	U	1.6	-1	4	-1	8x10	3	34	3	15	2	30	9
23ba11	728	0	0	0	-1	1	U	1.7	-1	4	-1	8x10	3	35	3	16	2	30	9
23ba11	729	0	0	0	-1	1	U	1.8	-1	4	-1	8x10	3	36	3	16	2	30	9
100aa12	730	0	0	0	-1	1	U	1.8	-1	4	-1	8x10	3	37	3	17	2	30	9
100aa12	731	0	0	0	-1	1	U	1.8	-1	4	-1	8x10	3	38	3	17	2	30	9
105aa3	732	0	0	0	-1	1	U	1.5	-1	4	-1	8x10	3	39	3	18	2	30	9
105aa3	733	0	0	0	-1	1	U	1.7	-1	4	-1	8x10	3	40	3	18	2	30	9
106aa7	734	End of Row 3, Primary trees	0	0	-1	1	Y	2.2	-1	4	-1	8x10	3	41	3	19	2	30	9
2b29	735	Start row 3, Secondary trees	0	0	-1	1	U	1.2	-1	4	-1	8x10	3	42	3	20	2	30	9
2b29	736	0	0	0	-1	1	U	1.3	-1	4	-1	8x10	3	43	3	20	2	30	9
14b3	737	Was incorrectly named 14b30.	0	0	-1	1	U	1.1	-1	4	-1	8x10	3	44	3	21	2	30	9
2b4	738	Redish leaves/stems, weak?	0	0	-1	1	U	1.7	-1	4	-1	8x10	3	45	3	22	2	30	9
2b4	739	Very redish, weak? ELD	0	0	-1	1	U	1.8	-1	4	-1	8x10	3	46	3	22	2	30	9
22bg8	740	stem broken	0	animal	-1	0	U	0	-1	-1	-1	8x10	3	47	3	23	2	30	9
14b17	741	0	0	0	-1	1	U	1.4	-1	4	-1	8x10	3	48	3	24	2	30	9
23ba5	742	deer broken	0	animal	-1	0	U	0	-1	-1	-1	8x10	3	49	3	25	2	30	9
11ab11	743	0	0	0	-1	1	U	1.6	-1	4	-1	8x10	3	50	3	26	2	30	9
106aa3	744	ELD	0	0	-1	1	U	1.7	-1	4	-1	8x10	3	51	3	27	2	30	9
22bg7	745	End of Row 3, Secondary trees	0	0	-1	1	U	1.4	-1	4	-1	8x10	3	52	3	28	2	30	9
dn34	746	Start 2017 row 4 Primary clones	0	0	-1	1	U	1.1	-1	3	-1	8x10	4	1	4	1	2	30	9
dn34	747	0	0	0	-1	1	U	1.2	-1	3	-1	8x10	4	2	4	1	2	30	9
dn34	748	0	0	0	-1	1	U	1.3	-1	3	-1	8x10	4	3	4	1	2	30	9
7bt1	749	0	0	0	-1	1	U	1.3	-1	4	-1	8x10	4	4	4	2	2	30	9
7bt1	750	0	0	0	-1	1	Y	1.8	-1	4	-1	8x10	4	5	4	2	2	30	9
3bc3	751	0	0	0	-1	1	Y	1.9	-1	5	-1	8x10	4	6	4	3	2	30	9
3bc3	752	0	0	0	-1	1	U	1	-1	5	-1	8x10	4	7	4	3	2	30	9
8bg9	753	0	0	0	-1	1	Y	1.6	-1	4	-1	8x10	4	8	4	4	2	30	9
8bg9	754	0	0	0	-1	1	U	1.3	-1	4	-1	8x10	4	9	4	4	2	30	9
2b6	755	0	0	0	-1	1	Y	1.7	-1	4	-1	8x10	4	10	4	5	2	30	9
2b6	756	0	0	0	-1	1	U	1.3	-1	4	-1	8x10	4	11	4	5	2	30	9
8gb2	757	0	0	0	-1	1	U	1.1	-1	4	-1	8x10	4	12	4	6	2	30	9
8gb2	758	deer broken	0	animal	-1	1	U	0.5	-1	4	-1	8x10	4	13	4	6	2	30	9
2b71	759	droopy form	0	0	-1	1	N	1.5	-1	4	-1	8x10	4	14	4	7	2	30	9
2b71	760	droopy form	0	0	-1	1	N	1.1	-1	4	-1	8x10	4	15	4	7	2	30	9
18bg2	761	0	0	0	-1	1	U	1.3	-1	4	-1	8x10	4	16	4	8	2	30	9
18bg2	762	deer broken	0	animal	-1	1	U	1.2	-1	-1	-1	8x10	4	17	4	8	2	30	9
18bg25	763	0	0	0	-1	1	U	1.2	-1	5	-1	8x10	4	18	4	9	2	30	9
18bg25	764	0	0	0	-1	1	U	1	-1	5	-1	8x10	4	19	4	9	2	30	9
2b21	765	0	0	0	-1	1	U	1.1	-1	4	-1	8x10	4	20	4	10	2	30	9
2b21	766	Weak, 8 inches of growth.	0	0	-1	1	N	0.9	-1	3	-1	8x10	4	21	4	10	2	30	9
a502	767	0	0	0	-1	1	U	1.4	-1	4	-1	8x10	4	22	4	11	2	30	9
1bw6	768	0	0	0	-1	1	Y	2.2	-1	5	-1	8x10	4	23	4	12	2	30	9
1bw6	769	0	0	0	-1	1	Y	2.3	-1	5	-1	8x10	4	24	4	12	2	30	9
23ba15	770	0	0	0	-1	1	Y	2.4	-1	5	-1	8x10	4	25	4	13	2	30	9
23ba15	771	0	0	0	-1	1	U	1.6	-1	5	-1	8x10	4	26	4	13	2	30	9
22bg1	772	0	0	0	-1	1	U	1.5	-1	4	-1	8x10	4	27	4	14	2	30	9
22bg1	773	0	0	0	-1	1	U	1.4	-1	4	-1	8x10	4	28	4	14	2	30	9
23ba18	774	0	0	0	-1	1	U	1.6	-1	5	-1	8x10	4	29	4	15	2	30	9
23ba18	775	0	0	0	-1	1	U	1.5	-1	4	-1	8x10	4	30	4	15	2	30	9
14b31	776	0	0	0	-1	1	U	1.3	-1	4	-1	8x10	4	31	4	16	2	30	9
14b31	777	0	0	0	-1	1	U	0.9	-1	4	-1	8x10	4	32	4	16	2	30	9
20bs1	778	wide	0	0	-1	1	U	2.1	-1	4	-1	8x10	4	33	4	17	2	30	9
20bs1	779	0	0	0	-1	1	U	1.8	-1	4	-1	8x10	4	34	4	17	2	30	9
23ba10	780	0	0	0	-1	1	U	1.4	-1	4	-1	8x10	4	35	4	18	2	30	9
23ba10	781	0	0	0	-1	1	U	1.3	-1	4	-1	8x10	4	36	4	18	2	30	9
105aa5	782	0	0	0	-1	1	U	1.3	-1	4	-1	8x10	4	37	4	19	2	30	9
105aa5	783	0	0	0	-1	1	U	1.5	-1	4	-1	8x10	4	38	4	19	2	30	9
100aa11	784	0	0	0	-1	1	U	1.8	-1	4	-1	8x10	4	39	4	20	2	30	9
100aa11	785	End of Row 4, Primary trees	0	0	-1	1	Y	2.3	-1	4	-1	8x10	4	40	4	20	2	30	9
gg7	786	Start row 4, Secondary planting. Deer browsed	0	animal	-1	0	U	0	-1	-1	-1	8x10	4	50	4	21	2	30	9
gg7	787	deer browsed	0	animal	-1	0	U	0	-1	-1	-1	8x10	4	51	4	21	2	30	9
gg7	788	deer browsed	0	animal	-1	0	U	0	-1	-1	-1	8x10	4	52	4	21	2	30	9
23ba2	789	stem destroyed, by wood chuck hole.	0	animal	-1	0	U	0	-1	-1	-1	8x10	4	53	4	22	2	30	9
104aa12	790	weak	0	0	-1	1	U	1.5	-1	4	-1	8x10	4	54	4	23	2	30	9
20bs6	791	0	0	0	-1	1	U	1.2	-1	4	-1	8x10	4	55	4	24	2	30	9
20bs8	792	0	0	0	-1	1	Y	2.1	-1	4	-1	8x10	4	56	4	25	2	30	9
11ab3	793	0	0	0	-1	1	U	1.7	-1	4	-1	8x10	4	57	4	26	2	30	9
106aa1	794	0	0	0	-1	1	Y	2	-1	4	-1	8x10	4	58	4	27	2	30	9
20bs5	795	0	0	0	-1	1	U	1.5	-1	4	-1	8x10	4	59	4	28	2	30	9
107aa7	796	End of Row 4, Secondary trees	0	0	-1	1	U	1.4	-1	4	-1	8x10	4	60	4	29	2	30	9
14b7	797	SW site corner	Demo1	c	1	1	U	5	160.02	-1	-1	9x9 	1	1	1	-1	1	40	12
14b7	798	0	Demo1	t	2	1	U	8	160.02	-1	-1	9x9 	2	1	1	-1	1	40	12
25r10	799	25xr family	Demo1	c	3	1	U	13	160.02	-1	-1	9x9 	3	1	1	-1	1	40	12
cag204	800	0	Demo1	c	4	1	U	6	160.02	-1	-1	9x9 	4	1	1	-1	1	40	12
dn34	801	Removed Tube at RL	Demo1	c	5	1	U	13	160.02	-1	-1	9x9 	5	1	1	-1	1	40	12
25r4	802	25xr family	Demo1	s	6	1	U	5	160.02	-1	-1	9x9 	6	1	1	-1	1	40	12
cag204	803	0	Demo1	s	7	1	U	5	160.02	-1	-1	9x9 	7	1	1	-1	1	40	12
te12	804	TxE family	Demo1	t	8	1	U	4	160.02	-1	-1	9x9 	1	2	2	-1	1	40	12
te3	805	TxE family	Demo1	c	9	1	U	5	160.02	-1	-1	9x9 	2	2	2	-1	1	40	12
dn34	806	0	Demo1	t	10	1	U	14	160.02	-1	-1	9x9 	3	2	2	-1	1	40	12
25r20	807	25xr family	Demo1	t	11	1	U	5	160.02	-1	-1	9x9 	4	2	2	-1	1	40	12
1bw6	808	0	Demo1	t	12	1	U	7	160.02	-1	-1	9x9 	5	2	2	-1	1	40	12
2b25	809	0	Demo1	s	13	1	U	7	160.02	-1	-1	9x9 	6	2	2	-1	1	40	12
14b7	810	0	Demo1	s	14	1	U	6	160.02	-1	-1	9x9 	7	2	2	-1	1	40	12
2b25	811	0	Demo1	t	15	1	U	7	160.02	-1	-1	9x9 	1	3	3	-1	1	40	12
cag204	812	0	Demo1	t	16	1	U	6	160.02	-1	-1	9x9 	2	3	3	-1	1	40	12
1bw6	813	0	Demo1	s	17	1	U	5	142.24	-1	-1	9x9 	3	3	3	-1	1	40	12
1bw6	814	0	Demo1	c	18	1	U	5	160.02	-1	-1	9x9 	4	3	3	-1	1	40	12
2b25	815	0	Demo1	c	19	1	U	8	160.02	-1	-1	9x9 	5	3	3	-1	1	40	12
dn34	816	0	Demo1	s	20	1	U	8	160.02	-1	-1	9x9 	6	3	3	-1	1	40	12
te6	817	TxE family	Demo1	s	21	1	U	6	160.02	-1	-1	9x9 	7	3	3	-1	1	40	12
25r5	818	May have figure	Demo2	s	22	1	U	7	160.02	-1	-1	9x9 	1	4	4	-1	1	40	12
agrr1	819	Has light figure	Demo2	s	23	1	U	2	124.46	-1	-1	9x9 	2	4	4	-1	1	40	12
agrr1	820	Has light figure	Demo2	s	24	1	U	4	160.02	-1	-1	9x9 	3	4	4	-1	1	40	12
2b29	821	Hard to split but, may not be figured	Demo2	s	25	1	U	5	160.02	-1	-1	9x9 	4	4	4	-1	1	40	12
23ba10	822	Good rooting P. alba back cross	Demo2	s	26	1	U	7	160.02	-1	-1	9x9 	5	4	4	-1	1	40	12
te15	823	law1, stem was next to root	Demo2	t	27	1	U	2	111.76	-1	-1	9x9 	1	5	5	-1	1	40	12
te15	824	law2, second stem next to root	Demo2	t	28	1	U	2	88.9	-1	-1	9x9 	2	5	5	-1	1	40	12
te15	825	law3, third stem next to root	Demo2	t	29	1	U	2	81.28	-1	-1	9x9 	3	5	5	-1	1	40	12
8bg3	826	Good rooting P. grandidentata back cross	Demo2	s	30	1	U	6	160.02	-1	-1	9x9 	4	5	5	-1	1	40	12
23ba10	827	Good rooting P. alba back cross	Demo2	s	31	1	U	5	160.02	-1	-1	9x9 	5	5	5	-1	1	40	12
1bw6	828	NE Site corner	Demo3	s	1	1	U	6	160.02	-1	-1	9x9 	1	1	1	-1	2	41	13
dn34	829	0	Demo3	c	2	1	U	13	160.02	-1	-1	9x9 	2	1	1	-1	2	41	13
25r10	830	25xr family	Demo3	s	3	1	U	9	160.02	-1	-1	9x9 	3	1	1	-1	2	41	13
2b25	831	0	Demo3	t	4	1	U	9	160.02	-1	-1	9x9 	4	1	1	-1	2	41	13
14b7	832	0	Demo3	c	5	1	U	7	160.02	-1	-1	9x9 	5	1	1	-1	2	41	13
1bw6	833	0	Demo3	s	6	1	U	10	160.02	-1	-1	9x9 	6	1	1	-1	2	41	13
te5	834	TxE family	Demo3	s	7	1	U	5	154.94	-1	-1	9x9 	7	1	1	-1	2	41	13
cag204	835	0	Demo3	c	8	1	U	6	160.02	-1	-1	9x9 	1	2	2	-1	2	41	13
dn34	836	0	Demo3	t	9	1	U	11	160.02	-1	-1	9x9 	2	2	2	-1	2	41	13
2b25	837	0	Demo3	s	10	1	U	12	160.02	-1	-1	9x9 	3	2	2	-1	2	41	13
14b7	838	0	Demo3	t	11	1	U	8	160.02	-1	-1	9x9 	4	2	2	-1	2	41	13
dn34	839	0	Demo3	s	12	1	U	11	160.02	-1	-1	9x9 	5	2	2	-1	2	41	13
25r4	840	25xr family	Demo3	t	13	1	U	10	160.02	-1	-1	9x9 	6	2	2	-1	2	41	13
cag204	841	0	Demo3	t	14	1	U	5	160.02	-1	-1	9x9 	7	2	2	-1	2	41	13
1bw6	842	0	Demo3	t	15	1	U	8	160.02	-1	-1	9x9 	1	3	3	-1	2	41	13
25r20	843	25xr family	Demo3	c	16	1	U	8	160.02	-1	-1	9x9 	2	3	3	-1	2	41	13
te7	844	TxE family	Demo3	c	17	1	U	6	160.02	-1	-1	9x9 	3	3	3	-1	2	41	13
cag204	845	0	Demo3	s	18	1	U	7	160.02	-1	-1	9x9 	4	3	3	-1	2	41	13
te1	846	TxE family	Demo3	t	19	1	U	5	160.02	-1	-1	9x9 	5	3	3	-1	2	41	13
14b7	847	0	Demo3	s	20	1	U	10	160.02	-1	-1	9x9 	6	3	3	-1	2	41	13
2b25	848	0	Demo3	c	21	1	U	9	160.02	-1	-1	9x9 	7	3	3	-1	2	41	13
23ba10	849	0	Demo4	t	22	1	U	8	160.02	-1	-1	9x9 	1	4	4	-1	2	41	13
23ba10	850	Has 6 SS staples	Demo4	s	23	1	U	5	160.02	-1	-1	9x9 	2	4	4	-1	2	41	13
gg8	851	PostNE - WEST Edge (Rows WtoE) - Start: 2017-PostNE-West-Measurement	dead	0	-1	0	U	-1	-1	-1	-1	4x6 	1	1	1	1	1	52	9
4gw10	852	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	2	1	2	1	52	9
2bg7	853	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	3	1	3	1	52	9
16ab2	854	Early Leaf Drop (ELD)	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	4	1	4	1	52	9
4gw13	855	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	5	1	5	1	52	9
20bs7	856	ELD	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	6	1	6	1	52	9
20bs3	857	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	7	1	7	1	52	9
16ab3	858	ELD	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	8	1	8	1	52	9
4ab7	859	ELD, Branchy	0	0	-1	1	N	-1	-1	-1	-1	4x6 	1	9	1	9	1	52	9
80aa3mf	860	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	10	1	10	1	52	9
80aa3mf	861	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	11	1	10	1	52	9
89aa1	862	Crooked form	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	12	1	11	1	52	9
89aa1	863	Crooked form	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	13	1	11	1	52	9
2b22	864	leaf miners	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	14	1	12	1	52	9
2b25	865	ELD	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	15	1	13	1	52	9
dn34	866	ELD	2017 get whips	0	-1	1	U	-1	-1	-1	-1	4x6 	1	16	1	17	1	52	9
dn34	867	ELD	2017 get whips, thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	17	1	17	1	52	9
dn34	868	ELD	2017 get whips	0	-1	1	U	-1	-1	-1	-1	4x6 	1	18	1	17	1	52	9
dn34	869	ELD	2017 get whips, thin later	animal	-1	1	U	-1	-1	-1	-1	4x6 	1	19	1	17	1	52	9
dn34	870	ELD	2017 get whips	0	-1	1	U	-1	-1	-1	-1	4x6 	1	20	1	17	1	52	9
1bw6	871	ELD	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	21	1	18	1	52	9
1bw6	872	ELD	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	22	1	18	1	52	9
105aa5	873	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	23	1	19	1	52	9
105aa5	874	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	24	1	19	1	52	9
1bw1	875	dry stem canker	2017 get whips	0	-1	1	N	-1	-1	-1	-1	4x6 	1	25	1	20	1	52	9
20bs1	876	bursting sleeve (why N score?, form?)	2017 get whips	0	-1	1	U	-1	-1	-1	-1	4x6 	1	26	1	21	1	52	9
1bw1	877	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	27	1	22	1	52	9
97aa11	878	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	28	1	24	1	52	9
3bc3	879	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	29	1	25	1	52	9
4ab9	880	bursting sleeve	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	30	1	26	1	52	9
4ab9	881	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	31	1	26	1	52	9
92aa11	882	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	32	1	27	1	52	9
92aa11	883	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	33	1	27	1	52	9
2b6	884	0	2017 get whips, thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	34	1	28	1	52	9
2b6	885	ELD	2017 get whips, thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	35	1	28	1	52	9
4ab4	886	ELD	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	36	1	29	1	52	9
4ab4	887	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	37	1	29	1	52	9
101aa11	888	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	38	1	30	1	52	9
101aa11	889	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	39	1	30	1	52	9
101aa11	890	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	40	1	30	1	52	9
2b4	891	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	41	1	31	1	52	9
2b64	892	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	42	1	32	1	52	9
2b50	893	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	43	1	33	1	52	9
2b62	894	ELD	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	44	1	34	1	52	9
c173	895	0	2017 get whips	0	-1	1	U	-1	-1	-1	-1	4x6 	1	45	1	35	1	52	9
c173	896	0	2017 get whips, thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	46	1	35	1	52	9
c173	897	0	2017 get whips	0	-1	1	U	-1	-1	-1	-1	4x6 	1	47	1	35	1	52	9
98aa11	898	good form	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	48	1	36	1	52	9
98aa11	899	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	49	1	36	1	52	9
98aa11	900	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	50	1	36	1	52	9
101aa11	901	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	51	1	37	1	52	9
101aa11	902	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	52	1	37	1	52	9
101aa11	903	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	1	53	1	37	1	52	9
105aa3	904	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	54	1	38	1	52	9
16ab7	905	ELD	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	55	1	39	1	52	9
105aa5	906	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	1	56	1	40	1	52	9
4gw11	907	Start 2017 row 1 secondary planting	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	57	1	41	2	52	9
zoss	908	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	58	1	42	2	52	9
2b66	909	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	59	1	43	2	52	9
98aa11	910	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	1	60	1	44	2	52	9
14b16	911	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	1	61	1	45	2	52	9
13gb6	912	Was incorrectly labeled 14b16	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	62	1	45	2	52	9
15b5	913	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	63	1	46	2	52	9
19gb1	914	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	64	1	47	2	52	9
14b18	915	Leaf specks	0	0	-1	1	Y	-1	-1	-1	-1	8x10	1	65	1	48	2	52	9
16ab1	916	ELD	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	66	1	49	2	52	9
14b6	917	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	67	1	50	2	52	9
18bg17	918	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	1	68	1	51	2	52	9
14b14	919	Nice!	0	0	-1	1	Y	-1	-1	-1	-1	8x10	1	69	1	52	2	52	9
14b30	920	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	70	1	53	2	52	9
2b24	921	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	71	1	54	2	52	9
15b14	922	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	72	1	55	2	52	9
19gb9	923	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	73	1	56	2	52	9
2b7	924	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	74	1	57	2	52	9
14b13	925	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	75	1	58	2	52	9
15b8	926	ELD	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	76	1	59	2	52	9
15b11	927	ELD	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	77	1	60	2	52	9
14b11	928	End of Row 1, Secondary trees	0	0	-1	1	U	-1	-1	-1	-1	8x10	1	78	1	61	2	52	9
4gw11	929	Start row 2, secondary trees	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	1	2	1	1	52	9
2b73	930	ELD - May be tallest tree, with 12 feet of growth in 2017.	0	0	-1	1	Y	-1	-1	-1	-1	4x6 	2	2	2	2	1	52	9
4gw12	931	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	3	2	3	1	52	9
2b68	932	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	4	2	4	1	52	9
16ab4	933	ELD	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	5	2	5	1	52	9
16ab8	934	bursting sleeve	0	0	-1	1	Y	-1	-1	-1	-1	4x6 	2	6	2	6	1	52	9
20bs9	935	branchy, buck rubbed, sprouty	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	7	2	7	1	52	9
16ab1	936	ELD	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	8	2	8	1	52	9
98aa11	937	0	Thin later	0	-1	1	Y	-1	-1	-1	-1	4x6 	2	9	2	9	1	52	9
98aa11	938	0	0	0	-1	1	Y	-1	-1	-1	-1	4x6 	2	10	2	9	1	52	9
98aa11	939	0	Thin later	0	-1	1	Y	-1	-1	-1	-1	4x6 	2	11	2	11	1	52	9
98aa11	940	ELD	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	2	12	2	11	1	52	9
2b29	941	buck rubbed	2017 get whips	animal	-1	1	U	-1	-1	-1	-1	4x6 	2	13	2	12	1	52	9
97aa11	942	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	14	2	13	1	52	9
zoss	943	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	15	2	14	1	52	9
2b6	944	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	16	2	15	1	52	9
100aa12	945	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	17	2	16	1	52	9
95aa11	946	branchy	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	18	2	17	1	52	9
95aa11	947	branchy	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	2	19	2	17	1	52	9
105aa3	948	ELD, branchy	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	2	20	2	18	1	52	9
105aa3	949	branchy	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	21	2	18	1	52	9
14b7	950	0	2017 get whips	0	-1	1	U	-1	-1	-1	-1	4x6 	2	22	2	19	1	52	9
105aa3	951	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	2	23	2	20	1	52	9
105aa3	952	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	24	2	20	1	52	9
zoss	953	branchy	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	2	25	2	25	1	52	9
zoss	954	branchy	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	26	2	25	1	52	9
2b3	955	0	2017 get whips	0	-1	1	N	-1	-1	-1	-1	4x6 	2	27	2	26	1	52	9
2b3	956	branch tree top, leaf spots	2017 get whips, thin later	0	-1	1	N	-1	-1	-1	-1	4x6 	2	28	2	26	1	52	9
2b3	957	branch tree top, leaf spots. 2017 FW split figured wood sample	2017 get whips	0	-1	1	N	-1	-1	-1	-1	4x6 	2	29	2	26	1	52	9
2b25	958	branch tree top, leaf spots	2017 get whips	0	-1	1	U	-1	-1	-1	-1	4x6 	2	30	2	27	1	52	9
2b25	959	0	2017 get whips, thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	2	31	2	27	1	52	9
100aa11	960	0	2017 get whips	0	-1	1	Y	-1	-1	-1	-1	4x6 	2	32	2	28	1	52	9
100aa11	961	0	2017 get whips, thin later	0	-1	1	Y	-1	-1	-1	-1	4x6 	2	33	2	28	1	52	9
100aa11	962	branchy	2017 get whips	0	-1	1	Y	-1	-1	-1	-1	4x6 	2	34	2	28	1	52	9
100aa12	963	0	Thin later	0	-1	1	Y	-1	-1	-1	-1	4x6 	2	35	2	29	1	52	9
100aa12	964	0	0	0	-1	1	Y	-1	-1	-1	-1	4x6 	2	36	2	29	1	52	9
97aa12	965	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	2	37	2	30	1	52	9
97aa12	966	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	2	38	2	30	1	52	9
2b71	967	0	2017 get whips	0	-1	1	U	-1	-1	-1	-1	4x6 	2	39	2	31	1	52	9
2b22	968	Nice! good clone	0	0	-1	1	Y	-1	-1	-1	-1	4x6 	2	40	2	32	1	52	9
2b22	969	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	2	41	2	32	1	52	9
2b22	970	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	42	2	32	1	52	9
cag204	971	ELD	2017 get whips	0	-1	1	U	-1	-1	-1	-1	4x6 	2	43	2	33	1	52	9
2b21	972	ELD, leaf bug issues	0	0	-1	1	N	-1	-1	-1	-1	4x6 	2	44	2	34	1	52	9
2b21	973	ELD, leaf bug issues	Thin later	0	-1	1	N	-1	-1	-1	-1	4x6 	2	45	2	34	1	52	9
2b6	974	0	2017 get whips	0	-1	1	U	-1	-1	-1	-1	4x6 	2	46	2	35	1	52	9
2b6	975	0	2017 get whips, thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	2	47	2	35	1	52	9
2b6	976	0	2017 get whips	0	-1	1	U	-1	-1	-1	-1	4x6 	2	48	2	35	1	52	9
2b25	977	whip with 1 inch roots	0	0	-1	1	Y	-1	-1	-1	-1	4x6 	2	49	2	36	1	52	9
2b3	978	0	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	50	2	37	1	52	9
2b3	979	0	Thin later	0	-1	1	U	-1	-1	-1	-1	4x6 	2	51	2	37	1	52	9
2b3	980	ELD	0	0	-1	1	U	-1	-1	-1	-1	4x6 	2	52	2	37	1	52	9
2b21	981	buggy, branchy	2017 get whips	0	-1	1	N	-1	-1	-1	-1	4x6 	2	53	2	38	1	52	9
2b21	982	0	2017 get whips, thin later	0	-1	1	N	-1	-1	-1	-1	4x6 	2	54	2	38	1	52	9
2b21	983	0	2017 get whips	0	-1	1	N	-1	-1	-1	-1	4x6 	2	55	2	38	1	52	9
2b21	984	0	2017 get whips	0	-1	1	N	-1	-1	-1	-1	4x6 	2	56	2	38	1	52	9
93aa11	985	Start 2017 row 2 secondary planting, buggy	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	57	2	39	1	52	9
93aa11	986	buggy	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	58	2	39	1	52	9
2b80	987	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	2	59	2	40	1	52	9
8bg8	988	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	60	2	41	1	52	9
6ba2	989	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	61	2	42	1	52	9
2b55	990	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	62	2	43	1	52	9
4ab9	991	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	2	63	2	44	1	52	9
8bg21	992	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	64	2	45	1	52	9
2b67	993	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	2	65	2	46	1	52	9
2b63	994	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	66	2	47	1	52	9
2b68	995	buggy leaves	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	67	2	48	1	52	9
3bc4	996	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	2	68	2	49	1	52	9
aag2001	997	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	69	2	50	1	52	9
aag2001	998	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	70	2	50	1	52	9
7bt7	999	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	71	2	51	1	52	9
83aa70	1000	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	72	2	52	1	52	9
ae3	1001	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	73	2	53	1	52	9
ae3	1002	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	74	2	53	1	52	9
2b62	1003	ELD	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	75	2	54	1	52	9
aa4102	1004	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	76	2	55	1	52	9
11ab10	1005	Was aa4102, Replaced with 11ab10 on 3/20/18.	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	77	2	55	1	52	9
92aa11	1006	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	78	2	56	1	52	9
3bc5	1007	ELD	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	79	2	57	1	52	9
tc72	1008	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	80	2	58	1	52	9
1bw6	1009	Was tc72, replaced withe 1bw6 on 3/20/18. (very small, 1/4 inch diameter)	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	81	2	58	1	52	9
14b19	1010	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	82	2	59	1	52	9
14b4	1011	End of Row 2, Secondary trees	0	0	-1	1	U	-1	-1	-1	-1	8x10	2	83	2	60	1	52	9
dn34	1012	Start 2017 row 3 Primary clones	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	1	3	1	2	52	9
dn34	1013	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	2	3	1	2	52	9
dn34	1014	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	3	3	1	2	52	9
4ab4	1015	ELD	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	4	3	2	2	52	9
4ab4	1016	ELD	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	5	3	2	2	52	9
cag204	1017	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	6	3	3	2	52	9
5br3	1018	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	7	3	4	2	52	9
5br3	1019	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	8	3	4	2	52	9
8bg3	1020	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	3	9	3	3	2	52	9
8bg3	1021	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	3	10	3	3	2	52	9
2b52	1022	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	11	3	4	2	52	9
2b52	1023	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	12	3	4	2	52	9
dn34	1024	Was 2b55, replaced with a 1/2 inch dia dn34.	0	0	-1	0	U	-1	-1	-1	-1	8x10	3	13	3	5	2	52	9
2b55	1025	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	14	3	5	2	52	9
18bg19	1026	leaf spot	0	0	-1	1	N	-1	-1	-1	-1	8x10	3	15	3	6	2	52	9
18bg19	1027	leaf spot (dear pruned to 3' in 2017)	0	0	-1	1	N	-1	-1	-1	-1	8x10	3	16	3	6	2	52	9
3bc1	1028	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	3	17	3	7	2	52	9
3bc1	1029	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	18	3	7	2	52	9
2b3	1030	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	19	3	8	2	52	9
2b3	1031	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	20	3	8	2	52	9
2b25	1032	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	3	21	3	9	2	52	9
2b25	1033	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	3	22	3	9	2	52	9
11ab10	1034	wide form, bad leaves	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	23	3	10	2	52	9
11ab10	1035	wide form, bad leaves	0	0	-1	1	Y	-1	-1	-1	-1	8x10	3	24	3	10	2	52	9
11ab22	1036	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	3	25	3	11	2	52	9
11ab22	1037	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	3	26	3	11	2	52	9
14b7	1038	wide form	0	0	-1	1	Y	-1	-1	-1	-1	8x10	3	27	3	12	2	52	9
14b7	1039	wide form	0	0	-1	1	Y	-1	-1	-1	-1	8x10	3	28	3	12	2	52	9
14b21	1040	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	3	29	3	13	2	52	9
14b21	1041	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	3	30	3	13	2	52	9
14b10	1042	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	31	3	14	2	52	9
14b10	1043	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	32	3	14	2	52	9
16ab8	1044	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	33	3	15	2	52	9
16ab8	1045	Note bare root whip planted after this tree; col=34.5, Leaf=4, DBH=1.8 	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	34	3	15	2	52	9
23ba11	1046	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	35	3	16	2	52	9
23ba11	1047	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	36	3	16	2	52	9
100aa12	1048	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	37	3	17	2	52	9
100aa12	1049	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	38	3	17	2	52	9
105aa3	1050	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	39	3	18	2	52	9
105aa3	1051	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	40	3	18	2	52	9
106aa7	1052	End of Row 3, Primary trees	0	0	-1	1	Y	-1	-1	-1	-1	8x10	3	41	3	19	2	52	9
dn34	1053	Start row 3, Secondary trees (was col 42, now col 47 with new trees added in gaps)	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	42	3	20	2	52	9
11ab1	1054	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	43	3	20	2	52	9
23ba18	1055	Was incorrectly named 14b30.	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	44	3	21	2	52	9
3bc3	1056	Redish leaves/stems, weak?	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	45	3	22	2	52	9
dn34	1057	Very redish, weak? ELD	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	46	3	22	2	52	9
2b29	1058	stem broken	0	animal	-1	0	U	-1	-1	-1	-1	8x10	3	47	3	23	2	52	9
2b29	1059	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	48	3	20	2	52	9
14b3	1060	Was incorrectly named 14b30.	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	49	3	21	2	52	9
2b4	1061	Redish leaves/stems, weak?	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	50	3	22	2	52	9
2b4	1062	Very redish, weak? ELD	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	51	3	22	2	52	9
2b25	1063	stem broken (End, was col 47, now col 52) (was 22bg8 replaced 3/22/18)	0	animal	-1	0	U	-1	-1	-1	-1	8x10	3	52	3	23	2	52	9
14b17	1064	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	53	3	24	2	52	9
14b21	1065	deer broken, Was 23ba5, replaced 3/22/18)	0	animal	-1	0	U	-1	-1	-1	-1	8x10	3	54	3	25	2	52	9
11ab11	1066	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	55	3	26	2	52	9
106aa3	1067	ELD	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	56	3	27	2	52	9
22bg7	1068	End of Row 3, Secondary trees	0	0	-1	1	U	-1	-1	-1	-1	8x10	3	57	3	28	2	52	9
dn34	1069	Start 2017 row 4 Primary clones	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	1	4	1	2	52	9
dn34	1070	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	2	4	1	2	52	9
dn34	1071	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	3	4	1	2	52	9
7bt1	1072	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	4	4	2	2	52	9
7bt1	1073	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	4	5	4	2	2	52	9
3bc3	1074	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	4	6	4	3	2	52	9
3bc3	1075	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	7	4	3	2	52	9
8bg9	1076	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	4	8	4	4	2	52	9
8bg9	1077	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	9	4	4	2	52	9
2b6	1078	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	4	10	4	5	2	52	9
2b6	1079	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	11	4	5	2	52	9
8gb2	1080	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	12	4	6	2	52	9
23ba20	1081	deer broken, was 8bg2, replaced on 3/22/18 3/4 inch dia, curly	0	animal	-1	1	U	-1	-1	-1	-1	8x10	4	13	4	6	2	52	9
2b71	1082	droopy form	0	0	-1	1	N	-1	-1	-1	-1	8x10	4	14	4	7	2	52	9
2b71	1083	droopy form	0	0	-1	1	N	-1	-1	-1	-1	8x10	4	15	4	7	2	52	9
18bg2	1084	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	16	4	8	2	52	9
23ba20	1085	deer broken, was 18bg2, replaced on 3/22/18 (1/4 dia)	0	animal	-1	1	U	-1	-1	-1	-1	8x10	4	17	4	8	2	52	9
18bg25	1086	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	18	4	9	2	52	9
18bg25	1087	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	19	4	9	2	52	9
2b21	1088	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	20	4	10	2	52	9
2b21	1089	Weak, 8 inches of growth.	0	0	-1	1	N	-1	-1	-1	-1	8x10	4	21	4	10	2	52	9
a502	1090	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	22	4	11	2	52	9
1bw6	1091	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	4	23	4	12	2	52	9
1bw6	1092	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	4	24	4	12	2	52	9
23ba15	1093	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	4	25	4	13	2	52	9
23ba15	1094	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	26	4	13	2	52	9
22bg1	1095	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	27	4	14	2	52	9
22bg1	1096	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	28	4	14	2	52	9
23ba18	1097	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	29	4	15	2	52	9
23ba18	1098	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	30	4	15	2	52	9
14b31	1099	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	31	4	16	2	52	9
14b31	1100	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	32	4	16	2	52	9
20bs1	1101	wide	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	33	4	17	2	52	9
20bs1	1102	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	34	4	17	2	52	9
23ba10	1103	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	35	4	18	2	52	9
23ba10	1104	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	36	4	18	2	52	9
105aa5	1105	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	37	4	19	2	52	9
105aa5	1106	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	38	4	19	2	52	9
100aa11	1107	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	39	4	20	2	52	9
100aa11	1108	Was end of Row 4, Primary trees	0	0	-1	1	Y	-1	-1	-1	-1	8x10	4	40	4	20	2	52	9
2b25	1109	Added new on 3/22/18.	0	0	-1	1	Y	-1	-1	-1	-1	8x10	4	41	4	20	2	52	9
14b10	1110	Added new on 3/22/18.	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	42	4	21	2	52	9
a502	1111	Added new on 3/22/18.	0	0	-1	1	Y	-1	-1	-1	-1	8x10	4	43	4	22	2	52	9
2b13	1112	End of Row 4, Primary trees, Added new on 3/22/18.	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	44	4	23	2	52	9
11ab22	1113	Start row 4, Secondary planting. Deer browsed. Was gg7 replaced on 3/22/18, 10mm	0	0	-1	0	U	-1	-1	-1	-1	8x10	4	50	4	24	2	52	9
20bs8	1114	deer browsed. Was gg7 replaced on 3/22/18	0	0	-1	0	U	-1	-1	-1	-1	8x10	4	51	4	24	2	52	9
20bs1	1115	deer browsed. Was gg7 replaced on 3/22/18	0	0	-1	0	U	-1	-1	-1	-1	8x10	4	52	4	24	2	52	9
16ab8	1116	stem destroyed, by wood chuck hole. Was 23ba2 replaced 3/22/18	0	0	-1	0	U	-1	-1	-1	-1	8x10	4	53	4	25	2	52	9
2b25	1117	was 104aa12, replaced 3/22/18	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	54	4	26	2	52	9
20bs6	1118	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	55	4	27	2	52	9
20bs8	1119	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	4	56	4	28	2	52	9
11ab3	1120	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	57	4	29	2	52	9
106aa1	1121	0	0	0	-1	1	Y	-1	-1	-1	-1	8x10	4	58	4	30	2	52	9
20bs5	1122	0	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	59	4	31	2	52	9
107aa7	1123	End of Row 4, Secondary trees	0	0	-1	1	U	-1	-1	-1	-1	8x10	4	60	4	32	2	52	9
northfox	1124	Start of Row 5, mix of trees	0	0	-1	1	U	0.5	-1	-1	-1	8x8 	5	1	5	1	3	52	9
14b31	1125	0	0	0	-1	1	U	0.7	-1	-1	-1	8x8 	5	2	5	2	3	52	9
dn34	1126	0	0	0	-1	1	U	1.2	-1	-1	-1	8x8 	5	3	5	3	3	52	9
1bw6	1127	0	0	0	-1	1	U	0.4	-1	-1	-1	8x8 	5	4	5	4	3	52	9
23ba35	1128	0	0	0	-1	1	U	0.9	-1	-1	-1	8x8 	5	5	5	5	3	52	9
dn34	1129	0	0	0	-1	1	U	1.3	-1	-1	-1	8x8 	5	6	5	6	3	52	9
11ab31	1130	0	0	0	-1	1	U	0.9	-1	-1	-1	8x8 	5	7	5	7	3	52	9
23ba33	1131	0	0	0	-1	1	U	0.9	-1	-1	-1	8x8 	5	8	5	8	3	52	9
7b21	1132	0	0	0	-1	1	U	0.8	-1	-1	-1	8x8 	5	9	5	9	3	52	9
25r14	1133	0	0	0	-1	1	U	0.8	-1	-1	-1	8x8 	5	10	5	10	3	52	9
aa4102	1134	0	0	0	-1	1	U	0.8	-1	-1	-1	8x8 	5	11	5	11	3	52	9
14b7	1135	0	0	0	-1	1	U	1	-1	-1	-1	8x8 	5	12	5	12	3	52	9
8bg3	1136	0	0	0	-1	1	U	0.8	-1	-1	-1	8x8 	5	13	5	13	3	52	9
25r4	1137	0	0	0	-1	1	U	0.7	-1	-1	-1	8x8 	5	14	5	14	3	52	9
23ba15	1138	0	0	0	-1	1	U	1.3	-1	-1	-1	8x8 	5	15	5	15	3	52	9
25r2	1139	0	0	0	-1	1	U	1.2	-1	-1	-1	8x8 	5	16	5	16	3	52	9
3bc5	1140	0	0	0	-1	1	U	1	-1	-1	-1	8x8 	5	17	5	17	3	52	9
2b25	1141	End of Row 5, Mixed trees	0	0	-1	1	U	0.8	-1	-1	-1	8x8 	5	1	5	18	3	52	9
23ba37	1142	Start of Row 6, mix of trees	0	0	-1	1	U	0.8	-1	-1	-1	8x8 	6	2	5	19	3	52	9
1bw6	1143	0	0	0	-1	1	U	0.9	-1	-1	-1	8x8 	6	3	5	20	3	52	9
1bw6	1144	0	0	0	-1	1	U	0.6	-1	-1	-1	8x8 	6	4	5	21	3	52	9
2b25	1145	0	0	0	-1	1	U	0.8	-1	-1	-1	8x8 	6	5	5	22	3	52	9
14b61	1146	0	0	0	-1	1	U	0.9	-1	-1	-1	8x8 	6	6	5	23	3	52	9
2b71	1147	0	0	0	-1	1	U	0.8	-1	-1	-1	8x8 	6	7	5	24	3	52	9
15b8	1148	0	0	0	-1	1	U	0.8	-1	-1	-1	8x8 	6	8	5	25	3	52	9
dn34	1149	0	0	0	-1	1	U	1.1	-1	-1	-1	8x8 	6	9	5	26	3	52	9
4ab4	1150	0	0	0	-1	1	U	0.9	-1	-1	-1	8x8 	6	10	5	27	3	52	9
c173	1151	0	0	0	-1	1	U	0.8	-1	-1	-1	8x8 	6	11	5	28	3	52	9
23ba15	1152	0	0	0	-1	1	U	1.1	-1	-1	-1	8x8 	6	12	5	29	3	52	9
25r7	1153	0	0	0	-1	1	U	1	-1	-1	-1	8x8 	6	13	5	30	3	52	9
23ba10	1154	0	0	0	-1	1	U	0.8	-1	-1	-1	8x8 	6	14	5	31	3	52	9
25r19	1155	0	0	0	-1	1	U	1.7	-1	-1	-1	8x8 	6	15	5	32	3	52	9
23ba21	1156	0	0	0	-1	1	U	0.9	-1	-1	-1	8x8 	6	16	5	33	3	52	9
23ba2	1157	Curly	0	0	-1	1	U	1.2	-1	-1	-1	8x8 	6	17	5	34	3	52	9
\.


--
-- Name: field_trial_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('field_trial_id_seq', 1, false);


--
-- Data for Name: journal; Type: TABLE DATA; Schema: public; Owner: user
--

COPY journal (journal_key, id, notes, author, id_plant, id_family, id_test_spec, id_site, date, web_url) FROM stdin;
TBD	1	To Be Determined	0	2	2	2	2	1111-11-11	0
NA	2	Does Not Apply	0	2	2	2	2	1111-11-11	0
2010-Bell-Nursery-update	3	The 2010 Phase 3 Breeding Project was successful.  There were 19 P. alba crosses produced resulting in over 5,000 seedlings that were grown by Patrick McGovern and Brad Bender.  There are about 40 selections that will be carried forward into the 2012 season for further evaluation.  There is an estimated 34,000 plus seeds remaining from the Phase 3 crosses.  The 83xAA04 family continues to show good rooting performance.  Thirteen ASP/SASP shoot rooting tests were performed, resulting in 4 selections that will be compared to the parent family 100xAA10 for hardwood cutting rooting performance. Seven 6 foot plus alba whips were planted in the nursery to evaluate this process.  All survived and more tests are planned for 2012. Two well stocked 288 cell flats were planted as is to evaluate whole flat planting as an early selection technique.  The results were interesting with the high survival rate and 17 selections.	pmcgovern	1	1	1	1	2010-12-16	0
2011-Bell-Nursery-update	4	I have posted my 2011 Bell Nursery Results that describe dormant cuttingrooting results and selections from Phase 3 families (P3) and Phase 2(P2) clones.  I expect to replant the selections in the 2012 nursery withat least 20 cuttings each.  The 2011 growing season was very good withample Spring moisture and Summer heat.  I planted the more standardized 6" cuttings instead of 4" and am pleased with the results.It was interesting to watch the growth of the 4 rooted 1-0 83AA204 treescut back to 3" root and shoots.  Two of these stools grew 12' in thenursery this year!  See the 2011 Bell Nursery Photos for more details.	pmcgovern	1	1	1	1	2011-11-01	0
2012-bell-nursery	5	Planted 2012-bell-nursery.\tHalf of the 2012 cutting stock was stored in the Bell Ave. refrigerator and sprouted/rooted due to high temperatures.  The other half was stored in Ryans refrigerator and suffered no damage.  About 1/4 of the entire stock was severely impacted by this issue.   All of the pre-maturely rooted stock was planted at the beginning of each replication.  The second replication was affected the most.  I planted the stock as is by forcing them into the ground with no special treatment.  March was much warmer than April (first time in 100yrs) and April had many frosty mornings which may have been stressful on cuttings.  The nursery was kept moist as needed with irrigation. 	pmcgovern	2	2	14	2	2012-04-06	0
2012-bell-nursery	6	I put red straws next to early and vigorously growing and good rooting clones.  Selection criteria was for clones with at least 90% survival and averaging at least 6 height on 5/30/12.	pmcgovern	2	2	14	2	2012-05-30	0
2011-RNE-AlbaPolePlanting	7	Planted 3 clones at RNE as pole stock in early November 2011.  I used a 2 foot auger attached to a portable drill.  	pmcgovern	2	2	17	2	2011-11-05	0
2011-RNE-AlbaPolePlanting	8	On 4/21/12 I sprayed Round around these pole plantings.  We had a warmer March and a frosty/cold April.  It really hit these hard... 	pmcgovern	2	2	17	2	2012-04-21	0
2011-RNE-AlbaPolePlanting	9	On 6/23/12. I sprayed Round around these pole plantings.  Only one 83AA204 tree survived and it was pruned back by deer browse...	pmcgovern	2	2	17	2	2012-06-23	0
2011-1xCAGW-Cross	10	Planted 2 flats of this 2011 seed in 2012, cut tips today.\tObserved that there are 2 general types of seedlings, alba (tomentose on leaf undersides) and aspen like (no tomentose) on leaf undersides.  I counted 174 total seedlings in Flat B with 47 aspen types (27%) and 109 in Flat A with 33 aspen types (30%). 	pmcgovern	2	2	16	2	2012-06-23	0
2012-2xCAG12-Cross	11	C173 x AG15 - planted about 350 seedlings on 6/16/12 that were grown indoors under flourescent lights.  Seedlings today are average 5 tall and in good health.	pmcgovern	2	2	15	2	2012-06-28	0
1CAGW01	12	Selected this clone today from the 1xCAGW family.  It is vigorous and leaves are healthy.  Observed another aspen like clone from the same family with yellow rust like leaf spots...	pmcgovern	181	171	14	2	2012-06-28	0
2012-2xCAG12-Cross	13	Most of the 2xCAG12 seedlings have set bud.  A few are over 6' tall, some are 5' tall the average is about 4' tall.  While all seedlings have obvious alba influence, many have more aspen or alba traits in terms of tomentose on leaf and stems and some have alba leaves vs the aspen types that have the more intermediate (AG) type leaves.\t	pmcgovern	2	173	15	2	2012-08-28	0
2012-bell-nursery	14	I surveyed the 2012 Bell nursery today to see what is still actively growing and what has set bud. In general most of my albas and 1xCAGW materials started from 6 cuttings that are over 5' are still growing and those 5' or less have set bud. The 2xCAG12 seedlings average about 4' tall with most (95% ?) having set bud. The 1xCAGW seedlings average about 3' tall with about 65% still actively growing. Those 1xCAGW seedlings were planted 7/2/12 and with Miracle Grow 20:20:20 soluble fertilzer applied several times to help increase growth.	pmcgovern	2	2	14	2	2012-09-03	0
RevisedExternalPlant-IDs	15	The current plant naming standard for external selections is too long and does not scale. A new Plant id syntax is as follows: [NbrLetterFamilyID][ExternalSiteIDNbr][SiteLocationCode].  Example: 83AA3MF where 83AA is the Family ID, 3 is the External site ID number, MF stands for MSU FBIC location code that is persisted in the Site table.	pmcgovern	182	2	2	8	2012-09-03	0
2011-1xCAGW-Cross	16	Selected 30 trees with numbered yellow tags. Selected for vigor, straightness and aspen traits (no tomentose).  These will be made into 6 cuttings and tested for rooting in 2013 nursery.  About 50% more have set bud since 9/1, but some have re-sprouted.	pmcgovern	2	2	16	2	2012-09-15	0
2012-2xCAG12-Cross	17	Selected 30 trees with numbered yellow tags. Selected for vigor, straightness and some with more aspen traits.  These will be made into 6 cuttings and tested for rooting in 2013 nursery.  Most have set bud.	pmcgovern	2	2	15	2	2012-09-15	0
2012-bell-nursery	18	In general only a few and the tallest albas have NOT set bud.  We had a hard frost this morning 10/8/12 - hard enough to kill the garden...  	pmcgovern	2	2	14	2	2012-10-08	0
2012-field	19	RNE - 6th 9xAG91 tree from south edge is nice well formed male and should be crossed with C173 - it often scored light BLD.  CSSE - Lots of flowers on CAG177, AE42, TA10 some, POST - Triploid TE male has flowers., 	pmcgovern	2	2	2	2	2012-10-08	0
2012-bell-nursery	20	Lifted the last of the Bell Nursery trees - It took about 1 week.\tHeeled them into 3 rows, first is all alba/aspens from 6 cuttings, second is 2xCAG12 seedlings in 3 groups (5 most vigorous, 30 for WASP, rest for wasp tips).\tThird row is 1xCAGw.  	pmcgovern	2	2	14	2	2012-11-23	0
2013-bell-nursery	40	7/20/13: 1CAGW01 Rooting observations. I planted 7 replications of this clone in the 2013 nursery with 10 - 6 cuttings with diameters ranging from 14 to 3 mm. I just scored these 7 replications for survival of cuttings 10mm or greater. There was 83% survival from 33 total 6 cuttings that were 10 mm or greater in diameter. This compares to 60% (26/43) survival in my nursery for DN34 5 cuttings greater than 13mm.  Ideally I should have planted cuttings 10mm or greater.	pmcgovern	1	1	1	1	2013-07-20	0
2012-Bell-Nursery-Results	21	The 2012 Bell Nursery consisted of over 94 clones and over 2000 6" cuttings planted in 10 count sets of 1 to 3 replications.  Sixteen clones have been selected representing 10 different families. A VigorSurvival metric was used as the primary selection model. It consisted ofmultiplying the survival rate by the median diameter (mm) from each cloneset. The speculation is that this model may select clones that root welland grow more vigorously in the first year of a field planting.  The top 13 selections had a rooting average of 84% via 24 replications with atotal of 240 6" dormant cuttings.  Thirteen clones had at least 2 yearsof propagation testing.  Three clones are from the 1xCAGW family (CAG204 xOpen Pollinated) and have P. grandidentata and P. tremula characteristics.There were 150+ seedlings grown from the family 2xCAG12 (AG15 x C173).The parents of this cross have performed well in Michigan's UpperPeninsula.  The 2013-02-02-B WASP Test Observations: A 16 day WASP testof the 16 2012 aspen selections.  It compared each clone's dormant 4" tip cutting rooting potential with test parameters: no-soak and 4, 4" tip cuttings/clone using the WASP protocol.  The average rooting was 89% which compares to 79% average rooting for the 16 2012 nursery selections.  Nine of the 16 clones rooted 100%, however only 1 of the 9 rooted via ASP shoot after 11 days.  The 2013-02-02-C 2xCAG12 WASP Test Observations:  A16 day WASP test of 2xCAG12 aspen ortet cuttings to compare tip rootingresults with a potential rooting percent metric. The average tray(1 clone/tray) rooting was 65%. The average tray score was 20.05 (maxis 60). The CAG204 control may have been compromised but it rooted 25%and scored at 13. I replanted the best 9 clones and may ramp 5 of themfor a potential 2014 test.  There were 33 test ortets 24% (8/33) and8 ortets that had a perfect score of 60. I expect perhaps 4 of these perfect rooters to show good rooting in the 2013 nursery and perhapsa few that had low scores as well.	pmcgovern	1	1	1	1	2013-04-10	0
WASP-2013-A	22	A 2013 WASP rooting test involving 93AA12 that rooted 60% (24/40) in 2012 and 15AG4MF (aka AG15) that did not root at all.   It was interesting to note how poor the water soak tests performed, but it could be chance since there were only 2 reps and one rep had small diameter cuttings or that the 24hr soak was just too long.  I certainly need to decrease the number of treatments and increase the number of reps.  The willow soak treatment was interesting and might be worth another look but I am sticking to no pre-soaks for my upcoming ramp ups.  I guess it was not too surprising that 100% of the 93AA12 cuttings of at least 7mm dia rooted, but it is a bit surprising to see that all 4 of the 93AA12 tips (2-3mm dia) also rooted.  Clone 93AA12 rooted 60% (24/40) in 2012 nursery, and it rooted 88% in this test (avg of both No Soak tests).  If this type of difference is real (repeatable over time), then perhaps these WASP test stats could have more value in selecting good rooting clones than field rooting results that are subject to more variation.	pmcgovern	193	2	18	6	2013-02-01	https://docs.google.com/spreadsheet/ccc?key=0Ar-SwoTVeWFadEFfYW11X21iamFKX0tKNHRsWWlrR3c#gid=13
2013-breeding-observations	23	2013 Breeding update: On 2/23/13 - Collected AE42 and CAG177 male branches, all from CSSE.  Started forcing CAG177 branches.  On 3/16/13 - Collected AGRR1 male branches and the new female 15xAG91 selection, 15AG11, both from RNE.  Also collected 2 branch sets of CAG204 and A502.  Collected all AE42 pollen on 3/18/13.  The AGRR1 branches were taken from a 14" trunk.  Flowers were somewhat sparse and observed that most were male but 2 branches may have female buds.	pmcgovern	2	2	19	6	2013-03-19	https://docs.google.com/spreadsheet/ccc?key=0Ar-SwoTVeWFadDhTNGtibW51amt0Z1JHYmw5SGdjRXc#gid=3
ASP-2013-D	24	3/26/13: The 2xCAG12 WASP to ASP cuttings failed.  Ortets #26 and #30 did root as ASP but poorly.  Perhaps my ASP conditions were bad, perhaps these CAG clones can root but not ASP meaning there is little to no correlation between dormant stem rooting and ASP rooting.	pmcgovern	1	1	1	1	2013-03-26	0
2013-breeding-observations	25	3/26/13: The suspected AGRR1 female branches were in fact male - just smaller...  Also the AGRR1 had fewer male flower buds but they produced abundant pollen.\tI started the CAG204 and AG??? females for the AGRR1 pollen.	pmcgovern	1	1	1	1	2013-03-26	0
2013-breeding-observations	26	4/12/13: Obtaining large quantities of high quality seed from 3xCAGC.  The cross 4xACAG (A502 x CAG177) is finished.  Likely over 1000 seeds were produced, but it did not appear as productive as other AxA crosses with this female.	pmcgovern	1	1	1	1	2013-04-12	0
2013-breeding-observations	27	4/13/13: Collected female flower branches from HCRA for the new clone 3AA202.  It is a diverse clone with fairly good form, vigor and durability (23yrs old).  I will attempt WASP propagation of some 3AA02 tips.  I also tagged a lone survivor of 21xaa91 family on the North West side that has nice form, durability and vigor for this site (21 yrs old).	pmcgovern	1	1	1	1	2013-04-13	0
2013-field	28	4/13/13: Sprayed canned prunning sealer onto all trees at 5/3 lot - up to 3' high.  Planted all left over stock at Post NE.  Planted on East edge of site on 4' x 8' spacings.	pmcgovern	1	1	1	1	2013-04-13	0
2013-breeding-observations	29	4/17/13:\tFertilized 2 sets of 3AA202 female branches with NorthFox alba (NFA) and AGRR1 pollen.\tThe 3AA202 clone had a lot of flowers and was fertilized when the catkins were about .5 long.	pmcgovern	1	1	1	1	2013-04-17	0
2013-breeding-observations	30	4/20/13: I observed 2 P. tremuloides males in full extension.  It may be at or near peak reception for small tooth aspen...	pmcgovern	1	1	1	1	2013-04-20	0
2013-breeding-observations	31	4/27/13: Observed a number of P. alba and bigtooth males at peak extension.  It is likely peak receptivity in the GR area.  Next week I may harvest some fertilized bigtooth female branches.	pmcgovern	1	1	1	1	2013-04-27	0
2013-breeding-observations	32	5/11/13: Seed started to shed on bigtooth.	pmcgovern	1	1	1	1	2013-05-11	0
2013-breeding-observations	33	5/14/13: Finished seed for 4xGW and 2xGW.  The 3xGW cross shed one (wet) batch, expect it to finish in 2 days.	pmcgovern	1	1	1	1	2013-05-14	0
2013-breeding-observations	34	5/15/13: Observed that the G2 bigtooth female catkins appear to be ripening slowly and unevenly compared to the other clones.  Perhaps more evidence of variation...	pmcgovern	1	1	1	1	2013-05-15	0
2013-breeding-observations	35	5/18/13: Observed several area bigtooth females shedding seed.	pmcgovern	1	1	1	1	2013-05-18	0
2013-field	36	5/22/13: Sprayed Roundup around newly planted trees at 5/3 and Post NE lots.  The grass growth was very tall (1'-2'), green and healthy.\tI used perhaps just under 3 gallons of mix.	pmcgovern	1	1	1	1	2013-05-22	0
2013-breeding-observations	37	5/23/13: I thinned out the bigtooth aspen seedlings.  There is a huge difference in family performance (see pics).  The actual germination is poor - maybe 25% for the best lot, then perhaps 15% and 5%.  I need to investigate if a good portion of the poor viability is actually empty seed embryos - that were never fertilized.	pmcgovern	1	1	1	1	2013-05-23	0
2013-bell-nursery	38	5/26/13:  Observed that one of the two Zoss hybrid trees did not grow yet.  I lifted the tree, did not see any issues and cut it up for root shoot propagation.	pmcgovern	1	1	1	1	2013-05-26	0
2013-breeding-observations	39	5/30/13: P. grandidentata seed germination estimates at Bell indoors:  2xGW	pmcgovern	1	1	1	1	2013-05-30	0
2013-bell-nursery	41	8/21/13: Bud set observations: All DN34 set bud.  Six of the seven 2xcag12 mini-stool clones set bud.  More than half of the 2xcag12 ramet cuttings (clones 1-30) have set but with some family differences (eg. Taller #14 has not set bud).  	pmcgovern	1	1	1	1	2013-07-21	0
2013-field	42	8/22/13: 5-3Dot-Lot site: All trees have set bud.  The all look pretty good, but 2 had flopped over due to planting them too tall for the dbh.  	pmcgovern	1	1	1	1	2013-07-22	0
2013-bell-nursery	43	9/21/13: Most seedlings are now set or appear to be setting bud). 	pmcgovern	1	1	1	1	2013-09-21	0
2013-Open4st-Nursery-Results	44	1/1/2014: The 2013 Nursery consisted of over 13 Phase 3 (P3) selections, 10 new Phase 4 families and 144 2xCAG12 ramets.  It is expected to yield over 700 - 10" cuttings and 1300 1-0 stock plants and seedlings.  A Vigor Survival metric was used as the primary selection model. It consisted of multiplying the survival rate by the median diameter (mm) from each clone set.  The 13 P3 selections averaged 82% rooting from 6" cuttings over a 2 or 3 year test period.  The best rooting 2013 clone was 101AA11 with 98% rooting via 39/40 cuttings in 4 replications. The 2xCAG12 family was root tested via 6 - 6" cuttings per 34 ortets and averaged about 80% rooting.  Fourteen ortets rooted 100%. 1xCAGW selections - Observed pure aspen traits in terms of leaf, stem and roots, and some also root well.  Clone 1CAGW01 was planted in planted 7 replications of 65 - 6" cuttings with diameters ranging from 3 mm to 14 mm and a mean rooting of 73%.  However, there was 83% survival from  cuttings that were 10 mm or greater in diameter. Future tests will include cuttings with a 7 mm cutting diameter.  Ten aspen crosses were produced in 2013.  They represented a variety of alba hybrids with most leaf/stem traits meeting parental and intermediate expectations.  Four bigtooth x Open pollinated families - Bigtooth females from urban areas had low seed set.  Open pollinated seed from McGovern's RNE alba aspen site had vigorous AG like progeny. These seedlings were planted at the end of June.  The gxg seedlings averaged 2' and the AGs averaged 4'.	pmcgovern	1	1	1	1	2014-01-01	0
2014-breeding-observations	45	2/28/14: The 2010 Phase 3 crosses contain 3 crosses with the male EBL and 3 with 41AA111 including 89xAA10 that has both of these parents.  It may be interesting to note if there are any parental patterns with these families.  It may help us see what effect different combinations of these parents have on early growth.	pmcgovern	1	1	1	1	2014-02-28	0
2014-breeding-observations	46	2/28/14: I checked my stored 89xAA10 seed from the freezer.  On 2/25 I germ tested 11 seeds on a damp napkin and put under a shop light. On 2/28  I counted 7 sprouted, and 2 have green leaves. It doesn't mean much because they could fail to develop second true leaves.  I have about 200 seeds so 10% would be 20 trees.  On 3/2 I observed 2 true leaves - a living meristem!	pmcgovern	1	1	1	1	2014-02-28	0
2014-breeding-observations	47	3/1/14: Two feet of snow!  Used snow shoes to visit RNE and Post SE. RNE - Nice flowers on AGRR1, all 9xAG91, consider mating 20XAAG91. Post SE- Flaged 3 nice flowered trees that may be 84x, 80x and 82x.	pmcgovern	1	1	1	1	2014-03-01	0
2014-bell-nursery	48	9/22/14: All non-dominant seedlings have set bud.  About 1/2 of the P. Alba type seedings have or are close to bud set.  Most (3/4) of BG/BT type seedlings have bud set.  	pmcgovern	1	1	1	1	2014-09-22	0
2014-bell-nursery	49	9/30/14 Decided to change the family name 2xcag12 to 2xb to conform with new 2014 standard. The clones names will also be changed (eg. 2Xcag12-25 will be 2b25)	pmcgovern	1	1	1	1	2014-09-30	0
2014-Open4st-Nursery-Results	50	12/24/2014: 2014 Open4st Nursery Results:  We planted 1854 total aspens representing a variety of stock types with 1173 aspens surviving in the 2014 nursery.  Final tallies include 980seedlings from 24 families, 820 rooted cuttings, 24 rooted stock, 184 ortet rooted cuttings and 145 cuttings propagated via WASP. 24 aspen families were grown at Rakers Greenhouse with a 38% mean germination rate, resulting in 1173 seedlings. Each family was measured for the tallest and median height tree within about 3' of the tallest tree (about 20 trees). The overall tallest tree was 156 cm (15xb), the mean tallest was 126 cm and 88 cm for the mean median height. Six families had germination rates at 10% or less.  Four of these families had the female parent Plaza AG.  The other 2 families involved an AAG trihybrid and a bisexual AG 9AG105.  It will be interesting to see if these low germinating families will continue to have progeny with low germination rates that could be leveraged to produce effectively sterile materials.  A general observation was made that bigtooth parents are more difficult to breed than other aspens. The flowers have waxy coating that requires soaking the branch in warm water for about 30 minutes.  Female bigtooth aspens are difficult to work with but eventually produce viable seed. Therefore female CAG clones may be more valuable.  Family seedlingleaf/stem variability was subjectively scored on a 1-5 scale with 1 beinglow and 5 being high variability within the family. The mean score was 3.54. The 4 families with a 5 score were 9xbr, 5xrb, 4xrr and 1xbar.Three of these were mated with an AG  parent but 2 were the bisexual 9AG105. 5xRB had a 35% seed germination rate, the others were lessthan 7%.  It was interesting to note that 1xBAR failed to germinate at Rakers but McGovern produced 4 seedlings likely because they were planted immediately after collection. It will be interesting to see if there willbe any good rooting and or vigorous selections from these families.  Five families scored a 2 for variability, 3 were of CAG and bigtooth parentage (8xbg, 18xbg, 19xgb).  2014 Family comparisons:  While I think there is no seedling to long term field growth correlation, it is interesting to note family seedling growth patterns.  Six families consisted of CAG male (CAG177) or female (CAG204) mated to 6 bigtooth aspens and one smalltooth (P. tremuloides). The mean of their tallest trees was 131 cm, exceeding the mean of 126 for all families and the best AxA family (107xAA) with 138 and the best GA F1 from 4xgw with 123 cm. The tallest tree of these families was a 7xbt which was the 4th tallest tree for all families. Four of these 6 families had median heights above the mean value of 89. It will be interesting to see how these CAG x aspen families compare to F1 AGs and the CAG F2 crosses to show if hybrid vigor can exist apart from an F1 cross. These types of crosses hold a lot of potential if they are productive because they employ a wild and diverse parent with potential for good rooting and selection possibilities from recombination.Parental Sibling Observations: Two sibling male/female bigtooth aspens (gg102 and gg101) with Lower Penninsula parents were mated to 2 siblingmale/female Canadian CAG clones (CAG204 and CAG177).  The families 18xBG and 19xGB had both bigtooth parents G5 and G6 were growing about 300' apart from Michigan's Upper Peninsula in an area known for its  figured aspen wood. There were interesting 1 year seedling differences betweenthese families.  Both crosses had similar Rakers germination rates (38%for 18xBG vs 33% 19xGB) but 18xBG had 1 Rakers flat seeded vs 1/2 flatfor 19xGB.  18xBG ranked 3rd in median height (107cm), behind 15xB and14xB CAG families while 19xGB ranked 13th (83cm) the shorter than allother CAG x native aspen families.  Note that the 6th ranked family 13xGB(102cm) with Lower Peninsula parents had a female bigtooth mated to themale CAG177.  It was interesting that G5 and G6 performed so differentlyand that G5 outperformed all others despite its Northern source in this one year study.  If the 18xBG to 19xGB vigor differences continue to later stages, then perhaps there is significant selection potential for aspen parents from any given region.  The family with the tallest trees (tallest and median) is the CAG family, 15xB (c173 x 9ag105). Note that2xB (c173 x AG15) from 2012 had a clonal selection, 2B25 that was thetallest in the 2014 nursery at 320 cm. Both families differ only by the P. alba female parent on the AG side (A10 vs. PCA2).  It was observed that the 15xB had high stem variation in terms of diameter, form and bud patterns relative to the 2xB family.It will be interesting to track the performance of all 4 CAG crosses, compare them to F1 AGs and CAG204/CAG177 and breed them with native aspens.  The top 3 familiesfor median diameter were 15xb, 14xb and 18xbg. The top 3 families for tallest single tree height were 15xb, 20xbs and 14xb. The top 3 families for the greatest range (variation) from tallest tree to the median were 20xbs, 5xrb and 107xaa.  It will be interesting to see if there are any correlations to be made from future field performance results back to these nursery seedling results.  The 'Plaza' wild AG performed poorly from a breeding perspective. It was found in NE Grand Rapids in a fertile low land area with many hybrids.  It is likely a wild AG clone but I can never be sure of its parentage. There were 4 crosses with Plaza all had Rakers germination rates lower than 11%. These female flower branches were taken from the lower branches of a huge tree so it would beinteresting to do crosses with better quality branches to investigate if the issue is branch or compatibility.  Conducted a Leaf Study: Compared leaf shapes/margins to overall phenotypes and family types. In general,families with more than 50% alba parentage had more lobed shaped leaves with a cordate to ovate pattern (alba like). Families with less than 50%alba tend to have more intermediate cordate shaped leaves somewhat typical of F1 AG hybrids. While typical F1 AG and CAG familes are 50% alba the AGs have intermediate leaves, but the CAG families tend to have more alba lobing and tomentose with intermediate outliers. Perhaps this can be attributed to the recombination of a double hybrid and that the CAG parents tend to have more alba than intermediate leaf traits. The CAG(B) families mated with AG crosses and 11xAB tended to have the most leaf variation (mixtures of lobed and intermediate). Most alba types had dentate to sinuate leaf margins. Only 12xRB and 7xBT were scored to have doubly serrate margins. Other families had variable margin patterns.  See: Open4st Aspen Clonal/Family Leaf Shape Photos The 20xbs family did not appear to have the expected aspen traits (too much alba) of a CAG xP. smithii. We observed that the male parent 4xBT has alba like leaves (like AGA or canescens) and is likely the mistake causing this issue. The 9AG105 clone is bisexual and was mated to C173 (15xB median=128), CAG177 (5xRBmedian=60), Plaza AG (3xRR median=78), CAG204 (9xBR median=80). It wasinteresting that 15xB was the best family over all and with intermediate variability. 9xBR ranked 15th for median height, while its sibling reciprocal 5xRB ranked 19th for median height and had the second highest height range.  The family 7xBT was the only CAG backcross to employ the native P. tremuloides.  It ranked 8th in median height rank (100cm) but had the tallest seedlings from Rakers (6").  It will be interesting to compare this family to the other CAG x B families.  The clone 101AA11 (30AA5MF x NFA) had 98% rooting over 2 years with 59 cuttings survived.  It is the best aspen rooter and should be used in future crosses.  Figured Wood: Observed consistent undulating grain patterns in 13-17mm radially split sections of 1 year lightly figured AGRR1 stems.  This split wood process will be used as part of the early clonal selection.  Also, collected four bigtooth clones from an area known for figured aspen.  Converted the Competition Indexer Program to the Postresql database and integrated with the online r4st database program.  Nursery Context: Most of the Bell Nursery cutting material was planted on 4/20/14 in a 672 square foot nursery (22' x 15 and 19 x 18). The ramet cuttings were 6" long with diameters ranging from 7mm to ~13mm.  Mini-stools were planted that consisted of a 1-0 stock plant that is 6" long with a 1-2" root length. The cutting material was planted in rows planted on 30" centers and seedlings on 36" centers with dual rows of cuttings 4" apart and cuttings planted about 2" apart in each row. The internal 4" between the rows was covered with Miracle Gro Sphagnum Peat Moss, which had someplant food and absorbed water easily. The area between the double rowswas covered with green grass clipping mulch. These materials helped toreduce weed growth and prevented hardening of the top soil layer that istypical on this site after repeated watering. The nursery was irrigatedas needed with a 5' tall sprinkler. The last seedlings were planted on 7/2/14 and most materials had bud set by 9/22/14.	pmcgovern	1	1	1	1	2014-12-24	0
2015-Open4st-Nursery-Summary	51	10/19/2015: The primary 2015 focus was to propagate, test and select clones derived from earlier Phase 3-4 breeding efforts.  The following is a summary ofthe year's progress. We planted 3463 total aspens representing a variety of stock types with 2206 aspens surviving in the 2015 nursery.  Final tallies include 319 unique clones via 453 test replications with a mean survival rate of 61% and 153 Plus Trees noted for their outstanding performance. The stock type distributions are: ODC1-0, WASP, DC, 1-0, 1-1 and oDC.  The 2015 nursery contains 319 clones represented by 57 different  families, 43 of which are from recent McGovern Breeding Program  (MBP) crosses and 14 are from the wild or outside programs that  include clones.  See the Phase 4 Breeding Matrix for details on  the most recent MBP families. There were significant germination differences within families listed on the Phase 4 Breeding Matrix that may illustrate selection potential for selecting less fertile trees.  For example the male F1 hybrid 9AG105 and female Plaza AG had combined 8 cross progeny germination rates under 25%.  There are many variables to germination rates such as parental combining characteristics, branch health/age and seed age that can impact germination rates.  However, it may worthwhile to investigate if specific crosses can produce selections with desirable traits including effectively sterile progeny to prevent interbreeding with native populations.  The ODC and ODC1-0 dormant cuttings planted in the 2015 nursery had  57% mean survival rate (1603 trees).  There were 146 aspen clonal selections from the 2015 nursery that will be carried forward to 2016.  These selections had a 65% average survival rate for the DC and ODC1-0 stock types. Note that most of this material was planted with 6" cuttings and diameters ranging from 13 - 4 milometers.  We speculate that aspen field grade cuttings of 10-12" will have much higher survival rates.  The ODC1-0 stock types consisted of 5 - 6 ortet 6" cuttings planted with the ortet 1-0 mini-stool.  The cuttings were scored with survival and median collar diameter, along with the 1-0 mini-stool collar diameter.  These metrics were combined to form the stool vigor survival metric (Stool VS).  The replicated DC 6" stock types also had their survival rates and median collar diameter tabulated to form the Vigor Survival (VS) values. The hypothesis is that if the VS and Stool VS nursery metrics are recorded then later field trial patterns may show useful correlations. Below are the basic formulas.  end_quantity / td.start_quantity AS survival_rate, (end_quantity /  td.start_quantity) * td.collar_median_dia_mm  AS vigor_survival,  (end_quantity / td.start_quantity)  * td.stool_1_1_collar_mm  AS stool_vigor_survival The online r4st Postgres database contains several 2015 Nursery views that list the details, selections and selection summaries.  The vw_nursery_2015_selections table has the column, new_old_clones_ranked_vs_stoolvs that lists older and new (1 yr ODC1-0) clones.  These clone names were used to assist with clonal selection for the 2016 materials.  The older clone names contain the syntax:  <CloneName~VigorSurvivalMetric-VigorSurvivalPlusTreeMetric>.  The new one year clones have the format:  <CloneName-StoolVSMetric-StoolVSPlusTreeMetric_1_ODC1-0>. Three unrooted 6' aspen whips were field planted at 10" deep in the Spring of 2015Planted field trial at one site (see: 2B16 2015 Unrooted Whips).  All 3 whips survived with healthy stems that had about 18" of growth.  The 2B16 clone has a 3 year nursery 6" cutting survival rate of 54%.  A 3 year old CAG x T clone was observed with Bronze Leaf Disease (BLD).  This was not unexpected since native but rare, T x G families are highly susceptible to BLD. This may provide an interesting opportunity to study the disease and observe if different family/parent combinations would produce resistant strains.  Created the Hybrid Aspen Research and Deployment Strategies document to outline important research areas.	pmcgovern	1	1	1	1	2015-10-19	0
2016-Propossed-Open4st-Activities	52	08/14/2016: The following are proposed Open4st activities that will be scheduled for implementation: Select 40 to 70 clones for future field trials.  Selection criteria will likely focus on vigor survival traits of cuttings and plus tree performances of cuttings and stools.  Enter these clones in the r4st Plant database table with relevant details. Assign aspen materials to Hybrid Classes. Rename selected families and clones that have long, confusing names (eg. change 5xCAGR to 5xBR). Designate aspen materials that will be used as controls in the r4st Plant table (eg. parents, tested clones). Distribute cuttings or rooted stock to cooperators for field trials.  Design a .5 acre field trail scenario that considers the same  spacing, number of plants, block and plot strategies.  Document  cooperator sites in Google drive and later r4st database with  measurements. Update Open4st FAQ docs to serve as White Papers describing the what how of our aspen culture. Include:  How to plant and maintain aspens.  How to propagate aspens -  WASP/ASP, Rootlings, traditional root propagation, ... Produce a collection of YouTube videos like aspen culture, propagation and breeding.  Emulate this open4st video.  Plant key selections and controls on DOT sites for an aspen seed/cutting orchard:  Use 1-1 mini-stools lifted from Bell nursery.  Soak in water for  24 hours before planting.  Cut stools down to 24" total  height. Cut roots to 2.75" width and use a 3" auger to  bore a 12" deep hole.  Dip or brush mini-stools ends with  thick paste of JRM SoilMoist Endophyte (1/2 tsp/100cc water),  place in hole, push in a little topsoil, then mix in 1 handful  (cup) of MiracleGro peat moss with the topsoil.  Plant 2 rows  on 9x9 centers, rows 30' apart.Also plant 20" cuttings of control clones at closerspacing with/without JRM dip.  Wrap above ground stem with 12" high x 10" wide fabric  sleeves, secure with tack at the bottom, staple edges, except  for 3" at top to let shoots through.  Staple one lengthwise  sheet of Bounce dryer sheet to the inside of the fabric sleeve  for cheap deer/rabbit/insect repellent.  Spray glysophyte around  trees in mid May and July. Test 8" cuttings in nursery with JRM/Peat moss dips.	pmcgovern	1	1	1	1	2016-08-14	0
2016-Open4st-Summary	53	09/27/2016: The primary 2016 focus of the Open4st project was to propagate, test andselect clones derived from earlier breeding and nursery selection efforts.Here are highlights of the season:  # 2016 Nursery Stock Types#: The following stock types were used in the 2016 nursery: 8" Dormant Cuttings (DC): Dormant cutting lengths were increased from 6" to 8" in 2016 to make final nursery selections that were closer to the standard 10" field grade cutting length. Mini-Stools (MS):  1-0 stock cut to 10" length with roots pruned to 1" laterals and having a 3" top stem.  Family Dormant Cuttings: (FDC): A single family 8" dormant cutting taken from the ortet at about 2" from the root collar.  Other minor materials planted include Seedlings (SEL), 1-1 stock, and WASP stock.  # 2016 Nursery Summary#: The 2016 Bell Nursery was irrigated, mulched, fertilized and located on about 1000 square feet with 17 rows, most planted on 30" centers.  See: 2016-Bell-Nursery spreadsheet and 2016 Nursery photos. The 2016 nursery had 2802 trees of various stock types planted with 2127 live trees surviving (76%).  The 8" Dormant cuttings (DC) were planted in rows 30" apart with cuttings spaced 2" within the row and separated by 4" double rows and MiracleGro Peat moss applied between the cuttings.  All clones were represented with 5 cuttings in one or more replications.  Mini-Stools (MS) were planted in rows 30" apart with trees  spaced 5" within the row. Most clones were represented by 3  mini-stools in one replication. The mean rooted cutting collar median diameter was 7 mm.  The mean rooted median Mini-Stool collar diameter was 13.2 mm.  There were 178 Mini-Stool clones planted spread across 468 trees and ending the season with a 94% survival rate and an average median stool collar diameter of 13 mm.  There were 174 dormant cutting clones planted spread across 1500 cuttings with a 74% survival rate and an average median collar diameter of 8.2 mm.  For more details see the r4st database and the 2016 Nursery Stock  Summary.  # 2016 Clonal Selection Process#: It is important to note that most of the McGovern Breeding Program (MBP) materials in the 2016 nursery have not been field tested. Therefore the nursery selection process focuses on the primary objectives of promoting vigorous, good rooting clones from a collection of diverse aspen families.  Future clonal field trials are needed to select durable regional clones, investigate any nursery to field trial correlations and leverage future breeding opportunities with the elite performers.  Each 2016 MS and DC replication was scored for median lower collar diameter, survival rate, a subjective Plus Tree score of Y (Yes) and the estimated number of 12" field grade cuttings with a top diameter at least 9 mm termed, field_grade_ft.  In previous years the dormant cuttings were 6" long to select clones that can root at a shorter length and for easier storage/handling/lifting.  They were previously ranked using a Vigor Survival Plus Tree formula represented by: (median collar diameter * survival rate) + sum of Plus Trees).  Vigor Survival is the product of (median collar diameter * survival rate).  Plus trees are a subjective Yes score for a given replication that were observed to have outstanding performance in its environment.  It is handy for cross checking performance across replications but its subjective nature makes it variable.  The primary 2016 selection criteria was based on dormant cutting vigor survival and the number of 12" field grade cuttings with a top diameter at least 9 mm termed, field_grade_ft.  The mini-stool data was not used for selection since they only had one replication and had variable mini-stool stem sizes.  The formula for ranking dormant cutting performance was termed, cut_fcut_rep represented by: average(vigor_survival) + average(field_cuttings_ft) * (count(replication_nbr) *.1).  This metric is objective (doesn't use the Plus Tree values) and factors in the variable number of replications since each clone may have 1 to 11 replications (eg. 100AA12).  The above formula provided the primary 2016 selection rank criteria.  However, the final sets were manually adjusted to ensure diverse family and species representation while maintaining adequate vigor and survival (propagation) metrics.  # 2016 Selection Types#: The 2016 selections are subject to change before or during the Spring 2017processing date.  See the vw_2016_6_nursery_field_summary view details forcurrent selection details.  See the 2016 Nursery Stock Types for aggregateselection type details.  Below are details for the 2016 Selection Types: (Primary - Elite selections:)  These selections will represent about 30 clones that are recommended for field trials.It includes 4 FDC clones that require additional nursery testing.  These clones are represented by 18 different families and 5 selection types (A, AH, H, ASH, C).  The primary DC selections had 91% survival rate with 384 trees and 771 feet of field grade cuttings available for the 2017 season.  (Secondary - Archive selections:)  These selections represent about 30 clones that will be archived for later use, since most have siblings in the primary group.  These DC selections had a 91% survival rate with 246 trees and 412 feet of field grade cuttings available for the 2017 season.  (Tertiary - Parent selections:)  These represents parents of previous MBP crosses.  These DC materials are represented by 11 clones and a 65% survival rate with 55 available trees and 11 field grade cuttings. Most simply do not propagate as well as their progeny.  (Families - Re-test selections:)  These represent 2 2016 families 25xR and 6xGG that will have some trees planted in a 2017 field and all others tested as FDC 8" ortet stock in 2017 nursery that will also preserve each Mini-stool.  It will be very interesting to see if any of the native bigtooth 6xGG aspen FDC cuttings can grow roots. (Discarded Clones:) About 100 clones are expected to be discarded. They have a 64% survival rate.  # Family Classification System#A classification system was developed to help categorize these aspenmaterials.  Below is a listing of these classes which are also includedin the rank_class field of the vw_2016_2_nursery_key_summary table.The final selections and counts are subject to change.  (A = Alba x Alba - More or less 100% AxA materials (eg. 83xAA04,  107xAA).  3 Primary selections) (AH = Alba Hybrid - Have more  than 50% P. alba (eg. 2xBA, 22xAR). 8 Primary selections) (ASH  = Aspen Hybrid - Have less than 50% P. alba (eg. 22xBG, 7xBT).  8 Primary selections) (H = Hybrid - Have 50% P. alba (2xB, 25xR,  5xCAGR). 13 Primary selections) (C = Control - 1 clone (DN34))  (N = Native (eg. gg12))  # Miscellaneous Notes:# There were 644 aspen seedlings planted that used the GG12 figured aspen as the male parent.  In September 2016, 375 seedlings survived with a 75% survival rate and an average median collar diameter of 6 mm.  See: 2016 MBP Aspen Crosses.  In 2017 8" cuttings of these materials will be tested for rooting and about 10% will be planted in field trials.  The female AxAG hybrid AAG2002 was mated to the native bigtooth clone, GG12 (1xARG) with 5% germination and open pollinated (2xARW) with 6% germination.  These similar germination rates help validate comparisons between artificial crosses and open pollinated matings.  See: Selecting for Effectively Sterile Clones. The open4st team hopes to ramp up, test and distribute the new selections to cooperators seeking to participate in open Aspen research.  The final selections will need to be carefully reviewed and consider archiving other lesser rooting clones that may have phytoremediation potential.  There are 144 total clones with rooting over 49% (see: vw_2016_7_dc_rooting_over_49percent).  These may need to be screened separately.  The selections should also consider future breeding opportunities, while avoiding inbreeding.  For example many MBP families use similar parents such as A10 and NFA.  CAG Families like 14xB may require more selections, since it can be mated with more promising clones like 100xAA11.  112 MBP 5' 1-0 aspen trees were planted as archive clones.  See Photos.  Two WASP experiments were conducted using the JRM Endophyte mycorrhizal product.  See 2016 WASP Tests.  # 2017 Stock and Nursery Projections#Below are the 2017 projections to distribute and plant the 2016 aspenstock: * For each primary selection, plant 2 deer-proof 6' sized trees at an archive MBP DOT site and plant 14, 8" cuttings or mini-stools in the MBP nursery.  This material could be used for a 2018 field trial. * For each secondary selection, plant 1 deer-proof 6' sized tree at an archive MBP DOT site and plant 4, 8" cuttings or mini-stools in the MBP nursery.  * Distribute 4 or 8, 10" cuttings of primary, secondary clones and 8, 6xGG and 25xR seedlings to Purdue for a 2017 field trial.  * Distribute 10 clones for a potential MSU Pytorediation clonal lab test.  * Plant selected FDC and Family (6xGG, 25xR) cuttings and mini-stools in the 2017 nursery, select top clones and check cuttings for figure.  There are about 1300 cuttings that will be planted in the 2017 Bell nursery with about 380 available linear foot of growing area.  If cuttings were planted in double rows at 4" apart (6 cuttings/foot) then 2280 cuttings could be planted (380 feet x 6/foot).  If cuttings were planted in double rows at 5" apart (4.8 cuttings/foot) then 1340 cuttings could be planted (380 feet x 4.8/foot). I will plant at 4" spacing.  * Change all references of the Primary Elite selections to just Primary. The Elite designation should be reserved for final selections, not nursery selections.	pmcgovern	1	1	1	1	2016-09-27	0
TestingSpecialCharacters	54	12/31/2017: Testing special character display: This double quote character (“) displays as this character: â€ on Linux Firefox.  Other special characters that should display properly:  ~! @ # $ % 6 & * ( ) _ -=+ < > { } [ ]  \\ end	pmcgovern	1	1	1	1	2017-12-31	0
R4st-CVS-Import-Rules	55	12/31/2017: The r4st delimiter is the pipe character, the ESCAPE character is set to the forward slash '\\', the QUOTE character is set to the back tick.  Therefore, avoid using the back tick in the imported text files it will break the CSV import process.  	pmcgovern	1	1	1	1	2017-12-31	0
EscapingPipeCharsWithBackticks	56	The delimiter pipe character must be escaped for and aft by the backtick character like:   |   	pmcgovern	1	1	1	1	2017-12-31	0
UseBackticksInDoubles	57	The backtick character must be used as doubles in the same field but it will not be displayed:    Boo    “double quotes”	pmcgovern	1	1	1	1	2017-12-31	0
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
8	 105XAA     	 >F1 3XAA89=(A10 x JAMIE) >F2 105XAA=(3AA202 x NORTHFOX)
9	 106XAA     	 >F1 41XAA91=(A10 x A73) >F2 83XAA04=(A502 x AA4102) >F3 106XAA=(83AA565 x NORTHFOX)
10	 107XAA     	 >F1 23XAA91=(PCA2 x PRINCE) >F2 80XAA04=(AA2301 x AA4102) >F3 107XAA=(30AA5MF x 80AA3MF)
11	 107XAA     	 >F1 30XAA91=(PCA2 x A57) >F2 107XAA=(30AA5MF x 80AA3MF)
12	 107XAA     	 >F1 41XAA91=(A10 x A73) >F2 80XAA04=(AA2301 x AA4102) >F3 107XAA=(30AA5MF x 80AA3MF)
13	 10XAA90    	 >F1 10XAA90=(PIONEER x A344)
14	 10XAGA91   	 >F1 10XAGA91=(CRANDON x A546)
15	 10XBR      	 >F1 10XBR=(CAG204 x AGRR1)
16	 10XGA91    	 >F1 10XGA91=(BT044 x A546)
17	 10XTG93    	 >F1 10XTG93=(ST7 x BT016)
18	 11XAA90    	 >F1 11XAA90=(PIONEER x PRINCE)
19	 11XAAG91   	 >F1 11XAAG91=(A266 x AGMORIN)
20	 11XAB      	 >F1 11XAB=(A266 x CAG177)
21	 11XTG93    	 >F1 11XTG93=(ST8 x AGMORIN)
22	 12XAA90    	 >F1 12XAA90=(PCA1 x EBL)
23	 12XAG91    	 >F1 12XAG91=(A266 x AGMORIN)
24	 12XGAA91   	 >F1 12XGAA91=(GA14 x PRINCE)
25	 12XRB      	 >F1 12XRB=(PLAZA x CAG177)
26	 12XTG93    	 >F1 12XTG93=(ST8 x BT017)
27	 13XAA90    	 >F1 13XAA90=(PCA1 x PRINCE)
28	 13XAG91    	 >F1 13XAG91=(A10 x TBD)
29	 13XGAG91   	 >F1 13XGAG91=(GA14 x BT016)
30	 13XGB      	 >F1 1XGG91=(BT044 x BT016) >F2 13XGB=(GG102 x CAG177)
31	 13XTG93    	 >F1 13XTG93=(ST9 x AGMORIN)
32	 14XAA90    	 >F1 14XAA90=(ALGER x A344)
33	 14XAG91    	 >F1 14XAG91=(A10 x TBD)
34	 14XB       	 >F1 14XB=(C173 x AGRR1)
35	 14XGAA91   	 >F1 14XGAA91=(GA14 x JAMIE)
36	 14XTG93    	 >F1 14XTG93=(ST9 x BT017)
37	 15XAA90    	 >F1 15XAA90=(ALGER x PRINCE)
38	 15XAG91    	 >F1 15XAG91=(A10 x BT016)
39	 15XAGA91   	 >F1 15XAGA91=(FHAG x JAMIE)
40	 15XB       	 >F1 9XAG91=(PCA2 x BT016) >F2 15XB=(C173 x 9AG105)
41	 15XTG93    	 >F1 15XTG93=(ST10 x AGMORIN)
42	 16XAA91    	 >F1 16XAA91=(A10 x YUGO2)
43	 16XAAG91   	 >F1 16XAAG91=(A502 x AGMORIN)
44	 16XAB      	 >F1 41XAA91=(A10 x A73) >F2 83XAA04=(A502 x AA4102) >F3 16XAB=(83AA565 x CAG177)
45	 16XAG93    	 >F1 16XAG93=(A502 x BT017)
46	 16XGA92    	 >F1 16XGA92=(BT6 x ZOO)
47	 17XAA91    	 >F1 17XAA91=(A10 x A546)
48	 17XAAG91   	 >F1 17XAAG91=(A10 x AGMORIN)
49	 17XB       	 >F1 4XAE91=(A10 x E120) >F2 17XB=(PLAZA x 4AE1)
50	 17XGA04    	 >F1 1XGG91=(BT044 x BT016) >F2 17XGA04=(GG102 x AA4102)
51	 17XGA04    	 >F1 41XAA91=(A10 x A73) >F2 17XGA04=(GG102 x AA4102)
52	 18XAA91    	 >F1 18XAA91=(A266 x YUGO1)
53	 18XAG04    	 >F1 1XGG91=(BT044 x BT016) >F2 18XAG04=(AA4101 x GG101)
54	 18XAG04    	 >F1 41XAA91=(A10 x A73) >F2 18XAG04=(AA4101 x GG101)
55	 18XBG      	 >F1 18XBG=(CAG204 x GG6)
56	 18XGAA91   	 >F1 18XGAA91=(GA14 x A546)
57	 19XAA91    	 >F1 19XAA91=(A266 x KOREANALBA)
58	 19XAAG91   	 >F1 19XAAG91=(PCA2 x AGMORIN)
59	 19XGB      	 >F1 19XGB=(GG5 x CAG177)
60	 1XA4E05    	 >F1 1XA4E05=(A502 x TA10)
61	 1XAA85     	 >F1 1XAA85=(A266 x JAMIE)
62	 1XAAE05    	 >F1 1XAAE05=(A502 x GROBER)
63	 1XAAG88    	 >F1 1XAAG88=(A266 x CRANDON)
64	 1XAC91     	 >F1 1XAC91=(A10 x C28)
65	 1XAE91     	 >F1 1XAE91=(A266 x E120)
66	 1XAG88     	 >F1 1XAG88=(A266 x FHBT)
67	 1XAGA88    	 >F1 1XAGA88=(FHAG x JAMIE)
68	 1XAGC91    	 >F1 1XAGC91=(CRANDON x C28)
69	 1XAGE91    	 >F1 1XAGE91=(FHAG x E120)
70	 1XARG      	 >F1 20XAAG91=(A266 x CRANDON) >F2 1XARG=(AAG2002 x GG12)
71	 1XAT90     	 >F1 1XAT90=(ALGER x ST3)
72	 1XAW       	 >F1 41XAA91=(A10 x A73) >F2 83XAA04=(A502 x AA4102) >F3 1XAW=(83AA301 x WIND)
73	 1XBAR      	 >F1 20XAAG91=(A266 x CRANDON) >F2 1XBAR=(CAG204 x AAG2001)
74	 1XEE91     	 >F1 1XEE91=(E138 x E120)
75	 1XGA84     	 >F1 1XGA84=(SEITSMABT x JAMIE)
76	 1XGAAG91   	 >F1 1XGAAG91=(GA14 x AGMORIN)
77	 1XGAG91    	 >F1 1XGAG91=(BT044 x AGMORIN)
78	 1XGE91     	 >F1 1XGE91=(BT044 x E120)
79	 1XGG91     	 >F1 1XGG91=(BT044 x BT016)
80	 1XGT90     	 >F1 1XGT90=(BT2 x ST3)
81	 1XT4E04    	 >F1 1XT4E04=(T8057 x TA10)
82	 1XTE04     	 >F1 1XTE04=(CLONE5 x TA483)
83	 1XTG90     	 >F1 1XTG90=(ST071 x BT1)
84	 1XTT91     	 >F1 1XTT91=(ST071 x ST072)
85	 20XAA91    	 >F1 20XAA91=(A266 x A546)
86	 20XAAG91   	 >F1 20XAAG91=(A266 x CRANDON)
87	 21XAA91    	 >F1 21XAA91=(A502 x A73)
88	 21XAAG91   	 >F1 32XAA91=(A266 x PRINCE) >F2 21XAAG91=(AA3201 x CRANDON)
89	 21XBA      	 >F1 23XAA91=(PCA2 x PRINCE) >F2 80XAA04=(AA2301 x AA4102) >F3 21XBA=(CAG204 x 80AA3MF)
90	 21XBA      	 >F1 41XAA91=(A10 x A73) >F2 80XAA04=(AA2301 x AA4102) >F3 21XBA=(CAG204 x 80AA3MF)
91	 22XAA91    	 >F1 22XAA91=(A502 x PRINCE)
92	 22XAAG92   	 >F1 22XAAG92=(A266 x AGM46)
93	 22XAR      	 >F1 3XAA89=(A10 x JAMIE) >F2 22XAR=(3AA202 x AGRR1)
94	 22XBG      	 >F1 22XBG=(CAG204 x GG4)
95	 23XAA91    	 >F1 23XAA91=(PCA2 x PRINCE)
96	 23XAAG92   	 >F1 23XAAG92=(PCA1 x AGM46)
97	 23XBA      	 >F1 41XAA91=(A10 x A73) >F2 82XAA04=(AA901 x AA4102) >F3 23XBA=(CAG204 x 82AA3)
98	 23XBA      	 >F1 9XAA90=(A266 x A344) >F2 82XAA04=(AA901 x AA4102) >F3 23XBA=(CAG204 x 82AA3)
99	 24XAA91    	 >F1 24XAA91=(A101 x JAMIE)
100	 24XR       	 >F1 9XAGA91=(FHAG x PRINCE) >F2 24XR=(82AA4 x GG12)
101	 25XAA91    	 >F1 25XAA91=(A266 x PA092)
102	 25XR       	 >F1 41XAA91=(A10 x A73) >F2 83XAA04=(A502 x AA4102) >F3 25XR=(83AA301 x GG12)
103	 26XAA91    	 >F1 26XAA91=(PCA2 x A73)
104	 27XAA91    	 >F1 27XAA91=(A10 x PRINCE)
105	 28XAA91    	 >F1 28XAA91=(A266 x A73)
106	 29XAA91    	 >F1 29XAA91=(A266 x YUGO2)
107	 2XA4E05    	 >F1 2XA4E05=(A266 x TA10)
108	 2XAA88     	 >F1 2XAA88=(A266 x JAMIE)
109	 2XAAE06    	 >F1 2XAAE06=(A502 x GROBER)
110	 2XAAG88    	 >F1 2XAAG88=(A266 x AGMORIN)
111	 2XAC91     	 >F1 2XAC91=(A266 x C28)
112	 2XAG90     	 >F1 2XAG90=(A266 x FHBT)
113	 2XAGA90    	 >F1 2XAGA90=(CRANDON x A344)
114	 2XAGC91    	 >F1 2XAGC91=(FHAG x C28)
115	 2XARW      	 >F1 20XAAG91=(A266 x CRANDON) >F2 2XARW=(AAG2002 x WIND)
116	 2XB        	 >F1 15XAG91=(A10 x BT016) >F2 2XB=(C173 x 15AG4MF)
117	 2XEA91     	 >F1 2XEA91=(E138 x PRINCE)
118	 2XEG91     	 >F1 2XEG91=(E138 x BT016)
119	 2XGA88     	 >F1 2XGA88=(SEITSMABT x JAMIE)
120	 2XGAE91    	 >F1 2XGAE91=(GA14 x E120)
121	 2XGAG91    	 >F1 2XGAG91=(GA14 x M1BT)
122	 2XGG91     	 >F1 2XGG91=(BT044 x M1BT)
123	 2XGT91     	 >F1 2XGT91=(BT044 x ST072)
124	 2XRR       	 >F1 9XAG91=(PCA2 x BT016) >F2 2XRR=(9AG103 x AGRR1)
125	 2XT4E04    	 >F1 2XT4E04=(CLONE5 x TA10)
126	 2XTG90     	 >F1 2XTG90=(ST071 x FHBT)
127	 30XAA91    	 >F1 30XAA91=(PCA2 x A57)
128	 31XAA91    	 >F1 31XAA91=(A266 x C28)
129	 32XAA91    	 >F1 32XAA91=(A266 x PRINCE)
130	 33XAA91    	 >F1 33XAA91=(A10 x JAMIE)
131	 35XAA91    	 >F1 35XAA91=(PCA2 x JAMIE)
132	 36XAA91    	 >F1 36XAA91=(A502 x A546)
133	 37XAA91    	 >F1 37XAA91=(PCA2 x A546)
134	 39XAA91    	 >F1 39XAA91=(PCA2 x YUGO2)
135	 3XAA89     	 >F1 3XAA89=(A10 x JAMIE)
136	 3XAAE07    	 >F1 3XAAE07=(A502 x GROBER)
137	 3XAG90     	 >F1 3XAG90=(PCA1 x FHBT)
138	 3XAGA90    	 >F1 3XAGA90=(CRANDON x PRINCE)
139	 3XBC       	 >F1 3XBC=(CAG204 x AE42)
140	 3XEA91     	 >F1 3XEA91=(E138 x JAMIE)
141	 3XRR       	 >F1 9XAG91=(PCA2 x BT016) >F2 3XRR=(PLAZA x 9AG105)
142	 3XTG90     	 >F1 3XTG90=(ST2 x BT1)
143	 40XAA91    	 >F1 40XAA91=(A10 x A57)
144	 41XAA91    	 >F1 41XAA91=(A10 x A73)
145	 43XAA92    	 >F1 43XAA92=(A266 x ZOO)
146	 44XAA92    	 >F1 44XAA92=(A266 x TEVERE2)
147	 45XAA92    	 >F1 45XAA92=(A266 x TANARO)
148	 46XAA92    	 >F1 46XAA92=(A266 x JAMIE)
149	 47XAA92    	 >F1 47XAA92=(GODFREY x ZOO)
150	 48XAA92    	 >F1 48XAA92=(GODFREY x JAMIE)
151	 49XAA92    	 >F1 49XAA92=(GODFREY x TEVERE2)
152	 4XAA89     	 >F1 4XAA89=(A316 x JAMIE)
153	 4XACAG     	 >F1 4XACAG=(A502 x CAG177)
154	 4XAE91     	 >F1 4XAE91=(A10 x E120)
155	 4XAG90     	 >F1 4XAG90=(ALGER x FHBT)
156	 4XAGA90    	 >F1 4XAGA90=(ARENAAG x A344)
157	 4XGW       	 >F1 1XGG91=(BT044 x BT016) >F2 4XGW=(GG102 x WIND)
158	 4XRR       	 >F1 4XRR=(PLAZA x AGRR1)
159	 4XTG91     	 >F1 4XTG91=(ST071 x BT016)
160	 50XAA92    	 >F1 50XAA92=(PCA1 x ZOO)
161	 51XAA92    	 >F1 51XAA92=(PCA1 x JAMIE)
162	 52XAA92    	 >F1 52XAA92=(PCA1 x TEVERE2)
163	 53XAA92    	 >F1 1XAA85=(A266 x JAMIE) >F2 53XAA92=(AA101 x ZOO)
164	 54XAA93    	 >F1 54XAA93=(A266 x POL2)
165	 55XAA93    	 >F1 55XAA93=(A266 x POL3)
166	 56XAA93    	 >F1 56XAA93=(A266 x SER41)
167	 57XAA93    	 >F1 57XAA93=(A266 x SER42)
168	 58XAA93    	 >F1 58XAA93=(A266 x SER5)
169	 59XAA93    	 >F1 59XAA93=(A266 x SER6)
170	 5XAA89     	 >F1 5XAA89=(A502 x JAMIE)
171	 5XAE91     	 >F1 5XAE91=(PCA2 x E120)
172	 5XAGA90    	 >F1 5XAGA90=(KENTAG x A344)
173	 5XCAGR     	 >F1 5XCAGR=(CAG204 x AGRR1)
174	 5XGA91     	 >F1 5XGA91=(BT044 x PRINCE)
175	 5XRB       	 >F1 9XAG91=(PCA2 x BT016) >F2 5XRB=(9AG105 x CAG177)
176	 5XTG91     	 >F1 5XTG91=(ST071 x SHELBYBT)
177	 5XTG93     	 >F1 5XTG93=(ST071 x BT016)
178	 60XAA93    	 >F1 60XAA93=(A266 x NORTHFOX)
179	 61XAA93    	 >F1 61XAA93=(A502 x POL2)
180	 62XAA93    	 >F1 62XAA93=(A502 x POL3)
181	 63XAA93    	 >F1 63XAA93=(A502 x SER41)
182	 64XAA93    	 >F1 64XAA93=(A502 x SER42)
183	 65XAA93    	 >F1 65XAA93=(A502 x SER5)
184	 66XAA93    	 >F1 66XAA93=(A502 x SER6)
185	 67XAA93    	 >F1 67XAA93=(A502 x NORTHFOX)
186	 68XAA93    	 >F1 1XAA85=(A266 x JAMIE) >F2 68XAA93=(AA101 x POL2)
187	 69XAA93    	 >F1 1XAA85=(A266 x JAMIE) >F2 69XAA93=(AA101 x POL3)
188	 6XAA89     	 >F1 6XAA89=(A266 x A344)
189	 6XAGA90    	 >F1 6XAGA90=(POSTAG x A344)
190	 6XBA       	 >F1 6XBA=(CAG204 x NORTHFOX)
191	 6XGA91     	 >F1 6XGA91=(BT044 x A57)
192	 6XGG       	 >F1 1XGG91=(BT044 x BT016) >F2 6XGG=(GG102 x GG12)
193	 6XTG91     	 >F1 6XTG91=(ST071 x M1BT)
194	 70XAA93    	 >F1 1XAA85=(A266 x JAMIE) >F2 70XAA93=(AA101 x SER41)
195	 71XAA93    	 >F1 1XAA85=(A266 x JAMIE) >F2 71XAA93=(AA101 x SER42)
196	 72XAA93    	 >F1 1XAA85=(A266 x JAMIE) >F2 72XAA93=(AA101 x SER5)
197	 73XAA93    	 >F1 1XAA85=(A266 x JAMIE) >F2 73XAA93=(AA101 x NORTHFOX)
198	 74XAA95    	 >F1 74XAA95=(SOUTHBELL x JAMIE)
199	 75XAA95    	 >F1 75XAA95=(A266 x JAMIE)
200	 76XAA02    	 >F1 21XAA91=(A502 x A73) >F2 76XAA02=(A502 x AA2101)
201	 77XAA02    	 >F1 21XAA91=(A502 x A73) >F2 77XAA02=(AA4101 x AA2101)
202	 77XAA02    	 >F1 41XAA91=(A10 x A73) >F2 77XAA02=(AA4101 x AA2101)
203	 78XAA02    	 >F1 20XAAG91=(A266 x CRANDON) >F2 78XAA02=(AAG2002 x AA2101)
204	 78XAA02    	 >F1 21XAA91=(A502 x A73) >F2 78XAA02=(AAG2002 x AA2101)
205	 79XAA03    	 >F1 41XAA91=(A10 x A73) >F2 79XAA03=(A502 x AA4102)
206	 7XAA90     	 >F1 7XAA90=(A266 x EBL)
207	 7XAG91     	 >F1 7XAG91=(FHAG x A546)
208	 7XAGA91    	 >F1 7XAGA91=(FHAG x A546)
209	 7XBT       	 >F1 7XBT=(CAG204 x ST11)
210	 7XGA91     	 >F1 7XGA91=(BT044 x JAMIE)
211	 7XTG93     	 >F1 7XTG93=(ST5 x AGMORIN)
212	 80XAA04    	 >F1 23XAA91=(PCA2 x PRINCE) >F2 80XAA04=(AA2301 x AA4102)
213	 80XAA04    	 >F1 41XAA91=(A10 x A73) >F2 80XAA04=(AA2301 x AA4102)
214	 81XAA04    	 >F1 32XAA91=(A266 x PRINCE) >F2 81XAA04=(AA3201 x AA4102)
215	 81XAA04    	 >F1 41XAA91=(A10 x A73) >F2 81XAA04=(AA3201 x AA4102)
216	 82XAA04    	 >F1 41XAA91=(A10 x A73) >F2 82XAA04=(AA901 x AA4102)
217	 82XAA04    	 >F1 9XAA90=(A266 x A344) >F2 82XAA04=(AA901 x AA4102)
218	 83XAA04    	 >F1 41XAA91=(A10 x A73) >F2 83XAA04=(A502 x AA4102)
219	 84XAA04    	 >F1 30XAA91=(PCA2 x A57) >F2 84XAA04=(AA3001 x AA4102)
220	 84XAA04    	 >F1 41XAA91=(A10 x A73) >F2 84XAA04=(AA3001 x AA4102)
221	 85XAA04    	 >F1 41XAA91=(A10 x A73) >F2 85XAA04=(AA4101 x AA4102)
222	 86XAA10    	 >F1 86XAA10=(A502 x NORTHFOX)
223	 87XAA10    	 >F1 40XAA91=(A10 x A57) >F2 87XAA10=(40AA08 x AA4102)
224	 87XAA10    	 >F1 41XAA91=(A10 x A73) >F2 87XAA10=(40AA08 x AA4102)
225	 88XAA10    	 >F1 40XAA91=(A10 x A57) >F2 88XAA10=(40AA08 x EBL)
226	 89XAA10    	 >F1 41XAA91=(A10 x A73) >F2 89XAA10=(41AA111 x EBL)
227	 8XAA90     	 >F1 8XAA90=(A266 x PRINCE)
228	 8XAG91     	 >F1 8XAG91=(A502 x BT016)
229	 8XAGA91    	 >F1 8XAGA91=(FHAG x C28)
230	 8XBG       	 >F1 1XGG91=(BT044 x BT016) >F2 8XBG=(CAG204 x GG101)
231	 90XAA10    	 >F1 40XAA91=(A10 x A57) >F2 90XAA10=(40AA08 x NORTHFOX)
232	 91XAA10    	 >F1 41XAA91=(A10 x A73) >F2 91XAA10=(41AA111 x NORTHFOX)
233	 92XAA10    	 >F1 35XAA91=(PCA2 x JAMIE) >F2 92XAA10=(41AA111 x 35AA201)
234	 92XAA10    	 >F1 41XAA91=(A10 x A73) >F2 92XAA10=(41AA111 x 35AA201)
235	 93XAA10    	 >F1 41XAA91=(A10 x A73) >F2 93XAA10=(A502 x AA4102)
236	 94XAA10    	 >F1 40XAA91=(A10 x A57) >F2 94XAA10=(40AA6MF x EBL)
237	 95XAA10    	 >F1 35XAA91=(PCA2 x JAMIE) >F2 95XAA10=(40AA08 x 35AA201)
238	 95XAA10    	 >F1 40XAA91=(A10 x A57) >F2 95XAA10=(40AA08 x 35AA201)
239	 96XAA10    	 >F1 35XAA91=(PCA2 x JAMIE) >F2 96XAA10=(40AA6MF x 35AA201)
240	 96XAA10    	 >F1 40XAA91=(A10 x A57) >F2 96XAA10=(40AA6MF x 35AA201)
241	 97XAA10    	 >F1 40XAA91=(A10 x A57) >F2 97XAA10=(40AA6MF x NORTHFOX)
242	 98XAA10    	 >F1 30XAA91=(PCA2 x A57) >F2 98XAA10=(30AA5MF x 83AA2MF)
243	 98XAA10    	 >F1 41XAA91=(A10 x A73) >F2 83XAA04=(A502 x AA4102) >F3 98XAA10=(30AA5MF x 83AA2MF)
244	 99XAA10    	 >F1 30XAA91=(PCA2 x A57) >F2 99XAA10=(30AA5MF x AA4102)
245	 99XAA10    	 >F1 41XAA91=(A10 x A73) >F2 99XAA10=(30AA5MF x AA4102)
246	 9XAA90     	 >F1 9XAA90=(A266 x A344)
247	 9XAG91     	 >F1 9XAG91=(PCA2 x BT016)
248	 9XAGA91    	 >F1 9XAGA91=(FHAG x PRINCE)
249	 9XBR       	 >F1 9XAG91=(PCA2 x BT016) >F2 9XBR=(CAG204 x 9AG105)
250	 9XTG93     	 >F1 9XTG93=(ST7 x AGMORIN)
\.


--
-- Name: pedigree_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('pedigree_id_seq', 250, true);


--
-- Data for Name: plant; Type: TABLE DATA; Schema: public; Owner: user
--

COPY plant (plant_key, id, notes, sex_mfbu, published_botanical_name, common_name, alternate_name, aquired_from, female_external_parent, male_external_parent, form_fnmwu, is_plus, is_cultivar, is_variety, is_from_wild, ploidy_n, date_aquired, alba_class, id_taxa, id_family, web_photos, web_url) FROM stdin;
TBD	1	To Be Determined	U	0	0	0	0	0	0	U	U	U	U	U	-1	1111-11-11	U	2	2	0	0
NA	2	Does Not Apply	U	0	0	0	0	0	0	U	U	U	U	U	-1	1111-11-11	U	2	2	0	0
A73	3	AKA, Bolleana.  A fastigate tree that is somewhat short lived in Michigan.  Sheds pollen fast. Rooted 44% (23/52) in 1995 with Hormex 30 IBA (likely using 8 inch cuttings).	M	Populus alba 'Pyramidalis' 	Bolleana	0	Kalamazoo, MI	0	0	F	Y	Y	Y	U	2	1991-01-01	A	3	2	0	TBD
A10	4	A wild tree found in Ottawa, Ontario.  A large well formed, straight boled tree with poor rooting.  I harvested flowers from 3 large grafted trees.  	F	0	0	0	Maple, Ontario	0	0	W	Y	Y	N	Y	2	1989-01-01	A	3	2	0	TBD
A344	5	This is a Canadian cross that was produced in 1958.  The a69 parent had good rooting traits.	M	0	0	0	Maple, Ontario	A69	A57	W	Y	Y	N	N	2	1989-01-01	A	3	2	0	TBD
A57	6	Canada obtained this tree from Hohenheim, Germany in 1953.  Open crown, vigorous and healthy in Maple Ontario.	M	0	0	0	Maple, Ontario	0	0	W	Y	Y	N	U	2	1991-01-01	A	3	2	0	TBD
PRINCE	7	Located West of Burton Ballpark along RR tracks on a sandy site.  May be the same clone as NFA alba.  Vigorous poor formed tree.  Seems to combine well. Flowers late in age and some years flowers do not shed pollen (2004).  13.4 diameter on 12/26/03 at SLNE. Had 22% rooting in 1989 with 4 - .5 cuttings and #30 IBA.	M	0	0	0	~1/4 mile SE of US131 and Burton st., Grand Rapids, Mi	0	0	W	Y	N	N	Y	2	1989-01-01	A	3	2	0	TBD
EBL	8	Victor B. Barne's Isozyme tests showed it was different than Jamie alba.  Dense suckering, poor form. Combines well with a266.	M	0	0	0	2975 East Beltline GR, MI.	0	0	W	N	N	N	Y	2	1985-01-01	A	3	2	0	TBD
A266	9	May have originated in South Morovia, Czechoslovakia in 1960.  Very vigorous, poor rooter and very bad form.  Gets BLD.  Used in many crosses.  Produces lots of seed with most any pollen.  Most progeny has bad form.	F	0	0	0	PCA site @ Freesoil, MI	0	0	W	Y	Y	N	N	2	1991-01-01	A	3	2	0	TBD
YUGO2	10	This is one of 3 pollen samples sent in 1991.  It is from Dr. V. Guzina of the Poplar Research Institute.   They were collected from the riparian zone of the Danube River near Novi Sad.  Most pollen was bad due to the shipping delay.	M	0	0	0	Novi Sad, Yugoslavia	0	0	W	Y	N	N	Y	2	1991-01-01	A	3	2	0	TBD
A502	11	Canada obtained this tree from Casale Monferrato, Italy in 1967 as clone I58-57.  It has good form, some sun scalding, fair rooting, aspen features, gets BLD.  Flowering: Reliable for seed bearing, need to let the whole catkin shed.  Breeding Notes: When combined with Bolleana, progeny roots well, but the cross a502 x Bolleana may be not durable, but the cross A502 x Jamie is durable. Rooting: 1989=45%, 1990=13%, 1992=21%, 2004=24%, Phase 3 breeding notes: A502 catkins were about 10mm long on 3/28/10 at RNE.  I estimate that most albas will peak receptivity around 3/31 as we are expecting 70 degrees on 3/31..  The last A502 flowers were harvested on 4/9/10, almost 1 month from when they were started...  For more details see Web URL	F	0	0	0	Maple, Ontario	P.alba n2 Istituto Pignatelli - Villafranca Piemonte TO Italy	P.alba n2 Istituto Pignatelli - Villafranca Piemonte TO Italy	M	Y	Y	Y	N	2	1989-01-01	A	3	2	0	TBD
GODFREY	12	Similar to Bolleana. Seems to be pure alba. Perhaps a bit wider.  Vigorous, healthy, no bld in 1992. Light flowering, pollinate early. Rooting: 1992=65% 17/26 8 cuttings.	F	0	0	0	1526 Godfrey SW Grand Rapids, MI	0	0	F	N	N	N	Y	2	1992-01-01	A	3	2	0	TBD
POL3	13	About a 50 year old tree, very tall and slender and upright crown, exceptionally white bark. Good pollen vigor but some clumping.  Pollen used in 1993 cross.  	M	0	0	0	lat44 40' N; long 7 50' E; alt 175 m. Italy	0	0	U	Y	N	N	Y	2	1993-01-01	A	3	2	0	TBD
POL2	14	70-80 year old tree of massive dimensions. Fairly large branches wth flat branch angle and broad crown.  Excellent pollen vigor. Used in 1993 cross.	M	0	0	0	lat44 40' N; long 7 50' E; alt 175 m. Italy	0	0	W	Y	N	N	Y	2	1993-01-01	A	3	2	0	TBD
SER41	15	Rick Hall collected this pollen from an Italian plantation near the town of Ghivazzano on the east side of the track, north of the train station.  This tree was on the NW corner of the plantation.  It should have good rooting, since it was collected from a plantation.  Broad crown, large diameter, medium steep branch angle, not exceptionally tall.  Good pollen vigor.  Apparently a local man had made a collection of promising trees and established this plot 30 years ago.  Ser is an abbreviation for Serchio River, the valley in which all of these collections were made, north of the city of Lucca.  This is the only region in Itally and maybe Europe where P. alba is grown as a commercial species in plantations.  There has been a long history of selecting trees that root well for use in the plantations.  The assumption is that this area has natural populations that root well.  This area is about as far South as one can go in Italy and have sufficient cold hardiness for our winters.  	M	0	0	0	lat44 05' N; long 10 25' E; alt 100 m. Italy	0	0	W	Y	N	N	Y	2	1993-01-01	A	3	2	0	TBD
SER42	16	Collected from an experimental plantation near Ghivazzano, Italy. Tree is 150' tall.  Abnormal pollen.  Tree located near ser41. estimated 150' tall, may be polyploid due to the size of the tree and unusual pollen behavior.  NO seed was produced...	M	0	0	0	lat44 05' N; long 10 25' E; alt 100 m. Italy	0	0	W	Y	N	N	Y	2	1993-01-01	A	3	2	0	TBD
SER5	17	Taken from a tree growing along the west bank of the river south of the town of Borgo, Italy.  It may be a planted tree.  Large tree, perhaps over 50 years old. Tree has large sized branches.	M	0	0	0	lat44 05' N; long 10 30' E; alt 60 m. Italy	0	0	W	Y	N	N	Y	2	1993-01-01	A	3	2	0	TBD
SER6	18	From a commercial plantation N. of Lucca, Italy. 40 in diameter.  Located between a gravel quarry on the river and the dike along the roadway.  It is heavily branched and sparsely distributed. 	M	0	0	0	lat43 50' N; long 10 25' E; alt 40 m. Italy	0	0	W	Y	N	N	Y	2	1993-01-01	A	3	2	0	TBD
NORTHFOX	19	Discovered in 1993 and may be the same clone as Prince alba, which is located about 1 mile to the North.  Also known as NFA.  This SE area of Grand Rapids has a naturalized population of albas.  NFA trees appear more yellow and the form is less crooked.  Forced flowers of both NFA and Prince and earlier notes (1993?) indicate flowering differences.  NFA flowers have more red, are bigger (fatter) and Prince flowers are longer, darker and not as thick. However, both clones seem to shed pollen indoors if they are close to their natural shed date.  On 2-10-01: This clone was the top performer in a 1992 trial at ISU with 3 trees, 100% survival.  It measured 17.1 DBH in 2007 with 10.79 t/ac/yr.  On 3/29/10 I visited this tree (GR ortet) and compared male stamen development to Prince.  While the color was the same (pink), NFA appeared to be a bit behind Prince.  In Spring of 2010, the Prince clone was just starting to shed pollen and NFA should be starting in 2-3 days.  	M	0	NFA	0	347 Fox St. SW (W of Buchannan, N of Burton) GR, MI.	0	0	W	Y	N	N	Y	2	1993-01-01	A	3	2	0	TBD
ALGER	20	Alger has very small, distinctive stigmas, Noted for good rooting of the early albas. Rooting: 1989=66%, 1990=55%	F	0	0	0	North side of Alger Ave. E of Kalamazoo & W of Plymouth. 	0	0	W	N	N	N	Y	2	1985-01-01	A	3	2	0	TBD
A546	21	I took flower branches from this tree in 1991.  It was a huge tree.  It has large male buds with little pubesence.  It seems like a P. Canescens since 36xaa91 appears like an AGA cross.	M	0	0	0	 Norris Arm, Newfoundland (1970) I got it from Canada.	0	0	W	Y	Y	N	N	2	1991-01-01	A	3	2	0	TBD
A101	22	Not to be confused with clone AA101. From Canada.  They selected this from pop 1 in 1953.  It is a large tree with an open crown.	F	0	0	0	Tobra County, Hungary	0	0	W	Y	N	N	N	2	1991-01-01	A	3	2	0	TBD
JAMIE	23	Some of the trees are 40+ years old (1990). Traits: Large, open crown, white bark, sun scalds very easy on young S. side bark.  Roots poor, fast grower, flowers early (4yrs), suckers to 100'.   No noticable BLD. Leaves stay late, until frost kills them.	M	0	0	0	S of GR,MI. Many trees planted along E. Paris and Patterson.  	0	0	W	Y	N	N	Y	2	1983-01-01	A	3	2	0	TBD
ZOO	24	This clone is similar to EBL alba.	M	0	0	0	S of GR,MI. Many trees planted along E. Paris and Patterson.  	0	0	W	N	N	N	Y	2	1992-01-01	A	3	2	0	TBD
SOUTHBELL	25	A large open crowned tree. Lots of flowers, good flowering characteristics, typical alba.  Died in 2003.	F	0	0	0	S of GR,MI. Many trees planted along E. Paris and Patterson.  	0	0	W	N	N	N	Y	2	1995-01-01	A	3	2	0	TBD
15AG4MF	26	A Brad Bender selection.  This family performed well on a UP MSU site.  MSU Family U08m row-column location is 55-51.  A common short name is simply AG15.	M	0	0	AG15	U08m-1992 Row-41 Column-19 (middle tree in 3-tree plot)	0	0	M	Y	Y	N	N	2	2011-01-01	H	6	25	0	TBD
AA101	27	Not to be confused with clone A101.  One of 3 trees planted @ 100/Patterson in MI. AA101 has good form, vigor but some stem canker.  Lots of flower buds, some flower branches rooted in the buckets after 2.5 weeks.  Rooting: 1994=2/30(7%)	F	0	0	0	McGovern breeding project	0	0	W	N	N	N	N	2	1987-01-01	A	3	3	0	TBD
PA092	28	From Italy's Casale Monferrato (Alessadria) via the Poplar Institute of Experimentation and Dott. G. Lapietra.  Pollen was old & weak from shipment. 	M	0	0	0	Italy: lat N 45 degrees 08' Long E. 8 degrees 30'	0	0	W	Y	Y	N	Y	2	1991-01-01	A	3	2	0	TBD
PCA1	29	Border female @ old PCA aspen planting (1971). It is a large straight bole.  It origininated from Romania as an open pollinated seedling collected from a single plus tree in a nursery.  IPC's number was: XA-0-93-70. 	F	0	0	0	PCA site @ Freesoil, MI	0	0	W	N	N	N	N	2	1988-01-01	A	3	2	0	TBD
PCA2	30	Border female @ old PCA aspen planting (1971). It is a large straight bole.  It origininated from Romania as an open pollinated seedling collected from a single plus tree in a nursery.  IPC's number was: XA-0-93-70. Propagation was attempted but failed.	F	0	0	0	PCA site @ Freesoil, MI	0	0	W	N	N	N	N	2	1988-01-01	A	3	2	0	TBD
AA510	31	It is the tallest of all alba seedlings of 1989 crosses with good tap root.  Rooting: 1990=50%, 1992=54%	U	0	0	0	McGovern breeding project	0	0	M	Y	N	N	N	2	1989-01-01	A	3	109	0	TBD
AA511	32	Selected from Howard City Rest Area site.  Very vigorous tree.  Rooting: 1992=40%  	U	0	0	0	McGovern breeding project	0	0	M	Y	N	N	N	2	1990-01-01	A	3	109	0	TBD
AA2101	33	Selected from 55 nursery seedlings for vigor, strong tap root and 100% ortet rooting in 1992. Planted at SLNE and RNE, flowered at age 4. Very narrow fastigate tree that is susceptible to BLD and short lived.  Ortet had 100% initial rooting with 7 - 8 inch cuttings via Hormex #30 IBA Rooting powder with 3% IBA.  Nursery rooting history: 1992=100% (7/7), 2003=38% (20/53), 2004=32% (19/60).	U	0	0	0	Ortet located at Sand Lake/US 131 Interchange	0	0	W	Y	N	N	N	2	1992-12-01	A	3	57	0	TBD
AA4101	34	Excellent form and vigor with some BLD observed on 8/28/01. Seems to have aspen branching features. 37 inch circumference, 11.8 inch diameter on 12/26/04. BLD score: 8/28/01=1 Rooting: 2004=0% (0/40)	F	0	0	0	Ortet located @ RNE/US 131 	0	0	M	N	N	N	Y	2	2001-03-20	A	3	88	0	TBD
AA4102	35	Excellent form and vigor.  Form may be better than aa4101. Seems to have aspen branching features. 37 inch circ and 11.8 inch diameter on 12/26/04. BLD score: 8/28/01=0 Rooting: 2004=10% (4/40).	M	0	0	0	Ortet located @ RNE/US 131 	0	0	M	Y	N	N	Y	2	2001-08-28	A	3	88	0	TBD
AA4201	36	Open pollinated seed from Yugoslavia. Good form and vigor dispite top damage. Lots of flowers. BLD score: 2001=0% (0/20)	M	0	0	0	Ortet located @ RNE/US 131 	0	0	M	Y	N	N	Y	2	2001-01-01	A	3	90	0	TBD
DN34	37	Used as a control clone.  Has a reputation for good, stable performance even on dry sites. Rooting 6 cuttings: 2004=86% (153/178).  Originated at the Simon Louis Freres Nursery in Plantieres, France in 1832 and imported to North America around the 19th or early 20th century.  	M	P. xcanadensis 'Eugenei'	Carolina	NC-5326	Hramor Nursery - Manistee, Michigan	0	0	M	Y	Y	Y	Y	2	1985-01-01	C	1	2	0	TBD
NM6	38	Used as a control clone.  Very vigorous, known to be susceptible to wind breakage.  Have seen canker issues.	M	Populus nigra L. x P. maximowiczii A. Henry 'NM6'	0	0	Brad Bradford	0	0	M	Y	Y	N	N	2	2004-01-01	C	1	2	0	TBD
PIONEER	39	Typical alba, poor form fair vigor.  Seems to be a poor seed bearing tree!	F	0	0	0	Located on W. side of Pioneer Construction Co. SE of Burton/131 along Plaster Creek	0	0	W	N	N	N	Y	2	1990-01-01	A	3	2	0	TBD
TA10	40	Tetraploid (4N) P. tremula.  A large tree with short stubby branches and lots of huge flower buds.  Does not seem to be long lived.  See: http://www.sfws.auburn.edu/enebak/pubs/cjfr26.html  It may originate from the oceanic region of Ekebo, Sweden.  It is suspected to be poorly adapted to our climate. Sheds a lot of pollen.  Must dry before storage or it may clump.	M	0	0	0	DNR MTIC	0	0	M	Y	Y	N	N	4	2004-01-01	ASO	1	2	0	TBD
AA3201	41	A vigorous tree, fair to poor form. Rooting: 2004=0% (0/20)	F	0	0	0	Ortet located @ RNE/US 131 	0	0	M	N	N	N	N	2	2004-01-01	A	3	78	0	TBD
AAG2001	42	Vigorous tree growing on a good site at RNE.  One of 15 ortets planted at RNE in which 2 were vigorous.  This clone was cut in 2014 for breeding, producing family 1xBAR with 0% germination at Rakers and 3 seedlings at MBP. 	M	0	0	0	RNE/US131 Interchange Michigan. 14th tree from family stake.	0	0	M	Y	N	N	N	2	2004-01-01	AH	1	56	0	TBD
AAG2002	43	Vigorous 3 bole tree growing on a somewhat poorly drained site.  Tallest tree on this site.  Very large leaves.  Produced 1 surviving seedling in 2004.  Stigmas have some red. 28 circumference on 12/26/03.  Observed on 8/16/09 that this single 4yr clone at CSSE was doing very well, about 5 dbh. same as best 82xAA04 tree.  Should monitor for bld.  Two planted at UofMN averaged 17cm dbh in 10 yrs.  	F	0	0	0	Sand Lake/US131 Interchange Michigan	0	0	M	Y	N	N	N	2	2004-01-01	AH	1	56	0	TBD
AA901	44	Vigorous tree with fairly good form. Has a slight East lean.  Flowering: Sparse, heavy bracts, can't see stigmas, fertilize at 1/2 flower length.  33 circ, 10.5 diameter on 12/26/03.  Rooting: 2004=0%	F	0	0	0	Ortet located @ RNE/US 131 	0	0	M	N	N	N	N	2	2004-01-01	A	3	146	0	TBD
CLONE5	45	Huge, vigorous well formed small tooth aspen. Can make good quality seed. 	F	0	0	0	DNR MTIC	0	0	M	Y	Y	N	N	2	2004-01-01	ASA	1	2	0	TBD
11AB11	232	11ab11#rankms=13_rankdc=114_reps=1_srate=0.2_class=AH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	AH	19	2	TBD	TBD
AA2301	46	Huge, vigorous poorly formed tree. 2 sides biased. Collected root/shoots in 2004.  37 circ, 11.8 diameter on 12/26/03.  Rooting: 2004=0%	F	0	0	0	PMG's site @ RNE/US 131	0	0	M	N	N	N	N	2	2004-01-01	A	3	60	0	TBD
AA3001	47	One of 3 trees planted at SLSE.  This is the most vigorous.  Diameter was 10.8 on 12/26/03.Has poor form.  BLD: 2003=1, 2004=0. Flowering: must fertilize early, at 1/2 Rooting: 2004=10% (4/40) 	F	0	0	0	Sand Lake/US131 Interchange Michigan	0	0	M	N	N	N	N	2	2004-01-01	A	3	76	0	TBD
GG102	48	A nice full sib GxG selection from the East edge of the MBP RNE planting.  Note that the parents BT044 x BT016 ranked third and first in the MSU, Greg Reighard 1982 P. Smithii test. 	F	0	0	0	PMG's site @ RNE/US 131	0	0	M	N	N	N	N	2	2004-01-01	ASA	10	49	0	TBD
GG101	49	A nice full sib GxG selection from the East edge of the MBP RNE planting.  Note that the parents BT044 x BT016 ranked third and first in the MSU, Greg Reighard 1982 P. Smithii test. 	M	0	0	0	PMG's site @ RNE/US 131	0	0	M	N	N	N	N	2	2004-01-01	ASA	10	49	0	TBD
BT016	50	This is potentially the same tree as MSU's 7431-0016 that was used in Greg Reighard's plantings. It is the male parent of the #1 MSU family for their Water Quality site.   I cut a tree likely of this clone on 2/27/93.  I selected a 14 dia tree about 29 paces North of Greg R's selection.  It is on a ledge.  I cut the number 93 into the stump after I cut the tree.	M	0	0	0	Ingham County sec 34 t2n, r1e ON Williamston Rd. before Dansville & Bunker Hill, on West side of road.  It is .4 mile South of Howard road. 	0	0	M	Y	N	N	N	2	1990-01-01	ASA	10	2	0	TBD
BT044	51	This is potentially the same tree as MSU's 7431-0044 selection. This is the female that was used in P. smithii family that was #2 in WC test and had no observed (by PMG) BLD at MSU WC site in 1990.  	F	0	0	0	Van Burien County T15, R15w sec 29. Located 1 mile NW of Breedsville, MI	0	0	M	Y	N	N	N	2	1990-01-01	ASA	10	2	0	TBD
FHBT	52	Large tree in a yard.  Known as Forest Hills Big Tooth.	M	0	0	0	NE Grand Rapids @ Forest Hills Dr and Ada Dr.	0	0	M	N	N	N	N	2	1988-01-01	ASA	10	2	0	TBD
BT1	53	Fair form.	M	0	0	0	North of Middlevile, E of M37next to road sign, Grand Rappids 22	0	0	M	N	N	N	N	2	1990-01-01	ASA	10	2	0	TBD
BT2	54	0	F	0	0	0	In Barry State Game area. Whitmore and Oak st. 	0	0	M	N	N	N	N	2	1990-01-01	ASA	10	2	0	TBD
BT017	55	4 trees in clone. Looks good, site looks good. About 2 miles SE of bt016.	M	0	0	0	Ingham County sec 3. SW of Ewers & Lienhart Intersection.	0	0	M	Y	N	N	N	2	1993-01-01	ASA	10	2	0	TBD
CRANDON	56	This clone has been used in many NC tests.  It gets BLD very heavily near Grand Rapids, MI. It often dies before age 10 on stressfull sites.  On good sites it is a productive clone.  Known for good diameter growth. It rooted 14% in 1990. 	B	0	0	0	Iowa	0	0	M	Y	Y	N	N	2	1983-01-01	H	6	2	0	TBD
FHAG	57	A large single AG in a yard.  Good seed producer. A sucker is planted at RNE.	F	0	0	0	NE Grand Rapids @ Forest Hills Dr and Ada Dr.	0	0	M	Y	N	N	N	2	1987-01-01	H	6	2	0	TBD
KENT	58	0	F	0	0	0	SE Grand Rapids, MI. W of EBL and N of 44th, S of 36th 	0	0	M	N	N	N	N	2	1989-01-01	H	6	2	0	TBD
GA14	59	The male alba is from Brno, Czech.	F	0	0	0	Obtained pollen from Maple, Ontario	srs,g3	A56	M	Y	Y	N	N	2	1991-01-01	H	7	2	0	TBD
AGMORIN	60	Located on a very sandy dry site.  Some BLD. Does not seem to sucker as much as Crandon.  A vigorous clone! Flowers late in age.  	M	0	0	0	Located E of Manistee, MI. Behind City Bar. 	0	0	M	Y	N	N	N	2	1985-01-01	H	6	2	0	TBD
AGRR1	61	A vigorous, well formed wild AG from Rockford, MI with lightly figured wood, and growing on a good site. Trees were about 33 years old in 1991 and 90 feet tall.  Planted at RNE.  Visited the ortet on 9/17/13 and the stand is still going strong.  Straight line winds in early Spring 2014 blew down most of this clone.  It has good veneer peeling characteristics per Tom Lenderink.	M	0	0	0	W of Rockford, MI. on Oak st 1 mile E of 10 mile.	0	0	M	Y	N	N	Y	2	1991-01-01	H	6	2	https://drive.google.com/open?id=0B7-SwoTVeWFaME1GY1JNMWJfcXc	TBD
CA2	62	A selection from Czechoslovakia.  Planted at PCA test planting. Very suseptible to BLD. Poor form, very poor rooting?	F	0	0	0	Howard City Rest Area along US131	0	0	M	Y	Y	N	N	2	1985-01-01	H	9	2	0	TBD
AE42	63	Fair form.  Good rooting. Rooting: Canada=50%, 1989=33%, 1990=46%	M	0	0	0	Maple, Ontario	a69	e12	M	N	Y	N	N	2	1989-01-01	H	9	2	0	TBD
C28	64	Canada obtained this clone from Pradikow, Prussia.	M	0	0	0	Maple, Ontario	0	0	M	N	Y	N	N	2	1991-01-01	H	9	2	0	TBD
CAG177	65	Produced in 1964 in Maple, Ontario Canada.  Seems to have more aspen traits and better form than its sibling CAG204.  A fair performer at CSSE site, one large tree and several suckers.  Rooting: Canada called it a poor rooter, McGovern: 52% via 8 cutitngs and #30 IBA (1989. 53% 7 cuttings #30 IBA 1990.  It is affected by BLD, grows on good sites. Started male branches in 1989 from Canada, which were young (10 yrs?) sparsely flowered.  It shed very little pollen and but did not make seed.  Planted at HCRA, CSSE and 2 at McGovern's Creek off 29st.     	M	0	0	0	Maple, Ontario	c18	ag7	M	Y	Y	N	N	2	1989-01-01	H	13	2	https://drive.google.com/open?id=0B7-SwoTVeWFaZ2NvWUFkLUE3TkE	TBD
CAG204	66	Produced in 1969 in Toronto, Ontario Canada.  Seems to have more alba traits.  An excellent performer at CSSE site with trees grown 1.5' apart as stools for 20+ years. Fall leaf color has been black in nursery (89,90) Rooting: Canada=37%, 1989=60%, 1990=27%.  Same parents as CAG177, but very different clones in appearance and form.  The female, C18 is a P. canescens obtained from Brno, Czechoslovakia in 1953.  The male is AG7, obtained from Rosedale Golf Club in Toronto, Ontario in 1954.  Collected 3 Wind pollinated branches in 2011 with excellent seed set and good seed viability.     	F	0	0	0	Maple, Ontario	c18	ag7	M	Y	Y	N	N	2	1989-01-01	H	13	2	https://drive.google.com/open?id=0B7-SwoTVeWFaT0ZENHl0RVFLTHc	TBD
ST071	67	A selection by PMG that tried to collect MSU's 7439-0071 tremuloides selection.  I found a depression.  His notes indicate, probably won't find it	F	0	0	0	Roscommon county t22n, r4w sec 3,10 .3 miles S of old m27 from wildlife station. E side of road.	0	0	M	Y	N	N	N	2	1990-01-01	ASA	11	2	0	TBD
ST072	68	0	M	0	0	0	3 miles N of st071. N side of research station., 200' from m27.	0	0	M	N	N	N	N	2	1991-01-01	ASA	11	2	0	TBD
ST2	69	Did not hold seed well.	F	0	0	0	Located west of st071.	0	0	M	N	N	N	N	2	1990-01-01	ASA	11	2	0	TBD
ST3	70	Wild P. Smithi. 10 trees in clone. About 12 in dia.  Gets BLD and dies back like AG's.  It is planted at SLNE and is as vigorous as Prince alba.  Poor alba like form and is bisexual.  The leaves do not resemble the TG's made by MSU, however, they do have some tomentose on leaf undersides and on the tips of the buds.  Should check its ploidy level as leaves are dark green with a similar texture to TA10. 14.6 diameter on 12/26/03.	B	0	0	0	SE Grand Rapids, MI. S of 52nd, W of Eastern.  	0	0	M	N	N	N	N	2	1990-01-01	ASA	5	2	0	TBD
83AA1	106	#9:  Selected during PIP2 Root test.  Best of PIP2. Had 2 dead shoots, tallest=25mm, Smallest dia=4, Rooting: 2005=2/3 66%	U	0	0	0	Ortet selected in 2005 PIP3 test	0	0	M	N	N	N	N	-1	2005-01-01	A	3	140	0	TBD
EE102	71	All of the 1xee91 tremula have died from an unknown die back disease.  This was one of the last survivors Took these roots from the parent tree on 5/26/03.  very vigorous tree, great form.  This was the 9th tree from the North stake at RNE.  Planted 5 at CSSE in 2005 of which 2 survived.   	F	0	0	0	RNE US131	e138	e120	M	N	N	N	N	2	2003-01-01	ASO	12	44	0	TBD
E138	72	Canada obtained this clone from Hubenow, Moravia in 1963. 	F	0	0	0	Maple, Ontario	0	0	M	N	Y	N	N	2	1991-01-01	ASO	12	2	0	TBD
E120	73	Canada obtained this clone from East Germany. It is a fairly clean looking tree. Produced a lot of pollen.	M	0	0	0	Maple, Ontario	0	0	M	N	Y	N	N	2	1991-01-01	ASO	12	2	0	TBD
ST5	74	0	F	0	0	0	Roscommon county t22n, r4w sec 4  on DNR research site.	0	0	M	N	N	N	Y	2	1993-01-01	ASA	11	2	0	TBD
T8057	75	A 2N tremuloides.  Fairly typical small tooth?	F	0	0	0	MTIC Howell, MI	0	0	M	N	N	N	Y	2	2004-01-01	ASA	1	2	0	TBD
R43C76	76	Obtained root material on 4/24/04:  Female with circumference of 33 & lots of maturing catkins. No visible disease. This is an edge tree, yet its inside sibling (R43C77) is larger (37 circumference) yet it might be dead? Leaves just starting to flush. Propagated 2 trees in 2004 for MSU.  	F	0	0	0	 MSU-Sand Hill - 82.02	7439-0033	7431-0033	M	Y	N	N	Y	2	2004-01-01	ASA	1	2	0	TBD
R32C77	77	Obtained root material on 4/24/04:  Circumference of 33 & medium amount of maturing catkins. No visible disease. Propagated 4 vigorous trees in 2004 for MSU.  	F	0	0	0	 MSU-Sand Hill - 82.02	7439-0033	7431-0033	M	Y	N	N	Y	2	2004-01-01	ASA	1	2	0	TBD
R28C74	78	 Obtained root material on 4/24/04: Likely a male (no catkins).  A nice tree, great form, no disease.   No sign of bud movement.  Circumference is 49.  Located between R23C72 and R32C76 with 3 PINK ribbons.  Roots were very difficult to obtain, somewhat poor in quality. Propagated 1 12 shoot from a large root in 2004. This may be a selection form the wild.	M	0	0	0	 MSU-Sand Hill - 82.02	0	0	M	Y	N	N	Y	2	2004-01-01	ASA	1	2	0	TBD
76AA4	79	Selected after 2yr. Root test. Branchy. Rooting: 2003=100% (Yellow), 2004=90% 9/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA5	80	Selected after 2yr. Root test. Not Branchy. Rooting: 2003=100% (Yellow), 2004=80% 8/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA6	81	Selected after 2yr. Root test. Vigorous, not Branchy. Rooting: 2003=100% (Yellow), 2004=90% 9/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA7	82	Selected after 2yr. Root test. Vigorous, not Branchy. Rooting: 2003=100% (Yellow), 2004=60% 6/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA8	83	Selected after 2yr. Root test. OK growth. Rooting: 2003=100% (Yellow), 2004=70% 7/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA9	84	Selected after 2yr. Root test. Vigorous, not Branchy. Rooting: 2003=100% (Yellow), 2004=100% 10/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA1	85	Selected after 2yr. Root test. Varied Growth. Rooting: 2003=100% (Red), 2004=70% 21/30	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA2	86	Selected after 2yr. Root test. Varied Growth. Rooting: 2003=100% (Red), 2004=90% 27/30, 2005 PIP1=81% 17/21	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA3	87	Selected after 2yr. Root test. Varied Growth. Rooting: 2003=100% (Red), 2004=70% 21/30	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA10	88	Selected after 2yr. Root test. Tall 4-6'. Rooting: 2003=80% (Black), 2004=100% 10/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA11	89	Selected after 2yr. Root test. OK growth.  Rooting: 2003=80% (Black), 2004=70% 7/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA12	90	Selected after 2yr. Root test. OK growth.  Rooting: 2003=80% (Black), 2004=100% 10/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA13	91	Selected after 2yr. Root test. Variable growth. Rooting: 2003=80% (Black), 2004=80% 8/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA14	92	Selected after 2yr. Root test. Nice growth 3-4'. Rooting: 2003=80% (Black), 2004=100% 10/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA15	93	Selected after 2yr. Root test. OK growth. Rooting: 2003=80% (Black), 2004=90% 9/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA16	94	Selected after 2yr. Root test. OK growth. Rooting: 2003=100% (Yellow), 2004=90% 9/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA17	95	Selected after 2yr. Root test. Nice 4-5'. Rooting: 2003=100% (Yellow), 2004=90% 9/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA18	96	Selected after 2yr. Root test. Best  competetive growth!  4-5'. Rooting: 2003=100% (Yellow), 2004=80% 8/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA19	97	Selected after 2yr. Root test. Good growth. Rooting: 2003=100% (Yellow), 2004=90% 9/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
77AA1	98	Selected after 2yr. Root test. OK growth 2-3'.  Rooting: 2003=100% (Red), 2004=83% 25/30	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	130	0	TBD
77AA2	99	Selected after 2yr. Root test. OK growth 2-3'.  Rooting: 2003=100% (Red), 2004=80% 32/40	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	130	0	TBD
77AA9	100	Selected after 2yr. Root test. OK branchy.  Rooting: 2003=80% (Black), 2004=80% 8/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	130	0	TBD
77AA8	101	Selected after 2yr. Root test. Good growth 4-6'..  Rooting: 2003=80% (Black), 2004=100% 10/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	130	0	TBD
77AA3	102	Selected after 2yr. Root test. OK growth. .  Rooting: 2003=100% (Yellow), 2004=60% 6/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	130	0	TBD
77AA4	103	Selected after 2yr. Root test. OK growth. .  Rooting: 2003=100% (Yellow), 2004=100% 10/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	130	0	TBD
77AA5	104	Selected after 2yr. Root test. Nice, 4-5'  growth. .  Rooting: 2003=100% (Yellow), 2004=100% 10/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	130	0	TBD
77AA6	105	Selected after 2yr. Root test. OK growth, branchy.  Rooting: 2003=100% (Yellow), 2004=100% 10/10	U	0	0	0	Ortet selected in 2004 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	130	0	TBD
83AA2	107	#24: Selected during PIP3 root test. Weighted score=29, basic score=50.  Best of PIP3 test! Rooting: 2005=4/6 66%	U	0	0	0	Ortet selected in 2005 PIP3 test	0	0	M	N	N	N	N	-1	2005-01-01	A	3	140	0	TBD
83AA3	108	#29: Selected during PIP3 root test. Weighted score=24, basic score=33.  Heavy bottom rooting. Rooting: 3/6 50%	U	0	0	0	Ortet selected in 2005 PIP3 test	0	0	M	N	N	N	N	-1	2005-01-01	A	3	140	0	TBD
83AA4	109	#30: Selected during PIP3 root test. Weighted score=25, basic score=27.  Rooting: 3/6 50%	U	0	0	0	Ortet selected in 2005 PIP3 test	0	0	M	N	N	N	N	-1	2005-01-01	A	3	140	0	TBD
83AA5	110	#48: Selected during PIP3 root test. Weighted score=23, basic score=27.  Heavy bottom rooting. Rooting: 5/6 83%	U	0	0	0	Ortet selected in 2005 PIP3 test	0	0	M	N	N	N	N	-1	2005-01-01	A	3	2	0	TBD
83AA6	111	Selected for potential figured wood characteristics.  The 2nd year wood of this 3yr. tree had bumpy/rippled bark.  I cut 3 4' whips for 2007 propagation.  Need to root test indoors next year.  Need to see if any clones will show figured wood....  May be a good candidate to cross with good rooters...	U	0	0	0	Ortet selected from Post/US131 Interchange on 4/11/07	0	0	M	N	N	N	N	-1	2005-01-01	A	3	140	0	TBD
83AA58	112	This is a PIP tested clone.  It maps to record B11.58-83x in my PIP docs and it had a score of 25.5 (low)...  It was likely a mistake that it was given to Brad Bender who used it in his rooting tests.  However, it may still be a good rooting clone since Flat B was challenged with dryness which likely affected rooting results...	U	0	0	0	Ortet selected in 2010 @ Bell Nursery	0	0	M	N	N	N	N	-1	2005-01-01	A	3	140	0	TBD
83AA101	113	Selected on 7/11/09 for its 4N potential.  Has very thick stem, large buds, extra green leaves, vigorous but shorter height and very thick and unusual terminal shoot.  Collected 10 softwood cuttings from syliptic shoots for propagation and dipped with #30 IBA.  Took pics of selections.  Transplanted 7 rooted cuttings on about 8/1/09.  On 8/16/09 the tallest plant was 9 1/4 tall and 3.2 mm at base.	U	0	0	0	Selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	M	N	N	N	N	-1	2009-01-01	A	3	140	0	TBD
83AA102	114	Selected on 7/11/09 for its vigorous growth and extra thick stem diameter potential.  Stem dia at base=8.3 mm (ave large stemmed population is 6.5)  Collected 10 softwood cuttings from syliptic shoots for propagation and dipped with #30 IBA. Took pics of selections.  Transplanted 7 rooted cuttings on about 8/1/09.  On 8/16/09 the tallest plant was 13.3/4 tall and 4 mm at base.	U	0	0	0	Selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	M	N	N	N	N	-1	2009-01-01	A	3	140	0	TBD
83AA103	115	Selected in 9/2009 for a possible mutation where a sylliptic shoot apparently mutated (somaclonal variation?) and the observable change was that the leaf shape above that shoot was spear shaped.  I propagated the tips and the shape is still spear shaped.  More propagation will be conducted.  It may be useful as a marker clone.  It may even revert back to the normal alba maple leaf shape...	U	0	0	0	Selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	M	N	N	N	N	-1	2009-01-01	A	3	140	0	TBD
83AA104	116	Selected in 9/2009 for its remarkable growth performance in the back 20% Northern section of the nursery row that was typically slower growing. It was growing in a competitive area with many nearby seedlings.  It grew 8' 2 in the nursery. and has the thickest basal stem diameter (19mm @1 from root collar) of the entire 2009 83x crop.  The next tallest class contains about 10 seedlings that are about 6 to 6.5 feet tall.  The stem is relatively straight, leaves healthy and terminal tip has a medium sized bud that is tightly closed (observed 10/19).  On 10/20, observed that its remaining leaves went from top to about 52 from ground.  Need to monitor all internal trees for leaf drop date.  Also, this clone does not have any sylliptic shoots, which could be very good for form.  As of 11/07/09 the leaf retention is perhaps the best of all the nursery trees. and they are still quite green.  Noticed that ants like the sap exuding from the freshly fallen leaves, somewhat swee too.  Took pics of leaf and growwing tip with leaves.	U	0	0	0	Selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	M	N	N	N	N	-1	2009-01-01	A	3	140	0	TBD
T0601	117	Vigorous clone growing on marginal, open site.  Need GPS site location.	M	0	0	0	12231 Buchanan (SE Big Rapids) Clear cut, 200' from S side of road.	0	0	M	N	N	N	Y	-1	2006-01-01	ASA	1	2	0	TBD
T0602	118	Vigorous clone growing on good, weedy site.  Some of the ripe aspen ovaries are bright yellow...  Need GPS site location. 	F	0	0	0	< 1mile SE of GFS and East of bike path West of lumber yard and South of 54th. 	0	0	M	N	N	N	Y	-1	2006-01-01	ASA	1	2	0	TBD
4AA101	119	Nice tree, even compares favorably to area DN 34 and border tree.  A number are planted at HCRA with 2 nice specimens.	U	0	0	0	Ortet @ HCRA, 16th tree East of 4xaa89 West stake.	0	0	M	N	N	N	N	-1	2009-01-01	A	3	96	0	TBD
70AA01	120	Observed a nice single bole border specimen at RNE on SW end.  No observed BLD in 09.  Should be an interesting clone, since it has no A502 and the ser41 male parent was selected from an Italian plantation so it may have good rooting.  10/05/09 Site observations:  48 Circumfirence, no surviving siblings, may have been cut down, has larger stem branches (3-4 class). Fairly straight bole. Quite tapered.  3 Nearby single bole DN34: 35 and 36 circ. 	F	0	0	0	RNE SW corner, tagged	0	0	M	Y	N	N	N	-1	2009-01-01	A	3	123	0	TBD
68AA01	121	Fall-09 Observed a nice specimen at RNE on SW end.  It is a 3 bole tree with no observed BLD in 09.  Should be an interesting clone, since it has no A502 and POL2 males was known for its size. 10/05/09 site observations: North bole circumference is 40 at 4' high. Moderate stem branchiness (2-3 dia size).  Siblings are much weaker.  3 Nearby single bole DN34: 35 and 36 circ. 	F	0	0	0	RNE SW corner, tagged	0	0	M	N	N	N	N	-1	2009-01-01	A	3	120	0	TBD
62AA01	122	Observed 8/31/09: Found one really nice tree at RNE (2009). Quite vigorous, reasonable form.  10/05/09 site observations: 50 circumference at 4' high. Slight sweep in bole. 2 leaves observed to have BLD on lower branch, otherwise very healthy...  Side branches are 2-3 best of the 93 bunch...  Nearby DN34 are 32, 34, and 44 circumference.  The 44 tree is a border tree on West side.	M	0	0	0	RNE - West of AA4102, 3rd row from west edge.	0	0	M	N	N	N	N	-1	2009-01-01	A	3	114	0	TBD
76AA214	123	Grown at Bell in 2008 and Ryan's nursery in 2009 (6/10)	U	0	0	0	Ortet selected in 2009 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA217	124	Grown at Bell in 2008 and Ryan's nursery in 2009 (12/20). May be best 76aa clone.	U	0	0	0	Ortet selected in 2009 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
83AA189	125	This is a PIP tested clone.  It maps to record D6.189.83x and had a score of 112.5 which was the highest 2010 PIP score.   Brad Bender used it in his rooting tests	U	0	0	0	Ortet selected in 2010 @ Bell Nursery	0	0	M	Y	N	N	N	-1	2005-01-01	A	3	140	0	TBD
83AA202	126	Not associated with 2009 PIP-202 test...	U	0	0	0	Ortet selected in 2009 @ Bell Nursery	0	0	M	N	N	N	N	-1	2009-01-01	A	3	140	0	TBD
83AA203	127	Dark green leaves - Bugs like leaves...  The PIP-09-T5 test had incredible callus cluster roots at cutting base. 5/6 rooted 2009.	U	0	0	0	Ortet selected in 2009 @ Ryans Nursery	0	0	M	N	N	N	N	-1	2005-01-01	A	3	140	0	TBD
83AA204	128	First tested in 2/16/2010 in PIP test 2010-02-16-83x-D with an ID of D7.204.83x and a PIP score of 103.5.  The roots have exceptionaly thick basal callus.  Planted 7 cuttings, 6 survived with the tallest at 8.5'.  3 others were around 8'.  A 1-0 stock of this clone also outperformed nearby clones but not to the same degree. It should be noted that additional fertilizer was applied 2' from the cuttings to ensure survival of the only 41AA111 cutting.  Therefore this clone needs to be reassessed again.  Dormant syliptic cuttings were propagated under lights on 3/24/11.  There were shoots forming from the callus.  On 4/18/11 larger 8cm cuttings were propagated with buds cut off and significant amount of callus and shoots have formed.  	U	0	0	A204	Ortet selected in 2009 @ Bell Nursery	0	0	M	Y	N	N	N	-1	2009-01-01	A	3	140	0	TBD
83AA206	129	NIce! Tallest=81, 100% rooting if 4 is counted. 3/4 2009 rooting. 2010 Rooted 67% (14/21).	U	0	0	0	Ortet selected in 2009 @ Ryans Nursery	0	0	M	N	N	N	N	-1	2005-01-01	A	3	140	0	TBD
83AA208	130	2/4 in 2009	U	0	0	0	Ortet selected in 2009 @ Ryans Nursery	0	0	M	N	N	N	N	-1	2005-01-01	A	3	140	0	TBD
83AA209	131	2/11 in 2009 rooting.  Huge 1-0 and 1-1 parent stock, Large leaves, wavy, syliptic	U	0	0	0	Ortet selected in 2009 @ Ryans Nursery	0	0	M	N	N	N	N	-1	2005-01-01	A	3	140	0	TBD
35AA200	132	This entire family has the latest leaf drop of any surviving clones at RNE (2009).  All are fairly vigorous trees with fair form.	M	0	0	0	RNE	0	0	M	Y	N	N	N	-1	2010-01-01	A	3	80	0	TBD
35AA201	133	6/10 rooted in a PIP test in 11/09, but likely not a good rooter.  See: 92xAA10	M	0	0	0	RNE	0	0	M	N	N	N	N	-1	2010-01-01	A	3	80	0	TBD
35AA202	134	See: 102xAA10 and 104xAA10	F	0	0	0	RNE	0	0	M	N	N	N	N	-1	2010-01-01	A	3	80	0	TBD
83AA105	135	Selected in 9/2009 for its numerous small side shoots that may indicate it will be extremely branchy... Scored 29.5 PIP in 2009 (#87) for flat C, which was challenged.	U	0	0	0	Selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	M	N	N	N	N	-1	2009-01-01	A	3	140	0	TBD
83AA106	136	Selected in 9/2009 for its numerous small side shoots that may indicate it will be extremely branchy... Scored 62 PIP in 2009 (#96) for flat C, which was challenged.	U	0	0	0	Selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	M	N	N	N	N	-1	2009-01-01	A	3	140	0	TBD
83AA107	137	Selected in 9/2009 for its large dia/hgt and aspen like bark (not white).  Fairly straight.  Scored 104 PIP in 2009 (#183) for flat D - all BCR rooting.	U	0	0	0	Selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	M	N	N	N	N	-1	2009-01-01	A	3	140	0	TBD
41AA111	138	Fastigate tree. This and aa4102 are last surviving trees of this clone planted at RNE (~70 planted). It was declining in vigor.  The flowers were very high, so it was cut down in Spring 2010 for Phase 3 breeding.  The stems had a curly habit.  Tree was cut at about 4.5' high to promote shoots for propagation.  It was mated with 3 albas, NFA, EBL, and 35AA201. It had large flowers with thick stigmas.  I fertilized it when the flowers were 1/2 long but might   have been better to wait until about 3/4 long since the stigmas seemed to peak then. It was not an ideal female from a seed bearing perspective in 2010.	F	0	0	0	Ortet located (stump tagged) @ RNE/US 131	0	0	M	N	N	N	N	-1	2001-01-01	A	3	88	0	TBD
33AA11	139	Nice, well formed tree. Flowers were receptive later (2010)  than other albas, which is why it was selected for NFA, since the Zoss alba pollen failed.  Flower lengths ranged from 1/2 to 3/4 at the time of the NFA fertilization.  On 4/13 I observed how unusual these seed bearing catkins were with large, bright green flowers that point upwards.  It dehised the seed naturally and was very productive.  A 3 branch flowering set produced about 8000 seeds in 2010, which could make it more productive than A502.	F	0	0	0	Ortet located at RNE/US 131 tagged (It is the 11th tree of this family from the South edge of planting at RNE)	0	0	M	Y	N	N	N	-1	2010-01-01	A	3	79	0	TBD
40AA08	140	Nice tree with a slight sweep in trunk.  Growing fairly good on a somewhat poorly drained, maintained site.  Mated with 4 males in 2010. While it produced a fair amount of seed, it was not as productive as 33AA11	F	0	0	0	Ortet located at Sand Lake SE and US131 interchange. It is the 8th tree of this family from the North edge.	0	0	M	Y	N	N	N	-1	2010-01-01	A	3	87	0	TBD
30AA5MF	141	AKA 30AA-U08m-5-2. A vigorous, robust tree.  It was surrounded by healthy trees on all sides, yet this tree was very competitive. Poor form typical of PCA2 type trees; however, Brad Bender noticed that the branches were fairly contained and did not reach outsidehe area.  This family ranked #3 for 17yr. TPAY of 6.15 at MSU's U08m FBIC site.	F	0	0	30AA-8m-5-2	MSU's Escanaba UPTIC U08m site. Tree location is row/column 5-2.	0	0	M	Y	N	N	N	-1	2010-01-01	A	3	76	0	TBD
40AA6MF	142	A nice well formed tree.  Had longer catkins than its sibling, 40AA08.  This female does not root via PIP process.  It produces nice shoots but no roots.	F	0	0	40AA-8m-23-27	MSU's Escanaba UPTIC U08m site. Tree location is row/column 23-27.	0	0	M	Y	N	N	N	-1	2010-01-01	A	3	87	0	TBD
83AA1MF	143	A fairly nice tree.  It had 2 male catkins in 2010 that were used in Phase 3 crosses to sire about 450 seeds of 1 cross (100xAA10).  Pollinated 6 flowers from top to bottom with the minimal pollen.  Planted a 1/2 flat on 4/11 as the branch died early and flowers started rotting.  About 1/3 of the seed was small. Crude PIP testing done with the flowering branch material suggest that this may be a good rooter with 100% PIP rooting of tips, and some shoots > 20mm. 	M	0	0	83AA-7m-3-17	MSU's Escanaba UPTIC U07m site. Tree location is row/column 3-17	0	0	M	Y	N	N	N	-1	2010-01-01	A	3	140	0	TBD
83AA2MF	144	A fairly nice tree, good form with one side facing a no-tree family.  It had 13 male catkins in 2010 that were used in Phase 3 crosses to sire about 1600 seeds of 2 crosses (98xAA10  & 104xAA10). Crude PIP testing done with the flowering branch material suggest that this may be a fair rooter with 82% PIP rooting of tips, but NO shoots > 20mm.	M	0	0	83AA-7m-7-4	MSU's Escanaba UPTIC U07m site. Tree location is row/column 7-4	0	0	M	Y	N	N	N	-1	2010-01-01	A	3	140	0	TBD
83AA166	145	This is a PIP tested clone.  It maps to record D4.166.83x and had a score of 70.5 which is mediocre.  It was 11/11 in 2010 Bell nursery and was noted for its early and vigorous start.  It is used in ASP tests...	U	0	0	0	Ortet selected in 2010 @ Bell Nursery	0	0	M	N	N	N	N	-1	2005-01-01	A	3	140	0	TBD
83AA10MF	171	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-63	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
83AA11MF	172	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-72	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
87AA101	146	This is one of 3 seedlings from 3 different families that have variegated leaves.  These F2 families are 87xAA10, 90xAA10 and 94xAA10.  They all share a common F1 parent cross of 40xAA91 (A10 x A57), but 2 come from different 40xAA91 females. Andy David suggested that I follow them over time to see 1) if the varigation disappears as the season progresses 2) whether or not leaves are varigated next year.  Value not only as markers but potentially as horticultural examples.  That may be more valuable in the long run.  See email title: Found 3 variegated albas.  	U	0	0	0	Ortet selected in 2010 @ Woodard Nursery	0	0	M	N	N	N	N	-1	2010-01-01	A	3	164	0	TBD
90AA101	147	This is one of 3 seedlings from 3 different families that have variegated leaves.  These F2 families are 87xAA10, 90xAA10 and 94xAA10.  They all share a common F1 parent cross of 40xAA91 (A10 x A57), but 2 come from different 40xAA91 females. Andy David suggested that I follow them over time to see 1) if the varigation disappears as the season progresses 2) whether or not leaves are varigated next year.  Value not only as markers but potentially as horticultural examples.  That may be more valuable in the long run.  See email title: Found 3 variegated albas.	U	0	0	0	Ortet selected in 2010 @ Woodard Nursery	0	0	M	N	N	N	N	-1	2010-01-01	A	3	165	0	TBD
94AA101	148	This is one of 3 seedlings from 3 different families that have variegated leaves.  These F2 families are 87xAA10, 90xAA10 and 94xAA10.  They all share a common F1 parent cross of 40xAA91 (A10 x A57), but 2 come from different 40xAA91 females. Andy David suggested that I follow them over time to see 1) if the varigation disappears as the season progresses 2) whether or not leaves are varigated next year.  Value not only as markers but potentially as horticultural examples.  That may be more valuable in the long run.  See email title: Found 3 variegated albas.	U	0	0	0	Ortet selected in 2010 @ Woodard Nursery	0	0	M	N	N	N	N	-1	2010-01-01	A	3	161	0	TBD
ST7	149	This is an isolated clone - not tagged.  Noted that after flowers shed or matured, bisexual flowers developed so it may be temporary or unstable.  Collected 8 branches. 	F	0	0	0	Roscommon county t22n, r4w sec 4  on DNR research site.  Clone is directly across the street from 9166 on M55, about 150' South.  	0	0	M	N	N	N	Y	-1	1993-03-06	ASA	11	2	0	TBD
ST8	150	Could be more of this clone at this location. Flowers worked well for a 16 test branch. 	F	0	0	0	Wexford county, Clam Lake TWP. US131 and 115 South of Cadillac exit 176.  Tree is 5 reflector stakes S of 115.  Heavy seed crop.	0	0	M	N	N	N	Y	-1	1993-03-06	ASA	11	2	0	TBD
ST9	151	Not a good seed bearing tree for P. smithii in 93...	F	0	0	0	Kent county, Plainfield twp. Section 3, SE quad of us-131 and 10 mile interchange in a depression	0	0	M	N	N	N	Y	-1	1993-03-23	ASA	11	2	0	TBD
ST10	152	Tree is tagged and painted, may be good for seed bearing.  	F	0	0	0	Kent county, Plainfield twp. Section 3, SE quad of us-131 and 10 mile interchange. About 20 yards east of ramp.	0	0	M	N	N	N	Y	-1	1993-03-23	ASA	11	2	0	TBD
100AA01	153	A SASP selection from the 100xAA10 family.  It was selected for good rooting and vigorous growth under ASP conditions.  In the 2010-11-14-T9 ASP test, this clone rooted very well without any treatment (just water). 	U	0	0	0	PMG's 2010-05-08 100xAA10 SASP test.	0	0	U	Y	N	N	N	-1	2010-09-16	A	3	158	0	TBD
100AA02	154	A SASP selection from the 100xAA10 family.  It was selected for good rooting and vigorous growth under ASP conditions.  In the 2010-11-14-T9 ASP test, this clone did NOT root as well without any treatment (just water). 	U	0	0	0	PMG's 2010-05-08 100xAA10 SASP test.	0	0	U	Y	N	N	N	-1	2010-09-16	A	3	158	0	TBD
100AA03	155	A SASP selection from the 100xAA10 family.  It was selected for good rooting and vigorous growth under ASP conditions.  See SASP 2010-05-08 100xAA10	U	0	0	0	PMG's 2010-05-08 100xAA10 SASP test.	0	0	U	Y	N	N	N	-1	2010-09-16	A	3	158	0	TBD
100AA04	156	A SASP selection from the 100xAA10 family.  It was selected for good rooting and vigorous growth under ASP conditions.   See SASP 2010-05-08 100xAA10	U	0	0	0	PMG's 2010-05-08 100xAA10 SASP test.	0	0	U	Y	N	N	N	-1	2010-09-16	A	3	158	0	TBD
ZOSS	157	Likely a wild AG clone.  Found in Sioux Falls, SD. The tree is behind 605 N. Nesmith Ave. That owner is Dorothy Zoss.   A huge tree...	M	0	0	0	Found in Sioux Falls, SD. The tree is behind 605 N. Nesmith Ave	0	0	W	Y	N	N	Y	-1	2010-12-18	H	6	2	0	TBD
J2	158	Very similar to Jamie alba, likely the same tree...???  Not for breeding purposes, just for observation...	M	0	0	0	North of 5/3 Ballpark.	0	0	W	N	N	N	Y	-1	2010-12-17	A	3	2	0	TBD
76AA205	159	Grown at Bell in 2008 and Ryan's nursery in 2009 (6/10)	U	0	0	0	Ortet selected in 2009 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA211	160	Grown at Bell in 2008 and Ryan's nursery in 2009 (6/10)	U	0	0	0	Ortet selected in 2009 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
76AA218	161	Grown at Bell in 2008 and Ryan's nursery in 2009 (6/10)	U	0	0	0	Ortet selected in 2009 nursery	0	0	M	N	N	N	N	-1	2004-01-01	A	3	129	0	TBD
83AA301	162	Tree is planted and tagged at CSSE on North end of 2005 planting.  It is a vigorous tree with about 10-15 female flowers in 2011 with estimated receptive date of 4/20/11.  The surrounding trees were removed to eliminate competition and allow better flowering.  	F	0	0	0	Ortet selected at CSSE site, because it is the first female 83x clone	0	0	M	N	N	N	N	-1	2011-04-21	A	3	140	0	TBD
WIND	163	A generic place holder for all wind or open pollinated males.	M	0	Wind or Open Pollinated 	W	God	0	0	U	U	N	N	U	-1	1111-11-11	U	2	1	0	TBD
83AA3MF	164	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-69	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	A	3	140	0	TBD
83AA4MF	165	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-70	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
83AA5MF	166	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-66	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
83AA6MF	167	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-75	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
83AA7MF	168	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-74	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
83AA8MF	169	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-65	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
83AA9MF	170	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-68	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
83AA12MF	173	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-71	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
83AA13MF	174	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-67	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
83AA14MF	175	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-73	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
83AA15MF	176	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-64	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
83AA16MF	177	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-76	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
83AA17MF	178	Originally from TRC stool beds and planted at U08as alba clonal trial.	U	0	0	83AA-MSU-62	TRC selection from 2009 sowing of the remaining 4 batches of this seed.  523 seedlings survived on 5/26.	0	0	U	U	N	N	N	-1	2010-05-14	U	3	140	0	TBD
C173	179	U07l-1999 FBIC trial hybrid aspen from Canada via clone named Ca-14-75. A 1975 P. canescens addition from Louis Zufa, via clone number C173 from Clone 484/64 of Zavod Za Topole, Novi Sod, Yugoslavia--open pollinated seedling of plus tree #46 , alba like	F	0	0	Ca-14-75	Canada via Louis Zufa, originally from Zavod Za Topole, Novi Sod, Yugoslavia--open pollinated seedling of plus tree #4	0	0	W	Y	Y	N	N	-1	2012-02-20	H	9	2	TBD	TBD
T202	180	A wild P. tremuloides located on East side of M37 about ? mile South of Mission Point road.. Used for WASP testing	M	0	0	0	Patrick McGovern	0	0	W	U	N	N	N	-1	2012-02-20	ASA	1	2	TBD	TBD
1BW1	181	Renamed from 1CAGW01. 2012 Bell Nursery selection via 1.5 Avg Vigor Survival rate and 100% 6 cutting survival rate (6/6).  A vigorous ramet with Small Tooth and tremula aspen traits.  P. Tremuloides may be male parent. 	U	0	0	1CAGW01	2012 McGovern Bell Ave Nursery	0	0	U	N	N	N	N	-1	2012-06-28	ASH	14	171	TBD	TBD
80AA3MF	182	Selected by Brad Bender at MSU's FBIC site for notable diameter.  He propagated it via harvesting 120 watersprout shoots at 4' and sticking them in soil mix for several weeks. column 9 and row 5 on the u07m map, it is also in block I. It is the 1st tree in that 4 tree plot. The plot has trees on all sides except the tree in column9 row 4, the space next to this tree where I made the cuttings. It is interesting that the few shoots that I left alone on that tree have all died. This may have been a one time opportunity to get 120 easy greenwood cuttings from the lower branches that are already senescencing  like this.  DBH after 8 years = TBD	U	0	0	TBD	MSU's FBIC  U07m-2005 site (MF) Row = , Column =  .  	0	0	W	Y	N	N	N	-1	2012-06-21	A	3	137	TBD	TBD
1CAGW02	183	2012 Bell Nursery selection via .65 Avg Vigor Survival rate and 50% via 6 cutting survival rate (8/4).  A vigorous ramet with Big Tooth and tremula aspen traits.  AE42 may be male parent. 	U	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	Y	N	N	N	-1	2012-11-04	U	14	171	TBD	TBD
1CAGW03	184	2012 Bell Nursery selection via 1.11 Avg Vigor Survival rate and 86% via 6 cutting survival rate (6/7).  A vigorous ramet with Big Tooth and tremula aspen traits.  AE42 may be male parent. 	U	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	Y	N	N	N	-1	2012-11-04	U	14	171	TBD	TBD
100AA11	185	2012 Bell Nursery selection via .88 Avg Vigor Survival rate and 75% via 6 cutting survival rate. 2016 Nursery stats: 100aa11~rankms=50_rankdc=53_reps=4_srate=0.8_class=A. Observed male flowers on 4/15/17 after 4 yrs growth at 5/3 lot.	M	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	Y	N	N	N	-1	2012-11-04	A	3	158	TBD	TBD
100AA12	186	2012 Bell Nursery selection via .78 Avg Vigor Survival rate and 85% via 6 cutting survival rate. 100aa12~rankms=3_rankdc=5_reps=8_srate=0.8_class=A	F	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	Y	N	N	N	-1	2012-11-04	A	3	158	TBD	TBD
101AA11	187	2012 Bell Nursery selection via .76 Avg Vigor Survival rate and 75% via 6 cutting survival rate.	U	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	Y	N	N	N	-1	2012-11-04	A	3	156	TBD	TBD
103AA11	188	2012 Bell Nursery selection via .99 Avg Vigor Survival rate and 90% via 6 cutting survival rate.  Planted with 20 cuttings.	M	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	Y	N	N	N	-1	2012-11-04	A	3	170	TBD	TBD
104AA11	189	2012 Bell Nursery selection via .84 Avg Vigor Survival rate and 70% via 6 cutting survival rate.	U	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	Y	N	N	N	-1	2012-11-04	A	3	169	TBD	TBD
104AA12	190	2012 Bell Nursery selection via .77 Avg Vigor Survival rate and 87% via 6 cutting survival rate.  Planted 3 replications.	U	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	Y	N	N	N	-1	2012-11-04	A	3	169	TBD	TBD
92AA11	191	92aa11#rankms=19_rankdc=6_reps=2_srate=0.8_class=A	U	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	Y	N	N	N	-1	2012-11-04	A	3	152	TBD	TBD
93AA11	192	93aa11#rankms=74_rankdc=66_reps=3_srate=1.0_class=A	M	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	Y	N	N	N	-1	2012-11-04	A	3	166	TBD	TBD
93AA12	193	2012 Bell Nursery selection via .57 Avg Vigor Survival rate and 60% via 6 cutting survival rate, 4 replications.. A 2011 PRAVL selection (6/6 in 2011)	M	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	Y	N	N	N	-1	2012-11-04	A	3	166	TBD	TBD
95AA11	194	2012 Bell Nursery selection via .81 Avg Vigor Survival rate and 90% via 6 cutting survival rate.	U	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	Y	N	N	N	-1	2012-11-04	A	3	162	TBD	TBD
97AA11	195	2012 Bell Nursery selection via .76 Avg Vigor Survival rate and 85% via 6 cutting survival rate.	U	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	N	N	N	N	-1	2012-11-04	A	3	159	TBD	TBD
98AA11	196	98aa11~rankms=25.5_rankdc=5.3_dcreps=21_dcsrate=0.76_archived=8_field_score=6.09	M	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	N	N	N	N	-1	2012-11-04	A	3	155	TBD	TBD
97AA12	197	2012 Bell Nursery selection via ..65 Avg Vigor Survival rate and 70% via 6 cutting survival rate.	U	0	0	0	2012 McGovern Bell Ave Nursery	0	0	U	N	N	N	N	-1	2012-11-04	A	3	159	TBD	TBD
A69	198	It was considered a good rooter, but I did not observe good rooting results in my tests.  One tree at RNE.	F	0	0	0	Apparently a wild selection from Brampton, Ontario in 1952.	0	0	W	N	Y	N	Y	-1	1989-01-01	A	3	2	TBD	TBD
9AG103	199	Poorly formed and with below average vigor.  Selected because it was the only accessable female from 9xAG family in 2013.  Tree was cut at 4' and coppiced over 12'.	F	0	0	0	1991 McGovern breeding project	0	0	W	N	N	N	N	-1	1991-01-01	H	6	147	https://plus.google.com/u/0/photos/102384333186727094185/albums/5905173436984028769?authkey=CPqZopa__5y87AE	TBD
11AB10	231	11ab10&rankms=28.8_rankdc=23.2_dcreps=3_dcsrate=0.77_archived=2_field_score=2.50	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	AH	19	2	TBD	TBD
9AG105	200	Well formed, bisexual and above average vigor.  Selected for future breeding (2014).  Predominately Male in 2014.	B	0	0	0	1991 McGovern breeding project	0	0	W	Y	N	N	N	-1	1991-01-01	H	6	147	https://plus.google.com/u/0/photos/102384333186727094185/albums/5905173436984028769?authkey=CPqZopa__5y87AE	TBD
GG1	201	Well formed bigtooth used for open pollinated study. 	F	0	0	G1	2013 McGovern Breeding project	0	0	W	N	N	N	Y	-1	2013-05-04	ASA	10	175	0	TBD
GG2	202	Urban bigtooth used for open pollinated study. 	F	0	0	G2	2013 McGovern Breeding project	0	0	W	N	N	N	Y	-1	2013-05-04	ASA	10	176	0	TBD
GG3	203	Rural bigtooth used for open pollinated study. 	F	0	0	G3	2013 McGovern Breeding project	0	0	W	N	N	N	Y	-1	2013-05-24	ASA	10	177	0	TBD
3AA202	204	Selected from Howard City Rest Area site.  Very vigorous tree on a dry upland site.  Row/Column Location=TBD	F	0	0	0	1991 McGovern breeding project	0	0	W	Y	N	N	N	-1	2013-04-13	A	3	83	0	TBD
83AA565	205	A 5 year old vigorous, well formed selection from U08as-2010 site (ro,w 6, Column 5) with trees planted as small diameter 10” cuttings.  This tree had about 10 female flowers that were used in 2014 crosses.	F	0	0	0	FBIC	0	0	M	Y	N	N	N	-1	2014-04-07	A	3	140	0	TBD
80AA5MF	206	A FBIC u07m 9 year old selection for being a male tree with notable diameter, planted next to 80AA3MF.   DBH after 8 years = TBD, Row/Column = TBD.	M	0	0	0	MSU's FBIC  U07m-2005 site (MF) Row = , Column =  .  	0	0	W	Y	N	N	N	-1	2014-04-07	A	3	137	TBD	TBD
PLAZA	207	A wild, well formed, vigorous AG clone from NE Grand Rapids, MI.  Used in 2014 breeding. It did not produce good seed (lower,older branch), it is not a good female for breeding.  	F	0	0	0	2014 McGovern Breeding project.   Location=TBD.	0	0	W	Y	N	N	Y	2	2014-04-07	H	6	2	TBD	TBD
82AA3	208	A 9 year vigorous, well formed selection from McGoverns CSSE site.  This tree had about 20 male flowers on 1 branch that were used in 2014 crosses.	M	0	0	0	2014 McGovern Breeding project.   Location=CSSE	0	0	M	Y	N	N	N	-1	2014-04-07	A	3	139	TBD	TBD
ST11	209	A young, well formed, wild P. tremuloides located North of the Rockford Merrell parking lot.  It had excellent pollen shedding and mating characteristics.	M	0	0	0	2014 McGovern Breeding project.   Location=http://maps.google.com/?q=43.11552,-85.60007	0	0	M	Y	N	N	Y	2	2014-04-07	ASA	11	2	TBD	TBD
GG4	210	A young, well formed, wild P. grandidentata clone located SW of the Rockford Merrell parking lot.  It had many flowers and fair pollen shedding and mating characteristics.	M	0	0	G4	2014 McGovern Breeding project.   Location=http://maps.google.com/?q=43.111,-85.59949	0	0	M	N	N	N	Y	2	2014-04-07	ASA	10	2	TBD	TBD
GG5	211	A young, wild P. grandidentata clone located in North Central UP Michigan.  It had many flowers, poor mating characteristics and may have figured wood traits. 	F	0	0	G5	2014 McGovern Breeding project.   Location=TBD.	0	0	W	N	N	N	Y	2	2014-04-07	ASA	10	2	TBD	TBD
GG6	212	An old, wild P. grandidentata clone located in NC UP Michigan.  It had many flowers, fair mating characteristics and has some figured wood traits.  The tree had little to none at the butt, but some figure at 30 feet.  Not sure if it is same High figured clone as others in area.	M	0	0	G6	2014 McGovern Breeding project.   Location=TBD.	0	0	W	Y	N	N	Y	2	2014-04-07	ASA	10	2	TBD	TBD
4AE1	213	A fairly nice 2014 selection from McGoverns SLSE site.  Produced 10 2104 seedlings when mated with Plaza.  Not sure if the issue was this pollen or Plaza female.	M	0	0	0	2014 McGovern Breeding project.   Location=SLSE	0	0	W	N	N	N	N	-1	2014-04-07	H	9	97	TBD	TBD
4TG1	214	A vigorous, well formed 21 year selection from FBIC in 2014.  This is not a TG family, it is likely an alba hybrid type cross.  Will attempt to verify parentage.  	M	0	0	0	2014 McGovern Breeding project.   Location=TBD.	0	0	W	N	N	N	N	-1	2014-04-07	ASA	5	1	TBD	TBD
4AE2	215	A fairly nice 2014 selection from McGoverns SLSE site.  It failed to produce seed in 2104 seedlings when mated with AGRR1 and 9AG105.  Perhaps it is sterile or a triploid.	F	0	0	0	2014 McGovern Breeding project.   Location=SLSE	0	0	W	N	N	N	N	3	2014-04-07	H	9	97	TBD	TBD
GG7	216	A nice, wild P. grandidentata clone located in NC UP Michigan with figured wood traits.  It had a 6 inch DBH and imature male flowers that failed to produce pollen in 2014 breeding.  	M	0	0	G7	2014 McGovern Breeding project.   Location=TBD.	0	0	W	Y	N	N	Y	-1	2014-04-07	ASA	10	2	TBD	TBD
GG8	217	A nice, wild P. grandidentata clone located in NC UP Michigan in an area with figured wood traits.  Initially named E3 by Johns roadside bank.	U	0	0	0	2014 McGovern Breeding project.   Location=TBD.	0	0	W	Y	N	N	Y	-1	2014-04-07	ASA	10	2	TBD	TBD
GG9	218	A nice, wild P. grandidentata clone located in NC UP Michigan in an area with figured wood traits.  Initially named E4 located 21 paces North of Ees wood shed.	U	0	0	0	2014 McGovern Breeding project.   Location=TBD.	0	0	W	Y	N	N	Y	-1	2014-04-07	ASA	10	2	TBD	TBD
GG10	219	A nice, wild P. grandidentata clone located in NC UP Michigan in an area with figured wood traits.  Initially named E5 by Leagl house	U	0	0	0	2014 McGovern Breeding project.   Location=TBD.	0	0	W	Y	N	N	Y	-1	2014-04-07	ASA	10	2	TBD	TBD
GG12	220	A nice, wild P. Grandidentata ~40 year old tree near SE Grand Rapids.  It was highly figured with 10 mm deep, diagonal wavy grain.  The 16' butt log had most figure but whole tree also had significant figure.  Will propagate several nearby rooted suckers.	M	0	0	ARTM	2015 McGovern Breeding project.   Location=SE Grand Rapids	0	0	W	Y	N	N	Y	2	2015-12-31	ASA	10	2	TBD	https://drive.google.com/open?id=0B7-SwoTVeWFaLUFfaFJNdThQN1k
82AA4	221	A nice , well formed, vigorous P. alba selection at age 11 at the CSSE site.  It had poor seed viability when mated with GG12.  Next time try fertilizing flowers later (1 inch). 	F	0	0	0	2014 McGovern Breeding project.   Location=CSSE	0	0	W	Y	N	N	N	-1	2016-03-20	A	3	148	https://drive.google.com/open?id=0B7-SwoTVeWFaV2lsbXdkQkVRN0U	TBD
105AA3	222	105aa3~rankms=9_rankdc=8_reps=4_srate=0.9_class=A	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	A	3	2	TBD	TBD
105AA4	223	105aa4#rankms=109_rankdc=80_reps=2_srate=0.7_class=A	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	A	3	2	TBD	TBD
105AA5	224	105aa5#rankms=8_rankdc=9_reps=4_srate=1.0_class=A	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	A	3	2	TBD	TBD
106AA1	225	106aa1#rankms=6_rankdc=48_reps=2_srate=0.9_class=A	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	A	3	2	TBD	TBD
106AA3	226	106aa3#rankms=24_rankdc=101_reps=2_srate=0.5_class=A	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	A	3	2	TBD	TBD
106AA7	227	106aa7~rankms=-1_rankdc=2_reps=1_srate=1.0_class=A	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	A	3	2	TBD	TBD
106AA8	228	106aa8~rankms=-1_rankdc=2_reps=1_srate=1.0_class=A	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	A	3	2	TBD	TBD
107AA3	229	107aa3#rankms=33_rankdc=61_reps=1_srate=1.0_class=A	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	A	3	2	TBD	TBD
107AA7	230	107aa7#rankms=23_rankdc=42_reps=1_srate=1.0_class=A	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	A	3	2	TBD	TBD
11AB22	233	11ab22&rankms=28.5_rankdc=22.2_dcreps=3_dcsrate=0.79_archived=2_field_score=2.75	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	AH	19	2	TBD	TBD
11AB3	234	11ab3#rankms=25_rankdc=77_reps=2_srate=0.7_class=AH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	AH	19	2	TBD	TBD
13GB6	235	13gb6#rankms=40_rankdc=111_reps=2_srate=0.2_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASH	21	2	TBD	TBD
14B10	236	14b10~rankms=16.0_rankdc=16.0_dcreps=3_dcsrate=1.00_archived=2_field_score=1.52	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
14B11	237	14b11#rankms=85_rankdc=82_reps=2_srate=0.8_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
14B16	238	14b16~rankms=22.9_rankdc=8.3_dcreps=3_dcsrate=0.83_archived=1_field_score=2.20	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
14B17	239	14b17#rankms=45_rankdc=77_reps=2_srate=0.6_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
14B19	240	14b19#rankms=64_rankdc=100_reps=2_srate=0.5_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
14B21	241	14b21~rankms=25.0_rankdc=18.4_dcreps=3_dcsrate=0.86_archived=2_field_score=2.37	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
14B3	242	14b3#rankms=75_rankdc=82_reps=2_srate=0.8_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
14B30	243	14b30#rankms=103_rankdc=63_reps=1_srate=0.8_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
14B31	244	14b31~rankms=133_rankdc=7_reps=1_srate=1.0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
14B4	245	14b4#rankms=23_rankdc=89_reps=2_srate=0.5_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
14B40	246	14b40#0_0_0_0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
14B41	247	14b41#0_0_0_0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
14B6	248	14b6#rankms=105_rankdc=64_reps=1_srate=1.0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
14B7	249	14b7~rankms=21_rankdc=51_reps=2_srate=1.0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
15B11	250	15b11#rankms=51_rankdc=85_reps=2_srate=0.5_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
15B14	251	15b14#rankms=156_rankdc=129_reps=1_srate=0.0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
15B5	252	15b5#rankms=121_rankdc=38_reps=1_srate=1.0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
15B8	253	15b8#rankms=133_rankdc=27_reps=1_srate=1.0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
16AB1	254	16ab1~rankms=32.0_rankdc=14.3_dcreps=2_dcsrate=0.87_archived=2_field_score=4.80	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	AH	19	2	TBD	TBD
16AB8	255	16ab8~rankms=19.5_rankdc=25.6_dcreps=2_dcsrate=0.72_archived=3_field_score=5.17	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	AH	19	2	TBD	TBD
18BG17	256	18bg17#rankms=45_rankdc=77_reps=1_srate=0.8_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASH	22	2	TBD	TBD
18BG19	257	18bg19~rankms=76_rankdc=50_reps=1_srate=1.0_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASH	22	2	TBD	TBD
18BG2	258	18bg2~rankms=64_rankdc=46_reps=1_srate=1.0_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASH	22	2	TBD	TBD
18BG25	259	18bg25~rankms=115_rankdc=59_reps=2_srate=0.8_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASH	22	2	TBD	TBD
19GB1	260	19gb1#rankms=62_rankdc=105_reps=2_srate=0.3_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASH	21	2	TBD	TBD
19GB9	261	19gb9#rankms=29_rankdc=96_reps=2_srate=0.5_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASH	21	2	TBD	TBD
1BW6	262	1bw6~rankms=29.3_rankdc=18.7_dcreps=4_dcsrate=1.00_archived=4_field_score=5.74	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	AH	14	2	TBD	TBD
20BS1	263	20bs1~rankms=30.0_rankdc=31.0_dcreps=2_dcsrate=0.96_archived=3_field_score=5.87	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	AH	20	2	TBD	TBD
20BS5	264	20bs5#rankms=26_rankdc=29_reps=1_srate=1.0_class=AH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	AH	20	2	TBD	TBD
20BS6	265	20bs6#rankms=37_rankdc=51_reps=1_srate=1.0_class=AH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	AH	20	2	TBD	TBD
20BS8	266	20bs8#rankms=37_rankdc=56_reps=1_srate=0.6_class=AH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	AH	20	2	TBD	TBD
22BG1	267	22bg1~rankms=112_rankdc=57_reps=3_srate=0.8_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASH	22	2	TBD	TBD
22BG7	268	22bg7#rankms=30_rankdc=92_reps=2_srate=0.6_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASH	22	2	TBD	TBD
22BG8	269	22bg8#rankms=83_rankdc=80_reps=2_srate=0.6_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASH	22	2	TBD	TBD
23BA10	270	23ba10~rankms=20.0_rankdc=19.9_dcreps=3_dcsrate=0.92_archived=2_field_score=1.47	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	AH	20	2	TBD	TBD
23BA11	271	23ba11~rankms=10.6_rankdc=13.8_dcreps=4_dcsrate=0.86_archived=2_field_score=1.67	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	AH	20	2	TBD	TBD
23BA15	272	23ba15~rankms=17.7_rankdc=24.6_dcreps=2_dcsrate=0.96_archived=2_field_score=2.30	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	AH	20	199	TBD	TBD
23BA18	273	23ba18~rankms=10.5_rankdc=23.7_dcreps=2_dcsrate=0.92_archived=2_field_score=1.67	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	AH	20	2	TBD	TBD
23BA2	274	23ba2#rankms=64_rankdc=88_reps=1_srate=0.8_class=AH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	AH	20	2	TBD	TBD
23BA20	275	23ba20~0_0_0_0_class=AH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	AH	20	2	TBD	TBD
23BA21	276	23ba21~0_0_0_0_class=AH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	AH	20	2	TBD	TBD
23BA5	277	23ba5#rankms=60_rankdc=49_reps=1_srate=1.0_class=AH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	AH	20	2	TBD	TBD
2B21	278	2b21~rankms=42_rankdc=30_reps=3_srate=0.9_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B22	279	2b22#rankms=66_rankdc=42_reps=2_srate=0.9_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B24	280	2b24#rankms=71_rankdc=29_reps=2_srate=0.9_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B25	281	2b25~rankms=48.0_rankdc=8.8_dcreps=17_dcsrate=0.54_archived=6_field_score=6.07	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B29	282	2b29#rankms=47_rankdc=71_reps=3_srate=0.6_class=H	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B3	283	2b3~rankms=34_rankdc=19_reps=5_srate=0.9_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B4	284	2b4#rankms=50_rankdc=31_reps=3_srate=0.8_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B52	285	2b52~rankms=20_rankdc=15_reps=2_srate=1.0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B55	286	2b55~rankms=36_rankdc=20_reps=2_srate=1.0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B6	287	2b6~rankms=52_rankdc=13_reps=6_srate=0.9_class=H	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B62	288	2b62#rankms=12_rankdc=35_reps=2_srate=0.8_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B63	289	2b63#rankms=1_rankdc=92_reps=2_srate=0.5_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B66	290	2b66#rankms=113_rankdc=38_reps=1_srate=1.0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B67	291	2b67#rankms=35_rankdc=74_reps=2_srate=0.6_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B68	292	2b68#rankms=67_rankdc=34_reps=2_srate=0.9_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B7	293	2b7#rankms=110_rankdc=25_reps=2_srate=1.0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
2B71	294	2b71~rankms=27.0_rankdc=17.0_dcreps=4_dcsrate=0.95_archived=3_field_score=3.50	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	H	15	2	TBD	TBD
3BC1	295	3bc1~rankms=45_rankdc=18_reps=2_srate=1.0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	1	2	TBD	TBD
3BC3	296	3bc3~rankms=23.0_rankdc=23.1_dcreps=3_dcsrate=0.92_archived=3_field_score=5.12	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	H	1	2	TBD	TBD
3BC4	297	3bc4#rankms=39_rankdc=43_reps=2_srate=0.9_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	1	2	TBD	TBD
3BC5	298	3bc5~rankms=13.6_rankdc=22.2_dcreps=3_dcsrate=0.91_archived=1_field_score=1.55	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	H	1	2	TBD	TBD
4AB4	299	4ab4~rankms=23_rankdc=14_reps=2_srate=1.0_class=AH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	19	2	TBD	TBD
4AB9	300	4ab9#rankms=36_rankdc=54_reps=2_srate=0.9_class=AH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	19	2	TBD	TBD
4GW11	301	4gw11#rankms=14_rankdc=114_reps=1_srate=0.2_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	U	7	2	TBD	TBD
5BR3	302	5br3~rankms=35_rankdc=40_reps=2_srate=1.0_class=H	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	H	1	2	TBD	TBD
6BA2	303	6ba2#rankms=101_rankdc=37_reps=1_srate=1.0_class=AH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	AH	20	2	TBD	TBD
7BT1	304	7bt1~rankms=44_rankdc=25_reps=2_srate=0.9_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASA	1	2	TBD	TBD
7BT7	305	7bt7#rankms=31_rankdc=45_reps=1_srate=0.6_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	ASA	1	2	TBD	TBD
83AA70	306	83aa70#rankms=42_rankdc=70_reps=1_srate=0.8_class=A	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	A	3	2	TBD	TBD
89AA1	307	89aa1#rankms=83_rankdc=84_reps=1_srate=0.4_class=A	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	A	3	2	TBD	TBD
8BG2	308	8bg2~rankms=155_rankdc=60_reps=2_srate=0.9_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASH	22	2	TBD	TBD
8BG21	309	8bg21#rankms=133_rankdc=80_reps=1_srate=0.8_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASH	22	2	TBD	TBD
8BG3	310	8bg3~rankms=19.9_rankdc=23.8_dcreps=3_dcsrate=0.81_archived=2_field_score=2.47	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	ASH	22	2	TBD	TBD
8BG8	311	8bg8#rankms=60_rankdc=76_reps=2_srate=0.7_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	U	N	N	N	-1	2016-11-04	ASH	22	2	TBD	TBD
8BG9	312	8bg9~rankms=79_rankdc=50_reps=2_srate=0.7_class=ASH	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	ASH	22	2	TBD	TBD
TC72	313	tc72#rankms=51_rankdc=90_reps=2_srate=0.7_class=A	U	0	0	0	Phase 4 MBP	0	0	U	Y	N	N	N	-1	2016-11-04	A	3	2	TBD	TBD
YUGO1	314	This is one of 3 pollen samples sent in 1991.  It is from Dr. V. Guzina of the Poplar Research Institute.   They were collected from the riparian zone of the Danube River near Novi Sad.  Most pollen was bad due to the shipping delay.	M	0	0	0	Novi Sad, Yugoslavia	0	0	U	Y	N	N	Y	-1	1991-01-01	A	3	2	0	TBD
KOREANALBA	315	Pollen obtained from Suwon, S. Korea via Dr. Eui Rae Noh. They got it from Italy.	M	0	0	0	Suwon, South Korea	0	0	U	N	N	N	N	-1	1991-01-01	A	3	2	0	TBD
SHELBYBT	316	Bigtooth male located near Shelby MI	M	0	0	0	1991 McGovern Breeding project.   Location, probably near Shelby, MI	0	0	W	Y	N	N	Y	-1	1991-01-01	ASA	10	2	TBD	TBD
M1BT	317	Bigtooth male probably located off highway M1 near Detroit, Michigan	M	0	0	0	1991 McGovern Breeding project.   Location, probably near highway M1 near Detroit, MI	0	0	W	U	N	N	Y	-1	1991-01-01	ASA	10	2	TBD	TBD
BT6	318	Male wild Bigtooth growing on a sandy upland site.  Located near US131 and M82. Planted 6 suckers at HCRA in 1992.	M	0	0	0	NA	0	0	F	U	N	N	Y	-1	1992-01-01	ASA	10	2	TBD	TBD
AGM46	319	A vigorous, well formed, wild AG clone located on the North side of M46 25 miles west of M-27. 	M	0	0	0	NA	0	0	F	U	N	N	Y	-1	1992-01-01	H	6	2	TBD	TBD
TEVERE2	320	One of several pollen lots shipped from Itally in 1992.  The name is derived from the geographic selection area.	M	0	0	0	Italy, Tevere region	0	0	F	U	N	N	Y	-1	1992-01-01	A	3	2	TBD	TBD
TANARO	321	One of several pollen lots shipped from Itally in 1992.  The name is derived from the geographic selection area.	M	0	0	0	Italy, Tanaro region	0	0	F	U	N	N	Y	-1	1992-01-01	A	3	2	TBD	TBD
ARENAAG	322	Vigorous wild AG clone locatged in NE Grand Rapids East of the DeltaPlex  Arena.	F	0	0	0	NE Grand Rapids@ NE corner of Turner and West River Dr.	0	0	F	U	N	N	Y	-1	1990-01-01	H	6	2	TBD	TBD
KENTAG	323	Female AG located in Kent County, MI	F	0	0	0	Located in Kent County, MI	0	0	F	U	N	N	Y	-1	1990-01-01	H	6	2	TBD	TBD
POSTAG	324	Female AG located in North of Post Dr/US131 in Kent County, MI	F	0	0	0	located in North of Post Dr/US131 in Kent County, MI	0	0	F	U	N	N	Y	-1	1990-01-01	H	6	2	TBD	TBD
A316	325	Produced in Canada via mating A69 (Brampton Canada) x A473 (Germany).  It was considered to be a good rooter. It had poor form and fair vigor at RNE.	F	0	0	0	McGovern breeding project obtained this clone from Maple, Ontario Canada in 1989. 	0	0	W	N	N	N	N	-1	1989-01-01	A	3	2	TBD	TBD
25R10	326	25r10~rankms= -1_rankdc= 7_reps=1_srate=1.00, DOT0, R4, C8, WASP	U	0	0	0	Phase 4 MBP, 2017 Nursery and 2 year field selections	0	0	U	Y	N	N	N	-1	2017-12-01	H	16	121	TBD	TBD
25R4	327	25r4~rankms= -1_rankdc= 5_reps=1_srate=1.00, DOT0, R4, C9, WASP	U	0	0	0	Phase 4 MBP, 2017 Nursery and 2 year field selections	0	0	U	Y	N	N	N	-1	2017-12-01	H	16	121	TBD	TBD
25R22	328	25r22~Best 2017 25xr Double Selection. (1ms, 1 DC).  DC=8',MS=7', Yielded 13 Cuttings, WASP	U	0	0	0	Phase 4 MBP, 2017 Nursery and 2 year field selections	0	0	U	Y	N	N	N	-1	2017-12-01	H	16	121	TBD	TBD
25R23	329	25r23~2017 Double Selection. Planted 1 MS, 1 DC – Yielded 10 Cuttings. WASP	U	0	0	0	Phase 4 MBP, 2017 Nursery and 2 year field selections	0	0	U	Y	N	N	N	-1	2017-12-01	H	16	121	TBD	TBD
25R24	330	25r24~2017 Double Selection. Planted 1 MS, 1 DC – Yielded 7 Cuttings. WASP	U	0	0	0	Phase 4 MBP, 2017 Nursery and 2 year field selections	0	0	U	Y	N	N	N	-1	2017-12-01	H	16	121	TBD	TBD
25R25	331	25r25~2017 Double Selection. Planted 1 MS, 1 DC – Yielded 6 Cuttings. WASP	U	0	0	0	Phase 4 MBP, 2017 Nursery and 2 year field selections	0	0	U	Y	N	N	N	-1	2017-12-01	H	16	121	TBD	TBD
GROBER	332	Likely a P. Canescens clone found by Sam Grober in Maryland.  It is highly figured and noted in the paper: “Figured grain in aspen is heritable and not affected by graft-transmissible signals”. Was mated to A502 in 2005/2006.	M	0	0	Curly Poplar	Contract breeding work for Richard Meilan of Purdue University.  The tree was found by Sam Grober, perhaps in Maryland.	0	0	W	Y	Y	Y	Y	2	2012-02-20	AH	9	2	http://www.advancedtree.com/timber/timber-poplar-curly-history.aspx	https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&cad=rja&uact=8&ved=0ahUKEwjxtPypn8TYAhUDw4MKHR9oCKgQFggpMAA&url=https%3A%2F%2Fwww.fs.fed.us%2Fnrs%2Fpubs%2Fjrnl%2F2013%2Fnrs_2013_fan_001.pdf&usg=AOvVaw3QQGXf2d_OrPVS_lNQ6aLX
TA483	333	Tremula clone, TA483 is from Michigan DNR Tree Improvement Center	M	0	0	0	Michigan DNR Tree Improvement Center	0	0	M	U	Y	N	U	2	2004-03-01	ASO	12	2	0	TBD
SEITSMABT	334	Female is a bigtooth from Jerry Seitsmas Orchard (Knapp/8 in GR,MI)	F	0	0	G5	Female is a bigtooth from Jerry Seitsmas Orchard (Knapp/8 in GR,MI)	0	0	W	N	N	N	Y	2	1984-04-07	ASA	10	2	TBD	TBD
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
Bell-Nursery	3	BELLN	0	Pat McGovern's main nursery site	Grand Rapids, MI	0	0	900	0	sand	WD	34	48	170	1000	0	0	0	0
C-Nursery	4	CN	0	Temp 1 McGovern Nursery site	Grand Rapids, MI	0	0	900	0	sand	WD	34	48	170	1000	0	0	0	0
D-Nursery	5	DN	0	Temp 2 McGovern nursery site	Grand Rapids, MI	0	0	900	0	sand	ED	34	48	170	1000	0	0	0	0
Bell-Indoor	6	BELLI	0	Pat McGovern's Indoor Garden site	Grand Rapids, MI	0	0	900	0	0	U	-1	-1	-1	-1	0	0	0	0
RNE	7	RNE	0	Pat McGovern's RNE site.   Started P. alba 1992.	LP West Michigan	0	0	900	0	0	WD	0	0	0	-1	0	0	0	0
MB-Escanabaa	8	MF	0	MB Escanaba site	UP Michigan	0	0	0	0	0	U	-1	-1	-1	-1	0	0	0	0
PostNE-West	9	PNEW	0	Post NE – Planting starts on West edge	LP West Michigan	0	0	0	0	0	WD	-1	-1	-1	-1	0	0	0	0
CSNE	10	CSNE	0	Pat McGovern's CSNE site.   Started P. alba 1992.	LP West Michigan	0	0	0	0	clay	PD	-1	-1	-1	-1	0	0	0	0
Arthur-Nursery	11	ARTH	0	Pat McGovern's nursery site	Grand Rapids, MI	0	0	900	0	sand	WD	34	48	170	1000	0	0	0	0
Rlnder	12	RL1	0	Rlnder	RL, WI	0	0	0	0	0	U	0	0	0	0	0	0	0	0
Wyrdj5	13	WY1	0	Wyrdj5	Escanaba, MI	0	0	0	0	0	U	0	0	0	0	0	0	0	0
\.


--
-- Name: site_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('site_id_seq', 1, false);


--
-- Data for Name: split_wood_tests; Type: TABLE DATA; Schema: public; Owner: user
--

COPY split_wood_tests (swt_key, id, notes, notes2, cutting_order, stem_dia_small_end_mm, length_of_split_in, grain_pull_force_lb, undulation_level, gpf_test_set, replication_nbr, id_test_spec) FROM stdin;
TBD	1	To Be Determined	1	-1	-1	-1	-1	-1	N	-1	2
NA	2	Does Not Apply	2	-1	-1	-1	-1	-1	N	-1	2
2b29	3	0	08-27-17-gpft-2b29-Bell	1	14	3	13.3	-1	N	1	42
2b29	4	0	0	2	13	3	13.55	-1	N	1	42
2b29	5	0	0	3	12	3	7.55	-1	N	1	42
2b29	6	0	0	4	12	3	8	-1	N	1	42
2b29	7	0	0	5	11	3	7.3	-1	N	1	42
2b29	8	0	0	6	11	2	5.6	-1	N	1	42
2b29	9	0	0	7	10	2.5	6	-1	N	1	42
2b29	10	0	0	8	11	3	7.3	-1	N	1	42
2b29	11	0	0	9	10	3	4.5	-1	N	1	42
2b29	12	0	0	10	10	3	6.5	-1	N	1	42
2b29	13	0	0	11	10	3	4.5	-1	N	1	42
2b29	14	0	0	12	9	3	4.2	-1	N	1	42
agrr1	15	0	09-09-17-gpft-agrr1-RNE	1	17.1	3	20	1	N	1	43
agrr1	16	0	0	2	16.9	3	19.5	1	N	1	43
agrr1	17	0	0	3	16.3	3	19.15	1	N	1	43
agrr1	18	0	0	4	16.2	3	16.6	1	N	1	43
agrr1	19	0	0	5	15.8	3	18.85	1	N	1	43
agrr1	20	0	0	6	15.5	3	18.55	1	N	1	43
agrr1	21	0	0	7	15.4	3	16.5	1	N	1	43
agrr1	22	0	0	8	15.6	3	15.6	1	N	1	43
agrr1	23	0	0	9	14.3	3	15.15	1	N	1	43
agrr1	24	0	0	10	14	3	14.05	1	N	1	43
agrr1	25	0	0	11	14.6	3	12.2	1	N	1	43
agrr1	26	0	0	12	12.7	3	9.8	1	N	1	43
2b3	27	10-15-17-gpft-2b3-RNE	0	1	19.8	3	42.3	-1	N	1	44
2b3	28	0	0	2	18.4	3	33.8	-1	N	1	44
2b3	29	0	0	3	17.6	3	26.5	-1	N	1	44
2b3	30	0	0	4	16.4	3	20.6	-1	N	1	44
2b3	31	0	0	5	16	3	21.6	-1	N	1	44
2b3	32	0	0	6	15.5	3	20.6	-1	N	1	44
2b3	33	0	0	7	15.2	3	19.6	-1	N	1	44
2b3	34	0	0	8	14.8	3	-1	-1	N	1	44
2b3	35	0	0	9	14.8	3	13.9	-1	N	1	44
2b3	36	0	0	10	14.8	3	17.6	-1	N	1	44
2b3	37	0	0	11	14.6	3	10.3	-1	N	1	44
2b3	38	0	0	12	14.3	3	14.9	-1	N	1	44
2b3	39	0	0	13	13.7	3	17.3	-1	N	1	44
2b3	40	0	0	14	13.9	3	11.5	-1	N	1	44
2b3	41	0	0	15	14	3	14.2	-1	N	1	44
2b3	42	0	0	16	13.8	3	19.4	-1	N	1	44
2b3	43	0	0	17	13.1	3	14.6	-1	N	1	44
2b3	44	0	0	18	13.6	3	12.7	-1	N	1	44
2b3	45	0	0	19	22	3	10.5	-1	N	1	44
2b3	46	0	0	20	12	3	12.1	-1	N	1	44
2b3	47	0	0	21	12.3	2.8	6.6	-1	N	1	44
2b3	48	0	0	22	11.1	2.9	7.4	-1	N	1	44
2b3	49	0	0	23	11.2	2.5	8	-1	N	1	44
2b3	50	0	0	24	9.8	2.9	5.1	-1	N	1	44
2b3	51	0	0	25	9.9	3	3.6	-1	N	1	44
2b3	52	0	0	26	9.6	3	4	-1	N	1	44
2b3	53	0	0	27	8.6	3	4.5	-1	N	1	44
ae3	54	1-1 stock, uneven pith, no obvious figure, 1st 3 cuttings oblong. This is rep. 1.	0	1	12.7	3	12.9	1	Y	1	45
ae3	55	0	0	2	12.3	3	12.5	1	Y	1	45
ae3	56	0	0	3	11.7	3	10.45	1	Y	1	45
ae3	57	0	0	4	11	3	6.55	1	Y	1	45
ae3	58	2 yr old wood, near root collar	02-24-18-gpft-mix-Bell	1	12.9	3	15.8	1	Y	1	46
ae3	59	1yr old wood.	0	3	10.9	3	9.8	1	Y	1	46
18bg43	60	0	0	1	13.1	3	-1	1	N	1	46
1bw6	61	Post dr	0	1	13.9	3	11.9	1	Y	1	46
1bw6	62	Post dr	0	2	13.7	3	12	1	Y	1	46
23ba20	63	should retest, has long waves and twist	0	1	15.5	3	-1	0	N	1	46
25r5	64	First of 20 clones (25r1 – 25r20).	First of 20 clones (25r1 – 25r20).	1	15.4	3	21.75	2	Y	1	46
25r5	65	0	0	2	14.8	3	14.85	2	Y	1	46
25r5	66	0	0	3	14.4	3	15.7	2	Y	1	46
25r5	67	0	0	4	14	3	13.9	2	Y	1	46
agrr1	68	0	09-09-17-gpft-agrr1-Ortet	1	24.1	3	36.3	1	Y	1	43
agrr1	69	0	0	2	23	3	32.1	1	Y	1	43
agrr1	70	0	0	3	23.6	3	38.6	1	Y	1	43
agrr1	71	0	0	4	23	3	30.4	1	Y	1	43
agrr1	72	0	0	5	22.3	3	32.5	1	Y	1	43
agrr1	73	0	0	6	22.5	3	28.7	1	Y	1	43
agrr1	74	0	0	7	21.7	3	26	1	Y	1	43
agrr1	75	0	0	8	21.2	3	27.5	1	Y	1	43
agrr1	76	0	0	9	21.1	3	31.8	1	Y	1	43
agrr1	77	0	0	10	21.4	3	28.4	1	Y	1	43
agrr1	78	0	0	11	20.6	3	16.7	1	Y	1	43
agrr1	79	0	0	12	20.2	3	25.4	1	Y	1	43
agrr1	80	0	0	13	19.1	3	27.2	1	Y	1	43
agrr1	81	0	0	14	20.1	3	25.6	1	Y	1	43
agrr1	82	0	0	15	19.2	3	23.7	1	Y	1	43
agrr1	83	0	0	16	18.2	3	24.8	1	Y	1	43
agrr1	84	0	0	17	18.2	3	23.9	1	Y	1	43
agrr1	85	0	0	18	17.1	3	22.4	1	Y	1	43
agrr1	86	0	0	19	15.8	3	18.2	1	Y	1	43
agrr1	87	0	0	20	15.2	2.5	10.6	0	Y	1	43
agrr1	88	0	09-09-17-gpft-agrr1-Ortet	1	17.1	3	19.5	1	Y	2	43
agrr1	89	0	0	2	16.8	3	15.7	1	Y	2	43
agrr1	90	0	0	3	16.2	3	17.3	1	Y	2	43
agrr1	91	0	0	4	16.6	3	18	1	Y	2	43
agrr1	92	0	0	5	16.9	3	14.6	1	Y	2	43
agrr1	93	0	0	6	16	3	13.6	1	Y	2	43
agrr1	94	0	0	7	15.8	3	12.65	1	Y	2	43
agrr1	95	0	0	8	15.3	3	15	1	Y	2	43
agrr1	96	0	0	9	15.4	3	9.5	1	Y	2	43
agrr1	97	0	0	10	15.1	3	11.5	1	Y	2	43
agrr1	98	0	0	11	15.2	3	11.7	1	Y	2	43
agrr1	99	0	0	12	14.3	3	13.9	1	Y	2	43
agrr1	100	0	0	13	14.6	3	11.7	0	Y	2	43
agrr1	101	0	0	14	14	3	9.6	1	Y	2	43
agrr1	102	0	0	15	13.6	3	11.3	0	Y	2	43
agrr1	103	0	0	16	13.9	3	9.6	1	Y	2	43
agrr1	104	0	0	17	13.4	3	12.9	1	Y	2	43
agrr1	105	0	0	18	13.1	3	7.5	0	Y	2	43
agrr1	106	0	0	19	12.1	3	7.1	0	Y	2	43
agrr1	107	0	0	20	11.3	3	7.5	0	Y	2	43
agrr1	108	0	0	21	11.2	3	8	1	Y	2	43
agrr1	109	0	09-09-17-gpft-agrr1-Ortet	1	18.5	3	28.3	1	Y	3	43
agrr1	110	0	0	2	18.6	3	23.8	1	Y	3	43
agrr1	111	0	0	3	18.6	3	19.4	1	Y	3	43
agrr1	112	0	0	4	18.3	3	16.4	1	Y	3	43
agrr1	113	0	0	5	17.9	3	20.4	1	Y	3	43
agrr1	114	0	0	6	17.6	3	15.8	1	Y	3	43
agrr1	115	0	0	7	17.3	3	20.6	1	Y	3	43
agrr1	116	0	0	8	16.7	3	12.9	1	Y	3	43
2b3	117	0	03-01-18-gpft-2b3-Bell-whips	1	15.7	3	19.2	0	Y	1	45
2b3	118	0	0	2	15	3	14.2	0	Y	1	45
2b3	119	0	0	3	14.8	3	13.2	0	Y	1	45
2b3	120	0	0	4	14.5	3	14.4	0	Y	1	45
2b3	121	0	0	5	14.3	3	11.8	0	Y	1	45
2b3	122	0	0	6	14.1	3	10.9	1	Y	1	45
2b3	123	0	0	7	14.1	3	10.9	1	Y	1	45
2b3	124	0	0	8	13.3	3	9.7	1	Y	1	45
2b3	125	0	0	9	13.2	3	7.8	0	Y	1	45
2b3	126	0	0	10	12.7	3	8	0	Y	1	45
2b3	127	0	0	11	12.3	2.5	9.3	0	Y	1	45
2b3	128	0	0	12	12.3	3	6.9	0	Y	1	45
2b3	129	0	0	13	11.9	2.5	8.8	0	Y	1	45
2b3	130	0	0	14	11.4	3	8.4	0	Y	1	45
2b3	131	0	0	15	11.1	3	6.6	0	Y	1	45
2b3	132	0	0	16	10.7	3	8.1	1	Y	1	45
2b3	133	0	0	17	10.3	3	5.9	0	Y	1	45
2b3	134	0	0	18	10.2	3	7.3	0	Y	1	45
2b3	135	Did not blade split on 1-11.	03-01-18-gpft-2b3-Bell-whips	12	11.3	3	9	0	Y	2	45
2b3	136	0	0	13	10.8	3	7	0	Y	2	45
2b3	137	0	0	14	10.5	3	7.4	0	Y	2	45
2b3	138	0	0	15	10.2	3	7.4	0	Y	2	45
2b3	139	0	0	16	9.6	3	6	0	Y	2	45
2b3	140	0	03-01-18-gpft-2b3-Bell-whips,	1	12.8	3	14.1	0	Y	3	45
2b3	141	0	0	2	12.6	3	10	0	Y	3	45
2b3	142	0	0	3	12	3	10.9	0	Y	3	45
2b3	143	0	0	4	11.7	2.5	6.5	0	Y	3	45
2b3	144	0	0	5	11.5	3	6.9	0	Y	3	45
2b3	145	0	0	6	11.3	2.5	8	0	Y	3	45
2b3	146	0	0	7	10.7	3	5.9	0	Y	3	45
2b3	147	0	0	8	10.4	2.8	7.2	0	Y	3	45
2b3	148	0	0	9	10.5	2	6.3	0	Y	3	45
2b3	149	0	0	10	10.2	3	4.8	0	Y	3	45
2b3	150	0	0	11	9.8	3	4.5	0	Y	3	45
2b3	151	0	0	12	9.2	3	4.4	0	Y	3	45
2b3	152	0	0	13	9	3	3.9	0	Y	3	45
2b3	153	0	0	14	9.1	3	4.5	0	Y	3	45
3bc5	154	0	02-24-18-gpft-mix-Bell	1	15.8	3	19.4	0	Y	1	46
3bc5	155	0	0	2	15.6	3	20.5	0	Y	1	46
2b29	156	sampled on 3/18/18	0	1	14.3	3	13.1	0	Y	1	46
2b29	157	0	0	2	13.7	3	12.2	0	Y	1	46
2b30	158	0	0	3	13.7	2.5	8.2	0	Y	1	46
2b30	159	0	0	4	12.9	3	9.4	0	Y	1	46
2b31	160	0	0	5	12.8	3	12	1	Y	1	46
2b31	161	0	0	6	12.4	3	10.6	0	Y	1	46
2b32	162	0	0	7	11.9	3	9.5	1	Y	1	46
2b32	163	0	0	8	11.8	3	6.5	0	Y	1	46
2b33	164	0	0	9	11.3	1.5	4.4	0	Y	1	46
2b33	165	0	0	10	11.2	1.5	11.6	1	Y	1	46
2b34	166	0	0	11	10.9	1	9.1	0	Y	1	46
2b34	167	0	0	12	10.7	3	12.5	0	Y	1	46
105aa3	168	sampled on 3/18/18	0	1	15.9	3	12.5	0	Y	1	46
105aa3	169	0	0	2	13.7	3	7.9	0	Y	1	46
105aa3	170	0	0	3	13.2	3	9.1	0	Y	1	46
105aa3	171	0	0	4	12.9	3	10.8	0	Y	1	46
105aa3	172	0	0	5	12.3	3	9.5	0	Y	1	46
4ab4	173	sampled on 3/18/18	0	1	18.1	3	25.7	0	Y	1	46
4ab4	174	0	0	2	18.2	3	21.2	1	Y	1	46
4ab4	175	0	0	3	17.1	3	20.3	1	Y	1	46
4ab4	176	0	0	4	16.5	3	20.1	0	Y	1	46
25r1	177	0	0	1	20.3	3	26.9	1	Y	3	47
25r1	178	0	0	2	19.2	3	25.3	1	Y	3	47
25r10	179	0	0	1	20.3	3	30.2	1	Y	4	47
25r10	180	0	0	2	19.3	3	29.1	1	Y	4	47
25r10	181	0	0	3	14.5	2	11.7	1	Y	4	47
25r10	182	0	0	4	13.7	2	9.1	1	Y	4	47
25r11	183	fw?	0	1	14.1	3	16.5	2	Y	6	47
25r11	184	0	0	2	13.3	3	11	2	Y	6	47
25r12	185	0	0	1	13.6	3	16.1	2	Y	5	47
25r12	186	0	0	3	14.8	3	13.6	2	Y	5	47
25r12	187	0	0	2	14.5	3	-1	2	N	5	47
25r14	188	fw?	0	1	18.6	3	25.2	2	Y	2	47
25r14	189	fw?	0	2	17.7	3	22.6	2	Y	2	47
25r15	190	03-10-18-gpft-25xr-mix-Bell	0	1	13	3	9.3	1	Y	14	47
25r15	191	0	0	2	12.7	3	5.5	1	Y	14	47
25r16	192	0	0	1	16.2	3	14.5	0	Y	13	47
25r16	193	Split bud in 1/2	0	2	16	3	15.5	0	Y	13	47
25r19	194	0	03-05-18-gpft-25r1-20-Bell	1	23.6	3	43	0	Y	1	47
25r19	195	0	0	1	23.6	3	43	0	Y	1	47
25r19	196	0	0	2	22.6	3	35.2	0	Y	1	47
25r2	197	0	0	1	22	3	32.1	0	Y	8	47
25r2	198	0	0	2	20.5	3	28.7	0	Y	8	47
25r2	199	0	0	3	20	3	31.4	0	Y	8	47
25r20	200	0	0	1	14.6	3	11.4	2	Y	9	47
25r20	201	0	0	2	15.6	3	15.9	2	Y	9	47
25r22	202	0	0	1	17.7	3	16.4	1	Y	2	48
25r22	203	fw?	0	1	13	3	12.2	1	Y	2	48
25r23	204	High figure on 2 different clone whips.	03-10-18-gpft-25xr-mix-Bell	1	15.6	3	13.2	3	Y	1	48
25r23	205	High figure on 2 different clone whips.	0	1	16	3	12.8	3	Y	1	48
25r24	206	fw?	0	1	18.2	3	22	1	Y	3	48
25r24	207	fw?	0	2	16.7	3	19.1	1	Y	3	48
25r25	208	fw?	0	1	13.3	3	13.9	1	Y	4	48
25r36	209	0	0	1	19.2	3	-1	0	N	19	48
25r39	210	fw?	0	1	16.5	3	16.9	1	Y	5	48
25r4	211	0	0	1	15.6	3	15.9	0	Y	10	47
25r4	212	0	0	2	15.5	3	13.3	0	Y	10	47
25r40	213	0	0	2	13.3	3	-1	1	N	15	48
25r40	214	0	0	1	15.4	3	-1	1	N	15	48
25r59	215	fw?	0	1	13	3	-1	2	N	6	48
25r59	216	fw?	0	1	13.6	3	13.9	2	Y	6	48
25r60	217	fw?	0	1	19.5	3	29.4	2	Y	7	48
25r60	218	fw?	0	2	17.5	3	24.5	2	Y	7	48
25r61	219	fw? Split with pruners	0	1	13.8	3	-1	2	N	8	48
25r7	220	fw?	0	1	19.5	3	23	1	Y	7	47
25r7	221	fw?	0	2	19.5	3	23.8	1	Y	7	47
25r8	222	0	0	1	12.5	3	8.4	0	Y	11	47
25r8	223	0	0	2	12.2	3	8.5	0	Y	11	47
25r9	224	fw?	0	1	17.3	3	17.8	1	Y	12	47
25r9	225	fw?	0	2	17.3	3	18.7	1	Y	12	47
25r82	226	fw?	0	1	10.7	3	-1	2	N	16	48
25r80	227	0	0	1	14.5	3	-1	1	N	17	48
25r81	228	0	0	1	12.8	3	-1	1	N	18	48
25r21	229	0	0	1	20.9	3	34.8	1	Y	0	48
25r21	230	0	0	2	20.5	3	33.4	1	Y	1	48
a502	231	0	03-11-18-gpft-a502-RNE-3yr	1	23	3	35.5	0	Y	1	50
a502	232	0	0	2	23.3	3	33.5	0	Y	1	50
a502	233	0	0	3	22.3	3	35	0	Y	1	50
a502	234	0	0	4	22	3	31.7	0	Y	1	50
a502	235	0	03-11-18-gpft-a502-RNE-2yr	1	17.7	3	15.7	0	Y	1	51
a502	236	Split next to bud.	0	2	17.5	3	19.2	0	Y	1	51
a502	237	0	0	3	16.8	3	14.9	0	Y	1	51
a502	238	0	0	4	15.6	3	12.4	0	Y	1	51
a502	239	0	0	5	15.5	3	10	0	Y	1	51
a502	240	0	0	6	14.5	3	9.4	0	Y	1	51
a502	241	0	0	7	14.6	3	9.8	0	Y	1	51
a502	242	0	0	8	12.8	3	8.8	0	Y	1	51
a502	243	0	0	9	12.6	3	8.9	0	Y	1	51
\.


--
-- Name: split_wood_tests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('split_wood_tests_id_seq', 1, false);


--
-- Data for Name: taxa; Type: TABLE DATA; Schema: public; Owner: user
--

COPY taxa (taxa_key, id, notes, species, species_hybrid, common_name, binomial_name, kingdom, family, genus, web_photos, web_url) FROM stdin;
TBD	1	To Be Determined	0	NA	0	0	0	0	0	0	0
NA	2	Does Not Apply - See Taxa table for separate hybrid taxa definitions.	NA	0	0	0	0	0	0	0	0
A	3	Native to Europe, naturalized in some areas of USA.	P. alba Linnaeus	0	White Poplar	0	Plantae	Salicaceae	Populus	0	http://en.wikipedia.org/wiki/Populus_alba
GT	4	Occurs naturally, susceptible to BLD	0	P. grandidentata x P. tremuloides	A.k.a P. xbarnesii	P. x smithii Boivin	Plantae	Salicaceae	Populus	0	0
TG	5	Occurs naturally, susceptible to BLD	0	P. tremuloides x P. grandidentata	A.k.a P. xbarnesii	P. x smithii Boivin	Plantae	Salicaceae	Populus	0	0
AG	6	Occurs where P. alba females are present.	0	P. alba x P. grandidentata	AG or R	P. x rouleauiana Bovin	Plantae	Salicaceae	Populus	0	0
GA	7	Not common in the wild since most P. albas are females and P. grandidentata seed has more exacting requirements.	0	P. grandidentata x P. alba	GA or R	P. x rouleauiana Bovin	Plantae	Salicaceae	Populus	0	0
AT	8	Not as common in the wild as AG	0	P. alba x P. tremuloides	0	P. x heimburgeri Boivin	Plantae	Salicaceae	Populus	0	0
AE	9	A valuable cross - used by itself or with CAGs	0	P. alba x P. tremula	gray poplar	P. x canescens Smith	Plantae	Salicaceae	Populus	0	0
G	10	Native to NE USA.	P. grandidentata Michaux	0	Big Tooth aspen	0	Plantae	Salicaceae	Populus	0	http://en.wikipedia.org/wiki/Populus_grandidentata
T	11	Native to Northern North America	P. tremuloides Michaux	0	Small Tooth aspen	0	Plantae	Salicaceae	Populus	0	http://en.wikipedia.org/wiki/Populus_tremuloides
E	12	Native to Europe	P. tremula Linnaeus	0	European Aspen	0	Plantae	Salicaceae	Populus	0	http://en.wikipedia.org/wiki/Populus_tremula
CAG	13	Deprecated – See B	0	(P. alba x P. grandidentata) x P. canescens	CAG or B	0	Plantae	Salicaceae	Populus	0	0
BW	14	Describes an open pollinated (Wind) CAG cross.  They may have potential for interesting recombinations.	0	(P. canescens x (P. alba x P. grandidentata)) x OP (Wind)	CAGW or BW	0	Plantae	Salicaceae	Populus	0	0
B	15	Alternate name for CAG crosses for brevity.  A double hybrid cross pioneered by the Canadians and known for diversity with some good rooting individuals despite poor rooting parents.	0	(P. x rouleauiana x P. canescens)	CAG or B	0	Plantae	Salicaceae	Populus	0	0
R	16	Alternate name for AG/GA crosses (P. xrouleauiana) for brevity.	0	P. alba x P. grandidentata (and reciprocal)	AG or GA or R	P. x rouleauiana Bovin	Plantae	Salicaceae	Populus	0	0
S	17	Alternate name for the TG/GT smithii (P. xsmithii Boivin) crosses for brevity 	0	P. tremuloides x P. grandidentata (and reciprocal)	TG or GT	P. x smithii Boivin	Plantae	Salicaceae	Populus	0	0
W	18	W stands for Wind pollinated. Therefore the exact male parent is unknown.	Wind Pollinated	0	Open Pollinated	NA	NA	NA	NA	0	0
AB	19	Describes a P alba x CAG back cross. They may have potential for interesting recombinations.	0	P. alba x (P. canescens x (P. alba x P. Grandidentata))	AB	NA	NA	NA	NA	0	0
BA	20	Describes a CAG x P alba back cross. They may have potential for interesting recombinations.	0	(P. canescens x (P. alba x P. Grandidentata)) x P. Alba	BA	NA	NA	NA	NA	0	0
GB	21	Describes a G x CAG back cross. They may have potential for interesting recombinations.	0	P. grandidentata x (P. canescens x (P. alba x P. Grandidentata))	GB	NA	NA	NA	NA	0	0
BG	22	Describes a B x CAG back cross. They may have potential for interesting recombinations.	0	(P. canescens x (P. alba x P. Grandidentata)) x P. Grandidentata	BG	NA	NA	NA	NA	0	0
EG	23	E x G	0	P. tremula x P. grandidentata 	EG	NA	Plantae	Salicaceae	Populus	0	0
GE	24	G x E. Interesting cross.  Some trees having nice form.	0	P. grandidentata x P. Tremula	GE	NA	Plantae	Salicaceae	Populus	0	0
EA	25	E x A	0	P. tremula x P. alba	gray poplar	P. xcanescens Smith	Plantae	Salicaceae	Populus	0	0
AR	26	A x R	0	P. alba x P. Xrouleauiana	NA	NA	Plantae	Salicaceae	Populus	0	0
RA	27	R x A	0	P. x rouleauiana x P. Alba	NA	NA	Plantae	Salicaceae	Populus	0	0
RG	28	R x G	0	P. x rouleauiana x P. Grandidentata	NA	NA	Plantae	Salicaceae	Populus	0	0
AC	29	A x C	0	P. alba x P. canescens	NA	NA	Plantae	Salicaceae	Populus	0	0
RC	30	R x C	0	P. x rouleauiana x P. Canescens	NA	NA	Plantae	Salicaceae	Populus	0	0
RE	31	R x E	0	P. x rouleauiana x P. Tremula	NA	NA	Plantae	Salicaceae	Populus	0	0
TE	32	T x E	0	P. tremuloides x P. tremula	TE	P. * wettsteinii 	Plantae	Salicaceae	Populus	0	0
AW	33	A x W	0	P. alba x OP (Wind)	NA	NA	Plantae	Salicaceae	Populus	0	0
GW	34	G x W	0	P. grandidentata x OP (Wind)	NA	NA	Plantae	Salicaceae	Populus	0	0
RR	35	R x R	0	P. x rouleauiana x P. X rouleauiana	NA	NA	Plantae	Salicaceae	Populus	0	0
BC	36	B x C	0	(P. x rouleauiana x P. canescens) x P. canescens	NA	NA	Plantae	Salicaceae	Populus	0	0
BR	37	B x R	0	(P. x rouleauiana x P. canescens) x P. X rouleauiana	NA	NA	Plantae	Salicaceae	Populus	0	0
RB	38	R x B	0	P. x rouleauiana x (P. xrouleauiana x P. canescens)	NA	NA	Plantae	Salicaceae	Populus	0	0
BAR	39	B x (A x R)	0	(P. xrouleauiana x P. canescens) x P. X rouleauiana 	NA	NA	Plantae	Salicaceae	Populus	0	0
ARW	40	(A x R) x W	0	(P. alba x P. X rouleauiana) x OP (Wind)	NA	NA	Plantae	Salicaceae	Populus	0	0
BT	41	B x T	0	(P. alba x P. X rouleauiana) x P. Tremuloides	NA	NA	Plantae	Salicaceae	Populus	0	0
ARA	42	(A x R) x A	0	(P. alba x P. X rouleauiana) x P. Alba	NA	NA	Plantae	Salicaceae	Populus	0	0
\.


--
-- Name: taxa_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('taxa_id_seq', 1, false);


--
-- Data for Name: test_detail; Type: TABLE DATA; Schema: public; Owner: user
--

COPY test_detail (test_detail_key, id, notes, notes2, notes3, planted_order, selection_type, start_quantity, end_quantity, this_start_date, score_date, stock_type, stock_length_cm, stock_dia_mm, is_plus_ynu, collar_median_dia_mm, collar_1_1_median_dia, stool_collar_median_dia_mm, field_cuttings_ft, height_cm, leaf_score, id_test_spec, row_nbr, column_nbr, replication_nbr, plot_nbr, block_nbr) FROM stdin;
TBD	-1	Dummy record used for id_prev_test_detail null values	1	0	-1	U	-1	-1	1111-11-11	1111-11-11	U     	-1	-1	0	-1	-1	-1	-1	-1	-1	2	-1	-1	-1	-1	-1
TBD	1	To Be Determined	1	0	-1	U	-1	-1	1111-11-11	1111-11-11	U     	-1	-1	0	-1	-1	-1	-1	-1	-1	2	-1	-1	-1	-1	-1
NA	2	Does Not Apply	2	0	-1	U	-1	-1	1111-11-11	1111-11-11	U     	-1	-1	0	-1	-1	-1	-1	-1	-1	2	-1	-1	-1	-1	-1
crandon	3	1989 6” dormant cutting test, Control - no shade cloth, no rooting hormone, .5” to 5/8 dia. 	0	0	0	U	20	5	1989-05-06	1989-11-01	DC    	15	13	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
crandon	4	1989 6” dormant cutting test, Shade cloth only.	0	0	0	U	20	3	1989-05-06	1989-11-01	DC    	15	10	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
crandon	5	1989 6” dormant cutting test, Shade cloth, #30 Hormex rooting hormone (3% IBA). Small dia cuttings.	0	0	0	U	27	2	1989-05-06	1989-11-01	DC    	15	8	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
crandon	6	1989 6” dormant cutting test, Shade cloth, #30 Hormex rooting hormone (3% IBA). Large dia cuttings.	0	0	0	U	24	5	1989-05-06	1989-11-01	DC    	15	16	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
crandon	7	1989 4” dormant cutting test, Control – with cloth, no rooting hormone, 10mm dia. 	0	0	0	U	20	0	1989-05-06	1989-11-01	DC    	10	10	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
crandon	8	1989 4” dormant cutting test, Shade cloth,  #30 Hormex rooting hormone (3% IBA). Med. dia cuttings.	0	0	0	U	58	6	1989-05-06	1989-11-01	DC    	10	13	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
crandon	9	1989 4” dormant cutting test, Shade cloth,  #30 Hormex rooting hormone (3% IBA). LG. dia cuttings.	0	0	0	U	42	8	1989-05-06	1989-11-01	DC    	10	16	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
prince	10	1989 4” dormant cutting test,  Dipped in #30 Hormex rooting hormone (3% IBA).	0	0	0	U	54	12	1989-05-06	1989-11-01	DC    	10	13	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
alger	11	1989 4” dormant cutting test,  Dipped in #30 Hormex rooting hormone (3% IBA).	0	0	0	U	31	17	1989-05-06	1989-11-01	DC    	10	9	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
jamie	12	1989 4” dormant cutting test,  Dipped in #30 Hormex rooting hormone (3% IBA).	0	0	0	U	58	1	1989-05-06	1989-11-01	DC    	10	9	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
agmorin	13	1989 4” dormant cutting test,  Dipped in #30 Hormex rooting hormone (3% IBA).	0	0	0	U	55	6	1989-05-06	1989-11-01	DC    	10	13	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
cag204	14	1989 8” dormant cutting test,  Shade cloth,Dipped in 30 Hormex rooting hormone (3% IBA).	0	0	0	U	28	17	1989-05-06	1989-11-01	DC    	20	11	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
cag177	15	1989 8” dormant cutting test,  Shade cloth,Dipped in 30 Hormex rooting hormone (3% IBA).	0	0	0	U	29	15	1989-05-06	1989-11-01	DC    	20	14	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
ae42	16	1989 8” dormant cutting test,  Shade cloth,Dipped in 30 Hormex rooting hormone (3% IBA).	0	0	0	U	30	10	1989-05-06	1989-11-01	DC    	20	11	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
a502	17	1989 8” dormant cutting test,  Shade cloth,Dipped in 30 Hormex rooting hormone (3% IBA).	0	0	0	U	20	9	1989-05-06	1989-11-01	DC    	20	17	U	-1	-1	-1	-1	-1	-1	32	-1	-1	-1	-1	-1
a73	18	1995 8” dormant cutting rooting test.  Cutting dipped in 30 Hormex rootng hormone (3% IBA).	0	0	0	U	52	23	1995-05-01	1995-11-01	DC    	20	-1	U	-1	-1	-1	-1	-1	-1	34	-1	-1	-1	-1	-1
aa510	19	1990 8” dormant cutting test,  Dipped in 30 Hormex rooting hormone (3% IBA).	0	0	0	U	6	3	1990-04-21	1990-09-18	DC    	20	-1	U	-1	-1	-1	-1	-1	-1	33	-1	-1	-1	-1	-1
cag204	20	1990. Shipped from Maple, Ontario on 3/5/90. Large diameter cuttings over .5” and 10” long.  Cut back to 7”. Most cuttings had root bumps. Dipped in 30 Hormex rooting hormone (3% IBA).	0	0	0	U	30	8	1990-04-21	1990-09-18	DC    	18	14	U	-1	-1	-1	-1	-1	-1	33	-1	-1	-1	-1	-1
ae42	21	1990. Shipped from Maple, Ontario on 3/5/90. Large diameter cuttings over .5” and 10” long.  Cut back to 7”. Most cuttings had root bumps. Dipped in 30 Hormex rooting hormone (3% IBA).	0	0	0	U	30	14	1990-04-21	1990-09-18	DC    	18	14	U	-1	-1	-1	-1	-1	-1	33	-1	-1	-1	-1	-1
a502	22	1990. Shipped from Maple, Ontario on 3/5/90. Large diameter cuttings over .5” and 10” long.  Cut back to 7”. Most cuttings had root bumps. Dipped in 30 Hormex rooting hormone (3% IBA).	0	0	0	U	30	4	1990-04-21	1990-09-18	DC    	18	14	U	-1	-1	-1	-1	-1	-1	33	-1	-1	-1	-1	-1
cag177	23	1990. Shipped from Maple, Ontario on 3/5/90. Large diameter cuttings over .5” and 10” long.  Cut back to 7”. Most cuttings had root bumps. Dipped in 30 Hormex rooting hormone (3% IBA).	0	0	0	U	30	16	1990-04-21	1990-09-18	DC    	18	14	U	-1	-1	-1	-1	-1	-1	33	-1	-1	-1	-1	-1
godfrey	24	2/1/18 late entry: Similar to Bolleana. Seems to be pure alba. Perhaps a bit wider. Vigorous, healthy, no bld in 1992. Light flowering, pollinate early. Rooting: 1992=65% 17/26 8" cuttings.	0	0	0	U	26	17	1992-04-01	1992-11-01	DC    	20	-1	U	-1	-1	-1	-1	-1	-1	35	-1	-1	-1	-1	-1
aa2101	25	2/1/18 late entry: Selected in nursery for vigor in 1992. Flowered @ age 4. Very narrow fastigate tree that is suseptible to BLD, short lived. Ortet rooted 100% but was dissapointing since. Rooting: 1992=100%, 2003=38% (20/53), 2004=32% (19/60). 	0	0	0	U	53	20	2003-04-01	2003-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	36	-1	-1	-1	-1	-1
aa2101	26	2/1/18 late entry: Selected in nursery for vigor in 1992. Flowered @ age 4. Very narrow fastigate tree that is suseptible to BLD, short lived. Ortet rooted 100% but was dissapointing since. Rooting: 1992=100%, 2003=38% (20/53), 2004=32% (19/60).	0	0	0	U	60	19	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
aa4101	27	2/1/18 late entry: Excellent form and vigor. Some BLD. Seems to have aspen branching features. 37" circ, 11.8" diameter on 12/26/04. BLD score: 8/28/01=1 Rooting: 2004=0% (0/40)	0	0	0	U	40	0	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
aa4102	28	2/1/18 late entry: Excellent form and vigor. Form is better than aa4101. Seems to have aspen branching features. 37" circ, 11.8" diameter on 12/26/04. BLD score: 8/28/01=0 Rooting: 2004=10% (4/40)	0	0	0	U	40	4	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
dn34	29	2/1/18 late entry: Used as a control clone. Has a reputation for good, stable performance even on dry sites. Rooting 6" cuttings: 2004=86% (153/178).	0	0	0	U	178	153	2004-04-01	2004-11-01	DC    	15	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
aa3201	30	2/1/18 late entry: A vigorous tree, fair to poor form. Rooting: 2004=0% (0/20)	0	0	0	U	20	0	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
aa901	31	2/1/18 late entry, P2 parent, estimated 20 cuttings.: Vigorous tree with fairly good form. Has a slight East lean. Flowering: Sparse, heavy bracts, can't see stigmas, fertilize at 1/2" flower length. 33" circ, 10.5" diameter on 12/26/03. Rooting: 2004=0%.	0	0	0	U	20	0	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
aa2301	32	2/1/18 late entry, P2 parent, estimated 20 cuttings: Huge, vigorous poorly formed tree. 2 sides biased. Collected root/shoots in 2004. 37" circ, 11.8" diameter on 12/26/03. Rooting: 2004=0%	0	0	0	U	20	0	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
aa3001	33	2/1/18 late entry, P2 parent: One of 3 trees planted at SLSE. This is the most vigorous. Diameter was 10.8" on 12/26/03.Has poor form. BLD: 2003=1, 2004=0. Flowering: must fertilize early, at 1/2" Rooting: 2004=10% (4/40)	0	0	0	U	40	4	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa4	34	Selected after 2yr. Root test. Branchy. Rooting: 2003=100% (Yellow), 2004=90% 9/10	0	0	0	U	10	9	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa5	35	Selected after 2yr. Root test. Not Branchy. Rooting: 2003=100% (Yellow), 2004=80% 8/10	0	0	0	U	10	8	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa6	36	Selected after 2yr. Root test. Vigorous, not Branchy. Rooting: 2003=100% (Yellow), 2004=90% 9/10	0	0	0	U	10	9	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa7	37	Selected after 2yr. Root test. Vigorous, not Branchy. Rooting: 2003=100% (Yellow), 2004=60% 6/10	0	0	0	U	10	6	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa8	38	Selected after 2yr. Root test. OK growth. Rooting: 2003=100% (Yellow), 2004=70% 7/10	0	0	0	U	10	7	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa9	39	Selected after 2yr. Root test. Vigorous, not Branchy. Rooting: 2003=100% (Yellow), 2004=100% 10/10	0	0	0	U	10	10	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa1	40	Selected after 2yr. Root test. Varied Growth. Rooting: 2003=100% (Red), 2004=70% 21/30	0	0	0	U	30	21	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa2	41	Selected after 2yr. Root test. Varied Growth. Rooting: 2003=100% (Red), 2004=90% 27/30, 2005 PIP1=81% 17/21	0	0	0	U	21	17	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa3	42	Selected after 2yr. Root test. Varied Growth. Rooting: 2003=100% (Red), 2004=70% 21/30	0	0	0	U	30	21	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa10	43	Selected after 2yr. Root test. Tall 4-6'. Rooting: 2003=80% (Black), 2004=100% 10/10	0	0	0	U	10	10	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa11	44	Selected after 2yr. Root test. OK growth. Rooting: 2003=80% (Black), 2004=70% 7/10	0	0	0	U	10	7	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa12	45	Selected after 2yr. Root test. OK growth. Rooting: 2003=80% (Black), 2004=100% 10/10	0	0	0	U	10	10	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa13	46	Selected after 2yr. Root test. Variable growth. Rooting: 2003=80% (Black), 2004=80% 8/10	0	0	0	U	10	8	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa14	47	Selected after 2yr. Root test. Nice growth 3-4'. Rooting: 2003=80% (Black), 2004=100% 10/10	0	0	0	U	10	10	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa15	48	Selected after 2yr. Root test. OK growth. Rooting: 2003=80% (Black), 2004=90% 9/10	0	0	0	U	10	9	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa16	49	Selected after 2yr. Root test. OK growth. Rooting: 2003=100% (Yellow), 2004=90% 9/10	0	0	0	U	10	9	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa17	50	Selected after 2yr. Root test. Nice 4-5'. Rooting: 2003=100% (Yellow), 2004=90% 9/10	0	0	0	U	10	9	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa18	51	Selected after 2yr. Root test. Best competetive growth! 4-5'. Rooting: 2003=100% (Yellow), 2004=80% 8/10	0	0	0	U	10	8	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
76aa19	52	Selected after 2yr. Root test. Good growth. Rooting: 2003=100% (Yellow), 2004=90% 9/10	0	0	0	U	10	9	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
77aa1	53	Selected after 2yr. Root test. OK growth 2-3'. Rooting: 2003=100% (Red), 2004=83% 25/30	0	0	0	U	30	25	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
77aa2	54	Selected after 2yr. Root test. OK growth 2-3'. Rooting: 2003=100% (Red), 2004=80% 32/40	0	0	0	U	40	32	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
77aa9	55	Selected after 2yr. Root test. OK branchy. Rooting: 2003=80% (Black), 2004=80% 8/10	0	0	0	U	10	8	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
77aa8	56	Selected after 2yr. Root test. Good growth 4-6'.. Rooting: 2003=80% (Black), 2004=100% 10/10	0	0	0	U	10	10	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
77aa3	57	Selected after 2yr. Root test. OK growth. . Rooting: 2003=100% (Yellow), 2004=60% 6/10	0	0	0	U	10	6	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
77aa4	58	Selected after 2yr. Root test. OK growth. . Rooting: 2003=100% (Yellow), 2004=100% 10/10	0	0	0	U	10	10	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
77aa5	59	Selected after 2yr. Root test. Nice, 4-5' growth. . Rooting: 2003=100% (Yellow), 2004=100% 10/10	0	0	0	U	10	10	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
77aa6	60	Selected after 2yr. Root test. OK growth, branchy. Rooting: 2003=100% (Yellow), 2004=100% 10/10	0	0	0	U	10	10	2004-04-01	2004-11-01	DC    	10	-1	U	-1	-1	-1	-1	-1	-1	37	-1	-1	-1	-1	-1
85xaa04	61	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	1	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	50	-1	39	-1	1	1	1	-1
85xaa04	62	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	2	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	55	-1	39	-1	2	1	-1	-1
85xaa04	63	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	3	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	25	-1	39	-1	3	1	-1	-1
85xaa04	64	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	4	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	80	-1	39	-1	4	1	-1	-1
85xaa04	65	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	5	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	30	-1	39	-1	5	1	-1	-1
85xaa04	66	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	6	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	45	-1	39	-1	6	1	-1	-1
85xaa04	67	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	7	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	30	-1	39	-1	7	1	-1	-1
85xaa04	68	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	8	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	45	-1	39	-1	8	1	-1	-1
85xaa04	69	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	9	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	80	-1	39	-1	9	1	-1	-1
85xaa04	70	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	10	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	50	-1	39	-1	10	1	-1	-1
85xaa04	71	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	11	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	50	-1	39	-1	11	1	-1	-1
85xaa04	72	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	12	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	40	-1	39	-1	12	1	-1	-1
85xaa04	73	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	13	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	45	-1	39	-1	13	1	-1	-1
85xaa04	74	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	14	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	45	-1	39	-1	14	1	-1	-1
85xaa04	75	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	15	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	60	-1	39	-1	15	1	-1	-1
85xaa04	76	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	16	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	40	-1	39	-1	16	1	-1	-1
85xaa04	77	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	17	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	45	-1	39	-1	17	1	-1	-1
85xaa04	78	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	18	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	45	-1	39	-1	18	1	-1	-1
85xaa04	79	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	19	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	75	-1	39	-1	19	1	-1	-1
85xaa04	80	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	20	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	20	1	-1	-1
85xaa04	81	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	21	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	21	1	-1	-1
85xaa04	82	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	22	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	22	1	-1	-1
81xaa04	83	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	23	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	95	-1	39	-1	1	2	1	-1
81xaa04	84	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	24	U	1	1	2004-06-01	2004-11-21	SEL   	-1	9	U	-1	-1	-1	-1	135	-1	39	-1	2	2	-1	-1
81xaa04	85	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	25	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	100	-1	39	-1	3	2	-1	-1
81xaa04	86	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	26	U	1	1	2004-06-01	2004-11-21	SEL   	-1	9	U	-1	-1	-1	-1	110	-1	39	-1	4	2	-1	-1
81xaa04	87	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	27	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	80	-1	39	-1	5	2	-1	-1
81xaa04	88	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	28	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	85	-1	39	-1	6	2	-1	-1
81xaa04	89	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	29	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	90	-1	39	-1	7	2	-1	-1
81xaa04	90	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	30	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	70	-1	39	-1	8	2	-1	-1
81xaa04	91	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	31	U	1	1	2004-06-01	2004-11-21	SEL   	-1	10	U	-1	-1	-1	-1	125	-1	39	-1	9	2	-1	-1
81xaa04	92	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	32	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	90	-1	39	-1	10	2	-1	-1
81xaa04	93	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	33	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	90	-1	39	-1	11	2	-1	-1
81xaa04	94	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	34	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	80	-1	39	-1	12	2	-1	-1
81xaa04	95	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	35	U	1	1	2004-06-01	2004-11-21	SEL   	-1	10	U	-1	-1	-1	-1	115	-1	39	-1	13	2	-1	-1
81xaa04	96	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	36	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	95	-1	39	-1	14	2	-1	-1
81xaa04	97	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	37	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	40	-1	39	-1	15	2	-1	-1
81xaa04	98	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	38	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	60	-1	39	-1	16	2	-1	-1
83aa101	314	0	0	0	0	U	1	1	2010-03-25	2010-11-01	1-0   	10	-1	U	-1	-1	-1	-1	251.5	-1	7	-1	2	-1	-1	-1
81xaa04	99	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	39	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	95	-1	39	-1	17	2	-1	-1
81xaa04	100	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	40	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	85	-1	39	-1	18	2	-1	-1
81xaa04	101	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	41	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	19	2	-1	-1
81xaa04	102	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	42	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	20	2	-1	-1
81xaa04	103	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	43	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	21	2	-1	-1
81xaa04	104	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	44	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	22	2	-1	-1
17xga04	105	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	45	U	1	1	2004-06-01	2004-11-21	SEL   	-1	2	U	-1	-1	-1	-1	20	-1	39	-1	1	3	1	-1
17xga04	106	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	46	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	45	-1	39	-1	2	3	-1	-1
17xga04	107	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	47	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	85	-1	39	-1	3	3	-1	-1
17xga04	108	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	48	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	100	-1	39	-1	4	3	-1	-1
17xga04	109	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	49	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	80	-1	39	-1	5	3	-1	-1
17xga04	110	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	50	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	30	-1	39	-1	6	3	-1	-1
17xga04	111	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	51	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	55	-1	39	-1	7	3	-1	-1
17xga04	112	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	52	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	90	-1	39	-1	8	3	-1	-1
17xga04	113	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	53	U	1	1	2004-06-01	2004-11-21	SEL   	-1	2	U	-1	-1	-1	-1	25	-1	39	-1	9	3	-1	-1
17xga04	114	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	54	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	45	-1	39	-1	10	3	-1	-1
17xga04	115	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	55	U	1	1	2004-06-01	2004-11-21	SEL   	-1	9	U	-1	-1	-1	-1	115	-1	39	-1	11	3	-1	-1
17xga04	116	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	56	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	80	-1	39	-1	12	3	-1	-1
17xga04	117	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	57	U	1	1	2004-06-01	2004-11-21	SEL   	-1	10	U	-1	-1	-1	-1	135	-1	39	-1	13	3	-1	-1
17xga04	118	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	58	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	45	-1	39	-1	14	3	-1	-1
17xga04	119	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	59	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	15	3	-1	-1
17xga04	120	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	60	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	16	3	-1	-1
17xga04	121	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	61	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	17	3	-1	-1
17xga04	122	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	62	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	18	3	-1	-1
17xga04	123	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	63	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	19	3	-1	-1
17xga04	124	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	64	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	20	3	-1	-1
17xga04	125	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	65	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	21	3	-1	-1
17xga04	126	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	66	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	22	3	-1	-1
1xte04	127	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	67	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	100	-1	39	-1	1	4	1	-1
1xte04	128	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	68	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	100	-1	39	-1	2	4	-1	-1
1xte04	129	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	69	U	1	1	2004-06-01	2004-11-21	SEL   	-1	9	U	-1	-1	-1	-1	145	-1	39	-1	3	4	-1	-1
1xte04	130	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	70	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	100	-1	39	-1	4	4	-1	-1
1xte04	131	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	71	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	115	-1	39	-1	5	4	-1	-1
1xte04	132	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	72	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	100	-1	39	-1	6	4	-1	-1
1xte04	133	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	73	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	85	-1	39	-1	7	4	-1	-1
1xte04	134	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	74	U	1	1	2004-06-01	2004-11-21	SEL   	-1	9	U	-1	-1	-1	-1	130	-1	39	-1	8	4	-1	-1
1xte04	135	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	75	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	9	4	-1	-1
1xte04	136	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	76	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	10	4	-1	-1
1xte04	137	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	77	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	11	4	-1	-1
1xte04	138	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	78	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	12	4	-1	-1
1xte04	139	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	79	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	13	4	-1	-1
1xte04	140	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	80	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	14	4	-1	-1
1xte04	141	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	81	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	15	4	-1	-1
1xte04	142	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	82	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	16	4	-1	-1
1xte04	143	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	83	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	17	4	-1	-1
1xte04	144	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	84	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	18	4	-1	-1
1xte04	145	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	85	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	19	4	-1	-1
1xte04	146	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	86	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	20	4	-1	-1
1xte04	147	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	87	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	21	4	-1	-1
1xte04	148	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	88	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	22	4	-1	-1
18xag04	149	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	89	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	45	-1	39	-1	1	5	1	-1
18xag04	150	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	90	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	55	-1	39	-1	2	5	-1	-1
18xag04	151	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	91	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	60	-1	39	-1	3	5	-1	-1
18xag04	152	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	92	U	1	1	2004-06-01	2004-11-21	SEL   	-1	9	U	-1	-1	-1	-1	120	-1	39	-1	4	5	-1	-1
18xag04	153	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	93	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	100	-1	39	-1	5	5	-1	-1
18xag04	154	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	94	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	90	-1	39	-1	6	5	-1	-1
18xag04	155	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	95	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	115	-1	39	-1	7	5	-1	-1
18xag04	156	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	96	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	80	-1	39	-1	8	5	-1	-1
18xag04	157	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	97	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	75	-1	39	-1	9	5	-1	-1
18xag04	158	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	98	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	10	5	-1	-1
18xag04	159	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	99	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	11	5	-1	-1
18xag04	160	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	100	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	12	5	-1	-1
18xag04	161	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	101	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	13	5	-1	-1
18xag04	162	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	102	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	14	5	-1	-1
18xag04	163	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	103	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	15	5	-1	-1
18xag04	164	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	104	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	16	5	-1	-1
18xag04	165	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	105	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	17	5	-1	-1
18xag04	166	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	106	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	18	5	-1	-1
18xag04	167	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	107	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	19	5	-1	-1
18xag04	168	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	108	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	20	5	-1	-1
18xag04	169	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	109	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	21	5	-1	-1
18xag04	170	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	110	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	22	5	-1	-1
83aa203	315	0	0	0	0	U	6	6	2010-03-25	2010-11-01	1-1   	10	-1	U	-1	-1	-1	-1	223.5	-1	7	-1	2	-1	-1	-1
80xaa04	171	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	111	U	1	1	2004-06-01	2004-11-21	SEL   	-1	8	U	-1	-1	-1	-1	100	-1	39	-1	1	6	1	-1
80xaa04	172	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	112	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	50	-1	39	-1	2	6	-1	-1
80xaa04	173	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	113	U	1	1	2004-06-01	2004-11-21	SEL   	-1	10	U	-1	-1	-1	-1	120	-1	39	-1	3	6	-1	-1
80xaa04	174	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	114	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	85	-1	39	-1	4	6	-1	-1
80xaa04	175	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	115	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	50	-1	39	-1	5	6	-1	-1
80xaa04	176	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	116	U	1	1	2004-06-01	2004-11-21	SEL   	-1	9	U	-1	-1	-1	-1	115	-1	39	-1	6	6	-1	-1
80xaa04	177	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	117	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	125	-1	39	-1	7	6	-1	-1
80xaa04	178	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	118	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	65	-1	39	-1	8	6	-1	-1
80xaa04	179	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	119	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	65	-1	39	-1	9	6	-1	-1
80xaa04	180	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	120	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	60	-1	39	-1	10	6	-1	-1
80xaa04	181	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	121	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	90	-1	39	-1	11	6	-1	-1
80xaa04	182	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	122	U	1	1	2004-06-01	2004-11-21	SEL   	-1	9	U	-1	-1	-1	-1	105	-1	39	-1	12	6	-1	-1
80xaa04	183	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	123	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	65	-1	39	-1	13	6	-1	-1
80xaa04	184	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	124	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	85	-1	39	-1	14	6	-1	-1
80xaa04	185	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	125	U	1	1	2004-06-01	2004-11-21	SEL   	-1	2	U	-1	-1	-1	-1	30	-1	39	-1	15	6	-1	-1
80xaa04	186	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	126	U	1	1	2004-06-01	2004-11-21	SEL   	-1	2	U	-1	-1	-1	-1	40	-1	39	-1	16	6	-1	-1
80xaa04	187	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	127	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	75	-1	39	-1	17	6	-1	-1
80xaa04	188	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	128	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	30	-1	39	-1	18	6	-1	-1
80xaa04	189	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	129	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	105	-1	39	-1	19	6	-1	-1
80xaa04	190	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	130	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	75	-1	39	-1	20	6	-1	-1
80xaa04	191	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	131	U	1	1	2004-06-01	2004-11-21	SEL   	-1	8	U	-1	-1	-1	-1	115	-1	39	-1	21	6	-1	-1
80xaa04	192	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	132	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	22	6	-1	-1
2xt4e04	193	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	133	U	1	1	2004-06-01	2004-11-21	SEL   	-1	11	U	-1	-1	-1	-1	110	-1	39	-1	1	7	1	-1
2xt4e04	194	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	134	U	1	1	2004-06-01	2004-11-21	SEL   	-1	2	U	-1	-1	-1	-1	40	-1	39	-1	2	7	-1	-1
2xt4e04	195	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	135	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	80	-1	39	-1	3	7	-1	-1
2xt4e04	196	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	136	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	70	-1	39	-1	4	7	-1	-1
2xt4e04	197	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	137	U	1	1	2004-06-01	2004-11-21	SEL   	-1	8	U	-1	-1	-1	-1	100	-1	39	-1	5	7	-1	-1
2xt4e04	198	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	138	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	70	-1	39	-1	6	7	-1	-1
2xt4e04	199	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	139	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	80	-1	39	-1	7	7	-1	-1
2xt4e04	200	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	140	U	1	1	2004-06-01	2004-11-21	SEL   	-1	2	U	-1	-1	-1	-1	40	-1	39	-1	8	7	-1	-1
2xt4e04	201	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	141	U	1	1	2004-06-01	2004-11-21	SEL   	-1	2	U	-1	-1	-1	-1	40	-1	39	-1	9	7	-1	-1
2xt4e04	202	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	142	U	1	1	2004-06-01	2004-11-21	SEL   	-1	2	U	-1	-1	-1	-1	40	-1	39	-1	10	7	-1	-1
2xt4e04	203	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	143	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	65	-1	39	-1	11	7	-1	-1
2xt4e04	204	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	144	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	80	-1	39	-1	12	7	-1	-1
2xt4e04	205	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	145	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	45	-1	39	-1	13	7	-1	-1
83aa203	316	Whip Planting - 63 Whip, grew 76 planted 2' deep	0	0	0	U	1	1	2010-03-25	2010-11-01	DC    	160	-1	U	-1	-1	-1	-1	193	-1	7	-1	2	-1	-1	-1
2xt4e04	206	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	146	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	14	7	-1	-1
2xt4e04	207	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	147	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	15	7	-1	-1
2xt4e04	208	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	148	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	16	7	-1	-1
2xt4e04	209	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	149	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	17	7	-1	-1
2xt4e04	210	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	150	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	18	7	-1	-1
2xt4e04	211	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	151	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	19	7	-1	-1
2xt4e04	212	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	152	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	20	7	-1	-1
2xt4e04	213	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	153	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	21	7	-1	-1
2xt4e04	214	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	154	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	22	7	-1	-1
1xt4e04	215	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	155	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	35	-1	39	-1	1	8	1	-1
1xt4e04	216	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	156	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	65	-1	39	-1	2	8	-1	-1
1xt4e04	217	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	157	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	30	-1	39	-1	3	8	-1	-1
1xt4e04	218	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	158	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	30	-1	39	-1	4	8	-1	-1
1xt4e04	219	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	159	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	30	-1	39	-1	5	8	-1	-1
1xt4e04	220	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	160	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	30	-1	39	-1	6	8	-1	-1
1xt4e04	221	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	161	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	55	-1	39	-1	7	8	-1	-1
1xt4e04	222	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	162	U	1	1	2004-06-01	2004-11-21	SEL   	-1	2	U	-1	-1	-1	-1	20	-1	39	-1	8	8	-1	-1
1xt4e04	223	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	163	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	30	-1	39	-1	9	8	-1	-1
1xt4e04	224	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	164	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	55	-1	39	-1	10	8	-1	-1
1xt4e04	225	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	165	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	45	-1	39	-1	11	8	-1	-1
1xt4e04	226	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	166	U	1	1	2004-06-01	2004-11-21	SEL   	-1	2	U	-1	-1	-1	-1	30	-1	39	-1	12	8	-1	-1
1xt4e04	227	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	167	U	1	1	2004-06-01	2004-11-21	SEL   	-1	2	U	-1	-1	-1	-1	30	-1	39	-1	13	8	-1	-1
1xt4e04	228	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	168	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	65	-1	39	-1	14	8	-1	-1
1xt4e04	229	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	169	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	20	-1	39	-1	15	8	-1	-1
1xt4e04	230	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	170	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	45	-1	39	-1	16	8	-1	-1
1xt4e04	231	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	171	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	17	8	-1	-1
1xt4e04	232	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	172	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	18	8	-1	-1
1xt4e04	233	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	173	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	19	8	-1	-1
1xt4e04	234	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	174	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	20	8	-1	-1
1xt4e04	235	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	175	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	21	8	-1	-1
1xt4e04	236	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	176	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	22	8	-1	-1
83xaa04	237	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	177	U	1	1	2004-06-01	2004-11-21	SEL   	-1	10	U	-1	-1	-1	-1	140	-1	39	-1	1	9	1	-1
83xaa04	238	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	178	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	95	-1	39	-1	2	9	-1	-1
83xaa04	239	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	179	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	120	-1	39	-1	3	9	-1	-1
83xaa04	240	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	180	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	85	-1	39	-1	4	9	-1	-1
83xaa04	241	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	181	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	90	-1	39	-1	5	9	-1	-1
83xaa04	242	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	182	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	130	-1	39	-1	6	9	-1	-1
83xaa04	243	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	183	U	1	1	2004-06-01	2004-11-21	SEL   	-1	10	U	-1	-1	-1	-1	85	-1	39	-1	7	9	-1	-1
83xaa04	244	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	184	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	105	-1	39	-1	8	9	-1	-1
83xaa04	245	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	185	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	115	-1	39	-1	9	9	-1	-1
83xaa04	246	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	186	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	90	-1	39	-1	10	9	-1	-1
83xaa04	247	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	187	U	1	1	2004-06-01	2004-11-21	SEL   	-1	8	U	-1	-1	-1	-1	135	-1	39	-1	11	9	-1	-1
83xaa04	248	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	188	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	80	-1	39	-1	12	9	-1	-1
83xaa04	249	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	189	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	95	-1	39	-1	13	9	-1	-1
83xaa04	250	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	190	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	60	-1	39	-1	14	9	-1	-1
83xaa04	251	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	191	U	1	1	2004-06-01	2004-11-21	SEL   	-1	8	U	-1	-1	-1	-1	115	-1	39	-1	15	9	-1	-1
83xaa04	252	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	192	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	80	-1	39	-1	16	9	-1	-1
83xaa04	253	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	193	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	17	9	-1	-1
83xaa04	254	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	194	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	18	9	-1	-1
83xaa04	255	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	195	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	19	9	-1	-1
83xaa04	256	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	196	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	20	9	-1	-1
83xaa04	257	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	197	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	21	9	-1	-1
83xaa04	258	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	198	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	22	9	-1	-1
82xaa04	259	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	199	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	110	-1	39	-1	1	10	1	-1
82xaa04	260	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	200	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	85	-1	39	-1	2	10	-1	-1
82xaa04	261	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	201	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	85	-1	39	-1	3	10	-1	-1
82xaa04	262	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	202	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	85	-1	39	-1	4	10	-1	-1
82xaa04	263	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	203	U	1	1	2004-06-01	2004-11-21	SEL   	-1	8	U	-1	-1	-1	-1	160	-1	39	-1	5	10	-1	-1
82xaa04	264	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	204	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	60	-1	39	-1	6	10	-1	-1
82xaa04	265	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	205	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	75	-1	39	-1	7	10	-1	-1
82xaa04	266	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	206	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	75	-1	39	-1	8	10	-1	-1
82xaa04	267	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	207	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	120	-1	39	-1	9	10	-1	-1
82xaa04	268	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	208	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	40	-1	39	-1	10	10	-1	-1
82xaa04	269	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	209	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	120	-1	39	-1	11	10	-1	-1
82xaa04	270	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	210	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	105	-1	39	-1	12	10	-1	-1
82xaa04	271	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	211	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	105	-1	39	-1	13	10	-1	-1
82xaa04	272	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	212	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	50	-1	39	-1	14	10	-1	-1
82xaa04	273	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	213	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	90	-1	39	-1	15	10	-1	-1
82xaa04	274	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	214	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	105	-1	39	-1	16	10	-1	-1
82xaa04	275	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	215	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	85	-1	39	-1	17	10	-1	-1
82xaa04	276	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	216	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	125	-1	39	-1	18	10	-1	-1
82xaa04	277	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	217	U	1	1	2004-06-01	2004-11-21	SEL   	-1	8	U	-1	-1	-1	-1	155	-1	39	-1	19	10	-1	-1
82xaa04	278	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	218	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	105	-1	39	-1	20	10	-1	-1
82xaa04	279	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	219	U	1	1	2004-06-01	2004-11-21	SEL   	-1	9	U	-1	-1	-1	-1	135	-1	39	-1	21	10	-1	-1
82xaa04	280	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	220	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	22	10	-1	-1
84xaa04	281	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	221	U	1	1	2004-06-01	2004-11-21	SEL   	-1	8	U	-1	-1	-1	-1	125	-1	39	-1	1	11	1	-1
84xaa04	282	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	222	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	60	-1	39	-1	2	11	-1	-1
84xaa04	283	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	223	U	1	1	2004-06-01	2004-11-21	SEL   	-1	4	U	-1	-1	-1	-1	70	-1	39	-1	3	11	-1	-1
84xaa04	284	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	224	U	1	1	2004-06-01	2004-11-21	SEL   	-1	8	U	-1	-1	-1	-1	115	-1	39	-1	4	11	-1	-1
84xaa04	285	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	225	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	110	-1	39	-1	5	11	-1	-1
84xaa04	286	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	226	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	110	-1	39	-1	6	11	-1	-1
84xaa04	287	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	227	U	1	1	2004-06-01	2004-11-21	SEL   	-1	9	U	-1	-1	-1	-1	125	-1	39	-1	7	11	-1	-1
84xaa04	288	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	228	U	1	1	2004-06-01	2004-11-21	SEL   	-1	7	U	-1	-1	-1	-1	115	-1	39	-1	8	11	-1	-1
84xaa04	289	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	229	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	95	-1	39	-1	9	11	-1	-1
84xaa04	290	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	230	U	1	1	2004-06-01	2004-11-21	SEL   	-1	10	U	-1	-1	-1	-1	155	-1	39	-1	10	11	-1	-1
84xaa04	291	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	231	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	80	-1	39	-1	11	11	-1	-1
84xaa04	292	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	232	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	90	-1	39	-1	12	11	-1	-1
84xaa04	293	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	233	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	100	-1	39	-1	13	11	-1	-1
84xaa04	294	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	234	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	90	-1	39	-1	14	11	-1	-1
84xaa04	295	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	235	U	1	1	2004-06-01	2004-11-21	SEL   	-1	3	U	-1	-1	-1	-1	55	-1	39	-1	15	11	-1	-1
84xaa04	296	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	236	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	80	-1	39	-1	16	11	-1	-1
84xaa04	297	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	237	U	1	1	2004-06-01	2004-11-21	SEL   	-1	8	U	-1	-1	-1	-1	115	-1	39	-1	17	11	-1	-1
84xaa04	298	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	238	U	1	1	2004-06-01	2004-11-21	SEL   	-1	5	U	-1	-1	-1	-1	85	-1	39	-1	18	11	-1	-1
84xaa04	299	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	239	U	1	1	2004-06-01	2004-11-21	SEL   	-1	6	U	-1	-1	-1	-1	100	-1	39	-1	19	11	-1	-1
84xaa04	300	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	240	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	20	11	-1	-1
84xaa04	301	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	241	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	21	11	-1	-1
84xaa04	302	A 22 tree sample of 2004 P2 family seedlings with height/diameter measurements.	0	0	242	U	1	0	2004-06-01	2004-11-21	SEL   	-1	0	U	-1	-1	-1	-1	0	-1	39	-1	22	11	-1	-1
83aa1	303	#9 pip test: Selected during PIP2 Root test. Best of PIP2. Had 2 dead shoots, tallest=25mm, Smallest dia=4, Rooting: 2005=2/3 66%	0	0	0	U	3	2	2005-03-01	2005-03-14	WASP  	10	-1	U	-1	-1	-1	-1	-1	-1	38	-1	-1	-1	-1	-1
83aa2	304	#24 pip test:  Selected during PIP3 root test. Weighted score=29, basic score=50. Best of PIP3 test! Rooting: 2005=4/6 66%	0	0	0	U	6	4	2005-03-01	2005-03-14	WASP  	10	-1	U	-1	-1	-1	-1	-1	-1	38	-1	-1	-1	-1	-1
83aa3	305	#29 pip test: Selected during PIP3 root test. Weighted score=24, basic score=33. Heavy bottom rooting. Rooting: 3/6 50%	0	0	0	U	6	3	2005-03-01	2005-03-14	WASP  	10	-1	U	-1	-1	-1	-1	-1	-1	38	-1	-1	-1	-1	-1
83aa4	306	#30 pip test: Selected during PIP3 root test. Weighted score=25, basic score=27. Rooting: 3/6 50%	0	0	0	U	6	3	2005-03-01	2005-03-14	WASP  	10	-1	U	-1	-1	-1	-1	-1	-1	38	-1	-1	-1	-1	-1
83aa5	307	#48 pip test: Selected during PIP3 root test. Weighted score=23, basic score=27. Heavy bottom rooting. Rooting: 5/6 83%	0	0	0	U	6	5	2005-03-01	2005-03-14	WASP  	10	-1	U	-1	-1	-1	-1	-1	-1	38	-1	-1	-1	-1	-1
pip-190	308	tag marked 83aa190 but not in DB	0	0	0	U	1	1	2010-03-25	2010-11-01	1-0   	10	-1	U	-1	-1	-1	-1	238.8	-1	7	-1	2	-1	-1	-1
83aa107	309	Has little tomentose on bark	0	0	0	U	1	1	2010-03-25	2010-11-01	1-0   	10	-1	U	-1	-1	-1	-1	383.5	-1	7	-1	2	-1	-1	-1
83aa106	310	Has Knotty Poplar trait real strong, need to propagate more	0	0	0	U	1	1	2010-03-25	2010-11-01	1-0   	10	-1	Y	-1	-1	-1	-1	302.3	-1	7	-1	2	-1	-1	-1
83aa105	311	0	0	0	0	U	1	1	2010-03-25	2010-11-01	1-0   	10	-1	U	-1	-1	-1	-1	170.2	-1	7	-1	2	-1	-1	-1
83aa104	312	Had #1 dia in 2009, 3 boles totaled 311 hgt.	0	0	0	U	1	1	2010-03-25	2010-11-01	1-0   	10	-1	Y	-1	-1	-1	-1	388.6	-1	7	-1	2	-1	-1	-1
83aa103	313	0	0	0	0	U	1	1	2010-03-25	2010-11-01	1-0   	10	-1	U	-1	-1	-1	-1	198.1	-1	7	-1	2	-1	-1	-1
76aa217	317	Whip Planting - 72 Whip, grew 48 planted 2' deep	0	0	0	U	1	1	2010-03-25	2010-11-01	DC    	183	-1	U	-1	-1	-1	-1	121.9	-1	7	-1	2	-1	-1	-1
83aa214	318	Whip Planting - 100 Whip, grew 37 planted 2' deep	0	0	0	U	1	1	2010-03-25	2010-11-01	DC    	254	-1	U	-1	-1	-1	-1	94	-1	7	-1	2	-1	-1	-1
83aa206	319	Whip Planting - 87 Whip, grew 40 planted 2' deep	0	0	0	U	1	1	2010-03-25	2010-11-01	DC    	221	-1	U	-1	-1	-1	-1	101.6	-1	7	-1	2	-1	-1	-1
83aa209	320	Whip Planting - 78 Whip, grew 33 planted 2' deep	0	0	0	U	1	1	2010-03-25	2010-11-01	DC    	199	-1	Y	-1	-1	-1	-1	83.8	-1	7	-1	2	-1	-1	-1
83aa211	321	Whip Planting - 89 Whip, grew 43 planted 2' deep	0	0	0	U	1	1	2010-03-25	2010-11-01	DC    	226	-1	U	-1	-1	-1	-1	109.2	-1	7	-1	2	-1	-1	-1
prince	322	suckers from source	0	0	0	U	4	4	2010-04-10	2010-11-01	1-0   	10	-1	U	-1	-1	-1	-1	137.2	-1	7	-1	3	-1	-1	-1
jamie	323	cuttings from RNE upper branches.  Used #16 IBA.	0	0	0	U	21	0	2010-04-10	2010-11-01	DC    	15	-1	U	-1	-1	-1	-1	0	-1	7	-1	3	-1	-1	-1
ebl	324	suckers from source, very bushy	0	0	0	U	2	2	2010-04-10	2010-11-01	1-0   	30	-1	U	-1	-1	-1	-1	66	-1	7	-1	3	-1	-1	-1
nfa	325	suckers from source, very bushy	0	0	0	U	2	2	2010-04-10	2010-11-01	1-0   	30	-1	U	-1	-1	-1	-1	137.2	-1	7	-1	3	-1	-1	-1
j2	326	suckers from source	0	0	0	U	1	1	2010-04-10	2010-11-01	1-0   	30	-1	U	-1	-1	-1	-1	129.5	-1	7	-1	3	-1	-1	-1
83aa206	327	0	0	0	0	U	1	1	2010-04-10	2010-11-01	1-0   	30	-1	Y	-1	-1	-1	-1	195.6	-1	7	-1	3	-1	-1	-1
83aa204	328	Best performing in this row. This clone did well as cuttings, very competitive.	0	0	0	U	1	1	2010-04-10	2010-11-01	1-0   	30	-1	U	-1	-1	-1	-1	228.6	-1	7	-1	3	-1	-1	-1
83aa202	329	NOT pip-202	0	0	0	U	1	1	2010-04-10	2010-11-01	1-0   	30	-1	U	-1	-1	-1	-1	139.7	-1	7	-1	3	-1	-1	-1
41aa111	330	A P3 Parent clone, need more...	0	0	0	U	10	1	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	25.4	-1	7	-1	4	-1	-1	-1
nfa	331	0	0	0	0	U	54	8	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	81.3	-1	7	-1	4	-1	-1	-1
ebl	332	0	0	0	0	U	26	8	2010-04-10	2010-11-01	DC    	15	-1	U	-1	-1	-1	-1	81.3	-1	7	-1	4	-1	-1	-1
a266	333	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	0	0	U	14	0	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	0	-1	7	-1	4	-1	-1	-1
83aa204	334	Awesome! By far the best clone for cutting performance in 2010.  4 trees had height ranges from 103 to 88 and the first 2 cuttings (from South) had 20 mm diameters at the base.  This is tested as PIP-204 in 2009.	0	0	0	U	7	6	2010-04-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	228.6	-1	7	-1	5	-1	-1	-1
pip58	335	nice	0	0	0	U	7	7	2010-04-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	139.7	-1	7	-1	5	-1	-1	-1
83aa107	336	PIP-183, This was noted in 2009 for having aspen like bark, being greener and having much less tomentose.  It still applies in 2010.	0	0	0	U	6	4	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	91.4	-1	7	-1	5	-1	-1	-1
pip202	337	Not 83AA202 !!	0	0	0	U	3	1	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	101.6	-1	7	-1	5	-1	-1	-1
pip48	338	0	0	0	0	U	6	2	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	45.7	-1	7	-1	5	-1	-1	-1
40aa6mf	339	Used #16 IBA	0	0	0	U	10	0	2010-04-10	2010-11-01	DC    	15	-1	U	-1	-1	-1	-1	0	-1	7	-1	5	-1	-1	-1
33aa11	340	0	0	0	0	U	6	0	2010-04-10	2010-11-01	DC    	15	-1	U	-1	-1	-1	-1	0	-1	7	-1	5	-1	-1	-1
aa4102	341	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	0	0	U	15	0	2010-04-10	2010-11-01	DC    	15	-1	U	-1	-1	-1	-1	0	-1	7	-1	5	-1	-1	-1
pip206	342	NOT 83AA206 !!	0	0	0	U	8	2	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	121.9	-1	7	-1	6	-1	-1	-1
pip203	343	NOT 83AA203 !!	0	0	0	U	10	2	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	78.7	-1	7	-1	6	-1	-1	-1
83aa206	344	NOT PIP-206	0	0	0	U	21	14	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	111.8	-1	7	-1	6	-1	-1	-1
83aa203	345	PIP-2010 control clone - 95BC, 43BC, 87C, 97A, 74A, 21A	0	0	0	U	32	20	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	76.2	-1	7	-1	6	-1	-1	-1
83aa209	346	Noted for its vigor/poor rooting. had 18% rooting in 2009	0	0	0	U	16	9	2010-04-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	139.7	-1	7	-1	6	-1	-1	-1
83aa217	347	0	0	0	0	U	13	6	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	73.7	-1	7	-1	6	-1	-1	-1
83aa214	348	0	0	0	0	U	20	10	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	71.1	-1	7	-1	6	-1	-1	-1
pip63	349	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	0	0	U	5	2	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	48.3	-1	7	-1	6	-1	-1	-1
pip189	350	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results.  This had the #1 PIP score in 2009.	0	0	0	U	4	1	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	58.4	-1	7	-1	6	-1	-1	-1
pip190	351	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	0	0	U	4	0	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	0	-1	7	-1	6	-1	-1	-1
pip181	352	0	0	0	0	U	16	11	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	96.5	-1	7	-1	7	-1	-1	-1
pip187	353	Not found in PIP spreadsheet, could it be 188?	0	0	0	U	10	9	2010-04-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	149.9	-1	7	-1	7	-1	-1	-1
pip197	354	0	0	0	0	U	10	5	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	78.7	-1	7	-1	7	-1	-1	-1
pip193	355	0	0	0	0	U	9	3	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	61	-1	7	-1	7	-1	-1	-1
pip206	356	0	0	0	0	U	7	3	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	121.9	-1	7	-1	7	-1	-1	-1
pip196	357	0	0	0	0	U	11	4	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	101.6	-1	7	-1	7	-1	-1	-1
pip182	358	0	0	0	0	U	13	11	2010-04-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	119.4	-1	7	-1	7	-1	-1	-1
pip184	359	0	0	0	0	U	9	4	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	83.8	-1	7	-1	7	-1	-1	-1
pip194	360	0	0	0	0	U	14	8	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	96.5	-1	7	-1	7	-1	-1	-1
pip200	361	0	0	0	0	U	10	6	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	73.7	-1	7	-1	7	-1	-1	-1
pip199	362	Yellow tagged	0	0	0	U	10	8	2010-04-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	96.5	-1	7	-1	7	-1	-1	-1
pip195	363	0	0	0	0	U	12	6	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	94	-1	7	-1	7	-1	-1	-1
pip185	364	0	0	0	0	U	11	5	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	76.2	-1	7	-1	7	-1	-1	-1
pip186	365	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	0	0	U	12	2	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	50.8	-1	7	-1	7	-1	-1	-1
pip198	366	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	0	0	U	11	0	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	0	-1	7	-1	7	-1	-1	-1
pip180	367	0	0	0	0	U	11	9	2010-04-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	137.2	-1	7	-1	8	-1	-1	-1
pip164	368	0	0	0	0	U	15	12	2010-04-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	137.2	-1	7	-1	8	-1	-1	-1
pip171	369	0	0	0	0	U	16	12	2010-04-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	114.3	-1	7	-1	8	-1	-1	-1
pip170	370	0	0	0	0	U	12	8	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	68.6	-1	7	-1	8	-1	-1	-1
pip175	371	0	0	0	0	U	14	7	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	83.8	-1	7	-1	8	-1	-1	-1
pip154	372	0	0	0	0	U	16	9	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	71.1	-1	7	-1	8	-1	-1	-1
pip176	373	0	0	0	0	U	10	3	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	58.4	-1	7	-1	8	-1	-1	-1
pip173	374	0	0	0	0	U	16	9	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	81.3	-1	7	-1	8	-1	-1	-1
pip172	375	0	0	0	0	U	10	5	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	76.2	-1	7	-1	8	-1	-1	-1
pip156	376	0	0	0	0	U	13	5	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	50.8	-1	7	-1	8	-1	-1	-1
pip191	377	Back Edge Death Area (BEDA) - Do not score with 2010 PIP results	0	0	0	U	8	1	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	48.3	-1	7	-1	8	-1	-1	-1
pip201	378	0	0	0	0	U	7	3	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	58.4	-1	7	-1	8	-1	-1	-1
pip188	379	0	0	0	0	U	8	0	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	0	-1	7	-1	8	-1	-1	-1
pip159	380	Check this for selection??	0	0	0	U	11	10	2010-04-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	76.2	-1	7	-1	9	-1	-1	-1
pip160	381	0	0	0	0	U	18	16	2010-04-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	101.6	-1	7	-1	9	-1	-1	-1
pip161	382	0	0	0	0	U	14	6	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	58.4	-1	7	-1	9	-1	-1	-1
pip168	383	0	0	0	0	U	12	11	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	71.1	-1	7	-1	9	-1	-1	-1
pip177	384	0	0	0	0	U	13	10	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	63.5	-1	7	-1	9	-1	-1	-1
pip162	385	0	0	0	0	U	16	14	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	86.4	-1	7	-1	9	-1	-1	-1
pip167	386	0	0	0	0	U	11	5	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	81.3	-1	7	-1	9	-1	-1	-1
pip174	387	0	0	0	0	U	13	10	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	91.4	-1	7	-1	9	-1	-1	-1
pip178	388	0	0	0	0	U	12	1	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	78.7	-1	7	-1	9	-1	-1	-1
pip166	389	83xA166 - Strong early performer that was cut back to make more cuttings indoors (ASP tests)	0	0	0	U	11	9	2010-04-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	71.1	-1	7	-1	9	-1	-1	-1
pip179	390	0	0	0	0	U	13	1	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	91.4	-1	7	-1	9	-1	-1	-1
pip87	391	0	0	0	0	U	12	7	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	66	-1	7	-1	10	-1	-1	-1
pip69	392	0	0	0	0	U	11	7	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	94	-1	7	-1	10	-1	-1	-1
pip74	393	0	0	0	0	U	17	14	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	101.6	-1	7	-1	10	-1	-1	-1
pip157	394	0	0	0	0	U	10	9	2010-04-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	83.8	-1	7	-1	10	-1	-1	-1
pip153	395	0	0	0	0	U	11	7	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	58.4	-1	7	-1	10	-1	-1	-1
pip155	396	0	0	0	0	U	11	8	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	78.7	-1	7	-1	10	-1	-1	-1
pip151	397	0	0	0	0	U	8	6	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	94	-1	7	-1	10	-1	-1	-1
pip165	398	0	0	0	0	U	14	7	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	63.5	-1	7	-1	10	-1	-1	-1
pip163	399	0	0	0	0	U	16	9	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	101.6	-1	7	-1	10	-1	-1	-1
pip152	400	0	0	0	0	U	14	5	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	91.4	-1	7	-1	10	-1	-1	-1
pip158	401	0	0	0	0	U	15	5	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	83.8	-1	7	-1	10	-1	-1	-1
pip169	402	0	0	0	0	U	15	4	2010-04-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	73.7	-1	7	-1	10	-1	-1	-1
83xaa107	403	Stock Started as ASP material. Tallest is 113	0	0	0	U	16	16	2010-04-10	2010-11-01	ASP   	10	-1	Y	-1	-1	-1	-1	139.7	-1	7	-1	11	-1	-1	-1
zoss	404	This is likely an AG or canescens clone	0	0	0	U	3	3	2010-04-10	2010-11-01	ASP   	10	-1	Y	-1	-1	-1	-1	111.8	-1	7	-1	11	-1	-1	-1
83aa2mf	405	0	0	0	0	U	2	2	2010-04-10	2010-11-01	ASP   	10	-1	U	-1	-1	-1	-1	0	-1	7	-1	11	-1	-1	-1
83aa1mf	406	0	0	0	0	U	5	5	2010-04-10	2010-11-01	ASP   	10	-1	U	-1	-1	-1	-1	121.9	-1	7	-1	11	-1	-1	-1
40aa6mf	407	0	0	0	0	U	2	2	2010-04-10	2010-11-01	ASP   	10	-1	U	-1	-1	-1	-1	154.9	-1	7	-1	11	-1	-1	-1
83aa1mf	408	0	0	0	0	U	2	1	2010-04-10	2010-11-01	ASP   	10	-1	U	-1	-1	-1	-1	198.1	-1	7	-1	11	-1	-1	-1
100aa01	409	Planted in Summer	0	0	0	U	14	14	2010-04-10	2010-11-01	ASP   	10	-1	Y	-1	-1	-1	-1	101.6	-1	7	-1	12	-1	-1	-1
100xaa10	410	tallest=89 quite branchy	0	0	0	U	14	63	2010-04-10	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	101.6	-1	7	-1	12	-1	-1	-1
100aa04	411	0	0	0	0	U	15	11	2010-04-10	2010-11-01	SEL   	10	-1	Y	-1	-1	-1	-1	91.4	-1	7	-1	13	-1	-1	-1
100aa03	412	0	0	0	0	U	12	12	2010-04-10	2010-11-01	SEL   	10	-1	Y	-1	-1	-1	-1	101.6	-1	7	-1	13	-1	-1	-1
100aa02	413	0	0	0	0	U	9	9	2010-04-10	2010-11-01	SEL   	10	-1	Y	-1	-1	-1	-1	78.7	-1	7	-1	13	-1	-1	-1
100xaa10	414	tallest=49, SASP rejects	0	0	0	U	100	6	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	76.2	-1	8	-1	7	-1	-1	-1
87xaa10	415	tallest=53	0	0	0	U	60	48	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	96.5	-1	8	-1	7	-1	-1	-1
101xaa10	416	tallest=48	0	0	0	U	60	33	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	96.5	-1	8	-1	7	-1	-1	-1
102xaa10	417	tallest=30	0	0	0	U	30	16	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	99.1	-1	8	-1	7	-1	-1	-1
91xaa10	418	tallest=58	0	0	0	U	75	54	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	88.9	-1	8	-1	7	-1	-1	-1
91xaa10	419	tallest=54	0	0	0	U	75	32	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	83.8	-1	8	-1	8	-1	-1	-1
98xaa10	420	tallest=53	0	0	0	U	150	75	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	83.8	-1	8	-1	8	-1	-1	-1
100xaa10	421	tallest=58	0	0	0	U	100	75	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	101.6	-1	8	-1	8	-1	-1	-1
104xaa10	422	tallest=61	0	0	0	U	100	105	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	104.1	-1	8	-1	8	-1	-1	-1
104xaa10	423	tallest=54	0	0	0	U	100	18	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	104.1	-1	8	-1	9	-1	-1	-1
103xaa10	424	tallest=60	0	0	0	U	150	120	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	91.4	-1	8	-1	9	-1	-1	-1
97xaa10	425	tallest=66	0	0	0	U	160	120	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	101.6	-1	8	-1	9	-1	-1	-1
86xaa10	426	tallest=60	0	0	0	U	160	150	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	101.6	-1	8	-1	10	-1	-1	-1
93xaa10	427	tallest=71	0	0	0	U	250	120	2010-06-19	2010-11-01	SEL   	10	-1	Y	-1	-1	-1	-1	101.6	-1	8	-1	10	-1	-1	-1
93xaa10	428	tallest=56	0	0	0	U	250	195	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	109.2	-1	8	-1	11	-1	-1	-1
94xaa10	429	tallest=59	0	0	0	U	100	75	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	99.1	-1	8	-1	11	-1	-1	-1
94xaa10	430	tallest=60	0	0	0	U	100	90	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	96.5	-1	8	-1	12	-1	-1	-1
99xaa10	431	tallest=67	0	0	0	U	200	120	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	101.6	-1	8	-1	12	-1	-1	-1
96xaa10	432	tallest=57	0	0	0	U	75	27	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	99.1	-1	8	-1	12	-1	-1	-1
96xaa10	433	tallest=63	0	0	0	U	75	60	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	106.7	-1	8	-1	13	-1	-1	-1
89xaa10	434	tallest=66 (6 @ 66)	0	0	0	U	300	225	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	104.1	-1	8	-1	13	-1	-1	-1
92xaa10	435	tallest=64 (drought loss)	0	0	0	U	200	160	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	96.5	-1	8	-1	14	-1	-1	-1
90xaa10	436	tallest=60	0	0	0	U	125	60	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	96.5	-1	8	-1	14	-1	-1	-1
90xaa10	437	tallest=56 (1 with variagated leaves)	0	0	0	U	125	120	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	96.5	-1	8	-1	15	-1	-1	-1
95xaa10	438	tallest=54	0	0	0	U	60	75	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	94	-1	8	-1	15	-1	-1	-1
88xaa10	439	tallest=58	0	0	0	U	150	105	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	104.1	-1	8	-1	15	-1	-1	-1
88xaa10	440	tallest=64	0	0	0	U	150	135	2010-06-19	2010-11-01	SEL   	10	-1	U	-1	-1	-1	-1	96.5	-1	8	-1	16	-1	-1	-1
76xaa02	441	Seed was frozen till 2007. 1-1 stock South to North. Tallest was #5 - 85.  See PIP notes for #'s 5,7,8,9,11	0	0	0	U	11	11	2008-04-01	2008-11-01	SEL   	15	-1	U	-1	-1	-1	-1	137.2	-1	4	-1	-1	-1	-1	-1
76xaa02	442	0	0	0	0	U	6	2	2008-04-01	2008-11-01	SEL   	15	-1	U	-1	-1	-1	-1	132.1	-1	4	-1	-1	-1	-1	-1
76xaa02	443	0	0	0	0	U	4	1	2008-04-01	2008-11-01	SEL   	15	-1	U	-1	-1	-1	-1	61	-1	4	-1	-1	-1	-1	-1
76xaa02	444	0	0	0	0	U	4	2	2008-04-01	2008-11-01	SEL   	15	-1	U	-1	-1	-1	-1	71.1	-1	4	-1	-1	-1	-1	-1
76xaa02	445	Wide crown? Close nodes. One was 85!  	0	0	0	U	4	4	2008-04-01	2008-11-01	SEL   	15	-1	U	-1	-1	-1	-1	127	-1	4	-1	-1	-1	-1	-1
76xaa02	446	Fastigate?  Was 	0	0	0	U	4	1	2008-04-01	2008-11-01	SEL   	15	-1	U	-1	-1	-1	-1	167.6	-1	4	-1	-1	-1	-1	-1
76xaa02	447	Fastigate?	0	0	0	U	4	3	2008-04-01	2008-11-01	SEL   	15	-1	U	-1	-1	-1	-1	127	-1	4	-1	-1	-1	-1	-1
76xaa02	448	Fastigate?	0	0	0	U	4	1	2008-04-01	2008-11-01	SEL   	15	-1	U	-1	-1	-1	-1	66	-1	4	-1	-1	-1	-1	-1
83xaa04	449	These were part of 200 (1 flat) seedlings raised for MSU.  Planted 20 - 13 survived.  The ID numbers here were carried over to the PIP tests...	0	0	0	U	20	13	2008-04-01	2008-11-01	SEL   	10	-1	U	-1	-1	-1	-1	121.9	-1	4	-1	-1	-1	-1	-1
83xaa04	450	0	0	0	0	U	1	1	2008-04-01	2008-11-01	SEL   	10	-1	U	-1	-1	-1	-1	66	-1	3	-1	-1	-1	-1	-1
83aa203	451	May be PIP #3	0	0	0	U	1	1	2008-04-01	2008-11-01	SEL   	10	-1	U	-1	-1	-1	-1	129.5	-1	3	-1	-1	-1	-1	-1
83xaa04	452	0	0	0	0	U	1	1	2008-04-01	2008-11-01	SEL   	10	-1	U	-1	-1	-1	-1	101.6	-1	3	-1	-1	-1	-1	-1
83xaa04	453	May be PIP #5	0	0	0	U	1	1	2008-04-01	2008-11-01	SEL   	10	-1	U	-1	-1	-1	-1	119.4	-1	3	-1	-1	-1	-1	-1
83xaa04	454	0	0	0	0	U	1	1	2008-04-01	2008-11-01	SEL   	10	-1	U	-1	-1	-1	-1	101.6	-1	3	-1	-1	-1	-1	-1
83xaa04	455	0	0	0	0	U	1	1	2008-04-01	2008-11-01	SEL   	10	-1	U	-1	-1	-1	-1	99.1	-1	3	-1	-1	-1	-1	-1
83aa208	456	0	0	0	0	U	1	1	2008-04-01	2008-11-01	SEL   	10	-1	U	-1	-1	-1	-1	99.1	-1	3	-1	-1	-1	-1	-1
83xaa04	457	May be PIP #9	0	0	0	U	1	1	2008-04-01	2008-11-01	SEL   	10	-1	U	-1	-1	-1	-1	182.9	-1	3	-1	-1	-1	-1	-1
83xaa04	458	0	0	0	0	U	1	1	2008-04-01	2008-11-01	SEL   	10	-1	U	-1	-1	-1	-1	61	-1	3	-1	-1	-1	-1	-1
83xaa04	459	0	0	0	0	U	1	1	2008-04-01	2008-11-01	SEL   	10	-1	U	-1	-1	-1	-1	94	-1	3	-1	-1	-1	-1	-1
83xaa04	460	0	0	0	0	U	1	1	2008-04-01	2008-11-01	SEL   	10	-1	U	-1	-1	-1	-1	83.8	-1	3	-1	-1	-1	-1	-1
83xaa04	461	0	0	0	0	U	1	1	2008-04-01	2008-11-01	SEL   	10	-1	U	-1	-1	-1	-1	81.3	-1	3	-1	-1	-1	-1	-1
76aa218	462	PIP09-T5=0	0	0	0	U	10	2	2009-04-04	2009-11-01	DC    	10	-1	U	-1	-1	-1	-1	91.4	-1	6	-1	-1	-1	-1	-1
76aa217	463	Nice - vigorous, PIP09-T5=18	0	0	0	U	20	12	2009-04-04	2009-11-01	DC    	10	-1	U	-1	-1	-1	-1	76.2	-1	6	-1	-1	-1	-1	-1
76aa214	464	PIP09-T5=4	0	0	0	U	10	6	2009-04-04	2009-11-01	DC    	10	-1	U	-1	-1	-1	-1	127	-1	6	-1	-1	-1	-1	-1
76aa211	465	Short 1-0 parent stock, PIP09-T5=16	0	0	0	U	10	4	2009-04-04	2009-11-01	DC    	10	-1	U	-1	-1	-1	-1	91.4	-1	6	-1	-1	-1	-1	-1
76aa205	466	PIP09-T5=46	0	0	0	U	12	7	2009-04-04	2009-11-01	DC    	10	-1	U	-1	-1	-1	-1	121.9	-1	6	-1	-1	-1	-1	-1
83aa209	467	Huge 1-0 parent stock, Large leaves, wavy, syliptic, PIP09-T5=28	0	0	0	U	11	2	2009-04-04	2009-11-01	DC    	10	-1	U	-1	-1	-1	-1	157.5	-1	6	-1	-1	-1	-1	-1
83aa208	468	PIP09-T5=70	0	0	0	U	4	2	2009-04-04	2009-11-01	DC    	10	-1	U	-1	-1	-1	-1	88.9	-1	6	-1	-1	-1	-1	-1
83aa206	469	NIce! Tallest=81, 100% rooting if 4 is counted.  PIP09-T5=100	0	0	0	U	4	3	2009-04-04	2009-11-01	DC    	10	-1	U	-1	-1	-1	-1	121.9	-1	6	-1	-1	-1	-1	-1
83aa203	470	Dark green leaves - Bugs like leaves...  The PIP-09-T5 test had incredible callus cluster roots at cutting base.  PIP09-T5=66	0	0	0	U	6	5	2009-04-04	2009-11-01	DC    	10	-1	U	-1	-1	-1	-1	142.2	-1	6	-1	-1	-1	-1	-1
pip120	471	Tallest=31 Dia 5-9mm (Dykema PIP cuttings)	0	0	0	U	11	11	2010-05-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	22	-1	8	-1	3	-1	-1	-1
pip101	472	Tallest=32   (Dykema PIP cuttings)	0	0	0	U	12	9	2010-05-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	25	-1	8	-1	3	-1	-1	-1
pip115	473	Tallest=37   (Dykema PIP cuttings)	0	0	0	U	12	10	2010-05-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	24	-1	8	-1	3	-1	-1	-1
pip129	474	Tallest=37   (Dykema PIP cuttings)	0	0	0	U	14	11	2010-05-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	23	-1	8	-1	3	-1	-1	-1
pip37	475	Tallest=43   (Dykema PIP cuttings)	0	0	0	U	15	10	2010-05-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	33	-1	8	-1	4	-1	-1	-1
pip31	476	Tallest=37   (Dykema PIP cuttings)	0	0	0	U	14	11	2010-05-10	2010-11-01	DC    	10	-1	Y	-1	-1	-1	-1	29	-1	8	-1	4	-1	-1	-1
pip9	477	Tallest=49 biased  (Dykema PIP cuttings)	0	0	0	U	11	8	2010-05-10	2010-11-01	DC    	10	-1	U	-1	-1	-1	-1	31	-1	8	-1	5	-1	-1	-1
93xaa10	479	Flat 2 all 1-0 stock (select 2)	0	0	0	U	12	10	2011-04-17	2011-09-01	1-0   	15	4	Y	-1	-1	-1	-1	-1	-1	13	-1	3	-1	-1	-1
83aa221	480	PIP120 ? Check notes (select 2)	0	0	0	U	12	12	2011-04-17	2011-09-01	1-0   	30	4	Y	-1	-1	-1	-1	-1	-1	13	-1	4	-1	-1	-1
90aa101	481	Variegated 10% on 5/26/11 (Reverted)	0	0	0	U	1	1	2011-04-17	2011-09-01	1-0   	40	5	N	-1	-1	-1	-1	-1	-1	13	-1	5	-1	-1	-1
94aa101	482	Variegated 50% on 5/26/11, 50% on 9/1/11	0	0	0	U	1	1	2011-04-17	2011-09-01	1-0   	40	5	Y	-1	-1	-1	-1	-1	-1	13	-1	6	-1	-1	-1
87aa101	483	Variegated 0% on 5/26/11 looked dead.  (Reverted)	0	0	0	U	1	1	2011-04-17	2011-09-01	1-0   	30	4	N	-1	-1	-1	-1	-1	-1	13	-1	7	-1	-1	-1
88xaa10	484	Nice 5/26/11 Begin Row (right side)	0	0	0	U	6	2	2011-04-17	2011-09-01	DC    	15	14	N	-1	-1	-1	-1	-1	-1	13	-1	8	-1	-1	-1
88xaa10	485	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	9	-1	-1	-1
88xaa10	486	0	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	10	-1	-1	-1
88xaa10	487	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	11	-1	-1	-1
88xaa10	488	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	12	-1	-1	-1
88xaa10	489	0	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	13	-1	-1	-1
88xaa10	490	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	14	-1	-1	-1
88xaa10	491	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	15	-1	-1	-1
88xaa10	492	0	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	16	-1	-1	-1
88xaa10	493	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	17	-1	-1	-1
88xaa10	494	0	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	18	-1	-1	-1
88xaa10	495	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	19	-1	-1	-1
88xaa10	496	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	20	-1	-1	-1
88xaa10	497	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	21	-1	-1	-1
88xaa10	498	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	22	-1	-1	-1
88xaa10	499	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	23	-1	-1	-1
88xaa10	500	end row	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	24	-1	-1	-1
88xaa10	501	begin row	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	25	-1	-1	-1
88xaa10	502	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	26	-1	-1	-1
88xaa10	503	0	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	27	-1	-1	-1
88xaa10	504	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	28	-1	-1	-1
88xaa10	505	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	29	-1	-1	-1
88xaa10	506	0	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	30	-1	-1	-1
88xaa10	507	0	0	0	0	U	6	1	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	31	-1	-1	-1
88xaa10	508	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	32	-1	-1	-1
88xaa10	509	0	0	0	0	U	5	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	33	-1	-1	-1
88xaa10	510	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	34	-1	-1	-1
88xaa10	511	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	35	-1	-1	-1
88xaa10	512	0	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	36	-1	-1	-1
88xaa10	513	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	37	-1	-1	-1
88xaa10	514	0	0	0	0	U	5	1	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	38	-1	-1	-1
88xaa10	515	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	39	-1	-1	-1
89xaa10	516	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	40	-1	-1	-1
89xaa10	517	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	41	-1	-1	-1
89xaa10	518	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	5	N	-1	-1	-1	-1	-1	-1	13	-1	42	-1	-1	-1
89xaa10	519	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	43	-1	-1	-1
89xaa10	520	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	44	-1	-1	-1
89xaa10	521	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	45	-1	-1	-1
89xaa10	522	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	46	-1	-1	-1
89xaa10	523	0	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	47	-1	-1	-1
89xaa10	524	end row	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	48	-1	-1	-1
89xaa10	525	begin row	0	0	0	U	6	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	49	-1	-1	-1
89xaa10	526	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	50	-1	-1	-1
89xaa10	527	0	0	0	0	U	5	1	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	51	-1	-1	-1
89xaa10	528	0	0	0	0	U	5	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	52	-1	-1	-1
89xaa10	529	0	0	0	0	U	6	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	53	-1	-1	-1
89xaa10	530	0	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	54	-1	-1	-1
89xaa10	531	0	0	0	0	U	5	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	55	-1	-1	-1
89xaa10	532	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	56	-1	-1	-1
89xaa10	533	0	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	57	-1	-1	-1
89xaa10	534	0	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	1	-1	-1	-1
89xaa10	535	0	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	2	-1	-1	-1
89xaa10	536	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	3	-1	-1	-1
89xaa10	537	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	Y	-1	-1	-1	-1	-1	-1	13	-1	4	-1	-1	-1
89xaa10	538	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	Y	-1	-1	-1	-1	-1	-1	13	-1	5	-1	-1	-1
89xaa10	539	end row	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	6	-1	-1	-1
89xaa10	540	begin row	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	7	-1	-1	-1
89xaa10	541	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	8	-1	-1	-1
89xaa10	542	0	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	9	-1	-1	-1
89xaa10	543	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	10	-1	-1	-1
89xaa10	544	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	11	-1	-1	-1
91xaa10	545	0	0	0	0	U	7	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	12	-1	-1	-1
91xaa10	546	0	0	0	0	U	7	6	2011-04-17	2011-09-01	DC    	-1	8	Y	-1	-1	-1	-1	-1	-1	13	-1	13	-1	-1	-1
91xaa10	547	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	14	-1	-1	-1
91xaa10	548	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	15	-1	-1	-1
91xaa10	549	0	0	0	0	U	4	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	16	-1	-1	-1
91xaa10	550	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	17	-1	-1	-1
91xaa10	551	0	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	18	-1	-1	-1
91xaa10	552	0	0	0	0	U	4	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	19	-1	-1	-1
91xaa10	553	0	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	20	-1	-1	-1
91xaa10	554	0	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	21	-1	-1	-1
91xaa10	555	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	22	-1	-1	-1
91xaa10	556	0	0	0	0	U	5	0	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	23	-1	-1	-1
91xaa10	557	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	24	-1	-1	-1
91xaa10	558	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	25	-1	-1	-1
91xaa10	559	0	0	0	0	U	5	6	2011-04-17	2011-09-01	DC    	-1	-1	Y	-1	-1	-1	-1	-1	-1	13	-1	26	-1	-1	-1
91xaa10	560	end row	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	27	-1	-1	-1
91xaa10	561	begin row	0	0	0	U	7	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	28	-1	-1	-1
91xaa10	562	0	0	0	0	U	5	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	29	-1	-1	-1
91xaa10	563	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	30	-1	-1	-1
91xaa10	564	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	31	-1	-1	-1
91xaa10	565	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	32	-1	-1	-1
91xaa10	566	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	33	-1	-1	-1
91xaa10	567	Best family selection	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	34	-1	-1	-1
91xaa10	568	0	0	0	0	U	4	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	35	-1	-1	-1
91xaa10	569	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	4	Y	-1	-1	-1	-1	-1	-1	13	-1	36	-1	-1	-1
91xaa10	570	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	37	-1	-1	-1
91xaa10	571	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	38	-1	-1	-1
91xaa10	572	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	39	-1	-1	-1
91xaa10	573	0	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	40	-1	-1	-1
91xaa10	574	0	0	0	0	U	4	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	41	-1	-1	-1
99xaa10	575	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	42	-1	-1	-1
99xaa10	576	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	43	-1	-1	-1
99xaa10	577	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	44	-1	-1	-1
99xaa10	578	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	45	-1	-1	-1
99xaa10	579	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	46	-1	-1	-1
99xaa10	580	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	4	N	-1	-1	-1	-1	-1	-1	13	-1	47	-1	-1	-1
99xaa10	581	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	48	-1	-1	-1
99xaa10	582	0	0	0	0	U	4	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	49	-1	-1	-1
99xaa10	583	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	50	-1	-1	-1
99xaa10	584	0	0	0	0	U	7	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	51	-1	-1	-1
99xaa10	585	0	0	0	0	U	2	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	52	-1	-1	-1
99xaa10	586	0	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	53	-1	-1	-1
99xaa10	587	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	54	-1	-1	-1
99xaa10	588	end row	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	55	-1	-1	-1
99xaa10	589	begin row	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	56	-1	-1	-1
99xaa10	590	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	57	-1	-1	-1
99xaa10	591	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	58	-1	-1	-1
99xaa10	592	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	59	-1	-1	-1
99xaa10	593	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	60	-1	-1	-1
99xaa10	594	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	61	-1	-1	-1
99xaa10	595	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	62	-1	-1	-1
99xaa10	596	0	0	0	0	U	6	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	63	-1	-1	-1
99xaa10	597	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	64	-1	-1	-1
99xaa10	598	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	65	-1	-1	-1
99xaa10	599	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	66	-1	-1	-1
99xaa10	600	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	67	-1	-1	-1
99xaa10	601	0	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	68	-1	-1	-1
99xaa10	602	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	69	-1	-1	-1
99xaa10	603	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	70	-1	-1	-1
87xaa10	604	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	6	N	-1	-1	-1	-1	-1	-1	13	-1	71	-1	-1	-1
87xaa10	605	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	72	-1	-1	-1
87xaa10	606	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	73	-1	-1	-1
87xaa10	607	0	0	0	0	U	6	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	74	-1	-1	-1
87xaa10	608	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	75	-1	-1	-1
87xaa10	609	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	5	N	-1	-1	-1	-1	-1	-1	13	-1	76	-1	-1	-1
87xaa10	610	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	77	-1	-1	-1
87xaa10	611	0	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	78	-1	-1	-1
87xaa10	612	end row	0	0	0	U	6	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	79	-1	-1	-1
87xaa10	613	begin row	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	80	-1	-1	-1
87xaa10	614	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	81	-1	-1	-1
87xaa10	615	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	82	-1	-1	-1
87xaa10	616	0	0	0	0	U	4	1	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	83	-1	-1	-1
87xaa10	617	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	84	-1	-1	-1
87xaa10	618	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	85	-1	-1	-1
87xaa10	619	0	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	86	-1	-1	-1
87xaa10	620	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	87	-1	-1	-1
100xaa10	621	Cutting stock from Dykema 2010	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	1	-1	-1	-1
100xaa10	622	Cutting stock from Dykema 2010	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	2	-1	-1	-1
100xaa10	623	Cutting stock from Dykema 2010	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	3	-1	-1	-1
100xaa10	624	Cutting stock from Dykema 2010	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	6	Y	-1	-1	-1	-1	-1	-1	13	-1	4	-1	-1	-1
100xaa10	625	Cutting stock from Dykema 2010	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	5	-1	-1	-1
100xaa10	626	Cutting stock from Dykema 2010	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	6	-1	-1	-1
100xaa10	627	Cutting stock from Dykema 2010	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	7	-1	-1	-1
100xaa10	628	Cutting stock from Dykema 2010	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	8	-1	-1	-1
100xaa10	629	PRAVL - Stock from Dykema 2010	PRAVL	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	9	-1	-1	-1
100xaa10	630	Cutting stock from Dykema 2010	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	10	-1	-1	-1
100xaa10	631	Cutting stock from Dykema 2010	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	11	-1	-1	-1
100xaa10	632	Cutting stock from Dykema 2010	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	12	-1	-1	-1
100xaa10	633	Cutting stock from Dykema 2010	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	11	Y	-1	-1	-1	-1	-1	-1	13	-1	13	-1	-1	-1
100xaa10	634	end row	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	14	-1	-1	-1
100xaa10	635	begin row	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	11	Y	-1	-1	-1	-1	-1	-1	13	-1	15	-1	-1	-1
100xaa10	636	Cutting stock from Dykema 2010	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	16	-1	-1	-1
100xaa10	637	Cutting stock from Dykema 2010	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	17	-1	-1	-1
100xaa10	638	Cutting stock from Dykema 2010	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	18	-1	-1	-1
100xaa10	639	Cutting stock from Dykema 2010	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	19	-1	-1	-1
100xaa10	640	Cutting stock from Dykema 2010	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	6	Y	-1	-1	-1	-1	-1	-1	13	-1	20	-1	-1	-1
100xaa10	641	Cutting stock from Dykema 2010	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	7	Y	-1	-1	-1	-1	-1	-1	13	-1	21	-1	-1	-1
100xaa10	642	Cutting stock from Dykema 2010	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	22	-1	-1	-1
100xaa10	643	Cutting stock from Dykema 2010	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	23	-1	-1	-1
100xaa10	644	Cutting stock from Dykema 2010	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	24	-1	-1	-1
100xaa10	645	Cutting stock from Dykema 2010	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	25	-1	-1	-1
100xaa10	646	Cutting stock from Dykema 2010	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	26	-1	-1	-1
100xaa10	647	Cutting stock from Dykema 2010	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	27	-1	-1	-1
100xaa10	648	Cutting stock from Dykema 2010	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	28	-1	-1	-1
100xaa10	649	Cutting stock from Dykema 2010	0	0	0	U	4	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	29	-1	-1	-1
95xaa10	650	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	12	N	-1	-1	-1	-1	-1	-1	13	-1	30	-1	-1	-1
95xaa10	651	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	8	N	-1	-1	-1	-1	-1	-1	13	-1	31	-1	-1	-1
95xaa10	652	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	32	-1	-1	-1
95xaa10	653	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	33	-1	-1	-1
95xaa10	654	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	34	-1	-1	-1
95xaa10	655	0	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	35	-1	-1	-1
95xaa10	656	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	36	-1	-1	-1
95xaa10	657	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	37	-1	-1	-1
95xaa10	658	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	38	-1	-1	-1
95xaa10	659	0	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	39	-1	-1	-1
95xaa10	660	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	40	-1	-1	-1
95xaa10	661	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	41	-1	-1	-1
95xaa10	662	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	42	-1	-1	-1
95xaa10	663	0	0	0	0	U	6	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	43	-1	-1	-1
95xaa10	664	end row	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	44	-1	-1	-1
95xaa10	665	begin row	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	45	-1	-1	-1
95xaa10	666	0	0	0	0	U	6	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	46	-1	-1	-1
95xaa10	667	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	47	-1	-1	-1
95xaa10	668	0	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	48	-1	-1	-1
95xaa10	669	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	49	-1	-1	-1
95xaa10	670	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	50	-1	-1	-1
95xaa10	671	0	0	0	0	U	6	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	51	-1	-1	-1
95xaa10	672	0	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	52	-1	-1	-1
95xaa10	673	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	53	-1	-1	-1
95xaa10	674	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	54	-1	-1	-1
95xaa10	675	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	55	-1	-1	-1
95xaa10	676	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	4	Y	-1	-1	-1	-1	-1	-1	13	-1	56	-1	-1	-1
95xaa10	677	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	57	-1	-1	-1
95xaa10	678	0	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	58	-1	-1	-1
95xaa10	679	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	59	-1	-1	-1
102xaa10	680	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	60	-1	-1	-1
102xaa10	681	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	61	-1	-1	-1
102xaa10	682	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	12	Y	-1	-1	-1	-1	-1	-1	13	-1	62	-1	-1	-1
102xaa10	683	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	63	-1	-1	-1
102xaa10	684	0	0	0	0	U	6	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	64	-1	-1	-1
102xaa10	685	end row	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	65	-1	-1	-1
102xaa10	686	begin row	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	8	Y	-1	-1	-1	-1	-1	-1	13	-1	66	-1	-1	-1
102xaa10	687	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	67	-1	-1	-1
102xaa10	688	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	68	-1	-1	-1
102xaa10	689	0	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	69	-1	-1	-1
102xaa10	690	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	4	Y	-1	-1	-1	-1	-1	-1	13	-1	70	-1	-1	-1
102xaa10	691	0	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	71	-1	-1	-1
102xaa10	692	0	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	72	-1	-1	-1
101xaa10	693	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	73	-1	-1	-1
101xaa10	694	0	0	0	0	U	4	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	74	-1	-1	-1
101xaa10	695	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	75	-1	-1	-1
101xaa10	696	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	76	-1	-1	-1
101xaa10	697	end row	0	0	0	U	5	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	77	-1	-1	-1
101xaa10	698	begin row	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	78	-1	-1	-1
101xaa10	699	0	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	79	-1	-1	-1
101xaa10	700	0	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	80	-1	-1	-1
101xaa10	701	0	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	81	-1	-1	-1
101xaa10	702	0	0	0	0	U	4	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	82	-1	-1	-1
83aa204	703	Vigorous clone, not the best rooter.	0	0	0	U	7	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	246	-1	13	-1	1	-1	-1	-1
83aa204	704	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	246	-1	13	-1	2	-1	-1	-1
83aa215	705	Nice, Get 2010 source details	0	0	0	U	11	10	2011-04-17	2011-09-01	DC    	-1	12	Y	-1	-1	-1	-1	-1	-1	13	-1	3	-1	-1	-1
83aa215	706	Nice, Get 2010 source details	0	0	0	U	8	6	2011-04-17	2011-09-01	DC    	-1	13	N	-1	-1	-1	-1	-1	-1	13	-1	4	-1	-1	-1
83aa212	707	Nice, Get 2010 source details	0	0	0	U	9	9	2011-04-17	2011-09-01	DC    	-1	10	Y	-1	-1	-1	-1	-1	-1	13	-1	5	-1	-1	-1
83aa212	708	Nice, Get 2010 source details	0	0	0	U	10	9	2011-04-17	2011-09-01	DC    	-1	12	N	-1	-1	-1	-1	-1	-1	13	-1	6	-1	-1	-1
a502	709	0	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	25	10	Y	-1	-1	-1	-1	-1	-1	13	-1	7	-1	-1	-1
a502	710	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	25	12	N	-1	-1	-1	-1	-1	-1	13	-1	8	-1	-1	-1
41aa111	711	0	0	0	0	U	9	3	2011-04-17	2011-09-01	DC    	25	-1	Y	-1	-1	-1	-1	-1	-1	13	-1	9	-1	-1	-1
41aa111	712	0	0	0	0	U	7	2	2011-04-17	2011-09-01	DC    	25	-1	N	-1	-1	-1	-1	-1	-1	13	-1	10	-1	-1	-1
83aa217	713	Not good	0	0	0	U	8	4	2011-04-17	2011-09-01	DC    	-1	10	N	-1	-1	-1	-1	-1	-1	13	-1	11	-1	-1	-1
83aa217	714	Not good	0	0	0	U	9	5	2011-04-17	2011-09-01	DC    	-1	10	N	-1	-1	-1	-1	-1	-1	13	-1	12	-1	-1	-1
83aa103	715	Check for spear leaf mutation	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	13	N	-1	-1	-1	-1	-1	-1	13	-1	13	-1	-1	-1
83aa103	716	Check for spear leaf mutation	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	13	N	-1	-1	-1	-1	-1	-1	13	-1	14	-1	-1	-1
83aa216	717	Very Nice	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	12	Y	-1	-1	-1	-1	-1	-1	13	-1	15	-1	-1	-1
83aa216	718	Very Nice	0	0	0	U	6	6	2011-04-17	2011-09-01	DC    	-1	16	N	-1	-1	-1	-1	-1	-1	13	-1	16	-1	-1	-1
nfa	719	northFox alba	0	0	0	U	11	7	2011-04-17	2011-09-01	DC    	25	-1	Y	-1	-1	-1	-1	-1	-1	13	-1	17	-1	-1	-1
nfa	720	northFox alba	0	0	0	U	11	8	2011-04-17	2011-09-01	DC    	25	-1	N	-1	-1	-1	-1	-1	-1	13	-1	18	-1	-1	-1
ebl	721	EastBeltline alba	0	0	0	U	11	6	2011-04-17	2011-09-01	DC    	25	-1	Y	-1	-1	-1	-1	-1	-1	13	-1	19	-1	-1	-1
ebl	722	EastBeltline alba	0	0	0	U	11	7	2011-04-17	2011-09-01	DC    	25	-1	N	-1	-1	-1	-1	-1	-1	13	-1	20	-1	-1	-1
83aa104	723	Selected in 9/2009 for its remarkable growth performance. Compare now	0	0	0	U	7	3	2011-04-17	2011-09-01	DC    	-1	19	N	-1	-1	-1	-1	-1	-1	13	-1	21	-1	-1	-1
83aa104	724	Selected in 9/2009 for its remarkable growth performance. Compare now	0	0	0	U	8	4	2011-04-17	2011-09-01	DC    	-1	19	N	-1	-1	-1	-1	-1	-1	13	-1	22	-1	-1	-1
83aa107	725	Aspen like appearance	0	0	0	U	8	4	2011-04-17	2011-09-01	DC    	-1	12	Y	-1	-1	-1	-1	-1	-1	13	-1	23	-1	-1	-1
83aa107	726	Aspen like appearance	0	0	0	U	7	4	2011-04-17	2011-09-01	DC    	-1	12	N	-1	-1	-1	-1	-1	-1	13	-1	24	-1	-1	-1
83aa204	727	selected for 2012. Vigorous, but a fair rooter	0	0	0	U	9	7	2011-04-17	2011-09-01	DC    	-1	12	Y	-1	-1	-1	-1	203	-1	13	-1	25	-1	-1	-1
83aa204	728	0	0	0	0	U	10	6	2011-04-17	2011-09-01	DC    	-1	12	N	-1	-1	-1	-1	203	-1	13	-1	26	-1	-1	-1
83aa227	729	Nice, Get 2010 source details	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	6	Y	-1	-1	-1	-1	-1	-1	13	-1	27	-1	-1	-1
83aa227	730	Nice, Get 2010 source details	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	6	N	-1	-1	-1	-1	-1	-1	13	-1	28	-1	-1	-1
83aa211	731	0	0	0	0	U	5	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	29	-1	-1	-1
83aa211	732	0	0	0	0	U	5	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	30	-1	-1	-1
83aa106	733	Selected in 9/2009 for its numerous small side shoots. Are there?	0	0	0	U	6	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	31	-1	-1	-1
83aa106	734	Selected in 9/2009 for its numerous small side shoots. Are there?	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	32	-1	-1	-1
83aa228	735	0	0	0	0	U	8	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	33	-1	-1	-1
83aa228	736	0	0	0	0	U	6	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	34	-1	-1	-1
83aa214	737	0	0	0	0	U	4	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	35	-1	-1	-1
83aa214	738	0	0	0	0	U	5	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	36	-1	-1	-1
83aa204	739	0	0	0	0	U	9	6	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	178	-1	13	-1	37	-1	-1	-1
83aa204	740	0	0	0	0	U	9	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	178	-1	13	-1	38	-1	-1	-1
zoss	741	Get dia and length details	0	0	0	U	7	1	2011-04-17	2011-09-01	DC    	-1	-1	Y	-1	-1	-1	-1	-1	-1	13	-1	39	-1	-1	-1
zoss	742	0	0	0	0	U	7	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	40	-1	-1	-1
83aa1mf	743	0	0	0	0	U	17	3	2011-04-17	2011-09-01	DC    	-1	10	Y	-1	-1	-1	-1	-1	-1	13	-1	41	-1	-1	-1
83aa1mf	744	0	0	0	0	U	17	5	2011-04-17	2011-09-01	DC    	-1	10	N	-1	-1	-1	-1	-1	-1	13	-1	42	-1	-1	-1
83aa2mf	745	0	0	0	0	U	8	5	2011-04-17	2011-09-01	DC    	-1	10	Y	-1	-1	-1	-1	-1	-1	13	-1	43	-1	-1	-1
83aa2mf	746	0	0	0	0	U	8	3	2011-04-17	2011-09-01	DC    	-1	10	N	-1	-1	-1	-1	-1	-1	13	-1	44	-1	-1	-1
83aa226	747	0	0	0	0	U	3	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	45	-1	-1	-1
83aa226	748	0	0	0	0	U	4	4	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	46	-1	-1	-1
83aa224	749	0	0	0	0	U	6	5	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	47	-1	-1	-1
83aa223	750	0	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	48	-1	-1	-1
83aa225	751	0	0	0	0	U	5	3	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	49	-1	-1	-1
83aa222	752	0	0	0	0	U	11	10	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	50	-1	-1	-1
83aa220	753	0	0	0	0	U	7	2	2011-04-17	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	51	-1	-1	-1
104xaa10	754	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	6	N	-1	-1	-1	-1	-1	-1	13	-1	1	-1	-1	-1
104xaa10	755	0	0	0	0	U	11	11	2011-04-25	2011-09-01	DC    	-1	10	Y	-1	-1	-1	-1	-1	-1	13	-1	2	-1	-1	-1
104xaa10	756	0	0	0	0	U	40	10	2011-04-25	2011-09-01	DC    	-1	10	N	-1	-1	-1	-1	-1	-1	13	-1	3	-1	-1	-1
104xaa10	757	0	0	0	0	U	7	7	2011-04-25	2011-09-01	DC    	-1	6	N	-1	-1	-1	-1	-1	-1	13	-1	4	-1	-1	-1
104xaa10	758	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	5	-1	-1	-1
104xaa10	759	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	6	-1	-1	-1
104xaa10	760	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	7	-1	-1	-1
104xaa10	761	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	8	-1	-1	-1
104xaa10	762	PRAVL - Stock from Dykema 2010	PRAVL	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	10	Y	-1	-1	-1	-1	-1	-1	13	-1	9	-1	-1	-1
104xaa10	763	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	10	-1	-1	-1
104xaa10	764	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	6	Y	-1	-1	-1	-1	-1	-1	13	-1	11	-1	-1	-1
104xaa10	765	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	12	-1	-1	-1
104xaa10	766	0	0	0	0	U	6	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	13	-1	-1	-1
104xaa10	767	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	14	-1	-1	-1
104xaa10	768	end row	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	10	Y	-1	-1	-1	-1	-1	-1	13	-1	15	-1	-1	-1
104xaa10	769	begin row (yes, this row is duplicated)	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	15	-1	-1	-1
104xaa10	770	0	0	0	0	U	7	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	16	-1	-1	-1
104xaa10	771	0	0	0	0	U	7	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	17	-1	-1	-1
104xaa10	772	0	0	0	0	U	9	9	2011-04-25	2011-09-01	DC    	-1	11	Y	-1	-1	-1	-1	-1	-1	13	-1	18	-1	-1	-1
104xaa10	773	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	19	-1	-1	-1
104xaa10	774	RF	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	12	N	-1	-1	-1	-1	-1	-1	13	-1	20	-1	-1	-1
104xaa10	775	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	21	-1	-1	-1
104xaa10	776	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	22	-1	-1	-1
104xaa10	777	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	23	-1	-1	-1
104xaa10	778	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	24	-1	-1	-1
104xaa10	779	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	25	-1	-1	-1
104xaa10	780	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	26	-1	-1	-1
104xaa10	781	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	27	-1	-1	-1
104xaa10	782	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	28	-1	-1	-1
97xaa10	783	0	0	0	0	U	6	2	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	29	-1	-1	-1
97xaa10	784	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	9	Y	-1	-1	-1	-1	-1	-1	13	-1	30	-1	-1	-1
97xaa10	785	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	31	-1	-1	-1
97xaa10	786	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	32	-1	-1	-1
97xaa10	787	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	33	-1	-1	-1
97xaa10	788	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	34	-1	-1	-1
97xaa10	789	0	0	0	0	U	6	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	35	-1	-1	-1
97xaa10	790	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	36	-1	-1	-1
97xaa10	791	0	0	0	0	U	6	2	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	37	-1	-1	-1
97xaa10	792	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	38	-1	-1	-1
97xaa10	793	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	39	-1	-1	-1
97xaa10	794	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	40	-1	-1	-1
97xaa10	795	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	41	-1	-1	-1
97xaa10	796	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	42	-1	-1	-1
97xaa10	797	end row	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	43	-1	-1	-1
97xaa10	798	begin row	0	0	0	U	5	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	44	-1	-1	-1
97xaa10	799	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	12	Y	-1	-1	-1	-1	-1	-1	13	-1	45	-1	-1	-1
97xaa10	800	0	0	0	0	U	6	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	46	-1	-1	-1
97xaa10	801	0	0	0	0	U	5	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	47	-1	-1	-1
97xaa10	802	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	48	-1	-1	-1
97xaa10	803	0	0	0	0	U	6	1	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	49	-1	-1	-1
97xaa10	804	0	0	0	0	U	7	7	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	50	-1	-1	-1
97xaa10	805	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	51	-1	-1	-1
97xaa10	806	0	0	0	0	U	6	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	52	-1	-1	-1
97xaa10	807	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	7	Y	-1	-1	-1	-1	-1	-1	13	-1	53	-1	-1	-1
97xaa10	808	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	54	-1	-1	-1
97xaa10	809	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	55	-1	-1	-1
97xaa10	810	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	56	-1	-1	-1
97xaa10	811	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	57	-1	-1	-1
40aa6mf	812	0	0	0	0	U	10	1	2011-04-25	2011-09-01	DC    	-1	-1	Y	-1	-1	-1	-1	-1	-1	13	-1	58	-1	-1	-1
40aa6mf	813	0	0	0	0	U	9	1	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	59	-1	-1	-1
98xaa10	814	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	60	-1	-1	-1
98xaa10	815	0	0	0	0	U	6	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	61	-1	-1	-1
98xaa10	816	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	62	-1	-1	-1
98xaa10	817	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	5	N	-1	-1	-1	-1	-1	-1	13	-1	63	-1	-1	-1
98xaa10	818	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	64	-1	-1	-1
98xaa10	819	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	12	N	-1	-1	-1	-1	-1	-1	13	-1	65	-1	-1	-1
98xaa10	820	0	0	0	0	U	8	7	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	66	-1	-1	-1
98xaa10	821	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	5	N	-1	-1	-1	-1	-1	-1	13	-1	67	-1	-1	-1
98xaa10	822	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	68	-1	-1	-1
100aa01	823	Cuttings from selected SASP 2010 1-0 stock. 	0	0	0	U	19	13	2011-04-25	2011-09-01	DC    	-1	8	Y	-1	-1	-1	-1	-1	-1	13	-1	1	-1	-1	-1
100aa01	824	Cuttings from selected SASP 2010 1-0 stock. Why North row 100%	0	0	0	U	19	19	2011-04-25	2011-09-01	DC    	-1	8	N	-1	-1	-1	-1	-1	-1	13	-1	2	-1	-1	-1
101xaa10	873	end row	0	0	0	U	5	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	51	-1	-1	-1
100aa02	825	Cuttings from selected SASP 2010 1-0 stock. 	0	0	0	U	13	11	2011-04-25	2011-09-01	DC    	-1	8	Y	-1	-1	-1	-1	-1	-1	13	-1	3	-1	-1	-1
100aa02	826	Cuttings from selected SASP 2010 1-0 stock. Why North row 100%	0	0	0	U	11	11	2011-04-25	2011-09-01	DC    	-1	8	N	-1	-1	-1	-1	-1	-1	13	-1	4	-1	-1	-1
100aa03	827	Cuttings from selected SASP 2010 1-0 stock. Best of 4 clones?	0	0	0	U	13	8	2011-04-25	2011-09-01	DC    	-1	8	Y	-1	-1	-1	-1	-1	-1	13	-1	5	-1	-1	-1
100aa03	828	Cuttings from selected SASP 2010 1-0 stock. Why North row ~100%	0	0	0	U	14	13	2011-04-25	2011-09-01	DC    	-1	8	N	-1	-1	-1	-1	-1	-1	13	-1	6	-1	-1	-1
100aa04	829	Cuttings from selected SASP 2010 1-0 stock. 	0	0	0	U	12	10	2011-04-25	2011-09-01	DC    	-1	8	Y	-1	-1	-1	-1	-1	-1	13	-1	7	-1	-1	-1
100aa04	830	Cuttings from selected SASP 2010 1-0 stock. 	0	0	0	U	12	8	2011-04-25	2011-09-01	DC    	-1	8	N	-1	-1	-1	-1	-1	-1	13	-1	8	-1	-1	-1
100xaa10	831	Cutting stock from Bell 2010 nursery	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	9	-1	-1	-1
100xaa10	832	Cutting stock from Bell 2010 nursery	0	0	0	U	6	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	10	-1	-1	-1
100xaa10	833	Cutting stock from Bell 2010 nursery	0	0	0	U	5	3	2011-04-25	2011-09-01	DC    	-1	0	N	-1	-1	-1	-1	-1	-1	13	-1	11	-1	-1	-1
100xaa10	834	Cutting stock from Bell 2010 nursery	0	0	0	U	6	3	2011-04-25	2011-09-01	DC    	-1	1	N	-1	-1	-1	-1	-1	-1	13	-1	12	-1	-1	-1
100xaa10	835	Cutting stock from Bell 2010 nursery	0	0	0	U	6	3	2011-04-25	2011-09-01	DC    	-1	2	N	-1	-1	-1	-1	-1	-1	13	-1	13	-1	-1	-1
100xaa10	836	Cutting stock from Bell 2010 nursery	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	3	N	-1	-1	-1	-1	-1	-1	13	-1	14	-1	-1	-1
100xaa10	837	Cutting stock from Bell 2010 nursery (end row)	0	0	0	U	6	2	2011-04-25	2011-09-01	DC    	-1	4	N	-1	-1	-1	-1	-1	-1	13	-1	15	-1	-1	-1
100xaa10	838	Cutting stock from Bell 2010 nursery (begin row)	0	0	0	U	6	2	2011-04-25	2011-09-01	DC    	-1	5	N	-1	-1	-1	-1	-1	-1	13	-1	16	-1	-1	-1
100xaa10	839	Cutting stock from Bell 2010 nursery	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	6	N	-1	-1	-1	-1	-1	-1	13	-1	17	-1	-1	-1
100xaa10	840	Cutting stock from Bell 2010 nursery PRAVL	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	12	N	-1	-1	-1	-1	-1	-1	13	-1	18	-1	-1	-1
100xaa10	841	Cutting stock from Bell 2010 nursery	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	19	-1	-1	-1
100xaa10	842	Cutting stock from Bell 2010 nursery	0	0	0	U	4	2	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	20	-1	-1	-1
100xaa10	843	Cutting stock from Bell 2010 nursery	0	0	0	U	4	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	21	-1	-1	-1
100xaa10	844	Cutting stock from Bell 2010 nursery	0	0	0	U	4	4	2011-04-25	2011-09-01	DC    	-1	4	N	-1	-1	-1	-1	-1	-1	13	-1	22	-1	-1	-1
100xaa10	845	Cutting stock from Bell 2010 nursery	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	23	-1	-1	-1
83aa218	846	Nice, Get 2010 source details	0	0	0	U	9	9	2011-04-25	2011-09-01	DC    	-1	13	Y	-1	-1	-1	-1	-1	-1	13	-1	24	-1	-1	-1
83aa218	847	Nice, Get 2010 source details	0	0	0	U	8	5	2011-04-25	2011-09-01	DC    	-1	10	N	-1	-1	-1	-1	-1	-1	13	-1	25	-1	-1	-1
83aa203	848	0	0	0	0	U	4	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	26	-1	-1	-1
83aa203	849	0	0	0	0	U	4	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	27	-1	-1	-1
83aa209	850	0	0	0	0	U	7	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	28	-1	-1	-1
83aa209	851	0	0	0	0	U	7	2	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	29	-1	-1	-1
83aa207	852	0	0	0	0	U	5	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	30	-1	-1	-1
83aa207	853	0	0	0	0	U	5	1	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	31	-1	-1	-1
83aa206	854	0	0	0	0	U	8	6	2011-04-25	2011-09-01	DC    	-1	10	Y	-1	-1	-1	-1	170	-1	13	-1	32	-1	-1	-1
83aa206	855	0	0	0	0	U	9	4	2011-04-25	2011-09-01	DC    	-1	6	N	-1	-1	-1	-1	170	-1	13	-1	33	-1	-1	-1
83aa203	856	0	0	0	0	U	7	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	34	-1	-1	-1
83aa203	857	0	0	0	0	U	6	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	35	-1	-1	-1
83aa226	858	0	0	0	0	U	3	1	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	36	-1	-1	-1
83aa226	859	0	0	0	0	U	4	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	37	-1	-1	-1
83aa206	860	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	12	N	-1	-1	-1	-1	170	-1	13	-1	38	-1	-1	-1
83aa206	861	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	10	N	-1	-1	-1	-1	170	-1	13	-1	39	-1	-1	-1
83aa213	862	0	0	0	0	U	7	7	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	40	-1	-1	-1
83aa213	863	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	41	-1	-1	-1
101xaa10	864	0	0	0	0	U	5	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	42	-1	-1	-1
101xaa10	865	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	43	-1	-1	-1
101xaa10	866	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	44	-1	-1	-1
101xaa10	867	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	45	-1	-1	-1
101xaa10	868	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	46	-1	-1	-1
101xaa10	869	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	47	-1	-1	-1
101xaa10	870	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	4	Y	-1	-1	-1	-1	-1	-1	13	-1	48	-1	-1	-1
101xaa10	871	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	49	-1	-1	-1
101xaa10	872	0	0	0	0	U	4	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	50	-1	-1	-1
101xaa10	874	begin row	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	52	-1	-1	-1
101xaa10	875	0	0	0	0	U	4	2	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	53	-1	-1	-1
101xaa10	876	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	54	-1	-1	-1
101xaa10	877	0	0	0	0	U	5	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	55	-1	-1	-1
101xaa10	878	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	56	-1	-1	-1
101xaa10	879	0	0	0	0	U	4	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	57	-1	-1	-1
101xaa10	880	0	0	0	0	U	5	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	58	-1	-1	-1
101xaa10	881	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	59	-1	-1	-1
101xaa10	882	0	0	0	0	U	4	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	60	-1	-1	-1
101xaa10	883	0	0	0	0	U	1	1	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	61	-1	-1	-1
83aa204	884	Cutting stock was 6 with 1 stubby root section. Intended as a 1yr stool.	0	0	0	U	4	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	62	-1	-1	-1
98xaa10	885	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	1	-1	-1	-1
98xaa10	886	0	0	0	0	U	5	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	2	-1	-1	-1
98xaa10	887	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	4	Y	-1	-1	-1	-1	-1	-1	13	-1	3	-1	-1	-1
98xaa10	888	0	0	0	0	U	5	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	4	-1	-1	-1
98xaa10	889	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	5	-1	-1	-1
98xaa10	890	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	6	-1	-1	-1
98xaa10	891	0	0	0	0	U	5	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	7	-1	-1	-1
98xaa10	892	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	8	-1	-1	-1
98xaa10	893	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	9	-1	-1	-1
98xaa10	894	end row	0	0	0	U	5	4	2011-04-25	2011-09-01	DC    	-1	4	Y	-1	-1	-1	-1	-1	-1	13	-1	10	-1	-1	-1
98xaa10	895	begin row	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	11	-1	-1	-1
98xaa10	896	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	12	-1	-1	-1
98xaa10	897	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	6	Y	-1	-1	-1	-1	-1	-1	13	-1	13	-1	-1	-1
98xaa10	898	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	14	-1	-1	-1
98xaa10	899	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	15	-1	-1	-1
98xaa10	900	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	4	Y	-1	-1	-1	-1	-1	-1	13	-1	16	-1	-1	-1
98xaa10	901	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	17	-1	-1	-1
98xaa10	902	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	18	-1	-1	-1
98xaa10	903	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	19	-1	-1	-1
98xaa10	904	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	4	Y	-1	-1	-1	-1	-1	-1	13	-1	20	-1	-1	-1
98xaa10	905	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	21	-1	-1	-1
90xaa10	906	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	13	Y	-1	-1	-1	-1	-1	-1	13	-1	22	-1	-1	-1
90xaa10	907	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	23	-1	-1	-1
90xaa10	908	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	24	-1	-1	-1
90xaa10	909	0	0	0	0	U	6	2	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	25	-1	-1	-1
90xaa10	910	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	26	-1	-1	-1
90xaa10	911	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	12	Y	-1	-1	-1	-1	-1	-1	13	-1	27	-1	-1	-1
90xaa10	912	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	7	N	-1	-1	-1	-1	-1	-1	13	-1	28	-1	-1	-1
90xaa10	913	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	29	-1	-1	-1
90xaa10	914	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	12	Y	-1	-1	-1	-1	-1	-1	13	-1	30	-1	-1	-1
90xaa10	915	0	0	0	0	U	6	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	31	-1	-1	-1
90xaa10	916	0	0	0	0	U	6	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	32	-1	-1	-1
90xaa10	917	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	33	-1	-1	-1
90xaa10	918	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	34	-1	-1	-1
90xaa10	919	end row	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	35	-1	-1	-1
90xaa10	920	begin row	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	36	-1	-1	-1
90xaa10	921	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	37	-1	-1	-1
90xaa10	922	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	38	-1	-1	-1
90xaa10	923	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	39	-1	-1	-1
90xaa10	924	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	40	-1	-1	-1
90xaa10	925	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	8	Y	-1	-1	-1	-1	-1	-1	13	-1	41	-1	-1	-1
90xaa10	926	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	42	-1	-1	-1
90xaa10	927	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	43	-1	-1	-1
90xaa10	928	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	44	-1	-1	-1
90xaa10	929	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	45	-1	-1	-1
90xaa10	930	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	46	-1	-1	-1
90xaa10	931	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	47	-1	-1	-1
90xaa10	932	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	8	Y	-1	-1	-1	-1	-1	-1	13	-1	48	-1	-1	-1
90xaa10	933	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	9	Y	-1	-1	-1	-1	-1	-1	13	-1	49	-1	-1	-1
90xaa10	934	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	50	-1	-1	-1
86xaa10	935	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	10	N	-1	-1	-1	-1	-1	-1	13	-1	51	-1	-1	-1
86xaa10	936	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	52	-1	-1	-1
86xaa10	937	0	0	0	0	U	5	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	53	-1	-1	-1
86xaa10	938	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	6	N	-1	-1	-1	-1	-1	-1	13	-1	54	-1	-1	-1
86xaa10	939	0	0	0	0	U	5	4	2011-04-25	2011-09-01	DC    	-1	6	N	-1	-1	-1	-1	-1	-1	13	-1	55	-1	-1	-1
86xaa10	940	0	0	0	0	U	6	6	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	56	-1	-1	-1
86xaa10	941	0	0	0	0	U	5	6	2011-04-25	2011-09-01	DC    	-1	12	N	-1	-1	-1	-1	-1	-1	13	-1	57	-1	-1	-1
86xaa10	942	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	58	-1	-1	-1
86xaa10	943	end row	0	0	0	U	5	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	59	-1	-1	-1
86xaa10	944	begin row	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	60	-1	-1	-1
86xaa10	945	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	61	-1	-1	-1
86xaa10	946	First Tree is vigorous	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	8	N	-1	-1	-1	-1	-1	-1	13	-1	62	-1	-1	-1
86xaa10	947	0	0	0	0	U	5	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	63	-1	-1	-1
86xaa10	948	0	0	0	0	U	6	3	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	64	-1	-1	-1
86xaa10	949	0	0	0	0	U	6	4	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	65	-1	-1	-1
86xaa10	950	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	66	-1	-1	-1
86xaa10	951	0	0	0	0	U	6	5	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	67	-1	-1	-1
86xaa10	952	0	0	0	0	U	5	2	2011-04-25	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	68	-1	-1	-1
93xaa10	953	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	1	-1	-1	-1
93xaa10	954	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	2	-1	-1	-1
93xaa10	955	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	3	-1	-1	-1
93xaa10	956	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	4	-1	-1	-1
93xaa10	957	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	5	-1	-1	-1
93xaa10	958	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	6	-1	-1	-1
93xaa10	959	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	7	-1	-1	-1
93xaa10	960	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	12	Y	-1	-1	-1	-1	-1	-1	13	-1	8	-1	-1	-1
93xaa10	961	0	0	0	0	U	5	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	9	-1	-1	-1
93xaa10	962	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	8	Y	-1	-1	-1	-1	-1	-1	13	-1	10	-1	-1	-1
93xaa10	963	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	11	-1	-1	-1
93xaa10	964	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	6	Y	-1	-1	-1	-1	-1	-1	13	-1	12	-1	-1	-1
93xaa10	965	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	13	-1	-1	-1
93xaa10	966	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	14	-1	-1	-1
93xaa10	967	end row	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	15	-1	-1	-1
93xaa10	968	begin row	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	16	-1	-1	-1
93xaa10	969	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	17	-1	-1	-1
93xaa10	970	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	18	-1	-1	-1
93xaa10	971	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	19	-1	-1	-1
93xaa10	972	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	20	-1	-1	-1
93xaa10	973	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	21	-1	-1	-1
93xaa10	974	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	22	-1	-1	-1
93xaa10	975	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	23	-1	-1	-1
93xaa10	976	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	24	-1	-1	-1
93xaa10	977	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	25	-1	-1	-1
93xaa10	978	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	26	-1	-1	-1
93xaa10	979	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	27	-1	-1	-1
93xaa10	980	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	28	-1	-1	-1
93xaa10	981	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	29	-1	-1	-1
93xaa10	982	PRAVL - Stock from Dykema 2010	PRAVL	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	12	Y	-1	-1	-1	-1	-1	-1	13	-1	30	-1	-1	-1
103xaa10	983	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	31	-1	-1	-1
103xaa10	984	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	5	N	-1	-1	-1	-1	-1	-1	13	-1	32	-1	-1	-1
103xaa10	985	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	4	N	-1	-1	-1	-1	-1	-1	13	-1	33	-1	-1	-1
103xaa10	986	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	34	-1	-1	-1
103xaa10	987	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	35	-1	-1	-1
103xaa10	988	Remove tags marked with P	0	0	0	U	5	4	2011-05-06	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	36	-1	-1	-1
103xaa10	989	0	0	0	0	U	5	2	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	37	-1	-1	-1
103xaa10	990	Remove tags marked with P	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	4	Y	-1	-1	-1	-1	-1	-1	13	-1	38	-1	-1	-1
103xaa10	991	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	39	-1	-1	-1
103xaa10	992	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	40	-1	-1	-1
103xaa10	993	end row	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	41	-1	-1	-1
103xaa10	994	begin row	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	42	-1	-1	-1
103xaa10	995	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	43	-1	-1	-1
103xaa10	996	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	44	-1	-1	-1
103xaa10	997	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	45	-1	-1	-1
103xaa10	998	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	46	-1	-1	-1
103xaa10	999	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	47	-1	-1	-1
103xaa10	1000	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	48	-1	-1	-1
103xaa10	1001	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	49	-1	-1	-1
103xaa10	1002	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	50	-1	-1	-1
103xaa10	1003	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	51	-1	-1	-1
103xaa10	1004	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	52	-1	-1	-1
86xaa10	1005	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	1	-1	-1	-1
86xaa10	1006	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	2	-1	-1	-1
86xaa10	1007	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	3	-1	-1	-1
86xaa10	1008	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	4	-1	-1	-1
86xaa10	1009	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	5	-1	-1	-1
86xaa10	1010	Yes, this row this column number duplicated	0	0	0	U	5	5	2011-05-06	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	5	-1	-1	-1
86xaa10	1011	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	6	-1	-1	-1
86xaa10	1012	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	7	-1	-1	-1
86xaa10	1013	0	0	0	0	U	6	2	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	8	-1	-1	-1
86xaa10	1014	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	9	Y	-1	-1	-1	-1	-1	-1	13	-1	9	-1	-1	-1
86xaa10	1015	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	10	-1	-1	-1
103xaa10	1016	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	11	-1	-1	-1
103xaa10	1017	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	4	Y	-1	-1	-1	-1	-1	-1	13	-1	12	-1	-1	-1
103xaa10	1018	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	13	-1	-1	-1
103xaa10	1019	end row	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	14	-1	-1	-1
103xaa10	1020	begin row	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	15	-1	-1	-1
103xaa10	1021	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	16	-1	-1	-1
103xaa10	1022	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	17	-1	-1	-1
103xaa10	1023	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	18	-1	-1	-1
96xaa10	1024	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	19	-1	-1	-1
96xaa10	1025	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	20	-1	-1	-1
96xaa10	1026	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	21	-1	-1	-1
96xaa10	1027	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	22	-1	-1	-1
96xaa10	1028	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	23	-1	-1	-1
96xaa10	1029	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	24	-1	-1	-1
96xaa10	1030	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	25	-1	-1	-1
96xaa10	1031	0	0	0	0	U	5	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	26	-1	-1	-1
96xaa10	1032	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	27	-1	-1	-1
96xaa10	1033	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	28	-1	-1	-1
96xaa10	1034	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	29	-1	-1	-1
96xaa10	1035	0	0	0	0	U	5	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	30	-1	-1	-1
96xaa10	1036	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	12	Y	-1	-1	-1	-1	-1	-1	13	-1	31	-1	-1	-1
96xaa10	1037	0	0	0	0	U	5	1	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	32	-1	-1	-1
96xaa10	1038	end row	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	33	-1	-1	-1
96xaa10	1039	begin row	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	34	-1	-1	-1
96xaa10	1040	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	35	-1	-1	-1
96xaa10	1041	0	0	0	0	U	5	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	36	-1	-1	-1
96xaa10	1042	0	0	0	0	U	5	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	37	-1	-1	-1
96xaa10	1043	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	38	-1	-1	-1
96xaa10	1044	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	39	-1	-1	-1
96xaa10	1045	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	40	-1	-1	-1
96xaa10	1046	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	41	-1	-1	-1
96xaa10	1047	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	42	-1	-1	-1
96xaa10	1048	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	43	-1	-1	-1
96xaa10	1049	0	0	0	0	U	6	2	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	44	-1	-1	-1
96xaa10	1050	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	45	-1	-1	-1
96xaa10	1051	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	46	-1	-1	-1
96xaa10	1052	0	0	0	0	U	6	2	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	47	-1	-1	-1
96xaa10	1053	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	48	-1	-1	-1
92xaa10	1054	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	1	-1	-1	-1
92xaa10	1055	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	2	-1	-1	-1
92xaa10	1056	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	6	Y	-1	-1	-1	-1	-1	-1	13	-1	3	-1	-1	-1
92xaa10	1057	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	4	-1	-1	-1
92xaa10	1058	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	5	-1	-1	-1
92xaa10	1059	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	6	-1	-1	-1
92xaa10	1060	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	7	-1	-1	-1
92xaa10	1061	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	8	-1	-1	-1
92xaa10	1062	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	9	Y	-1	-1	-1	-1	-1	-1	13	-1	9	-1	-1	-1
92xaa10	1063	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	10	-1	-1	-1
92xaa10	1064	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	11	-1	-1	-1
92xaa10	1065	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	12	-1	-1	-1
92xaa10	1066	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	13	-1	-1	-1
92xaa10	1067	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	14	-1	-1	-1
92xaa10	1068	end row	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	15	-1	-1	-1
92xaa10	1069	begin row	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	16	-1	-1	-1
92xaa10	1070	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	17	-1	-1	-1
92xaa10	1071	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	18	-1	-1	-1
92xaa10	1072	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	19	-1	-1	-1
92xaa10	1073	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	20	-1	-1	-1
92xaa10	1074	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	21	-1	-1	-1
92xaa10	1075	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	22	-1	-1	-1
92xaa10	1076	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	23	-1	-1	-1
92xaa10	1077	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	24	-1	-1	-1
92xaa10	1078	0	0	0	0	U	6	2	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	25	-1	-1	-1
92xaa10	1079	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	26	-1	-1	-1
92xaa10	1080	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	27	-1	-1	-1
92xaa10	1081	0	0	0	0	U	6	2	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	28	-1	-1	-1
92xaa10	1082	0	0	0	0	U	6	0	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	29	-1	-1	-1
92xaa10	1083	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	30	-1	-1	-1
94xaa10	1084	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	31	-1	-1	-1
94xaa10	1085	0	0	0	0	U	6	2	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	32	-1	-1	-1
94xaa10	1086	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	33	-1	-1	-1
94xaa10	1087	0	0	0	0	U	6	2	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	34	-1	-1	-1
94xaa10	1088	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	35	-1	-1	-1
94xaa10	1089	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	36	-1	-1	-1
94xaa10	1090	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	37	-1	-1	-1
94xaa10	1091	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	38	-1	-1	-1
94xaa10	1092	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	39	-1	-1	-1
94xaa10	1093	end row	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	10	Y	-1	-1	-1	-1	-1	-1	13	-1	40	-1	-1	-1
94xaa10	1094	begin row	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	41	-1	-1	-1
94xaa10	1095	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	42	-1	-1	-1
94xaa10	1096	0	0	0	0	U	5	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	43	-1	-1	-1
94xaa10	1097	0	0	0	0	U	5	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	44	-1	-1	-1
94xaa10	1098	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	5	Y	-1	-1	-1	-1	-1	-1	13	-1	45	-1	-1	-1
94xaa10	1099	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	46	-1	-1	-1
94xaa10	1100	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	47	-1	-1	-1
94xaa10	1101	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	48	-1	-1	-1
94xaa10	1102	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	49	-1	-1	-1
94xaa10	1103	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	50	-1	-1	-1
94xaa10	1104	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	6	Y	-1	-1	-1	-1	-1	-1	13	-1	1	-1	-1	-1
94xaa10	1105	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	2	-1	-1	-1
94xaa10	1106	0	0	0	0	U	6	3	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	3	-1	-1	-1
94xaa10	1107	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	10	N	-1	-1	-1	-1	-1	-1	13	-1	4	-1	-1	-1
94xaa10	1108	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	5	-1	-1	-1
94xaa10	1109	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	6	-1	-1	-1
94xaa10	1110	0	0	0	0	U	6	6	2011-05-06	2011-09-01	DC    	-1	5	N	-1	-1	-1	-1	-1	-1	13	-1	7	-1	-1	-1
94xaa10	1111	0	0	0	0	U	6	4	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	8	-1	-1	-1
94xaa10	1112	0	0	0	0	U	6	5	2011-05-06	2011-09-01	DC    	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	9	-1	-1	-1
15ag4mf	1113	WASP stock started from Brads rootlings, planted as ASP plugs. Tallest was 10' on 9/1/11	0	0	0	U	100	100	2011-06-01	2011-09-01	ASP   	8	2	Y	-1	-1	-1	-1	-1	-1	13	-1	10	-1	-1	-1
83aa204	1114	Cuttings started from sylleptic stems. Planted as ASP plugs. Tallest was 8' on 9/1/11	0	0	0	U	110	110	2011-06-01	2011-09-01	WASP  	8	2	N	-1	-1	-1	-1	-1	-1	13	-1	1	-1	-1	-1
41aa111	1115	0	0	0	0	U	5	5	2011-06-01	2011-09-01	1-0   	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	2	-1	-1	-1
41aa111	1116	0	0	0	0	U	10	10	2011-06-01	2011-09-01	WASP  	8	-1	N	-1	-1	-1	-1	-1	-1	13	-1	3	-1	-1	-1
a502	1117	0	0	0	0	U	7	7	2011-06-01	2011-09-01	WASP  	8	-1	N	-1	-1	-1	-1	-1	-1	13	-1	4	-1	-1	-1
83aa204	1118	SCP - Somclonal Propagation (Induced shoots on cutting top), Changed to RS (Root Shoot).	0	0	0	U	14	14	2011-07-02	2011-09-01	RS    	12	-1	N	-1	-1	-1	-1	-1	-1	13	-1	1	-1	-1	-1
1xcagw	1119	0	0	0	0	U	7	7	2011-07-02	2011-09-01	SEL   	-1	-1	Y	-1	-1	-1	-1	-1	-1	13	-1	2	-1	-1	-1
1xaw11	1120	Seeded 5/14/11, Planted 7/2/11. 3 have AG characteristics	0	0	0	U	48	23	2011-07-02	2011-09-01	SEL   	-1	-1	Y	-1	-1	-1	-1	-1	-1	13	-1	3	-1	-1	-1
1xcagw	1121	Seeded 5/30/11, Planted 7/16/11	0	0	0	U	22	22	2011-07-16	2011-09-01	SEL   	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	4	-1	-1	-1
1xcagw	1122	Seeded 5/30/11, Planted 7/16/11. About 60/40% Alba/Aspen characteristics. Losses from rabbits.	0	0	0	U	130	122	2011-07-16	2011-09-01	SEL   	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	1	-1	-1	-1
1xcagw	1123	Seeded 5/30/11, Planted 7/16/11. About 60/40% Alba/Aspen characteristics. Losses from rabbits.	0	0	0	U	130	96	2011-07-16	2011-09-01	SEL   	-1	-1	N	-1	-1	-1	-1	-1	-1	13	-1	2	-1	-1	-1
90xaa10	1124	 2012: Start rep 1, row 1, (FYI: NOTES2 = 2011-ID, which is id_prev_test_detail). Biased = edge effect	969	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	1	1	1	-1	-1
86xaa10	1125	Biased = 1, edge effect	993	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	1	2	1	-1	-1
103xaa10	1126	Biased = 1, edge effect	1036	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	1	3	1	-1	-1
92xaa10	1127	Biased = 1, edge effect	1105	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	1	4	1	-1	-1
98xaa10	1128	Biased = 1, edge effect, leaf spots on lower leaves	936	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	3	14	1	5	1	-1	-1
86xaa10	1129	Biased = 1, edge effect, nice!	1060	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	1	6	1	-1	-1
92xaa10	1130	Biased = 1, edge effect	1108	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	3	14	1	7	1	-1	-1
90xaa10	1131	Biased = 1, edge effect. Nice! Largest dia=23mm at collar.	968	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	4	14	1	8	1	-1	-1
86xaa10	1132	Biased = 1, edge effect	1056	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	1	9	1	-1	-1
98xaa10	1133	Biased = 1, edge effect. short...	942	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	3	14	1	10	1	-1	-1
93xaa10	1134	Biased = 1, edge effect. Nice! Largest dia=23mm at collar.	1028	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	4	14	1	11	1	-1	-1
98xaa10	1135	Biased = -2, nursery bad spot - needs soil test.	946	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	1	12	1	-1	-1
90xaa10	1136	Biased = -2, nursery bad spot - needs soil test.	960	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	1.1	-1	-1	-1	-1	3	14	1	13	1	-1	-1
90xaa10	1137	Biased = -2, nursery bad spot - needs soil test.	971	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	1.1	-1	-1	-1	-1	4	14	1	14	1	-1	-1
83aa204	1138	Biased = -2, nursery bad spot - needs soil test.	773	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	1	15	1	-1	-1
83aa204	1139	Biased = -2, nursery bad spot - needs soil test. Interesting - poor	773	0	0	U	10	2	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	1	16	1	-1	-1
100xaa10	1140	Biased = -2, nursery bad spot - needs soil test.	670	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.4	-1	-1	-1	-1	3	14	1	17	1	-1	-1
102xaa10	1141	Biased = -2, nursery bad spot - needs soil test.	728	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	3	14	1	18	1	-1	-1
100xaa10	1142	Biased = -2, nursery bad spot - needs soil test.	668	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	3	14	1	19	1	-1	-1
102xaa10	1143	Biased = -2, nursery bad spot - needs soil test.	736	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	3	14	1	20	1	-1	-1
100aa03	1144	Biased = -2, nursery bad spot - needs soil test.	873	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	1	21	1	-1	-1
83aa216	1145	Biased = -2, nursery bad spot - needs soil test.	763	0	0	U	10	3	2012-04-06	2012-09-12	DC    	15	-1	U	1.4	-1	-1	-1	-1	4	14	1	22	1	-1	-1
83aa206	1146	Biased = -2, nursery bad spot - needs soil test.	900	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	1	23	1	-1	-1
104xaa10	1147	Biased = -2, nursery bad spot - needs soil test.	801	0	0	U	10	0	2012-04-06	2012-09-12	DC    	15	-1	U	0	-1	-1	-1	-1	4	14	1	24	1	-1	-1
104xaa10	1148	End rep1, row1.  Biased = -2, nursery bad spot - needs soil test.	818	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	1	25	1	-1	-1
92xaa10	1149	Start rep1, row 2, col 1. Biased=edge of row	1102	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	2	1	1	-1	-1
103xaa10	1150	Nice!	1034	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	2	2	1	-1	-1
96xaa10	1151	Bad	1073	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	2	3	1	-1	-1
98xaa10	1152	0	933	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	2	4	1	-1	-1
93xaa10	1153	0	1025	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	2	5	1	-1	-1
86xaa10	1154	0	1052	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	2	6	1	-1	-1
86xaa10	1155	0	1055	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	2	7	1	-1	-1
103xaa10	1156	0	1063	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	2	8	1	-1	-1
93xaa10	1157	0	1006	0	0	U	10	2	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	2	9	1	-1	-1
90xaa10	1158	0	978	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	2	10	1	-1	-1
98xaa10	1159	0	943	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	2	11	1	-1	-1
93xaa10	1160	0	1010	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	2	12	1	-1	-1
93xaa10	1161	Biased= -2, Bad nusery area.	1008	0	0	U	10	3	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	2	13	1	-1	-1
100xaa10	1162	Biased= -2, Bad nusery area.	679	0	0	U	10	3	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	3	14	2	14	1	-1	-1
100xaa10	1163	Biased= -2, Bad nusery area.	687	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	4	14	2	15	1	-1	-1
95xaa10	1164	Biased= -2, Bad nusery area.	722	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	2	16	1	-1	-1
83aa212	1165	Biased= -2, Bad nusery area.	753	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	3	14	2	17	1	-1	-1
102xaa10	1166	Biased= -2, Bad nusery area.	732	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	3	14	2	18	1	-1	-1
83aa215	1167	Biased= -2, Bad nusery area.	751	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	2	19	1	-1	-1
104xaa10	1168	Biased= -2, Bad nusery area.	814	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	2	14	2	20	1	-1	-1
83aa206	1169	Biased= -2, Bad nusery area.	900	0	0	U	10	1	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	3	14	2	21	1	-1	-1
104xaa10	1170	Biased= -2, Bad nusery area.	808	0	0	U	10	2	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	3	14	2	22	1	-1	-1
100xaa10	1171	Biased= -2, Bad nusery area.	886	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	3	14	2	23	1	-1	-1
104xaa10	1172	Biased= -2, Bad nusery area.	810	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	2	24	1	-1	-1
101xaa10	1173	End rep1, row2.  Biased= -2, Bad nusery area.	911	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	2	25	1	-1	-1
99xaa10	1174	Start rep1, row 3, col 1	644	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	4	14	3	1	1	-1	-1
100xaa10	1175	0	675	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	3	2	1	-1	-1
100xaa10	1176	0	692	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	3	3	1	-1	-1
83aa227	1177	0	775	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	3	14	3	4	1	-1	-1
41aa111	1178	0	757	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	3	5	1	-1	-1
100aa01	1179	0	869	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	3	6	1	-1	-1
97xaa10	1180	0	830	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	3	7	1	-1	-1
100aa04	1181	0	875	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	3	8	1	-1	-1
97xaa10	1182	0	845	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	3	9	1	-1	-1
100xaa10	1183	0	912	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.3	-1	-1	-1	-1	4	14	3	10	1	-1	-1
91xaa10	1184	0	605	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	3	14	3	11	1	-1	-1
91xaa10	1185	Biased= -2, Bad nusery area.	613	0	0	U	10	2	2012-04-06	2012-09-12	DC    	15	-1	U	0.4	-1	-1	-1	-1	3	14	3	12	1	-1	-1
83aa221	1186	Biased= -2, Bad nusery area.	526	0	0	U	10	0	2012-04-06	2012-09-12	DC    	15	-1	U	0	-1	-1	-1	-1	3	14	3	13	1	-1	-1
96xaa10	1187	Biased= -2, Bad nusery area.	1099	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	3	14	3	14	1	-1	-1
98xaa10	1188	Biased= -2, Bad nusery area.	950	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	3	14	3	15	1	-1	-1
86xaa10	1189	Biased= -2, Bad nusery area.	981	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	3	16	1	-1	-1
83aa218	1190	0	892	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	3	14	3	17	1	-1	-1
86xaa10	1191	0	987	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	3	14	3	18	1	-1	-1
86xaa10	1192	End rep1, row3	984	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	3	14	3	19	1	-1	-1
100xaa10	1193	Start rep1, row 4, col 1	686	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	4	14	4	1	1	-1	-1
99xaa10	1194	0	629	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	4	2	1	-1	-1
100xaa10	1195	Very NICE! Sylleptical	681	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	1.4	-1	-1	-1	-1	4	14	4	3	1	-1	-1
83aa107	1196	0	771	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	3	14	4	4	1	-1	-1
83aa216	1197	0	763	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	4	5	1	-1	-1
100aa02	1198	0	871	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	3	14	4	6	1	-1	-1
97xaa10	1199	0	853	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	4	7	1	-1	-1
101xaa10	1200	0	928	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	4	14	4	8	1	-1	-1
101xaa10	1201	0	916	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	4	9	1	-1	-1
101xaa10	1202	0	915	0	0	U	10	1	2012-04-06	2012-09-12	DC    	15	-1	U	0.3	-1	-1	-1	-1	1	14	4	10	1	-1	-1
91xaa10	1203	0	615	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.4	-1	-1	-1	-1	3	14	4	11	1	-1	-1
91xaa10	1204	Biased= -2, Bad nusery area.	617	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.3	-1	-1	-1	-1	3	14	4	12	1	-1	-1
89xxaa10	1205	Biased= -2, Bad nusery area.	585	0	0	U	10	1	2012-04-06	2012-09-12	DC    	15	-1	U	1.3	-1	-1	-1	-1	3	14	4	13	1	-1	-1
91xaa10	1206	Biased= -2, Bad nusery area.	592	0	0	U	10	2	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	4	14	1	-1	-1
90xaa10	1207	Biased= -2, Bad nusery area.	957	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	3	14	4	15	1	-1	-1
90xaa10	1208	Biased= -2, Bad nusery area.	952	0	0	U	10	3	2012-04-06	2012-09-12	DC    	15	-1	U	0.4	-1	-1	-1	-1	4	14	4	16	1	-1	-1
98xaa10	1209	Biased= -2, Bad nusery area.	940	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	3	14	4	17	1	-1	-1
86xaa10	1210	Biased= -2, Bad nusery area.	985	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	3	14	4	18	1	-1	-1
103xaa10	1211	End rep1, row4, Biased= -2, Bad nusery area.	1039	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	3	14	4	19	1	-1	-1
83aa216	1212	Sart REP2, row1,  Biased= -2, Bad nusery area & pre-rooted cuttings.	763	0	0	U	10	2	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	3	14	1	1	2	-1	-1
104xaa10	1213	Bad nusery area & pre-rooted cuttings.0	818	0	0	U	10	2	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	3	14	1	2	2	-1	-1
83aa107	1214	dead - Bad nusery area & pre-rooted cuttings.	771	0	0	U	10	0	2012-04-06	2012-09-12	DC    	15	-1	U	0	-1	-1	-1	-1	0	14	1	3	2	-1	-1
100xaa10	1215	Bad nusery area & pre-rooted cuttings.	675	0	0	U	10	2	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	3	14	1	4	2	-1	-1
83aa204	1216	Bad nusery area & pre-rooted cuttings.	773	0	0	U	10	2	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	3	14	1	5	2	-1	-1
104xaa10	1217	Bad nusery area & pre-rooted cuttings.	801	0	0	U	10	0	2012-04-06	2012-09-12	DC    	15	-1	U	0	-1	-1	-1	-1	0	14	2	1	2	-1	-1
41aa111	1218	Bad nusery area & pre-rooted cuttings.	757	0	0	U	10	0	2012-04-06	2012-09-12	DC    	15	-1	U	0	-1	-1	-1	-1	0	14	2	2	2	-1	-1
83aa227	1219	Bad nusery area & pre-rooted cuttings.	775	0	0	U	10	0	2012-04-06	2012-09-12	DC    	15	-1	U	0	-1	-1	-1	-1	0	14	2	3	2	-1	-1
101xaa10	1220	Bad nusery area & pre-rooted cuttings.	911	0	0	U	10	0	2012-04-06	2012-09-12	DC    	15	-1	U	0	-1	-1	-1	-1	0	14	2	4	2	-1	-1
100xaa10	1221	Bad nusery area & pre-rooted cuttings.	679	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	2	5	2	-1	-1
99xaa10	1222	Start rep2, row 3, col 1	629	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	3	1	2	-1	-1
91xaa10	1223	0	617	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	4	14	3	2	2	-1	-1
89xxaa10	1224	0	585	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	3	3	2	-1	-1
91xaa10	1225	0	615	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	3	4	2	-1	-1
102xaa10	1226	0	732	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	3	5	2	-1	-1
100xaa10	1227	0	670	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	3	6	2	-1	-1
100xaa10	1228	0	686	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	3	7	2	-1	-1
83aa215	1229	0	751	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	3	8	2	-1	-1
102xaa10	1230	0	736	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	3	9	2	-1	-1
95xaa10	1231	0	722	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	4	14	3	10	2	-1	-1
83aa204	1232	0	773	0	0	U	10	3	2012-04-06	2012-09-12	DC    	15	-1	U	0.4	-1	-1	-1	-1	4	14	3	11	2	-1	-1
83aa216	1233	0	763	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	3	12	2	-1	-1
100xaa10	1234	0	886	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	1.1	-1	-1	-1	-1	4	14	3	13	2	-1	-1
83aa206	1235	0	900	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	3	14	2	-1	-1
100aa03	1236	0	873	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	3	15	2	-1	-1
98xaa10	1237	0	950	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	3	14	3	16	2	-1	-1
90xaa10	1238	0	978	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	3	17	2	-1	-1
86xaa10	1239	0	987	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	3	14	3	18	2	-1	-1
86xaa10	1240	0	984	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	3	19	2	-1	-1
90xaa10	1241	Biased= 1, edge	969	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	3	20	2	-1	-1
98xaa10	1242	0	943	0	0	U	10	0	2012-04-06	2012-09-12	DC    	15	-1	U	0	-1	-1	-1	-1	4	14	3	21	2	-1	-1
86xaa10	1243	0	1060	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	3	22	2	-1	-1
103xaa10	1244	0	1036	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	3	23	2	-1	-1
86xaa10	1245	0	1055	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	4	14	3	24	2	-1	-1
93xaa10	1246	End rep2, row3	1008	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	3	25	2	-1	-1
99xaa10	1247	Biased= 1, edge	644	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	1.3	-1	-1	-1	-1	4	14	4	1	2	-1	-1
91xaa10	1248	Biased= 1, edge	592	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	4	2	2	-1	-1
83aa221	1249	Biased= 1, edge	526	0	0	U	10	2	2012-04-06	2012-09-12	DC    	15	-1	U	0.3	-1	-1	-1	-1	4	14	4	3	2	-1	-1
91xaa10	1250	Biased= 1, edge	605	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	1.1	-1	-1	-1	-1	3	14	4	4	2	-1	-1
91xaa10	1251	0	613	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	4	5	2	-1	-1
100xaa10	1252	0	681	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	4	14	4	6	2	-1	-1
83aa212	1253	0	753	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	4	7	2	-1	-1
100xaa10	1254	0	687	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	3	14	4	8	2	-1	-1
100xaa10	1255	0	692	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	1.3	-1	-1	-1	-1	4	14	4	9	2	-1	-1
102xaa10	1256	0	728	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	4	10	2	-1	-1
100xaa10	1257	0	668	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	4	14	4	11	2	-1	-1
104xaa10	1258	good	810	0	0	U	10	10	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	3	14	4	12	2	-1	-1
83aa206	1259	0	900	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	4	13	2	-1	-1
104xaa10	1260	0	808	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	4	14	4	14	2	-1	-1
104xaa10	1261	0	814	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	4	15	2	-1	-1
86xaa10	1262	bad form	981	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	4	16	2	-1	-1
98xaa10	1263	0	940	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	4	17	2	-1	-1
103xaa10	1264	0	1039	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	4	18	2	-1	-1
86xaa10	1265	bad form	993	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	4	19	2	-1	-1
90xaa10	1266	0	952	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	4	20	2	-1	-1
83aa218	1267	0	892	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	4	14	4	21	2	-1	-1
93xaa10	1268	0	1025	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	4	22	2	-1	-1
86xaa10	1269	bad form	1052	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.3	-1	-1	-1	-1	4	14	4	23	2	-1	-1
92xaa10	1270	Nice!	1102	0	0	U	10	10	2012-04-06	2012-09-12	DC    	15	-1	U	1.1	-1	-1	-1	-1	4	14	4	24	2	-1	-1
92xaa10	1271	0	1108	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	4	25	2	-1	-1
93xaa10	1272	End rep2, row4	1006	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	4	26	2	-1	-1
86xaa10	1273	Biased= 1, edge	1056	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	4	14	5	1	2	-1	-1
93xaa10	1274	Biased= 1, edge	1010	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	5	2	2	-1	-1
103xaa10	1275	0	1063	0	0	U	10	10	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	5	3	2	-1	-1
86xaa10	1276	0	985	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	5	4	2	-1	-1
90xaa10	1277	0	968	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	4	14	5	5	2	-1	-1
98xaa10	1278	0	933	0	0	U	10	10	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	5	6	2	-1	-1
90xaa10	1279	0	960	0	0	U	10	10	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	5	7	2	-1	-1
93xaa10	1280	0	1028	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	3	14	5	8	2	-1	-1
92xaa10	1281	Biased= 1, edge	1105	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	3	14	6	1	2	-1	-1
103xaa10	1282	Biased= 1, edge	1034	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	3	14	6	2	2	-1	-1
96xaa10	1283	Biased= 1, edge	1023	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	6	3	2	-1	-1
96xaa10	1284	Biased= 1, edge	1099	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	4	14	6	4	2	-1	-1
98xaa10	1285	Biased= 1, edge	936	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	6	5	2	-1	-1
90xaa10	1286	Biased= 1, edge	971	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	6	6	2	-1	-1
98xaa10	1287	Biased= 1, edge	942	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	1.1	-1	-1	-1	-1	4	14	6	7	2	-1	-1
98xaa10	1288	Biased= 1, edge	946	0	0	U	10	10	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	6	8	2	-1	-1
90xaa10	1289	End rep2	957	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	6	9	2	-1	-1
100aa01	1290	Sart REP3, row1	869	0	0	U	10	3	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	1	1	3	-1	-1
83aa215	1291	0	751	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	1	2	3	-1	-1
83aa212	1292	0	753	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	1	3	3	-1	-1
83aa204	1293	0	773	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	1	4	3	-1	-1
83aa212	1294	0	753	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	1	5	3	-1	-1
100xaa10	1295	was missed	912	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	1	6	3	-1	-1
100aa02	1296	0	871	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	1	7	3	-1	-1
101xaa10	1297	0	928	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	1	8	3	-1	-1
100aa04	1298	0	875	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	1	9	3	-1	-1
100aa01	1299	0	869	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	1	10	3	-1	-1
92xaa10	1300	0	1102	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	1	11	3	-1	-1
83aa218	1301	Biased= 1, edge	892	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	1	12	3	-1	-1
100aa02	1302	0	871	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	3	14	2	1	3	-1	-1
100aa04	1303	poor	875	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	3	14	2	2	3	-1	-1
83aa204	1304	poor	773	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	3	14	2	3	3	-1	-1
100xaa10	1305	poor - decieving (compare)	675	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	1.3	-1	-1	-1	-1	3	14	2	4	3	-1	-1
83aa215	1306	0	751	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	3	14	2	5	3	-1	-1
97xaa10	1307	Nice!	853	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	2	6	3	-1	-1
101xaa10	1308	0	916	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	2	7	3	-1	-1
97xaa10	1309	0	830	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	4	14	2	8	3	-1	-1
97xaa10	1310	Nice!	845	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	2	9	3	-1	-1
101xaa10	1311	0	915	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	2	10	3	-1	-1
92xaa10	1312	0	1108	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	2	11	3	-1	-1
93xaa10	1313	0	1028	0	0	U	10	3	2012-04-06	2012-09-12	DC    	15	-1	U	1.5	-1	-1	-1	-1	4	14	2	12	3	-1	-1
93xaa10	1314	End rep3, row2	1028	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	4	14	2	13	3	-1	-1
93xaa10	1315	Sart REP3, row3 -  Flat 1 test	525	0	0	U	10	2	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	4	14	3	1	3	-1	-1
94aa101	1316	variagated alba	528	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	3	3	3	-1	-1
83aa227	1317	verify this key #######	775	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	1.6	-1	-1	-1	-1	4	14	3	5	3	-1	-1
83aa216	1318	0	763	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	3	6	3	-1	-1
104xaa10	1319	0	808	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	3	7	3	-1	-1
100aa03	1320	0	873	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	0.4	-1	-1	-1	-1	4	14	3	8	3	-1	-1
104xaa10	1321	0	801	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	3	14	3	9	3	-1	-1
104xaa10	1322	0	818	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	4	14	3	10	3	-1	-1
90xaa10	1323	0	952	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	4	14	3	11	3	-1	-1
83aa206	1324	End rep3, row3	900	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	3	12	3	-1	-1
93xaa10	1325	Sart REP3, row4	525	0	0	U	10	3	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	4	14	4	1	3	-1	-1
93xaa10	1326	Flat 2 test - same clones in f2?	1372	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	1.5	-1	-1	-1	-1	4	14	4	2	3	-1	-1
93xaa10	1327	Flat 2 test - same clones in f2?	1373	0	0	U	10	4	2012-04-06	2012-09-12	DC    	15	-1	U	1.4	-1	-1	-1	-1	3	14	4	3	3	-1	-1
41aa111	1328	0	757	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.8	-1	-1	-1	-1	3	14	4	4	3	-1	-1
83aa216	1329	0	763	0	0	U	10	3	2012-04-06	2012-09-12	DC    	15	-1	U	1.3	-1	-1	-1	-1	4	14	4	5	3	-1	-1
83aa206	1330	0	900	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	4	6	3	-1	-1
104xaa10	1331	0	814	0	0	U	10	7	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	4	14	4	7	3	-1	-1
100xaa10	1332	0	886	0	0	U	10	8	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	4	14	4	8	3	-1	-1
104xaa10	1333	0	801	0	0	U	10	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	3	14	4	9	3	-1	-1
104xaa10	1334	0	814	0	0	U	10	6	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	4	14	4	10	3	-1	-1
98xaa10	1335	0	942	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.9	-1	-1	-1	-1	4	14	4	11	3	-1	-1
104xaa10	1336	End rep3, row4	808	0	0	U	10	9	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	4	14	4	12	3	-1	-1
1xcagw	1337	8/26 rooting=  2/6 aspen type	1168	0	0	U	6	2	2012-04-06	2012-09-12	DC    	15	-1	U	0.5	-1	-1	-1	-1	1	14	5	1	3	-1	-1
1xcagw	1338	8/26 rooting=  4/7 aspen type	1168	0	0	U	7	4	2012-04-06	2012-09-12	DC    	15	-1	U	0.6	-1	-1	-1	-1	0	14	5	2	3	-1	-1
1xaw	1339	8/26 rooting= 5/7 alba type	1166	0	0	U	8	5	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	0	14	5	3	3	-1	-1
1xaw	1340	8/26 rooting= 5/6 alba type	1166	0	0	U	6	5	2012-04-06	2012-09-12	DC    	15	-1	U	0.7	-1	-1	-1	-1	0	14	5	4	3	-1	-1
1xcagw	1341	8/26 rooting= 0/7 alba type Biased=1, edge	1168	0	0	U	7	0	2012-04-06	2012-09-12	DC    	15	-1	U	0	-1	-1	-1	-1	1	14	5	5	3	-1	-1
1xcagw	1342	8/26 rooting= 0/7 alba type	1168	0	0	U	7	0	2012-04-06	2012-09-12	DC    	15	-1	U	0	-1	-1	-1	-1	1	14	5	6	3	-1	-1
1xcagw	1343	8/26 rooting= 5/7 alba type - Yellow tagged	1168	0	0	U	7	6	2012-04-06	2012-09-12	DC    	15	-1	U	1.3	-1	-1	-1	-1	1	14	5	7	3	-1	-1
1xcagw	1344	8/26 rooting=  5/6 aspen type	1168	0	0	U	6	5	2012-04-06	2012-09-12	DC    	15	-1	U	1.2	-1	-1	-1	-1	1	14	6	1	3	-1	-1
1bw1	1345	8/26 rooting=  6/6 Excellent! Aspen type. amily 1xCAGW. Selected as 1CAGW01	1168	0	0	U	6	6	2012-04-06	2012-09-12	DC    	15	-1	U	1.5	-1	-1	-1	-1	1	14	6	2	3	-1	-1
1xaw	1346	8/26 rooting=  2/6  Potential AG - Yellow tagged	1166	0	0	U	6	2	2012-04-06	2012-09-12	DC    	15	-1	U	1	-1	-1	-1	-1	1	14	6	3	3	-1	-1
1xaw	1347	8/26 rooting=  0/6 aspen type	1166	0	0	U	6	0	2012-04-06	2012-09-12	DC    	15	-1	U	0	-1	-1	-1	-1	1	14	6	4	3	-1	-1
1cagw02	1348	8/26 rooting=  4/8 alba type - Vigorous - Family 1xCAGW	1168	0	0	U	8	4	2012-04-06	2012-09-12	DC    	15	-1	U	1.3	-1	-1	-1	-1	1	14	6	5	3	-1	-1
1xcagw	1349	8/26 rooting=  4/8 aspen type - has very thin terminal tips and leaves - bad - Clone for poor aspen rooter	1168	0	0	U	7	4	2012-04-06	2012-09-12	DC    	15	-1	U	1.8	-1	-1	-1	-1	1	14	6	6	3	-1	-1
1cagw03	1350	8/26 rooting= 6/7 aspen type - Vigorous - Family 1xCAGW	1168	0	0	U	7	6	2012-04-06	2012-09-12	DC    	15	-1	U	1.3	-1	-1	-1	-1	1	14	6	7	3	-1	-1
brads80x	1352	5/14 rooting=  0/6 - WASP	-1	0	0	U	3	0	2012-04-06	2012-09-12	WASP  	15	-1	U	0	-1	-1	-1	-1	1	14	6	9	3	-1	-1
c173	1353	1/3 survived Planted 3 WASP tip cuttings - WASP (30' tall)	1	0	0	U	3	1	2012-04-06	2012-09-12	WASP  	15	-1	U	0.7	-1	-1	-1	-1	1	14	6	10	3	-1	-1
15ag4mf	1354	Wasp - planted 5/5/12 qty 13 - WASP	1	0	0	U	20	11	2012-04-06	2012-09-12	WASP  	15	-1	U	1	-1	-1	-1	-1	1	14	6	11	3	-1	-1
2xb	1355	Seed date= ?, Plant date= ???  SE (estimated counts)	2	0	0	U	70	40	2012-04-06	2012-09-12	SEL   	15	-1	U	-1	-1	-1	-1	-1	1	14	6	12	3	-1	-1
2xb	1356	Seed date= ?, Plant date= ???  SE (estimated counts)	2	0	0	U	250	200	2012-04-06	2012-09-12	SEL   	15	-1	U	-1	-1	-1	-1	-1	1	14	8	1	3	-1	-1
2xb	1357	Seed date= ?, Plant date= ???  SE (estimated counts)	2	0	0	U	70	50	2012-04-06	2012-09-12	SEL   	15	-1	U	-1	-1	-1	-1	-1	1	14	10	1	3	-1	-1
1xcagw	1358	Seed date= ?, Plant date= ???  SE (estimated counts)	2	0	0	U	10	10	2012-04-06	2012-09-12	SEL   	15	-1	U	-1	-1	-1	-1	-1	1	14	10	2	3	-1	-1
41aa111	1364	Qty 3 -  - 1-0	2	0	0	U	3	3	2012-04-06	2012-09-12	1-0   	15	-1	U	1.2	-1	-1	-1	-1	2	14	1	6	4	-1	-1
nfa	1365	Qty 3   - 1-0 - Lots of leaf spots 	765	0	0	U	3	3	2012-04-06	2012-09-12	1-0   	15	-1	U	1.2	-1	-1	-1	-1	2	14	1	7	4	-1	-1
83aa1mf	1366	Qty 2   - 1-0	789	0	0	U	2	2	2012-04-06	2012-09-12	1-0   	15	-1	U	1.2	-1	-1	-1	-1	2	14	1	8	4	-1	-1
a502	1367	Qty 2   - 1-0	755	0	0	U	2	2	2012-04-06	2012-09-12	1-0   	15	-1	U	1	-1	-1	-1	-1	2	14	1	9	4	-1	-1
zoss	1368	Qty 2   - 1-0	2	0	0	U	2	2	2012-04-06	2012-09-12	1-0   	15	-1	U	0.7	-1	-1	-1	-1	2	14	1	10	4	-1	-1
83aa2mf	1369	Qty 2   - 1-0 - was 83aa-uo7m-7-14 (7-4)	2	0	0	U	2	2	2012-04-06	2012-09-12	1-0   	15	-1	U	1	-1	-1	-1	-1	2	14	1	11	4	-1	-1
94aa101	1370	Qty 1 Variagated  - 1-0 - Not much variagation, only on N half	528	0	0	U	1	1	2012-04-06	2012-09-12	1-0   	15	-1	U	1	-1	-1	-1	-1	2	14	1	12	4	-1	-1
40aa6mf	1371	Qty1  - 1-0	858	0	0	U	1	0	2012-04-06	2012-09-12	1-0   	15	-1	U	1	-1	-1	-1	-1	2	14	1	13	4	-1	-1
2ww	1372	Willow - CC gold qty 2  - 1-0	0	0	0	U	2	1	2012-04-06	2012-09-12	1-0   	15	-1	U	1	-1	-1	-1	-1	0	14	1	14	4	-1	-1
wasp-2013-01-12-ae1	1374	Clone 93AA12, No soak, rep #1, 8 - 10 cm cuttings, 2 week root test	0	0	0	U	8	6	2013-01-12	2013-01-26	DC    	10	4.75	Y	-1	-1	-1	-1	-1	-1	18	-1	-1	1	-1	-1
wasp-2013-01-12-ae2	1375	Clone 93AA12, No soak, rep #2, 8 - 10 cm cuttings, 2 week root test	0	0	0	U	8	8	2013-01-12	2013-01-26	DC    	10	5	Y	-1	-1	-1	-1	-1	-1	18	-1	-1	2	-1	-1
1wx	1376	 Willow 2013: Start - North row 1	1	1	0	U	1	1	2013-04-20	2013-09-21	1-1   	120	-1	U	35	-1	-1	-1	-1	-1	20	1	1	0	-1	-1
nfa	1378	7' tall, leaf spots	3	3	0	U	1	1	2013-04-20	2013-09-21	1-1   	120	-1	U	20	-1	-1	-1	-1	-1	20	1	3	0	-1	-1
83aa1mf	1379	Nice Diameter	4	4	0	U	2	2	2013-04-20	2013-09-21	1-1   	120	-1	Y	24	-1	-1	-1	-1	-1	20	1	4	0	-1	-1
a502	1380	0	5	5	0	U	2	2	2013-04-20	2013-09-21	1-1   	120	-1	U	18	-1	-1	-1	-1	-1	20	1	5	0	-1	-1
c173	1381	0	6	6	0	U	1	1	2013-04-20	2013-09-21	1-1   	120	-1	U	15	-1	-1	-1	-1	-1	20	1	6	0	-1	-1
zoss	1382	alba like leaves	7	7	0	U	1	1	2013-04-20	2013-09-21	1-1   	120	-1	U	12	-1	-1	-1	-1	-1	20	1	7	0	-1	-1
83aa2mf	1383	weaker than 83aa1mf (soil?)	8	8	0	U	2	2	2013-04-20	2013-09-21	1-0   	120	-1	U	12	-1	-1	-1	-1	-1	20	1	8	0	-1	-1
94aa101	1384	Not much variegation	9	9	0	U	1	1	2013-04-20	2013-09-21	1-0   	120	-1	U	12	-1	-1	-1	-1	-1	20	1	9	0	-1	-1
41aa111	1385	4' tall	10	10	0	U	1	1	2013-04-20	2013-09-21	1-0   	120	-1	U	9	-1	-1	-1	-1	-1	20	1	10	0	-1	-1
2b21	1386	0	11	11	0	U	1	1	2013-04-20	2013-09-21	1-0   	120	-1	U	10	-1	-1	-1	-1	-1	20	1	11	0	-1	-1
2b29	1387	0	12	12	0	U	1	1	2013-04-20	2013-09-21	1-0   	120	-1	U	10	-1	-1	-1	-1	-1	20	1	12	0	-1	-1
2b26	1388	0	13	13	0	U	1	1	2013-04-20	2013-09-21	1-0   	120	-1	U	11	-1	-1	-1	-1	-1	20	1	13	0	-1	-1
2b27	1389	0	14	14	0	U	1	1	2013-04-20	2013-09-21	1-0   	120	-1	U	9	-1	-1	-1	-1	-1	20	1	14	0	-1	-1
2b3	1390	0	15	15	0	U	1	1	2013-04-20	2013-09-21	1-0   	120	-1	U	12	-1	-1	-1	-1	-1	20	1	15	0	-1	-1
2b28	1391	0	16	16	0	U	1	1	2013-04-20	2013-09-21	1-0   	120	-1	U	10	-1	-1	-1	-1	-1	20	1	16	0	-1	-1
2b2	1392	0	17	17	0	U	1	1	2013-04-20	2013-09-21	1-0   	120	-1	U	13	-1	-1	-1	-1	-1	20	1	17	0	-1	-1
2b2	1393	0	18	18	0	U	1	1	2013-04-20	2013-09-21	1-0   	120	-1	U	12	-1	-1	-1	-1	-1	20	1	18	0	-1	-1
2b31	1394	0	19	19	0	U	1	1	2013-04-20	2013-09-21	1-0   	120	-1	U	12	-1	-1	-1	-1	-1	20	1	19	0	-1	-1
tc alba (m72)	1397	Small dia cuttings (<4mm)	22	22	0	U	5	2	2013-04-20	2013-09-21	DC    	15	-1	U	8	-1	-1	-1	-1	-1	20	2	1	0	-1	-1
a502	1398	0	23	23	0	U	10	5	2013-04-20	2013-09-21	DC    	15	-1	U	9	-1	-1	-1	-1	-1	20	2	2	0	-1	-1
41aa111	1399	0	24	24	0	U	10	5	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	2	3	0	-1	-1
83aa2mf	1400	0	25	25	0	U	10	5	2013-04-20	2013-09-21	DC    	15	-1	U	9	-1	-1	-1	-1	-1	20	2	4	0	-1	-1
83aa2mf	1401	6mm avg dia cuttings	26	26	0	U	10	6	2013-04-20	2013-09-21	DC    	15	-1	U	9	-1	-1	-1	-1	-1	20	2	5	0	-1	-1
9ww	1402	Willow 8mm avg dia cuttings	27	27	0	U	10	9	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	2	6	0	-1	-1
80aa3mf	1405	0	30	30	0	U	4	3	2013-04-20	2013-09-21	1-0   	120	-1	U	7	-1	-1	-1	-1	-1	20	2	9	0	-1	-1
100aa12	1406	1 large whip each stool	31	31	0	U	6	6	2013-04-20	2013-09-21	1-0   	120	-1	Y	9	-1	-1	-1	-1	-1	20	2	10	0	-1	-1
cag204	1407	4.5' tall	32	32	0	U	1	1	2013-04-20	2013-09-21	1-0   	120	-1	U	16	-1	-1	-1	-1	-1	20	2	11	0	-1	-1
1cagw02	1408	1 usable whip per stool	33	33	0	U	3	3	2013-04-20	2013-09-21	1-0   	120	-1	U	13	-1	-1	-1	-1	-1	20	2	12	0	-1	-1
104aa12	1409	0	34	34	0	U	6	6	2013-04-20	2013-09-21	1-0   	120	-1	U	14	-1	-1	-1	-1	-1	20	2	13	0	-1	-1
101aa11	1410	5' avg height	35	35	0	U	6	6	2013-04-20	2013-09-21	1-0   	120	-1	U	11	-1	-1	-1	-1	-1	20	2	14	0	-1	-1
100aa11	1411	0	36	36	0	U	6	6	2013-04-20	2013-09-21	1-0   	120	-1	U	13	-1	-1	-1	-1	-1	20	2	15	0	-1	-1
1cagw03	1412	0	37	37	0	U	4	4	2013-04-20	2013-09-21	1-0   	120	-1	U	15	-1	-1	-1	-1	-1	20	2	16	0	-1	-1
98aa11	1413	2 whips per stool	38	38	0	U	6	6	2013-04-20	2013-09-21	1-0   	120	-1	U	14	-1	-1	-1	-1	-1	20	2	17	0	-1	-1
1bw1	1414	(I cut one whip for FW test)	39	39	0	U	5	5	2013-04-20	2013-09-21	1-0   	120	-1	U	12	-1	-1	-1	-1	-1	20	2	18	0	-1	-1
103aa11	1415	0	40	40	0	U	6	6	2013-04-20	2013-09-21	1-0   	120	-1	U	10	-1	-1	-1	-1	-1	20	2	19	0	-1	-1
94aa101	1416	very little variegation 	41	41	0	U	10	9	2013-04-20	2013-09-21	1-0   	120	-1	U	10	-1	-1	-1	-1	-1	20	3	20	0	-1	-1
nfa	1417	cuttings were 8inch long and 10mm dia	42	42	0	U	10	7	2013-04-20	2013-09-21	1-0   	120	-1	Y	6	-1	-1	-1	-1	-1	20	3	21	0	-1	-1
83aa1mf	1418	small dia cuttings (5mm)	43	43	0	U	10	5	2013-04-20	2013-09-21	1-0   	120	-1	U	4	-1	-1	-1	-1	-1	20	3	22	0	-1	-1
41aa111	1419	0	44	44	0	U	10	4	2013-04-20	2013-09-21	1-0   	120	-1	U	8	-1	-1	-1	-1	-1	20	3	23	0	-1	-1
83aa1mf	1420	0	45	45	0	U	10	4	2013-04-20	2013-09-21	1-0   	120	-1	U	9	-1	-1	-1	-1	-1	20	4	1	0	-1	-1
1bw1	1421	NICE!	46	46	0	U	10	8	2013-04-20	2013-09-21	1-0   	120	-1	Y	10	-1	-1	-1	-1	-1	20	4	2	0	-1	-1
2xb	1422	These are ortets, nice!  8inch cuttings taken from 12inch tips.	47	47	0	U	46	32	2013-04-20	2013-09-21	DC    	15	-1	Y	9	-1	-1	-1	-1	-1	20	4	3	0	-1	-1
1bw1	1423	NICE!	48	48	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	Y	12	-1	-1	-1	-1	-1	20	4	4	0	-1	-1
2xb	1424	9 are selectable	49	49	0	U	36	30	2013-04-20	2013-09-21	DC    	15	-1	Y	7	-1	-1	-1	-1	-1	20	4	5	0	-1	-1
83aa1mf	1425	0	50	50	0	U	10	5	2013-04-20	2013-09-21	DC    	15	-1	U	9	-1	-1	-1	-1	-1	20	5	6	0	-1	-1
1xcagw	1426	13 are selectable	51	51	0	U	34	21	2013-04-20	2013-09-21	DC    	15	-1	Y	8	-1	-1	-1	-1	-1	20	5	7	0	-1	-1
1bw1	1427	0	52	52	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	Y	9	-1	-1	-1	-1	-1	20	5	8	0	-1	-1
2xb	1428	2mm cutting tips, 24 are good	53	53	0	U	64	47	2013-04-20	2013-09-21	DC    	15	-1	Y	6	-1	-1	-1	-1	-1	20	5	9	0	-1	-1
104aa11	1429	2 have 3 whips/stool	54	54	0	U	7	7	2013-04-20	2013-09-21	1-0   	120	-1	Y	13	-1	-1	-1	-1	-1	20	5	10	0	-1	-1
92aa11	1430	0	55	55	0	U	6	6	2013-04-20	2013-09-21	1-0   	120	-1	Y	15	-1	-1	-1	-1	-1	20	5	11	0	-1	-1
93aa11	1431	0	56	56	0	U	6	6	2013-04-20	2013-09-21	1-0   	120	-1	Y	16	-1	-1	-1	-1	-1	20	5	12	0	-1	-1
97aa12	1432	0	57	57	0	U	6	6	2013-04-20	2013-09-21	1-0   	120	-1	U	14	-1	-1	-1	-1	-1	20	5	13	0	-1	-1
93aa12	1433	0	58	58	0	U	6	6	2013-04-20	2013-09-21	1-0   	120	-1	Y	19	-1	-1	-1	-1	-1	20	5	14	0	-1	-1
97aa11	1434	0	59	59	0	U	6	6	2013-04-20	2013-09-21	1-0   	120	-1	U	15	-1	-1	-1	-1	-1	20	5	15	0	-1	-1
95aa11	1435	0	60	60	0	U	6	6	2013-04-20	2013-09-21	1-0   	120	-1	U	15	-1	-1	-1	-1	-1	20	5	16	0	-1	-1
dn34	1436	5 inch cuttings from TRC	61	61	0	U	22	15	2013-04-20	2013-09-21	1-0   	120	-1	U	8	-1	-1	-1	-1	-1	20	6	1	0	-1	-1
98aa11	1437	12 inch cuttings	62	62	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	10	-1	-1	-1	-1	-1	20	6	2	0	-1	-1
98aa11	1438	10 inch cuttings	63	63	0	U	10	10	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	6	3	0	-1	-1
dn34	1439	5 inch cuttings	64	64	0	U	22	13	2013-04-20	2013-09-21	DC    	15	-1	U	8	-1	-1	-1	-1	-1	20	7	1	0	-1	-1
98aa11	1440	planted as 12 inch cuttings	65	65	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	9	-1	-1	-1	-1	-1	20	7	2	0	-1	-1
98aa11	1441	planted as 10 inch cuttings	66	66	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	U	9	-1	-1	-1	-1	-1	20	7	3	0	-1	-1
1cagw02	1442	planted as 6 inch cuttings (all below)	67	67	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	6	4	1	-1	-1
93aa11	1443	0	68	68	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	6	5	1	-1	-1
93aa12	1444	0	69	69	0	U	10	4	2013-04-20	2013-09-21	DC    	15	-1	U	9	-1	-1	-1	-1	-1	20	6	6	1	-1	-1
1bw1	1445	Poor performance due to slow start?	70	70	0	U	10	5	2013-04-20	2013-09-21	DC    	15	-1	U	4	-1	-1	-1	-1	-1	20	6	7	1	-1	-1
101aa11	1446	0	71	71	0	U	10	10	2013-04-20	2013-09-21	DC    	15	-1	Y	6	-1	-1	-1	-1	-1	20	6	8	1	-1	-1
100aa12	1447	0	72	72	0	U	10	5	2013-04-20	2013-09-21	DC    	15	-1	U	4	-1	-1	-1	-1	-1	20	6	9	1	-1	-1
95aa11	1448	0	73	73	0	U	10	9	2013-04-20	2013-09-21	DC    	15	-1	U	9	-1	-1	-1	-1	-1	20	6	10	1	-1	-1
1cagw03	1449	0	74	74	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	6	11	1	-1	-1
92aa11	1450	0	75	75	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	U	9	-1	-1	-1	-1	-1	20	6	12	2	-1	-1
93aa12	1451	0	76	76	0	U	10	5	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	6	13	2	-1	-1
104aa11	1452	0	77	77	0	U	10	3	2013-04-20	2013-09-21	DC    	15	-1	U	4	-1	-1	-1	-1	-1	20	6	14	2	-1	-1
104aa12	1453	0	78	78	0	U	10	5	2013-04-20	2013-09-21	DC    	15	-1	U	9	-1	-1	-1	-1	-1	20	6	15	2	-1	-1
97aa12	1454	0	79	79	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	6	16	2	-1	-1
95aa11	1455	0	80	80	0	U	10	9	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	6	17	2	-1	-1
1cagw03	1456	0	81	81	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	6	18	2	-1	-1
100aa12	1457	0	82	82	0	U	10	6	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	6	19	2	-1	-1
cag204	1458	0	83	83	0	U	10	3	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	6	20	3	-1	-1
1cagw03	1459	0	84	84	0	U	10	6	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	6	21	3	-1	-1
100aa12	1460	0	85	85	0	U	10	4	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	6	22	3	-1	-1
101aa11	1461	0	86	86	0	U	10	10	2013-04-20	2013-09-21	DC    	15	-1	Y	6	-1	-1	-1	-1	-1	20	6	23	3	-1	-1
92aa11	1462	0	87	87	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	6	24	3	-1	-1
93aa12	1463	0	88	88	0	U	10	1	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	6	25	3	-1	-1
103aa11	1464	0	89	89	0	U	10	5	2013-04-20	2013-09-21	DC    	15	-1	U	4	-1	-1	-1	-1	-1	20	6	26	3	-1	-1
104aa11	1465	0	90	90	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	4	-1	-1	-1	-1	-1	20	6	27	3	-1	-1
97aa11	1466	0	91	91	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	7	4	1	-1	-1
92aa11	1467	0	92	92	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	7	5	1	-1	-1
103aa11	1468	0	93	93	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	4	-1	-1	-1	-1	-1	20	7	6	1	-1	-1
104aa11	1469	0	94	94	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	Y	8	-1	-1	-1	-1	-1	20	7	7	1	-1	-1
104aa12	1470	0	95	95	0	U	10	6	2013-04-20	2013-09-21	DC    	15	-1	U	4	-1	-1	-1	-1	-1	20	7	8	1	-1	-1
97aa12	1471	0	96	96	0	U	10	10	2013-04-20	2013-09-21	DC    	15	-1	Y	8	-1	-1	-1	-1	-1	20	7	9	1	-1	-1
cag204	1472	0	97	97	0	U	10	1	2013-04-20	2013-09-21	DC    	15	-1	U	3	-1	-1	-1	-1	-1	20	7	10	1	-1	-1
100aa11	1473	0	98	98	0	U	10	9	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	7	11	1	-1	-1
98aa11	1474	0	99	99	0	U	10	9	2013-04-20	2013-09-21	DC    	15	-1	Y	8	-1	-1	-1	-1	-1	20	7	12	1	-1	-1
1cagw02	1475	0	100	100	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	7	13	2	-1	-1
93aa11	1476	0	101	101	0	U	10	9	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	7	14	2	-1	-1
103aa11	1477	0	102	102	0	U	10	3	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	7	15	2	-1	-1
1bw1	1478	0	103	103	0	U	10	5	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	7	16	2	-1	-1
cag204	1479	0	104	104	0	U	10	1	2013-04-20	2013-09-21	DC    	15	-1	U	4	-1	-1	-1	-1	-1	20	7	17	2	-1	-1
97aa11	1480	0	105	105	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	7	18	2	-1	-1
98aa11	1481	0	106	106	0	U	10	10	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	7	19	2	-1	-1
100aa11	1482	0	107	107	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	7	20	2	-1	-1
101aa11	1483	Biased	108	108	0	U	10	10	2013-04-20	2013-09-21	DC    	15	-1	Y	9	-1	-1	-1	-1	-1	20	7	21	2	-1	-1
97aa11	1484	0	109	109	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	9	-1	-1	-1	-1	-1	20	7	22	3	-1	-1
97aa12	1485	0	110	110	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	Y	10	-1	-1	-1	-1	-1	20	7	23	3	-1	-1
100aa11	1486	0	111	111	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	7	24	3	-1	-1
98aa11	1487	0	112	112	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	7	25	3	-1	-1
95aa11	1488	0	113	113	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	7	26	3	-1	-1
93aa11	1489	0	114	114	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	7	27	3	-1	-1
104aa12	1490	0	115	115	0	U	10	9	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	7	28	3	-1	-1
1bw1	1491	0	116	116	0	U	10	9	2013-04-20	2013-09-21	DC    	15	-1	Y	8	-1	-1	-1	-1	-1	20	7	29	3	-1	-1
2b3	1492	0	117	117	0	U	10	6	2013-04-20	2013-09-21	DC    	15	-1	U	10	-1	-1	-1	-1	-1	20	8	1	0	-1	-1
2b28	1493	0	118	118	0	U	6	5	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	8	2	0	-1	-1
2b21	1494	0	119	119	0	U	6	5	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	8	3	0	-1	-1
2b30	1495	0	120	120	0	U	6	4	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	8	4	0	-1	-1
2b7	1496	Nice	121	121	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	Y	8	-1	-1	-1	-1	-1	20	8	5	0	-1	-1
2b1	1497	0	122	122	0	U	6	4	2013-04-20	2013-09-21	DC    	15	-1	U	4	-1	-1	-1	-1	-1	20	8	6	0	-1	-1
2b9	1498	2 are dead	123	123	0	U	6	4	2013-04-20	2013-09-21	DC    	15	-1	U	8	-1	-1	-1	-1	-1	20	8	7	0	-1	-1
2b11	1499	0	124	124	0	U	6	5	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	8	8	0	-1	-1
2b19	1500	0	125	125	0	U	6	5	2013-04-20	2013-09-21	DC    	15	-1	Y	7	-1	-1	-1	-1	-1	20	8	9	0	-1	-1
2b12	1501	Nice	126	126	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	Y	5	-1	-1	-1	-1	-1	20	8	10	0	-1	-1
2b15	1502	Nice	127	127	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	8	11	0	-1	-1
2b13	1503	0	128	128	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	Y	7	-1	-1	-1	-1	-1	20	8	12	0	-1	-1
2b24	1504	0	129	129	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	8	13	0	-1	-1
2b40	1505	0	130	130	0	U	6	3	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	8	14	0	-1	-1
2b18	1506	0	131	131	0	U	6	5	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	8	15	0	-1	-1
2b2	1507	0	132	132	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	U	4	-1	-1	-1	-1	-1	20	8	16	0	-1	-1
98aa11	1508	0	133	133	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	8	17	4	-1	-1
1cagw03	1509	0	134	134	0	U	10	9	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	8	18	4	-1	-1
100aa12	1510	0	135	135	0	U	10	7	2013-04-20	2013-09-21	DC    	15	-1	U	8	-1	-1	-1	-1	-1	20	8	19	4	-1	-1
97aa12	1511	0	136	136	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	8	20	4	-1	-1
92aa11	1512	0	137	137	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	Y	12	-1	-1	-1	-1	-1	20	8	21	4	-1	-1
103aa11	1513	0	138	138	0	U	10	6	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	8	22	4	-1	-1
104aa12	1514	0	139	139	0	U	10	9	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	8	23	4	-1	-1
1bw1	1515	biased	140	140	0	U	10	9	2013-04-20	2013-09-21	DC    	15	-1	U	10	-1	-1	-1	-1	-1	20	8	24	4	-1	-1
2b21	1516	clone #21 propagated from root shoots	141	141	0	U	17	14	2013-04-20	2013-09-21	RS    	10	-1	U	9	-1	-1	-1	-1	-1	20	8	25	0	-1	-1
3aa202	1518	4' wasp 4-14-13	143	143	0	U	1	1	2013-04-20	2013-09-21	WASP  	10	-1	Y	8	-1	-1	-1	-1	-1	20	8	27	0	-1	-1
22xar	1519	20 potential trees to select from	144	144	0	U	42	20	2013-04-20	2013-09-21	SEL   	6	-1	U	6	-1	-1	-1	-1	-1	20	8	28	0	-1	-1
2b27	1520	Biased edge in this row	145	145	0	U	6	5	2013-04-20	2013-09-21	DC    	15	-1	U	4	-1	-1	-1	-1	-1	20	9	1	0	-1	-1
2b4	1521	0	146	146	0	U	6	5	2013-04-20	2013-09-21	DC    	15	-1	U	8	-1	-1	-1	-1	-1	20	9	2	0	-1	-1
2b29	1522	0	147	147	0	U	6	4	2013-04-20	2013-09-21	DC    	15	-1	Y	10	-1	-1	-1	-1	-1	20	9	3	0	-1	-1
2b31	1523	0	148	148	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	Y	9	-1	-1	-1	-1	-1	20	9	4	0	-1	-1
2b26	1524	0	149	149	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	9	5	0	-1	-1
2b22	1525	0	150	150	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	Y	10	-1	-1	-1	-1	-1	20	9	6	0	-1	-1
2b6	1526	0	151	151	0	U	6	5	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	9	7	0	-1	-1
2b8	1527	0	152	152	0	U	6	3	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	9	8	0	-1	-1
2b5	1528	0	153	153	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	9	9	0	-1	-1
2b25	1529	0	154	154	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	Y	11	-1	-1	-1	-1	-1	20	9	10	0	-1	-1
2b23	1530	0	155	155	0	U	6	4	2013-04-20	2013-09-21	DC    	15	-1	U	8	-1	-1	-1	-1	-1	20	9	11	0	-1	-1
2b17	1531	0	156	156	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	Y	8	-1	-1	-1	-1	-1	20	9	12	0	-1	-1
2b16	1532	0	157	157	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	Y	10	-1	-1	-1	-1	-1	20	9	13	0	-1	-1
2b20	1533	0	158	158	0	U	6	3	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	9	14	0	-1	-1
2b10	1534	0	159	159	0	U	6	2	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	9	15	0	-1	-1
2b14	1535	0	160	160	0	U	6	6	2013-04-20	2013-09-21	DC    	15	-1	U	7	-1	-1	-1	-1	-1	20	9	16	0	-1	-1
95aa11	1536	start rep. 4- row 9	161	161	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	9	17	4	-1	-1
100aa11	1537	0	162	162	0	U	10	6	2013-04-20	2013-09-21	DC    	15	-1	U	9	-1	-1	-1	-1	-1	20	9	18	4	-1	-1
97aa12	1538	0	163	163	0	U	10	9	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	9	19	4	-1	-1
101aa11	1539	0	164	164	0	U	10	9	2013-04-20	2013-09-21	DC    	15	-1	U	6	-1	-1	-1	-1	-1	20	9	20	4	-1	-1
93aa12	1540	0	165	165	0	U	10	8	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	9	21	4	-1	-1
93aa11	1541	0	166	166	0	U	10	10	2013-04-20	2013-09-21	DC    	15	-1	Y	8	-1	-1	-1	-1	-1	20	9	22	4	-1	-1
104aa11	1542	0	167	167	0	U	10	10	2013-04-20	2013-09-21	DC    	15	-1	U	5	-1	-1	-1	-1	-1	20	9	23	0	-1	-1
2b21	1543	clone 21, 13 plantable	168	168	0	U	13	13	2013-04-20	2013-09-21	RS    	10	-1	U	9	-1	-1	-1	-1	-1	20	9	24	0	-1	-1
22xar	1545	27 plantable/selectable	170	170	0	U	38	27	2013-04-20	2013-09-21	SEL   	6	-1	U	7	-1	-1	-1	-1	-1	20	9	26	0	-1	-1
3xcagc	1546	0	171	171	0	U	90	63	2013-04-20	2013-09-21	SEL   	6	-1	U	6	-1	-1	-1	-1	-1	20	10	1	0	-1	-1
5xcagr	1547	0	172	172	0	U	50	37	2013-04-20	2013-09-21	SEL   	6	-1	U	7	-1	-1	-1	-1	-1	20	10	2	0	-1	-1
2xrr	1548	0	173	173	0	U	30	23	2013-04-20	2013-09-21	SEL   	6	-1	U	7	-1	-1	-1	-1	-1	20	10	3	0	-1	-1
3xcagc	1549	0	174	174	0	U	90	61	2013-04-20	2013-09-21	SEL   	6	-1	U	7	-1	-1	-1	-1	-1	20	11	1	0	-1	-1
5xcagr	1550	0	175	175	0	U	70	55	2013-04-20	2013-09-21	SEL   	6	-1	U	6	-1	-1	-1	-1	-1	20	11	2	0	-1	-1
2xrr	1551	0	176	176	0	U	40	29	2013-04-20	2013-09-21	SEL   	6	-1	U	7	-1	-1	-1	-1	-1	20	11	3	0	-1	-1
105xaa	1552	0	177	177	0	U	40	29	2013-04-20	2013-09-21	SEL   	6	-1	U	6	-1	-1	-1	140	-1	20	12	1	0	-1	-1
4xacag	1553	0	178	178	0	U	55	41	2013-04-20	2013-09-21	SEL   	6	-1	U	7	-1	-1	-1	-1	-1	20	12	2	0	-1	-1
105xaa	1554	0	179	179	0	U	40	26	2013-04-20	2013-09-21	SEL   	6	-1	U	6	-1	-1	-1	-1	-1	20	13	1	0	-1	-1
4xacag	1555	0	180	180	0	U	55	42	2013-04-20	2013-09-21	SEL   	6	-1	U	8	-1	-1	-1	-1	-1	20	13	2	0	-1	-1
4xgw	1556	Tallest is 50inch, which is the ONLY AG	181	181	0	U	9	5	2013-07-01	2013-09-21	SEL   	6	-1	U	4	-1	-1	-1	-1	-1	20	14	1	0	-1	-1
5xgw	1557	0	182	182	0	U	9	7	2013-07-01	2013-09-21	SEL   	6	-1	U	4	-1	-1	-1	-1	-1	20	14	2	0	-1	-1
zoss	1558	From root cutting, figured?	183	183	0	U	6	6	2013-07-01	2013-09-21	RS    	6	-1	U	4	-1	-1	-1	-1	-1	20	14	3	0	-1	-1
4xgw	1559	Nice, 16 are AG, 1 is GG	184	184	0	U	17	5	2013-07-01	2013-09-21	SEL   	6	-1	U	8	-1	-1	-1	-1	-1	20	14	4	0	-1	-1
2xgw	1560	tallest is 30inch, all have a leaf rust. Last 2013 tree.	185	185	0	U	4	4	2013-07-01	2013-09-21	SEL   	6	-1	U	4	-1	-1	-1	-1	-1	20	14	5	0	-1	-1
100aa11	1561	0	0	0	0	U	10	9	2014-04-20	2014-09-14	DC    	15	7	U	7	-1	-1	-1	-1	-1	22	3	13	3	-1	-1
100aa11	1562	0	0	0	0	U	10	9	2014-04-20	2014-09-14	DC    	15	10	U	5	-1	-1	-1	-1	-1	22	4	5	4	-1	-1
100aa12	1563	0	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	7	U	8	-1	-1	-1	-1	-1	22	3	15	3	-1	-1
100aa12	1564	0	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	7	U	10	-1	-1	-1	-1	-1	22	5	5	4	-1	-1
101aa11	1565	Rep 3 - NICE!	0	0	0	U	10	10	2014-04-20	2014-09-14	DC    	15	10	Y	9	-1	-1	-1	-1	-1	22	2	9	3	-1	-1
101aa11	1566	0	0	0	0	U	10	10	2014-04-20	2014-09-14	DC    	15	10	Y	8	-1	-1	-1	-1	-1	22	4	3	4	-1	-1
103aa11	1567	0	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	7	U	9	-1	-1	-1	-1	-1	22	3	17	3	-1	-1
103aa11	1568	0	0	0	0	U	10	5	2014-04-20	2014-09-14	DC    	15	7	U	4	-1	-1	-1	-1	-1	22	4	8	4	-1	-1
104aa11	1569	0	0	0	0	U	10	4	2014-04-20	2014-09-14	DC    	15	10	U	10	-1	-1	-1	-1	-1	22	3	16	3	-1	-1
104aa11	1570	rep 4	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	10	U	10	-1	-1	-1	-1	-1	22	5	1	4	-1	-1
104aa12	1571	ZZ=3mm	0	0	0	U	10	10	2014-04-20	2014-09-14	DC    	15	7	Y	6	-1	-1	-1	-1	-1	22	2	11	3	-1	-1
104aa12	1572	0	0	0	0	U	10	9	2014-04-20	2014-09-14	DC    	15	7	U	6	-1	-1	-1	-1	-1	22	4	4	4	-1	-1
105xaa	1573	ZZ>3mm	0	0	0	U	26	22	2014-04-20	2014-09-14	DC    	15	10	U	6	-1	-1	-1	-1	-1	22	8	6	8	-1	-1
105xaa	1574	0	0	0	0	U	26	24	2014-04-20	2014-09-14	ODC   	15	7	U	7	-1	-1	-1	-1	-1	22	9	6	8	-1	-1
106xaa	1575	ZZ>3mm notes2=TallestHeightCm (Leaf Stem variabilities L=1 H=5 in Leaf_score column)	120	0	0	U	16	15	2014-06-28	2014-09-14	SEL   	6	7	U	5	-1	-1	-1	80	2	22	16	3	10	-1	-1
106xaa	1576	ZZ>3mm	0	0	0	U	16	14	2014-06-28	2014-09-14	SEL   	6	7	U	5	-1	-1	-1	-1	-1	22	17	3	10	-1	-1
107xaa	1577	notes2=TallestHeightCm Leaf undersides not as tomentose as most albas	138	0	0	U	34	33	2014-06-28	2014-09-14	SEL   	6	10	U	6	-1	-1	-1	88	3	22	18	2	10	-1	-1
107xaa	1578	ZZ>3mm	0	0	0	U	34	34	2014-06-28	2014-09-14	SEL   	6	10	U	6	-1	-1	-1	-1	-1	22	19	2	10	-1	-1
11xab	1579	ZZ>3mm notes2=TallestHeightCm Leaves mostly lobed to some intermediate.	135	0	0	U	24	20	2014-06-28	2014-09-14	SEL   	6	10	Y	6	-1	-1	-1	101	4	22	18	3	10	-1	-1
11xab	1580	ZZ>3mm	0	0	0	U	25	24	2014-06-28	2014-09-14	SEL   	6	10	Y	6	-1	-1	-1	-1	-1	22	19	3	10	-1	-1
11xab	1581	0	0	0	0	U	19	17	2014-06-28	2014-09-14	SEL   	6	10	U	6	-1	-1	-1	-1	-1	22	20	1	10	-1	-1
11xab	1582	ZZ>3mm	0	0	0	U	19	18	2014-06-28	2014-09-14	WASP  	6	10	U	6	-1	-1	-1	-1	-1	22	21	1	10	-1	-1
12xrb	1583	ZZ>3mm notes2=TallestHeightCm Intermediate leaves with variable margins.	110	0	0	U	7	7	2014-06-28	2014-09-14	SEL   	6	3	U	6	-1	-1	-1	89	4	22	10	8	10	-1	-1
13xgb	1584	ZZ>3mm notes2=TallestHeightCm	137	0	0	U	18	15	2014-06-28	2014-09-14	SEL   	6	7	U	6	-1	-1	-1	102	4	22	10	13	10	-1	-1
13xgb	1585	ZZ>3mm Has smaller leaves than 18xbg.	0	0	0	U	21	20	2014-06-28	2014-09-14	SEL   	6	7	U	7	-1	-1	-1	-1	-1	22	11	6	10	-1	-1
14xb	1586	Start 2.5 inch spacing.  ZZ>3mm notes2=TallestHeightCm mostly lobed leaves.	142	0	0	U	43	43	2014-06-28	2014-09-14	SEL   	6	7	U	6	-1	-1	-1	113	4	22	14	1	10	-1	-1
14xb	1587	ZZ>3mm	0	0	0	U	43	43	2014-06-28	2014-09-14	SEL   	6	7	U	5	-1	-1	-1	-1	-1	22	15	1	10	-1	-1
15xb	1588	ZZ>3mm	0	0	0	U	7	6	2014-06-28	2014-09-14	SEL   	6	3	U	6	-1	-1	-1	-1	-1	22	10	11	10	-1	-1
15xb	1589	Has tallest tree at 15 mm with a 9 mm collar dia. best family collar=11mm ZZ>3mm notes2=TallestHeightCm Intermediate leaves with variable margins. 	156	0	0	U	23	19	2014-06-28	2014-09-14	SEL   	6	7	Y	7	-1	-1	-1	128	3	22	11	4	10	-1	-1
16xab	1590	ZZ>3mm notes2=TallestHeightCm Lobed leaves.	122	0	0	U	20	20	2014-06-28	2014-09-14	SEL   	6	7	U	5	-1	-1	-1	85	4	22	16	2	10	-1	-1
16xab	1591	ZZ>3mm	0	0	0	U	20	20	2014-06-28	2014-09-14	SEL   	6	7	U	5	-1	-1	-1	-1	-1	22	17	2	10	-1	-1
17xb	1592	ZZ>3mm notes2=TallestHeightCm Intermediate leaves with variable margins.	112	0	0	U	12	7	2014-06-28	2014-09-14	SEL   	6	5	U	6	-1	-1	-1	67	4	22	11	3	10	-1	-1
18xbg	1593	ZZ>3mm	0	0	0	U	50	47	2014-06-28	2014-09-14	SEL   	6	10	Y	7	-1	-1	-1	-1	-1	22	10	12	10	-1	-1
18xbg	1594	Leaves have trace yellow spots (not rust) on some leaves.  ZZ>3mm notes2=TallestHeightCm Intermediate characteristics	133	0	0	U	50	50	2014-06-28	2014-09-14	SEL   	6	10	Y	6	-1	-1	-1	107	2	22	11	5	10	-1	-1
19xgb	1595	ZZ>3mm	0	0	0	U	21	20	2014-06-28	2014-09-14	SEL   	6	7	U	6	-1	-1	-1	-1	-1	22	12	4	10	-1	-1
19xgb	1596	All ortets have yellow spots on leaves (not rust).  ZZ>3mm notes2=TallestHeightCm	126	0	0	U	22	20	2014-06-28	2014-09-14	SEL   	6	7	U	6	-1	-1	-1	83	2	22	13	4	10	-1	-1
1bw1	1597	(2mm ZZ)	0	0	0	U	4	3	2014-04-20	2014-09-14	DC    	15	10	U	15	-1	-1	-1	-1	-1	22	1	17	1	-1	-1
1bw1	1598	0	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	10	U	9	-1	-1	-1	-1	-1	22	2	5	2	-1	-1
1bw1	1599	0	0	0	0	U	10	8	2014-04-20	2014-09-14	DC    	15	7	U	6	-1	-1	-1	170	-1	22	3	6	2	-1	-1
1bw1	1600	0	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	10	Y	10	-1	-1	-1	-1	-1	22	3	18	3	-1	-1
1bw1	1601	0	0	0	0	U	10	9	2014-04-20	2014-09-14	DC    	15	10	Y	10	-1	-1	-1	145	-1	22	5	7	4	-1	-1
1bw1	1602	0	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	10	U	10	-1	-1	-1	-1	-1	22	6	7	6	-1	-1
1bw1	1603	0	0	0	0	U	10	9	2014-04-20	2014-09-14	DC    	15	10	Y	9	-1	-1	-1	-1	-1	22	7	7	6	-1	-1
1cagw02	1604	ZZ=2mm	0	0	0	U	10	8	2014-04-20	2014-09-14	DC    	15	10	U	7	-1	-1	-1	-1	-1	22	2	16	3	-1	-1
1cagw02	1605	0	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	7	U	7	-1	-1	-1	-1	-1	22	4	9	4	-1	-1
1cagw03	1606	0	0	0	0	U	10	9	2014-04-20	2014-09-14	DC    	15	7	U	6	-1	-1	-1	-1	-1	22	3	19	3	-1	-1
1cagw03	1607	0	0	0	0	U	10	8	2014-04-20	2014-09-14	DC    	15	10	U	5	-1	-1	-1	-1	-1	22	4	6	4	-1	-1
1xbar	1610	notes2=TallestHeightCm Has all leaf shapes/margins, not vigorous.	78	0	0	U	3	3	2014-06-28	2014-09-14	SEL   	6	3	U	4	-1	-1	-1	49	5	22	10	4	9	-1	-1
1xcagw	1611	Ortets Rep 8. The male may be small tooth due to lack of tomentose similar to 7xbt.	0	0	0	U	5	3	2014-04-20	2014-09-14	DC    	15	10	Y	13	-1	-1	-1	-1	-1	22	8	1	8	-1	-1
1xcagw	1612	Alba types	0	0	0	U	5	5	2014-04-20	2014-09-14	ODC   	15	5	Y	12	-1	-1	-1	175	-1	22	9	1	8	-1	-1
20xbs	1613	0	0	0	0	U	10	10	2014-06-28	2014-09-14	SEL   	6	7	U	4	-1	-1	-1	-1	-1	22	16	4	10	-1	-1
20xbs	1614	All ortets have lobed alba like leaves, tomentose. I expect this to be a mistake.	0	0	0	U	10	8	2014-06-28	2014-09-14	SEL   	6	7	U	5	-1	-1	-1	-1	-1	22	17	4	10	-1	-1
20xbs	1615	All ortets have lobed alba like leaves, tomentose. I expect this to be a mistake.	0	0	0	U	29	29	2014-06-28	2014-09-14	SEL   	6	7	U	5	-1	-1	-1	-1	-1	22	18	1	10	-1	-1
20xbs	1616	ZZ>3mm notes2=TallestHeightCm Lobed leaves.	149	0	0	U	29	27	2014-06-28	2014-09-14	SEL   	6	7	U	6	-1	-1	-1	80	3	22	19	1	10	-1	-1
21xba	1617	ZZ>3mm notes2=TallestHeightCm	137	0	0	U	21	20	2014-06-28	2014-09-14	SEL   	6	3	U	6	-1	-1	-1	105	3	22	10	10	10	-1	-1
22xar	1618	Ramets not ortets	0	0	0	U	10	6	2014-06-28	2014-09-14	DC    	15	10	U	9	-1	-1	-1	-1	-1	22	3	5	2	-1	-1
22xar	1619	ZZ>3mm	0	0	0	U	20	17	2014-06-28	2014-09-14	DC    	15	7	U	7	-1	-1	-1	-1	-1	22	8	5	8	-1	-1
22xar	1620	0	0	0	0	U	20	18	2014-06-28	2014-09-14	ODC   	15	7	U	7	-1	-1	-1	-1	-1	22	9	5	8	-1	-1
22xbg	1621	ZZ>3mm	0	0	0	U	47	45	2014-06-28	2014-09-14	SEL   	6	7	Y	5	-1	-1	-1	-1	-1	22	14	2	10	-1	-1
22xbg	1622	4 ortets have varying sized leaf spots. One serious.  ZZ>3mm notes2=TallestHeightCm	130	0	0	U	49	48	2014-06-28	2014-09-14	SEL   	6	7	Y	5	-1	-1	-1	90	4	22	15	2	10	-1	-1
23xba	1623	5 inch spacing, ZZ>3mm 14 have a LOT of Zig Zag, most of which are runts.  	130	0	0	U	37	36	2014-06-28	2014-09-14	SEL   	6	10	U	6	-1	-1	-1	101	4	22	20	2	10	-1	-1
23xba	1624	5 inch spacing. ZZ>3mm	0	0	0	U	37	36	2014-06-28	2014-09-14	WASP  	6	10	U	6	-1	-1	-1	-1	-1	22	21	2	10	-1	-1
23xba	1625	14 have a LOT of Zig Zag. most of which are runts.  ZZ>3mm	0	0	0	U	43	33	2014-06-28	2014-09-14	WASP  	6	10	U	6	-1	-1	-1	-1	-1	22	22	1	10	-1	-1
23xba	1626	ZZ>3mm	0	0	0	U	47	43	2014-06-28	2014-09-14	WASP  	6	10	U	6	-1	-1	-1	-1	-1	22	22	2	10	-1	-1
2b12	1627	0	0	0	0	U	10	2	2014-04-20	2014-09-14	DC    	15	10	U	4	-1	-1	-1	-1	-1	22	7	21	7	-1	-1
2b13	1628	zz=2mm	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	7	U	3	-1	-1	-1	-1	-1	22	7	4	6	-1	-1
2b14	1629	0	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	7	U	6	-1	-1	-1	-1	-1	22	4	16	5	-1	-1
2b14	1630	0	0	0	0	U	10	4	2014-04-20	2014-09-14	DC    	15	7	U	8	-1	-1	-1	-1	-1	22	7	16	7	-1	-1
2b16	1631	0	0	0	0	U	10	4	2014-04-20	2014-09-14	DC    	15	10	U	10	-1	-1	-1	-1	-1	22	4	13	5	-1	-1
2b16	1632	0	0	0	0	U	10	4	2014-04-20	2014-09-14	DC    	15	10	U	15	-1	-1	-1	-1	-1	22	6	16	7	-1	-1
2b16	1633	0	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	7	U	7	-1	-1	-1	-1	-1	22	7	3	6	-1	-1
2b17	1634	0	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	7	U	8	-1	-1	-1	-1	-1	22	4	17	5	-1	-1
2b17	1635	0	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	7	U	6	-1	-1	-1	-1	-1	22	7	19	7	-1	-1
2b19	1636	0	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	5	U	5	-1	-1	-1	-1	-1	22	4	15	5	-1	-1
2b19	1637	ZZ>3mm	0	0	0	U	10	4	2014-04-20	2014-09-14	DC    	15	7	U	7	-1	-1	-1	-1	-1	22	7	18	7	-1	-1
2b2	1638	0	0	0	0	U	10	5	2014-04-20	2014-09-14	DC    	15	7	U	7	-1	-1	-1	-1	-1	22	6	6	6	-1	-1
2b2	1639	0	0	0	0	U	10	3	2014-04-20	2014-09-14	DC    	15	5	U	3	-1	-1	-1	-1	-1	22	6	20	7	-1	-1
2b21	1640	ZZ=2.5mm, Nice!	0	0	0	U	10	10	2014-04-20	2014-09-14	DC    	15	10	Y	10	-1	-1	-1	170	-1	22	2	4	2	-1	-1
2b21	1641	ZZ=2mm	0	0	0	U	10	8	2014-04-20	2014-09-14	DC    	15	10	U	10	-1	-1	-1	-1	-1	22	3	4	2	-1	-1
2b21	1642	zz=2mm	0	0	0	U	10	8	2014-04-20	2014-09-14	DC    	15	10	U	7	-1	-1	-1	-1	-1	22	6	5	6	-1	-1
2b21	1643	zz=2mm	0	0	0	U	10	9	2014-04-20	2014-09-14	DC    	15	10	U	8	-1	-1	-1	-1	-1	22	7	6	6	-1	-1
2b22	1644	0	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	7	U	11	-1	-1	-1	-1	-1	22	5	14	5	-1	-1
2b22	1645	biased	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	7	U	13	-1	-1	-1	-1	-1	22	6	14	7	-1	-1
2b24	1646	0	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	7	U	8	-1	-1	-1	-1	-1	22	4	11	5	-1	-1
2b24	1647	0	0	0	0	U	10	5	2014-04-20	2014-09-14	DC    	15	7	U	10	-1	-1	-1	-1	-1	22	6	3	6	-1	-1
2b25	1648	Nice! Rep 5	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	7	Y	11	-1	-1	-1	206	-1	22	4	10	5	-1	-1
2b25	1649	0	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	7	Y	15	-1	-1	-1	271	-1	22	5	12	5	-1	-1
2b25	1650	0	0	0	0	U	10	5	2014-04-20	2014-09-14	DC    	15	10	U	13	-1	-1	-1	208	-1	22	6	18	7	-1	-1
2b26	1651	ZZ>3mm	0	0	0	U	10	5	2014-04-20	2014-09-14	DC    	15	7	U	4	-1	-1	-1	-1	-1	22	4	12	5	-1	-1
2b26	1652	0	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	10	U	8	-1	-1	-1	-1	-1	22	6	15	7	-1	-1
2b29	1653	0	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	10	U	7	-1	-1	-1	-1	-1	22	4	14	5	-1	-1
2b29	1654	zz=2mm	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	10	U	8	-1	-1	-1	-1	-1	22	7	14	7	-1	-1
2b3	1655	0	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	10	U	11	-1	-1	-1	-1	-1	22	6	19	7	-1	-1
2b3	1656	0	0	0	0	U	10	9	2014-04-20	2014-09-14	DC    	15	10	U	11	-1	-1	-1	-1	-1	22	6	21	7	-1	-1
2b3	1657	zz=2mm	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	10	U	8	-1	-1	-1	-1	-1	22	7	5	6	-1	-1
2b30	1658	0	0	0	0	U	10	4	2014-04-20	2014-09-14	DC    	15	10	U	7	-1	-1	-1	-1	-1	22	6	4	6	-1	-1
2b31	1659	0	0	0	0	U	10	4	2014-04-20	2014-09-14	DC    	15	7	U	11	-1	-1	-1	-1	-1	22	5	11	5	-1	-1
2b31	1660	0	0	0	0	U	10	4	2014-04-20	2014-09-14	DC    	15	10	U	9	-1	-1	-1	-1	-1	22	5	16	5	-1	-1
2b31	1661	0	0	0	0	U	10	8	2014-04-20	2014-09-14	DC    	15	10	U	6	-1	-1	-1	-1	-1	22	7	2	6	-1	-1
2b31	1662	0	0	0	0	U	3	1	2014-04-20	2014-09-14	ODC   	15	7	U	10	-1	-1	-1	-1	-1	22	8	17	8	-1	-1
2b4	1663	0	0	0	0	U	10	8	2014-04-20	2014-09-14	DC    	15	7	Y	9	-1	-1	-1	-1	-1	22	5	15	5	-1	-1
2b4	1664	0	0	0	0	U	10	5	2014-04-20	2014-09-14	DC    	15	7	U	11	-1	-1	-1	-1	-1	22	7	15	7	-1	-1
2b4	1665	0	0	0	0	U	10	5	2014-04-20	2014-09-14	DC    	15	10	U	10	-1	-1	-1	-1	-1	22	7	20	7	-1	-1
2b41	1666	0	0	0	0	U	10	2	2014-04-20	2014-09-14	DC    	15	10	U	3	-1	-1	-1	-1	-1	22	6	13	6	-1	-1
2b42	1667	0	0	0	0	U	8	2	2014-04-20	2014-09-14	DC    	15	10	U	13	-1	-1	-1	-1	-1	22	1	19	2	-1	-1
2b5	1668	0	0	0	0	U	10	5	2014-04-20	2014-09-14	DC    	15	10	U	5	-1	-1	-1	-1	-1	22	5	17	5	-1	-1
2b6	1669	0	0	0	0	U	10	8	2014-04-20	2014-09-14	DC    	15	7	Y	9	-1	-1	-1	-1	-1	22	5	13	5	-1	-1
2b6	1670	zz=2mm	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	5	U	10	-1	-1	-1	-1	-1	22	7	17	7	-1	-1
2b7	1671	rep 5	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	7	U	10	-1	-1	-1	-1	-1	22	5	10	5	-1	-1
2b7	1672	0	0	0	0	U	10	8	2014-04-20	2014-09-14	DC    	15	10	U	9	-1	-1	-1	-1	-1	22	6	2	6	-1	-1
2b50	1673	Nice 2014 selection for vigor (301 cm tall).	0	0	0	U	1	1	2014-04-20	2014-09-14	DC    	15	10	Y	18	-1	-1	-1	301	-1	22	2	1	2	-1	-1
2b51	1674	Nice 2014 selection for dark red fall leaves	0	0	0	U	1	1	2014-04-20	2014-09-14	DC    	15	10	Y	14	-1	-1	-1	216	-1	22	2	1	2	-1	-1
2rr1	1675	ZZ>3mm	0	0	0	U	8	2	2014-04-20	2014-09-14	DC    	15	5	U	5	-1	-1	-1	-1	-1	22	8	13	8	-1	-1
2rr10	1676	0	0	0	0	U	8	0	2014-04-20	2014-09-14	DC    	15	7	U	0	-1	-1	-1	-1	-1	22	8	9	8	-1	-1
2rr2	1677	0	0	0	0	U	8	1	2014-04-20	2014-09-14	ODC   	15	7	U	10	-1	-1	-1	-1	-1	22	9	12	8	-1	-1
2rr3	1678	0	0	0	0	U	8	2	2014-04-20	2014-09-14	ODC   	15	10	U	9	-1	-1	-1	-1	-1	22	9	9	8	-1	-1
2rr4	1679	0	0	0	0	U	8	2	2014-04-20	2014-09-14	ODC   	15	5	U	3	-1	-1	-1	-1	-1	22	9	13	8	-1	-1
2rr6	1680	0	0	0	0	U	8	2	2014-04-20	2014-09-14	ODC   	15	7	U	5	-1	-1	-1	-1	-1	22	9	10	8	-1	-1
2rr7	1681	0	0	0	0	U	8	3	2014-04-20	2014-09-14	DC    	15	5	U	4	-1	-1	-1	-1	-1	22	8	12	8	-1	-1
2rr8	1682	0	0	0	0	U	8	3	2014-04-20	2014-09-14	DC    	15	7	U	3	-1	-1	-1	-1	-1	22	8	10	8	-1	-1
2rr9	1683	0	0	0	0	U	8	0	2014-04-20	2014-09-14	ODC   	15	10	U	0	-1	-1	-1	-1	-1	22	9	11	8	-1	-1
2ww	1684	CC Gold Willow	0	0	0	U	3	3	2014-04-20	2014-09-14	DC    	15	10	U	13	-1	-1	-1	-1	-1	22	1	4	1	-1	-1
2xb	1685	Ortets. Nice! 5 selections, 2 for ZZ, one is huge!  (was renamed from 2xcag12)	0	0	0	U	22	17	2014-04-20	2014-09-14	DC    	15	10	U	12	-1	-1	-1	-1	-1	22	2	1	2	-1	-1
2xb	1686	Ortets (was renamed from 2xcag12)	0	0	0	U	21	12	2014-04-20	2014-09-14	DC    	15	5	U	9	-1	-1	-1	-1	-1	22	2	2	2	-1	-1
2xb	1687	Ortets (was renamed from 2xcag12)	0	0	0	U	18	14	2014-04-20	2014-09-14	DC    	15	5	U	7	-1	-1	-1	-1	-1	22	3	3	2	-1	-1
2xrr	1688	Highly variable	0	0	0	U	24	12	2014-04-20	2014-09-14	DC    	15	7	U	7	-1	-1	-1	-1	-1	22	8	2	8	-1	-1
2xrr	1689	0	0	0	0	U	24	18	2014-04-20	2014-09-14	ODC   	15	7	U	7	-1	-1	-1	-1	-1	22	9	2	8	-1	-1
3aa202	1690	2013 P4 parent (2 mm ZZ) keep Wasp 4/14	0	0	0	U	1	1	2014-04-20	2014-09-14	WASP  	6	10	Y	10	-1	-1	-1	-1	-1	22	1	9	1	-1	-1
3xcagc	1691	ZZ>3mm	0	0	0	U	17	13	2014-04-20	2014-09-14	DC    	15	10	Y	6	-1	-1	-1	-1	-1	22	8	4	8	-1	-1
3xcagc	1692	Nice!	0	0	0	U	18	14	2014-04-20	2014-09-14	ODC   	15	10	Y	9	-1	-1	-1	-1	-1	22	9	4	8	-1	-1
3xrr	1693	ZZ>3mm notes2=TallestHeightCm	118	0	0	U	11	11	2014-04-20	2014-09-14	SEL   	6	3	U	7	-1	-1	-1	78	4	22	10	9	10	-1	-1
41aa111	1694	P3 Parent	0	0	0	U	2	2	2014-04-20	2014-09-14	1-1   	30	10	U	13	-1	-1	-1	-1	-1	22	1	12	1	-1	-1
4acag2	1695	0	0	0	0	U	8	5	2014-04-20	2014-09-14	ODC   	15	10	U	12	-1	-1	-1	-1	-1	22	8	16	8	-1	-1
4acag3	1696	0	0	0	0	U	8	5	2014-04-20	2014-09-14	ODC   	15	7	Y	14	-1	-1	-1	-1	-1	22	9	14	8	-1	-1
4ab4	1697	Verify Clone ID	0	0	0	U	8	6	2014-04-20	2014-09-14	ODC   	15	10	Y	15	-1	-1	-1	-1	-1	22	9	17	8	-1	-1
4cag1	1698	ok	0	0	0	U	8	5	2014-04-20	2014-09-14	DC    	15	7	U	3	-1	-1	-1	-1	-1	22	8	11	8	-1	-1
4gw1	1699	0	0	0	0	U	8	0	2014-04-20	2014-09-14	ODC   	15	7	U	0	-1	-1	-1	-1	-1	22	8	15	8	-1	-1
4gw2	1700	0	0	0	0	U	8	0	2014-04-20	2014-09-14	ODC   	15	10	U	0	-1	-1	-1	-1	-1	22	8	14	8	-1	-1
4gw3	1701	0	0	0	0	U	8	1	2014-04-20	2014-09-14	ODC   	15	5	U	15	-1	-1	-1	-1	-1	22	9	15	8	-1	-1
4xacag	1702	0	0	0	0	U	37	27	2014-04-20	2014-09-14	DC    	15	7	U	6	-1	-1	-1	-1	-1	22	8	8	8	-1	-1
4xacag	1703	0	0	0	0	U	38	33	2014-04-20	2014-09-14	ODC   	15	10	U	7	-1	-1	-1	-1	-1	22	9	8	8	-1	-1
4xgw	1704	Some have zz=5mm. GA types measured only. 	0	0	0	U	8	4	2014-04-20	2014-09-14	DC    	15	10	Y	9	-1	-1	-1	-1	-1	22	8	3	8	-1	-1
4xgw	1705	ZZ>3mm	0	0	0	U	7	5	2014-04-20	2014-09-14	ODC   	15	10	U	12	-1	-1	-1	-1	-1	22	9	3	8	-1	-1
4xgw	1706	ZZ>3mm notes2=TallestHeightCm	123	0	0	U	23	19	2014-06-28	2014-09-14	SEL   	6	5	U	5	-1	-1	-1	104	4	22	12	5	10	-1	-1
4xgw	1707	End 2 inch spacing.  ZZ>3mm	0	0	0	U	22	19	2014-06-28	2014-09-14	SEL   	6	5	U	6	-1	-1	-1	-1	-1	22	13	5	10	-1	-1
4xrr	1708	Very diverse, ZZ>3mm notes2=TallestHeightCm	110	0	0	U	6	6	2014-06-28	2014-09-14	SEL   	6	7	U	6	-1	-1	-1	70	5	22	11	2	10	-1	-1
5xcagr	1709	Ortets	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	10	U	6	-1	-1	-1	-1	-1	22	2	3	2	-1	-1
5xcagr	1710	ZZ>3mm	0	0	0	U	39	30	2014-04-20	2014-09-14	DC    	15	7	U	8	-1	-1	-1	-1	-1	22	8	7	8	-1	-1
5xcagr	1711	0	0	0	0	U	42	36	2014-04-20	2014-09-14	ODC   	15	7	U	6	-1	-1	-1	-1	-1	22	9	7	8	-1	-1
5xgw	1712	GA ortets - Poor - P. smithii - discard 	0	0	0	U	3	3	2014-04-20	2014-09-14	DC    	15	5	U	7	-1	-1	-1	-1	-1	22	1	8	1	-1	-1
5xrb	1713	Highly variable, ZZ>3mm notes2=TallestHeightCm	128	0	0	U	17	14	2014-06-28	2014-09-14	SEL   	6	7	U	5	-1	-1	-1	60	5	22	12	3	10	-1	-1
5xrb	1714	notes2=TallestHeightCm	0	0	0	U	16	12	2014-06-28	2014-09-14	SEL   	6	7	U	5	-1	-1	-1	-1	-1	22	13	3	10	-1	-1
6xba	1716	ZZ>3mm notes2=TallestHeightCm	115	0	0	U	24	23	2014-06-28	2014-09-14	SEL   	6	7	U	5	-1	-1	-1	82	2	22	12	2	10	-1	-1
6xba	1717	ZZ>3mm	0	0	0	U	24	23	2014-06-28	2014-09-14	SEL   	6	7	U	5	-1	-1	-1	-1	-1	22	13	2	10	-1	-1
7xbt	1718	Many ortets have blotchy yellowing late leaves. ZZ>3mm notes2=TallestHeightCm	141	0	0	U	46	42	2014-06-28	2014-09-14	SEL   	6	10	Y	5	-1	-1	-1	100	3	22	16	1	10	-1	-1
7xbt	1719	All have green leave undersides, similar to the 1xCAGW aspen types.  	0	0	0	U	46	41	2014-06-28	2014-09-14	SEL   	6	10	Y	6	-1	-1	-1	-1	-1	22	17	1	10	-1	-1
80aa3mf	1720	P3 Parent (2 mm ZZ)	0	0	0	U	2	2	2014-04-20	2014-09-14	1-0   	30	10	Y	14	-1	-1	-1	-1	-1	22	1	13	1	-1	-1
80aa3mf	1721	May have Topophysis? WASP started 4/17.	0	0	0	U	4	3	2014-04-20	2014-09-14	WASP  	6	5	U	13	-1	-1	-1	-1	-1	22	10	2	9	-1	-1
82aa3	1722	0	0	0	0	U	10	0	2014-06-28	2014-09-14	WASP  	6	5	U	0	-1	-1	-1	-1	-1	22	3	1	2	-1	-1
82aa3	1723	May have Topophysis? WASP started 4/14. 	0	0	0	U	1	1	2014-06-28	2014-09-14	WASP  	6	5	U	7	-1	-1	-1	-1	-1	22	10	5	9	-1	-1
83aa1mf	1724	P3 Parent	0	0	0	U	1	1	2014-04-20	2014-09-14	1-0   	30	10	U	14	-1	-1	-1	-1	-1	22	1	14	1	-1	-1
83aa1mf	1725	0	0	0	0	U	10	1	2014-04-20	2014-09-14	1-0   	30	10	U	5	-1	-1	-1	-1	-1	22	3	10	2	-1	-1
83aa2mf	1726	P3 Parent	0	0	0	U	2	2	2014-04-20	2014-09-14	1-0   	30	10	U	14	-1	-1	-1	-1	-1	22	1	11	1	-1	-1
83aa565	1727	tiny cuttings	0	0	0	U	10	0	2014-04-20	2014-09-14	DC    	15	3	U	0	-1	-1	-1	-1	-1	22	3	7	2	-1	-1
83aa565	1728	small cuttings	0	0	0	U	10	0	2014-04-20	2014-09-14	DC    	15	5	U	0	-1	-1	-1	-1	-1	22	3	8	2	-1	-1
83aa5mf	1729	0	0	0	0	U	10	5	2014-04-20	2014-09-14	DC    	15	3	U	5	-1	-1	-1	-1	-1	22	3	2	2	-1	-1
83aa85f	1730	Discard? ZZ>3mm	0	0	0	U	6	1	2014-04-20	2014-09-14	ODC   	15	7	U	12	-1	-1	-1	-1	-1	22	8	18	8	-1	-1
89aa1	1731	0	0	0	0	U	10	0	2014-04-20	2014-09-14	DC    	15	7	U	0	-1	-1	-1	-1	-1	22	6	10	6	-1	-1
89aa1	1732	zz=2mm ok	0	0	0	U	10	3	2014-04-20	2014-09-14	DC    	15	10	U	5	-1	-1	-1	-1	-1	22	7	13	6	-1	-1
89aa10	1733	0	0	0	0	U	10	2	2014-04-20	2014-09-14	DC    	15	7	U	4	-1	-1	-1	-1	-1	22	7	8	6	-1	-1
89aa2	1734	0	0	0	0	U	10	0	2014-04-20	2014-09-14	DC    	15	7	U	0	-1	-1	-1	-1	-1	22	6	12	6	-1	-1
89aa3	1735	0	0	0	0	U	10	0	2014-04-20	2014-09-14	DC    	15	5	U	0	-1	-1	-1	-1	-1	22	7	11	6	-1	-1
89aa4	1736	Early good rooter. ok	0	0	0	U	10	4	2014-04-20	2014-09-14	DC    	15	10	U	6	-1	-1	-1	50	-1	22	7	10	6	-1	-1
89aa5	1737	was 89xaa10-5	0	0	0	U	10	1	2014-04-20	2014-09-14	DC    	15	7	U	10	-1	-1	-1	-1	-1	22	6	8	6	-1	-1
89aa6	1738	0	0	0	0	U	10	0	2014-04-20	2014-09-14	DC    	15	7	U	0	-1	-1	-1	-1	-1	22	7	9	6	-1	-1
89aa7	1739	0	0	0	0	U	10	1	2014-04-20	2014-09-14	DC    	15	5	U	4	-1	-1	-1	-1	-1	22	7	12	6	-1	-1
89aa8	1740	0	0	0	0	U	10	0	2014-04-20	2014-09-14	DC    	15	10	U	0	-1	-1	-1	-1	-1	22	6	9	6	-1	-1
89aa9	1741	0	0	0	0	U	10	1	2014-04-20	2014-09-14	DC    	15	7	U	5	-1	-1	-1	-1	-1	22	6	11	6	-1	-1
8xbg	1742	ZZ>3mm notes2=TallestHeightCm	119	0	0	U	23	23	2014-06-28	2014-09-14	SEL   	6	7	U	6	-1	-1	-1	90	2	22	12	1	10	-1	-1
8xbg	1743	ZZ>3mm	0	0	0	U	24	23	2014-06-28	2014-09-14	SEL   	6	7	U	6	-1	-1	-1	-1	-1	22	13	1	10	-1	-1
92aa11	1744	ZZ>3mm	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	10	Y	9	-1	-1	-1	-1	-1	22	2	15	3	-1	-1
92aa11	1745	1st tree in rep is 8'+.  ZZ>3mm	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	10	Y	10	-1	-1	-1	-1	-1	22	4	2	4	-1	-1
93aa11	1746	0	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	10	U	13	-1	-1	-1	203	-1	22	2	14	3	-1	-1
93aa11	1747	0	0	0	0	U	10	4	2014-04-20	2014-09-14	DC    	15	10	U	4	-1	-1	-1	-1	-1	22	4	7	4	-1	-1
93aa12	1748	ZZ=3mm	0	0	0	U	10	5	2014-04-20	2014-09-14	DC    	15	7	Y	6	-1	-1	-1	104	-1	22	2	13	3	-1	-1
93aa12	1749	0	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	7	U	7	-1	-1	-1	-1	-1	22	5	2	4	-1	-1
95aa11	1750	0	0	0	0	U	10	10	2014-04-20	2014-09-14	DC    	15	10	U	8	-1	-1	-1	-1	-1	22	2	10	3	-1	-1
95aa11	1751	0	0	0	0	U	10	9	2014-04-20	2014-09-14	DC    	15	10	U	7	-1	-1	-1	-1	-1	22	5	3	4	-1	-1
97aa11	1752	shaded	0	0	0	U	10	6	2014-04-20	2014-09-14	DC    	15	7	U	7	-1	-1	-1	-1	-1	22	3	20	3	-1	-1
97aa11	1753	Rep 4	0	0	0	U	10	10	2014-04-20	2014-09-14	DC    	15	7	U	7	-1	-1	-1	-1	-1	22	4	1	4	-1	-1
97aa12	1754	0	0	0	0	U	10	8	2014-04-20	2014-09-14	DC    	15	10	U	9	-1	-1	-1	-1	-1	22	3	14	3	-1	-1
97aa12	1755	0	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	10	U	7	-1	-1	-1	-1	-1	22	5	9	4	-1	-1
98aa11	1756	ZZ=2mm shaded	0	0	0	U	10	5	2014-04-20	2014-09-14	DC    	15	10	U	7	-1	-1	-1	-1	-1	22	2	17	3	-1	-1
98aa11	1757	ZZ=2mm Nice!	0	0	0	U	10	9	2014-04-20	2014-09-14	DC    	15	10	Y	7	-1	-1	-1	-1	-1	22	3	12	3	-1	-1
98aa11	1758	0	0	0	0	U	10	10	2014-04-20	2014-09-14	DC    	15	10	U	6	-1	-1	-1	-1	-1	22	5	4	4	-1	-1
98aa11	1759	0	0	0	0	U	10	9	2014-04-20	2014-09-14	DC    	15	10	U	9	-1	-1	-1	-1	-1	22	5	8	4	-1	-1
9xbr	1760	ZZ>3mm notes2=TallestHeightCm 50/50 lobed to intermediate leaves.	122	0	0	U	4	4	2014-06-28	2014-09-14	SEL   	6	7	U	8	-1	-1	-1	80	5	22	11	1	10	-1	-1
a502	1761	P1/2/3 Parent	0	0	0	U	3	3	2014-04-20	2014-09-14	1-0   	30	10	U	15	-1	-1	-1	-1	-1	22	1	10	1	-1	-1
aag2001	1762	May have Topophysis? WASP started 4/2	0	0	0	U	3	3	2014-04-20	2014-09-14	WASP  	6	3	U	3	-1	-1	-1	40	-1	22	10	3	9	-1	-1
agrr1	1763	zz=2mm (verify this on ortet)	0	0	0	U	2	2	2014-04-20	2014-09-14	1-0   	30	10	U	15	-1	-1	-1	89	-1	22	7	22	7	-1	-1
agrr1	1764	0	0	0	0	U	3	0	2014-04-20	2014-09-14	DC    	15	5	U	0	-1	-1	-1	-1	-1	22	7	23	7	-1	-1
c173	1765	3/4 inch collar,Topophysis? Replace? 8 foot tall	0	0	0	U	1	1	2014-04-20	2014-09-14	1-0   	30	10	U	20	-1	-1	-1	-1	-1	22	1	7	1	-1	-1
c173	1766	0	0	0	0	U	4	0	2014-04-20	2014-09-14	1-0   	30	10	U	0	-1	-1	-1	-1	-1	22	3	9	2	-1	-1
c173	1767	May have Topophysis? WASP started 4/17.	0	0	0	U	5	4	2014-04-20	2014-09-14	WASP  	6	10	U	10	-1	-1	-1	-1	-1	22	10	1	9	-1	-1
cag204	1768	3 plantable	0	0	0	U	10	0	2014-04-20	2014-09-14	DC    	15	7	U	0	-1	-1	-1	145	-1	22	2	6	2	-1	-1
cag204	1769	0	0	0	0	U	10	5	2014-04-20	2014-09-14	DC    	15	10	U	7	-1	-1	-1	-1	-1	22	2	7	2	-1	-1
dn34	1770	Control clone	0	0	0	U	3	3	2014-04-20	2014-09-14	DC    	15	7	U	6	-1	-1	-1	138	-1	22	1	18	1	-1	-1
dn34	1771	0	0	0	0	U	19	12	2014-04-20	2014-09-14	DC    	15	7	U	7	-1	-1	-1	-1	-1	22	2	8	2	-1	-1
dn34	1772	0	0	0	0	U	10	9	2014-04-20	2014-09-14	DC    	15	7	U	5	-1	-1	-1	-1	-1	22	2	12	3	-1	-1
dn34	1773	0	0	0	0	U	10	7	2014-04-20	2014-09-14	DC    	15	7	U	6	-1	-1	-1	-1	-1	22	3	11	2	-1	-1
dn34	1774	0	0	0	0	U	10	9	2014-04-20	2014-09-14	DC    	15	7	U	9	-1	-1	-1	-1	-1	22	5	6	4	-1	-1
nfa	1776	P3 Parent	0	0	0	U	2	2	2014-04-20	2014-09-14	1-0   	30	10	U	13	-1	-1	-1	-1	-1	22	1	15	1	-1	-1
plaza	1780	WASP started Topophysis? Replace? ZZ>3mm	0	0	0	U	3	3	2014-06-28	2014-09-14	WASP  	6	5	U	7	-1	-1	-1	-1	-1	22	10	7	9	-1	-1
rr5	1781	0	0	0	0	U	8	5	2014-04-20	2014-09-14	ODC   	15	10	U	4	-1	-1	-1	-1	-1	22	9	16	8	-1	-1
tcalba	1782	Needs ID (tc72)	0	0	0	U	2	2	2014-04-20	2014-09-14	1-0   	30	10	U	15	-1	-1	-1	-1	-1	22	1	16	1	-1	-1
zoss	1788	Send to Zoss in SD, Nice	0	0	0	U	5	5	2014-04-20	2014-09-14	1-0   	30	10	U	13	-1	-1	-1	-1	-1	22	1	6	1	-1	-1
zoss	1789	rep 6	0	0	0	U	10	1	2014-04-20	2014-09-14	1-0   	30	7	U	3	-1	-1	-1	-1	-1	22	6	1	6	-1	-1
100aa11	1790	Mini-Stools - nice	10	100aa11~34-54 6rep 3dot	10	U	3	3	2015-05-08	2015-09-15	1-1   	-1	11	U	-1	15	15	-1	-1	-1	23	1	10	4	-1	-1
100aa11	1791	0	34	100aa11~34-54	34	U	10	9	2015-05-08	2015-09-15	DC    	-1	7	U	7	-1	-1	-1	-1	-1	23	2	6	1	-1	-1
100aa11	1792	0	44	100aa11~34-54	44	U	10	8	2015-05-08	2015-09-15	DC    	-1	10	U	7	-1	-1	-1	-1	-1	23	2	16	1	-1	-1
100aa11	1793	0	72	100aa11~34-54	72	U	10	9	2015-05-08	2015-09-15	DC    	-1	9	U	7	-1	-1	-1	-1	-1	23	4	5	2	-1	-1
100aa11	1794	0	85	100aa11~34-54	85	U	10	6	2015-05-08	2015-09-15	DC    	-1	6	U	7	-1	-1	-1	-1	-1	23	4	18	2	-1	-1
100aa12	1795	Mini-Stools, nice	25	100aa12~53-33 8rep 3dot 	25	U	3	3	2015-05-08	2015-09-15	1-1   	-1	11	U	-1	16	16	-1	-1	-1	23	1	25	4	-1	-1
100aa12	1796	0	47	100aa12~53-33	47	U	10	6	2015-05-08	2015-09-15	DC    	-1	11	U	6	-1	-1	-1	-1	-1	23	2	19	1	-1	-1
100aa12	1797	0	54	100aa12~53-33	54	U	10	4	2015-05-08	2015-09-15	DC    	-1	9	U	10	-1	-1	-1	-1	-1	23	3	7	1	-1	-1
100aa12	1798	0	92	100aa12~53-33	92	U	10	5	2015-05-08	2015-09-15	DC    	-1	8	U	13	-1	-1	-1	-1	-1	23	5	4	2	-1	-1
100aa12	1799	0	363	100aa12~53-33	363	U	10	8	2015-05-08	2015-09-15	DC    	-1	8	Y	10	-1	-1	-1	-1	-1	23	19	5	3	-1	-1
101aa11	1800	Mini-Stools	13	101aa11~3-1 8rep 8whip 3dot	13	U	3	3	2015-05-08	2015-09-15	1-1   	-1	11	U	-1	14	14	-1	-1	-1	23	1	13	4	-1	-1
101aa11	1801	ok	36	101aa11~3-1	36	U	10	8	2015-05-08	2015-09-15	DC    	-1	6	U	8	-1	-1	-1	-1	-1	23	2	8	1	-1	-1
101aa11	1802	Nice!	49	101aa11~3-1	49	U	10	9	2015-05-08	2015-09-15	DC    	-1	5	U	9	-1	-1	-1	-1	-1	23	3	2	1	-1	-1
101aa11	1803	nice	95	101aa11~3-1	95	U	10	6	2015-05-08	2015-09-15	DC    	-1	8	Y	12	-1	-1	-1	-1	-1	23	5	7	2	-1	-1
101aa11	1804	0	106	101aa11~3-1	106	U	10	8	2015-05-08	2015-09-15	DC    	-1	7	U	11	-1	-1	-1	-1	-1	23	5	18	2	-1	-1
101aa11	1805	0	324	101aa11~3-1	324	U	10	7	2015-05-08	2015-09-15	DC    	-1	4	Y	11	-1	-1	-1	-1	-1	23	16	1	3	-1	-1
101aa11	1806	0	348	101aa11~3-1	348	U	8	7	2015-05-08	2015-09-15	DC    	-1	4	Y	10	-1	-1	-1	-1	-1	23	18	1	3	-1	-1
104aa12	1807	Mini-Stools	18	104aa12~39-36 2rep	18	U	2	2	2015-05-08	2015-09-15	1-1   	-1	5	U	-1	13	13	-1	-1	-1	23	1	18	4	-1	-1
105aa1	1808	Ortets	189	0	189	U	1	1	2015-05-08	2015-09-15	1-0   	-1	8	U	9	9	9	-1	-1	-1	23	8	24	5	-1	-1
105aa1	1809	0	203	0	203	U	10	7	2015-05-08	2015-09-15	MS    	-1	4	U	5	6	6	-1	-1	-1	23	9	10	5	-1	-1
105aa10	1810	Ortets	193	0	193	U	1	1	2015-05-08	2015-09-15	1-0   	-1	11	U	16	16	16	-1	-1	-1	23	8	28	5	-1	-1
105aa10	1811	0	204	0	204	U	11	4	2015-05-08	2015-09-15	MS    	-1	4	U	7	8	8	-1	-1	-1	23	9	11	5	-1	-1
105aa2	1812	0	174	0	174	U	10	4	2015-05-08	2015-09-15	MS    	-1	5	U	8	14	14	-1	-1	-1	23	8	9	5	-1	-1
105aa2	1813	1.5 inch root ortets	191	0	191	U	1	1	2015-05-08	2015-09-15	1-0   	-1	10	U	10	10	10	-1	-1	-1	23	8	26	5	-1	-1
105aa3	1814	Very Nice!	202	105aa3-15-68_1_MS 6rep 3whip 2dot	202	U	15	13	2015-05-08	2015-09-15	MS    	-1	8	Y	11	11	11	-1	-1	-1	23	9	9	5	-1	-1
105aa3	1815	Ramets 1-0 Biased	221	105aa3-15-68_1_MS	221	U	1	1	2015-05-08	2015-09-15	1-0   	-1	14	Y	16	16	16	-1	-1	-1	23	9	28	5	-1	-1
105aa4	1816	nice	173	105aa4-90-136_1_MS 4rep	173	U	12	8	2015-05-08	2015-09-15	MS    	-1	5	Y	8	12	12	-1	-1	-1	23	8	8	5	-1	-1
105aa4	1817	Ramets 1-0 Biased	220	105aa4-90-136_1_MS	220	U	1	1	2015-05-08	2015-09-15	1-0   	-1	12	U	10	10	10	-1	-1	-1	23	9	27	5	-1	-1
105aa5	1818	Very Nice!	200	105aa5-7-16_1_MS 4rep 2dot 1whip	200	U	10	9	2015-05-08	2015-09-15	MS    	-1	8	Y	14	16	16	-1	-1	-1	23	9	7	5	-1	-1
105aa5	1819	Ramets 1-0	217	105aa5-7-16_1_MS	217	U	1	1	2015-05-08	2015-09-15	1-0   	-1	12	Y	17	17	17	-1	-1	-1	23	9	24	5	-1	-1
105aa6	1820	Ortets	192	0	192	U	1	1	2015-05-08	2015-09-15	1-0   	-1	10	U	12	12	12	-1	-1	-1	23	8	27	5	-1	-1
105aa6	1821	0	201	0	201	U	6	5	2015-05-08	2015-09-15	MS    	-1	5	U	6	11	11	-1	-1	-1	23	9	8	5	-1	-1
105aa7	1822	weak	177	0	177	U	11	5	2015-05-08	2015-09-15	MS    	-1	6	U	4	11	11	-1	-1	-1	23	8	12	5	-1	-1
105aa7	1823	Ramets 1-0	219	0	219	U	1	1	2015-05-08	2015-09-15	1-0   	-1	11	U	15	15	15	-1	-1	-1	23	9	26	5	-1	-1
105aa8	1824	ok, retry	176	0	176	U	10	6	2015-05-08	2015-09-15	MS    	-1	4	U	4	14	14	-1	-1	-1	23	8	11	5	-1	-1
105aa8	1825	Ramets 1-0	218	0	218	U	1	1	2015-05-08	2015-09-15	1-0   	-1	10	U	14	14	14	-1	-1	-1	23	9	25	5	-1	-1
105aa9	1826	ok, retry	175	0	175	U	10	8	2015-05-08	2015-09-15	DC    	-1	5	U	7	-1	-1	-1	-1	-1	23	8	10	5	-1	-1
105aa9	1827	Ortets	190	0	190	U	1	1	2015-05-08	2015-09-15	1-0   	-1	10	U	10	10	10	-1	-1	-1	23	8	25	5	-1	-1
106aa1	1828	0	373	106aa1-54-58_1_MS 3rep	373	U	6	5	2015-05-08	2015-09-15	MS    	-1	6	Y	8	15	15	-1	-1	-1	23	20	4	7	-1	-1
106aa2	1829	0	377	106aa2-78-59_1_MS	377	U	6	5	2015-05-08	2015-09-15	MS    	-1	4	Y	7	16	16	-1	-1	-1	23	20	8	7	-1	-1
106aa3	1830	Nice! 1-0	390	106aa3-168-73_1_MS 3rep	390	U	6	5	2015-05-08	2015-09-15	MS    	-1	4	Y	4	18	18	-1	-1	-1	23	21	7	7	-1	-1
106aa4	1831	0	389	106aa4-28-34_1_MS 3rep	389	U	6	6	2015-05-08	2015-09-15	MS    	-1	4	Y	8	14	14	-1	-1	-1	23	21	6	7	-1	-1
106aa5	1832	0	374	0	374	U	5	4	2015-05-08	2015-09-15	MS    	-1	4	U	6	15	15	-1	-1	-1	23	20	5	7	-1	-1
106aa6	1833	0	388	106aa6-65-28_1_MS 3rep	388	U	5	5	2015-05-08	2015-09-15	MS    	-1	4	Y	6	17	17	-1	-1	-1	23	21	5	7	-1	-1
106aa7	1834	0	375	0	375	U	5	4	2015-05-08	2015-09-15	MS    	-1	4	U	6	10	10	-1	-1	-1	23	20	6	7	-1	-1
106aa8	1835	0	376	0	376	U	5	5	2015-05-08	2015-09-15	MS    	-1	4	U	6	14	14	-1	-1	-1	23	20	7	7	-1	-1
106xaa	1836	8 inch stem ortets ODC	438	106xaa 8rep	438	U	10	8	2015-05-08	2015-09-15	ODC   	-1	4	U	9	22	22	-1	-1	-1	23	26	1	8	-1	-1
106xaa	1837	8 inch stem ortets ODC	441	0	441	U	10	10	2015-05-08	2015-09-15	ODC   	-1	4	U	7	17	17	-1	-1	-1	23	27	4	8	-1	-1
107aa1	1838	0	391	107aa1-104-49_1_1-0 3rep	391	U	6	5	2015-05-08	2015-09-15	1-0   	-1	4	Y	6	19	19	-1	-1	-1	23	21	8	7	-1	-1
107aa2	1839	0	380	107aa2-101-60_1_MS 3rep	380	U	6	5	2015-05-08	2015-09-15	MS    	-1	8	Y	6	17	17	-1	-1	-1	23	20	11	7	-1	-1
107aa3	1840	0	378	107aa3 3rep	378	U	6	6	2015-05-08	2015-09-15	MS    	-1	5	U	5	12	12	-1	-1	-1	23	20	9	7	-1	-1
107aa4	1841	0	394	0	394	U	6	6	2015-05-08	2015-09-15	MS    	-1	5	N	5	15	15	-1	-1	-1	23	21	11	7	-1	-1
107aa5	1842	0	392	0	392	U	6	5	2015-05-08	2015-09-15	ODC   	-1	4	U	3	10	10	-1	-1	-1	23	21	9	7	-1	-1
107aa6	1843	0	379	0	379	U	5	4	2015-05-08	2015-09-15	MS    	-1	5	U	5	15	15	-1	-1	-1	23	20	10	7	-1	-1
107aa7	1844	0	393	107aa7-93-37_1_MS	393	U	6	6	2015-05-08	2015-09-15	MS    	-1	5	Y	5	17	17	-1	-1	-1	23	21	10	7	-1	-1
107xaa	1845	8 inch stem ortets ODC	440	107xaa 18rep	440	U	19	15	2015-05-08	2015-09-15	ODC   	-1	6	U	6	14	14	-1	-1	-1	23	26	3	8	-1	-1
107xaa	1846	8 inch stem ortets ODC	443	0	443	U	22	23	2015-05-08	2015-09-15	ODC   	-1	6	U	8	21	21	-1	-1	-1	23	27	6	8	-1	-1
11ab1	1847	smaller leaves	304	11ab1-77-71_1_MS 3rep	304	U	6	5	2015-05-08	2015-09-15	MS    	-1	5	Y	7	15	15	-1	-1	-1	23	14	10	6	-1	-1
11ab10	1848	0	308	11ab10-106-38_1_MS 2rep	308	U	6	5	2015-05-08	2015-09-15	MS    	-1	5	Y	6	20	20	-1	-1	-1	23	14	14	6	-1	-1
11ab11	1849	ok retry	307	11ab11-165-185_1_MS 2rep	307	U	6	3	2015-05-08	2015-09-15	MS    	-1	5	Y	7	13	13	-1	-1	-1	23	14	13	6	-1	-1
11ab12	1850	0	303	0	303	U	6	4	2015-05-08	2015-09-15	MS    	-1	5	U	7	16	16	-1	-1	-1	23	14	9	6	-1	-1
11ab2	1851	0	317	0	317	U	6	3	2015-05-08	2015-09-15	ODC   	-1	5	U	7	19	19	-1	-1	-1	23	15	9	6	-1	-1
11ab20	1852	Renamed from ?	273	11ab20-169-39_1_MS 2rep	273	U	6	5	2015-05-08	2015-09-15	MS    	-1	4	Y	4	22	22	-1	-1	-1	23	12	13	6	-1	-1
11ab21	1853	Renamed from ?	290	0	290	U	6	6	2015-05-08	2015-09-15	MS    	-1	5	N	6	14	14	-1	-1	-1	23	13	13	6	-1	-1
11ab22	1854	Renamed from ?	291	11ab22-46-20_1_MS 3rep	291	U	6	6	2015-05-08	2015-09-15	MS    	-1	5	Y	7	18	18	-1	-1	-1	23	13	14	6	-1	-1
11ab3	1855	0	305	11ab3-53-57_1_MS 3rep	305	U	6	5	2015-05-08	2015-09-15	MS    	-1	5	Y	8	15	15	-1	-1	-1	23	14	11	6	-1	-1
11ab4	1856	0	321	11ab4-88-118_1_1-0 2rep	321	U	6	4	2015-05-08	2015-09-15	1-0   	-1	6	Y	8	14	14	-1	-1	-1	23	15	13	6	-1	-1
11ab5	1857	0	319	11ab5 3rep	319	U	6	5	2015-05-08	2015-09-15	DC    	-1	6	Y	7	17	17	-1	-1	-1	23	15	11	6	-1	-1
11ab6	1858	0	320	0	320	U	6	4	2015-05-08	2015-09-15	ODC   	-1	6	U	6	15	15	-1	-1	-1	23	15	12	6	-1	-1
11ab7	1859	0	318	0	318	U	6	4	2015-05-08	2015-09-15	ODC   	-1	6	U	6	19	19	-1	-1	-1	23	15	10	6	-1	-1
11ab8	1860	0	322	0	322	U	6	3	2015-05-08	2015-09-15	ODC   	-1	5	U	7	13	13	-1	-1	-1	23	15	14	6	-1	-1
11ab9	1861	0	306	0	306	U	6	4	2015-05-08	2015-09-15	MS    	-1	4	U	5	9	9	-1	-1	-1	23	14	12	6	-1	-1
22bg7	2007	0	195	22bg7 2rep	195	U	5	2	2015-05-08	2015-09-15	MS    	-1	4	U	7	21	21	-1	-1	-1	23	9	2	5	-1	-1
11xab	1862	8 inch stem ortets ODC	428	11xab 12rep	428	U	22	20	2015-05-08	2015-09-15	ODC   	-1	5	U	7	14	14	-1	-1	-1	23	24	9	8	-1	-1
11xab	1863	8 inch stem ortets ODC	437	0	437	U	26	23	2015-05-08	2015-09-15	ODC   	-1	5	U	9	24	24	-1	-1	-1	23	25	9	8	-1	-1
13gb1	1864	0	292	0	292	U	6	0	2015-05-08	2015-09-15	MS    	-1	6	U	0	15	15	-1	-1	-1	23	13	15	6	-1	-1
13gb10	1865	0	276	0	276	U	5	0	2015-05-08	2015-09-15	MS    	-1	4	U	0	12	12	-1	-1	-1	23	12	16	6	-1	-1
13gb2	1866	0	309	0	309	U	6	1	2015-05-08	2015-09-15	DC    	-1	4	U	6	13	13	-1	-1	-1	23	15	1	6	-1	-1
13gb3	1867	0	310	13gb3 2rep	310	U	6	1	2015-05-08	2015-09-15	DC    	-1	5	U	7	18	18	-1	-1	-1	23	15	2	6	-1	-1
13gb4	1868	0	295	0	295	U	6	2	2015-05-08	2015-09-15	MS    	-1	4	U	3	15	15	-1	-1	-1	23	14	1	6	-1	-1
13gb5	1869	0	277	0	277	U	5	0	2015-05-08	2015-09-15	MS    	-1	4	U	0	17	17	-1	-1	-1	23	12	17	6	-1	-1
13gb6	1870	Nice!	293	13gb6-213-182_1_MS 2rep	293	U	5	2	2015-05-08	2015-09-15	MS    	-1	4	Y	6	20	20	-1	-1	-1	23	13	16	6	-1	-1
13gb7	1871	retry	294	13gb7-283-272_1_MS 1rep	294	U	5	1	2015-05-08	2015-09-15	MS    	-1	4	Y	3	19	19	-1	-1	-1	23	13	17	6	-1	-1
13gb8	1872	0	275	0	275	U	6	1	2015-05-08	2015-09-15	MS    	-1	4	U	4	13	13	-1	-1	-1	23	12	15	6	-1	-1
13gb9	1873	0	274	0	274	U	6	1	2015-05-08	2015-09-15	MS    	-1	4	U	8	14	14	-1	-1	-1	23	12	14	6	-1	-1
13xgb	1874	8 inch stem ortets ODC, weak	422	13xgb 2rep	422	U	7	4	2015-05-08	2015-09-15	ODC   	-1	4	N	4	7	7	-1	-1	-1	23	24	3	8	-1	-1
13xgb	1875	8 inch stem ortets ODC	431	0	431	U	8	5	2015-05-08	2015-09-15	ODC   	-1	4	U	5	12	12	-1	-1	-1	23	25	3	8	-1	-1
14b1	1876	Roots have twist, nice	247	14b1-125-90_1_MS 3rep	247	U	9	8	2015-05-08	2015-09-15	MS    	-1	5	Y	5	14	14	-1	-1	-1	23	11	6	6	-1	-1
14b10	1877	0	228	14b10-30-85_1_MS 4rep	228	U	6	6	2015-05-08	2015-09-15	MS    	-1	5	Y	8	9	9	-1	-1	-1	23	10	7	6	-1	-1
14b11	1878	0	225	14b11-171-122_1_MS 3rep	225	U	6	5	2015-05-08	2015-09-15	MS    	-1	4	Y	4	13	13	-1	-1	-1	23	10	4	6	-1	-1
14b12	1879	0	248	14b12-133-102_1_MS 3rep	248	U	6	5	2015-05-08	2015-09-15	MS    	-1	4	Y	5	14	14	-1	-1	-1	23	11	7	6	-1	-1
14b13	1880	Nice!	252	14b13-94-30_1_MS 3rep	252	U	6	6	2015-05-08	2015-09-15	MS    	-1	5	Y	5	18	18	-1	-1	-1	23	11	11	6	-1	-1
14b14	1881	0	230	14b14-109-9_2_MS 3rep	230	U	5	3	2015-05-08	2015-09-15	MS    	-1	4	Y	6	18	18	-1	-1	-1	23	10	9	6	-1	-1
14b14	1882	0	244	14b14-109-9_2_MS	244	U	6	5	2015-05-08	2015-09-15	MS    	-1	5	Y	5	20	20	-1	-1	-1	23	11	3	6	-1	-1
14b15	1883	0	233	14b15-102-101_1_MS  3rep	233	U	6	5	2015-05-08	2015-09-15	MS    	-1	4	Y	6	13	13	-1	-1	-1	23	10	12	6	-1	-1
14b16	1884	0	232	14b16 2rep	232	U	6	5	2015-05-08	2015-09-15	MS    	-1	5	U	5	12	12	-1	-1	-1	23	10	11	6	-1	-1
14b17	1885	0	251	14b17-95-75_1_MS  3rep	251	U	6	6	2015-05-08	2015-09-15	MS    	-1	5	Y	5	13	13	-1	-1	-1	23	11	10	6	-1	-1
14b18	1886	0	229	14b18-66-29_1_MS 3rep	229	U	6	6	2015-05-08	2015-09-15	MS    	-1	6	Y	6	17	17	-1	-1	-1	23	10	8	6	-1	-1
14b19	1887	0	224	14b19-162-178_1_MS 3rep	224	U	6	3	2015-05-08	2015-09-15	MS    	-1	5	Y	7	14	14	-1	-1	-1	23	10	3	6	-1	-1
14b2	1888	0	226	0	226	U	5	4	2015-05-08	2015-09-15	MS    	-1	3	U	4	11	11	-1	-1	-1	23	10	5	6	-1	-1
14b20	1889	0	250	14b20-92-88_1_MS 3rep	250	U	6	6	2015-05-08	2015-09-15	MS    	-1	5	Y	5	12	12	-1	-1	-1	23	11	9	6	-1	-1
14b21	1890	0	231	14b21-50-47_1_MS 3rep	231	U	6	6	2015-05-08	2015-09-15	MS    	-1	6	Y	7	14	14	-1	-1	-1	23	10	10	6	-1	-1
14b3	1891	0	245	14b3-146-131_1_MS 3rep	245	U	6	4	2015-05-08	2015-09-15	MS    	-1	4	Y	6	15	15	-1	-1	-1	23	11	4	6	-1	-1
14b5	1892	0	227	0	227	U	6	6	2015-05-08	2015-09-15	MS    	-1	4	U	5	10	10	-1	-1	-1	23	10	6	6	-1	-1
14b6	1893	0	246	14b6-134-103_1_MS 3rep	246	U	6	5	2015-05-08	2015-09-15	MS    	-1	4	Y	5	14	14	-1	-1	-1	23	11	5	6	-1	-1
14b7	1894	Nice	249	14b7-56-100_1_MS  3rep 1dot	249	U	6	5	2015-05-08	2015-09-15	MS    	-1	6	Y	8	11	11	-1	-1	-1	23	11	8	6	-1	-1
14b8	1895	0	253	0	253	U	6	4	2015-05-08	2015-09-15	MS    	-1	5	N	6	10	10	-1	-1	-1	23	11	12	6	-1	-1
14b9	1896	0	234	14b9-197-166_1_MS 1rep	234	U	6	4	2015-05-08	2015-09-15	MS    	-1	4	Y	4	13	13	-1	-1	-1	23	10	13	6	-1	-1
14xb	1897	8 inch stem ortets ODC	420	14xb 22rep	420	U	25	22	2015-05-08	2015-09-15	ODC   	-1	4	U	7	13	13	-1	-1	-1	23	24	1	8	-1	-1
14xb	1898	8 inch stem ortets ODC	429	0	429	U	28	28	2015-05-08	2015-09-15	ODC   	-1	4	U	6	17	17	-1	-1	-1	23	25	1	8	-1	-1
15b1	1899	Very tall in 2014, weak but retry.	114	15b1-200-167_1_MS 3rep	114	U	9	6	2015-05-08	2015-09-15	MS    	-1	5	Y	4	13	13	-1	-1	-1	23	6	5	5	-1	-1
15b10	1900	0	146	0	146	U	6	3	2015-05-08	2015-09-15	MS    	-1	4	U	5	7	7	-1	-1	-1	23	7	10	5	-1	-1
15b11	1901	0	223	15b11-170-51_1_MS 3rep	223	U	6	5	2015-05-08	2015-09-15	MS    	-1	7	Y	4	21	21	-1	-1	-1	23	10	2	6	-1	-1
15b12	1902	0	148	15b12-175-176_1_MS 3rep	148	U	6	4	2015-05-08	2015-09-15	MS    	-1	4	Y	5	11	11	-1	-1	-1	23	7	12	5	-1	-1
15b13	1903	0	145	0	145	U	4	1	2015-05-08	2015-09-15	MS    	-1	4	U	4	8	8	-1	-1	-1	23	7	9	5	-1	-1
15b14	1904	0	242	15b14-198-93_1_MS 2rep	242	U	6	4	2015-05-08	2015-09-15	MS    	-1	8	Y	4	21	21	-1	-1	-1	23	11	1	6	-1	-1
15b15	1905	0	118	0	118	U	6	3	2015-05-08	2015-09-15	MS    	-1	4	U	4	8	8	-1	-1	-1	23	6	9	5	-1	-1
15b16	1906	0	243	15b16-135-114_1_MS 3rep	243	U	6	5	2015-05-08	2015-09-15	MS    	-1	4	Y	5	13	13	-1	-1	-1	23	11	2	6	-1	-1
15b17	1907	Rep 6 Ramets	222	15b17-75-23_1_MS 3rep	222	U	6	5	2015-05-08	2015-09-15	MS    	-1	7	Y	7	22	22	-1	-1	-1	23	10	1	6	-1	-1
15b2	1908	0	115	0	115	U	4	2	2015-05-08	2015-09-15	MS    	-1	4	U	4	6	6	-1	-1	-1	23	6	6	5	-1	-1
15b3	1909	weak	116	0	116	U	9	5	2015-05-08	2015-09-15	MS    	-1	5	U	4	8	8	-1	-1	-1	23	6	7	5	-1	-1
15b4	1910	Curly stems	147	15b4 2rep	147	U	5	2	2015-05-08	2015-09-15	MS    	-1	6	U	4	13	13	-1	-1	-1	23	7	11	5	-1	-1
15b5	1911	weak, retry	120	15b5-205-203_1_MS  2rep	120	U	6	3	2015-05-08	2015-09-15	MS    	-1	5	Y	5	13	13	-1	-1	-1	23	6	11	5	-1	-1
15b6	1912	0	144	15b6-232-187_1_MS  2rep	144	U	6	3	2015-05-08	2015-09-15	MS    	-1	5	Y	4	16	16	-1	-1	-1	23	7	8	5	-1	-1
15b7	1913	0	119	0	119	U	6	2	2015-05-08	2015-09-15	MS    	-1	5	U	4	6	6	-1	-1	-1	23	6	10	5	-1	-1
15b8	1914	0	149	15b8-167-162_1_MS 3rep	149	U	6	5	2015-05-08	2015-09-15	MS    	-1	5	Y	4	10	10	-1	-1	-1	23	7	13	5	-1	-1
15b9	1915	0	117	0	117	U	5	0	2015-05-08	2015-09-15	MS    	-1	4	U	0	10	10	-1	-1	-1	23	6	8	5	-1	-1
16ab1	1916	0	412	0	412	U	6	4	2015-05-08	2015-09-15	ODC   	-1	6	Y	12	20	20	-1	-1	-1	23	23	5	7	-1	-1
16ab2	1917	0	411	0	411	U	5	2	2015-05-08	2015-09-15	ODC   	-1	4	Y	-1	24	24	-1	-1	-1	23	23	4	7	-1	-1
16ab3	1918	0	399	16ab3 0rep 1dot	399	U	6	3	2015-05-08	2015-09-15	MS    	-1	5	U	8	18	18	-1	-1	-1	23	22	3	7	-1	-1
16ab4	1919	Nice	413	16ab4 3rep 1dot	413	U	5	4	2015-05-08	2015-09-15	ODC   	-1	5	Y	8	18	18	-1	-1	-1	23	23	6	7	-1	-1
16ab5	1920	weak	400	0	400	U	5	2	2015-05-08	2015-09-15	MS    	-1	4	U	5	17	17	-1	-1	-1	23	22	4	7	-1	-1
16ab6	1921	0	401	0	401	U	5	4	2015-05-08	2015-09-15	MS    	-1	3	U	4	14	14	-1	-1	-1	23	22	5	7	-1	-1
16ab7	1922	0	410	16ab7 0rep 1whip	410	U	6	3	2015-05-08	2015-09-15	ODC   	-1	4	U	4	16	16	-1	-1	-1	23	23	3	7	-1	-1
16ab8	1923	Nice!	402	16ab8-40-21_1_MS	402	U	6	4	2015-05-08	2015-09-15	MS    	-1	5	Y	11	26	26	-1	-1	-1	23	22	6	7	-1	-1
16xab	1924	8 inch stem ortets ODC	425	16xab 8rep	425	U	12	10	2015-05-08	2015-09-15	ODC   	-1	4	U	8	12	12	-1	-1	-1	23	24	6	8	-1	-1
16xab	1925	8 inch stem ortets ODC	434	0	434	U	13	13	2015-05-08	2015-09-15	DC    	-1	4	U	8	14	14	-1	-1	-1	23	25	6	8	-1	-1
17b1	1926	0	141	0	141	U	5	1	2015-05-08	2015-09-15	MS    	-1	4	U	4	5	5	-1	-1	-1	23	7	5	5	-1	-1
17b2	1927	Shriveled leaves	142	0	142	U	5	4	2015-05-08	2015-09-15	MS    	-1	4	N	4	16	16	-1	-1	-1	23	7	6	5	-1	-1
17b3	1928	Nice leaves!	143	17b3-278-285_1_MS 1rep	143	U	4	1	2015-05-08	2015-09-15	MS    	-1	4	Y	3	12	12	-1	-1	-1	23	7	7	5	-1	-1
18bg1	1929	0	125	18bg1-103-91_1_MS 4rep	125	U	6	5	2015-05-08	2015-09-15	MS    	-1	6	Y	6	14	14	-1	-1	-1	23	6	16	5	-1	-1
18bg10	1930	0	132	0	132	U	6	4	2015-05-08	2015-09-15	MS    	-1	5	U	4	8	8	-1	-1	-1	23	6	23	5	-1	-1
18bg11	1931	0	162	18bg11 1rep	162	U	6	2	2015-05-08	2015-09-15	MS    	-1	5	U	4	14	14	-1	-1	-1	23	7	26	5	-1	-1
18bg12	1932	0	130	18bg12 1rep	130	U	6	2	2015-05-08	2015-09-15	MS    	-1	5	U	4	14	14	-1	-1	-1	23	6	21	5	-1	-1
18bg13	1933	0	161	18bg13-209-186_1_MS 3rep	161	U	6	3	2015-05-08	2015-09-15	MS    	-1	5	Y	5	15	15	-1	-1	-1	23	7	25	5	-1	-1
18bg14	1934	0	133	0	133	U	6	4	2015-05-08	2015-09-15	MS    	-1	5	U	4	8	8	-1	-1	-1	23	6	24	5	-1	-1
18bg15	1935	Nice!	160	18bg15-136-72_1_MS 2rep	160	U	6	5	2015-05-08	2015-09-15	MS    	-1	4	Y	5	17	17	-1	-1	-1	23	7	24	5	-1	-1
18bg16	1936	0	158	0	158	U	5	3	2015-05-08	2015-09-15	MS    	-1	3	U	4	11	11	-1	-1	-1	23	7	22	5	-1	-1
18bg17	1937	0	126	18bg17 2rep	126	U	5	2	2015-05-08	2015-09-15	MS    	-1	5	U	5	14	14	-1	-1	-1	23	6	17	5	-1	-1
18bg18	1938	retry?	123	18bg18 2rep	123	U	4	2	2015-05-08	2015-09-15	MS    	-1	4	U	4	16	16	-1	-1	-1	23	6	14	5	-1	-1
18bg19	1939	retry	134	18bg19-76-70_1_MS 3rep	134	U	6	5	2015-05-08	2015-09-15	MS    	-1	5	Y	7	15	15	-1	-1	-1	23	6	25	5	-1	-1
18bg2	1940	Nice!	156	18bg2-105-54_1_MS	156	U	6	5	2015-05-08	2015-09-15	MS    	-1	6	Y	6	18	18	-1	-1	-1	23	7	20	5	-1	-1
18bg20	1941	0	155	18bg20 3rep	155	U	6	4	2015-05-08	2015-09-15	MS    	-1	4	U	4	12	12	-1	-1	-1	23	7	19	5	-1	-1
18bg21	1942	0	152	18bg21 2rep	152	U	6	3	2015-05-08	2015-09-15	MS    	-1	5	U	4	15	15	-1	-1	-1	23	7	16	5	-1	-1
18bg22	1943	0	121	18bg22 2rep	121	U	6	5	2015-05-08	2015-09-15	MS    	-1	5	U	5	10	10	-1	-1	-1	23	6	12	5	-1	-1
18bg23	1944	0	157	18bg23-161-168_1_MS 3rep	157	U	6	3	2015-05-08	2015-09-15	MS    	-1	4	Y	7	15	15	-1	-1	-1	23	7	21	5	-1	-1
18bg24	1945	0	129	18bg24-174-132_1_MS 2rep	129	U	6	4	2015-05-08	2015-09-15	MS    	-1	5	Y	5	16	16	-1	-1	-1	23	6	20	5	-1	-1
18bg25	1946	Cuttings rooted on side - see pic	153	18bg25-172-146_1_MS 3rep 	153	U	6	4	2015-05-08	2015-09-15	MS    	-1	5	Y	5	14	14	-1	-1	-1	23	7	17	5	-1	-1
18bg26	1947	0	124	0	124	U	6	0	2015-05-08	2015-09-15	MS    	-1	6	U	0	6	6	-1	-1	-1	23	6	15	5	-1	-1
18bg27	1948	0	154	0	154	U	6	4	2015-05-08	2015-09-15	MS    	-1	4	U	4	8	8	-1	-1	-1	23	7	18	5	-1	-1
18bg28	1949	0	151	0	151	U	6	0	2015-05-08	2015-09-15	DC    	-1	6	U	0	11	11	-1	-1	-1	23	7	15	5	-1	-1
18bg29	1950	0	150	0	150	U	6	1	2015-05-08	2015-09-15	MS    	-1	6	U	6	10	10	-1	-1	-1	23	7	14	5	-1	-1
18bg3	1951	retry	122	18bg3 3rep	122	U	6	3	2015-05-08	2015-09-15	DC    	-1	5	Y	7	16	16	-1	-1	-1	23	6	13	5	-1	-1
18bg30	1952	0	163	0	163	U	5	3	2015-05-08	2015-09-15	MS    	-1	5	U	4	9	9	-1	-1	-1	23	7	27	5	-1	-1
18bg4	1953	0	128	0	128	U	5	2	2015-05-08	2015-09-15	MS    	-1	5	U	8	10	10	-1	-1	-1	23	6	19	5	-1	-1
18bg5	1954	0	164	18bg5-230-181_1_MS 1rep	164	U	6	3	2015-05-08	2015-09-15	MS    	-1	4	Y	4	17	17	-1	-1	-1	23	7	28	5	-1	-1
18bg6	1955	0	127	0	127	U	5	0	2015-05-08	2015-09-15	MS    	-1	4	U	0	10	10	-1	-1	-1	23	6	18	5	-1	-1
18bg7	1956	0	159	0	159	U	6	4	2015-05-08	2015-09-15	MS    	-1	4	U	7	6	6	-1	-1	-1	23	7	23	5	-1	-1
18bg8	1957	0	131	18bg8 2rep	131	U	6	3	2015-05-08	2015-09-15	MS    	-1	5	U	5	9	9	-1	-1	-1	23	6	22	5	-1	-1
18bg9	1958	0	135	18bg9 3rep	135	U	6	5	2015-05-08	2015-09-15	MS    	-1	4	U	4	10	10	-1	-1	-1	23	6	26	5	-1	-1
18xbg	1959	8 inch stem ortets ODC	423	18xbg 14rep	423	U	25	18	2015-05-08	2015-09-15	ODC   	-1	4	U	8	14	14	-1	-1	-1	23	24	4	8	-1	-1
18xbg	1960	8 inch stem ortets ODC	432	0	432	U	24	19	2015-05-08	2015-09-15	WASP  	-1	4	U	7	16	16	-1	-1	-1	23	25	4	8	-1	-1
19gb1	1961	0	271	19gb1-201-119_1_MS 2rep	271	U	6	4	2015-05-08	2015-09-15	MS    	-1	5	Y	4	18	18	-1	-1	-1	23	12	11	6	-1	-1
19gb10	1962	0	270	0	270	U	6	0	2015-05-08	2015-09-15	MS    	-1	4	U	0	11	11	-1	-1	-1	23	12	10	6	-1	-1
19gb11	1963	0	268	0	268	U	5	1	2015-05-08	2015-09-15	MS    	-1	4	U	5	16	16	-1	-1	-1	23	12	8	6	-1	-1
19gb2	1964	retry Do I need 6 reps?	284	19gb2-264-274_1_MS 6rep	284	U	6	1	2015-05-08	2015-09-15	MS    	-1	5	Y	8	18	18	-1	-1	-1	23	13	7	6	-1	-1
19gb3	1965	0	272	0	272	U	6	1	2015-05-08	2015-09-15	MS    	-1	3	U	4	12	12	-1	-1	-1	23	12	12	6	-1	-1
19gb4	1966	weak	287	0	287	U	4	2	2015-05-08	2015-09-15	MS    	-1	6	N	6	7	7	-1	-1	-1	23	13	10	6	-1	-1
19gb5	1967	0	289	0	289	U	6	2	2015-05-08	2015-09-15	MS    	-1	5	U	5	10	10	-1	-1	-1	23	13	12	6	-1	-1
19gb6	1968	0	286	0	286	U	6	1	2015-05-08	2015-09-15	MS    	-1	4	U	8	15	15	-1	-1	-1	23	13	9	6	-1	-1
19gb7	1969	0	285	0	285	U	4	0	2015-05-08	2015-09-15	MS    	-1	3	U	0	14	14	-1	-1	-1	23	13	8	6	-1	-1
19gb8	1970	0	288	0	288	U	6	1	2015-05-08	2015-09-15	MS    	-1	4	U	6	13	13	-1	-1	-1	23	13	11	6	-1	-1
19gb9	1971	retry	269	19gb9-246-270_1_MS 2rep	269	U	6	1	2015-05-08	2015-09-15	MS    	-1	5	Y	10	18	18	-1	-1	-1	23	12	9	6	-1	-1
19xgb	1972	8 inch stem ortets ODC	424	19xgb 6rep	424	U	11	9	2015-05-08	2015-09-15	ODC   	-1	3	U	7	11	11	-1	-1	-1	23	24	5	8	-1	-1
19xgb	1973	8 inch stem ortets ODC	433	0	433	U	13	7	2015-05-08	2015-09-15	DC    	-1	3	U	5	12	12	-1	-1	-1	23	25	5	8	-1	-1
2b6	1974	Mini-Stools	6	2b6~37-12	6	U	3	3	2015-05-08	2015-09-15	1-1   	-1	12	U	-1	16	16	-1	-1	-1	23	1	6	4	-1	-1
1bar1	1975	weak, retry for testing	403	1bar1-304-340_1_1-0 1rep	403	U	3	0	2015-05-08	2015-09-15	1-0   	-1	3	Y	0	8	8	-1	-1	-1	23	22	7	7	-1	-1
1bar2	1976	0	414	1bar2 1rep	414	U	2	0	2015-05-08	2015-09-15	1-0   	-1	3	U	0	8	8	-1	-1	-1	23	23	7	7	-1	-1
1bw1	1977	Mini-Stools - Renamed from 1cagw01 to 1BW1	7	1bw1 5rep 2whip 1dot	7	U	3	3	2015-05-08	2015-09-15	1-1   	-1	12	U	-1	12	12	-1	-1	-1	23	1	7	4	-1	-1
1bw1	1978	Renamed from 1cagw01 to 1BW1	48	0	48	U	10	8	2015-05-08	2015-09-15	DC    	-1	8	U	8	-1	-1	-1	-1	-1	23	3	1	1	-1	-1
1bw1	1979	Renamed from 1cagw01 to 1BW1	58	0	58	U	10	5	2015-05-08	2015-09-15	DC    	-1	7	U	6	-1	-1	-1	-1	-1	23	3	11	1	-1	-1
1bw1	1980	Renamed from 1cagw01 to 1BW1	75	0	75	U	10	7	2015-05-08	2015-09-15	DC    	-1	8	U	9	-1	-1	-1	-1	-1	23	4	8	2	-1	-1
1bw1	1981	Renamed from 1cagw01 to 1BW1	103	0	103	U	10	7	2015-05-08	2015-09-15	DC    	-1	8	U	8	-1	-1	-1	-1	-1	23	5	15	2	-1	-1
1bw1	1982	Renamed from 1cagw01 to 1BW1	329	0	329	U	10	3	2015-05-08	2015-09-15	DC    	-1	5	U	5	-1	-1	-1	-1	-1	23	16	6	3	-1	-1
1bw1	1983	Renamed from 1cagw01 to 1BW1	340	0	340	U	10	6	2015-05-08	2015-09-15	DC    	-1	6	U	9	-1	-1	-1	-1	-1	23	17	5	3	-1	-1
1bw6	1984	Awesome alba type Nice! - renamed from 1cagw6 to 1bw6	254	1cagw6-16-19_1_MS 4rep 2dot 5whip	254	U	16	15	2015-05-08	2015-09-15	MS    	-1	10	Y	10	18	18	-1	-1	-1	23	11	13	6	-1	-1
1cagw7	1985	(dont retain or rename) 6 inch- Small tooth aspen type	235	0	235	U	14	10	2015-05-08	2015-09-15	MS    	-1	10	U	5	17	17	-1	-1	-1	23	10	14	6	-1	-1
20bs1	1986	Nice!	396	20bs1-11-8_1_MS 3rep	396	U	6	6	2015-05-08	2015-09-15	MS    	-1	8	Y	10	23	23	-1	-1	-1	23	21	13	7	-1	-1
20bs2	1987	0	382	0	382	U	6	4	2015-05-08	2015-09-15	MS    	-1	7	U	4	12	12	-1	-1	-1	23	20	13	7	-1	-1
20bs3	1988	0	409	20bs3-31-17_1_MS 3rep	409	U	5	5	2015-05-08	2015-09-15	MS    	-1	8	Y	8	19	19	-1	-1	-1	23	23	2	7	-1	-1
20bs4	1989	Nice	383	20bs4-22-32_1_MS 3rep	383	U	5	4	2015-05-08	2015-09-15	MS    	-1	4	Y	11	17	17	-1	-1	-1	23	20	14	7	-1	-1
20bs5	1990	0	395	20bs5-29-35_1_MS 3rep	395	U	6	6	2015-05-08	2015-09-15	MS    	-1	4	Y	8	14	14	-1	-1	-1	23	21	12	7	-1	-1
20bs6	1991	0	397	20bs6-51-36_1_MS 3rep	397	U	6	6	2015-05-08	2015-09-15	MS    	-1	6	Y	7	15	15	-1	-1	-1	23	22	1	7	-1	-1
20bs7	1992	0	408	20bs7 1dot	408	U	6	5	2015-05-08	2015-09-15	1-0   	-1	4	U	8	18	18	-1	-1	-1	23	23	1	7	-1	-1
20bs8	1993	0	381	20bs8-71-56_1_MS 3rep	381	U	6	4	2015-05-08	2015-09-15	MS    	-1	8	Y	9	20	20	-1	-1	-1	23	20	12	7	-1	-1
20bs9	1994	ok	398	20bs9-39-42_1_MS 3rep	398	U	6	4	2015-05-08	2015-09-15	MS    	-1	4	Y	11	21	21	-1	-1	-1	23	22	2	7	-1	-1
20xbs	1995	8 inch stem ortets ODC	426	20xbs 13rep	426	U	15	13	2015-05-08	2015-09-15	ODC   	-1	4	U	8	14	14	-1	-1	-1	23	24	7	8	-1	-1
20xbs	1996	8 inch stem ortets ODC	435	0	435	U	14	14	2015-05-08	2015-09-15	DC    	-1	4	U	8	14	14	-1	-1	-1	23	25	7	8	-1	-1
22bg1	1997	ok retry	196	22bg1-47-92_1_MS 3rep	196	U	6	3	2015-05-08	2015-09-15	MS    	-1	5	Y	14	19	19	-1	-1	-1	23	9	3	5	-1	-1
22bg10	1998	ok retry	198	22bg10-143-141_1_MS	198	U	6	3	2015-05-08	2015-09-15	MS    	-1	4	Y	8	18	18	-1	-1	-1	23	9	5	5	-1	-1
22bg11	1999	ok, retry	172	22bg11-113-174_1_MS 2rep	172	U	5	2	2015-05-08	2015-09-15	MS    	-1	4	Y	12	15	15	-1	-1	-1	23	8	7	5	-1	-1
22bg12	2000	0	167	0	167	U	6	2	2015-05-08	2015-09-15	MS    	-1	4	U	4	7	7	-1	-1	-1	23	8	2	5	-1	-1
22bg13	2001	0	194	22bg13 2rep	194	U	6	1	2015-05-08	2015-09-15	MS    	-1	5	U	8	22	22	-1	-1	-1	23	9	1	5	-1	-1
22bg2	2002	Had large leaf spots in 2014, and all 3 in 2015.	199	22bg2 2rep	199	U	6	3	2015-05-08	2015-09-15	MS    	-1	3	N	4	18	18	-1	-1	-1	23	9	6	5	-1	-1
22bg3	2003	ok, retry	170	22bg3-210-199_1_MS 2rep	170	U	6	3	2015-05-08	2015-09-15	MS    	-1	6	Y	5	14	14	-1	-1	-1	23	8	5	5	-1	-1
22bg4	2004	0	197	0	197	U	6	1	2015-05-08	2015-09-15	MS    	-1	5	U	10	23	23	-1	-1	-1	23	9	4	5	-1	-1
22bg5	2005	Very Nice! 11 foot tall	169	22bg5-97-18_1_MS 3rep	169	U	6	6	2015-05-08	2015-09-15	MS    	-1	4	Y	5	22	22	-1	-1	-1	23	8	4	5	-1	-1
22bg6	2006	0	168	0	168	U	5	1	2015-05-08	2015-09-15	MS    	-1	4	U	4	8	8	-1	-1	-1	23	8	3	5	-1	-1
22bg8	2008	ok, retry	171	22bg8-229-180_1_MS 2rep	171	U	6	3	2015-05-08	2015-09-15	MS    	-1	5	Y	4	17	17	-1	-1	-1	23	8	6	5	-1	-1
22bg9	2009	0	166	0	166	U	5	2	2015-05-08	2015-09-15	MS    	-1	4	U	4	11	11	-1	-1	-1	23	8	1	5	-1	-1
22xbg	2010	8 inch stem ortets ODC	439	22xbg 19rep	439	U	25	23	2015-05-08	2015-09-15	ODC   	-1	4	U	5	17	17	-1	-1	-1	23	26	2	8	-1	-1
22xbg	2011	8 inch stem ortets ODC	442	0	442	U	24	21	2015-05-08	2015-09-15	ODC   	-1	4	U	7	20	20	-1	-1	-1	23	27	5	8	-1	-1
23ba1	2012	Curly stems	417	23ba1 1rep	417	U	3	1	2015-05-08	2015-09-15	DC    	-1	4	U	4	10	10	-1	-1	-1	23	23	10	7	-1	-1
23ba10	2013	Nice!	186	23ba10-19-13_1_MS 3rep	186	U	6	6	2015-05-08	2015-09-15	MS    	-1	8	Y	9	19	19	-1	-1	-1	23	8	21	5	-1	-1
23ba11	2014	0	214	23ba11-17-80_1_MS 4rep	214	U	6	5	2015-05-08	2015-09-15	MS    	-1	8	Y	11	10	10	-1	-1	-1	23	9	21	5	-1	-1
23ba12	2015	ok	185	0	185	U	6	5	2015-05-08	2015-09-15	MS    	-1	6	U	7	11	11	-1	-1	-1	23	8	20	5	-1	-1
23ba13	2016	0	213	0	213	U	6	6	2015-05-08	2015-09-15	MS    	-1	5	U	6	12	12	-1	-1	-1	23	9	20	5	-1	-1
23ba14	2017	0	210	0	210	U	6	4	2015-05-08	2015-09-15	DC    	-1	5	U	7	-1	-1	-1	-1	-1	23	9	17	5	-1	-1
23ba15	2018	ok	184	23ba15-118-97_1_MS 2rep	184	U	6	4	2015-05-08	2015-09-15	MS    	-1	8	Y	7	17	17	-1	-1	-1	23	8	19	5	-1	-1
23ba16	2019	0	211	0	211	U	6	4	2015-05-08	2015-09-15	MS    	-1	5	U	7	13	13	-1	-1	-1	23	9	18	5	-1	-1
23ba17	2020	ok, retry	182	0	182	U	6	4	2015-05-08	2015-09-15	MS    	-1	5	U	6	14	14	-1	-1	-1	23	8	17	5	-1	-1
23ba18	2021	0	212	23ba18-26-43_1_MS 3rep	212	U	6	6	2015-05-08	2015-09-15	MS    	-1	5	Y	8	13	13	-1	-1	-1	23	9	19	5	-1	-1
23ba19	2022	0	183	0	183	U	6	3	2015-05-08	2015-09-15	MS    	-1	5	U	5	8	8	-1	-1	-1	23	8	18	5	-1	-1
23ba2	2023	Curly stems, Nice	405	23ba2-68-87_1_MS 4rep	405	U	3	3	2015-05-08	2015-09-15	MS    	-1	3	Y	6	11	11	-1	-1	-1	23	22	9	7	-1	-1
23ba3	2024	Curly stems, Nice!	415	23ba3-184-109_1_MS 1rep 1dot	415	U	4	3	2015-05-08	2015-09-15	MS    	-1	3	Y	4	16	16	-1	-1	-1	23	23	8	7	-1	-1
23ba4	2025	Curly stems	416	23ba4 1rep	416	U	2	2	2015-05-08	2015-09-15	1-0   	-1	3	U	4	5	5	-1	-1	-1	23	23	9	7	-1	-1
23ba5	2026	Curly stems	404	23ba5-235-170_1_1-0 1rep 1dot	404	U	4	2	2015-05-08	2015-09-15	1-0   	-1	3	Y	4	18	18	-1	-1	-1	23	22	8	7	-1	-1
23xba	2027	8 inch stem ortets ODC All CURLY, largest is 18mm dia and 7' tall, very interesting	406	23xba-57-31_1_1-0 15rep	406	U	13	13	2015-05-08	2015-09-15	1-0   	-1	4	Y	7	17	17	-1	-1	-1	23	22	10	8	-1	-1
23xba	2028	8 inch stem ortets ODC, All STRAIGHT, nice!	407	23xba-57-31_1_1-0 36rep	407	U	38	31	2015-05-08	2015-09-15	ODC   	-1	4	U	7	16	16	-1	-1	-1	23	22	11	8	-1	-1
23xba	2029	8 inch stem ortets ODC, CURLY 1-0	418	23xba-57-31_1_1-0	418	U	14	14	2015-05-08	2015-09-15	1-0   	-1	4	U	6	-1	-1	-1	-1	-1	23	23	11	8	-1	-1
23xba	2030	8 inch stem ortets ODC, STRAIGHT, 35/35 survival! Nice!	419	23xba-57-31_1_1-0	419	U	35	35	2015-05-08	2015-09-15	ODC   	-1	4	U	8	17	17	-1	-1	-1	23	23	12	8	-1	-1
2b16	2031	0	32	2b16~40-41	32	U	10	3	2015-05-08	2015-09-15	DC    	-1	9	U	5	-1	-1	-1	-1	-1	23	2	4	1	-1	-1
2b21	2032	Mini-Stools - nice	8	2b21~5-5 8rep 3dot 24whips	8	U	6	6	2015-05-08	2015-09-15	1-1   	-1	11	U	-1	14	14	-1	-1	-1	23	1	8	4	-1	-1
2b21	2033	ok	40	2b21~5-5	40	U	10	5	2015-05-08	2015-09-15	DC    	-1	5	Y	9	-1	-1	-1	-1	-1	23	2	12	1	-1	-1
2b21	2034	nice	61	2b21~5-5	61	U	10	8	2015-05-08	2015-09-15	DC    	-1	9	Y	10	-1	-1	-1	-1	-1	23	3	14	1	-1	-1
2b21	2035	0	82	2b21~5-5	82	U	10	9	2015-05-08	2015-09-15	DC    	-1	8	U	6	-1	-1	-1	-1	-1	23	4	15	2	-1	-1
2b21	2036	nice	102	2b21~5-5	102	U	10	10	2015-05-08	2015-09-15	DC    	-1	7	Y	10	-1	-1	-1	-1	-1	23	5	14	2	-1	-1
2b21	2037	0	347	2b21~5-5	347	U	10	10	2015-05-08	2015-09-15	DC    	-1	5	U	6	-1	-1	-1	-1	-1	23	17	12	3	-1	-1
2b22	2038	Mini-Stools	4	2b22~28-18 4rep 3whip 3dot	4	U	3	3	2015-05-08	2015-09-15	1-1   	-1	9	U	-1	16	16	-1	-1	-1	23	1	4	4	-1	-1
2b22	2039	0	37	2b22~28-18	37	U	10	2	2015-05-08	2015-09-15	DC    	-1	10	U	17	-1	-1	-1	-1	-1	23	2	9	1	-1	-1
2b22	2040	root pruned, ~6 qty Dcs	109	2b22~28-18	109	U	10	3	2015-05-08	2015-09-15	DC    	-1	11	U	11	-1	-1	-1	-1	-1	23	5	21	2	-1	-1
2b22	2041	retry	349	2b22~28-18	349	U	10	5	2015-05-08	2015-09-15	DC    	-1	8	Y	13	-1	-1	-1	-1	-1	23	18	2	3	-1	-1
2b24	2042	0	53	2b24~38-58	53	U	10	6	2015-05-08	2015-09-15	DC    	-1	8	U	9	-1	-1	-1	-1	-1	23	3	6	1	-1	-1
2b24	2043	0	105	2b24~38-58 5rep	105	U	10	7	2015-05-08	2015-09-15	DC    	-1	6	U	6	-1	-1	-1	-1	-1	23	5	17	2	-1	-1
2b25	2044	Mini-Stools, not impressive as previous years	5	2b25~55-10 8rep 14whip 2dot 	5	U	5	5	2015-05-08	2015-09-15	1-1   	-1	13	U	-1	13	13	-1	-1	-1	23	1	5	4	-1	-1
2b25	2045	0	42	2b25~55-10	42	U	10	4	2015-05-08	2015-09-15	DC    	-1	11	U	10	-1	-1	-1	-1	-1	23	2	14	1	-1	-1
2b25	2046	0	43	2b25~55-10	43	U	10	2	2015-05-08	2015-09-15	DC    	-1	6	U	9	-1	-1	-1	-1	-1	23	2	15	1	-1	-1
2b25	2047	0	57	2b25~55-10	57	U	10	3	2015-05-08	2015-09-15	DC    	-1	10	U	7	-1	-1	-1	-1	-1	23	3	10	1	-1	-1
2b25	2048	weak	81	2b25~55-10	81	U	10	4	2015-05-08	2015-09-15	DC    	-1	7	U	12	-1	-1	-1	-1	-1	23	4	14	2	-1	-1
2b25	2049	0	83	2b25~55-10	83	U	10	4	2015-05-08	2015-09-15	DC    	-1	7	U	10	-1	-1	-1	-1	-1	23	4	16	2	-1	-1
2b25	2050	0	99	2b25~55-10	99	U	10	5	2015-05-08	2015-09-15	DC    	-1	8	U	8	-1	-1	-1	-1	-1	23	5	11	2	-1	-1
2b25	2051	0	333	2b25~55-10	333	U	10	4	2015-05-08	2015-09-15	DC    	-1	5	U	5	-1	-1	-1	-1	-1	23	16	10	3	-1	-1
2b25	2052	0	344	2b25~55-10	344	U	10	5	2015-05-08	2015-09-15	DC    	-1	4	U	6	-1	-1	-1	-1	-1	23	17	9	3	-1	-1
2b25	2053	Post Dr	360	2b25~55-10	360	U	10	4	2015-05-08	2015-09-15	DC    	-1	8	Y	10	-1	-1	-1	-1	-1	23	19	2	3	-1	-1
2b29	2054	Mini-Stools may have figured wood, see pic	14	2b29~54-48 4rep 1dot	14	U	1	1	2015-05-08	2015-09-15	1-1   	-1	16	U	-1	14	14	-1	-1	-1	23	1	14	4	-1	-1
2b29	2055	0	30	2b29~54-48	30	U	10	6	2015-05-08	2015-09-15	DC    	-1	11	U	5	-1	-1	-1	-1	-1	23	2	2	1	-1	-1
2b29	2056	0	93	2b29~54-48	93	U	10	6	2015-05-08	2015-09-15	DC    	-1	10	U	8	-1	-1	-1	-1	-1	23	5	5	2	-1	-1
2b3	2057	Mini-Stools	3	2b3~10-7 10rep 12whip 3dot	3	U	3	3	2015-05-08	2015-09-15	1-1   	-1	10	U	-1	14	14	-1	-1	-1	23	1	3	4	-1	-1
2b3	2058	0	62	2b3~10-7	62	U	10	6	2015-05-08	2015-09-15	DC    	-1	6	U	6	-1	-1	-1	-1	-1	23	3	15	1	-1	-1
2b3	2059	0	76	2b3~10-7	76	U	10	6	2015-05-08	2015-09-15	DC    	-1	9	U	8	-1	-1	-1	-1	-1	23	4	9	2	-1	-1
2b3	2060	0	77	2b3~10-7	77	U	10	6	2015-05-08	2015-09-15	DC    	-1	8	Y	10	-1	-1	-1	-1	-1	23	4	10	2	-1	-1
2b3	2061	0	104	2b3~10-7	104	U	10	8	2015-05-08	2015-09-15	DC    	-1	9	U	8	-1	-1	-1	-1	-1	23	5	16	2	-1	-1
2b3	2062	0	325	2b3~10-7	325	U	10	8	2015-05-08	2015-09-15	DC    	-1	5	Y	10	-1	-1	-1	-1	-1	23	16	2	3	-1	-1
2b3	2063	nice	341	2b3~10-7	341	U	10	6	2015-05-08	2015-09-15	DC    	-1	5	Y	11	-1	-1	-1	-1	-1	23	17	6	3	-1	-1
2b4	2064	0	55	2b4~63-60 5rep 1dot 	55	U	10	4	2015-05-08	2015-09-15	DC    	-1	6	U	6	-1	-1	-1	-1	-1	23	3	8	1	-1	-1
2b4	2065	0	94	2b4~63-60	94	U	10	3	2015-05-08	2015-09-15	DC    	-1	10	U	7	-1	-1	-1	-1	-1	23	5	6	2	-1	-1
2b4	2066	0	97	2b4~63-60	97	U	10	7	2015-05-08	2015-09-15	DC    	-1	10	U	6	-1	-1	-1	-1	-1	23	5	9	2	-1	-1
2b4	2067	0	108	2b4~63-60	108	U	10	5	2015-05-08	2015-09-15	DC    	-1	7	U	7	-1	-1	-1	-1	-1	23	5	20	2	-1	-1
2b4	2068	0	330	2b4~63-60	330	U	10	1	2015-05-08	2015-09-15	DC    	-1	4	N	12	-1	-1	-1	-1	-1	23	16	7	3	-1	-1
2b50	2069	Mini-Stools, poor	2	2b50 3rep 1dot	2	U	1	1	2015-05-08	2015-09-15	1-1   	-1	15	N	-1	8	8	-1	-1	-1	23	1	2	4	-1	-1
2b50	2070	Tallest in 2014	327	0	327	U	10	3	2015-05-08	2015-09-15	DC    	-1	8	U	13	-1	-1	-1	-1	-1	23	16	4	3	-1	-1
2b50	2071	Tallest in 2014, weak	336	0	336	U	10	5	2015-05-08	2015-09-15	DC    	-1	8	U	6	-1	-1	-1	-1	-1	23	17	1	3	-1	-1
2b51	2072	Had red leaves last year, 3 died of shade?  2015 also had root issues.	326	2b51~1-4 3rep	326	U	14	9	2015-05-08	2015-09-15	DC    	-1	5	Y	10	-1	-1	-1	-1	-1	23	16	3	3	-1	-1
2b52	2073	ok, retry	178	2b52 3rep	178	U	5	3	2015-05-08	2015-09-15	DC    	-1	5	U	11	-1	-1	-1	-1	-1	23	8	13	5	-1	-1
2b53	2074	0	179	0	179	U	5	4	2015-05-08	2015-09-15	DC    	-1	4	U	6	-1	-1	-1	-1	-1	23	8	14	5	-1	-1
2b54	2075	0	207	0	207	U	6	1	2015-05-08	2015-09-15	DC    	-1	4	U	9	-1	-1	-1	-1	-1	23	9	14	5	-1	-1
2b55	2076	0	205	2b55 2rep	205	U	6	2	2015-05-08	2015-09-15	DC    	-1	5	U	16	-1	-1	-1	-1	-1	23	9	12	5	-1	-1
2b56	2077	0	209	0	209	U	6	4	2015-05-08	2015-09-15	DC    	-1	4	U	8	-1	-1	-1	-1	-1	23	9	16	5	-1	-1
2b57	2078	0	206	0	206	U	6	4	2015-05-08	2015-09-15	DC    	-1	4	U	10	-1	-1	-1	-1	-1	23	9	13	5	-1	-1
2b58	2079	0	208	0	208	U	6	1	2015-05-08	2015-09-15	DC    	-1	3	U	4	-1	-1	-1	-1	-1	23	9	15	5	-1	-1
2b59	2080	0	181	0	181	U	5	2	2015-05-08	2015-09-15	DC    	-1	5	U	6	-1	-1	-1	-1	-1	23	8	16	5	-1	-1
2b6	2081	Reps 1-3, P3/P4 Dcs, Nice!	29	2b6~37-12 8rep 3dot 6whips	29	U	10	9	2015-05-08	2015-09-15	DC    	-1	7	U	7	-1	-1	-1	-1	-1	23	2	1	1	-1	-1
2b6	2082	0	35	2b6~37-12	35	U	10	3	2015-05-08	2015-09-15	DC    	-1	6	U	10	-1	-1	-1	-1	-1	23	2	7	1	-1	-1
2b6	2083	By gutter  (tmp - add row her when done)	68	2b6~37-12	68	U	10	3	2015-05-08	2015-09-15	DC    	-1	9	U	5	-1	-1	-1	-1	-1	23	4	1	2	-1	-1
2b6	2084	0	74	2b6~37-12	74	U	10	6	2015-05-08	2015-09-15	DC    	-1	8	U	9	-1	-1	-1	-1	-1	23	4	7	2	-1	-1
2b6	2085	0	87	2b6~37-12	87	U	10	2	2015-05-08	2015-09-15	DC    	-1	5	U	8	-1	-1	-1	-1	-1	23	4	20	2	-1	-1
2b6	2086	0	328	2b6~37-12	328	U	10	8	2015-05-08	2015-09-15	DC    	-1	7	U	7	-1	-1	-1	-1	-1	23	16	5	3	-1	-1
2b6	2087	0	342	2b6~37-12	342	U	10	7	2015-05-08	2015-09-15	DC    	-1	5	Y	8	-1	-1	-1	-1	-1	23	17	7	3	-1	-1
2b6	2088	Nice!	362	2b6~37-12	362	U	10	8	2015-05-08	2015-09-15	DC    	-1	7	Y	12	-1	-1	-1	-1	-1	23	19	4	3	-1	-1
2b60	2089	0	180	0	180	U	5	3	2015-05-08	2015-09-15	DC    	-1	5	U	9	-1	-1	-1	-1	-1	23	8	15	5	-1	-1
2b61	2090	0	60	0	60	U	10	8	2015-05-08	2015-09-15	DC    	-1	11	U	6	-1	-1	-1	-1	-1	23	3	13	1	-1	-1
2b62	2091	nice	101	2b62 4rep 1dot	101	U	10	9	2015-05-08	2015-09-15	DC    	-1	8	Y	9	-1	-1	-1	-1	-1	23	5	13	2	-1	-1
2b63	2092	0	343	2b63 3rep	343	U	10	4	2015-05-08	2015-09-15	DC    	-1	6	Y	11	-1	-1	-1	-1	-1	23	17	8	3	-1	-1
2b64	2093	nice	100	2b64 3rep 1dot	100	U	10	7	2015-05-08	2015-09-15	DC    	-1	9	Y	11	-1	-1	-1	-1	-1	23	5	12	2	-1	-1
2b65	2094	0	39	0	39	U	10	5	2015-05-08	2015-09-15	DC    	-1	12	U	8	-1	-1	-1	-1	-1	23	2	11	1	-1	-1
2b66	2095	0	59	2b66 1rep	59	U	10	6	2015-05-08	2015-09-15	DC    	-1	9	U	6	-1	-1	-1	-1	-1	23	3	12	1	-1	-1
2b67	2096	retry	345	2b67 3rep 1dot	345	U	10	6	2015-05-08	2015-09-15	DC    	-1	6	Y	12	-1	-1	-1	-1	-1	23	17	10	3	-1	-1
2b68	2097	Nice!	331	2b68 3rep 1dot	331	U	10	8	2015-05-08	2015-09-15	DC    	-1	6	Y	12	-1	-1	-1	-1	-1	23	16	8	3	-1	-1
2b69	2098	0	332	0	332	U	10	2	2015-05-08	2015-09-15	DC    	-1	8	U	3	-1	-1	-1	-1	-1	23	16	9	3	-1	-1
2b7	2099	0	31	2b7~57-53 5rep	31	U	10	5	2015-05-08	2015-09-15	DC    	-1	8	U	6	-1	-1	-1	-1	-1	23	2	3	1	-1	-1
2b7	2100	0	52	2b7~57-53	52	U	10	5	2015-05-08	2015-09-15	DC    	-1	8	U	5	-1	-1	-1	-1	-1	23	3	5	1	-1	-1
2b7	2101	0	73	2b7~57-53	73	U	10	3	2015-05-08	2015-09-15	DC    	-1	8	U	7	-1	-1	-1	-1	-1	23	4	6	2	-1	-1
2b7	2102	0	88	2b7~57-53	88	U	10	3	2015-05-08	2015-09-15	DC    	-1	4	U	7	-1	-1	-1	-1	-1	23	4	21	2	-1	-1
2b70	2103	0	78	0	78	U	10	2	2015-05-08	2015-09-15	DC    	-1	8	N	1	-1	-1	-1	-1	-1	23	4	11	2	-1	-1
2b71	2104	Nice!	79	2b71 3rep 1dot	79	U	10	10	2015-05-08	2015-09-15	DC    	-1	9	Y	8	-1	-1	-1	-1	-1	23	4	12	2	-1	-1
2b72	2105	0	50	0	50	U	10	5	2015-05-08	2015-09-15	DC    	-1	9	U	6	-1	-1	-1	-1	-1	23	3	3	1	-1	-1
2b73	2106	0	334	2b73 0rep 1dot	334	U	10	2	2015-05-08	2015-09-15	DC    	-1	6	U	12	-1	-1	-1	-1	-1	23	16	11	3	-1	-1
2rr11	2107	8 inch ok retry	188	2rr11 2rep	188	U	9	4	2015-05-08	2015-09-15	MS    	-1	7	U	7	11	11	-1	-1	-1	23	8	23	5	-1	-1
2rr12	2108	8 inch	187	0	187	U	8	4	2015-05-08	2015-09-15	MS    	-1	8	U	5	8	8	-1	-1	-1	23	8	22	5	-1	-1
2rr13	2109	8 inch DCs	215	0	215	U	6	2	2015-05-08	2015-09-15	MS    	-1	5	U	4	4	4	-1	-1	-1	23	9	22	5	-1	-1
2rr14	2110	8 inch DCs	216	2rr14-194-151_1_MS 2rep	216	U	7	5	2015-05-08	2015-09-15	MS    	-1	6	Y	4	13	13	-1	-1	-1	23	9	23	5	-1	-1
3aa202	2111	Mini-Stools	1	3aa202~62-37 1rep	1	U	1	1	2015-05-08	2015-09-15	1-0   	-1	10	U	-1	10	10	-1	-1	-1	23	1	1	4	-1	-1
3aa202	2112	0	337	3aa202~62-37	337	U	6	0	2015-05-08	2015-09-15	DC    	-1	5	U	0	-1	-1	-1	-1	-1	23	17	2	3	-1	-1
3bc1	2113	Renamed from 3cagc1 to 3bc1	371	3bc1-62-22_1_MS 3rep	371	U	10	9	2015-05-08	2015-09-15	MS    	-1	42	Y	7	20	20	-1	-1	-1	23	20	2	7	-1	-1
3cagc2	2114	0	386	0	386	U	10	6	2015-05-08	2015-09-15	MS    	-1	10	U	7	14	14	-1	-1	-1	23	21	3	7	-1	-1
3bc3	2115	Nice!	387	3bc3-52-14_1_MS 4rep 1dot	387	U	10	10	2015-05-08	2015-09-15	MS    	-1	10	Y	7	21	21	-1	-1	-1	23	21	4	7	-1	-1
3bc4	2116	0	385	3bc4-69-25_1_MS 4rep	385	U	10	10	2015-05-08	2015-09-15	MS    	-1	11	Y	6	18	18	-1	-1	-1	23	21	2	7	-1	-1
3bc5	2117	0	372	3bc5-131-120_1_MS 3rep	372	U	10	6	2015-05-08	2015-09-15	MS    	-1	41	Y	7	17	17	-1	-1	-1	23	20	3	7	-1	-1
3rr1	2118	1-0 ortet and 6 inch Dcs	113	0	113	U	6	0	2015-05-08	2015-09-15	MS    	-1	4	U	0	9	9	-1	-1	-1	23	6	4	5	-1	-1
3rr2	2119	1-0 ortet and 6 inch Dcs	110	0	110	U	5	0	2015-05-08	2015-09-15	MS    	-1	8	N	0	10	10	-1	-1	-1	23	6	1	5	-1	-1
41aa111	2120	0	339	41aa111~77-83	339	U	10	4	2015-05-08	2015-09-15	DC    	-1	5	U	6	-1	-1	-1	-1	-1	23	17	4	3	-1	-1
4ab4	2121	0	56	4ab4~30-19 4rep 2dot	56	U	10	6	2015-05-08	2015-09-15	DC    	-1	9	U	6	-1	-1	-1	-1	-1	23	3	9	1	-1	-1
4ab4	2122	0	86	4ab4~30-19	86	U	10	2	2015-05-08	2015-09-15	DC    	-1	10	U	9	-1	-1	-1	-1	-1	23	4	19	2	-1	-1
4ab4	2123	0	356	4ab4~30-19	356	U	14	11	2015-05-08	2015-09-15	DC    	-1	12	Y	7	-1	-1	-1	-1	-1	23	18	9	7	-1	-1
4acag7	2124	Nice!	357	4acag7-35-116_1_MS 4rep 1dot	357	U	10	7	2015-05-08	2015-09-15	MS    	-1	10	Y	11	10	10	-1	-1	-1	23	18	10	7	-1	-1
4acag8	2125	0	370	0	370	U	13	7	2015-05-08	2015-09-15	ODC   	-1	45	U	8	-1	-1	-1	-1	-1	23	20	1	7	-1	-1
4ab9	2126	Nice!	384	4ab9-24-55_1_MS rep4 2dot	384	U	13	9	2015-05-08	2015-09-15	MS    	-1	10	Y	12	16	16	-1	-1	-1	23	21	1	7	-1	-1
4gw10	2127	8 inch cuttings (GA like leaves) nice	297	4gw10-112-81_1_MS 3rep 1dot	297	U	10	6	2015-05-08	2015-09-15	MS    	-1	42	Y	8	21	21	-1	-1	-1	23	14	3	6	-1	-1
4gw10	2128	retry	314	4gw10-112-81_1_MS	314	U	6	3	2015-05-08	2015-09-15	DC    	-1	4	N	5	17	17	-1	-1	-1	23	15	6	6	-1	-1
4gw11	2129	8 inch cuttings (GA like leaves) nice	296	4gw11-195-40_1_MS 4rep 1dot	296	U	10	5	2015-05-08	2015-09-15	MS    	-1	11	Y	8	20	20	-1	-1	-1	23	14	2	6	-1	-1
4gw11	2130	GA like  	301	4gw11-195-40_1_MS	301	U	6	3	2015-05-08	2015-09-15	MS    	-1	5	U	3	17	17	-1	-1	-1	23	14	7	6	-1	-1
4gw12	2131	GA like retry	300	4gw12-87-83_1_MS 2rep 1dot	300	U	6	4	2015-05-08	2015-09-15	MS    	-1	4	Y	8	18	18	-1	-1	-1	23	14	6	6	-1	-1
4gw12	2132	GA type	311	4gw12-87-83_1_MS	311	U	10	0	2015-05-08	2015-09-15	DC    	-1	10	U	0	10	10	-1	-1	-1	23	15	3	6	-1	-1
4gw13	2133	GA type	312	4gw13 2rep 1dot	312	U	10	4	2015-05-08	2015-09-15	DC    	-1	10	U	5	15	15	-1	-1	-1	23	15	4	6	-1	-1
4gw13	2134	GA type	315	0	315	U	6	3	2015-05-08	2015-09-15	DC    	-1	4	Y	5	16	16	-1	-1	-1	23	15	7	6	-1	-1
4gw14	2135	GA like  	302	0	302	U	6	0	2015-05-08	2015-09-15	MS    	-1	5	U	0	18	18	-1	-1	-1	23	14	8	6	-1	-1
4gw15	2136	GA type	316	0	316	U	4	1	2015-05-08	2015-09-15	DC    	-1	4	U	4	12	12	-1	-1	-1	23	15	8	6	-1	-1
4gw3	2137	GA type	368	0	368	U	9	3	2015-05-08	2015-09-15	MS    	-1	12	U	8	15	15	-1	-1	-1	23	19	10	7	-1	-1
4rr1	2138	1-0 ortet and 6 inch Dcs	111	0	111	U	2	0	2015-05-08	2015-09-15	MS    	-1	6	N	0	4	4	-1	-1	-1	23	6	2	5	-1	-1
4rr2	2139	0	138	0	138	U	5	0	2015-05-08	2015-09-15	MS    	-1	4	U	0	12	12	-1	-1	-1	23	7	2	5	-1	-1
5cagr1	2140	1-0 ortet and 6 inch Dcs	112	0	112	U	8	4	2015-05-08	2015-09-15	MS    	-1	5	U	4	13	13	-1	-1	-1	23	6	3	5	-1	-1
5cagr2	2141	weak	367	0	367	U	10	7	2015-05-08	2015-09-15	DC    	-1	12	U	5	-1	-1	-1	-1	-1	23	19	9	7	-1	-1
5br3	2142	0	355	5br3 3rep	355	U	10	8	2015-05-08	2015-09-15	DC    	-1	8	Y	8	-1	-1	-1	-1	-1	23	18	8	7	-1	-1
5rb1	2143	0	256	0	256	U	6	1	2015-05-08	2015-09-15	MS    	-1	4	N	8	15	15	-1	-1	-1	23	11	15	6	-1	-1
5rb2	2144	0	236	0	236	U	6	2	2015-05-08	2015-09-15	MS    	-1	8	U	4	16	16	-1	-1	-1	23	10	15	6	-1	-1
5rb3	2145	0	255	0	255	U	6	0	2015-05-08	2015-09-15	MS    	-1	4	N	0	11	11	-1	-1	-1	23	11	14	6	-1	-1
6ba1	2146	0	299	0	299	U	6	4	2015-05-08	2015-09-15	MS    	-1	4	U	7	15	15	-1	-1	-1	23	14	5	6	-1	-1
6ba2	2147	ok	313	6ba2 3rep	313	U	6	6	2015-05-08	2015-09-15	ODC   	-1	4	Y	7	14	14	-1	-1	-1	23	15	5	6	-1	-1
6ba3	2148	0	298	0	298	U	6	2	2015-05-08	2015-09-15	MS    	-1	4	U	4	13	13	-1	-1	-1	23	14	4	6	-1	-1
7bt1	2149	nice	282	7bt1-55-69_1_MS 3rep	282	U	6	5	2015-05-08	2015-09-15	MS    	-1	7	Y	8	14	14	-1	-1	-1	23	13	5	6	-1	-1
7bt10	2150	0	283	7bt10-100-113_1_MS 2rep	283	U	6	5	2015-05-08	2015-09-15	MS    	-1	5	Y	6	12	12	-1	-1	-1	23	13	6	6	-1	-1
7bt2	2151	0	267	0	267	U	6	2	2015-05-08	2015-09-15	MS    	-1	6	U	4	7	7	-1	-1	-1	23	12	7	6	-1	-1
7bt3	2152	0	262	0	262	U	6	2	2015-05-08	2015-09-15	MS    	-1	6	U	7	13	13	-1	-1	-1	23	12	2	6	-1	-1
7bt4	2153	0	281	0	281	U	6	5	2015-05-08	2015-09-15	MS    	-1	5	U	7	9	9	-1	-1	-1	23	13	4	6	-1	-1
7bt5	2154	0	265	0	265	U	6	1	2015-05-08	2015-09-15	MS    	-1	5	U	11	19	19	-1	-1	-1	23	12	5	6	-1	-1
7bt6	2155	0	263	0	263	U	6	3	2015-05-08	2015-09-15	MS    	-1	5	U	7	10	10	-1	-1	-1	23	12	3	6	-1	-1
7bt7	2156	0	280	7bt7-163-179_1_MS 2rep	280	U	6	3	2015-05-08	2015-09-15	MS    	-1	4	Y	7	14	14	-1	-1	-1	23	13	3	6	-1	-1
7bt8	2157	0	264	0	264	U	5	0	2015-05-08	2015-09-15	MS    	-1	4	U	0	0	0	-1	-1	-1	23	12	4	6	-1	-1
7bt9	2158	0	266	7bt9-119-98_1_MS 2rep	266	U	6	4	2015-05-08	2015-09-15	MS    	-1	5	Y	7	17	17	-1	-1	-1	23	12	6	6	-1	-1
7xbt	2159	8 inch stem ortets ODC	427	7xbt 10rep	427	U	21	17	2015-05-08	2015-09-15	ODC   	-1	5	U	8	16	16	-1	-1	-1	23	24	8	8	-1	-1
7xbt	2160	8 inch stem ortets ODC	436	0	436	U	23	19	2015-05-08	2015-09-15	1-0   	-1	5	U	7	15	15	-1	-1	-1	23	25	8	8	-1	-1
80aa3mf	2161	2 1-0 8 inch cuttings, plant at Post	323	80aa3mf~2-8 2rep 2dot	323	U	10	4	2015-05-08	2015-09-15	MS    	-1	8	U	8	19	19	-1	-1	-1	23	15	15	6	-1	-1
82aa3	2162	CSSE selection, Barely 4 inches growth	140	82aa3~75-89 1rep	140	U	5	1	2015-05-08	2015-09-15	MS    	-1	4	U	2	3	3	-1	-1	-1	23	7	4	5	-1	-1
83aa66	2163	Brads container grown transplants	449	83aa66	449	U	1	1	2015-05-08	2015-09-15	WASP  	-1	3	Y	12	12	12	-1	-1	-1	23	28	6	9	-1	-1
83aa70	2164	Brads container grown transplants	448	83aa70 1rep	448	U	3	3	2015-05-08	2015-09-15	WASP  	-1	3	Y	7	16	16	-1	-1	-1	23	28	5	9	-1	-1
83aa74	2165	Brads container grown transplants	447	83aa74 1rep	447	U	2	2	2015-05-08	2015-09-15	WASP  	-1	3	Y	11	-1	-1	-1	-1	-1	23	28	4	9	-1	-1
89aa1	2166	Mini-Stools	12	89aa1 1rep 2dot	12	U	3	3	2015-05-08	2015-09-15	1-1   	-1	7	U	-1	14	14	-1	-1	-1	23	1	12	4	-1	-1
89aa1	2167	0	365	0	365	U	10	0	2015-05-08	2015-09-15	DC    	-1	7	U	0	0	0	-1	-1	-1	23	19	7	3	-1	-1
89aa4	2168	Mini-Stools	24	0	24	U	1	1	2015-05-08	2015-09-15	1-1   	-1	10	U	-1	7	7	-1	-1	-1	23	1	24	4	-1	-1
8bg1	2169	0	278	18bg1-103-91_1_MS	278	U	6	1	2015-05-08	2015-09-15	MS    	-1	4	U	7	8	8	-1	-1	-1	23	13	1	6	-1	-1
8bg10	2170	0	240	8bg10-107-50_1_MS 2rep	240	U	6	5	2015-05-08	2015-09-15	MS    	-1	4	Y	6	19	19	-1	-1	-1	23	10	19	6	-1	-1
8bg11	2171	0	259	0	259	U	6	3	2015-05-08	2015-09-15	MS    	-1	4	N	6	9	9	-1	-1	-1	23	11	18	6	-1	-1
8bg12	2172	0	239	0	239	U	5	3	2015-05-08	2015-09-15	MS    	-1	4	N	5	12	12	-1	-1	-1	23	10	18	6	-1	-1
8bg2	2173	0	260	18bg2-105-54_1_MS	260	U	6	3	2015-05-08	2015-09-15	MS    	-1	4	Y	7	14	14	-1	-1	-1	23	11	19	6	-1	-1
8bg3	2174	0	279	8bg3-89-106_1_MS 3rep	279	U	6	4	2015-05-08	2015-09-15	MS    	-1	4	Y	8	15	15	-1	-1	-1	23	13	2	6	-1	-1
8bg4	2175	retry	238	8bg4-185-147_1_MS 3rep	238	U	6	3	2015-05-08	2015-09-15	MS    	-1	7	Y	6	19	19	-1	-1	-1	23	10	17	6	-1	-1
8bg5	2176	0	241	18bg5-230-181_1_MS 2rep	241	U	6	4	2015-05-08	2015-09-15	MS    	-1	4	Y	6	21	21	-1	-1	-1	23	10	20	6	-1	-1
8bg6	2177	0	257	0	257	U	6	2	2015-05-08	2015-09-15	MS    	-1	4	U	7	15	15	-1	-1	-1	23	11	16	6	-1	-1
8bg7	2178	0	258	8bg7-141-96_1_MS 3rep	258	U	6	6	2015-05-08	2015-09-15	MS    	-1	4	Y	4	12	12	-1	-1	-1	23	11	17	6	-1	-1
8bg8	2179	retry	237	8bg8-228-154_1_MS 2rep	237	U	6	3	2015-05-08	2015-09-15	MS    	-1	4	Y	4	20	20	-1	-1	-1	23	10	16	6	-1	-1
8bg9	2180	0	261	8bg9-142-140_1_MS 3rep	261	U	6	3	2015-05-08	2015-09-15	MS    	-1	4	Y	8	18	18	-1	-1	-1	23	12	1	6	-1	-1
8xbg	2181	8 inch stem ortets ODC	421	8xbg 13rep	421	U	14	11	2015-05-08	2015-09-15	ODC   	-1	4	U	7	17	17	-1	-1	-1	23	24	2	8	-1	-1
8xbg	2182	8 inch stem ortets ODC	430	13xgb	430	U	15	14	2015-05-08	2015-09-15	WASP  	-1	4	U	8	17	17	-1	-1	-1	23	25	2	8	-1	-1
92aa11	2183	Mini-Stools, nice	22	92aa11~9-3 4rep 2dot 8whip	22	U	3	3	2015-05-08	2015-09-15	1-1   	-1	10	U	-1	16	16	-1	-1	-1	23	1	22	4	-1	-1
92aa11	2184	0	45	92aa11~9-3	45	U	10	5	2015-05-08	2015-09-15	DC    	-1	8	U	11	-1	-1	-1	-1	-1	23	2	17	1	-1	-1
92aa11	2185	nice	70	92aa11~9-3	70	U	10	5	2015-05-08	2015-09-15	DC    	-1	8	U	12	-1	-1	-1	-1	-1	23	4	3	2	-1	-1
92aa11	2186	0	352	92aa11~9-3	352	U	10	7	2015-05-08	2015-09-15	DC    	-1	8	Y	10	-1	-1	-1	-1	-1	23	18	5	3	-1	-1
92aa11	2187	ok	353	92aa11~9-3	353	U	10	6	2015-05-08	2015-09-15	DC    	-1	8	Y	13	-1	-1	-1	-1	-1	23	18	6	3	-1	-1
93aa11	2188	0	51	93aa11~6-9 4rep	51	U	10	5	2015-05-08	2015-09-15	DC    	-1	9	U	7	-1	-1	-1	-1	-1	23	3	4	1	-1	-1
93aa11	2189	0	107	93aa11~6-9	107	U	10	6	2015-05-08	2015-09-15	DC    	-1	8	U	8	-1	-1	-1	-1	-1	23	5	19	2	-1	-1
95aa11	2190	Mini-Stools	11	95aa11~27-47 3rep 2dot	11	U	2	2	2015-05-08	2015-09-15	1-1   	-1	10	U	-1	14	14	-1	-1	-1	23	1	11	4	-1	-1
95aa11	2191	0	38	95aa11~27-47	38	U	10	5	2015-05-08	2015-09-15	DC    	-1	7	U	9	-1	-1	-1	-1	-1	23	2	10	1	-1	-1
95aa11	2192	0	66	95aa11~27-47	66	U	10	4	2015-05-08	2015-09-15	DC    	-1	8	U	5	-1	-1	-1	-1	-1	23	3	19	1	-1	-1
95aa11	2193	0	91	95aa11~27-47	91	U	10	5	2015-05-08	2015-09-15	DC    	-1	9	U	7	-1	-1	-1	-1	-1	23	5	3	2	-1	-1
95aa11	2194	DC only	136	95aa11~27-47	136	U	5	8	2015-05-08	2015-09-15	DC    	-1	10	U	4	-1	-1	-1	-1	-1	23	6	27	5	-1	-1
97aa11	2195	Mini-Stools	19	97aa11~24-30 4rep 2dot 3whip 	19	U	2	2	2015-05-08	2015-09-15	1-1   	-1	12	U	-1	16	16	-1	-1	-1	23	1	19	4	-1	-1
97aa11	2196	0	63	97aa11~24-30	63	U	10	9	2015-05-08	2015-09-15	DC    	-1	8	U	6	-1	-1	-1	-1	-1	23	3	16	1	-1	-1
97aa11	2197	nice	89	97aa11~24-30	89	U	10	10	2015-05-08	2015-09-15	DC    	-1	8	Y	9	-1	-1	-1	-1	-1	23	5	1	2	-1	-1
97aa11	2198	0	351	97aa11~24-30	351	U	10	7	2015-05-08	2015-09-15	DC    	-1	8	U	5	-1	-1	-1	-1	-1	23	18	4	3	-1	-1
97aa12	2199	Mini-Stools	21	97aa12~25-16 3rep 2dot 2whip	21	U	2	2	2015-05-08	2015-09-15	1-1   	-1	10	U	-1	15	15	-1	-1	-1	23	1	21	4	-1	-1
97aa12	2200	0	46	97aa12~25-16	46	U	10	5	2015-05-08	2015-09-15	DC    	-1	11	U	8	-1	-1	-1	-1	-1	23	2	18	1	-1	-1
97aa12	2201	0	71	97aa12~25-16	71	U	10	5	2015-05-08	2015-09-15	DC    	-1	9	U	7	-1	-1	-1	-1	-1	23	4	4	2	-1	-1
97aa12	2202	0	364	97aa12~25-16	364	U	10	7	2015-05-08	2015-09-15	DC    	-1	9	U	8	-1	-1	-1	-1	-1	23	19	6	3	-1	-1
98aa11	2203	Mini-Stools	15	98aa11-326-76_1_1-0 6rep 9whip 4dot	15	U	6	6	2015-05-08	2015-09-15	1-1   	-1	11	U	-1	17	17	-1	-1	-1	23	1	15	4	-1	-1
98aa11	2204	0	33	98aa11-326-76_1_1-0	33	U	10	5	2015-05-08	2015-09-15	DC    	-1	6	U	6	-1	-1	-1	-1	-1	23	2	5	1	-1	-1
98aa11	2205	Stock was 2' tall 1-0, grew to 9.5' tall	67	98aa11-326-76_1_1-0	67	U	3	3	2015-05-08	2015-09-15	1-0   	-1	14	Y	-1	19	19	-1	-1	-1	23	3	20	1	-1	-1
98aa11	2206	0	84	98aa11-326-76_1_1-0	84	U	10	5	2015-05-08	2015-09-15	DC    	-1	5	U	5	-1	-1	-1	-1	-1	23	4	17	2	-1	-1
98aa11	2207	0	96	98aa11-326-76_1_1-0	96	U	10	5	2015-05-08	2015-09-15	DC    	-1	8	U	8	-1	-1	-1	-1	-1	23	5	8	2	-1	-1
98aa11	2208	0	98	98aa11-326-76_1_1-0	98	U	10	2	2015-05-08	2015-09-15	DC    	-1	7	U	10	-1	-1	-1	-1	-1	23	5	10	2	-1	-1
98aa11	2209	0	338	98aa11-326-76_1_1-0	338	U	10	8	2015-05-08	2015-09-15	DC    	-1	5	Y	9	-1	-1	-1	-1	-1	23	17	3	3	-1	-1
98aa11	2210	WASP planted 4/12/15	445	98aa11-326-76_1_1-0	445	U	5	5	2015-05-08	2015-09-15	WASP  	-1	3	U	15	-1	-1	-1	-1	-1	23	28	2	9	-1	-1
9br1	2211	0	139	0	139	U	6	4	2015-05-08	2015-09-15	MS    	-1	4	U	4	12	12	-1	-1	-1	23	7	3	5	-1	-1
a502	2212	Mini-Stools, poor	20	A502~66-65 3rep	20	U	3	1	2015-05-08	2015-09-15	1-1   	-1	18	U	-1	4	4	-1	-1	-1	23	1	20	4	-1	-1
a502	2213	8 inches long - weak	65	a502~66-65	65	U	10	4	2015-05-08	2015-09-15	DC    	-1	14	U	4	-1	-1	-1	-1	-1	23	3	18	1	-1	-1
a502	2214	0	90	a502~66-65	90	U	10	3	2015-05-08	2015-09-15	DC    	-1	12	U	7	-1	-1	-1	-1	-1	23	5	2	2	-1	-1
aa4102	2215	WASP planted 4/12/15	444	Aa4102~72-84 3rep	444	U	7	6	2015-05-08	2015-09-15	WASP  	-1	3	U	7	9	9	-1	-1	-1	23	28	1	9	-1	-1
aag2001	2216	1-0	335	Aag2001~44-64 3rep	335	U	2	2	2015-05-08	2015-09-15	1-0   	-1	3	U	7	-1	-1	-1	-1	-1	23	16	12	3	-1	-1
aag2001	2217	WASP planted 4/12/15, 2 have noticable topiasis	446	aag2001~44-64	446	U	3	3	2015-05-08	2015-09-15	WASP  	-1	3	U	5	11	11	-1	-1	-1	23	28	3	9	-1	-1
agrr1	2219	Mini-Stools (should be more)	16	Agrr1~49-70 1rep	16	U	2	1	2015-05-08	2015-09-15	1-1   	-1	13	U	-1	12	12	-1	-1	-1	23	1	16	4	-1	-1
c173	2220	Mini-Stools 1 inch root collar, cut low, poor (roots too small).	17	c173-199-225_1_MS 5rep 3dot	17	U	2	2	2015-05-08	2015-09-15	1-1   	-1	20	U	-1	6	6	-1	-1	-1	23	1	17	4	-1	-1
c173	2221	8 inch cuttings with 3 1-0 stock plants. Post DR	358	c173-199-225_1_MS	358	U	12	4	2015-05-08	2015-09-15	MS    	-1	10	Y	8	13	13	-1	-1	-1	23	18	11	7	-1	-1
c173	2222	0	361	c173-199-225_1_MS	361	U	10	7	2015-05-08	2015-09-15	DC    	-1	12	Y	10	-1	-1	-1	-1	-1	23	19	3	3	-1	-1
cag204	2223	Mini-Stools	27	Cag204~74-78 3rep 1dot	27	U	3	3	2015-05-08	2015-09-15	1-1   	-1	8	U	-1	8	8	-1	-1	-1	23	1	27	4	-1	-1
cag204	2224	8 inches long - weak	64	cag204~74-78	64	U	10	4	2015-05-08	2015-09-15	DC    	-1	12	U	5	-1	-1	-1	-1	-1	23	3	17	1	-1	-1
cag204	2225	8 inches long - weak	69	cag204~74-78	69	U	10	5	2015-05-08	2015-09-15	DC    	-1	13	U	5	-1	-1	-1	-1	-1	23	4	2	2	-1	-1
cag204	2226	8 inch cuttings	350	cag204~74-78	350	U	10	6	2015-05-08	2015-09-15	DC    	-1	10	Y	6	-1	-1	-1	-1	-1	23	18	3	3	-1	-1
dn34	2227	Mini-Stools	9	Dn34~45-66 12rep 8dot	9	U	6	6	2015-05-08	2015-09-15	1-1   	-1	11	U	-1	11	11	-1	-1	-1	23	1	9	4	-1	-1
dn34	2228	0	41	dn34~45-66	41	U	10	9	2015-05-08	2015-09-15	DC    	-1	8	U	4	-1	-1	-1	-1	-1	23	2	13	1	-1	-1
dn34	2229	weak	80	dn34~45-66	80	U	10	6	2015-05-08	2015-09-15	DC    	-1	8	U	4	-1	-1	-1	-1	-1	23	4	13	2	-1	-1
dn34	2230	0	346	dn34~45-66	346	U	10	10	2015-05-08	2015-09-15	DC    	-1	5	U	10	-1	-1	-1	-1	-1	23	17	11	3	-1	-1
dn34	2231	0	359	dn34~45-66	359	U	10	8	2015-05-08	2015-09-15	DC    	-1	8	U	9	-1	-1	-1	-1	-1	23	19	1	3	-1	-1
gg10	2232	Initially named E5 - FW? (Leagl house)	453	gg10-173-233_1_1-0	453	U	3	1	2015-05-08	2015-09-15	1-0   	-1	11	Y	10	10	10	-1	-1	-1	23	29	4	10	-1	-1
gg7	2233	Initially named E2 - FW by EEs house steps	450	gg7-38-107_1_1-0	450	U	4	3	2015-05-08	2015-09-15	1-0   	-1	7	Y	10	10	10	-1	-1	-1	23	29	1	10	-1	-1
gg8	2234	Initially named E4 - FW? - Johns roadside bank	451	gg8-42-123_1_1-0	451	U	1	1	2015-05-08	2015-09-15	1-0   	-1	30	Y	7	7	7	-1	-1	-1	23	29	2	10	-1	-1
gg9	2235	Initially named E3 - FW, 21 paces North of EEs wood shed.	452	gg9-14-61_1_1-0	452	U	2	1	2015-05-08	2015-09-15	1-0   	-1	18	Y	19	19	19	-1	-1	-1	23	29	3	10	-1	-1
nfa	2236	Mini-Stools, poor	26	Nfa~67-44 3rep	26	U	2	2	2015-05-08	2015-09-15	1-1   	-1	12	U	-1	9	9	-1	-1	-1	23	1	26	4	-1	-1
nfa	2237	8 inch cuttings, weak	366	nfa~67-44	366	U	8	5	2015-05-08	2015-09-15	MS    	-1	7	U	5	5	5	-1	-1	-1	23	19	8	7	-1	-1
plaza	2238	Ag plaza cuttings were 6 inch	137	Plaza~70-81 2rep	137	U	6	3	2015-05-08	2015-09-15	MS    	-1	4	U	0	8	8	-1	-1	-1	23	7	1	5	-1	-1
tc72	2239	Mini-Stools TC alba	23	tc72 3rep 1whip	23	U	1	1	2015-05-08	2015-09-15	1-1   	-1	18	U	-1	9	9	-1	-1	-1	23	1	23	4	-1	-1
tc72	2240	ok	354	tc72	354	U	10	6	2015-05-08	2015-09-15	DC    	-1	8	Y	7	-1	-1	-1	-1	-1	23	18	7	3	-1	-1
zoss	2241	Mini-Stools	28	Zoss~71-62 3rep 3dot 1whip	28	U	2	2	2015-05-08	2015-09-15	1-1   	-1	15	U	-1	13	13	-1	-1	-1	23	1	28	4	-1	-1
zoss	2242	8 inch cutting Nice retry	165	zoss~71-62	165	U	17	8	2015-05-08	2015-09-15	MS    	-1	8	U	7	14	14	-1	-1	-1	23	7	29	5	-1	-1
100aa11	2243	0	14,8,2,4,7	100aa11~rankms=50_rankdc=53_reps=4_srate=0.8_class=A	49	U	6	6	2016-04-15	2016-09-11	MS    	25	11	U	-1	15	15	15	-1	-1	24	2	12	4	-1	-1
100aa11	2244	0	14,8,2,4,7	100aa11~rankms=50_rankdc=53_reps=4_srate=0.8_class=A	332	U	5	4	2016-04-15	2016-09-11	DC    	20	11	U	8	-1	-1	4	-1	-1	24	12	19	1	-1	-1
100aa11	2245	0	14,8,2,4,7	100aa11~rankms=50_rankdc=53_reps=4_srate=0.8_class=A	353	U	5	5	2016-04-15	2016-09-11	DC    	20	11	U	7	-1	-1	2	-1	-1	24	13	17	1	-1	-1
100aa11	2246	0	14,8,2,4,7	100aa11~rankms=50_rankdc=53_reps=4_srate=0.8_class=A	354	U	5	3	2016-04-15	2016-09-11	DC    	20	10	U	6	-1	-1	7	-1	-1	24	13	18	1	-1	-1
100aa11	2247	0	14,8,2,4,7	100aa11~rankms=50_rankdc=53_reps=4_srate=0.8_class=A	468	U	5	5	2016-04-15	2016-09-11	DC    	20	6	U	9	-1	-1	11	-1	-1	24	18	21	1	-1	-1
100aa12	2248	0	14,8,2,3,5	100aa12~rankms=3_rankdc=5_reps=8_srate=0.8_class=A	52	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	17	17	12	-1	-1	24	2	15	4	-1	-1
100aa12	2249	nice	14,8,2,3,5	100aa12~rankms=3_rankdc=5_reps=8_srate=0.8_class=A	126	U	2	2	2016-04-15	2016-09-11	MS    	25	15	Y	-1	23	23	20	-1	-1	24	4	26	4	-1	-1
100aa12	2250	0	14,8,2,3,5	100aa12~rankms=3_rankdc=5_reps=8_srate=0.8_class=A	132	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	21	21	12	-1	-1	24	5	2	4	-1	-1
100aa12	2251	0	14,8,2,3,5	100aa12~rankms=3_rankdc=5_reps=8_srate=0.8_class=A	335	U	5	4	2016-04-15	2016-09-11	DC    	20	15	U	6	-1	-1	7	-1	-1	24	12	22	1	-1	-1
100aa12	2252	nice	14,8,2,3,5	100aa12~rankms=3_rankdc=5_reps=8_srate=0.8_class=A	362	U	5	5	2016-04-15	2016-09-11	DC    	20	13	Y	10	-1	-1	15	-1	-1	24	14	3	1	-1	-1
100aa12	2253	0	14,8,2,3,5	100aa12~rankms=3_rankdc=5_reps=8_srate=0.8_class=A	448	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	13	-1	-1	15	-1	-1	24	18	1	1	-1	-1
100aa12	2254	branchy	14,8,2,3,5	100aa12~rankms=3_rankdc=5_reps=8_srate=0.8_class=A	449	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	15	-1	-1	25	-1	-1	24	18	2	1	-1	-1
100aa12	2255	0	14,8,2,3,5	100aa12~rankms=3_rankdc=5_reps=8_srate=0.8_class=A	461	U	5	4	2016-04-15	2016-09-11	DC    	20	8	U	8	-1	-1	1	-1	-1	24	18	14	1	-1	-1
100aa12	2256	0	14,8,2,3,5	100aa12~rankms=3_rankdc=5_reps=8_srate=0.8_class=A	462	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	7	-1	-1	7	-1	-1	24	18	15	1	-1	-1
100aa12	2257	0	14,8,2,3,5	100aa12~rankms=3_rankdc=5_reps=8_srate=0.8_class=A	466	U	5	3	2016-04-15	2016-09-11	DC    	20	11	U	6	-1	-1	0	-1	-1	24	18	19	1	-1	-1
100aa12	2258	0	14,8,2,3,5	100aa12~rankms=3_rankdc=5_reps=8_srate=0.8_class=A	482	U	5	3	2016-04-15	2016-09-11	DC    	20	12	U	12	-1	-1	11	-1	-1	24	19	14	1	-1	-1
101aa11	2259	0	0,4,0,2,4	101aa11#rankms=58_rankdc=53_reps=2_srate=1.0_class=A	33	U	4	4	2016-04-15	2016-09-11	MS    	25	12	U	-1	14	14	17	-1	-1	24	1	33	4	-1	-1
101aa11	2260	0	0,4,0,2,4	101aa11#rankms=58_rankdc=53_reps=2_srate=1.0_class=A	464	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	7	-1	-1	0	-1	-1	24	18	17	1	-1	-1
101aa11	2261	0	0,4,0,2,4	101aa11#rankms=58_rankdc=53_reps=2_srate=1.0_class=A	481	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	10	-1	-1	4	-1	-1	24	19	13	1	-1	-1
104aa12	2262	edge biased	4,0,1,0,0	104aa12#rankms=40_rankdc=47_reps=2_srate=1.0_class=A	182	U	2	2	2016-04-15	2016-09-11	MS    	25	14	U	-1	16	16	17	-1	-1	24	6	8	4	-1	-1
104aa12	2263	0	4,0,1,0,0	104aa12#rankms=40_rankdc=47_reps=2_srate=1.0_class=A	259	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	0	-1	-1	24	9	18	1	-1	-1
104aa12	2264	0	4,0,1,0,0	104aa12#rankms=40_rankdc=47_reps=2_srate=1.0_class=A	294	U	5	5	2016-04-15	2016-09-11	DC    	20	13	Y	10	-1	-1	13	-1	-1	24	11	4	1	-1	-1
105aa3	2265	0	14,8,2,2,3	105aa3~rankms=9_rankdc=8_reps=4_srate=0.9_class=A	147	U	3	3	2016-04-15	2016-09-11	MS    	25	12	Y	-1	18	18	23	-1	-1	24	5	17	4	-1	-1
105aa3	2266	0	14,8,2,2,3	105aa3~rankms=9_rankdc=8_reps=4_srate=0.9_class=A	148	U	3	3	2016-04-15	2016-09-11	MS    	25	13	Y	-1	19	19	20	-1	-1	24	5	18	4	-1	-1
105aa3	2267	0	14,8,2,2,3	105aa3~rankms=9_rankdc=8_reps=4_srate=0.9_class=A	185	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	10	-1	-1	8	-1	-1	24	6	10	1	-1	-1
105aa3	2268	0	14,8,2,2,3	105aa3~rankms=9_rankdc=8_reps=4_srate=0.9_class=A	215	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	9	-1	-1	5	-1	-1	24	8	2	1	-1	-1
105aa3	2269	0	14,8,2,2,3	105aa3~rankms=9_rankdc=8_reps=4_srate=0.9_class=A	467	U	5	5	2016-04-15	2016-09-11	DC    	20	8	U	11	-1	-1	3	-1	-1	24	18	20	1	-1	-1
105aa3	2270	nice	14,8,2,2,3	105aa3~rankms=9_rankdc=8_reps=4_srate=0.9_class=A	515	U	5	4	2016-04-15	2016-09-11	DC    	20	8	Y	20	-1	-1	23	-1	-1	24	21	3	1	-1	-1
105aa4	2271	0	0,0,1,0,0	105aa4#rankms=109_rankdc=80_reps=2_srate=0.7_class=A	110	U	4	4	2016-04-15	2016-09-11	MS    	25	12	U	-1	10	10	4	-1	-1	24	4	10	4	-1	-1
105aa4	2272	0	0,0,1,0,0	105aa4#rankms=109_rankdc=80_reps=2_srate=0.7_class=A	175	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	8	-1	-1	4	-1	-1	24	6	5	1	-1	-1
105aa4	2273	0	0,0,1,0,0	105aa4#rankms=109_rankdc=80_reps=2_srate=0.7_class=A	210	U	5	2	2016-04-15	2016-09-11	DC    	20	8	U	8	-1	-1	0	-1	-1	24	7	8	1	-1	-1
105aa5	2274	0	14,8,2,2,4	105aa5#rankms=8_rankdc=9_reps=4_srate=1.0_class=A	155	U	4	4	2016-04-15	2016-09-11	MS    	25	14	Y	-1	20	20	32	-1	-1	24	5	25	4	-1	-1
105aa5	2275	0	14,8,2,2,4	105aa5#rankms=8_rankdc=9_reps=4_srate=1.0_class=A	234	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	11	-1	-1	15	-1	-1	24	8	21	1	-1	-1
105aa5	2276	nice competetive	14,8,2,2,4	105aa5#rankms=8_rankdc=9_reps=4_srate=1.0_class=A	256	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	11	-1	-1	16	-1	-1	24	9	15	1	-1	-1
105aa5	2277	0	14,8,2,2,4	105aa5#rankms=8_rankdc=9_reps=4_srate=1.0_class=A	484	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	6	-1	-1	4	-1	-1	24	19	16	1	-1	-1
105aa5	2278	0	14,8,2,2,4	105aa5#rankms=8_rankdc=9_reps=4_srate=1.0_class=A	513	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	12	-1	-1	10	-1	-1	24	21	2	1	-1	-1
106aa1	2279	nice	4,8,1,1,5	106aa1#rankms=6_rankdc=48_reps=2_srate=0.9_class=A	202	U	3	3	2016-04-15	2016-09-11	MS    	25	14	Y	-1	21	21	29	-1	-1	24	6	25	4	-1	-1
106aa1	2280	0	4,8,1,1,5	106aa1#rankms=6_rankdc=48_reps=2_srate=0.9_class=A	399	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	8	-1	-1	4	-1	-1	24	15	18	1	-1	-1
106aa1	2281	0	4,8,1,1,5	106aa1#rankms=6_rankdc=48_reps=2_srate=0.9_class=A	429	U	5	5	2016-04-15	2016-09-11	DC    	20	13	U	10	-1	-1	11	-1	-1	24	17	4	1	-1	-1
106aa2	2282	0	0	0	195	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	17	17	8	-1	-1	24	6	18	4	-1	-1
106aa2	2283	0	0	0	430	U	5	5	2016-04-15	2016-09-11	DC    	20	14	U	7	-1	-1	3	-1	-1	24	17	5	1	-1	-1
106aa3	2284	0	4,0,1,0,0	106aa3#rankms=24_rankdc=101_reps=2_srate=0.5_class=A	163	U	2	2	2016-04-15	2016-09-11	MS    	25	13	Y	-1	19	19	13	-1	-1	24	5	33	4	-1	-1
106aa3	2285	0	4,0,1,0,0	106aa3#rankms=24_rankdc=101_reps=2_srate=0.5_class=A	340	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	5	-1	-1	7	-1	-1	24	13	4	1	-1	-1
106aa3	2286	0	4,0,1,0,0	106aa3#rankms=24_rankdc=101_reps=2_srate=0.5_class=A	373	U	5	0	2016-04-15	2016-09-11	DC    	20	12	U	0	-1	-1	0	-1	-1	24	14	14	1	-1	-1
106aa4	2287	0	0	0	16	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	16	16	9	-1	-1	24	1	16	4	-1	-1
106aa4	2288	0	0	0	275	U	5	5	2016-04-15	2016-09-11	DC    	20	13	U	6	-1	-1	0	-1	-1	24	10	8	1	-1	-1
106aa6	2289	0	5,0,0,0,0	0	22	U	1	1	2016-04-15	2016-09-11	MS    	25	11	U	-1	17	17	4	-1	-1	24	1	22	4	-1	-1
106aa6	2290	0	5,0,0,0,0	0	280	U	5	4	2016-04-15	2016-09-11	DC    	20	11	U	5	-1	-1	2	-1	-1	24	10	13	1	-1	-1
106aa7	2291	Nice – syliptical 2016 FDC selection with 21mm collar. Rooted as a FDC cutting for 2 years.	5,0,1,0,0	106aa7~rankms=-1_rankdc=2_reps=1_srate=1.0_class=A	500	U	1	1	2016-04-15	2016-09-11	FDC   	20	12	U	21	-1	-1	7	-1	-1	24	20	6	3	-1	-1
106aa8	2292	Nice – syliptical 2016 FDC selection with 21mm collar. Rooted as a FDC cutting for 2 years.	5,0,0,0,0	106aa8~rankms=-1_rankdc=2_reps=1_srate=1.0_class=A	501	U	1	1	2016-04-15	2016-09-11	FDC   	20	12	U	21	-1	-1	7	-1	-1	24	20	6	3	-1	-1
106xaa	2293	1=9cuttings	0	0	502	U	4	4	2016-04-15	2016-09-11	FDC   	20	12	U	11	-1	-1	10	-1	-1	24	20	6	3	-1	-1
106xaa	2294	1=8cuttings	0	0	518	U	4	4	2016-04-15	2016-09-11	FDC   	20	9	U	10	-1	-1	8	-1	-1	24	21	5	3	-1	-1
107aa1	2295	0	0	0	190	U	2	2	2016-04-15	2016-09-11	MS    	25	11	U	-1	15	15	5	-1	-1	24	6	13	4	-1	-1
107aa1	2296	0	0	0	443	U	5	2	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	0	-1	-1	24	17	18	1	-1	-1
107aa2	2297	0	0	0	200	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	19	19	8	-1	-1	24	6	23	4	-1	-1
107aa2	2298	0	0	0	288	U	5	5	2016-04-15	2016-09-11	DC    	20	13	U	7	-1	-1	3	-1	-1	24	10	21	1	-1	-1
107aa3	2299	syliptec shoots	0	107aa3#rankms=33_rankdc=61_reps=1_srate=1.0_class=A	189	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	18	18	6	-1	-1	24	6	12	4	-1	-1
107aa3	2300	0	0	107aa3#rankms=33_rankdc=61_reps=1_srate=1.0_class=A	421	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	8	-1	-1	0	-1	-1	24	16	18	1	-1	-1
107aa7	2301	0	4,8,1,2,0	107aa7#rankms=23_rankdc=42_reps=1_srate=1.0_class=A	199	U	2	2	2016-04-15	2016-09-11	MS    	25	14	U	-1	19	19	14	-1	-1	24	6	22	4	-1	-1
107aa7	2302	0	4,8,1,2,0	107aa7#rankms=23_rankdc=42_reps=1_srate=1.0_class=A	377	U	5	5	2016-04-15	2016-09-11	DC    	20	13	Y	9	-1	-1	14	-1	-1	24	14	18	1	-1	-1
107xaa	2303	Retained 2	0	107xaa?0_0_0_0_class=A	504	U	10	9	2016-04-15	2016-09-11	FDC   	20	9	U	8	-1	-1	3	-1	-1	24	20	8	3	-1	-1
107xaa	2304	0	0	107xaa?0_0_0_0_class=A	520	U	10	10	2016-04-15	2016-09-11	FDC   	20	10	U	7	-1	-1	5	-1	-1	24	21	7	3	-1	-1
11ab1	2305	0	0	0	18	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	15	15	8	-1	-1	24	1	18	4	-1	-1
11ab1	2306	0	0	0	273	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	7	-1	-1	1	-1	-1	24	10	6	1	-1	-1
11ab1	2307	0	0	0	296	U	5	5	2016-04-15	2016-09-11	DC    	20	11	U	6	-1	-1	5	-1	-1	24	11	6	1	-1	-1
11ab10	2308	nice	14,8,2,2,2	11ab10~rankms=2_rankdc=27_reps=2_srate=0.8_class=AH	196	U	2	2	2016-04-15	2016-09-11	MS    	25	14	Y	-1	24	24	18	-1	-1	24	6	19	4	-1	-1
11ab10	2309	0	14,8,2,2,2	11ab10~rankms=2_rankdc=27_reps=2_srate=0.8_class=AH	418	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	12	-1	-1	11	-1	-1	24	16	15	1	-1	-1
11ab10	2310	0	14,8,2,2,2	11ab10~rankms=2_rankdc=27_reps=2_srate=0.8_class=AH	431	U	5	4	2016-04-15	2016-09-11	DC    	20	12	Y	12	-1	-1	18	-1	-1	24	17	6	1	-1	-1
11ab11	2311	0	4,0,1,0,0	11ab11#rankms=13_rankdc=114_reps=1_srate=0.2_class=AH	19	U	2	2	2016-04-15	2016-09-11	MS    	25	16	Y	-1	21	21	13	-1	-1	24	1	19	4	-1	-1
11ab11	2312	0	4,0,1,0,0	11ab11#rankms=13_rankdc=114_reps=1_srate=0.2_class=AH	286	U	5	1	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	0	-1	-1	24	10	19	1	-1	-1
11ab20	2313	edge biased	0	0	172	U	2	2	2016-04-15	2016-09-11	MS    	25	10	U	-1	16	16	14	-1	-1	24	6	3	4	-1	-1
11ab20	2314	0	0	0	231	U	5	2	2016-04-15	2016-09-11	DC    	20	13	U	5	-1	-1	0	-1	-1	24	8	18	1	-1	-1
11ab20	2315	0	0	0	292	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	5	-1	-1	0	-1	-1	24	11	2	1	-1	-1
11ab22	2316	edge biased	14,8,2,2,0	11ab22~rankms=16_rankdc=43_reps=2_srate=0.8_class=AH	178	U	3	3	2016-04-15	2016-09-11	MS    	25	12	Y	-1	20	20	20	-1	-1	24	6	6	4	-1	-1
11ab22	2317	nice	14,8,2,2,0	11ab22~rankms=16_rankdc=43_reps=2_srate=0.8_class=AH	232	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	13	-1	-1	14	-1	-1	24	8	19	1	-1	-1
11ab22	2318	0	14,8,2,2,0	11ab22~rankms=16_rankdc=43_reps=2_srate=0.8_class=AH	270	U	5	3	2016-04-15	2016-09-11	DC    	20	13	U	6	-1	-1	6	-1	-1	24	10	3	1	-1	-1
11ab3	2319	0	4,0,1,0,0	11ab3#rankms=25_rankdc=77_reps=2_srate=0.7_class=AH	10	U	2	2	2016-04-15	2016-09-11	MS    	25	11	U	-1	19	19	12	-1	-1	24	1	10	4	-1	-1
11ab3	2320	0	4,0,1,0,0	11ab3#rankms=25_rankdc=77_reps=2_srate=0.7_class=AH	281	U	5	3	2016-04-15	2016-09-11	DC    	20	11	U	8	-1	-1	0	-1	-1	24	10	14	1	-1	-1
11ab3	2321	0	4,0,1,0,0	11ab3#rankms=25_rankdc=77_reps=2_srate=0.7_class=AH	282	U	5	4	2016-04-15	2016-09-11	DC    	20	11	U	9	-1	-1	4	-1	-1	24	10	15	1	-1	-1
11xab	2322	0	0	11xab?0_0_0_0_class=AH	508	U	6	5	2016-04-15	2016-09-11	FDC   	20	10	U	6	-1	-1	1	-1	-1	24	20	12	3	-1	-1
11xab	2323	1=nice	0	11xab?0_0_0_0_class=AH	524	U	6	5	2016-04-15	2016-09-11	FDC   	20	11	U	12	-1	-1	9	-1	-1	24	21	11	3	-1	-1
13gb3	2324	0	0	0	15	U	2	1	2016-04-15	2016-09-11	MS    	25	14	U	-1	11	11	1	-1	-1	24	1	15	4	-1	-1
13gb3	2325	0	0	0	302	U	5	0	2016-04-15	2016-09-11	DC    	20	13	U	0	-1	-1	0	-1	-1	24	11	12	1	-1	-1
13gb3	2326	0	0	0	303	U	5	0	2016-04-15	2016-09-11	DC    	20	12	U	0	-1	-1	0	-1	-1	24	11	13	1	-1	-1
13gb6	2327	0	0,0,1,0,0	13gb6#rankms=40_rankdc=111_reps=2_srate=0.2_class=ASH	118	U	2	2	2016-04-15	2016-09-11	MS    	25	14	U	-1	17	17	7	-1	-1	24	4	18	4	-1	-1
13gb6	2328	0	0,0,1,0,0	13gb6#rankms=40_rankdc=111_reps=2_srate=0.2_class=ASH	360	U	5	0	2016-04-15	2016-09-11	DC    	20	13	U	0	-1	-1	0	-1	-1	24	14	1	1	-1	-1
13gb6	2329	0	0,0,1,0,0	13gb6#rankms=40_rankdc=111_reps=2_srate=0.2_class=ASH	383	U	5	2	2016-04-15	2016-09-11	DC    	20	12	U	9	-1	-1	0	-1	-1	24	15	2	1	-1	-1
13gb7	2330	0	0	0	58	U	1	1	2016-04-15	2016-09-11	MS    	25	17	U	-1	6	6	0	-1	-1	24	2	21	4	-1	-1
13gb7	2331	0	0	0	371	U	5	0	2016-04-15	2016-09-11	DC    	20	14	U	0	-1	-1	0	-1	-1	24	14	12	1	-1	-1
13gb7	2332	0	0	0	392	U	5	0	2016-04-15	2016-09-11	DC    	20	12	U	0	-1	-1	0	-1	-1	24	15	11	1	-1	-1
13xgb	2333	0	0	0	493	U	1	1	2016-04-15	2016-09-11	FDC   	20	8	U	7	-1	-1	0	-1	-1	24	20	2	3	-1	-1
13xgb	2334	0	0	0	514	U	1	1	2016-04-15	2016-09-11	FDC   	20	10	U	8	-1	-1	0	-1	-1	24	21	2	3	-1	-1
14b1	2335	0	0	0	115	U	3	3	2016-04-15	2016-09-11	MS    	25	13	U	-1	11	11	6	-1	-1	24	4	15	4	-1	-1
14b1	2336	0	0	0	169	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	5	-1	-1	2	-1	-1	24	6	2	1	-1	-1
14b1	2337	0	0	0	255	U	5	5	2016-04-15	2016-09-11	DC    	20	11	U	6	-1	-1	0	-1	-1	24	9	14	1	-1	-1
14b10	2338	0	14,8,2,2,4	14b10~rankms=56_rankdc=48_reps=2_srate=1.0_class=H	100	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	15	15	9	-1	-1	24	3	34	4	-1	-1
14b10	2339	0	14,8,2,2,4	14b10~rankms=56_rankdc=48_reps=2_srate=1.0_class=H	208	U	5	5	2016-04-15	2016-09-11	DC    	20	8	Y	7	-1	-1	7	-1	-1	24	7	6	1	-1	-1
14b10	2340	0	14,8,2,2,4	14b10~rankms=56_rankdc=48_reps=2_srate=1.0_class=H	228	U	5	5	2016-04-15	2016-09-11	DC    	20	9	Y	9	-1	-1	10	-1	-1	24	8	15	1	-1	-1
14b11	2341	0	4,0,1,0,0	14b11#rankms=85_rankdc=82_reps=2_srate=0.8_class=H	144	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	12	12	11	-1	-1	24	5	14	4	-1	-1
14b11	2342	0	4,0,1,0,0	14b11#rankms=85_rankdc=82_reps=2_srate=0.8_class=H	226	U	5	3	2016-04-15	2016-09-11	DC    	20	9	U	5	-1	-1	0	-1	-1	24	8	13	1	-1	-1
14b11	2343	0	4,0,1,0,0	14b11#rankms=85_rankdc=82_reps=2_srate=0.8_class=H	247	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	8	-1	-1	1	-1	-1	24	9	6	1	-1	-1
14b12	2344	0	0	0	113	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	9	9	0	-1	-1	24	4	13	4	-1	-1
14b12	2345	0	0	0	181	U	5	5	2016-04-15	2016-09-11	DC    	20	11	U	6	-1	-1	3	-1	-1	24	6	8	1	-1	-1
14b12	2346	0	0	0	207	U	5	5	2016-04-15	2016-09-11	DC    	20	8	U	3	-1	-1	5	-1	-1	24	7	5	1	-1	-1
14b13	2347	0	0	0	154	U	3	3	2016-04-15	2016-09-11	MS    	25	12	Y	-1	16	16	18	-1	-1	24	5	24	4	-1	-1
14b13	2348	0	0	0	203	U	5	3	2016-04-15	2016-09-11	DC    	20	13	U	10	-1	-1	9	-1	-1	24	7	1	1	-1	-1
14b13	2349	0	0	0	252	U	5	2	2016-04-15	2016-09-11	DC    	20	13	U	14	-1	-1	5	-1	-1	24	9	11	1	-1	-1
14b14	2350	nice	4,8,1,2,0	14b14#rankms=56_rankdc=67_reps=2_srate=0.3_class=H	143	U	3	3	2016-04-15	2016-09-11	MS    	25	12	Y	-1	14	14	19	-1	-1	24	5	13	4	-1	-1
14b14	2351	0	4,8,1,2,0	14b14#rankms=56_rankdc=67_reps=2_srate=0.3_class=H	261	U	5	2	2016-04-15	2016-09-11	DC    	20	12	U	21	-1	-1	9	-1	-1	24	9	20	1	-1	-1
14b14	2352	0	0	0	262	U	4	1	2016-04-15	2016-09-11	DC    	20	11	U	14	-1	-1	5	-1	-1	24	9	21	1	-1	-1
14b15	2353	0	0	0	111	U	3	3	2016-04-15	2016-09-11	MS    	25	10	U	-1	13	13	9	-1	-1	24	4	11	4	-1	-1
14b15	2354	0	0	0	177	U	5	2	2016-04-15	2016-09-11	DC    	20	10	U	10	-1	-1	1	-1	-1	24	6	6	1	-1	-1
14b16	2355	propagates well	4,0,1,2,3	14b16#rankms=7_rankdc=72_reps=2_srate=1.0_class=H	107	U	2	2	2016-04-15	2016-09-11	MS    	25	12	Y	-1	22	22	15	-1	-1	24	4	7	4	-1	-1
14b16	2356	propagates well	4,0,1,2,3	14b16#rankms=7_rankdc=72_reps=2_srate=1.0_class=H	173	U	5	5	2016-04-15	2016-09-11	DC    	20	8	U	6	-1	-1	4	-1	-1	24	6	4	1	-1	-1
14b16	2357	propagates well	4,0,1,2,3	14b16#rankms=7_rankdc=72_reps=2_srate=1.0_class=H	209	U	5	5	2016-04-15	2016-09-11	DC    	20	8	Y	6	-1	-1	6	-1	-1	24	7	7	1	-1	-1
14b17	2358	0	4,0,1,1,0	14b17#rankms=45_rankdc=77_reps=2_srate=0.6_class=H	108	U	3	3	2016-04-15	2016-09-11	MS    	25	12	Y	-1	15	15	19	-1	-1	24	4	8	4	-1	-1
14b17	2359	0	4,0,1,1,0	14b17#rankms=45_rankdc=77_reps=2_srate=0.6_class=H	229	U	5	4	2016-04-15	2016-09-11	DC    	20	9	U	6	-1	-1	4	-1	-1	24	8	16	1	-1	-1
14b17	2360	QTY=4	4,0,1,1,0	14b17#rankms=45_rankdc=77_reps=2_srate=0.6_class=H	251	U	4	2	2016-04-15	2016-09-11	DC    	20	11	U	12	-1	-1	6	-1	-1	24	9	10	1	-1	-1
14b18	2361	0	0	0	109	U	3	3	2016-04-15	2016-09-11	MS    	25	12	Y	-1	15	15	18	-1	-1	24	4	9	4	-1	-1
14b18	2362	0	0	0	250	U	5	4	2016-04-15	2016-09-11	DC    	20	11	U	9	-1	-1	8	-1	-1	24	9	9	1	-1	-1
14b19	2363	0	4,0,1,0,0	14b19#rankms=64_rankdc=100_reps=2_srate=0.5_class=H	117	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	14	14	12	-1	-1	24	4	17	4	-1	-1
14b19	2364	0	4,0,1,0,0	14b19#rankms=64_rankdc=100_reps=2_srate=0.5_class=H	179	U	5	3	2016-04-15	2016-09-11	DC    	20	11	U	5	-1	-1	0	-1	-1	24	6	7	1	-1	-1
14b19	2365	0	4,0,1,0,0	14b19#rankms=64_rankdc=100_reps=2_srate=0.5_class=H	206	U	5	2	2016-04-15	2016-09-11	DC    	20	9	U	9	-1	-1	0	-1	-1	24	7	4	1	-1	-1
14b20	2366	0	0	0	112	U	2	1	2016-04-15	2016-09-11	MS    	25	12	U	-1	9	9	0	-1	-1	24	4	12	4	-1	-1
14b20	2367	0	0	0	253	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	3	-1	-1	1	-1	-1	24	9	12	1	-1	-1
14b21	2368	biased	14,8,2,2,3	14b21~rankms=30_rankdc=29_reps=2_srate=0.9_class=H	101	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	17	17	20	-1	-1	24	4	1	4	-1	-1
14b21	2369	0	14,8,2,2,3	14b21~rankms=30_rankdc=29_reps=2_srate=0.9_class=H	227	U	5	5	2016-04-15	2016-09-11	DC    	20	11	U	9	-1	-1	6	-1	-1	24	8	14	1	-1	-1
14b21	2370	0	14,8,2,2,3	14b21~rankms=30_rankdc=29_reps=2_srate=0.9_class=H	249	U	5	4	2016-04-15	2016-09-11	DC    	20	10	U	15	-1	-1	11	-1	-1	24	9	8	1	-1	-1
14b3	2371	0	0,0,1,0,0	14b3#rankms=75_rankdc=82_reps=2_srate=0.8_class=H	105	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	13	13	11	-1	-1	24	4	5	4	-1	-1
14b3	2372	0	0,0,1,0,0	14b3#rankms=75_rankdc=82_reps=2_srate=0.8_class=H	222	U	5	3	2016-04-15	2016-09-11	DC    	20	11	U	7	-1	-1	0	-1	-1	24	8	9	1	-1	-1
14b3	2373	0	0,0,1,0,0	14b3#rankms=75_rankdc=82_reps=2_srate=0.8_class=H	223	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	6	-1	-1	5	-1	-1	24	8	10	1	-1	-1
14b30	2374	0	4,0,1,0,0	14b30#rankms=103_rankdc=63_reps=1_srate=0.8_class=H	8	U	1	1	2016-04-15	2016-09-11	MS    	25	15	U	-1	11	11	1	-1	-1	24	1	8	4	-1	-1
14b30	2375	0	4,0,1,0,0	14b30#rankms=103_rankdc=63_reps=1_srate=0.8_class=H	300	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	9	-1	-1	6	-1	-1	24	11	10	1	-1	-1
14b31	2376	0	14,0,2,0,0	14b31~rankms=133_rankdc=7_reps=1_srate=1.0_class=H	28	U	1	1	2016-04-15	2016-09-11	MS    	25	15	U	-1	8	8	0	-1	-1	24	1	28	4	-1	-1
14b31	2377	nice	14,0,2,0,0	14b31~rankms=133_rankdc=7_reps=1_srate=1.0_class=H	301	U	5	5	2016-04-15	2016-09-11	DC    	20	13	Y	14	-1	-1	16	-1	-1	24	11	11	1	-1	-1
14b4	2378	nice	4,0,1,0,0	14b4#rankms=23_rankdc=89_reps=2_srate=0.5_class=H	140	U	3	3	2016-04-15	2016-09-11	MS    	25	14	Y	-1	18	18	24	-1	-1	24	5	10	4	-1	-1
14b4	2379	0	4,0,1,0,0	14b4#rankms=23_rankdc=89_reps=2_srate=0.5_class=H	183	U	5	2	2016-04-15	2016-09-11	DC    	20	11	U	10	-1	-1	2	-1	-1	24	6	9	1	-1	-1
14b4	2380	0	4,0,1,0,0	14b4#rankms=23_rankdc=89_reps=2_srate=0.5_class=H	242	U	5	3	2016-04-15	2016-09-11	DC    	20	15	U	8	-1	-1	2	-1	-1	24	9	3	1	-1	-1
14b40	2381	nice big leaves FDC selection 	12,0,0,0,0	14b40#0_0_0_0_class=H	243	U	1	1	2016-04-15	2016-09-11	DC    	20	12	U	8	-1	-1	1	-1	-1	24	9	3	1	-1	-1
14b41	2382	nice FDC Selection	1,0,1,0,0	14b41#0_0_0_0_class=H	244	U	1	1	2016-04-15	2016-09-11	DC    	20	12	U	8	-1	-1	1	-1	-1	24	9	3	1	-1	-1
14b6	2383	0	4,0,1,0,0	14b6#rankms=105_rankdc=64_reps=1_srate=1.0_class=H	116	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	10	10	7	-1	-1	24	4	16	4	-1	-1
14b6	2384	0	4,0,1,0,0	14b6#rankms=105_rankdc=64_reps=1_srate=1.0_class=H	205	U	5	5	2016-04-15	2016-09-11	DC    	20	10	Y	7	-1	-1	5	-1	-1	24	7	3	1	-1	-1
14b7	2385	nice - no bias	28,4,2,2,5	14b7~rankms=21_rankdc=51_reps=2_srate=1.0_class=H	114	U	3	3	2016-04-15	2016-09-11	MS    	25	12	Y	-1	19	19	21	-1	-1	24	4	14	4	-1	-1
14b7	2386	0	28,4,2,2,5	14b7~rankms=21_rankdc=51_reps=2_srate=1.0_class=H	171	U	5	5	2016-04-15	2016-09-11	DC    	20	7	U	6	-1	-1	1	-1	-1	24	6	3	1	-1	-1
14b7	2387	0	28,4,2,2,5	14b7~rankms=21_rankdc=51_reps=2_srate=1.0_class=H	211	U	5	5	2016-04-15	2016-09-11	DC    	20	10	Y	9	-1	-1	15	-1	-1	24	7	9	1	-1	-1
14b9	2388	0	0	0	268	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	10	-1	-1	6	-1	-1	24	10	1	1	-1	-1
14b9	2389	0	0	0	75	U	1	1	2016-04-15	2016-09-11	MS    	25	13	U	-1	17	17	4	-1	-1	24	3	9	4	-1	-1
14xb	2390	2=ok	4,0,0,0,0	14xb?0_0_0_0_class=H	510	U	10	8	2016-04-15	2016-09-11	FDC   	20	9	U	7	-1	-1	4	-1	-1	24	20	14	3	-1	-1
14xb	2391	3=nice retained 4	4,0,0,0,0	14xb?0_0_0_0_class=H	526	U	9	8	2016-04-15	2016-09-11	FDC   	20	7	Y	9	-1	-1	16	-1	-1	24	21	13	3	-1	-1
15b1	2392	0	0	0	85	U	3	3	2016-04-15	2016-09-11	MS    	25	11	U	-1	9	9	4	-1	-1	24	3	19	4	-1	-1
15b1	2393	0	0	0	417	U	5	5	2016-04-15	2016-09-11	DC    	20	11	U	7	-1	-1	0	-1	-1	24	16	14	1	-1	-1
15b11	2394	0	4,0,1,0,0	15b11#rankms=51_rankdc=85_reps=2_srate=0.5_class=H	102	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	15	15	14	-1	-1	24	4	2	4	-1	-1
15b11	2395	0	4,0,1,0,0	15b11#rankms=51_rankdc=85_reps=2_srate=0.5_class=H	216	U	5	3	2016-04-15	2016-09-11	DC    	20	12	U	5	-1	-1	0	-1	-1	24	8	3	1	-1	-1
15b11	2396	0	4,0,1,0,0	15b11#rankms=51_rankdc=85_reps=2_srate=0.5_class=H	230	U	5	2	2016-04-15	2016-09-11	DC    	20	14	U	15	-1	-1	6	-1	-1	24	8	17	1	-1	-1
15b12	2397	0	0	0	92	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	6	6	0	-1	-1	24	3	26	4	-1	-1
15b12	2398	0	0	0	419	U	5	4	2016-04-15	2016-09-11	DC    	20	10	U	5	-1	-1	0	-1	-1	24	16	16	1	-1	-1
15b14	2399	small diameter stools	4,0,1,0,0	15b14#rankms=156_rankdc=129_reps=1_srate=0.0_class=H	146	U	2	2	2016-04-15	2016-09-11	MS    	25	15	U	-1	9	9	9	-1	-1	24	5	16	4	-1	-1
15b14	2400	1st DC	4,0,1,0,0	15b14#rankms=156_rankdc=129_reps=1_srate=0.0_class=H	167	U	5	0	2016-04-15	2016-09-11	MS    	25	10	U	0	-1	-1	0	-1	-1	24	6	1	1	-1	-1
15b14	2401	0	4,0,1,0,0	15b14#rankms=156_rankdc=129_reps=1_srate=0.0_class=H	218	U	5	0	2016-04-15	2016-09-11	DC    	20	13	U	0	-1	-1	0	-1	-1	24	8	5	1	-1	-1
15b16	2402	0	0	0	142	U	3	3	2016-04-15	2016-09-11	MS    	25	10	U	-1	9	9	5	-1	-1	24	5	12	4	-1	-1
15b16	2403	0	0	0	245	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	5	-1	-1	0	-1	-1	24	9	4	1	-1	-1
15b16	2404	0	0	0	246	U	5	4	2016-04-15	2016-09-11	DC    	20	9	U	8	-1	-1	0	-1	-1	24	9	5	1	-1	-1
15b17	2405	0	0	0	103	U	3	3	2016-04-15	2016-09-11	MS    	25	13	U	-1	10	10	5	-1	-1	24	4	3	4	-1	-1
15b17	2406	0	0	0	219	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	8	-1	-1	4	-1	-1	24	8	6	1	-1	-1
15b17	2407	0	0	0	224	U	5	5	2016-04-15	2016-09-11	DC    	20	13	U	5	-1	-1	0	-1	-1	24	8	11	1	-1	-1
15b4	2408	0	0	0	88	U	2	1	2016-04-15	2016-09-11	MS    	25	10	U	-1	8	8	0	-1	-1	24	3	22	4	-1	-1
15b4	2409	0	0	0	381	U	5	3	2016-04-15	2016-09-11	DC    	20	8	U	4	-1	-1	0	-1	-1	24	14	22	1	-1	-1
15b4	2410	0	0	0	386	U	5	0	2016-04-15	2016-09-11	DC    	20	11	U	0	-1	-1	0	-1	-1	24	15	5	1	-1	-1
15b5	2411	0	4,0,1,0,0	15b5#rankms=121_rankdc=38_reps=1_srate=1.0_class=H	84	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	9	9	0	-1	-1	24	3	18	4	-1	-1
15b5	2412	0	4,0,1,0,0	15b5#rankms=121_rankdc=38_reps=1_srate=1.0_class=H	379	U	5	5	2016-04-15	2016-09-11	DC    	20	13	U	10	-1	-1	6	-1	-1	24	14	20	1	-1	-1
15b6	2413	0	0	0	96	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	8	8	0	-1	-1	24	3	30	4	-1	-1
15b6	2414	0	0	0	380	U	5	2	2016-04-15	2016-09-11	DC    	20	13	U	4	-1	-1	0	-1	-1	24	14	21	1	-1	-1
15b6	2415	0	0	0	405	U	5	3	2016-04-15	2016-09-11	DC    	20	12	U	12	-1	-1	9	-1	-1	24	16	2	1	-1	-1
15b8	2416	0	4,0,1,0,0	15b8#rankms=133_rankdc=27_reps=1_srate=1.0_class=H	99	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	8	8	0	-1	-1	24	3	33	4	-1	-1
15b8	2417	0	4,0,1,0,0	15b8#rankms=133_rankdc=27_reps=1_srate=1.0_class=H	426	U	5	5	2016-04-15	2016-09-11	DC    	20	11	U	12	-1	-1	5	-1	-1	24	17	1	1	-1	-1
16ab1	2418	0	4,4,1,2,0	16ab1#rankms=15_rankdc=48_reps=1_srate=1.0_class=AH	21	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	21	21	11	-1	-1	24	1	21	4	-1	-1
16ab1	2419	0	4,4,1,2,0	16ab1#rankms=15_rankdc=48_reps=1_srate=1.0_class=AH	276	U	5	5	2016-04-15	2016-09-11	DC    	20	14	Y	9	-1	-1	7	-1	-1	24	10	9	1	-1	-1
16ab4	2420	0	0	0	24	U	2	2	2016-04-15	2016-09-11	MS    	25	11	U	-1	10	10	0	-1	-1	24	1	24	4	-1	-1
16ab4	2421	0	0	0	299	U	5	5	2016-04-15	2016-09-11	DC    	20	11	U	7	-1	-1	1	-1	-1	24	11	9	1	-1	-1
16ab8	2422	0	14,0,2,2,0	16ab8~rankms=41_rankdc=33_reps=1_srate=0.8_class=AH	12	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	17	17	6	-1	-1	24	1	12	4	-1	-1
16ab8	2423	0	14,0,2,2,0	16ab8~rankms=41_rankdc=33_reps=1_srate=0.8_class=AH	297	U	5	4	2016-04-15	2016-09-11	DC    	20	12	Y	13	-1	-1	14	-1	-1	24	11	7	1	-1	-1
16xab	2424	0	0	16xab?0_0_0_0_class=AH	503	U	4	4	2016-04-15	2016-09-11	FDC   	20	9	U	8	-1	-1	1	-1	-1	24	20	7	3	-1	-1
16xab	2425	ok, retained 1	0	16xab?0_0_0_0_class=AH	519	U	4	4	2016-04-15	2016-09-11	FDC   	20	9	U	16	-1	-1	9	-1	-1	24	21	6	3	-1	-1
17b3	2426	0	0	0	82	U	1	0	2016-04-15	2016-09-11	MS    	25	14	U	-1	0	0	0	-1	-1	24	3	16	4	-1	-1
17b3	2427	0	0	0	388	U	5	0	2016-04-15	2016-09-11	DC    	20	8	U	0	-1	-1	0	-1	-1	24	15	7	1	-1	-1
17b3	2428	0	0	0	441	U	5	1	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	0	-1	-1	24	17	16	1	-1	-1
18bg1	2429	0	0	0	98	U	3	3	2016-04-15	2016-09-11	MS    	25	11	U	-1	8	8	0	-1	-1	24	3	32	4	-1	-1
18bg1	2430	0	0	0	428	U	5	4	2016-04-15	2016-09-11	DC    	20	9	U	5	-1	-1	0	-1	-1	24	17	3	1	-1	-1
18bg1	2431	0	0	0	437	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	8	-1	-1	0	-1	-1	24	17	12	1	-1	-1
18bg11	2432	0	0	0	133	U	1	0	2016-04-15	2016-09-11	MS    	25	14	U	-1	0	0	0	-1	-1	24	5	3	4	-1	-1
18bg11	2433	0	0	0	356	U	5	3	2016-04-15	2016-09-11	DC    	20	11	U	8	-1	-1	0	-1	-1	24	13	20	1	-1	-1
18bg12	2434	0	0	0	136	U	1	1	2016-04-15	2016-09-11	MS    	25	15	U	-1	9	9	0	-1	-1	24	5	6	4	-1	-1
18bg12	2435	0	0	0	352	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	6	-1	-1	0	-1	-1	24	13	16	1	-1	-1
18bg13	2436	0	0	0	134	U	3	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	4	4	0	-1	-1	24	5	4	4	-1	-1
18bg13	2437	0	0	0	341	U	5	4	2016-04-15	2016-09-11	DC    	20	14	U	8	-1	-1	2	-1	-1	24	13	5	1	-1	-1
18bg15	2438	0	0	0	35	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	14	14	4	-1	-1	24	1	35	4	-1	-1
18bg15	2439	0	0	0	458	U	5	5	2016-04-15	2016-09-11	DC    	20	13	U	5	-1	-1	0	-1	-1	24	18	11	1	-1	-1
18bg17	2440	0	4,0,1,0,0	18bg17#rankms=45_rankdc=77_reps=1_srate=0.8_class=ASH	32	U	2	2	2016-04-15	2016-09-11	MS    	25	10	U	-1	16	16	9	-1	-1	24	1	32	4	-1	-1
18bg17	2441	0	4,0,1,0,0	18bg17#rankms=45_rankdc=77_reps=1_srate=0.8_class=ASH	453	U	5	4	2016-04-15	2016-09-11	DC    	20	11	U	8	-1	-1	0	-1	-1	24	18	6	1	-1	-1
18bg18	2442	weak	0	0	81	U	2	2	2016-04-15	2016-09-11	MS    	25	10	U	-1	4	4	0	-1	-1	24	3	15	4	-1	-1
18bg18	2443	0	0	0	413	U	5	2	2016-04-15	2016-09-11	DC    	20	13	U	9	-1	-1	0	-1	-1	24	16	10	1	-1	-1
18bg19	2444	0	16,4,2,0,3	18bg19~rankms=76_rankdc=50_reps=1_srate=1.0_class=ASH	34	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	13	13	9	-1	-1	24	1	34	4	-1	-1
18bg19	2445	0	16,4,2,0,3	18bg19~rankms=76_rankdc=50_reps=1_srate=1.0_class=ASH	456	U	5	5	2016-04-15	2016-09-11	DC    	20	11	U	9	-1	-1	4	-1	-1	24	18	9	1	-1	-1
18bg2	2446	0	16,4,2,0,2	18bg2~rankms=64_rankdc=46_reps=1_srate=1.0_class=ASH	31	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	14	14	12	-1	-1	24	1	31	4	-1	-1
18bg2	2447	ok	16,4,2,0,2	18bg2~rankms=64_rankdc=46_reps=1_srate=1.0_class=ASH	475	U	5	5	2016-04-15	2016-09-11	DC    	20	15	U	9	-1	-1	10	-1	-1	24	19	7	1	-1	-1
18bg20	2448	small diameter stools	0	0	145	U	3	2	2016-04-15	2016-09-11	MS    	25	9	U	-1	6	6	4	-1	-1	24	5	15	4	-1	-1
18bg20	2449	0	0	0	318	U	5	4	2016-04-15	2016-09-11	DC    	20	10	U	7	-1	-1	0	-1	-1	24	12	5	1	-1	-1
18bg21	2450	0	0	0	93	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	6	6	0	-1	-1	24	3	27	4	-1	-1
18bg21	2451	0	0	0	365	U	5	3	2016-04-15	2016-09-11	DC    	20	12	U	10	-1	-1	1	-1	-1	24	14	6	1	-1	-1
18bg22	2452	0	0	0	90	U	2	2	2016-04-15	2016-09-11	MS    	25	10	U	-1	14	14	4	-1	-1	24	3	24	4	-1	-1
18bg22	2453	0	0	0	366	U	5	3	2016-04-15	2016-09-11	DC    	20	9	U	7	-1	-1	0	-1	-1	24	14	7	1	-1	-1
18bg23	2454	0	0	0	135	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	8	8	3	-1	-1	24	5	5	4	-1	-1
18bg23	2455	0	0	0	320	U	5	2	2016-04-15	2016-09-11	DC    	20	14	U	7	-1	-1	0	-1	-1	24	12	7	1	-1	-1
18bg24	2456	0	0	0	130	U	2	2	2016-04-15	2016-09-11	MS    	25	11	U	-1	8	8	0	-1	-1	24	4	30	4	-1	-1
18bg24	2457	0	0	0	328	U	5	3	2016-04-15	2016-09-11	DC    	20	13	U	6	-1	-1	0	-1	-1	24	12	15	1	-1	-1
18bg25	2458	0	14,8,2,2,4	18bg25~rankms=115_rankdc=59_reps=2_srate=0.8_class=ASH	83	U	3	3	2016-04-15	2016-09-11	MS    	25	13	U	-1	9	9	7	-1	-1	24	3	17	4	-1	-1
18bg25	2459	0	14,8,2,2,4	18bg25~rankms=115_rankdc=59_reps=2_srate=0.8_class=ASH	364	U	5	4	2016-04-15	2016-09-11	DC    	20	10	U	8	-1	-1	5	-1	-1	24	14	5	1	-1	-1
18bg25	2460	0	14,8,2,2,4	18bg25~rankms=115_rankdc=59_reps=2_srate=0.8_class=ASH	387	U	5	4	2016-04-15	2016-09-11	DC    	20	13	U	10	-1	-1	6	-1	-1	24	15	6	1	-1	-1
18bg3	2461	0	0	0	89	U	3	3	2016-04-15	2016-09-11	MS    	25	11	U	-1	8	8	4	-1	-1	24	3	23	4	-1	-1
18bg3	2462	0	0	0	401	U	5	0	2016-04-15	2016-09-11	DC    	20	12	U	0	-1	-1	0	-1	-1	24	15	20	1	-1	-1
18bg3	2463	0	0	0	415	U	5	3	2016-04-15	2016-09-11	DC    	20	13	U	5	-1	-1	0	-1	-1	24	16	12	1	-1	-1
18bg5	2464	0	0	0	43	U	1	0	2016-04-15	2016-09-11	MS    	25	17	U	-1	0	0	0	-1	-1	24	2	6	4	-1	-1
18bg5	2465	0	0	0	350	U	5	2	2016-04-15	2016-09-11	DC    	20	15	U	11	-1	-1	2	-1	-1	24	13	14	1	-1	-1
18bg8	2466	0	0	0	46	U	2	2	2016-04-15	2016-09-11	MS    	25	8	U	-1	5	5	0	-1	-1	24	2	9	4	-1	-1
18bg8	2467	0	0	0	330	U	5	1	2016-04-15	2016-09-11	DC    	20	8	U	4	-1	-1	0	-1	-1	24	12	17	1	-1	-1
18bg9	2468	0	0	0	44	U	3	3	2016-04-15	2016-09-11	MS    	25	8	U	-1	3	3	0	-1	-1	24	2	7	4	-1	-1
18bg9	2469	0	0	0	346	U	5	3	2016-04-15	2016-09-11	DC    	20	8	U	6	-1	-1	0	-1	-1	24	13	10	1	-1	-1
22bg10	2513	0	0	0	258	U	5	3	2016-04-15	2016-09-11	DC    	20	13	U	7	-1	-1	0	-1	-1	24	9	17	1	-1	-1
18xbg	2470	3=10cuttings nice leaves	4,0,0,0,0	18xbg?0_0_0_0_class=ASH	499	U	7	6	2016-04-15	2016-09-11	FDC   	20	8	U	11	-1	-1	10	-1	-1	24	20	5	3	-1	-1
18xbg	2471	0	4,0,0,0,0	18xbg?0_0_0_0_class=ASH	517	U	7	5	2016-04-15	2016-09-11	FDC   	20	10	U	7	-1	-1	8	-1	-1	24	21	4	3	-1	-1
19gb1	2472	nice - nice leaves	0,0,1,0,0	19gb1#rankms=62_rankdc=105_reps=2_srate=0.3_class=ASH	120	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	15	15	4	-1	-1	24	4	20	4	-1	-1
19gb1	2473	0	0,0,1,0,0	19gb1#rankms=62_rankdc=105_reps=2_srate=0.3_class=ASH	319	U	5	0	2016-04-15	2016-09-11	DC    	20	13	U	0	-1	-1	0	-1	-1	24	12	6	1	-1	-1
19gb1	2474	0	0,0,1,0,0	19gb1#rankms=62_rankdc=105_reps=2_srate=0.3_class=ASH	361	U	5	3	2016-04-15	2016-09-11	DC    	20	13	U	7	-1	-1	5	-1	-1	24	14	2	1	-1	-1
19gb2	2475	0	0	0	123	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	12	12	2	-1	-1	24	4	23	4	-1	-1
19gb2	2476	0	0	0	266	U	5	0	2016-04-15	2016-09-11	DC    	20	10	U	0	-1	-1	0	-1	-1	24	9	25	1	-1	-1
19gb2	2477	0	0	0	336	U	5	0	2016-04-15	2016-09-11	DC    	20	13	U	0	-1	-1	0	-1	-1	24	12	23	1	-1	-1
19gb9	2478	edge biased	4,0,1,0,0	19gb9#rankms=29_rankdc=96_reps=2_srate=0.5_class=ASH	174	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	18	18	11	-1	-1	24	6	4	4	-1	-1
19gb9	2479	0	4,0,1,0,0	19gb9#rankms=29_rankdc=96_reps=2_srate=0.5_class=ASH	271	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	3	-1	-1	24	10	4	1	-1	-1
19gb9	2480	0	4,0,1,0,0	19gb9#rankms=29_rankdc=96_reps=2_srate=0.5_class=ASH	295	U	5	1	2016-04-15	2016-09-11	DC    	20	12	U	5	-1	-1	0	-1	-1	24	11	5	1	-1	-1
19xgb	2481	Start Family Dormant Cuttings (FDC) 1=6cuttings, retained 2	0	19xgb?0_0_0_0_class=ASH	491	U	3	3	2016-04-15	2016-09-11	FDC   	20	8	U	9	-1	-1	6	-1	-1	24	20	1	3	-1	-1
19xgb	2482	Retained 2	0	19xgb?0_0_0_0_class=ASH	512	U	3	2	2016-04-15	2016-09-11	FDC   	20	8	U	14	-1	-1	4	-1	-1	24	21	1	3	-1	-1
1bar1	2483	Dead	0	0	4	U	1	0	2016-04-15	2016-09-11	MS    	25	10	U	-1	0	0	0	-1	-1	24	1	4	4	-1	-1
1bar2	2484	Dead	0	0	23	U	1	1	2016-04-15	2016-09-11	MS    	25	8	U	-1	0	0	0	-1	-1	24	1	23	4	-1	-1
1bw1	2485	weak	0	0	48	U	2	2	2016-04-15	2016-09-11	MS    	25	11	U	-1	4	4	0	-1	-1	24	2	11	4	-1	-1
1bw1	2486	edge biased	0	0	168	U	2	2	2016-04-15	2016-09-11	MS    	25	7	U	-1	10	10	2	-1	-1	24	6	1	4	-1	-1
1bw1	2487	0	0	0	323	U	5	4	2016-04-15	2016-09-11	DC    	20	9	U	5	-1	-1	0	-1	-1	24	12	10	1	-1	-1
1bw1	2488	0	0	0	376	U	5	2	2016-04-15	2016-09-11	DC    	20	8	U	6	-1	-1	0	-1	-1	24	14	17	1	-1	-1
1bw6	2489	edge biased - AG type	14,8,2,2,6	1bw6~rankms=13_rankdc=39_reps=3_srate=1.0_class=H	176	U	4	4	2016-04-15	2016-09-11	MS    	25	10	Y	-1	20	20	23	-1	-1	24	6	5	4	-1	-1
1bw6	2490	ag type	14,8,2,2,6	1bw6~rankms=13_rankdc=39_reps=3_srate=1.0_class=H	269	U	5	5	2016-04-15	2016-09-11	DC    	20	11	Y	9	-1	-1	5	-1	-1	24	10	2	1	-1	-1
1bw6	2491	0	14,8,2,2,6	1bw6~rankms=13_rankdc=39_reps=3_srate=1.0_class=H	293	U	5	5	2016-04-15	2016-09-11	DC    	20	10	Y	11	-1	-1	6	-1	-1	24	11	3	1	-1	-1
1bw6	2492	0	14,8,2,2,6	1bw6~rankms=13_rankdc=39_reps=3_srate=1.0_class=H	465	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	8	-1	-1	1	-1	-1	24	18	18	1	-1	-1
1xarg	2493	S-N rows.Rakers seedlngs 6/18/16 (mixed with few 24x) 	0	0	534	U	4	4	2016-04-15	2016-09-11	SEL   	15	2	U	6	-1	-1	1	-1	-1	24	26	1	6	-1	-1
1xarg	2494	S-N rows.Rakers seedlngs 6/18/16 (mixed with few 24x) 	0	0	536	U	5	3	2016-04-15	2016-09-11	SEL   	15	2	U	7	-1	-1	0	-1	-1	24	27	1	6	-1	-1
20bs1	2495	0	14,8,2,2,1	20bs1~rankms=10_rankdc=10_reps=1_srate=1.0_class=AH	198	U	2	2	2016-04-15	2016-09-11	MS    	25	12	Y	-1	21	21	17	-1	-1	24	6	21	4	-1	-1
20bs1	2496	nice	14,8,2,2,1	20bs1~rankms=10_rankdc=10_reps=1_srate=1.0_class=AH	316	U	5	5	2016-04-15	2016-09-11	DC    	20	13	Y	13	-1	-1	18	-1	-1	24	12	3	1	-1	-1
20bs4	2497	0	0	0	194	U	2	2	2016-04-15	2016-09-11	MS    	25	14	U	-1	16	16	5	-1	-1	24	6	17	4	-1	-1
20bs4	2498	0	0	0	424	U	5	5	2016-04-15	2016-09-11	DC    	20	13	U	6	-1	-1	3	-1	-1	24	16	21	1	-1	-1
20bs5	2499	0	4,8,1,2,2	20bs5#rankms=26_rankdc=29_reps=1_srate=1.0_class=AH	13	U	2	2	2016-04-15	2016-09-11	MS    	25	9	U	-1	19	19	10	-1	-1	24	1	13	4	-1	-1
20bs5	2500	nice	4,8,1,2,2	20bs5#rankms=26_rankdc=29_reps=1_srate=1.0_class=AH	309	U	5	5	2016-04-15	2016-09-11	DC    	20	13	Y	11	-1	-1	12	-1	-1	24	11	19	1	-1	-1
20bs6	2501	0	4,0,1,0,0	20bs6#rankms=37_rankdc=51_reps=1_srate=1.0_class=AH	25	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	17	17	11	-1	-1	24	1	25	4	-1	-1
20bs6	2502	0	4,0,1,0,0	20bs6#rankms=37_rankdc=51_reps=1_srate=1.0_class=AH	305	U	5	5	2016-04-15	2016-09-11	DC    	20	13	Y	8	-1	-1	11	-1	-1	24	11	15	1	-1	-1
20bs8	2503	0	4,0,1,0,0	20bs8#rankms=37_rankdc=56_reps=1_srate=0.6_class=AH	197	U	2	2	2016-04-15	2016-09-11	MS    	25	10	U	-1	17	17	11	-1	-1	24	6	20	4	-1	-1
20bs8	2504	0	4,0,1,0,0	20bs8#rankms=37_rankdc=56_reps=1_srate=0.6_class=AH	422	U	5	3	2016-04-15	2016-09-11	DC    	20	12	U	12	-1	-1	14	-1	-1	24	16	19	1	-1	-1
20xbs	2505	0	3,0,0,0,0	20xbs?0_0_0_0_class=ASH	505	U	7	6	2016-04-15	2016-09-11	FDC   	20	10	U	6	-1	-1	3	-1	-1	24	20	9	3	-1	-1
20xbs	2506	2=nice Retained 3	3,0,0,0,0	20xbs?0_0_0_0_class=ASH	521	U	6	6	2016-04-15	2016-09-11	FDC   	20	10	Y	15	-1	-1	16	-1	-1	24	21	8	3	-1	-1
22bg1	2507	0	0	0	151	U	3	3	2016-04-15	2016-09-11	MS    	25	13	U	-1	10	10	2	-1	-1	24	5	21	4	-1	-1
22bg1	2508	0	0	22bg1~rankms=112_rankdc=57_reps=3_srate=0.8_class=ASH	187	U	5	3	2016-04-15	2016-09-11	DC    	20	11	U	13	-1	-1	8	-1	-1	24	6	11	1	-1	-1
22bg1	2509	0	0	22bg1~rankms=112_rankdc=57_reps=3_srate=0.8_class=ASH	241	U	5	4	2016-04-15	2016-09-11	DC    	20	11	U	10	-1	-1	1	-1	-1	24	9	2	1	-1	-1
22bg1	2510	End of Rep 1 DC materials	0	22bg1~rankms=112_rankdc=57_reps=3_srate=0.8_class=ASH	494	U	5	5	2016-04-15	2016-09-11	DC    	20	8	U	7	-1	-1	0	-1	-1	24	20	3	1	-1	-1
22bg10	2511	0	0	0	104	U	3	3	2016-04-15	2016-09-11	MS    	25	14	U	-1	5	5	0	-1	-1	24	4	4	4	-1	-1
22bg10	2512	0	0	0	225	U	5	2	2016-04-15	2016-09-11	DC    	20	12	U	10	-1	-1	1	-1	-1	24	8	12	1	-1	-1
22bg11	2514	0	0	0	94	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	7	7	0	-1	-1	24	3	28	4	-1	-1
22bg11	2515	0	0	0	406	U	5	2	2016-04-15	2016-09-11	DC    	20	12	U	9	-1	-1	0	-1	-1	24	16	3	1	-1	-1
22bg13	2516	0	0	0	150	U	2	2	2016-04-15	2016-09-11	MS    	25	15	U	-1	15	15	6	-1	-1	24	5	20	4	-1	-1
22bg13	2517	0	0	0	233	U	5	1	2016-04-15	2016-09-11	DC    	20	13	U	5	-1	-1	0	-1	-1	24	8	20	1	-1	-1
22bg13	2518	0	0	0	257	U	5	1	2016-04-15	2016-09-11	DC    	20	14	U	4	-1	-1	0	-1	-1	24	9	16	1	-1	-1
22bg2	2519	0	0	0	153	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	5	5	0	-1	-1	24	5	23	4	-1	-1
22bg2	2520	0	0	0	220	U	5	2	2016-04-15	2016-09-11	DC    	20	12	U	4	-1	-1	0	-1	-1	24	8	7	1	-1	-1
22bg3	2521	0	0	0	106	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	12	12	2	-1	-1	24	4	6	4	-1	-1
22bg3	2522	0	0	0	221	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	6	-1	-1	0	-1	-1	24	8	8	1	-1	-1
22bg5	2523	0	0	0	152	U	3	3	2016-04-15	2016-09-11	MS    	25	14	U	-1	15	15	16	-1	-1	24	5	22	4	-1	-1
22bg5	2524	0	0	0	217	U	5	5	2016-04-15	2016-09-11	DC    	20	11	U	4	-1	-1	0	-1	-1	24	8	4	1	-1	-1
22bg5	2525	0	0	0	248	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	1	-1	-1	24	9	7	1	-1	-1
22bg7	2526	edge biased - large clean leaves	4,0,1,0,0	22bg7#rankms=30_rankdc=92_reps=2_srate=0.6_class=ASH	186	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	17	17	6	-1	-1	24	6	10	4	-1	-1
22bg7	2527	0	4,0,1,0,0	22bg7#rankms=30_rankdc=92_reps=2_srate=0.6_class=ASH	204	U	5	2	2016-04-15	2016-09-11	DC    	20	12	Y	7	-1	-1	0	-1	-1	24	7	2	1	-1	-1
22bg7	2528	Was mislabeled as 2bg7 then renamed as 22bg7	4,0,1,0,0	22bg7#rankms=30_rankdc=92_reps=2_srate=0.6_class=ASH	73	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	18	18	9	-1	-1	24	3	7	4	-1	-1
22bg7	2529	0	4,0,1,0,0	22bg7#rankms=30_rankdc=92_reps=2_srate=0.6_class=ASH	254	U	5	4	2016-04-15	2016-09-11	DC    	20	14	U	7	-1	-1	0	-1	-1	24	9	13	1	-1	-1
22bg8	2530	0	4,0,1,0,0	22bg8#rankms=83_rankdc=80_reps=2_srate=0.6_class=ASH	184	U	2	2	2016-04-15	2016-09-11	MS    	25	14	U	-1	13	13	4	-1	-1	24	6	9	4	-1	-1
22bg8	2531	0	4,0,1,0,0	22bg8#rankms=83_rankdc=80_reps=2_srate=0.6_class=ASH	213	U	5	2	2016-04-15	2016-09-11	DC    	20	13	U	7	-1	-1	18	-1	-1	24	7	11	1	-1	-1
22bg8	2532	0	4,0,1,0,0	22bg8#rankms=83_rankdc=80_reps=2_srate=0.6_class=ASH	214	U	5	4	2016-04-15	2016-09-11	DC    	20	11	U	7	-1	-1	0	-1	-1	24	8	1	1	-1	-1
22xbg	2533	Retained 3	0	22xbg?0_0_0_0_class=ASH	498	U	7	5	2016-04-15	2016-09-11	FDC   	20	8	U	6	-1	-1	2	-1	-1	24	20	4	3	-1	-1
22xbg	2534	0	0	22xbg?0_0_0_0_class=ASH	516	U	12	8	2016-04-15	2016-09-11	FDC   	20	9	U	6	-1	-1	6	-1	-1	24	21	3	3	-1	-1
23ba10	2535	2 boles, big	14,8,2,2,4	23ba10~rankms=117_rankdc=37_reps=2_srate=1.0_class=AH	80	U	3	3	2016-04-15	2016-09-11	MS    	25	14	U	-1	8	8	14	-1	-1	24	3	14	4	-1	-1
23ba10	2536	0	14,8,2,2,4	23ba10~rankms=117_rankdc=37_reps=2_srate=1.0_class=AH	367	U	5	5	2016-04-15	2016-09-11	DC    	20	15	Y	11	-1	-1	6	-1	-1	24	14	8	1	-1	-1
23ba10	2537	0	14,8,2,2,4	23ba10~rankms=117_rankdc=37_reps=2_srate=1.0_class=AH	389	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	8	-1	-1	6	-1	-1	24	15	8	1	-1	-1
23ba11	2538	0	0	23ba11~rankms=109_rankdc=17_reps=2_srate=1.0_class=AH	97	U	4	4	2016-04-15	2016-09-11	MS    	25	13	U	-1	10	10	4	-1	-1	24	3	31	4	-1	-1
23ba11	2539	0	0	23ba11~rankms=109_rankdc=17_reps=2_srate=1.0_class=AH	403	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	5	-1	-1	24	15	22	1	-1	-1
23ba11	2540	0	0	23ba11~rankms=109_rankdc=17_reps=2_srate=1.0_class=AH	427	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	16	-1	-1	17	-1	-1	24	17	2	1	-1	-1
23ba15	2541	0	14,4,2,1,0	23ba15~rankms=60_rankdc=4_reps=1_srate=1.0_class=AH	86	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	15	15	5	-1	-1	24	3	20	4	-1	-1
23ba15	2542	Nice, was incorrectly named 2ba15	14,4,2,1,0	23ba15~rankms=60_rankdc=4_reps=1_srate=1.0_class=AH	414	U	5	5	2016-04-15	2016-09-11	DC    	20	13	Y	16	-1	-1	19	-1	-1	24	16	11	1	-1	-1
23ba18	2543	cuttings had 20 ft. of cuttings	14,4,2,0,3	23ba18~rankms=121_rankdc=6_reps=1_srate=1.0_class=AH	95	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	9	9	0	-1	-1	24	3	29	4	-1	-1
23ba18	2544	0	14,4,2,0,3	23ba18~rankms=121_rankdc=6_reps=1_srate=1.0_class=AH	402	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	14	-1	-1	20	-1	-1	24	15	21	1	-1	-1
23ba20	2545	Wavy, nice super thick stem, 2016 FDC selection with 24mm collar. Rooted as a FDC cutting for 2 years.	13,0,0,0,0	23ba20~0_0_0_0_class=AH	495	U	1	1	2016-04-15	2016-09-11	FDC   	20	12	Y	24	-1	-1	7	-1	-1	24	20	3	3	-1	-1
23ba21	2546	Nice straight stem, 2016 FDC selection with 18 mm collar. Rooted as a FDC cutting for 2 years.	13,0,0,0,0	23ba21~0_0_0_0_class=AH	496	U	1	1	2016-04-15	2016-09-11	FDC   	20	12	Y	18	-1	-1	7	-1	-1	24	20	3	3	-1	-1
23ba2	2547	0	4,0,1,0,2	23ba2#rankms=64_rankdc=88_reps=1_srate=0.8_class=AH	20	U	3	3	2016-04-15	2016-09-11	MS    	25	9	U	-1	15	15	2	-1	-1	24	1	20	4	-1	-1
23ba2	2548	all curly	4,0,1,0,2	23ba2#rankms=64_rankdc=88_reps=1_srate=0.8_class=AH	313	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	6	-1	-1	1	-1	-1	24	11	23	1	-1	-1
23ba3	2549	0	0	0	11	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	13	13	4	-1	-1	24	1	11	4	-1	-1
23ba3	2550	0	0	0	277	U	5	4	2016-04-15	2016-09-11	DC    	20	13	U	8	-1	-1	1	-1	-1	24	10	10	1	-1	-1
23ba4	2551	Curvy	0	0	3	U	1	1	2016-04-15	2016-09-11	MS    	25	10	U	-1	12	12	3	-1	-1	24	1	3	4	-1	-1
23ba4	2552	all curly	0	0	306	U	5	5	2016-04-15	2016-09-11	DC    	20	8	U	5	-1	-1	0	-1	-1	24	11	16	1	-1	-1
23ba5	2553	0	4,8,1,1,0	23ba5#rankms=60_rankdc=49_reps=1_srate=1.0_class=AH	14	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	15	15	5	-1	-1	24	1	14	4	-1	-1
23ba5	2554	0	4,8,1,1,0	23ba5#rankms=60_rankdc=49_reps=1_srate=1.0_class=AH	298	U	5	5	2016-04-15	2016-09-11	DC    	20	13	U	9	-1	-1	5	-1	-1	24	11	8	1	-1	-1
23xba	2555	0	9,0,0,0,0	23xba?0_0_0_0_class=AH	5	U	3	3	2016-04-15	2016-09-11	FDC   	20	8	U	-1	9	9	3	-1	-1	24	1	5	4	-1	-1
2b50	2596	0	0	0	311	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	6	-1	-1	4	-1	-1	24	11	21	1	-1	-1
23xba	2556	nice - 1=9cuttings curly, retained 7	9,0,0,0,0	23xba?0_0_0_0_class=AH	497	U	4	4	2016-04-15	2016-09-11	FDC   	20	11	U	9	-1	-1	9	-1	-1	24	20	3	3	-1	-1
23xba	2557	0	9,0,0,0,0	23xba?0_0_0_0_class=AH	506	U	12	10	2016-04-15	2016-09-11	FDC   	20	9	U	8	-1	-1	5	-1	-1	24	20	10	3	-1	-1
23xba	2558	0	9,0,0,0,0	23xba?0_0_0_0_class=AH	522	U	13	10	2016-04-15	2016-09-11	FDC   	20	9	Y	11	-1	-1	30	-1	-1	24	21	9	3	-1	-1
25xr	2559	Rakers seedlngs 6/18/16	177,16,0,0,0	25xr?0_0_0_0_class=H	527	U	118	76	2016-04-15	2016-09-11	SEL   	15	2	Y	6	-1	-1	15	-1	-1	24	22	1	6	-1	-1
25xr	2560	Rakers seedlngs 6/18/16	177,16,0,0,0	25xr?0_0_0_0_class=H	528	U	118	68	2016-04-15	2016-09-11	SEL   	15	2	Y	6	-1	-1	20	-1	-1	24	23	1	6	-1	-1
25xr	2561	Bell Lights - seedling, 4/24, planted 6/15 Leaf issues	177,16,0,0,0	25xr?0_0_0_0_class=H	531	U	5	5	2016-04-15	2016-09-11	SEL   	15	2	U	10	-1	-1	3	-1	-1	24	24	3	6	-1	-1
25xr	2562	Rakers seedlngs 6/18/16 leaf issues	177,16,0,0,0	25xr?0_0_0_0_class=H	535	U	94	49	2016-04-15	2016-09-11	SEL   	15	2	Y	7	-1	-1	23	-1	-1	24	26	2	6	-1	-1
25xr	2563	Rakers seedlngs 6/18/16 leaf issues	177,16,0,0,0	25xr?0_0_0_0_class=H	537	U	94	51	2016-04-15	2016-09-11	SEL   	15	2	Y	7	-1	-1	21	-1	-1	24	27	2	6	-1	-1
2b21	2564	0	14,8,2,4,5	2b21~rankms=42_rankdc=30_reps=3_srate=0.9_class=H	137	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	17	17	8	-1	-1	24	5	7	4	-1	-1
2b21	2565	0	14,8,2,4,5	2b21~rankms=42_rankdc=30_reps=3_srate=0.9_class=H	139	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	15	15	7	-1	-1	24	5	9	4	-1	-1
2b21	2566	0	14,8,2,4,5	2b21~rankms=42_rankdc=30_reps=3_srate=0.9_class=H	329	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	12	-1	-1	11	-1	-1	24	12	16	1	-1	-1
2b21	2567	0	14,8,2,4,5	2b21~rankms=42_rankdc=30_reps=3_srate=0.9_class=H	351	U	5	5	2016-04-15	2016-09-11	DC    	20	11	U	10	-1	-1	4	-1	-1	24	13	15	1	-1	-1
2b21	2568	0	14,8,2,4,5	2b21~rankms=42_rankdc=30_reps=3_srate=0.9_class=H	488	U	5	4	2016-04-15	2016-09-11	DC    	20	8	U	11	-1	-1	4	-1	-1	24	19	20	1	-1	-1
2b22	2569	0	4,8,0,0,0	2b22#rankms=66_rankdc=42_reps=2_srate=0.9_class=H	37	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	13	13	11	-1	-1	24	1	37	4	-1	-1
2b22	2570	0	4,8,0,0,0	2b22#rankms=66_rankdc=42_reps=2_srate=0.9_class=H	68	U	1	1	2016-04-15	2016-09-11	MS    	25	16	U	-1	14	14	5	-1	-1	24	3	2	4	-1	-1
2b22	2571	0	4,8,0,0,0	2b22#rankms=66_rankdc=42_reps=2_srate=0.9_class=H	393	U	5	4	2016-04-15	2016-09-11	DC    	20	15	Y	14	-1	-1	18	-1	-1	24	15	12	1	-1	-1
2b22	2572	0	4,8,0,0,0	2b22#rankms=66_rankdc=42_reps=2_srate=0.9_class=H	478	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	6	-1	-1	0	-1	-1	24	19	10	1	-1	-1
2b24	2573	0	4,8,1,4,3	2b24#rankms=71_rankdc=29_reps=2_srate=0.9_class=H	64	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	11	11	2	-1	-1	24	2	27	4	-1	-1
2b24	2574	0	4,8,1,4,3	2b24#rankms=71_rankdc=29_reps=2_srate=0.9_class=H	141	U	3	3	2016-04-15	2016-09-11	MS    	25	9	U	-1	15	15	14	-1	-1	24	5	11	4	-1	-1
2b24	2575	0	4,8,1,4,3	2b24#rankms=71_rankdc=29_reps=2_srate=0.9_class=H	264	U	5	5	2016-04-15	2016-09-11	DC    	20	10	Y	10	-1	-1	7	-1	-1	24	9	23	1	-1	-1
2b24	2576	0	4,8,1,4,3	2b24#rankms=71_rankdc=29_reps=2_srate=0.9_class=H	344	U	5	4	2016-04-15	2016-09-11	DC    	20	8	Y	13	-1	-1	13	-1	-1	24	13	8	1	-1	-1
2b25	2577	0	28,8,2,4,2	2b25~rankms=22_rankdc=24_reps=2_srate=0.7_class=H	50	U	4	4	2016-04-15	2016-09-11	MS    	25	12	Y	-1	18	18	30	-1	-1	24	2	13	4	-1	-1
2b25	2578	0	28,8,2,4,2	2b25~rankms=22_rankdc=24_reps=2_srate=0.7_class=H	469	U	5	4	2016-04-15	2016-09-11	DC    	20	11	Y	18	-1	-1	18	-1	-1	24	19	1	1	-1	-1
2b25	2579	0	28,8,2,4,2	2b25~rankms=22_rankdc=24_reps=2_srate=0.7_class=H	473	U	5	3	2016-04-15	2016-09-11	DC    	20	11	U	11	-1	-1	5	-1	-1	24	19	5	1	-1	-1
2b29	2580	0	28,8,2,2,7	2b29#rankms=47_rankdc=71_reps=3_srate=0.6_class=H	67	U	4	4	2016-04-15	2016-09-11	MS    	25	12	U	-1	15	15	17	-1	-1	24	3	1	4	-1	-1
2b29	2581	small dia cuttings	28,8,2,2,7	2b29#rankms=47_rankdc=71_reps=3_srate=0.6_class=H	240	U	5	2	2016-04-15	2016-09-11	DC    	20	6	U	13	-1	-1	4	-1	-1	24	9	1	1	-1	-1
2b29	2582	FW?	28,8,2,2,7	2b29#rankms=47_rankdc=71_reps=3_srate=0.6_class=H	325	U	5	4	2016-04-15	2016-09-11	DC    	20	13	U	8	-1	-1	5	-1	-1	24	12	12	1	-1	-1
2b29	2583	0	28,8,2,2,7	2b29#rankms=47_rankdc=71_reps=3_srate=0.6_class=H	452	U	5	3	2016-04-15	2016-09-11	DC    	20	13	U	8	-1	-1	7	-1	-1	24	18	5	1	-1	-1
2b3	2584	0	14,8,2,6,5	2b3~rankms=34_rankdc=19_reps=5_srate=0.9_class=H	63	U	1	1	2016-04-15	2016-09-11	MS    	25	12	U	-1	13	13	5	-1	-1	24	2	26	4	-1	-1
2b3	2585	0	14,8,2,6,5	2b3~rankms=34_rankdc=19_reps=5_srate=0.9_class=H	138	U	4	4	2016-04-15	2016-09-11	MS    	25	12	Y	-1	18	18	25	-1	-1	24	5	8	4	-1	-1
2b3	2586	0	14,8,2,6,5	2b3~rankms=34_rankdc=19_reps=5_srate=0.9_class=H	265	U	5	5	2016-04-15	2016-09-11	DC    	20	11	U	10	-1	-1	7	-1	-1	24	9	24	1	-1	-1
2b3	2587	0	14,8,2,6,5	2b3~rankms=34_rankdc=19_reps=5_srate=0.9_class=H	409	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	4	-1	-1	24	16	6	1	-1	-1
2b3	2588	0	14,8,2,6,5	2b3~rankms=34_rankdc=19_reps=5_srate=0.9_class=H	433	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	10	-1	-1	7	-1	-1	24	17	8	1	-1	-1
2b3	2589	0	14,8,2,6,5	2b3~rankms=34_rankdc=19_reps=5_srate=0.9_class=H	485	U	5	5	2016-04-15	2016-09-11	DC    	20	8	U	8	-1	-1	6	-1	-1	24	19	17	1	-1	-1
2b3	2590	0	14,8,2,6,5	2b3~rankms=34_rankdc=19_reps=5_srate=0.9_class=H	487	U	5	4	2016-04-15	2016-09-11	DC    	20	11	Y	15	-1	-1	16	-1	-1	24	19	19	1	-1	-1
2b4	2591	nice	14,8,2,5,2	2b4#rankms=50_rankdc=31_reps=3_srate=0.8_class=H	29	U	4	4	2016-04-15	2016-09-11	MS    	25	13	U	-1	14	14	25	-1	-1	24	1	29	4	-1	-1
2b4	2592	0	14,8,2,5,2	2b4#rankms=50_rankdc=31_reps=3_srate=0.8_class=H	451	U	5	5	2016-04-15	2016-09-11	DC    	20	13	Y	14	-1	-1	19	-1	-1	24	18	4	1	-1	-1
2b4	2593	Was mislabeled as 2b24	14,8,2,5,2	2b4#rankms=50_rankdc=31_reps=3_srate=0.8_class=H	474	U	5	3	2016-04-15	2016-09-11	DC    	20	12	U	12	-1	-1	9	-1	-1	24	19	6	1	-1	-1
2b4	2594	0	14,8,2,5,2	2b4#rankms=50_rankdc=31_reps=3_srate=0.8_class=H	483	U	5	4	2016-04-15	2016-09-11	DC    	20	11	U	6	-1	-1	5	-1	-1	24	19	15	1	-1	-1
2b50	2595	0	0	0	156	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	15	15	6	-1	-1	24	5	26	4	-1	-1
2b52	2597	nice	14,8,2,3,0	2b52~rankms=20_rankdc=15_reps=2_srate=1.0_class=H	87	U	3	3	2016-04-15	2016-09-11	MS    	25	12	Y	-1	19	19	22	-1	-1	24	3	21	4	-1	-1
2b52	2598	0	14,8,2,3,0	2b52~rankms=20_rankdc=15_reps=2_srate=1.0_class=H	416	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	14	-1	-1	18	-1	-1	24	16	13	1	-1	-1
2b52	2599	0	14,8,2,3,0	2b52~rankms=20_rankdc=15_reps=2_srate=1.0_class=H	440	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	10	-1	-1	5	-1	-1	24	17	15	1	-1	-1
2b55	2600	0	0	2b55~rankms=36_rankdc=20_reps=2_srate=1.0_class=H	149	U	2	2	2016-04-15	2016-09-11	MS    	25	15	U	-1	17	17	12	-1	-1	24	5	19	4	-1	-1
2b55	2601	0	0	2b55~rankms=36_rankdc=20_reps=2_srate=1.0_class=H	212	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	9	-1	-1	8	-1	-1	24	7	10	1	-1	-1
2b55	2602	nice	0	2b55~rankms=36_rankdc=20_reps=2_srate=1.0_class=H	260	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	14	-1	-1	9	-1	-1	24	9	19	1	-1	-1
2b6	2603	nice	14,8,2,12,8	2b6~rankms=52_rankdc=13_reps=6_srate=0.9_class=H	119	U	4	4	2016-04-15	2016-09-11	MS    	25	11	Y	-1	15	15	27	-1	-1	24	4	19	4	-1	-1
2b6	2604	0	14,8,2,12,8	2b6~rankms=52_rankdc=13_reps=6_srate=0.9_class=H	127	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	11	11	6	-1	-1	24	4	27	4	-1	-1
2b6	2605	0	14,8,2,12,8	2b6~rankms=52_rankdc=13_reps=6_srate=0.9_class=H	236	U	5	4	2016-04-15	2016-09-11	DC    	20	11	U	11	-1	-1	6	-1	-1	24	8	23	1	-1	-1
2b6	2606	0	14,8,2,12,8	2b6~rankms=52_rankdc=13_reps=6_srate=0.9_class=H	391	U	5	5	2016-04-15	2016-09-11	DC    	20	11	Y	12	-1	-1	19	-1	-1	24	15	10	1	-1	-1
2b6	2607	0	14,8,2,12,8	2b6~rankms=52_rankdc=13_reps=6_srate=0.9_class=H	412	U	5	3	2016-04-15	2016-09-11	DC    	20	13	U	6	-1	-1	1	-1	-1	24	16	9	1	-1	-1
2b6	2608	0	14,8,2,12,8	2b6~rankms=52_rankdc=13_reps=6_srate=0.9_class=H	490	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	10	-1	-1	8	-1	-1	24	20	1	1	-1	-1
2b6	2609	0	14,8,2,12,8	2b6~rankms=52_rankdc=13_reps=6_srate=0.9_class=H	492	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	11	-1	-1	15	-1	-1	24	20	2	1	-1	-1
2b6	2610	0	14,8,2,12,8	2b6~rankms=52_rankdc=13_reps=6_srate=0.9_class=H	511	U	5	5	2016-04-15	2016-09-11	DC    	20	7	U	10	-1	-1	4	-1	-1	24	21	1	1	-1	-1
2b62	2611	nice	0	2b62#rankms=12_rankdc=35_reps=2_srate=0.8_class=H	56	U	4	4	2016-04-15	2016-09-11	MS    	25	13	Y	-1	20	20	24	-1	-1	24	2	19	4	-1	-1
2b62	2612	0	0	2b62#rankms=12_rankdc=35_reps=2_srate=0.8_class=H	450	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	0	-1	-1	24	18	3	1	-1	-1
2b62	2613	very tall - 12 foot 4 inches	0	2b62#rankms=12_rankdc=35_reps=2_srate=0.8_class=H	472	U	5	4	2016-04-15	2016-09-11	DC    	20	12	Y	17	-1	-1	17	-1	-1	24	19	4	1	-1	-1
2b63	2614	Nice - edge biased - Great stool but poor rooter	4,8,1,2,0	2b63#rankms=1_rankdc=92_reps=2_srate=0.5_class=H	166	U	3	3	2016-04-15	2016-09-11	MS    	25	12	Y	-1	27	27	28	-1	-1	24	5	36	4	-1	-1
2b63	2615	0	4,8,1,2,0	2b63#rankms=1_rankdc=92_reps=2_srate=0.5_class=H	339	U	5	3	2016-04-15	2016-09-11	DC    	20	12	U	5	-1	-1	6	-1	-1	24	13	3	1	-1	-1
2b63	2616	0	4,8,1,2,0	2b63#rankms=1_rankdc=92_reps=2_srate=0.5_class=H	374	U	5	2	2016-04-15	2016-09-11	DC    	20	12	U	10	-1	-1	1	-1	-1	24	14	15	1	-1	-1
2b64	2617	0	0	0	57	U	3	3	2016-04-15	2016-09-11	MS    	25	13	U	-1	13	13	8	-1	-1	24	2	20	4	-1	-1
2b64	2618	0	0	0	324	U	5	5	2016-04-15	2016-09-11	DC    	20	13	U	5	-1	-1	0	-1	-1	24	12	11	1	-1	-1
2b66	2619	0	0,0,1,0,0	2b66#rankms=113_rankdc=38_reps=1_srate=1.0_class=H	71	U	1	1	2016-04-15	2016-09-11	MS    	25	16	U	-1	10	10	0	-1	-1	24	3	5	4	-1	-1
2b66	2620	0	0,0,1,0,0	2b66#rankms=113_rankdc=38_reps=1_srate=1.0_class=H	291	U	5	5	2016-04-15	2016-09-11	DC    	20	13	U	10	-1	-1	6	-1	-1	24	11	1	1	-1	-1
2b67	2621	0	0	0	160	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	17	17	13	-1	-1	24	5	30	4	-1	-1
2b67	2622	0	4,0,1,0,0	2b67#rankms=35_rankdc=74_reps=2_srate=0.6_class=H	287	U	5	2	2016-04-15	2016-09-11	DC    	20	12	U	14	-1	-1	5	-1	-1	24	10	20	1	-1	-1
2b67	2623	0	4,0,1,0,0	2b67#rankms=35_rankdc=74_reps=2_srate=0.6_class=H	338	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	8	-1	-1	2	-1	-1	24	13	2	1	-1	-1
2b68	2624	0	4,8,1,5,0	2b68#rankms=67_rankdc=34_reps=2_srate=0.9_class=H	131	U	3	3	2016-04-15	2016-09-11	MS    	25	13	U	-1	14	14	10	-1	-1	24	5	1	4	-1	-1
2b68	2625	0	4,8,1,5,0	2b68#rankms=67_rankdc=34_reps=2_srate=0.9_class=H	410	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	10	-1	-1	5	-1	-1	24	16	7	1	-1	-1
2b68	2626	0	4,8,1,5,0	2b68#rankms=67_rankdc=34_reps=2_srate=0.9_class=H	435	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	12	-1	-1	11	-1	-1	24	17	10	1	-1	-1
2b7	2627	Small dia = slower?	4,4,1,2,0	2b7#rankms=110_rankdc=25_reps=2_srate=1.0_class=H	55	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	10	10	3	-1	-1	24	2	18	4	-1	-1
2b7	2628	0	4,4,1,2,0	2b7#rankms=110_rankdc=25_reps=2_srate=1.0_class=H	347	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	8	-1	-1	5	-1	-1	24	13	11	1	-1	-1
2b7	2629	nice	4,4,1,2,0	2b7#rankms=110_rankdc=25_reps=2_srate=1.0_class=H	369	U	5	5	2016-04-15	2016-09-11	DC    	20	10	Y	13	-1	-1	17	-1	-1	24	14	10	1	-1	-1
2b71	2630	0	14,4,2,4,4	2b71~rankms=63_rankdc=12_reps=2_srate=0.9_class=H	51	U	3	3	2016-04-15	2016-09-11	MS    	25	13	U	-1	14	14	13	-1	-1	24	2	14	4	-1	-1
2b71	2631	0	14,4,2,4,4	2b71~rankms=63_rankdc=12_reps=2_srate=0.9_class=H	345	U	5	5	2016-04-15	2016-09-11	DC    	20	13	U	13	-1	-1	11	-1	-1	24	13	9	1	-1	-1
2b71	2632	0	14,4,2,4,4	2b71~rankms=63_rankdc=12_reps=2_srate=0.9_class=H	355	U	5	4	2016-04-15	2016-09-11	DC    	20	12	Y	15	-1	-1	10	-1	-1	24	13	19	1	-1	-1
2b80	2633	??? - Unknown clone. very similar to 2b71.  Will name it 2b80. 	4,8,1,2,0	2b80#rankms=28_rankdc=-1reps=1_srate=1.0_class=H	42	U	4	4	2016-04-15	2016-09-11	MS    	25	12	Y	-1	17	17	23	-1	-1	24	2	5	4	-1	-1
2rr11	2634	0	0	0	77	U	2	1	2016-04-15	2016-09-11	MS    	25	10	U	-1	5	5	0	-1	-1	24	3	11	4	-1	-1
2rr11	2635	0	0	0	404	U	5	3	2016-04-15	2016-09-11	DC    	20	9	U	7	-1	-1	0	-1	-1	24	16	1	1	-1	-1
2rr14	2636	weak	0	0	91	U	2	2	2016-04-15	2016-09-11	MS    	25	10	U	-1	8	8	0	-1	-1	24	3	25	4	-1	-1
2rr14	2637	0	0	0	438	U	5	3	2016-04-15	2016-09-11	DC    	20	9	U	5	-1	-1	0	-1	-1	24	17	13	1	-1	-1
2xarw	2638	Bell Lights - seedling	0	0	530	U	2	2	2016-04-15	2016-09-11	SEL   	15	2	U	4	-1	-1	0	-1	-1	24	24	2	6	-1	-1
3aa202	2639	0	2,0,0,0,0	3aa202@rankms=189_rankdc=96_reps=1_srate=0.6_class=A	66	U	1	0	2016-04-15	2016-09-11	MS    	25	10	U	-1	0	0	0	-1	-1	24	2	29	4	-1	-1
3aa202	2640	0	2,0,0,0,0	3aa202@rankms=189_rankdc=96_reps=1_srate=0.6_class=A	368	U	5	3	2016-04-15	2016-09-11	DC    	20	7	U	6	-1	-1	0	-1	-1	24	14	9	1	-1	-1
3bc1	2641	Renamed from 3cagc1 to 3bc1	14,4,2,0,1	3bc1~rankms=45_rankdc=18_reps=2_srate=1.0_class=H	201	U	2	2	2016-04-15	2016-09-11	MS    	25	9	U	-1	16	16	9	-1	-1	24	6	24	4	-1	-1
3bc1	2642	Renamed from 3cagc1 to 3bc1	14,4,2,0,1	3bc1~rankms=45_rankdc=18_reps=2_srate=1.0_class=H	400	U	5	5	2016-04-15	2016-09-11	DC    	20	13	Y	13	-1	-1	17	-1	-1	24	15	19	1	-1	-1
3bc1	2643	Renamed from 3cagc1 to 3bc1	14,4,2,0,1	3bc1~rankms=45_rankdc=18_reps=2_srate=1.0_class=H	420	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	10	-1	-1	4	-1	-1	24	16	17	1	-1	-1
3bc3	2644	Renamed from 3cagc3 to 3bc3	14,0,2,4,0	3bc3~rankms=74_rankdc=24_reps=2_srate=1.0_class=H	192	U	3	3	2016-04-15	2016-09-11	MS    	25	13	U	-1	13	13	13	-1	-1	24	6	15	4	-1	-1
3bc3	2645	Renamed from 3cagc3 to 3bc3	14,0,2,4,0	3bc3~rankms=74_rankdc=24_reps=2_srate=1.0_class=H	442	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	9	-1	-1	9	-1	-1	24	17	17	1	-1	-1
3bc3	2646	Renamed from 3cagc3 to 3bc3	14,0,2,4,0	3bc3~rankms=74_rankdc=24_reps=2_srate=1.0_class=H	445	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	12	-1	-1	14	-1	-1	24	17	20	1	-1	-1
3bc4	2647	Renamed from 3cagc4 to 3bc4	4,4,1,2,4	3bc4#rankms=39_rankdc=43_reps=2_srate=0.9_class=H	188	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	17	17	8	-1	-1	24	6	11	4	-1	-1
3bc4	2648	Renamed from 3cagc4 to 3bc4	4,4,1,2,4	3bc4#rankms=39_rankdc=43_reps=2_srate=0.9_class=H	423	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	9	-1	-1	5	-1	-1	24	16	20	1	-1	-1
3bc4	2649	Renamed from 3cagc4 to 3bc4	4,4,1,2,4	3bc4#rankms=39_rankdc=43_reps=2_srate=0.9_class=H	446	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	10	-1	-1	12	-1	-1	24	17	21	1	-1	-1
3bc5	2650	Renamed from 3cagc5 to 3bc5	4,4,1,3,5	3bc5#rankms=90_rankdc=26_reps=2_srate=1.0_class=H	191	U	3	3	2016-04-15	2016-09-11	MS    	25	14	U	-1	12	12	6	-1	-1	24	6	14	4	-1	-1
3bc5	2651	Renamed from 3cagc5 to 3bc5.  Stems have pronounced leaf flanges.	4,4,1,3,5	3bc5#rankms=90_rankdc=26_reps=2_srate=1.0_class=H	310	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	12	-1	-1	16	-1	-1	24	11	20	1	-1	-1
3bc5	2652	Renamed from 3cagc5 to 3bc5	4,4,1,3,5	3bc5#rankms=90_rankdc=26_reps=2_srate=1.0_class=H	397	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	9	-1	-1	5	-1	-1	24	15	16	1	-1	-1
4ab4	2653	Renamed from 4acag4 to 4ab4	14,8,2,9,0	4ab4~rankms=23_rankdc=14_reps=2_srate=1.0_class=AH	162	U	3	3	2016-04-15	2016-09-11	MS    	25	11	Y	-1	18	18	24	-1	-1	24	5	32	4	-1	-1
4ab4	2654	Renamed from 4acag4 to 4ab4	14,8,2,9,0	4ab4~rankms=23_rankdc=14_reps=2_srate=1.0_class=AH	290	U	5	5	2016-04-15	2016-09-11	DC    	20	10	Y	11	-1	-1	20	-1	-1	24	10	23	1	-1	-1
4ab4	2655	Renamed from 4acag4 to 4ab4	14,8,2,9,0	4ab4~rankms=23_rankdc=14_reps=2_srate=1.0_class=AH	337	U	5	5	2016-04-15	2016-09-11	DC    	20	11	Y	11	-1	-1	14	-1	-1	24	13	1	1	-1	-1
4acag7	2656	0	0	0	165	U	2	2	2016-04-15	2016-09-11	MS    	25	11	Y	-1	17	17	12	-1	-1	24	5	35	4	-1	-1
4acag7	2657	0	0	0	312	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	6	-1	-1	4	-1	-1	24	11	22	1	-1	-1
4acag7	2658	0	0	0	315	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	7	-1	-1	2	-1	-1	24	12	2	1	-1	-1
4ab9	2659	Renamed from 4acag9 to 4ab9	4,8,1,4,3	4ab9#rankms=36_rankdc=54_reps=2_srate=0.9_class=AH	193	U	3	3	2016-04-15	2016-09-11	MS    	25	12	Y	-1	16	16	22	-1	-1	24	6	16	4	-1	-1
4ab9	2660	Renamed from 4acag9 to 4ab9	4,8,1,4,3	4ab9#rankms=36_rankdc=54_reps=2_srate=0.9_class=AH	375	U	5	5	2016-04-15	2016-09-11	DC    	20	13	U	9	-1	-1	8	-1	-1	24	14	16	1	-1	-1
4ab9	2661	Renamed from 4acag9 to 4ab9	4,8,1,4,3	4ab9#rankms=36_rankdc=54_reps=2_srate=0.9_class=AH	444	U	5	4	2016-04-15	2016-09-11	DC    	20	11	U	7	-1	-1	7	-1	-1	24	17	19	1	-1	-1
4gw11	2662	0	4,0,1,0,0	4gw11#rankms=14_rankdc=114_reps=1_srate=0.2_class=H	9	U	2	2	2016-04-15	2016-09-11	MS    	25	9	Y	-1	21	21	12	-1	-1	24	1	9	4	-1	-1
4gw11	2663	0	4,0,1,0,0	4gw11#rankms=14_rankdc=114_reps=1_srate=0.2_class=H	283	U	5	1	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	0	-1	-1	24	10	16	1	-1	-1
4gw13	2664	0	0	0	27	U	2	2	2016-04-15	2016-09-11	MS    	25	11	U	-1	16	16	6	-1	-1	24	1	27	4	-1	-1
4gw13	2665	0	0	0	307	U	5	3	2016-04-15	2016-09-11	DC    	20	10	U	11	-1	-1	3	-1	-1	24	11	17	1	-1	-1
5br3	2666	Renamed from 5cagr3 to 5br3	14,8,2,4,0	5br3~rankms=35_rankdc=40_reps=2_srate=1.0_class=H	129	U	3	3	2016-04-15	2016-09-11	MS    	25	12	Y	-1	17	17	13	-1	-1	24	4	29	4	-1	-1
5br3	2667	Renamed from 5cagr3 to 5br3	14,8,2,4,0	5br3~rankms=35_rankdc=40_reps=2_srate=1.0_class=H	408	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	9	-1	-1	5	-1	-1	24	16	5	1	-1	-1
5br3	2668	Renamed from 5cagr3 to 5br3	14,8,2,4,0	5br3~rankms=35_rankdc=40_reps=2_srate=1.0_class=H	411	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	10	-1	-1	5	-1	-1	24	16	8	1	-1	-1
6ba2	2669	0	4,4,1,2,0	6ba2#rankms=101_rankdc=37_reps=1_srate=1.0_class=AH	17	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	11	11	4	-1	-1	24	1	17	4	-1	-1
6ba2	2670	0	4,4,1,2,0	6ba2#rankms=101_rankdc=37_reps=1_srate=1.0_class=AH	304	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	10	-1	-1	7	-1	-1	24	11	14	1	-1	-1
6xgg	2671	Rakers seedlngs 6/18/16 leaf issues	57,8,0,0,0	6xgg?0_0_0_0_class=N	532	U	102	56	2016-04-15	2016-09-11	SEL   	15	2	U	5	-1	-1	0	-1	-1	24	24	4	6	-1	-1
6xgg	2672	Rakers seedlngs 6/18/16 leaf issues	57,8,0,0,0	6xgg?0_0_0_0_class=N	533	U	102	61	2016-04-15	2016-09-11	SEL   	15	2	U	7	-1	-1	0	-1	-1	24	25	1	6	-1	-1
7bt1	2673	0	14,4,2,3,4	7bt1~rankms=44_rankdc=25_reps=2_srate=0.9_class=ASH	122	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	16	16	12	-1	-1	24	4	22	4	-1	-1
7bt1	2674	0	14,4,2,3,4	7bt1~rankms=44_rankdc=25_reps=2_srate=0.9_class=ASH	357	U	5	4	2016-04-15	2016-09-11	DC    	20	12	Y	15	-1	-1	15	-1	-1	24	13	21	1	-1	-1
7bt1	2675	0	14,4,2,3,4	7bt1~rankms=44_rankdc=25_reps=2_srate=0.9_class=ASH	384	U	5	5	2016-04-15	2016-09-11	DC    	20	11	Y	8	-1	-1	12	-1	-1	24	15	3	1	-1	-1
7bt10	2676	0	0	0	65	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	14	14	4	-1	-1	24	2	28	4	-1	-1
7bt10	2677	0	0	0	333	U	5	2	2016-04-15	2016-09-11	DC    	20	11	U	15	-1	-1	5	-1	-1	24	12	20	1	-1	-1
7bt7	2678	0	4,4,1,0,0	7bt7#rankms=31_rankdc=45_reps=1_srate=0.6_class=ASH	70	U	2	2	2016-04-15	2016-09-11	MS    	25	14	U	-1	18	18	9	-1	-1	24	3	4	4	-1	-1
7bt7	2679	0	4,4,1,0,0	7bt7#rankms=31_rankdc=45_reps=1_srate=0.6_class=ASH	359	U	5	3	2016-04-15	2016-09-11	DC    	20	12	U	15	-1	-1	11	-1	-1	24	13	23	1	-1	-1
7bt9	2680	edge biased	0	0	180	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	16	16	8	-1	-1	24	6	7	4	-1	-1
7bt9	2681	0	0	0	272	U	4	4	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	2	-1	-1	24	10	5	1	-1	-1
7xbt	2682	0	0	7xbt?0_0_0_0_class=ASH	507	U	5	2	2016-04-15	2016-09-11	FDC   	20	10	U	12	-1	-1	2	-1	-1	24	20	11	3	-1	-1
7xbt	2683	2=nice Retained 2	0	7xbt?0_0_0_0_class=ASH	523	U	4	4	2016-04-15	2016-09-11	FDC   	20	11	U	16	-1	-1	12	-1	-1	24	21	10	3	-1	-1
80aa3mf	2684	Curvy	0	80aa3mf@rankms=147_rankdc=82_reps=1_srate=0.8_class=A	6	U	2	1	2016-04-15	2016-09-11	MS    	25	11	U	-1	12	12	2	-1	-1	24	1	6	4	-1	-1
80aa3mf	2685	0	0	80aa3mf@rankms=147_rankdc=82_reps=1_srate=0.8_class=A	284	U	5	4	2016-04-15	2016-09-11	DC    	20	9	U	7	-1	-1	0	-1	-1	24	10	17	1	-1	-1
83aa66	2686	0	0	0	39	U	1	1	2016-04-15	2016-09-11	MS    	25	12	U	-1	12	12	3	-1	-1	24	2	2	4	-1	-1
83aa66	2687	Best AA clone at FBIC	0	0	314	U	5	3	2016-04-15	2016-09-11	DC    	20	9	U	7	-1	-1	7	-1	-1	24	12	1	1	-1	-1
83aa70	2688	0	4,4,1,0,0	83aa70#rankms=42_rankdc=70_reps=1_srate=0.8_class=A	40	U	1	1	2016-04-15	2016-09-11	MS    	25	15	U	-1	17	17	5	-1	-1	24	2	3	4	-1	-1
83aa70	2689	0	4,4,1,0,0	83aa70#rankms=42_rankdc=70_reps=1_srate=0.8_class=A	308	U	5	4	2016-04-15	2016-09-11	DC    	20	15	U	8	-1	-1	7	-1	-1	24	11	18	1	-1	-1
83aa74	2690	0	0	0	41	U	1	1	2016-04-15	2016-09-11	MS    	25	17	U	-1	17	17	5	-1	-1	24	2	4	4	-1	-1
83aa74	2691	0	0	0	285	U	5	1	2016-04-15	2016-09-11	DC    	20	11	U	7	-1	-1	0	-1	-1	24	10	18	1	-1	-1
89aa1	2692	0	0	89aa1#rankms=83_rankdc=84_reps=1_srate=0.4_class=A	76	U	1	1	2016-04-15	2016-09-11	MS    	25	13	U	-1	13	13	4	-1	-1	24	3	10	4	-1	-1
89aa1	2693	0	0	89aa1#rankms=83_rankdc=84_reps=1_srate=0.4_class=A	239	U	5	2	2016-04-15	2016-09-11	DC    	20	10	U	12	-1	-1	4	-1	-1	24	8	26	1	-1	-1
8bg10	2694	0	0	0	59	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	13	13	5	-1	-1	24	2	22	4	-1	-1
8bg10	2695	0	0	0	263	U	5	1	2016-04-15	2016-09-11	DC    	20	13	U	7	-1	-1	0	-1	-1	24	9	22	1	-1	-1
8bg10	2696	0	0	0	267	U	4	2	2016-04-15	2016-09-11	DC    	20	12	U	5	-1	-1	0	-1	-1	24	9	26	1	-1	-1
8bg2	2697	0	14,4,2,0,0	8bg2~rankms=155_rankdc=60_reps=2_srate=0.9_class=ASH	72	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	6	6	0	-1	-1	24	3	6	4	-1	-1
8bg2	2698	0	14,4,2,0,0	8bg2~rankms=155_rankdc=60_reps=2_srate=0.9_class=ASH	238	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	9	-1	-1	9	-1	-1	24	8	25	1	-1	-1
8bg2	2699	0	14,4,2,0,0	8bg2~rankms=155_rankdc=60_reps=2_srate=0.9_class=ASH	370	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	0	-1	-1	24	14	11	1	-1	-1
8bg20	2700	0	0	0	26	U	1	1	2016-04-15	2016-09-11	MS    	25	15	U	-1	11	11	1	-1	-1	24	1	26	4	-1	-1
8bg20	2701	0	0	0	278	U	5	4	2016-04-15	2016-09-11	DC    	20	14	U	6	-1	-1	0	-1	-1	24	10	11	1	-1	-1
8bg21	2702	0	0,0,1,0,0	8bg21#rankms=133_rankdc=80_reps=1_srate=0.8_class=ASH	7	U	1	1	2016-04-15	2016-09-11	MS    	25	16	U	-1	8	8	0	-1	-1	24	1	7	4	-1	-1
8bg21	2703	0	0,0,1,0,0	8bg21#rankms=133_rankdc=80_reps=1_srate=0.8_class=ASH	279	U	5	4	2016-04-15	2016-09-11	DC    	20	14	U	7	-1	-1	4	-1	-1	24	10	12	1	-1	-1
8bg3	2704	ok	14,8,2,3,2	8bg3~rankms=42_rankdc=16_reps=2_srate=0.8_class=ASH	60	U	3	3	2016-04-15	2016-09-11	MS    	25	12	U	-1	16	16	15	-1	-1	24	2	23	4	-1	-1
8bg3	2705	0	14,8,2,3,2	8bg3~rankms=42_rankdc=16_reps=2_srate=0.8_class=ASH	372	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	10	-1	-1	5	-1	-1	24	14	13	1	-1	-1
8bg3	2706	nice - good/big leaves	14,8,2,3,2	8bg3~rankms=42_rankdc=16_reps=2_srate=0.8_class=ASH	385	U	5	4	2016-04-15	2016-09-11	DC    	20	11	Y	19	-1	-1	21	-1	-1	24	15	4	1	-1	-1
8bg4	2707	0	0	0	61	U	3	3	2016-04-15	2016-09-11	MS    	25	11	U	-1	6	6	0	-1	-1	24	2	24	4	-1	-1
8bg4	2708	0	0	0	342	U	5	2	2016-04-15	2016-09-11	DC    	20	14	U	10	-1	-1	1	-1	-1	24	13	6	1	-1	-1
8bg4	2709	0	0	0	363	U	5	2	2016-04-15	2016-09-11	DC    	20	13	U	9	-1	-1	0	-1	-1	24	14	4	1	-1	-1
8bg5	2710	0	0	0	121	U	2	2	2016-04-15	2016-09-11	MS    	25	15	Y	-1	20	20	18	-1	-1	24	4	21	4	-1	-1
8bg5	2711	0	0	0	334	U	5	2	2016-04-15	2016-09-11	DC    	20	13	U	7	-1	-1	0	-1	-1	24	12	21	1	-1	-1
8bg5	2712	0	0	0	394	U	5	4	2016-04-15	2016-09-11	DC    	20	14	U	8	-1	-1	4	-1	-1	24	15	13	1	-1	-1
8bg7	2713	0	0	0	74	U	3	3	2016-04-15	2016-09-11	MS    	25	11	U	-1	8	8	4	-1	-1	24	3	8	4	-1	-1
8bg7	2714	0	0	0	235	U	5	3	2016-04-15	2016-09-11	DC    	20	11	U	5	-1	-1	0	-1	-1	24	8	22	1	-1	-1
8bg7	2715	0	0	0	390	U	5	4	2016-04-15	2016-09-11	DC    	20	9	U	6	-1	-1	0	-1	-1	24	15	9	1	-1	-1
8bg8	2716	0	4,0,1,0,0	8bg8#rankms=60_rankdc=76_reps=2_srate=0.7_class=ASH	125	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	15	15	5	-1	-1	24	4	25	4	-1	-1
8bg8	2717	0	4,0,1,0,0	8bg8#rankms=60_rankdc=76_reps=2_srate=0.7_class=ASH	327	U	5	4	2016-04-15	2016-09-11	DC    	20	14	U	6	-1	-1	0	-1	-1	24	12	14	1	-1	-1
8bg8	2718	0	4,0,1,0,0	8bg8#rankms=60_rankdc=76_reps=2_srate=0.7_class=ASH	358	U	5	3	2016-04-15	2016-09-11	DC    	20	13	U	11	-1	-1	8	-1	-1	24	13	22	1	-1	-1
8bg9	2719	ok - Has same yield as cuttings	14,8,2,4,0	8bg9~rankms=79_rankdc=50_reps=2_srate=0.7_class=ASH	62	U	3	3	2016-04-15	2016-09-11	MS    	25	13	U	-1	12	12	16	-1	-1	24	2	25	4	-1	-1
8bg9	2720	nice - good leaves	14,8,2,4,0	8bg9~rankms=79_rankdc=50_reps=2_srate=0.7_class=ASH	343	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	12	-1	-1	16	-1	-1	24	13	7	1	-1	-1
8bg9	2721	0	14,8,2,4,0	8bg9~rankms=79_rankdc=50_reps=2_srate=0.7_class=ASH	349	U	5	2	2016-04-15	2016-09-11	DC    	20	10	U	9	-1	-1	0	-1	-1	24	13	13	1	-1	-1
8xbg	2722	2=ok	5,0,0,0,0	8xbg?0_0_0_0_class=ASH	509	U	5	5	2016-04-15	2016-09-11	FDC   	20	9	U	5	-1	-1	3	-1	-1	24	20	13	3	-1	-1
8xbg	2723	4=nice	5,0,0,0,0	8xbg?0_0_0_0_class=ASH	525	U	6	6	2016-04-15	2016-09-11	FDC   	20	9	U	11	-1	-1	8	-1	-1	24	21	12	3	-1	-1
92aa11	2724	0	4,8,1,4,0	92aa11#rankms=19_rankdc=6_reps=2_srate=0.8_class=A	128	U	3	3	2016-04-15	2016-09-11	MS    	25	13	Y	-1	20	20	15	-1	-1	24	4	28	4	-1	-1
92aa11	2725	Why is this different than nearby 92aa11	4,8,1,4,0	92aa11#rankms=19_rankdc=6_reps=2_srate=0.8_class=A	432	U	5	3	2016-04-15	2016-09-11	DC    	20	12	U	15	-1	-1	15	-1	-1	24	17	7	1	-1	-1
92aa11	2726	Why is this different than nearby 92aa11	4,8,1,4,0	92aa11#rankms=19_rankdc=6_reps=2_srate=0.8_class=A	434	U	5	5	2016-04-15	2016-09-11	DC    	20	12	Y	15	-1	-1	25	-1	-1	24	17	9	1	-1	-1
93aa11	2727	0	4,0,2,0,4	93aa11#rankms=74_rankdc=66_reps=3_srate=1.0_class=A	45	U	3	3	2016-04-15	2016-09-11	MS    	25	11	U	-1	13	13	13	-1	-1	24	2	8	4	-1	-1
93aa11	2728	0	4,0,2,0,4	93aa11#rankms=74_rankdc=66_reps=3_srate=1.0_class=A	321	U	5	5	2016-04-15	2016-09-11	DC    	20	8	U	8	-1	-1	2	-1	-1	24	12	8	1	-1	-1
93aa11	2729	0	4,0,2,0,4	93aa11#rankms=74_rankdc=66_reps=3_srate=1.0_class=A	331	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	8	-1	-1	5	-1	-1	24	12	18	1	-1	-1
93aa11	2730	0	4,0,2,0,4	93aa11#rankms=74_rankdc=66_reps=3_srate=1.0_class=A	486	U	5	5	2016-04-15	2016-09-11	DC    	20	6	U	4	-1	-1	0	-1	-1	24	19	18	1	-1	-1
95aa11	2731	0	0	0	69	U	3	3	2016-04-15	2016-09-11	MS    	25	11	U	-1	6	6	2	-1	-1	24	3	3	4	-1	-1
95aa11	2732	0	0	0	237	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	7	-1	-1	4	-1	-1	24	8	24	1	-1	-1
97aa11	2733	0	0	0	53	U	2	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	13	13	5	-1	-1	24	2	16	4	-1	-1
97aa11	2734	0	0	0	159	U	1	1	2016-04-15	2016-09-11	MS    	25	10	U	-1	17	17	6	-1	-1	24	5	29	4	-1	-1
97aa11	2735	0	0	0	396	U	5	5	2016-04-15	2016-09-11	DC    	20	10	U	9	-1	-1	4	-1	-1	24	15	15	1	-1	-1
97aa11	2736	0	0	0	471	U	5	5	2016-04-15	2016-09-11	DC    	20	8	Y	13	-1	-1	17	-1	-1	24	19	3	1	-1	-1
97aa12	2737	0	0	0	157	U	2	2	2016-04-15	2016-09-11	MS    	25	12	Y	-1	21	21	16	-1	-1	24	5	27	4	-1	-1
97aa12	2738	0	0	0	289	U	5	4	2016-04-15	2016-09-11	DC    	20	10	U	8	-1	-1	7	-1	-1	24	10	22	1	-1	-1
98aa11	2739	0	4,8,1,2,5	98aa11#rankms=52_rankdc=56_reps=3_srate=0.9_class=A	47	U	3	3	2016-04-15	2016-09-11	MS    	25	11	U	-1	11	11	11	-1	-1	24	2	10	4	-1	-1
98aa11	2740	0	4,8,1,2,5	98aa11#rankms=52_rankdc=56_reps=3_srate=0.9_class=A	164	U	2	2	2016-04-15	2016-09-11	MS    	25	13	U	-1	17	17	12	-1	-1	24	5	34	4	-1	-1
98aa11	2741	0	4,8,1,2,5	98aa11#rankms=52_rankdc=56_reps=3_srate=0.9_class=A	317	U	5	4	2016-04-15	2016-09-11	DC    	20	10	U	10	-1	-1	3	-1	-1	24	12	4	1	-1	-1
98aa11	2742	0	4,8,1,2,5	98aa11#rankms=52_rankdc=56_reps=3_srate=0.9_class=A	322	U	5	5	2016-04-15	2016-09-11	DC    	20	8	U	9	-1	-1	2	-1	-1	24	12	9	1	-1	-1
98aa11	2743	0	4,8,1,2,5	98aa11#rankms=52_rankdc=56_reps=3_srate=0.9_class=A	378	U	5	5	2016-04-15	2016-09-11	DC    	20	13	U	7	-1	-1	1	-1	-1	24	14	19	1	-1	-1
a502	2744	0	10,0,1,0,0	a502@rankms=72_rankdc=93_reps=1_srate=0.4_class=A	54	U	3	3	2016-04-15	2016-09-11	MS    	25	9	U	-1	14	14	5	-1	-1	24	2	17	4	-1	-1
a502	2745	0	10,0,1,0,0	a502@rankms=72_rankdc=93_reps=1_srate=0.4_class=A	470	U	5	2	2016-04-15	2016-09-11	DC    	20	8	U	10	-1	-1	1	-1	-1	24	19	2	1	-1	-1
aa4102	2746	0	12,0,2,0,0	aa4102@rankms=128_rankdc=108_reps=1_srate=0.4_class=A	2	U	3	3	2016-04-15	2016-09-11	MS    	25	9	U	-1	8	8	5	-1	-1	24	1	2	4	-1	-1
aa4102	2747	0	12,0,2,0,0	aa4102@rankms=128_rankdc=108_reps=1_srate=0.4_class=A	274	U	5	2	2016-04-15	2016-09-11	DC    	20	8	U	5	-1	-1	0	-1	-1	24	10	7	1	-1	-1
aag2001	2748	Planting started on 4/15/16. Measuring started on 9/11/16.	4,0,2,0,0	aag2001#0_0_0_0_class=AH	1	U	3	2	2016-04-15	2016-09-11	MS    	25	8	U	-1	15	15	6	-1	-1	24	1	1	4	-1	-1
ae3	2749	edge biased	0	0	170	U	3	3	2016-04-15	2016-09-11	MS    	25	10	U	-1	14	14	11	-1	-1	24	6	2	4	-1	-1
ae3	2750	0	0	0	476	U	5	1	2016-04-15	2016-09-11	DC    	20	8	U	6	-1	-1	0	-1	-1	24	19	8	1	-1	-1
ae3	2751	0	0	0	477	U	5	2	2016-04-15	2016-09-11	DC    	20	8	U	6	-1	-1	0	-1	-1	24	19	9	1	-1	-1
agrr1	2752	double stemmed	12,0,0,0,0	agrr1@rankms=155_rankdc=79_reps=1_srate=0.8_class=H	124	U	1	1	2016-04-15	2016-09-11	MS    	25	18	U	-1	6	6	0	-1	-1	24	4	24	4	-1	-1
agrr1	2753	was row 12 (TEMP) 	12,0,0,0,0	agrr1@rankms=155_rankdc=79_reps=1_srate=0.8_class=H	382	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	5	-1	-1	24	15	1	1	-1	-1
c173	2754	0	30,4,0,0,7	c173@rankms=102_rankdc=79_reps=2_srate=0.9_class=H	36	U	3	2	2016-04-15	2016-09-11	MS    	25	12	U	-1	15	15	10	-1	-1	24	1	36	4	-1	-1
c173	2755	0	30,4,0,0,7	c173@rankms=102_rankdc=79_reps=2_srate=0.9_class=H	463	U	5	5	2016-04-15	2016-09-11	DC    	20	11	U	5	-1	-1	0	-1	-1	24	18	16	1	-1	-1
c173	2756	0	30,4,0,0,7	c173@rankms=102_rankdc=79_reps=2_srate=0.9_class=H	480	U	5	4	2016-04-15	2016-09-11	DC    	20	9	U	9	-1	-1	0	-1	-1	24	19	12	1	-1	-1
cag204	2757	0	26,0,0,0,0	cag204@rankms=129_rankdc=91_reps=4_srate=0.7_class=H	30	U	3	3	2016-04-15	2016-09-11	MS    	25	9	Y	-1	8	8	4	-1	-1	24	1	30	4	-1	-1
cag204	2758	0	26,0,0,0,0	cag204@rankms=129_rankdc=91_reps=4_srate=0.7_class=H	425	U	5	4	2016-04-15	2016-09-11	DC    	20	12	U	6	-1	-1	0	-1	-1	24	16	22	1	-1	-1
cag204	2759	0	26,0,0,0,0	cag204@rankms=129_rankdc=91_reps=4_srate=0.7_class=H	447	U	5	5	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	0	-1	-1	24	17	22	1	-1	-1
cag204	2760	poor	26,0,0,0,0	cag204@rankms=129_rankdc=91_reps=4_srate=0.7_class=H	454	U	5	4	2016-04-15	2016-09-11	DC    	20	8	U	5	-1	-1	0	-1	-1	24	18	7	1	-1	-1
cag204	2761	0	26,0,0,0,0	cag204@rankms=129_rankdc=91_reps=4_srate=0.7_class=H	459	U	5	2	2016-04-15	2016-09-11	DC    	20	5	U	5	-1	-1	0	-1	-1	24	18	12	1	-1	-1
dn34	2762	0	70,16,6,4,16	dn34~rankms=5_rankdc=11_reps=7_srate=0.9_class=C	38	U	8	8	2016-04-15	2016-09-11	MS    	25	9	Y	-1	20	20	45	-1	-1	24	2	1	4	-1	-1
dn34	2763	0	70,16,6,4,16	dn34~rankms=5_rankdc=11_reps=7_srate=0.9_class=C	326	U	5	5	2016-04-15	2016-09-11	DC    	20	8	U	6	-1	-1	1	-1	-1	24	12	13	1	-1	-1
dn34	2764	0	70,16,6,4,16	dn34~rankms=5_rankdc=11_reps=7_srate=0.9_class=C	348	U	5	5	2016-04-15	2016-09-11	DC    	20	9	U	8	-1	-1	2	-1	-1	24	13	12	1	-1	-1
dn34	2765	0	70,16,6,4,16	dn34~rankms=5_rankdc=11_reps=7_srate=0.9_class=C	455	U	5	5	2016-04-15	2016-09-11	DC    	20	8	Y	12	-1	-1	17	-1	-1	24	18	8	1	-1	-1
dn34	2766	0	70,16,6,4,16	dn34~rankms=5_rankdc=11_reps=7_srate=0.9_class=C	457	U	5	5	2016-04-15	2016-09-11	DC    	20	8	Y	15	-1	-1	21	-1	-1	24	18	10	1	-1	-1
dn34	2767	0	70,16,6,4,16	dn34~rankms=5_rankdc=11_reps=7_srate=0.9_class=C	460	U	5	4	2016-04-15	2016-09-11	DC    	20	6	U	11	-1	-1	7	-1	-1	24	18	13	1	-1	-1
dn34	2768	0	70,16,6,4,16	dn34~rankms=5_rankdc=11_reps=7_srate=0.9_class=C	479	U	5	5	2016-04-15	2016-09-11	DC    	20	8	U	9	-1	-1	9	-1	-1	24	19	11	1	-1	-1
dn34	2769	0	70,16,6,4,16	dn34~rankms=5_rankdc=11_reps=7_srate=0.9_class=C	489	U	5	5	2016-04-15	2016-09-11	DC    	20	6	U	4	-1	-1	0	-1	-1	24	19	21	1	-1	-1
gg10	2770	aka e5	0	gg10#0_0_0_0_class=N	540	U	2	2	2016-04-15	2016-09-11	1-1   	50	12	U	-1	7	7	0	-1	-1	24	28	3	7	-1	-1
gg12	2771	Bell Lights - from root sucker	0	gg12#0_0_0_0_class=N	529	U	1	1	2016-04-15	2016-09-11	WASP  	15	2	U	11	-1	-1	1	-1	-1	24	24	1	6	-1	-1
gg12	2772	FW - best 2016 gg growth	0	gg12#0_0_0_0_class=N	541	U	6	4	2016-04-15	2016-09-11	1-1   	50	12	Y	-1	9	9	2	-1	-1	24	28	4	7	-1	-1
gg7	2773	aka e2	0	gg7#0_0_0_0_class=N	538	U	3	3	2016-04-15	2016-09-11	1-1   	50	12	U	-1	6	6	0	-1	-1	24	28	1	7	-1	-1
gg9	2774	aka e3	0	gg9#0_0_0_0_class=N	539	U	1	1	2016-04-15	2016-09-11	1-1   	50	12	U	-1	6	6	0	-1	-1	24	28	2	7	-1	-1
nfa	2775	0	3,0,0,0,0	nfa@rankms=143_rankdc=112_reps=1_srate=0.4_class=A	161	U	3	3	2016-04-15	2016-09-11	MS    	25	9	U	-1	7	7	0	-1	-1	24	5	31	4	-1	-1
nfa	2776	0	3,0,0,0,0	nfa@rankms=143_rankdc=112_reps=1_srate=0.4_class=A	395	U	5	2	2016-04-15	2016-09-11	DC    	20	5	U	4	-1	-1	0	-1	-1	24	15	14	1	-1	-1
plaza	2777	2-1 stock - weak	2,0,0,0,0	plaza@rankms=165_rankdc=103_reps=1_srate=0.6_class=H	79	U	2	2	2016-04-15	2016-09-11	MS    	25	11	U	-1	5	5	0	-1	-1	24	3	13	4	-1	-1
plaza	2778	0	2,0,0,0,0	plaza@rankms=165_rankdc=103_reps=1_srate=0.6_class=H	439	U	5	3	2016-04-15	2016-09-11	DC    	20	8	U	5	-1	-1	0	-1	-1	24	17	14	1	-1	-1
tc72	2779	0	4,0,2,0,0	tc72#rankms=51_rankdc=90_reps=2_srate=0.7_class=A	158	U	2	2	2016-04-15	2016-09-11	MS    	25	12	Y	-1	16	16	4	-1	-1	24	5	28	4	-1	-1
tc72	2780	4=nice	4,0,2,0,0	tc72#rankms=51_rankdc=90_reps=2_srate=0.7_class=A	398	U	5	4	2016-04-15	2016-09-11	DC    	20	10	U	5	-1	-1	4	-1	-1	24	15	17	1	-1	-1
tc72	2781	0	4,0,2,0,0	tc72#rankms=51_rankdc=90_reps=2_srate=0.7_class=A	407	U	5	3	2016-04-15	2016-09-11	DC    	20	12	U	7	-1	-1	1	-1	-1	24	16	4	1	-1	-1
zoss	2782	0	0,0,1,0,0	zoss#rankms=59_rankdc=94_reps=1_srate=0.8_class=H	78	U	3	3	2016-04-15	2016-09-11	MS    	25	11	U	-1	14	14	16	-1	-1	24	3	12	4	-1	-1
zoss	2783	0	0,0,1,0,0	zoss#rankms=59_rankdc=94_reps=1_srate=0.8_class=H	436	U	5	4	2016-04-15	2016-09-11	DC    	20	9	U	5	-1	-1	0	-1	-1	24	17	11	1	-1	-1
100aa11	2784	2017 Nursery Lifting Note Syntax: DOTN, ClassQty, nbr12inchCuttings (eg. DOT1, P3, C10)	100aa11~rankms= -1_rankdc= 67_reps=1_srate=0.50, DOT0, P3, C10	100aa11~rankms=30.0_rankdc=6.9_dcreps=15_dcsrate=0.79_archived=5_field_score=6.88	102	P	14	7	2017-04-17	2017-09-17	DC    	20	11	U	10	-1	0	7	-1	5	28	4	7	3	-1	-1
100aa12	2785	0	100aa12~rankms= -1_rankdc= 56_reps=1_srate=0.71, DOT0, S2, C10	100aa12~rankms=34.9_rankdc=10.5_dcreps=19_dcsrate=0.70_archived=5_field_score=5.84	103	S	14	10	2017-04-17	2017-09-17	DC    	20	12	U	8	-1	0	10	-1	5	28	4	8	3	-1	-1
101aa11	2786	Change from Secondary to Primary class	101aa11~rankms= -1_rankdc= 6_reps=1_srate=1.00	101aa11~rankms=31.0_rankdc=7.8_dcreps=15_dcsrate=0.90_archived=6_field_score=2.70	38	D	4	4	2017-04-17	2017-09-17	DC    	20	12	U	13	-1	0	5	-1	4	28	2	12	2	-1	-1
104aa12	2787	Fastigate form	104aa12~rankms= -1_rankdc= 30_reps=1_srate=0.75 Discarded (grow in 2018 nursery)	104aa12&rankms=33.0_rankdc=7.1_dcreps=9_dcsrate=0.83_archived=1_field_score=1.55	35	S	4	3	2017-04-17	2017-09-17	DC    	20	10	U	12	-1	0	2	-1	5	28	2	10	2	-1	-1
105aa3	2788	0	105aa3~rankms= -1_rankdc= 8_reps=1_srate=1.00 S2, C10	105aa3&rankms=29.4_rankdc=23.8_dcreps=5_dcsrate=0.96_archived=7_field_score=4.46	96	S	14	14	2017-04-17	2017-09-17	DC    	20	11	Y	10	-1	0	24	-1	5	28	4	1	3	-1	-1
105aa5	2789	0	105aa5~rankms= -1_rankdc= 45_reps=1_srate=0.85	105aa5~rankms=32.7_rankdc=19.4_dcreps=5_dcsrate=1.02_archived=5_field_score=4.51	94	D	14	12	2017-04-17	2017-09-17	DC    	20	10	U	9	-1	0	2	-1	3	28	3	14	3	-1	-1
106aa1	2790	0	106aa1~rankms= -1_rankdc= 90_reps=1_srate=0.25	106aa1&rankms=30.7_rankdc=11.7_dcreps=3_dcsrate=0.68_archived=1_field_score=2.10	32	D	4	1	2017-04-17	2017-09-17	DC    	20	11	U	12	-1	0	1	-1	5	28	2	7	2	-1	-1
106aa3	2791	0	106aa3~rankms= -1_rankdc= 64_reps=1_srate=0.75	106aa3&rankms=22.9_rankdc=5.9_dcreps=3_dcsrate=0.58_archived=1_field_score=1.65	33	D	4	3	2017-04-17	2017-09-17	DC    	20	8	U	8	-1	0	0	-1	5	28	2	8	2	-1	-1
106aa6	2792	0	106aa6~rankms= -1_rankdc= 85_reps=1_srate=0.66	0	13	D	1	1	2017-04-17	2017-09-17	MS    	25	17	N	0	-1	13	4	-1	1	28	1	13	1	-1	-1
106aa6	2793	0	106aa6~rankms= 68_rankdc= -1_reps=1_srate=1.00	0	14	D	6	4	2017-04-17	2017-09-17	DC    	20	13	N	6	-1	0	0	-1	1	28	1	14	1	-1	-1
106aa7	2794	0	106aa7~rankms= -1_rankdc= 58_reps=1_srate=0.60	106aa7&rankms=7.0_rankdc=10.0_dcreps=1_dcsrate=0.60_archived=1_field_score=2.20	15	D	5	3	2017-04-17	2017-09-17	DC    	20	10	N	10	-1	0	4	-1	3	28	1	15	1	-1	-1
107aa21	2795	0	107aa21~rankms= -1_rankdc= 42_reps=1_srate=1.00	0	140	D	5	5	2017-04-17	2017-09-17	DC    	20	12	U	8	-1	10	2	-1	5	28	5	21	4	-1	-1
107aa22	2796	0	107aa22~rankms= -1_rankdc= 103_reps=1_srate=0.20	0	141	D	5	1	2017-04-17	2017-09-17	DC    	20	11	U	7	-1	9	0	-1	4	28	5	22	4	-1	-1
107aa7	2797	0	107aa7~rankms= -1_rankdc= 39_reps=1_srate=1.00	107aa7&rankms=24.5_rankdc=17.5_dcreps=2_dcsrate=1.00_archived=1_field_score=1.50	36	D	4	4	2017-04-17	2017-09-17	DC    	20	10	Y	8	-1	0	4	-1	5	28	2	10	2	-1	-1
11ab10	2798	0	11ab10~rankms= -1_rankdc= 24_reps=1_srate=0.71, DOT1, P5, C12	11ab10&rankms=28.8_rankdc=23.2_dcreps=3_dcsrate=0.77_archived=2_field_score=2.50	115	P	14	10	2017-04-17	2017-09-17	DC    	20	10	U	12	-1	0	13	-1	4	28	5	13	3	-1	-1
11ab11	2799	0	11ab11~rankms= -1_rankdc= 59_reps=1_srate=1.00, DOT1	11ab11&rankms=19.7_rankdc=5.2_dcreps=2_dcsrate=0.60_archived=1_field_score=1.60	31	D	4	4	2017-04-17	2017-09-17	DC    	20	7	U	6	-1	0	3	-1	5	28	2	6	2	-1	-1
11ab22	2800	0	11ab22~rankms= -1_rankdc= 10_reps=1_srate=0.78, DOT1, P4, C15	11ab22&rankms=28.5_rankdc=22.2_dcreps=3_dcsrate=0.79_archived=2_field_score=2.75	114	P	14	11	2017-04-17	2017-09-17	DC    	20	10	Y	13	-1	0	20	-1	5	28	5	12	3	-1	-1
11ab3	2801	0	11ab3~rankms= -1_rankdc= 69_reps=1_srate=0.75	11ab3&rankms=21.2_rankdc=7.4_dcreps=3_dcsrate=0.71_archived=1_field_score=1.65	34	D	4	3	2017-04-17	2017-09-17	DC    	20	7	U	7	-1	0	1	-1	5	28	2	9	2	-1	-1
11ab31	2802	0	11ab31~rankms= -1_rankdc= 11_reps=1_srate=1.00, DOT1, R4, C5	0	150	R	5	5	2017-04-17	2017-09-17	DC    	20	14	Y	11	-1	12	5	-1	5	28	6	7	4	-1	-1
14b10	2803	0	14b10~rankms= -1_rankdc= 34_reps=1_srate=1.00, DOT1, P4, C7	14b10~rankms=16.0_rankdc=16.0_dcreps=3_dcsrate=1.00_archived=2_field_score=1.52	101	P	14	14	2017-04-17	2017-09-17	DC    	20	10	Y	8	-1	0	7	-1	5	28	4	6	3	-1	-1
14b11	2804	0	14b11~rankms= -1_rankdc= 78_reps=1_srate=0.75	14b11&rankms=16.3_rankdc=5.4_dcreps=3_dcsrate=0.78_archived=1_field_score=1.55	50	D	4	3	2017-04-17	2017-09-17	DC    	20	9	U	6	-1	0	0	-1	5	28	2	24	2	-1	-1
14b14	2805	0	14b14~rankms= -1_rankdc= 105_reps=1_srate=0.25	14b14&rankms=19.4_rankdc=9.0_dcreps=3_dcsrate=0.30_archived=1_field_score=2.10	48	D	4	1	2017-04-17	2017-09-17	DC    	20	13	U	5	-1	0	0	-1	5	28	2	22	2	-1	-1
14b16	2806	0	14b16~rankms= -1_rankdc= 91_reps=1_srate=0.50, DOT0, P2, C0	14b16~rankms=22.9_rankdc=8.3_dcreps=3_dcsrate=0.83_archived=1_field_score=2.20	40	P	4	2	2017-04-17	2017-09-17	DC    	20	10	U	6	-1	0	0	-1	5	28	2	14	2	-1	-1
14b17	2807	0	14b17~rankms= -1_rankdc= 95_reps=1_srate=0.50	14b17&rankms=23.0_rankdc=7.7_dcreps=3_dcsrate=0.60_archived=1_field_score=1.50	49	D	4	2	2017-04-17	2017-09-17	DC    	20	9	U	5	-1	0	0	-1	5	28	2	23	2	-1	-1
14b18	2808	0	14b18~rankms= -1_rankdc= 43_reps=1_srate=1.00	14b18~rankms=24.5_rankdc=11.6_dcreps=2_dcsrate=0.90_archived=1_field_score=1.95	53	D	4	4	2017-04-17	2017-09-17	DC    	20	14	N	8	-1	0	0	-1	1	28	2	27	2	-1	-1
14b19	2809	0	14b19~rankms= -1_rankdc= 97_reps=1_srate=0.50	14b19&rankms=16.0_rankdc=2.8_dcreps=3_dcsrate=0.50_archived=1_field_score=1.45	54	D	4	2	2017-04-17	2017-09-17	DC    	20	8	N	4	-1	0	0	-1	1	28	2	28	2	-1	-1
14b21	2810	0	14b21~rankms= -1_rankdc= 19_reps=1_srate=0.78, DOT1, P4, C7	14b21~rankms=25.0_rankdc=18.4_dcreps=3_dcsrate=0.86_archived=2_field_score=2.37	104	P	14	11	2017-04-17	2017-09-17	DC    	20	12	U	12	-1	0	8	-1	5	28	4	9	3	-1	-1
14b30	2811	0	14b30~rankms= -1_rankdc= 95_reps=1_srate=0.50	14b30&rankms=12.0_rankdc=7.8_dcreps=2_dcsrate=0.65_archived=1_field_score=1.70	51	D	4	2	2017-04-17	2017-09-17	DC    	20	10	U	5	-1	0	0	-1	4	28	2	25	2	-1	-1
14b31	2812	0	14b31~rankms= -1_rankdc= 41_reps=1_srate=0.71, DOT1, S3, C6	14b31~rankms=8.0_rankdc=20.9_dcreps=2_dcsrate=0.85_archived=2_field_score=1.35	99	S	14	10	2017-04-17	2017-09-17	DC    	20	11	U	11	-1	0	4	-1	5	28	4	4	3	-1	-1
14b4	2813	0	14b4~rankms= -1_rankdc= 87_reps=1_srate=0.75	14b4&rankms=42.0_rankdc=5.5_dcreps=3_dcsrate=0.58_archived=1_field_score=1.70	52	D	4	3	2017-04-17	2017-09-17	DC    	20	12	U	5	-1	0	0	-1	4	28	2	26	2	-1	-1
14b40	2814	Start Rep 4. FDC - 1 MS with 5, 8 inch DC cuttings. Score only DCs.	14b40~rankms= -1_rankdc= 57_reps=1_srate=0.90	0	120	D	10	9	2017-04-17	2017-09-17	DC    	20	14	U	7	-1	0	3	-1	5	28	5	1	4	4	-1
14b41	2815	0	14b41~rankms= -1_rankdc= 57_reps=1_srate=0.90	0	122	D	10	9	2017-04-17	2017-09-17	DC    	20	11	U	7	-1	0	3	-1	5	28	5	3	4	-1	-1
14b6	2816	0	14b6~rankms= -1_rankdc= 83_reps=1_srate=0.50, DOT0, S1, C1	14b6&rankms=13.8_rankdc=8.0_dcreps=2_dcsrate=0.75_archived=1_field_score=1.70	46	S	4	2	2017-04-17	2017-09-17	DC    	20	9	U	8	-1	0	0	-1	5	28	2	20	2	-1	-1
14b61	2817	Nice	14b61~rankms= -1_rankdc= 46_reps=1_srate=1.00, DOT1, R2, C5	14b61~rankms= -1_rankdc= 46_reps=1_srate=1.00	121	R	5	5	2017-04-17	2017-09-17	DC    	20	12	Y	7	-1	0	8	-1	4	28	5	2	4	-1	-1
14b62	2818	0	14b62~rankms= -1_rankdc= 57_reps=1_srate=1.00, DOT0, R2, C6	0	123	R	5	5	2017-04-17	2017-09-17	DC    	20	12	U	6	-1	0	6	-1	5	28	5	4	4	-1	-1
14b7	2819	Qty 9	14b7~rankms= -1_rankdc= 28_reps=2_srate=0.70, DOT1, P6, C13	14b7~rankms=24.0_rankdc=18.8_dcreps=4_dcsrate=0.85_archived=3_field_score=5.45	100	S	9	7	2017-04-17	2017-09-17	DC    	20	11	U	7	-1	0	9	-1	5	28	4	5	3	-1	-1
14b7	2820	8 inches apart - 8 inch DC	14b7~rankms= -1_rankdc= 28_reps=2_srate=0.70, DOT1, P6, C13	14b7~rankms=24.0_rankdc=18.8_dcreps=4_dcsrate=0.85_archived=3_field_score=5.45	203	S	14	9	2017-04-17	2017-09-17	DC    	20	11	U	11	-1	0	23	-1	5	28	10	5	12	-1	-1
15b11	2821	0	15b11~rankms= -1_rankdc= 95_reps=1_srate=0.25	15b11&rankms=22.7_rankdc=5.8_dcreps=3_dcsrate=0.41_archived=1_field_score=1.50	37	D	4	1	2017-04-17	2017-09-17	DC    	20	7	U	10	-1	0	0	-1	5	28	2	11	2	-1	-1
15b14	2822	Start Rep 2: Row 2/Rep 2 Secondary Clones (8 inch DC, 4/clone)	15b14~rankms= -1_rankdc= 123_reps=1_srate=0.00	15b14&rankms=10.2_rankdc=0.0_dcreps=2_dcsrate=0.00_archived=1_field_score=1.50	26	D	4	0	2017-04-17	2017-09-17	DC    	20	12	N	0	-1	0	0	-1	-1	28	2	1	2	2	-1
15b5	2823	slight curl	15b5~rankms= -1_rankdc= 64_reps=1_srate=0.75	15b5&rankms=7.2_rankdc=11.0_dcreps=2_dcsrate=0.87_archived=1_field_score=1.40	29	D	4	3	2017-04-17	2017-09-17	DC    	20	9	U	8	-1	0	0	-1	5	28	2	4	2	-1	-1
15b8	2824	0	15b8~rankms= -1_rankdc= 36_reps=1_srate=0.75, DOT1, S2, C2	15b8&rankms=7.6_rankdc=14.1_dcreps=2_dcsrate=0.87_archived=1_field_score=1.40	27	S	4	3	2017-04-17	2017-09-17	DC    	20	9	U	11	-1	0	3	-1	5	28	2	2	2	-1	-1
16ab1	2825	0	16ab1~rankms= -1_rankdc= 21_reps=1_srate=0.75, DOT0, P3, C7	16ab1~rankms=32.0_rankdc=14.3_dcreps=2_dcsrate=0.87_archived=2_field_score=4.80	28	P	4	3	2017-04-17	2017-09-17	DC    	20	12	U	13	-1	0	3	-1	5	28	2	3	2	-1	-1
16ab21	2826	0	16ab21~rankms= -1_rankdc= 40_reps=1_srate=0.80, DOT0, R3, C4	0	149	R	5	4	2017-04-17	2017-09-17	DC    	20	13	U	10	-1	15	3	-1	5	28	6	6	4	-1	-1
16ab8	2827	0	16ab8~rankms= -1_rankdc= 14_reps=1_srate=0.64, DOT1, P5, C18	16ab8~rankms=19.5_rankdc=25.6_dcreps=2_dcsrate=0.72_archived=3_field_score=5.17	105	P	14	9	2017-04-17	2017-09-17	DC    	20	12	Y	14	-1	0	18	-1	5	28	4	10	3	-1	-1
18bg17	2828	0	18bg17~rankms= -1_rankdc= 105_reps=1_srate=0.25	18bg17~rankms=14.8_rankdc=3.8_dcreps=2_dcsrate=0.52_archived=1_field_score=2.00	25	D	4	1	2017-04-17	2017-09-17	DC    	20	8	U	5	-1	0	0	-1	5	28	1	25	1	-1	-1
18bg19	2829	2 MS	18bg19~rankms= -1_rankdc= 66_reps=1_srate=0.78	18bg19#rankms=16.7_rankdc=10.7_dcreps=2_dcsrate=0.89_archived=2_field_score=0.70	82	D	14	11	2017-04-17	2017-09-17	DC    	20	8	U	7	-1	0	3	-1	5	28	3	2	3	-1	-1
18bg2	2830	Row 3 (2MS front, 14 total)	18bg2~rankms= -1_rankdc= 44_reps=1_srate=0.85, DOT0, P4, C7	18bg2&rankms=19.9_rankdc=14.8_dcreps=2_dcsrate=0.92_archived=2_field_score=0.92	81	S	14	12	2017-04-17	2017-09-17	DC    	20	10	U	9	-1	0	3	-1	5	28	3	1	3	-1	-1
18bg25	2831	0	18bg25~rankms= -1_rankdc= 92_reps=1_srate=0.35	18bg25&rankms=12.1_rankdc=9.3_dcreps=3_dcsrate=0.65_archived=2_field_score=1.55	93	D	14	5	2017-04-17	2017-09-17	DC    	20	8	U	8	-1	0	0	-1	5	28	3	13	3	-1	-1
18bg41	2832	0	18bg41~rankms= -1_rankdc= 108_reps=1_srate=0.20	0	124	D	5	1	2017-04-17	2017-09-17	DC    	20	12	U	5	-1	0	0	-1	3	28	5	5	4	-1	-1
18bg42	2833	0	18bg42~rankms= -1_rankdc= 74_reps=1_srate=1.00	0	125	D	5	5	2017-04-17	2017-09-17	DC    	20	13	U	5	-1	0	0	-1	4	28	5	6	4	-1	-1
18bg43	2834	0	18bg43~rankms= -1_rankdc= 68_reps=1_srate=1.00, DOT0, R1, C5	0	126	R	5	5	2017-04-17	2017-09-17	DC    	20	13	Y	5	-1	18	4	-1	5	28	5	7	4	-1	-1
18bg44	2835	0	18bg44~rankms= -1_rankdc= 74_reps=1_srate=1.00	0	127	D	5	5	2017-04-17	2017-09-17	DC    	20	12	U	5	-1	0	0	-1	5	28	5	8	4	-1	-1
19bg21	2836	Retry - cut back	19bg21~rankms= -1_rankdc= 81_reps=1_srate=0.40, DOT0, R2, C2	0	142	R	5	2	2017-04-17	2017-09-17	DC    	20	12	Y	10	-1	10	2	-1	5	28	5	23	4	-1	-1
19bg22	2837	Nice	19bg22~rankms= -1_rankdc= 104_reps=1_srate=0.20	19bg22~rankms= -1_rankdc= 104_reps=1_srate=0.20	143	D	5	1	2017-04-17	2017-09-17	DC    	20	13	U	6	-1	10	1	-1	5	28	5	24	4	-1	-1
19gb9	2838	0	19gb9~rankms= -1_rankdc= 123_reps=1_srate=0.00	19gb9~rankms=15.4_rankdc=3.2_dcreps=3_dcsrate=0.33_archived=1_field_score=1.30	30	D	4	0	2017-04-17	2017-09-17	DC    	20	7	U	0	-1	0	0	-1	-1	28	2	5	2	-1	-1
1bw6	2839	Nice! Best in 2017!	1bw6~rankms= -1_rankdc= 3_reps=1_srate=1.00, DOT1, P4, C5	1bw6~rankms=29.3_rankdc=18.7_dcreps=4_dcsrate=1.00_archived=4_field_score=5.74	106	P	14	14	2017-04-17	2017-09-17	DC    	20	9	Y	12	-1	0	23	-1	5	28	4	11	3	-1	-1
1xarg	2840	0	1xarg~rankms= 131_rankdc= -1_reps=1_srate=1.00, DOT0, R2, C0	0	20	R	3	3	2017-04-17	2017-09-17	MS    	25	10	U	0	-1	5	0	-1	1	28	1	20	1	-1	-1
20bs1	2841	Dog damaged.	20bs1~rankms= -1_rankdc= 9_reps=1_srate=0.92, DOT1, P4, C20	20bs1~rankms=30.0_rankdc=31.0_dcreps=2_dcsrate=0.96_archived=3_field_score=5.87	85	P	14	13	2017-04-17	2017-09-17	DC    	20	10	Y	11	-1	0	21	-1	5	28	3	5	3	-1	-1
20bs21	2842	0	20bs21~rankms= -1_rankdc= 29_reps=1_srate=1.00	0	151	D	5	5	2017-04-17	2017-09-17	DC    	20	14	U	9	-1	17	4	-1	5	28	6	8	4	-1	-1
20bs22	2843	0	20bs22~rankms= -1_rankdc= 65_reps=1_srate=0.80	0	152	D	5	4	2017-04-17	2017-09-17	DC    	20	13	U	7	-1	12	2	-1	5	28	6	9	4	-1	-1
20bs23	2844	Retry	20bs23~rankms= -1_rankdc= 16_reps=1_srate=1.00, DOT0, R3, C7	0	153	R	5	5	2017-04-17	2017-09-17	DC    	20	13	Y	10	-1	19	6	-1	5	28	6	10	4	-1	-1
20bs5	2845	0	20bs5~rankms= -1_rankdc= 43_reps=1_srate=1.00	20bs5&rankms=21.0_rankdc=15.5_dcreps=2_dcsrate=1.00_archived=1_field_score=1.55	47	D	4	4	2017-04-17	2017-09-17	DC    	20	9	U	8	-1	0	0	-1	4	28	2	21	2	-1	-1
20bs6	2846	0	20bs6~rankms= -1_rankdc= 83_reps=1_srate=0.50	20bs6&rankms=21.0_rankdc=11.5_dcreps=2_dcsrate=0.75_archived=1_field_score=1.40	45	D	4	2	2017-04-17	2017-09-17	DC    	20	6	N	8	-1	0	0	-1	5	28	2	19	2	-1	-1
20bs8	2847	0	20bs8~rankms= -1_rankdc= 17_reps=1_srate=1.00, DOT1, S2, C2	20bs8~rankms=20.1_rankdc=17.6_dcreps=2_dcsrate=0.80_archived=1_field_score=2.15	44	S	4	4	2017-04-17	2017-09-17	DC    	20	9	Y	10	-1	0	4	-1	5	28	2	18	2	-1	-1
22bg1	2848	0	22bg1~rankms= -1_rankdc= 62_reps=1_srate=0.64	22bg1&rankms=10.2_rankdc=10.3_dcreps=4_dcsrate=0.76_archived=2_field_score=1.52	97	D	14	9	2017-04-17	2017-09-17	DC    	20	8	U	9	-1	0	4	-1	5	28	4	2	3	-1	-1
22bg21	2849	0	22bg21~rankms= -1_rankdc= 91_reps=1_srate=0.60, DOT0, R4, C5	0	146	R	5	3	2017-04-17	2017-09-17	DC    	20	9	U	5	-1	5	0	-1	4	28	6	3	4	-1	-1
22bg22	2850	0	22bg22~rankms= -1_rankdc= 64_reps=1_srate=1.00	22bg22~rankms= -1_rankdc= 64_reps=1_srate=1.00	147	D	5	5	2017-04-17	2017-09-17	DC    	20	13	U	6	-1	7	0	-1	5	28	6	4	4	-1	-1
22bg23	2851	0	22bg23~rankms= -1_rankdc= 91_reps=1_srate=0.60	0	148	D	5	3	2017-04-17	2017-09-17	DC    	20	10	U	5	-1	4	0	-1	5	28	6	5	4	-1	-1
22bg7	2852	0	22bg7~rankms= -1_rankdc= 111_reps=1_srate=0.25	22bg7&rankms=19.1_rankdc=3.0_dcreps=3_dcsrate=0.48_archived=1_field_score=1.50	41	D	4	1	2017-04-17	2017-09-17	DC    	20	6	U	3	-1	0	0	-1	3	28	2	15	2	-1	-1
22bg8	2853	0	22bg8~rankms= -1_rankdc= 108_reps=1_srate=0.25	22bg8&rankms=12.2_rankdc=9.1_dcreps=3_dcsrate=0.48_archived=0_field_score=-0.20	43	D	4	1	2017-04-17	2017-09-17	DC    	20	8	N	4	-1	0	0	-1	4	28	2	17	2	-1	-1
23ba10	2854	Dog damaged.	23ba10~rankms= -1_rankdc= 23_reps=1_srate=0.78, DOT1, P3, C7	23ba10~rankms=20.0_rankdc=19.9_dcreps=3_dcsrate=0.92_archived=2_field_score=1.47	98	P	14	11	2017-04-17	2017-09-17	DC    	20	12	Y	10	-1	0	21	-1	5	28	4	3	3	-1	-1
23ba11	2855	Start Rep 3: Primary clones - most wtih 14 DC, some with 1 MS included	23ba11~rankms= -1_rankdc= 76_reps=2_srate=0.72, DOT0, P6, C4	23ba11~rankms=10.6_rankdc=13.8_dcreps=4_dcsrate=0.86_archived=2_field_score=1.67	78	P	9	6	2017-04-17	2017-09-17	DC    	20	10	U	5	-1	0	0	-1	5	28	2	52	3	3	-1
23ba11	2856	2 MS. Dog damaged.	23ba11~rankms= -1_rankdc= 76_reps=2_srate=0.72, DOT0, P6, C4	23ba11~rankms=10.6_rankdc=13.8_dcreps=4_dcsrate=0.86_archived=2_field_score=1.67	84	P	14	11	2017-04-17	2017-09-17	DC    	20	10	U	8	-1	0	1	-1	5	28	3	4	3	-1	-1
23ba15	2857	0	23ba15~rankms= 57_rankdc= -1_reps=1_srate=1.00, DOT2, P4, C7	23ba15~rankms=17.7_rankdc=24.6_dcreps=2_dcsrate=0.96_archived=2_field_score=2.30	18	P	3	3	2017-04-17	2017-09-17	MS    	25	13	U	0	-1	15	8	-1	4	28	1	18	1	-1	-1
23ba15	2858	Dog damaged.	23ba15~rankms= 57_rankdc= -1_reps=1_srate=1.00, DOT2, P4, C7	23ba15~rankms=17.7_rankdc=24.6_dcreps=2_dcsrate=0.96_archived=2_field_score=2.30	83	P	14	13	2017-04-17	2017-09-17	DC    	20	8	U	9	-1	0	6	-1	5	28	3	3	3	-1	-1
23ba18	2859	0	23ba18~rankms= -1_rankdc= 31_reps=1_srate=0.85, DOT1, P5, C10	23ba18~rankms=10.5_rankdc=23.7_dcreps=2_dcsrate=0.92_archived=2_field_score=1.67	86	P	14	12	2017-04-17	2017-09-17	DC    	20	10	U	10	-1	0	5	-1	5	28	3	6	3	-1	-1
23ba2	2860	Cool top curl stems!	23ba2~rankms= -1_rankdc= 52_reps=1_srate=0.50, DOT1, S3, C9	23ba2&rankms=13.5_rankdc=8.1_dcreps=2_dcsrate=0.65_archived=0_field_score=-0.20	42	S	4	2	2017-04-17	2017-09-17	DC    	20	8	Y	13	-1	0	4	-1	5	28	2	16	2	-1	-1
23ba20	2861	13 qty. Cool curly tips.	23ba20~rankms= -1_rankdc= 18_reps=1_srate=0.92, DOT2, R4, C7	23ba20~rankms= -1_rankdc= 18_reps=1_srate=0.92	80	R	13	12	2017-04-17	2017-09-17	DC    	20	13	Y	10	-1	0	11	-1	4	28	2	54	3	-1	-1
23ba21	2862	13 qty	23ba21~rankms= -1_rankdc= 25_reps=1_srate=0.76, DOT1, S3, C5	23ba21~rankms= -1_rankdc= 25_reps=1_srate=0.76	79	S	13	10	2017-04-17	2017-09-17	DC    	20	10	U	12	-1	0	5	-1	4	28	2	53	3	-1	-1
23ba31	2863	Short and curly (straight in 2017)	23ba31~rankms= 94_rankdc= -1_reps=1_srate=1.00	23ba31~rankms= 94_rankdc= -1_reps=1_srate=1.00	16	D	1	1	2017-04-17	2017-09-17	MS    	25	10	N	0	-1	9	0	-1	3	28	1	16	1	-1	-1
23ba31	2864	0	23ba31~rankms= -1_rankdc= 72_reps=1_srate=1.00	23ba31~rankms= -1_rankdc= 72_reps=1_srate=1.00	128	D	5	5	2017-04-17	2017-09-17	DC    	20	13	U	5	-1	12	2	-1	4	28	5	9	4	-1	-1
23ba32	2865	Short and curly (Verify clone)	23ba32~rankms= 80_rankdc= -1_reps=1_srate=1.00, DOT0, R1, C1, Verify clone duplicate	23ba32~rankms= 80_rankdc= -1_reps=1_srate=1.00	17	R	1	1	2017-04-17	2017-09-17	MS    	25	12	U	0	-1	11	1	-1	5	28	1	17	1	-1	-1
23ba32	2866	Very straight, (Verify Clone)	23ba32~rankms= 80_rankdc= -1_reps=1_srate=1.00, DOT0, R2, C5	23ba32~rankms= -1_rankdc= 70_reps=1_srate=0.60	129	R	5	3	2017-04-17	2017-09-17	DC    	20	12	U	8	-1	13	5	-1	4	28	5	10	4	-1	-1
23ba33	2867	0	23ba33~rankms= -1_rankdc= 80_reps=1_srate=1.00, DOT1, R2, C3	23ba33~rankms= -1_rankdc= 80_reps=1_srate=1.00	130	R	5	5	2017-04-17	2017-09-17	DC    	20	12	U	4	-1	17	4	-1	4	28	5	11	4	-1	-1
23ba34	2868	0	23ba34~rankms= -1_rankdc= 59_reps=1_srate=1.00, DOT0, R2,C5	23ba34~rankms= -1_rankdc= 59_reps=1_srate=1.00	131	R	5	5	2017-04-17	2017-09-17	DC    	20	13	U	6	-1	11	3	-1	5	28	5	12	4	-1	-1
23ba35	2869	0	23ba35~rankms= -1_rankdc= 27_reps=1_srate=1.00, DOT1, R2, C4	23ba35~rankms= -1_rankdc= 27_reps=1_srate=1.00	132	R	5	5	2017-04-17	2017-09-17	DC    	20	13	Y	9	-1	13	5	-1	4	28	5	13	4	-1	-1
23ba36	2870	0	23ba36~rankms= -1_rankdc= 31_reps=1_srate=0.80, DOT0, R2, C4	23ba36~rankms= -1_rankdc= 31_reps=1_srate=0.80	133	R	5	4	2017-04-17	2017-09-17	DC    	20	11	U	11	-1	10	2	-1	5	28	5	14	4	-1	-1
23ba37	2871	Nice	23ba37~rankms= -1_rankdc= 22_reps=1_srate=0.80, DOT0, R3, C6	23ba37~rankms= -1_rankdc= 22_reps=1_srate=0.80	134	R	5	4	2017-04-17	2017-09-17	DC    	20	12	Y	11	-1	14	12	-1	5	28	5	15	4	-1	-1
23ba4	2872	0	23ba4~rankms= -1_rankdc= 12_reps=1_srate=1.00, DOT0, R2, C3	23ba4~rankms= -1_rankdc= 12_reps=1_srate=1.00	21	R	1	1	2017-04-17	2017-09-17	MS    	25	14	U	0	-1	9	0	-1	3	28	1	21	1	-1	-1
23ba4	2873	0	23ba4~rankms= 94_rankdc= -1_reps=1_srate=1.00	23ba4~rankms= 94_rankdc= -1_reps=1_srate=1.00	22	D	4	4	2017-04-17	2017-09-17	DC    	20	10	U	11	-1	0	0	-1	4	28	1	22	1	-1	-1
23ba5	2874	0	23ba5~rankms= -1_rankdc= 47_reps=1_srate=0.75	23ba5&rankms=20.0_rankdc=10.7_dcreps=2_dcsrate=0.87_archived=0_field_score=-0.20	39	D	4	3	2017-04-17	2017-09-17	DC    	20	13	U	10	-1	1	0	-1	4	28	2	13	2	-1	-1
25r1	2875	0	25r1~rankms= -1_rankdc= 46_reps=1_srate=1.00, DOT0, R4, C7	25r1~rankms= -1_rankdc= 46_reps=1_srate=1.00	185	R	5	5	2017-04-17	2017-09-17	DC    	20	12	U	7	-1	21	8	-1	4	28	8	14	8	-1	-1
25r10	2876	Nice!	25r10~rankms= -1_rankdc= 7_reps=1_srate=1.00, DOT0, R4, C8, WASP	25r10~rankms= -1_rankdc= 7_reps=1_srate=1.00	187	R	5	5	2017-04-17	2017-09-17	DC    	20	8	Y	11	-1	25	19	-1	4	28	8	16	8	-1	-1
25r11	2877	0	25r11~rankms= -1_rankdc= 48_reps=1_srate=1.00, DOT0, R5, C9	25r11~rankms= -1_rankdc= 48_reps=1_srate=1.00	177	R	5	5	2017-04-17	2017-09-17	DC    	20	9	U	7	-1	15	4	-1	3	28	8	6	8	-1	-1
25r12	2878	0	25r12~rankms= -1_rankdc= 39_reps=1_srate=1.00, DOT0, R4, C7	25r12~rankms= -1_rankdc= 39_reps=1_srate=1.00	179	R	5	5	2017-04-17	2017-09-17	DC    	20	10	U	8	-1	18	4	-1	3	28	8	8	8	-1	-1
25r13	2879	Bad leaves	25r13~rankms= -1_rankdc= 49_reps=1_srate=1.00	25r13~rankms= -1_rankdc= 49_reps=1_srate=1.00	188	D	5	5	2017-04-17	2017-09-17	DC    	20	9	N	7	-1	15	3	-1	1	28	8	17	8	-1	-1
25r14	2880	Bad leaves	25r14~rankms= -1_rankdc= 15_reps=1_srate=1.00, DOT1, R5, C8	25r14~rankms= -1_rankdc= 15_reps=1_srate=1.00	190	R	5	5	2017-04-17	2017-09-17	DC    	20	11	U	10	-1	20	7	-1	5	28	8	19	8	-1	-1
25r15	2881	0	25r15~rankms= -1_rankdc= 96_reps=1_srate=0.20, DOT0, R2, C4	25r15~rankms= -1_rankdc= 96_reps=1_srate=0.20	180	R	5	1	2017-04-17	2017-09-17	DC    	20	9	U	9	-1	15	3	-1	4	28	8	9	8	-1	-1
25r16	2882	25r16 tested with easy spliting grain in 2016	25r16~rankms= -1_rankdc= 53_reps=1_srate=0.80, DOT0, R4, C4	25r16~rankms= -1_rankdc= 53_reps=1_srate=0.80	173	R	5	4	2017-04-17	2017-09-17	DC    	20	10	U	8	-1	18	4	-1	5	28	8	2	8	-1	-1
25r17	2883	0	25r17~rankms= -1_rankdc= 61_reps=1_srate=1.00	25r17~rankms= -1_rankdc= 61_reps=1_srate=1.00	178	D	5	5	2017-04-17	2017-09-17	DC    	20	9	N	6	-1	12	2	-1	1	28	8	7	8	-1	-1
25r18	2884	Bad leaves	25r18~rankms= -1_rankdc= 86_reps=1_srate=0.60	25r18~rankms= -1_rankdc= 86_reps=1_srate=0.60	189	D	5	3	2017-04-17	2017-09-17	DC    	20	9	N	6	-1	13	2	-1	1	28	8	18	8	-1	-1
25r19	2885	Very Sylliptec	25r19~rankms= -1_rankdc= 18_reps=1_srate=0.40, DOT1, R2, C9	25r19~rankms= -1_rankdc= 18_reps=1_srate=0.40	191	R	5	2	2017-04-17	2017-09-17	DC    	20	10	U	22	-1	11	15	-1	3	28	8	20	8	-1	-1
25r2	2886	0	25r2~rankms= -1_rankdc= 20_reps=1_srate=0.80, DOT1, R3, C9	25r2~rankms= -1_rankdc= 20_reps=1_srate=0.80	184	R	5	4	2017-04-17	2017-09-17	DC    	20	10	Y	11	-1	23	13	-1	4	28	8	13	8	-1	-1
25r20	2887	Nice!	25r20~rankms= -1_rankdc= 30_reps=1_srate=0.80, DOT0, R3, C6	25r20~rankms= -1_rankdc= 30_reps=1_srate=0.80	181	R	5	4	2017-04-17	2017-09-17	DC    	20	9	Y	10	-1	16	12	-1	4	28	8	10	8	-1	-1
25r3	2888	0	25r3~rankms= -1_rankdc= 91_reps=1_srate=0.60, R1, C1	25r3~rankms= -1_rankdc= 91_reps=1_srate=0.60	176	R	5	3	2017-04-17	2017-09-17	DC    	20	10	N	5	-1	10	0	-1	3	28	8	5	8	-1	-1
25r4	2889	Nice!	25r4~rankms= -1_rankdc= 5_reps=1_srate=1.00, DOT0, R4, C9, WASP	25r4~rankms= -1_rankdc= 5_reps=1_srate=1.00	175	R	5	5	2017-04-17	2017-09-17	DC    	20	10	Y	12	-1	19	16	-1	5	28	8	4	8	-1	-1
25r5	2890	One 1/2 inch sample displayed figure in 2016. Columns 11-20=South side. Tested as figured in 2016.	25r5~rankms= -1_rankdc= 51_reps=1_srate=0.80, DOT0, R4, C5, WASP	25r5~rankms= -1_rankdc= 51_reps=1_srate=0.80	182	R	5	4	2017-04-17	2017-09-17	DC    	20	10	Y	8	-1	17	8	-1	4	28	8	11	8	-1	-1
25r6	2891	0	25r6~rankms= -1_rankdc= 73_reps=1_srate=0.60, DOT0, R3, C7	25r6~rankms= -1_rankdc= 73_reps=1_srate=0.60	174	R	5	3	2017-04-17	2017-09-17	DC    	20	9	U	8	-1	12	3	-1	5	28	8	3	8	-1	-1
25r7	2892	Dog damaged	25r7~rankms= -1_rankdc= 37_reps=1_srate=1.00, DOT1, R4, C10	25r7~rankms= -1_rankdc= 37_reps=1_srate=1.00	186	R	5	5	2017-04-17	2017-09-17	DC    	20	9	U	7	-1	21	15	-1	3	28	8	15	8	-1	-1
25r8	2893	0	25r8~rankms= -1_rankdc= 48_reps=1_srate=1.00, DOT0, R6, C6	25r8~rankms= -1_rankdc= 48_reps=1_srate=1.00	183	R	5	5	2017-04-17	2017-09-17	DC    	20	9	U	7	-1	13	4	-1	5	28	8	12	8	-1	-1
25r9	2894	Start Rep 8: 20 clone Figured wood rooting test. 1 ortet MS, 7 inch space then 5 8 inches ODC cuttings spaced 2 inches apart then 7 inches. Columns 1-10=North side. (straight clone).	25r9~rankms= -1_rankdc= -1_reps=1_srate=0.60, DOT0, R3, C5	25r9~rankms= -1_rankdc= -1_reps=1_srate=0.60	172	R	5	3	2017-04-17	2017-09-17	ODC   	20	10	U	8	-1	19	5	-1	3	28	8	1	8	8	-1
25xr	2895	Start Rep 5: 1ortet  MS (80 ortets) and 1 lower 8 inches ODC (80 ramets) planted 4 inches apart. (10 yellow tag selections). Counted DC only.  About 94 were carried forward to 2018.	25xr~rankms= -1_rankdc= -1_reps=4_srate=0.39	25xr~rankms= -1_rankdc= -1_reps=4_srate=0.39	154	F	78	62	2017-04-17	2017-09-17	ODC   	20	7	U	7	-1	10	90	-1	-1	28	6	11	5	5	-1
25xr	2896	Rep 5, 1 ortet MS (37 ortets) and 1 lower 8 inches ODC (37 ramets) planted 4 inches apart. Counted DC only.	25xr~rankms= -1_rankdc= -1_reps=1_srate=0.91	25xr~rankms= -1_rankdc= -1_reps=1_srate=0.91	168	F	72	25	2017-04-17	2017-09-17	ODC   	20	5	U	6	-1	11	20	-1	-1	28	7	1	5	-1	-1
25xr	2897	Start Rep 6, 1-0 Ortets with 8 inch stems.	25xr~rankms= -1_rankdc= -1_reps=1_srate=NA	25xr~rankms= -1_rankdc= -1_reps=1_srate=NA	169	F	45	41	2017-04-17	2017-09-17	1-0   	20	5	U	0	-1	9	40	-1	-1	28	7	2	6	6	-1
25xr	2898	Start Rep 7, Misc. ODC (includes Yes/No leaf issue clones)	25xr~rankms= -1_rankdc= -1_reps=1_srate=NA	25xr~rankms= -1_rankdc= -1_reps=1_srate=NA	170	F	9	4	2017-04-17	2017-09-17	ODC   	20	10	U	9	-1	22	9	-1	3	28	7	3	7	7	-1
25xr	2899	Purdue stock root test. Very small diameters.	25xr~rankms= -1_rankdc= -1_reps=1_srate=NA	25xr~rankms= -1_rankdc= -1_reps=1_srate=NA	171	F	6	0	2017-04-17	2017-09-17	ODC   	20	4	U	0	-1	0	0	-1	-1	28	7	4	7	-1	-1
2b21	2900	0	2b21~rankms= -1_rankdc= 88_reps=1_srate=0.50	2b21~rankms=23.5_rankdc=8.0_dcreps=14_dcsrate=0.84_archived=8_field_score=1.09	92	D	14	7	2017-04-17	2017-09-17	DC    	20	10	U	7	-1	0	0	-1	4	28	3	12	3	-1	-1
2b22	2901	0	2b22~rankms= -1_rankdc= 97_reps=1_srate=0.25, DOT0, P1, C0	2b22~rankms=21.5_rankdc=7.9_dcreps=9_dcsrate=0.60_archived=4_field_score=3.41	76	S	4	1	2017-04-17	2017-09-17	DC    	20	11	U	8	-1	0	0	-1	5	28	2	50	2	-1	-1
2b24	2902	0	2b24~rankms= -1_rankdc= 43_reps=1_srate=1.00	2b24~rankms=21.0_rankdc=8.7_dcreps=8_dcsrate=0.77_archived=1_field_score=1.45	75	D	4	4	2017-04-17	2017-09-17	DC    	20	10	U	8	-1	0	0	-1	5	28	2	49	2	-1	-1
2b25	2903	0	2b25~rankms= -1_rankdc= 7_reps=2_srate=0.71, DOT1, P8, C13	2b25~rankms=48.0_rankdc=8.8_dcreps=17_dcsrate=0.54_archived=6_field_score=6.07	89	P	14	9	2017-04-17	2017-09-17	DC    	20	12	U	12	-1	0	6	-1	5	28	3	9	3	-1	-1
2b25	2904	6 inches apart - 8 inch DC	2b25~rankms= -1_rankdc= 7_reps=2_srate=0.71, DOT1, P8, C13	2b25~rankms=48.0_rankdc=8.8_dcreps=17_dcsrate=0.54_archived=6_field_score=6.07	201	P	14	11	2017-04-17	2017-09-17	DC    	20	13	Y	14	-1	0	30	-1	5	28	10	3	12	-1	-1
2b29	2905	0	2b29~rankms= -1_rankdc= 50_reps=2_srate=0.58, DOT0, S6, C9	2b29#rankms=17.2_rankdc=7.8_dcreps=10_dcsrate=0.60_archived=3_field_score=3.17	19	S	2	1	2017-04-17	2017-09-17	MS    	25	13	U	0	-1	5	0	-1	1	28	1	19	1	-1	-1
2b29	2906	0	2b29~rankms= -1_rankdc= 50_reps=2_srate=0.58, DOT0, S6, C9	2b29#rankms=17.2_rankdc=7.8_dcreps=10_dcsrate=0.60_archived=3_field_score=3.17	24	S	13	7	2017-04-17	2017-09-17	DC    	20	11	U	8	-1	0	1	-1	4	28	1	24	1	-1	-1
2b29	2907	10 inches apart - 8 inch DC	2b29~rankms= -1_rankdc= 50_reps=2_srate=0.58, DOT0, S6, C9	2b29#rankms=17.2_rankdc=7.8_dcreps=10_dcsrate=0.60_archived=3_field_score=3.17	205	S	14	9	2017-04-17	2017-09-17	DC    	20	13	U	11	-1	0	15	-1	4	28	10	7	12	-1	-1
2b3	2908	0	2b3~rankms= -1_rankdc= 35_reps=2_srate=0.78, DOT0, R3, C12 FWtests	2b3#rankms=30.5_rankdc=10.1_dcreps=17_dcsrate=0.78_archived=8_field_score=3.82	90	D	14	12	2017-04-17	2017-09-17	DC    	20	12	U	7	-1	0	0	-1	4	28	3	10	3	-1	-1
2b3	2909	9 inches apart - 8 inch DC	2b3~rankms= -1_rankdc= 35_reps=2_srate=0.78, DOT0, R3, C12 FWtests	2b3#rankms=30.5_rankdc=10.1_dcreps=17_dcsrate=0.78_archived=8_field_score=3.82	204	D	14	10	2017-04-17	2017-09-17	DC    	20	11	U	11	-1	0	18	-1	3	28	10	6	12	-1	-1
2b4	2910	0	2b4~rankms= -1_rankdc= 98_reps=1_srate=0.28	2b4~rankms=39.0_rankdc=6.8_dcreps=13_dcsrate=0.56_archived=3_field_score=4.57	95	D	14	4	2017-04-17	2017-09-17	DC    	20	11	U	7	-1	0	0	-1	4	28	3	15	3	-1	-1
2b52	2911	0	2b52~rankms= -1_rankdc= 62_reps=1_srate=0.42	2b52#rankms=41.0_rankdc=16.2_dcreps=4_dcsrate=0.75_archived=2_field_score=1.60	88	D	14	6	2017-04-17	2017-09-17	DC    	20	12	U	13	-1	0	7	-1	4	28	3	8	3	-1	-1
2b55	2912	0	2b55~rankms= -1_rankdc= 77_reps=2_srate=0.41	2b55#rankms=29.0_rankdc=11.0_dcreps=5_dcsrate=0.63_archived=2_field_score=2.30	67	D	4	1	2017-04-17	2017-09-17	DC    	20	9	U	13	-1	0	0	-1	4	28	2	41	2	-1	-1
2b55	2913	0	2b55~rankms= -1_rankdc= 77_reps=2_srate=0.41	2b55#rankms=29.0_rankdc=11.0_dcreps=5_dcsrate=0.63_archived=2_field_score=2.30	116	D	14	8	2017-04-17	2017-09-17	DC    	20	9	U	10	-1	0	2	-1	5	28	5	14	3	-1	-1
2b6	2914	0	2b6~rankms= -1_rankdc= 79_reps=1_srate=0.71, DOT0, S3, C3	2b6#rankms=29.5_rankdc=9.0_dcreps=18_dcsrate=0.72_archived=8_field_score=4.24	91	S	14	10	2017-04-17	2017-09-17	DC    	20	12	U	6	-1	0	2	-1	5	28	3	11	3	-1	-1
2b62	2915	0	2b62~rankms= -1_rankdc= 95_reps=1_srate=0.50	2b62~rankms=44.0_rankdc=11.4_dcreps=4_dcsrate=0.75_archived=2_field_score=2.15	73	D	4	2	2017-04-17	2017-09-17	DC    	20	14	U	5	-1	0	0	-1	4	28	2	47	2	-1	-1
2b63	2916	0	2b63~rankms= -1_rankdc= 89_reps=1_srate=0.25	2b63~rankms=55.0_rankdc=5.1_dcreps=4_dcsrate=0.41_archived=1_field_score=1.85	68	D	4	1	2017-04-17	2017-09-17	DC    	20	12	U	13	-1	0	0	-1	5	28	2	42	2	-1	-1
2b67	2917	0	2b67~rankms= -1_rankdc= 71_reps=1_srate=0.75	2b67~rankms=30.0_rankdc=7.6_dcreps=4_dcsrate=0.63_archived=1_field_score=2.20	69	D	4	3	2017-04-17	2017-09-17	DC    	20	10	U	7	-1	0	0	-1	4	28	2	43	2	-1	-1
2b68	2918	0	2b68~rankms= -1_rankdc= 64_reps=1_srate=0.75	2b68~rankms=24.0_rankdc=12.5_dcreps=4_dcsrate=0.83_archived=2_field_score=2.20	72	D	4	3	2017-04-17	2017-09-17	DC    	20	12	U	8	-1	0	0	-1	5	28	2	46	2	-1	-1
2b7	2919	0	2b7~rankms= -1_rankdc= 97_reps=1_srate=0.50	2b7#rankms=13.0_rankdc=6.8_dcreps=10_dcsrate=0.65_archived=1_field_score=1.50	77	D	4	2	2017-04-17	2017-09-17	DC    	20	13	U	4	-1	0	0	-1	5	28	2	51	2	-1	-1
2b71	2920	End of Rep 3	2b71~rankms= -1_rankdc= 26_reps=1_srate=1.00, DOT1	2b71~rankms=27.0_rankdc=17.0_dcreps=4_dcsrate=0.95_archived=3_field_score=3.50	113	P	14	14	2017-04-17	2017-09-17	DC    	20	10	U	9	-1	0	6	-1	4	28	5	7	3	-1	-1
2b80	2921	0	2b80~rankms= -1_rankdc= 87_reps=1_srate=0.75	2b80#rankms=40.0_rankdc=3.7_dcreps=1_dcsrate=0.75_archived=1_field_score=2.60	70	D	4	3	2017-04-17	2017-09-17	DC    	20	13	U	5	-1	0	0	-1	4	28	2	44	2	-1	-1
2xarw	2922	0	2xarw~rankms= 106_rankdc= -1_reps=1_srate=1.00, DOT1, R1, C0, Needs clone name	2xarw#rankms= 106_rankdc= -1_reps=1_srate=1.00	8	R	1	1	2017-04-17	2017-09-17	MS    	25	4	U	0	-1	8	0	-1	4	28	1	8	1	-1	-1
3aa202	2923	0	3aa202~rankms= 153_rankdc= -1_reps=1_srate=0.50, DOT1, T1, C0	3aa202@rankms= 153_rankdc= -1_reps=1_srate=0.50	12	T	2	1	2017-04-17	2017-09-17	MS    	25	4	U	0	-1	5	0	-1	3	28	1	12	1	-1	-1
3bc1	2924	0	3bc1~rankms= -1_rankdc= 33_reps=1_srate=0.71, DOT0, S3, C7	3bc1#rankms=21.0_rankdc=18.5_dcreps=3_dcsrate=0.90_archived=2_field_score=2.07	87	S	14	10	2017-04-17	2017-09-17	DC    	20	10	U	12	-1	0	3	-1	5	28	3	7	3	-1	-1
3bc3	2925	Dog damaged.	3bc3~rankms= -1_rankdc= 13_reps=1_srate=0.78, DOT1, P5, C18	3bc3~rankms=23.0_rankdc=23.1_dcreps=3_dcsrate=0.92_archived=3_field_score=5.12	112	P	14	11	2017-04-17	2017-09-17	DC    	20	10	U	12	-1	0	16	-1	5	28	5	6	3	-1	-1
3bc4	2926	0	3bc4~rankms= -1_rankdc= 12_reps=1_srate=1.00	3bc4~rankms=21.0_rankdc=15.0_dcreps=3_dcsrate=0.93_archived=1_field_score=2.25	74	D	4	4	2017-04-17	2017-09-17	DC    	20	11	U	11	-1	0	0	-1	5	28	2	48	2	-1	-1
3bc5	2927	The stem buds have small leaves. Change to Primary.	3bc5~rankms= -1_rankdc= 4_reps=1_srate=0.75, DOT1, P2, C12, Bud Leaves WASP!	3bc5~rankms=13.6_rankdc=22.2_dcreps=3_dcsrate=0.91_archived=1_field_score=1.55	71	P	4	3	2017-04-17	2017-09-17	DC    	20	10	Y	17	-1	0	12	-1	5	28	2	45	2	-1	-1
4ab4	2928	0	4ab4~rankms= -1_rankdc= 38_reps=1_srate=0.78, DOT1, S2, C7	4ab4~rankms=42.0_rankdc=14.1_dcreps=6_dcsrate=0.72_archived=4_field_score=4.15	110	S	14	11	2017-04-17	2017-09-17	DC    	20	12	U	9	-1	0	14	-1	4	28	5	4	3	-1	-1
4ab9	2929	0	4ab9~rankms= -1_rankdc= 57_reps=1_srate=0.50, DOT0, S2, C5	4ab9~rankms=24.0_rankdc=12.3_dcreps=3_dcsrate=0.76_archived=3_field_score=3.20	62	S	4	2	2017-04-17	2017-09-17	DC    	20	14	U	13	-1	0	1	-1	4	28	2	36	2	-1	-1
4gw11	2930	0	4gw11~rankms= -1_rankdc= 123_reps=1_srate=0.00	4gw11~rankms=16.4_rankdc=0.7_dcreps=2_dcsrate=0.10_archived=2_field_score=4.60	58	D	4	0	2017-04-17	2017-09-17	DC    	20	6	U	0	-1	0	0	-1	-1	28	2	32	2	-1	-1
5br3	2931	Row 5 - Dog damaged.	5br3~rankms= -1_rankdc= 60_reps=1_srate=0.85	5br3#rankms=30.0_rankdc=10.8_dcreps=4_dcsrate=0.91_archived=2_field_score=1.22	107	D	14	12	2017-04-17	2017-09-17	DC    	20	10	U	7	-1	0	3	-1	4	28	5	1	3	-1	-1
6ba2	2932	0	6ba2~rankms= -1_rankdc= 78_reps=1_srate=0.75	6ba2~rankms=15.0_rankdc=10.7_dcreps=2_dcsrate=0.87_archived=1_field_score=2.35	63	D	4	3	2017-04-17	2017-09-17	DC    	20	9	U	6	-1	0	0	-1	4	28	2	37	2	-1	-1
6xgg	2933	Start Rep 9, 1 ortet MS (8 ortets) and 1 lower 8 inch ODC planted 8 inches apart. (count DC, measure MS) Survived MS=4	6xgg~rankms= -1_rankdc= 113_reps=3_srate=0.03	6xgg~rankms= -1_rankdc= 113_reps=3_srate=0.03	192	F	8	0	2017-04-17	2017-09-17	DC    	20	8	U	0	-1	8	0	-1	1	28	8	21	9	9	-1
6xgg	2934	1 ortet MS planted 4 inches apart. (count DC, measure MS) Survived MS=24	6xgg~rankms= 123_rankdc= -1_reps=1_srate=0.82	6xgg~rankms= 123_rankdc= -1_reps=1_srate=0.82	193	F	26	2	2017-04-17	2017-09-17	DC    	20	8	U	4	-1	8	4	-1	1	28	9	1	9	-1	-1
6xgg	2935	Start Rep 10, 1 med. ortet MS cut to 10 inch stem planted 5 inches apart. Some with 7 inch cuttings. Survived MS=23.	6xgg~rankms= 123_rankdc= -1_reps=1_srate=0.82	6xgg~rankms= 123_rankdc= -1_reps=1_srate=0.82	197	F	26	1	2017-04-17	2017-09-17	DC    	20	8	U	4	-1	7	1	-1	1	28	9	2	10	10	-1
6xgg	2936	Start Rep 11, 1 small ortet MS cut to 8 inch stem planted 4 inches apart. Some DC planted. MS=23	6xgg~rankms= 123_rankdc= -1_reps=1_srate=0.82	6xgg~rankms= 123_rankdc= -1_reps=1_srate=0.82	198	F	40	33	2017-04-17	2017-09-17	MS    	25	3	U	0	-1	7	1	-1	1	28	9	3	11	11	-1
7bt1	2937	0	7bt1~rankms= -1_rankdc= 84_reps=1_srate=0.57	7bt1~rankms=19.3_rankdc=16.9_dcreps=3_dcsrate=0.79_archived=2_field_score=1.87	117	D	14	8	2017-04-17	2017-09-17	DC    	20	10	N	7	-1	0	0	-1	1	28	5	15	3	-1	-1
7bt21	2938	Row 6 - Retry	7bt21~rankms= -1_rankdc= 26_reps=1_srate=1.00, DOT1, R3, C7	7bt21#rankms= -1_rankdc= 26_reps=1_srate=1.00	144	D	5	5	2017-04-17	2017-09-17	DC    	20	13	Y	9	-1	17	6	-1	3	28	6	1	4	-1	-1
7bt22	2939	0	7bt22~rankms= -1_rankdc= 63_reps=1_srate=1.00	0	145	D	5	5	2017-04-17	2017-09-17	DC    	20	14	N	6	-1	8	1	-1	1	28	6	2	4	-1	-1
7bt7	2940	0	7bt7~rankms= -1_rankdc= 64_reps=1_srate=1.00	7bt7~rankms=16.5_rankdc=13.0_dcreps=2_dcsrate=0.80_archived=1_field_score=1.40	65	D	4	4	2017-04-17	2017-09-17	DC    	20	9	N	6	-1	0	0	-1	1	28	2	39	2	-1	-1
83aa70	2941	0	83aa70~rankms= -1_rankdc= 78_reps=1_srate=0.75, DOT0, S2,C0	83aa70~rankms=22.0_rankdc=8.9_dcreps=2_dcsrate=0.77_archived=1_field_score=1.35	64	S	4	3	2017-04-17	2017-09-17	DC    	20	12	U	6	-1	0	0	-1	4	28	2	38	2	-1	-1
8bg2	2942	Dog damaged.	8bg2~rankms= -1_rankdc= 94_reps=1_srate=0.42	0	109	D	14	6	2017-04-17	2017-09-17	DC    	20	8	U	6	-1	0	0	-1	4	28	5	3	3	-1	-1
8bg3	2943	Dog damaged. Nice.	8bg3~rankms= -1_rankdc= 23_reps=1_srate=0.85, DOT1, P6, C10	8bg3~rankms=19.9_rankdc=23.8_dcreps=3_dcsrate=0.81_archived=2_field_score=2.47	119	P	14	12	2017-04-17	2017-09-17	DC    	20	12	Y	10	-1	0	14	-1	4	28	5	17	3	-1	-1
8bg31	2944	0	8bg31~rankms= -1_rankdc= 123_reps=1_srate=0.00	0	135	D	5	0	2017-04-17	2017-09-17	DC    	20	11	U	0	-1	0	0	-1	-1	28	5	16	4	-1	-1
8bg32	2945	0	8bg32~rankms= -1_rankdc= 70_reps=1_srate=1.00, DOT1, R1, C4	8bg32~rankms= -1_rankdc= 70_reps=1_srate=1.00	136	R	5	5	2017-04-17	2017-09-17	DC    	20	12	Y	5	-1	14	3	-1	5	28	5	17	4	-1	-1
8bg33	2946	0	8bg33~rankms= -1_rankdc= 101_reps=1_srate=0.40	0	137	D	5	2	2017-04-17	2017-09-17	DC    	20	12	U	4	-1	9	0	-1	4	28	5	18	4	-1	-1
8bg34	2947	0	8bg34~rankms= -1_rankdc= 80_reps=1_srate=0.40	0	138	D	5	2	2017-04-17	2017-09-17	DC    	20	12	U	11	-1	0	0	-1	4	28	5	19	4	-1	-1
8bg35	2948	Retry	8bg35~rankms= -1_rankdc= 75_reps=1_srate=0.60, DOT1, R3, C4	0	139	R	5	3	2017-04-17	2017-09-17	DC    	20	9	Y	8	-1	9	1	-1	5	28	5	20	4	-1	-1
8bg8	2949	0	8bg8~rankms= -1_rankdc= 105_reps=1_srate=0.25	8bg8#rankms=14.5_rankdc=6.8_dcreps=3_dcsrate=0.55_archived=1_field_score=2.10	66	D	4	1	2017-04-17	2017-09-17	DC    	20	7	N	5	-1	0	0	-1	3	28	2	40	2	-1	-1
8bg9	2950	0	8bg9~rankms= -1_rankdc= 93_reps=1_srate=0.35, DOT0, S2, C2	8bg9#rankms=18.0_rankdc=12.0_dcreps=3_dcsrate=0.58_archived=2_field_score=1.82	118	S	14	5	2017-04-17	2017-09-17	DC    	20	9	U	7	-1	0	2	-1	4	28	5	16	3	-1	-1
92aa11	2951	0	92aa11~rankms= -1_rankdc= 31_reps=1_srate=1.00	92aa11#rankms=35.0_rankdc=9.7_dcreps=13_dcsrate=0.71_archived=3_field_score=2.65	61	D	4	4	2017-04-17	2017-09-17	DC    	20	12	U	9	-1	0	0	-1	5	28	2	35	2	-1	-1
93aa11	2952	dog damage	93aa11~rankms= -1_rankdc= 91_reps=1_srate=0.50	93aa11~rankms=26.0_rankdc=5.5_dcreps=12_dcsrate=0.76_archived=2_field_score=2.42	60	D	4	2	2017-04-17	2017-09-17	DC    	20	12	U	6	-1	0	0	-1	-1	28	2	34	2	-1	-1
98aa11	2953	0	98aa11~rankms= -1_rankdc= 64_reps=1_srate=0.75, DOT0, P2, C1	98aa11~rankms=25.5_rankdc=5.3_dcreps=21_dcsrate=0.76_archived=8_field_score=6.09	59	P	4	3	2017-04-17	2017-09-17	DC    	20	13	U	8	-1	0	0	-1	4	28	2	33	2	-1	-1
a502	2954	0	a502~rankms= 72_rankdc= -1_reps=1_srate=1.00, DOT1, T1, C0	a502@rankms=19.0_rankdc=1.2_dcreps=7_dcsrate=0.43_archived=1_field_score=1.50	10	T	2	2	2017-04-17	2017-09-17	MS    	25	8	U	0	-1	12	7	-1	4	28	1	10	1	-1	-1
a502	2955	0	a502~rankms= 72_rankdc= -1_reps=1_srate=1.00, DOT1, T1, C0	a502@rankms=19.0_rankdc=1.2_dcreps=7_dcsrate=0.43_archived=1_field_score=1.50	11	T	8	3	2017-04-17	2017-09-17	DC    	20	8	U	5	-1	0	0	-1	5	28	1	11	1	-1	-1
aa4102	2956	Start Rep 1: Misc stock such as parents. Planting started on 4/17/17. Measuring started on 9/20/17	aa4102~rankms= 97_rankdc= -1_reps=1_srate=0.66, DOT1	aa4102@rankms=11.7_rankdc=0.5_dcreps=2_dcsrate=0.20_archived=2_field_score=1.02	1	F	3	2	2017-04-17	2017-09-17	MS    	25	5	U	0	-1	13	2	-1	5	28	1	1	1	1	-1
aag2001	2957	0	aag2001~rankms= -1_rankdc= 123_reps=1_srate=0.00	aag2001~rankms=15.9_rankdc=0.0_dcreps=1_dcsrate=0.00_archived=2_field_score=1.72	57	D	4	0	2017-04-17	2017-09-17	DC    	20	9	U	0	-1	0	0	-1	-1	28	2	31	2	-1	-1
ae3	2958	MS	ae3~rankms= -1_rankdc= 102_reps=1_srate=0.14, DOT1, R2, C3	0	3	R	2	2	2017-04-17	2017-09-17	MS    	25	6	U	0	-1	14	5	-1	3	28	1	3	1	-1	-1
ae3	2959	8 in. DC	ae3~rankms= -1_rankdc= 102_reps=1_srate=0.14, DOT1, R2, C3	0	4	R	7	1	2017-04-17	2017-09-17	DC    	20	6	U	10	-1	0	1	-1	3	28	1	4	1	-1	-1
agrr1	2960	0	agrr1~rankms= -1_rankdc= 102_reps=1_srate=0.30, DOT0, F5, C2	agrr1~rankms= -1_rankdc= 102_reps=1_srate=0.30	9	F	10	3	2017-04-17	2017-09-17	DC    	20	8	U	5	-1	0	0	-1	3	28	1	9	1	-1	-1
asp1	2961	6/25 - Cut/planted 6 ASP shoots from stool1. 8/10 - Transplanted outside, heights from 1.5 to 3.5 inches tall. All lignified lower stems. Total of 46 days old with 2 ASP shoot harvests. 	asp1~rankms= -1_rankdc= -1_reps=1_srate=1.00, DOT0, R4, C0	asp1~rankms= -1_rankdc= -1_reps=1_srate=1.00	257	R	6	6	2017-04-17	2017-09-17	ASP   	10	2	U	0	-1	3	0.3	-1	1	28	16	10	15	-1	-1
asp2	2962	8/10/17 - Transplanted one shoot with 12 leaves at 4 inches tall, well lignified. Total of 29 days old with 1 ASP shoot harvest. 	asp2~rankms= -1_rankdc= -1_reps=1_srate=0.25, DOT0, R1, C0	asp1~rankms= -1_rankdc= -1_reps=1_srate=1.00	258	R	4	1	2017-04-17	2017-09-17	ASP   	10	2	U	0	-1	3	0.5	-1	3	28	16	10	15	-1	-1
asp3	2963	7/29 - Started 6 cells of ASP3 shoots - 5 shoots from ASP1, 1 shoot from ASP2. 8/16 - Transplanted 5 ASP3 shoots outside, heights from 2-4 inches tall. Total of 19 days from ASP1 and ASP2 stools, with no pruning. Excellent color and vigor! Probably could have outplanted on 8/13 (16 days after starting). The one shoot that was lignified to begin with died since it had no roots whent the dome was removed. 	asp3~rankms= -1_rankdc= -1_reps=1_srate=1.00, DOT0, R5, C0	asp1~rankms= -1_rankdc= -1_reps=1_srate=1.00	259	R	5	5	2017-04-17	2017-09-17	ASP   	10	2	U	0	-1	3	0.4	-1	4	28	16	10	15	-1	-1
c173	2964	0	c173~rankms= -1_rankdc= 82_reps=2_srate=0.36, DOT1, R5, C8	c173@rankms=11.5_rankdc=6.4_dcreps=5_dcsrate=0.64_archived=3_field_score=2.83	6	T	12	2	2017-04-17	2017-09-17	DC    	20	8	U	8	-1	0	2	-1	4	28	1	6	1	-1	-1
c173	2965	5 inches apart - 8 inch DC	c173~rankms= -1_rankdc= 82_reps=2_srate=0.36, DOT1, R5, C8	c173@rankms=11.5_rankdc=6.4_dcreps=5_dcsrate=0.64_archived=3_field_score=2.83	200	T	14	8	2017-04-17	2017-09-17	DC    	20	12	U	10	-1	0	5	-1	5	28	10	2	12	-1	-1
cag204	2966	0	cag204~rankms= -1_rankdc= 54_reps=2_srate=0.47, DOT0, R5, C3	cag204@rankms=12.0_rankdc=3.3_dcreps=14_dcsrate=0.46_archived=2_field_score=4.70	7	T	6	1	2017-04-17	2017-09-17	DC    	20	8	U	11	-1	0	1	-1	4	28	1	7	1	-1	-1
cag204	2967	7 inches apart - 8 inch DC	dn34~rankms= -1_rankdc= 1_reps=3_srate=0.94, DOT4, R24, C50	cag204@rankms=12.0_rankdc=3.3_dcreps=14_dcsrate=0.46_archived=2_field_score=4.70	202	T	14	11	2017-04-17	2017-09-17	DC    	20	13	U	12	-1	0	11	-1	3	28	10	4	12	-1	-1
dn34	2968	0	gg12~rankms= 164_rankdc= -1_reps=1_srate=0.00, DOT0, T4, C0	dn34@rankms=65.0_rankdc=15.0_dcreps=20_dcsrate=0.88_archived=11_field_score=4.29	108	T	14	14	2017-04-17	2017-09-17	DC    	20	13	Y	14	-1	0	36	-1	4	28	5	2	3	-1	-1
dn34	2969	0	0	dn34@rankms=65.0_rankdc=15.0_dcreps=20_dcsrate=0.88_archived=11_field_score=4.29	111	T	14	13	2017-04-17	2017-09-17	DC    	20	12	U	10	-1	0	15	-1	3	28	5	5	3	-1	-1
dn34	2970	Start Rep 12, 4 inches apart - 8 inch DC Control or Parent clones	0	dn34@rankms=65.0_rankdc=15.0_dcreps=20_dcsrate=0.88_archived=11_field_score=4.29	199	T	14	13	2017-04-17	2017-09-17	DC    	20	13	Y	15	-1	0	48	-1	3	28	10	1	12	12	-1
gg12	2971	Started weak, then died	0	tc72@rankms=20.0_rankdc=5.6_dcreps=4_dcsrate=0.75_archived=2_field_score=1.20	23	T	6	0	2017-04-17	2017-09-17	MS    	25	5	U	0	-1	0	0	-1	5	28	1	23	1	-1	-1
nfa	2972	0	nfa@rankms= 112_rankdc= -1_reps=1_srate=1.00, DOT1, T0, C0	nfa@rankms= 112_rankdc= -1_reps=1_srate=1.00	5	T	2	2	2017-04-17	2017-09-17	MS    	25	8	U	0	-1	7	0	-1	4	28	1	5	1	-1	-1
plaza	2973	0	plaza@rankms= 149_rankdc= -1_reps=1_srate=0.50	plaza@rankms= 149_rankdc= -1_reps=1_srate=0.50	2	D	2	1	2017-04-17	2017-09-17	MS    	25	6	U	0	-1	6	0	-1	4	28	1	2	1	-1	-1
stool1	2974	Start Rep 15 Rootlings – 5/20/17 - Planted rootlings. 6/17 - transplanted to a 9 cell tray. 6/25 7 of 10 rootlings survived with 2 inches growth. 7/23 transplanted 3 stools outside. 	stool1~rankms= -1_rankdc= -1_reps=1_srate=0.50, DOT0, R2, C0	stool1~rankms= -1_rankdc= -1_reps=1_srate=0.50	256	F	4	2	2017-04-17	2017-09-17	RTL   	10	2	U	0	-1	3	0.5	-1	3	28	16	9	15	15	-1
tc72	2975	0	tc72#rankms= -1_rankdc= 64_reps=1_srate=1.00	tc72#rankms= -1_rankdc= 64_reps=1_srate=1.00	56	D	4	4	2017-04-17	2017-09-17	DC    	20	10	U	6	-1	0	0	-1	3	28	2	30	2	-1	-1
te1	2976	Start Rep 13, TxE from WY – Control-StemPlantedVerticle-NoPruning # stem=12 inches, angle=90, tipLength=0,LatCnt/Ln=4,3. Real whip height in feet.	te1~rankms= -1_rankdc= -1_reps=1_srate=1.00	te1~rankms= -1_rankdc= -1_reps=1_srate=1.00	206	D	1	1	2017-04-17	2017-09-17	1-0   	30	4	U	0	-1	16	7	-1	3	28	10	1	13	13	1
te10	2977	Control-StemPlantedVerticle-CutTip # stem=12 inches, angle=90, tipLength=2,LatCnt/Ln=2,5	te10~rankms= -1_rankdc= -1_reps=1_srate=1.00, F1	te10~rankms= -1_rankdc= -1_reps=1_srate=1.00	213	F	1	1	2017-04-17	2017-09-17	1-0   	30	4	Y	0	-1	21	8	-1	3	28	10	2	13	-1	2
te11	2978	Control-StemPlantedVerticle-CutTip # stem=12 inches, angle=90, tipLength=2,LatCnt/Ln=2,6	te11~rankms= -1_rankdc= -1_reps=1_srate=1.00, F1	te11~rankms= -1_rankdc= -1_reps=1_srate=1.00	214	F	1	1	2017-04-17	2017-09-17	1-0   	30	4	Y	0	-1	18	7	-1	3	28	10	2	13	-1	2
te12	2979	Control-StemPlantedVerticle-CutTip # stem=12 inches, angle=90, tipLength=2,LatCnt/Ln=2,7	te12~rankms= -1_rankdc= -1_reps=1_srate=1.00, RL test	te12~rankms= -1_rankdc= -1_reps=1_srate=1.00	215	D	1	1	2017-04-17	2017-09-17	1-0   	30	4	U	0	-1	14	7	-1	1	28	10	2	13	-1	2
te13	2980	Control-StemPlantedVerticle-CutTip # stem=12 inches, angle=90, tipLength=2,LatCnt/Ln=2,8	te13~rankms= -1_rankdc= -1_reps=1_srate=1.00, F1	te13~rankms= -1_rankdc= -1_reps=1_srate=1.00	216	F	1	1	2017-04-17	2017-09-17	1-0   	30	4	U	0	-1	19	7	-1	3	28	10	2	13	-1	2
te14	2981	Control-StemPlantedVerticle-CutTip # stem=12 inches, angle=90, tipLength=2,LatCnt/Ln=2,9	te14~rankms= -1_rankdc= -1_reps=1_srate=1.00, F1	te14~rankms= -1_rankdc= -1_reps=1_srate=1.00	217	F	1	1	2017-04-17	2017-09-17	1-0   	30	4	U	0	-1	12	5	-1	3	28	10	2	13	-1	2
te15	2982	Start Rep 14, TxE from WY – Control-FlatStem-NoPruning # stem=14 inches, angle=0, tipLength=0,LatCnt/Ln=3,2 # PlantableShoots=4	te15~rankms= -1_rankdc= -1_reps=1_srate=5.00, ShootQty5, PlantableShootQty4	te15~rankms= -1_rankdc= -1_reps=1_srate=5.00	220	F	1	4	2017-04-17	2017-09-17	1-0   	36	4	Y	0	-1	8	19	-1	3	28	11	3	14	14	3
te16	2983	Control-FlatStem-NoPruning # stem=14 inches, angle=0, tipLength=0,LatCnt/Ln=3,3	te16~rankms= -1_rankdc= -1_reps=1_srate=3.00, SQ3, PSQ3	te16~rankms= -1_rankdc= -1_reps=1_srate=3.00	221	F	1	3	2017-04-17	2017-09-17	1-0   	36	4	U	0	-1	12	19	-1	1	28	11	3	14	-1	3
te17	2984	Control-FlatStem-NoPruning # stem=14 inches, angle=0, tipLength=0,LatCnt/Ln=3,4	te17~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ2, PSQ2	te17~rankms= -1_rankdc= -1_reps=1_srate=2.00	222	F	1	2	2017-04-17	2017-09-17	1-0   	36	4	U	0	-1	12	10	-1	3	28	11	3	14	-1	3
te18	2985	Control-FlatStem-NoPruning # stem=14 inches, angle=0, tipLength=0,LatCnt/Ln=3,5	te18~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ3, PSQ2	te18~rankms= -1_rankdc= -1_reps=1_srate=2.00	223	F	1	2	2017-04-17	2017-09-17	1-0   	36	4	U	0	-1	8	8	-1	1	28	11	3	14	-1	3
te19	2986	Control-FlatStem-NoPruning # stem=14 inches, angle=0, tipLength=0,LatCnt/Ln=3,6	te19~rankms= -1_rankdc= -1_reps=1_srate=3.00, SQ5, PSQ3	te19~rankms= -1_rankdc= -1_reps=1_srate=3.00	224	F	1	3	2017-04-17	2017-09-17	1-0   	36	4	U	0	-1	14	16	-1	3	28	11	3	14	-1	3
te2	2987	Control-StemPlantedVerticle-NoPruning # stem=12 inches, angle=90, tipLength=0,LatCnt/Ln=4,4	te2~rankms= -1_rankdc= -1_reps=1_srate=1.00, F1	te2~rankms= -1_rankdc= -1_reps=1_srate=1.00	207	F	1	1	2017-04-17	2017-09-17	1-0   	30	4	U	0	-1	14	6	-1	3	28	10	1	13	-1	1
te20	2988	Control-FlatStem-NoPruning # stem=14 inches, angle=0, tipLength=0,LatCnt/Ln=3,7	te20~rankms= -1_rankdc= -1_reps=1_srate=4.00, SQ4, PSQ4	te20~rankms= -1_rankdc= -1_reps=1_srate=4.00	225	F	1	4	2017-04-17	2017-09-17	1-0   	36	4	U	0	-1	5	10	-1	1	28	11	3	14	-1	3
te21	2989	Control-AngledStem-NoPruning # stem=15 inches, angle=45, tipLength=0,LatCnt/Ln=4,2	te21~rankms= -1_rankdc= -1_reps=1_srate=4.00, SQ4, PSQ3	te21~rankms= -1_rankdc= -1_reps=1_srate=4.00	226	F	1	3	2017-04-17	2017-09-17	1-0   	38	4	U	0	-1	7	10	-1	3	28	11	4	14	-1	4
te22	2990	Control-AngledStem-NoPruning # stem=15 inches, angle=45, tipLength=0,LatCnt/Ln=4,3	te22~rankms= -1_rankdc= -1_reps=1_srate=4.00, SQ4, PSQ3	te22~rankms= -1_rankdc= -1_reps=1_srate=4.00	227	F	1	3	2017-04-17	2017-09-17	1-0   	38	4	U	0	-1	10	13	-1	3	28	11	4	14	-1	4
te23	2991	Control-AngledStem-NoPruning # stem=15 inches, angle=45, tipLength=0,LatCnt/Ln=4,4	te23~rankms= -1_rankdc= -1_reps=1_srate=3.00, SQ3, PSQ3	te23~rankms= -1_rankdc= -1_reps=1_srate=3.00	228	F	1	3	2017-04-17	2017-09-17	1-0   	38	4	U	0	-1	9	14	-1	1	28	11	4	14	-1	4
te24	2992	Control-AngledStem-NoPruning # stem=15 inches, angle=45, tipLength=0,LatCnt/Ln=4,5	te24~rankms= -1_rankdc= -1_reps=1_srate=3.00, SQ3, PSQ3	te24~rankms= -1_rankdc= -1_reps=1_srate=3.00	229	F	1	3	2017-04-17	2017-09-17	1-0   	38	4	U	0	-1	8	12	-1	1	28	11	4	14	-1	4
te25	2993	Control-AngledStem-NoPruning # stem=15 inches, angle=45, tipLength=0,LatCnt/Ln=4,6	te25~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ2, PSQ1	te25~rankms= -1_rankdc= -1_reps=1_srate=2.00	230	F	1	1	2017-04-17	2017-09-17	1-0   	38	4	U	0	-1	7	7	-1	1	28	11	4	14	-1	4
te26	2994	Control-AngledStem-NoPruning # stem=15 inches, angle=45, tipLength=0,LatCnt/Ln=4,7	te26~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ2, PSQ2	te26~rankms= -1_rankdc= -1_reps=1_srate=2.00	231	F	1	2	2017-04-17	2017-09-17	1-0   	38	4	U	0	-1	14	12	-1	1	28	11	4	14	-1	4
te27	2995	Control-AngledStem-NoPruning # stem=15 inches, angle=45, tipLength=0,LatCnt/Ln=4,2	te27~rankms= -1_rankdc= -1_reps=1_srate=3.00, SQ3, PSQ3	te27~rankms= -1_rankdc= -1_reps=1_srate=3.00	232	F	1	3	2017-04-17	2017-09-17	1-0   	38	4	U	0	-1	9	11	-1	1	28	11	5	14	-1	4
te28	2996	Control-AngledStem-NoPruning # stem=15 inches, angle=45, tipLength=0,LatCnt/Ln=4,3	te28~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ2, PSQ1	te28~rankms= -1_rankdc= -1_reps=1_srate=2.00	233	F	1	1	2017-04-17	2017-09-17	1-0   	38	4	U	0	-1	11	8	-1	1	28	11	5	14	-1	4
te29	2997	Control-AngledStem-NoPruning # stem=15 inches, angle=45, tipLength=0,LatCnt/Ln=4,4	te29~rankms= -1_rankdc= -1_reps=1_srate=4.00, SQ4, PSQ3	te29~rankms= -1_rankdc= -1_reps=1_srate=4.00	234	F	1	3	2017-04-17	2017-09-17	1-0   	38	4	U	0	-1	7	8	-1	1	28	11	5	14	-1	4
te3	2998	Control-StemPlantedVerticle-NoPruning # stem=12 inches, angle=90, tipLength=0,LatCnt/Ln=4,5	te3~rankms= -1_rankdc= -1_reps=1_srate=1.00, RL test	te3~rankms= -1_rankdc= -1_reps=1_srate=1.00	208	F	1	1	2017-04-17	2017-09-17	1-0   	30	4	U	0	-1	15	7	-1	1	28	10	1	13	-1	1
te30	2999	Control-AngledStem-NoPruning # stem=15 inches, angle=45, tipLength=0,LatCnt/Ln=4,5	te30~rankms= -1_rankdc= -1_reps=1_srate=3.00, SQ3, PSQ3 (had 7 foot root)	te30~rankms= -1_rankdc= -1_reps=1_srate=3.00	235	F	1	3	2017-04-17	2017-09-17	1-0   	38	4	Y	0	-1	12	15	-1	3	28	11	5	14	-1	4
te31	3000	Control-AngledStem-NoPruning # stem=15 inches, angle=45, tipLength=0,LatCnt/Ln=4,6	te31~rankms= -1_rankdc= -1_reps=1_srate=3.00, SQ3, PSQ2	te31~rankms= -1_rankdc= -1_reps=1_srate=3.00	236	F	1	2	2017-04-17	2017-09-17	1-0   	38	4	U	0	-1	8	9	-1	1	28	11	5	14	-1	4
te32	3001	Control-AngledStem-NoPruning # stem=15 inches, angle=45, tipLength=0,LatCnt/Ln=4,7	te32~rankms= -1_rankdc= -1_reps=1_srate=3.00, SQ3, PSQ3	te32~rankms= -1_rankdc= -1_reps=1_srate=3.00	237	F	1	3	2017-04-17	2017-09-17	1-0   	38	4	U	0	-1	10	10	-1	1	28	11	5	14	-1	4
te33	3002	FlatStem-SaveOneTopShootPerFewInches-CutTip # stem=16 inches, angle=0, tipLength=2,LatCnt/Ln=3,2	te33~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ2, PSQ2	te33~rankms= -1_rankdc= -1_reps=1_srate=2.00	238	F	1	2	2017-04-17	2017-09-17	1-0   	41	4	U	0	-1	11	10	-1	1	28	11	6	14	-1	5
te34	3003	FlatStem-SaveOneTopShootPerFewInches-CutTip # stem=16 inches, angle=0, tipLength=2,LatCnt/Ln=3,3	te34~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ2, PSQ2	te34~rankms= -1_rankdc= -1_reps=1_srate=2.00	239	F	1	2	2017-04-17	2017-09-17	1-0   	41	4	U	0	-1	11	8	-1	1	28	11	6	14	-1	5
te35	3004	FlatStem-SaveOneTopShootPerFewInches-CutTip # stem=16 inches, angle=0, tipLength=2,LatCnt/Ln=3,4	te35~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ2, PSQ2	te35~rankms= -1_rankdc= -1_reps=1_srate=2.00	240	F	1	2	2017-04-17	2017-09-17	1-0   	41	4	U	0	-1	8	10	-1	1	28	11	6	14	-1	5
te36	3005	FlatStem-SaveOneTopShootPerFewInches-CutTip # stem=16 inches, angle=0, tipLength=2,LatCnt/Ln=3,5	te36~rankms= -1_rankdc= -1_reps=1_srate=1.00, SQ1, PSQ1	te36~rankms= -1_rankdc= -1_reps=1_srate=1.00	241	F	1	1	2017-04-17	2017-09-17	1-0   	41	4	U	0	-1	17	8	-1	1	28	11	6	14	-1	5
te37	3006	FlatStem-SaveOneTopShootPerFewInches-CutTip # stem=16 inches, angle=0, tipLength=2,LatCnt/Ln=3,6	te37~rankms= -1_rankdc= -1_reps=1_srate=3.00, SQ3, PSQ3	te37~rankms= -1_rankdc= -1_reps=1_srate=3.00	242	F	1	3	2017-04-17	2017-09-17	1-0   	41	4	U	0	-1	9	15	-1	1	28	11	6	14	-1	5
te38	3007	FlatStem-SaveOneTopShootPerFewInches-CutTip # stem=16 inches, angle=0, tipLength=2,LatCnt/Ln=3,7	te38~rankms= -1_rankdc= -1_reps=1_srate=3.00, SQ3, PSQ3	te38~rankms= -1_rankdc= -1_reps=1_srate=3.00	243	F	1	3	2017-04-17	2017-09-17	1-0   	41	4	U	0	-1	10	14	-1	1	28	11	6	14	-1	5
te39	3008	AngledStem-SaveTopShoots-CutTip # stem=14 inches, angle=45, tipLength=2,LatCnt/Ln=2,3	te39~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ3, PSQ2	te39~rankms= -1_rankdc= -1_reps=1_srate=2.00	244	F	1	2	2017-04-17	2017-09-17	1-0   	36	4	U	0	-1	8	9	-1	3	28	12	7	14	-1	6
te4	3009	Control-StemPlantedVerticle-NoPruning # stem=12 inches, angle=90, tipLength=0,LatCnt/Ln=4,6	te4~rankms= -1_rankdc= -1_reps=1_srate=1.00, SQ1, PSQ1	te4~rankms= -1_rankdc= -1_reps=1_srate=1.00	209	F	1	1	2017-04-17	2017-09-17	1-0   	30	4	U	0	-1	12	7	-1	1	28	10	1	13	-1	1
te40	3010	AngledStem-SaveTopShoots-CutTip # stem=14 inches, angle=45, tipLength=2,LatCnt/Ln=2,4	te40~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ2, PSQ2	te40~rankms= -1_rankdc= -1_reps=1_srate=2.00	245	F	1	2	2017-04-17	2017-09-17	1-0   	36	4	U	0	-1	12	8	-1	1	28	12	7	14	-1	6
te41	3011	AngledStem-SaveTopShoots-CutTip # stem=14 inches, angle=45, tipLength=2,LatCnt/Ln=2,5	te41~rankms= -1_rankdc= -1_reps=1_srate=3.00, SQ3, PSQ3	te41~rankms= -1_rankdc= -1_reps=1_srate=3.00	246	F	1	3	2017-04-17	2017-09-17	1-0   	36	4	U	0	-1	8	10	-1	1	28	12	7	14	-1	6
te42	3012	AngledStem-SaveTopShoots-CutTip # stem=14 inches, angle=45, tipLength=2,LatCnt/Ln=2,6	te42~rankms= -1_rankdc= -1_reps=1_srate=1.00, SQ1, PSQ1	te42~rankms= -1_rankdc= -1_reps=1_srate=1.00	247	F	1	1	2017-04-17	2017-09-17	1-0   	36	4	U	0	-1	17	5	-1	1	28	12	7	14	-1	6
te43	3013	AngledStem-SaveTopShoots-CutTip # stem=14 inches, angle=45, tipLength=2,LatCnt/Ln=2,7	te43~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ3, PSQ2	te43~rankms= -1_rankdc= -1_reps=1_srate=2.00	248	F	1	2	2017-04-17	2017-09-17	1-0   	36	4	U	0	-1	9	7	-1	1	28	12	7	14	-1	6
te44	3014	AngledStem-SaveTopShoots-CutTip # stem=14 inches, angle=45, tipLength=2,LatCnt/Ln=2,8	te44~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ2, PSQ1	te44~rankms= -1_rankdc= -1_reps=1_srate=2.00	249	F	1	1	2017-04-17	2017-09-17	1-0   	36	4	U	0	-1	12	10	-1	3	28	12	7	14	-1	6
te45	3015	AngledStem-SaveOneTopShootPerFewInches-CutTip # stem=16 inches, angle=45, tipLength=2,LatCnt/Ln=3,3	te45~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ2, PSQ2	te45~rankms= -1_rankdc= -1_reps=1_srate=2.00	250	F	1	2	2017-04-17	2017-09-17	1-0   	41	4	U	0	-1	10	8	-1	1	28	12	8	14	-1	7
te46	3016	AngledStem-SaveOneTopShootPerFewInches-CutTip # stem=16 inches, angle=45, tipLength=2,LatCnt/Ln=3,4	te46~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ2, PSQ2	te46~rankms= -1_rankdc= -1_reps=1_srate=2.00	251	F	1	2	2017-04-17	2017-09-17	1-0   	41	4	U	0	-1	8	9	-1	1	28	12	8	14	-1	7
te47	3017	AngledStem-SaveOneTopShootPerFewInches-CutTip # stem=16 inches, angle=45, tipLength=2,LatCnt/Ln=3,5	te47~rankms= -1_rankdc= -1_reps=1_srate=2.00, SQ2, PSQ2	te47~rankms= -1_rankdc= -1_reps=1_srate=2.00	252	F	1	2	2017-04-17	2017-09-17	1-0   	41	4	U	0	-1	11	11	-1	1	28	12	8	14	-1	7
te48	3018	AngledStem-SaveOneTopShootPerFewInches-CutTip # stem=16 inches, angle=45, tipLength=2,LatCnt/Ln=3,6	te48~rankms= -1_rankdc= -1_reps=1_srate=1.00, SQ1, PSQ1	te48~rankms= -1_rankdc= -1_reps=1_srate=1.00	253	F	1	1	2017-04-17	2017-09-17	1-0   	41	4	U	0	-1	12	5	-1	3	28	12	8	14	-1	7
te49	3019	AngledStem-SaveOneTopShootPerFewInches-CutTip # stem=16 inches, angle=45, tipLength=2,LatCnt/Ln=3,7	te49~rankms= -1_rankdc= -1_reps=1_srate=1.00, SQ2, PSQ2	te49~rankms= -1_rankdc= -1_reps=1_srate=1.00	254	F	1	2	2017-04-17	2017-09-17	1-0   	41	4	U	0	-1	17	7	-1	1	28	12	8	14	-1	7
te5	3020	Control-StemPlantedVerticle-NoPruning # stem=12 inches, angle=90, tipLength=0,LatCnt/Ln=4,7	te5~rankms= -1_rankdc= -1_reps=1_srate=1.00, RL test	te5~rankms= -1_rankdc= -1_reps=1_srate=1.00	210	F	1	1	2017-04-17	2017-09-17	1-0   	30	4	U	0	-1	16	6	-1	3	28	10	1	13	-1	1
te50	3021	AngledStem-SaveOneTopShootPerFewInches-CutTip # stem=16 inches, angle=45, tipLength=2,LatCnt/Ln=3,8	te50~rankms= -1_rankdc= -1_reps=1_srate=1.00, SQ2, PSQ1	te50~rankms= -1_rankdc= -1_reps=1_srate=1.00	255	F	1	1	2017-04-17	2017-09-17	1-0   	41	4	U	0	-1	17	4	-1	1	28	12	8	14	-1	7
te6	3022	Control-StemPlantedVerticle-NoPruning # stem=12 inches, angle=90, tipLength=0,LatCnt/Ln=4,8	te6~rankms= -1_rankdc= -1_reps=1_srate=1.00, RL test	te6~rankms= -1_rankdc= -1_reps=1_srate=1.00	211	F	1	1	2017-04-17	2017-09-17	1-0   	30	4	Y	0	-1	16	7	-1	1	28	10	1	13	-1	1
te7	3023	Control-StemPlantedVerticle-NoPruning # stem=12 inches, angle=90, tipLength=0,LatCnt/Ln=4,9	te7~rankms= -1_rankdc= -1_reps=1_srate=1.00, RL test	te7~rankms= -1_rankdc= -1_reps=1_srate=1.00	212	F	1	1	2017-04-17	2017-09-17	1-0   	30	4	U	0	-1	16	7	-1	3	28	10	1	13	-1	1
te8	3024	Control-StemPlantedVerticle-CutTip # stem=12 inches, angle=90, tipLength=2,LatCnt/Ln=2,3	te8~rankms= -1_rankdc= -1_reps=1_srate=1.00, F1	te8~rankms= -1_rankdc= -1_reps=1_srate=1.00	218	F	1	1	2017-04-17	2017-09-17	1-0   	30	4	U	0	-1	15	5	-1	3	28	10	2	13	-1	2
te9	3025	Control-StemPlantedVerticle-CutTip # stem=12 inches, angle=90, tipLength=2,LatCnt/Ln=2,4	te9~rankms= -1_rankdc= -1_reps=1_srate=1.00, F1	te9~rankms= -1_rankdc= -1_reps=1_srate=1.00	219	F	1	1	2017-04-17	2017-09-17	1-0   	30	4	U	0	-1	7	3	-1	3	28	10	2	13	-1	2
zoss	3026	0	zoss~rankms= -1_rankdc= 55_reps=1_srate=0.75	zoss@rankms=17.7_rankdc=2.0_dcreps=4_dcsrate=0.49_archived=4_field_score=4.28	55	D	4	3	2017-04-17	2017-09-17	DC    	20	14	U	9	-1	0	0	-1	3	28	2	29	2	-1	-1
6gg1	3027	1 ortet MS planted 4 inches apart. (counted DC, measure MS). Best rooted cutting with a 15 inch shoot, 6 inch root ball, but weakened from heavy shading.	R1, C0	0	194	R	1	1	2017-04-17	2017-11-25	DC    	20	8	U	4	-1	8	4	-1	1	31	9	1	9	-1	-1
6gg2	3028	1 ortet MS planted 4 inches apart. (counted DC, measure MS). The rooted cutting with a 8 inch shoot, 1.5 inch root ball, but weakened from heavy shading.	R1, C0	0	195	R	1	1	2017-04-18	2017-11-26	DC    	20	8	U	4	-1	8	4	-1	1	31	9	1	9	-1	-1
6gg3	3029	1 ortet MS planted 4 inches apart. (counted DC, measure MS). Best rooted cutting with a 15 inch shoot, 6 inch root ball, but weakened from heavy shading.	R1, C0	0	196	R	1	1	2017-04-19	2017-11-27	DC    	20	8	U	4	-1	8	4	-1	1	31	9	1	9	-1	-1
25r21	3030	Nice! 2017 Selection, no leaf issues	DOT1, R1, C4	0	155	R	1	1	2017-04-17	2017-11-25	DC    	20	8	Y	-1	-1	-1	4	-1	4	31	6	11	5	-1	-1
25r22	3031	25r22~Best 2017 25xr Double Selection. (1ms, 1 DC).  DC=8',MS=7', Yielded 13 Cuttings. 	R2, C13, WASP	0	156	P	1	1	2017-04-17	2017-11-25	DC    	20	8	Y	-1	-1	-1	13	-1	4	31	6	11	5	-1	-1
25r23	3032	25r23~2017 Double Selection. Planted 1 MS, 1 DC – Yielded 10 Cuttings.	R2, C10, WASP	0	157	P	1	1	2017-04-17	2017-11-25	DC    	20	8	Y	-1	-1	-1	10	-1	4	31	6	11	5	-1	-1
25r24	3033	25r24~2017 Double Selection. Planted 1 MS, 1 DC – Yielded 7 Cuttings.	R2, C7, WASP	0	158	P	1	1	2017-04-17	2017-11-25	DC    	20	8	Y	-1	-1	-1	7	-1	4	31	6	11	5	-1	-1
25r25	3034	25r25~2017 Double Selection. Planted 1 MS, 1 DC – Yielded 6 Cuttings.	R2, C6, WASP	0	159	P	1	1	2017-04-17	2017-11-25	DC    	20	8	Y	-1	-1	-1	6	-1	4	31	6	11	5	-1	-1
25r26	3035	Nice! 2017 Selection (double 1ms/1DC)	R2, C3	0	160	R	1	1	2017-04-17	2017-11-25	DC    	20	8	Y	-1	-1	-1	3	-1	4	31	6	11	5	-1	-1
25r27	3036	Nice! 2017 Selection (double 1ms/1DC)	R2, C5	0	161	R	1	1	2017-04-17	2017-11-25	DC    	20	8	Y	-1	-1	-1	5	-1	4	31	6	11	5	-1	-1
25r28	3037	Nice! 2017 Selection (double 1ms/1DC)	R2, C3	0	162	R	1	1	2017-04-17	2017-11-25	DC    	20	8	Y	-1	-1	-1	3	-1	4	31	6	11	5	-1	-1
25r29	3038	Nice! 2017 Selection (double 1ms/1DC)	R2, C4	0	163	R	1	1	2017-04-17	2017-11-25	DC    	20	8	Y	-1	-1	-1	4	-1	4	31	6	11	5	-1	-1
25r30	3039	Nice! 2017 Selection (double 1ms/1DC)	R2, C3	0	164	R	1	1	2017-04-17	2017-11-25	DC    	20	8	Y	-1	-1	-1	3	-1	4	31	6	11	5	-1	-1
25r31	3040	Nice! 2017 Selection (double 1ms/1DC)	R2, C3	0	165	R	1	1	2017-04-17	2017-11-25	DC    	20	8	Y	-1	-1	-1	3	-1	4	31	6	11	5	-1	-1
25r32	3041	Nice! 2017 Selection (double 1ms/1DC)	R2, C1	0	166	R	1	1	2017-04-17	2017-11-25	DC    	20	8	Y	-1	-1	-1	1	-1	4	31	6	11	5	-1	-1
25r33	3042	Nice! 2017 Selection (double 1ms/1DC)	R2, C3	0	167	R	1	1	2017-04-17	2017-11-25	DC    	20	8	Y	-1	-1	-1	3	-1	4	31	6	11	5	-1	-1
\.


--
-- Name: test_detail_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('test_detail_id_seq', 1, false);


--
-- Data for Name: test_spec; Type: TABLE DATA; Schema: public; Owner: user
--

COPY test_spec (test_spec_key, id, notes, activity_type, test_type, stock_type, stock_length_cm, stock_collar_dia_mm, research_hypothesis, web_protocol, web_url, web_photos, test_start_date, id_site) FROM stdin;
TBD	1	To Be Determined	0	0	U     	-1	-1	0	0	0	0	1111-11-11	1
NA	2	Does Not Apply	0	0	U     	-1	-1	0	0	0	0	1111-11-11	2
2008-bell-nursery	3	2008-bell-nursery results	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2008-04-04	3
2008-costa-nursery	4	2008-costa-nursery results	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2008-04-04	4
2009-bell-nursery	5	2009-bell-nursery results	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2009-04-04	3
2009-costa-nursery	6	2009-costa-nursery results	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2009-04-04	4
2010-bell-nursery	7	2010-bell-nursery results	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2010-03-25	3
2010-dykema-nursery	8	2010-dykema-nursery results	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2010-03-25	5
2011-bell-nursery	13	2011 Bell nursery results. Planted 14 E to W rows, with rows 2 foot on centered double rows 4 inches apart.  Rows planted from N to S, The NE 3 rows grew slower. 2011 was a very wet spring & moderate Summer.  The wet Spring seemed to help cutting survival.	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2011-04-08	3
2012-bell-nursery	14	2012 Bell nursery results. Planted 8 E to W rows with cuttings planted about 2 on centered doubled rows 4 apart.  Each row is counted separate.  Columns represented by each clone ID.  All clones are labeled with clone name and 2011 database ID.	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2012-04-06	3
2012-2xCAG12-Cross	15	C173 x AG15 - planted about 350 seedlings on 6/16/12 that were grown indoors under flourescent lights.  Leaves were in tough shape...  This cross will be tested for cutting propagation.	EVENT	breeding	MIX   	-1	-1	The 2xCAG12 cross will have selections that yield more biomass than CAG204, root from cuttings, have straighter form and be fertile or infertile.	0	0	0	2012-02-12	3
2011-1xCAGW-Cross	16	CAG204 x Wind Pollinated at Cedar Springs, Michigan, most pollen may be from AE42.  CAG204 is quite fertile and had very good seed set and flower productivity.  The progeny had aspen and alba like seedlings.  One 2011 seedling propagated via cuttings in 2012 rooted 100%.	EVENT	breeding	MIX   	-1	-1	The 1xCAGW cross will have similar aspen to alba like seedling ratios as the CAG204 x AE42 cross.	0	0	0	2012-03-14	3
2011-RNE-AlbaPolePlanting	17	Planted 3 clones at RNE as pole stock in early November 2011.	TRIAL	archive-planting	WHIP  	213	-1	The rootable aspen materials may have similar survival rates as poles planted on good field sites as the same stock in nursery as with 6 cuttings.	0	0	0	2011-11-05	7
WASP-2013-A	18	A 2013 WASP rooting test involving 93AA12 that rooted 60% (24/40) in 2012 and 15AG4MF (aka AG15) that did not root at all.  See Journal entry and URL for details...	TRIAL	propagation	WASP  	-1	-1	The Willow and Water Soak treatments will show an increase in rooting compared to the No Soak control.	0	https://docs.google.com/spreadsheet/ccc?key=0Ar-SwoTVeWFadEFfYW11X21iamFKX0tKNHRsWWlrR3c#gid=13	0	2013-01-12	6
2013-breeding	19	Six crosses are planned for 2013 as a Proof Of Concept (POC) for aspen hybrids with good vigor and rooting characteristics.  	EVENT	breeding	SEL   	8	-1	The 2013 aspen crosses will meet the expectations set within the POC breeding strategy.	0	https://docs.google.com/spreadsheet/ccc?key=0Ar-SwoTVeWFadDhTNGtibW51amt0Z1JHYmw5SGdjRXc#gid=3	0	2013-03-19	6
2013-bell-nursery	20	2013 Bell nursery results. Planted 7 E to W rows with cuttings planted about 1.3 inches on centered doubled rows 30 inches apart.  Each row is counted separate (14 actual rows).  Columns represented by each clone ID.  All clones are labeled with clone/family name.	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	https://drive.google.com/folderview?id=0B7-SwoTVeWFadVF2LVA0c3d0MWc&usp=sharing	2013-04-20	3
2014-breeding	21	Produced 24 crosses for 2014 for a Proof Of Concept (POC) testing for aspen hybrids with good vigor and rooting characteristics.  	EVENT	breeding	SEL   	8	-1	The 2014 aspen crosses will meet the expectations set within the POC breeding strategy.	0	0	0	2014-03-19	6
2014-bell-nursery	22	2014 Bell nursery results. Planted 12 (6 long 6 short) E to W double rows with cuttings planted about 2.5 to 3 inches on centered doubled rows 30 to 36 inches apart.  Each row is counted separate.  Columns represented by each clone ID.  All clones are labeled with clone/family name.	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2014-04-20	3
2015-bell-nursery	23	2015 Bell nursery results. Planted 12 (6 long 8 short) E to W double rows with cuttings planted about 2 inches on centered doubled rows 30 inches apart.  Each row is counted separate.  Columns represented by each clone ID.  All clones are labeled with clone/family name.	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2015-05-08	3
2016-bell-nursery	24	2016 Bell nursery results. Planted 15 (6 long 8 short) E to W single/double rows with 10 inch ministools or 8 inch cuttings planted about 2 inches on centered doubled rows 30 inches apart.  Each row is counted separate.  Columns represented by each clone ID.  All clones are labeled with clone/family name.	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2016-04-15	3
2016-PostNE-West-Planted	25	Establish the 2016 clonal archive planting at Post NE site.   Planted S to N rows planted 5 x 6 foot spacing.  Stock was 5-7 foot 1-1 trees wrapped with textile fabric.  Applied Glysophate mid May, June and July.	TRIAL	archive-planting	1-0   	213	20	NA	0	0	0	2016-03-15	9
2016-PostNE-West-Measured	26	Measure trees for first year field growth. Overall - an excellent site and 2016 growth. Trees are planted too close but these not all primary selections so they can be thinned later.   	TRIAL	archive-planting	1-0   	213	-1	NA	0	0	0	2016-12-26	9
2017-PostNE-West-Planting	27	Planted secondary level trees on Noth end of rows 1, 2, 3 and 4. Rows 1 and 2 have only secondary level trees.  Rows 3 and 4 start with Primary level trees.  	TRIAL	archive-planting	1-0   	213	-1	NA	0	0	0	2017-03-25	9
2017-bell-nursery	28	The 2017 Bell Nursery was started on 4/17/17 and measured after 9/20/17. It was irrigated, mulched, fertilized and located on about 1000 square feet with 16 rows and 15 replications of different tests. The stock consisted mostly of 8 inch cuttings or 10 inch mini-stools in rows 30 inches apart with centered double rows 4 inches apart. Columns are represented by each labeled clone/family ID.	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	https://drive.google.com/open?id=0B7-SwoTVeWFaNFQ5cVB4YlgxLUk0	2017-04-17	3
2017-CSNE-Measured	29	Measure 12 year growth on CSNE site.  A poorly drained site. I recall water present during planting.  Trees planted on 8x8 foot centers. Likely planted on 4/16/2005, one weekend after CSSE.	TRIAL	archive-planting	1-0   	50	-1	The control clones indicate that the field results are consistent.	0	0	https://drive.google.com/open?id=0B7-SwoTVeWFaYXRZNTFCSm84WDA	2017-10-16	10
2017-PostNE-West-Measured	30	Measure trees for first and second year field growth. Overall - an excellent site and 2017 growth. Noted some deer damage and a few trees on high North knoll have apparent bark damage from the staples.   	TRIAL	archive-planting	1-0   	213	-1	NA	0	0	0	2017-10-13	9
2017-bell-nursery-Selections	31	The 2017 Bell Nursery clonal selections.	EVENT	nursery	MIX   	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	https://drive.google.com/open?id=0B7-SwoTVeWFaNFQ5cVB4YlgxLUk0	2017-11-20	3
1989-Arthur-Nursery-Rooting	32	1989 dormant cutting rooting tests from McGovern Arthur nursery. Tests used 4 and 6” cuttings P. alba clones/hybrids. Some with shade cloth, #30 Hormex IBA rooting hormone (3% IBA).	EVENT	nursery	DC    	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	1989-11-01	11
1990-Arthur-Nursery-Rooting	33	1990 dormant cutting rooting tests from McGovern Arthur nursery. Tests used 7” cuttings P. alba clones/hybrids with #30 Hormex IBA rooting hormone (3% IBA).	EVENT	nursery	DC    	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	1990-11-01	11
1995-Arthur-Nursery-Rooting	34	1995 dormant cutting rooting tests from McGovern Arthur nursery. Tests used 8” cuttings P. alba clones/hybrids with #30 Hormex IBA rooting hormone (3% IBA).	EVENT	nursery	DC    	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	1995-11-01	11
1992-Arthur-Nursery-Rooting	35	1992 dormant cutting rooting tests from McGovern Arthur nursery. Tests used 8” cuttings P. alba clones/hybrids with #30 Hormex IBA rooting hormone (3% IBA).	EVENT	nursery	DC    	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	1992-11-21	11
2003-bell-nursery	36	2003-bell-nursery results for entries posted on 2/1/18 from the spreadsheet: PMGs_Poplar_Families_Clones_V1_8	EVENT	nursery	DC    	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2003-11-01	3
2004-bell-nursery	37	2004-bell-nursery results for entries posted on 2/1/18 from the spreadsheet: PMGs_Poplar_Families_Clones_V1_8	EVENT	nursery	DC    	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2004-11-01	3
2005-bell-nursery	38	2005-bell-nursery results for entries posted on 2/1/18 from the spreadsheet: PMGs_Poplar_Families_Clones_V1_8	EVENT	nursery	DC    	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2005-11-01	3
2004-bell-nursery-hgt-dia-meas	39	2004-bell-nursery results for each P2 2004 seedling measured for height/diamter on 2004-11-21. Data taken from spreadsheet, PMGs_Poplar_Families_Clones_V1_8, worksheet: 2004_Seedling_Sample_Stats	EVENT	nursery	DC    	-1	-1	The control clones indicate that the nursery results are consistent.	0	0	0	2004-11-21	3
2017-TreeShelterTrial-Rlnder	40	2017-TreeShelterTrial-Rlnder - Compare tree tube, textile fabric sleeve tree shelters, 6 hybrid aspen and figured wood varieties to the DN34 control clone. 	TRIAL	clonal-trial	1-0   	160	8	If using tree shelters with tree heights exceeding the shelter, then significant stem growth differences will not be observed.	0	0	0	2017-11-08	12
2017-TreeShelterTrial-Wyrdj5	41	2017-TreeShelterTrial-Wyrdj5 - Compare tree tube, textile fabric sleeve tree shelters, 6 hybrid aspen and figured wood varieties to the DN34 control clone. 	TRIAL	clonal-trial	1-0   	160	8	If using tree shelters with tree heights exceeding the shelter, then significant stem growth differences will not be observed.	0	0	0	2017-11-09	13
08-27-17-gpft-2b29-Bell	42	08-27-17-gpft-2b29-Bell - A 4', 1 year nursery whip stem cut on 8/27/17.  3” cuttings with a centered 10 mm band saw cut on big end and sliced with a 18mm x .3 mm thick blade.  Cutting split with  screw driver in bench vice, with wire in slit and pulled with peak load scale to measure gpf.	TRIAL	gpft	1-0   	122	15	If aspen wood grain is highly figured then the grain pull force will be higher than straight grained wood. 	0	0	0	2017-08-27	3
09-09-17-gpft-agrr1-Ortet	43	09-09-17-gpft-agrr1-Ortet - A 4', 2 year whip stem cut on 8/27/17 from the ortet location.  3” cuttings with a centered 10 mm band saw cut on big end and sliced with a 18mm x .3 mm thick blade.  Cutting split with  screw driver in bench vice, with wire in slit and pulled with peak load scale to measure gpf.	TRIAL	gpft	WHIP  	122	-1	If aspen wood grain is highly figured then the grain pull force will be higher than straight grained wood. 	0	0	0	2017-09-17	7
10-15-17-gpft-2b3-RNE	44	10-15-17-gpft-2b3-RNE - A 9.5', 2 year whip stem cut on 10/15/17 from archived tree at PostNE Row-2, Col-27. 3” cuttings with a centered 10 mm band saw cut on big end and sliced with a 18mm x .3 mm thick blade.  Cutting split with  screw driver in bench vice, with wire in slit and pulled with peak load scale to measure gpf.	TRIAL	gpft	WHIP  	290	-1	If aspen wood grain is highly figured then the grain pull force will be higher than straight grained wood. 	0	0	0	2017-10-15	9
03-01-18-gpft-2b3-Bell-whips	45	03-01-18-gpft-2b3-Bell-whips - Three 2b3 1-0 Bell nusery whips 8' to 9' tall. 3” cuttings with a centered 10 mm band saw cut on big end and sliced with a 18mm x .3 mm thick blade.    Then split using the GPF jig, with wire in slit and pulled with peak load scale to measure gpf.	TRIAL	gpft	WHIP  	290	-1	If aspen wood grain is highly figured then the grain pull force will be higher than straight grained wood. 	0	0	0	2018-03-01	9
02-24-18-gpft-mix-Bell	46	02-24-18-gpft-mix-Bell - Testing figured grain pull force for a mix of clolne whips from Bell nursery. Most 1-0 stock.  Cut 3” cuttings with a centered 10 mm band saw cut on big end and sliced with a 18mm x .3 mm thick blade.  Then split using the GPF jig.	TRIAL	gpft	WHIP  	213	-1	If aspen wood grain is highly figured then the grain pull force will be higher than straight grained wood. 	0	0	0	2018-03-01	3
03-05-18-gpft-25r1-20-Bell	47	03-05-18-gpft-25r1-20-Bell - Testing figured grain pull force for the 20 clones (25r1-25r20).  Will test the 2 lowest 3” cuttings from each clone and perhaps split the next with a pruning shear. Cut 3” cuttings with a centered 10 mm band saw cut on big end and sliced with a 18mm x .3 mm thick blade.  Then split using the GPF jig.	TRIAL	gpft	WHIP  	213	-1	If aspen wood grain is highly figured then the grain pull force will be higher than straight grained wood. 	0	0	0	2018-03-01	3
03-10-18-gpft-25xr-mix-Bell	48	03-10-18-gpft-25xr-mix-Bell - Testing figured grain pull force for the mix of 25xR family clones.  Will test the 2 lowest 3” cuttings from each clone and perhaps split the next with a pruning shear. Cut 3” cuttings with a centered 10 mm band saw cut on big end and	TRIAL	gpft	WHIP  	213	-1	If aspen wood grain is highly figured then the grain pull force will be higher than straight grained wood. 	0	0	0	2018-03-01	3
03-03-18-gpft-mix-Post	49	03-03-18-gpft-mix-Post - Testing figured grain pull force for a mix of clolne whips from Bell nursery. Cut from 1 to 2 year tree tops at Post DR..  Cut 3” cuttings with a centered 10 mm band saw cut on big end and sliced with a 18mm x .3 mm thick blade.  Then split using the GPF jig.	TRIAL	gpft	WHIP  	213	-1	If aspen wood grain is highly figured then the grain pull force will be higher than straight grained wood. 	0	0	0	2018-03-03	9
03-11-18-gpft-a502-RNE-3yr	50	03-11-18-gpft-a502-RNE-3yr stem material - Cut a 3 inch dia 20 foot tall straight stem from a A502 tree at RNE.  Cut 3” cuttings with a centered 10 mm band saw cut on big end and sliced with a 18mm x .3 mm thick blade. 	TRIAL	gpft	WHIP  	213	-1	If aspen wood grain is highly figured then the grain pull force will be higher than straight grained wood. 	0	0	0	2018-03-11	7
03-11-18-gpft-a502-RNE-2yr	51	03-11-18-gpft-a502-RNE-2yr stem material. - Cut a 3 inch dia 20 foot tall straight stem from a A502 tree at RNE.  Cut 3” cuttings with a centered 10 mm band saw cut on big end and sliced with a 18mm x .3 mm thick blade. 	TRIAL	gpft	WHIP  	213	-1	If aspen wood grain is highly figured then the grain pull force will be higher than straight grained wood. 	0	0	0	2018-03-11	7
2018-PostNE-West-Planting	52	Planted mulit-level level trees on East side of row 4 and replaced several dead trees.  	TRIAL	archive-planting	1-0   	213	-1	NA	0	0	0	2018-03-22	9
\.


--
-- Name: test_spec_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('test_spec_id_seq', 1, false);


--
-- Data for Name: u07m_2013; Type: TABLE DATA; Schema: public; Owner: user
--

COPY u07m_2013 (id, dbh, dbh_rank, name, area_index, sum_dbh_ratio2_cd, sdbh_x_cavg) FROM stdin;
1	5.6	131	17XGA24	221.36	3.17	13.58
2	3.2	186	17XGA04	122.51	2.28	14.48
3	8	44	17XGA04	200.73	9.59	23.4
4	4	167	17XGA5	138.35	3.65	15.6
5	5.8	123	82XAA04	172.79	6.24	18.85
6	5	145	82XAA04	141.89	3.54	22.63
7	8.7	22	82XAA04	215.4	6.17	25.45
8	0	208	82XAA04	0	0	0
9	0	208	2XT4E04	0	0	0
10	0	208	2XT4E04	0	0	0
11	0	208	2XT4E04	0	0	0
12	0	208	2XT4E04	0	0	0
13	8.7	23	83XAA04	220	3.6	25.01
14	9.8	5	83XAA04	206.49	7.33	32.46
15	9.4	7	83XAA04	205.42	6.97	31.84
16	8.9	17	83XAA04	207.91	6.89	27.48
17	6.3	101	81XAA04	170.58	3.49	23.78
18	9.3	9	81XAA04	180.84	6.84	40.45
19	7.9	48	81XAA04	171.23	6.07	35.35
20	4	168	81XAA04	171.41	2.52	14.15
21	0	208	NM6	0	0	0
22	9.4	8	80XAA04	187.05	8.17	38.66
23	6.8	83	80XAA04	81.66	8.58	48.03
24	6.4	97	80XAA04	89.87	9.91	39.28
25	3	189	80XAA04	32.15	3.77	20.21
26	8	45	84XAA04	121.35	13.62	42.2
27	6	115	84XAA04	81.98	8.47	37.13
28	7.7	53	84XAA04	130.97	10.55	37.06
29	4.7	155	84XAA04	110.43	4.48	23.97
30	4.4	161	18XAG04	146.12	3.8	16.83
31	6	116	18XAG04	178.91	3.97	20.02
32	8.2	38	18XAG04	192.77	4.92	29.42
33	7.7	54	18XAG04	165.46	3.67	32.82
34	0	208	81XAA04	0	0	0
35	5.5	133	81XAA04	82.41	6.09	35.34
36	2.9	192	81XAA04	42.34	2.79	19.32
37	0	208	81XAA04	0	0	0
38	6.1	109	80XAA04	88.47	6.08	38.58
39	5.9	119	80XAA04	67.6	6.85	42.19
40	8.6	25	80XAA04	103.72	10.9	58.05
41	8	46	80XAA04	125.91	9.64	45.5
42	3.8	174	NM6	168.37	2.37	13.4
43	8.9	18	83XAA04	205.22	5.34	32.26
44	8.4	28	83XAA04	140.92	7.57	44.62
45	6.6	89	83XAA04	137.26	7.21	31.43
46	9.1	15	83XAA04	163.19	9.93	41.29
47	6	117	1XTE04	103.63	8.25	30.97
48	3.3	184	1XTE04	42.52	4.63	19.88
49	5	146	1XTE04	77.07	7.96	27.06
50	5.8	124	1XTE04	92.1	10.81	31.18
51	9.2	12	80XAA04	147.96	18.96	42.43
52	4.9	151	80XAA04	134.97	7.6	19.78
53	0	208	80XAA04	0	0	0
54	10.1	3	80XAA04	205.51	5.95	35.48
55	7.1	76	82XAA04	145.35	5.28	31.68
56	7.3	68	82XAA04	143.4	8.51	30.93
57	6.2	104	82XAA04	127.26	6.79	28.44
58	6.2	105	82XAA04	112.17	8.43	31.78
59	7.5	60	83XAA04	116.97	8.87	41.53
60	6.5	94	83XAA04	84.27	8.79	41.52
61	5	147	83XAA04	56.45	5.79	35.38
62	7.4	65	83XAA04	91.33	9.53	49.67
63	8.8	21	NM6	183.69	7.29	35.86
64	0	208	85XAA04	0	0	0
65	4.4	162	85XAA04	101.56	4.87	21.07
66	0	208	85XAA04	0	0	0
67	0	208	85XAA04	0	0	0
68	6.3	102	18XAG04	145.61	5.39	26.93
69	5.6	132	18XAG04	172.7	6.19	16.94
70	3.6	178	18XAG04	140.22	3.62	11.84
71	6.6	90	18XAG04	158.05	10.05	24.91
72	1.8	205	85XAA04	37.52	2.61	8.62
73	2.7	195	85XAA04	90.26	3.81	11.71
74	0	208	85XAA04	0	0	0
75	0	208	85XAA04	0	0	0
76	5.1	141	84XAA04	101.29	5.29	26.01
77	0	208	84XAA04	0	0	0
78	7.1	77	84XAA04	111.87	8.06	39.23
79	7.7	55	84XAA04	126.37	9.48	40.62
80	3.5	181	82XAA04	65.26	4.09	19.69
81	8.4	29	82XAA04	154.95	14.56	35.91
82	6.1	110	82XAA04	120.19	9.64	29.43
83	5.7	126	82XAA04	104.67	8.06	31.21
84	7.7	56	NM6	187.4	4.38	27.72
85	2.7	196	81XAA04	156.33	1.7	9.18
86	6.9	80	81XAA04	145.03	8.26	30.45
87	4.8	152	81XAA04	125.56	3.61	21.42
88	10.2	2	81XAA04	209.28	6.89	30.98
89	0	208	2XT4E04	0	0	0
90	0	208	2XT4E04	0	0	0
91	0	208	2XT4E04	0	0	0
92	0	208	2XT4E04	0	0	0
93	4.8	153	84XAA04	110.74	9.66	18.72
94	4.3	164	84XAA04	111.2	10.95	16.13
95	9.7	6	84XAA04	188.8	17.53	35.77
96	8.3	33	84XAA04	193.78	13.19	25.63
97	2.9	193	17XGA04	126.9	2	8.77
98	5.1	142	17XGA04	181.73	4.24	13.9
99	6.7	86	17XGA04	170.55	6.78	23.28
100	5	148	17XGA04	125.44	6.42	20.12
101	0	208	85XAA04	0	0	0
102	3.7	176	85XAA04	82.78	6.06	17.16
103	1.9	204	85XAA04	32.64	2.25	10.4
104	0	208	85XAA04	0	0	0
105	6.9	81	NM6	181.94	4.01	24.06
106	9.2	13	81XAA04	188.3	8.33	37.84
107	6.7	87	81XAA04	82.54	8.99	46.15
108	7.5	61	81XAA04	100.8	7.36	49.03
109	0	208	81XAA04	0	0	0
110	5.7	127	82XAA04	177.2	1.98	18.74
111	7.9	49	82XAA04	231.76	4.56	16.29
112	6.9	82	82XAA04	199.15	6.07	18.03
113	6.1	111	82XAA04	157.96	9.49	19.67
114	2.5	198	18XAG04	55.89	3.87	10.63
115	7.2	73	18XAG04	126.05	16.93	33.39
116	1.3	207	18XAG04	22.43	1.56	7.31
117	5.7	128	18XAG04	123.81	9.23	26.36
118	0	208	1XTE04	0	0	0
119	0	208	1XTE04	0	0	0
120	0	208	1XTE04	0	0	0
121	2.9	194	1XTE04	86.37	2.33	12.36
122	4.3	165	82XAA04	105.68	5.43	17.9
123	6.8	84	82XAA04	163.27	10.98	21.67
124	6.1	112	82XAA04	122.46	9.97	28.14
125	7	79	82XAA04	129.93	11.33	33.43
126	7.5	62	NM6	196.01	5.37	23.63
127	8.5	27	83XAA04	206.83	6.78	28.05
128	8.1	42	83XAA04	140.65	13.99	43.74
129	7.4	66	83XAA04	152.97	11.92	31.82
130	8.2	39	83XAA04	166.02	13.89	31.26
131	0	208	2XT4E04	0	0	0
132	0	208	2XT4E04	0	0	0
133	3.9	171	2XT4E04	93.37	7.01	16.57
134	3	190	2XT4E04	52.74	5.87	14.59
135	4.7	156	17XGA04	77.69	8.43	24.09
136	3.9	172	17XGA04	66.3	8.36	20.33
137	5.9	120	17XGA04	114.6	10.77	27.14
138	0	208	17XGA04	0	0	0
139	8.9	19	83XAA04	177.95	7.19	34.82
140	7.5	63	83XAA04	183.48	4.23	27.47
141	8.2	40	83XAA04	182.74	8.53	30.24
142	9.9	4	83XAA04	199.2	11.37	30.94
143	0	208	81XAA04	0	0	0
144	5	149	81XAA04	113.21	5.41	21.5
145	4.5	159	81XAA04	78.66	5.19	24.75
146	8	47	81XAA04	144.09	12.08	36
147	3.3	185	85XAA04	135.85	3.12	12.42
148	2.4	199	1XTE04	222.71	0.58	4.98
149	0	208	1XTE04	0	0	0
150	1.5	206	1XTE04	147.94	1.2	4.89
151	2.4	200	1XTE04	105.87	2.9	9.51
152	6	118	18XAG04	161.99	6.93	22.88
153	2.6	197	18XAG04	90.77	3.23	11.99
154	2.2	201	18XAG04	54.01	3.34	11.08
155	5.3	138	18XAG04	88.39	9.72	28.42
156	7.3	69	82XAA04	109.41	11.78	40.24
157	5.7	129	82XAA04	85.09	8.83	31.71
158	7.1	78	82XAA04	129.43	10.32	31.95
159	5.9	121	82XAA04	99.79	7.43	31.71
160	6.5	95	81XAA04	101.25	7.32	37.38
161	5.7	130	81XAA04	81.84	5.47	36.84
162	0	208	81XAA04	0	0	0
163	3.5	182	81XAA04	71.27	3.2	18.86
164	6.1	113	84XAA04	104.16	7.99	32.33
165	6.6	91	84XAA04	130.22	6.79	30.44
166	0	208	84XAA04	0	0	0
167	4.5	160	84XAA04	93.23	7.42	22.22
168	3.1	188	85XAA04	143.5	3.72	11.08
169	0	208	85XAA04	0	0	0
170	0	208	85XAA04	0	0	0
171	0	208	85XAA04	0	0	0
172	0	208	85XAA04	0	0	0
173	8.6	26	80XAA04	148.83	14.38	39.99
174	8.7	24	80XAA04	137.01	16.98	43.5
175	7.5	64	80XAA04	126.33	15.53	36.94
176	9.3	10	80XAA04	144.76	18.06	44.76
177	5	150	84XAA04	94.03	6.79	25.88
178	7.2	74	84XAA04	134.98	10.62	32.49
179	3.4	183	84XAA04	90.17	3.82	14.41
180	4	169	84XAA04	93.37	6.59	18.05
181	7.2	75	80XAA04	159.77	10.05	27.81
182	6.8	85	80XAA04	171.45	7.61	23.8
183	6.6	92	80XAA04	201.94	5.71	16.42
184	3.9	173	80XAA04	122.89	3.3	15.84
185	8.4	30	83XAA04	157.94	9.91	34.76
186	5.1	143	83XAA04	97	4.39	27.16
187	7.8	51	83XAA04	146.65	8.58	35.49
188	10.6	1	83XAA04	197.41	16.57	36.04
189	2.2	202	85XAA04	163.52	1.99	6.05
190	9.3	11	84XAA04	264.08	2.91	15.35
191	0	208	84XAA04	0	0	0
192	5.4	136	84XAA04	176.53	3.04	19.91
193	9	16	84XAA04	158.05	8.89	42.75
194	4.8	154	17XGA04	74.4	5.37	28.74
195	3.7	177	17XGA04	42.7	4.65	24.74
196	4.6	157	17XGA04	56.7	6.35	31.16
197	3	191	17XGA04	54.39	3.58	17.21
198	3.6	179	2XT4E04	73.69	3.67	18.59
199	0	208	2XT4E04	0	0	0
200	4	170	2XT4E04	89.89	4.26	19.1
201	0	208	2XT4E04	0	0	0
202	2	203	85XAA04	56.95	2.32	8.57
203	0	208	85XAA04	0	0	0
204	0	208	85XAA04	0	0	0
205	0	208	85XAA04	0	0	0
206	7.9	50	80XAA04	145.28	8.11	36.83
207	0	208	80XAA04	0	0	0
208	5.8	125	80XAA04	95.9	6.78	33.2
209	3.8	175	80XAA04	73.89	5.06	21.42
210	0	208	85XAA04	0	0	0
211	5.4	137	NM6	156.2	2.58	22.68
212	7.8	52	NM6	109.02	7.89	49.14
213	7.4	67	NM6	108.3	7.75	44.86
214	5.3	139	NM6	64.21	6.56	35.44
215	6.5	96	NM6	85.31	8.78	41.6
216	6.1	114	NM6	82.16	8.36	38.58
217	6.7	88	NM6	90.54	9.73	43.3
218	9.2	14	NM6	144.75	12.45	48.3
219	0	208	NM6	0	0	0
220	7.6	58	NM6	150.73	8.76	33.34
221	7.7	57	NM6	143.38	8.3	35.61
222	8.3	34	NM6	156.92	14.59	35.48
223	4.4	163	NM6	127.51	6.89	15.95
224	3.6	180	NM6	121.8	5.47	12.87
225	5.5	134	NM6	162.25	5.06	19.8
226	6.2	106	NM6	131.39	6.1	29.06
227	7.3	70	NM6	132.85	7.16	34.13
228	6.4	98	NM6	102.94	7.3	35.12
229	6.2	107	NM6	104.89	7.57	32.86
230	5.9	122	NM6	99.9	6.92	32.97
231	6.6	93	NM6	195.8	4.41	22.03
232	8.3	35	NM6	230.06	3.61	22.2
233	8.2	41	NM6	171.39	5.95	36.18
234	6.4	99	NM6	156.82	4.67	28.08
235	6.4	100	NM6	159.61	4.9	26.56
236	7.6	59	NM6	171.01	5.95	30.97
237	8.3	36	NM6	171.27	5.96	36.62
238	8.4	31	NM6	166.89	5.56	40.64
239	8.4	32	NM6	185.93	4.32	33.18
240	7.3	71	NM6	184.23	4.36	26.83
241	4.2	166	NM6	148.5	2.18	16.22
242	8.3	37	NM6	182.49	6.95	33.62
243	4.6	158	NM6	149.72	4.19	18.34
244	3.2	187	NM6	133.16	3.14	11.28
245	7.3	72	NM6	193.51	8.47	20.9
246	6.2	108	NM6	167.87	5.83	21.78
247	5.5	135	NM6	157.3	4.61	20.83
248	5.1	144	NM6	150.34	4.05	20.21
249	6.3	103	NM6	166.26	5.29	23.86
250	5.3	140	NM6	147.44	4.02	22.33
251	8.9	20	NM6	183.06	7.07	35.71
252	8.1	43	NM6	227.69	3.51	21.67
\.


--
-- Name: u07m_2013_id_seq; Type: SEQUENCE SET; Schema: public; Owner: user
--

SELECT pg_catalog.setval('u07m_2013_id_seq', 1, false);


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
-- Name: field_trial_pk; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY field_trial
    ADD CONSTRAINT field_trial_pk PRIMARY KEY (id);


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
-- Name: split_wood_tests_pk; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY split_wood_tests
    ADD CONSTRAINT split_wood_tests_pk PRIMARY KEY (id);


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
-- Name: u07m_2013_pk; Type: CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY u07m_2013
    ADD CONSTRAINT u07m_2013_pk PRIMARY KEY (id);


--
-- Name: family_id_taxa_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY family
    ADD CONSTRAINT family_id_taxa_fk FOREIGN KEY (id_taxa) REFERENCES taxa(id);


--
-- Name: field_trial_id_site_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY field_trial
    ADD CONSTRAINT field_trial_id_site_fk FOREIGN KEY (id_site) REFERENCES site(id);


--
-- Name: field_trial_id_test_spec_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY field_trial
    ADD CONSTRAINT field_trial_id_test_spec_fk FOREIGN KEY (id_test_spec) REFERENCES test_spec(id);


--
-- Name: grain_pull_split_wood_tests_id_test_spec_fk; Type: FK CONSTRAINT; Schema: public; Owner: user
--

ALTER TABLE ONLY split_wood_tests
    ADD CONSTRAINT grain_pull_split_wood_tests_id_test_spec_fk FOREIGN KEY (id_test_spec) REFERENCES test_spec(id);


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

