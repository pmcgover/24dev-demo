CREATE TABLE taxa (          
  --taxaTable  tline
  taxa_key VARCHAR(20) UNIQUE,      -- eg AxGA --cline
  id serial,
  notes VARCHAR NOT NULL DEFAULT '0',
  species VARCHAR NOT NULL DEFAULT '0', -- grandidentata Michaux   --cline
  species_hybrid VARCHAR NOT NULL DEFAULT '0', -- eg. Populus ×rouleauiana Boivin  --cline
  common_name VARCHAR NOT NULL DEFAULT '0', --cline
  binomial_name VARCHAR NOT NULL DEFAULT '0', --cline
  -- class CHAR(6) NOT NULL DEFAULT 'U' CHECK (class in ('U','AA','AH','H','C','N')), --cline --Moved to the plant table for easier updates. 
  kingdom VARCHAR NOT NULL DEFAULT '0', --cline
  family VARCHAR NOT NULL DEFAULT '0', --cline
  genus VARCHAR NOT NULL DEFAULT '0', --cline
  web_photos VARCHAR NOT NULL DEFAULT '0', 
  web_url VARCHAR NOT NULL DEFAULT '0',
  CONSTRAINT taxa_pk PRIMARY KEY (id),
  CONSTRAINT taxa_check  CHECK (species = '0' OR species_hybrid = '0')
);

CREATE TABLE family (   
  --familyTable   tline 
  family_key VARCHAR(20) UNIQUE,
  id serial,
  notes VARCHAR NOT NULL DEFAULT '0',
  female_plant_id INTEGER NOT NULL DEFAULT 1, --cline 
  male_plant_id INTEGER NOT NULL DEFAULT 1,  --cline 
  seed_notes VARCHAR NOT NULL DEFAULT '0',   --cline
  form_fnmwu CHAR NOT NULL DEFAULT 'U' CHECK (form_fnmwu in ('U','F','N','M','W')),     --eg Unknown, Fastigate, Narrow, Medium, Wide  --cline
  is_plus CHAR NOT NULL DEFAULT 'U' CHECK (is_plus in ('N','Y','U')), -- eg Yes, No, Unknown --cline
  is_root varCHAR NOT NULL DEFAULT '0',  
  seeds_in_storage NUMERIC NOT NULL DEFAULT -1, --cline
  seed_germ_percent NUMERIC NOT NULL DEFAULT '-1' CHECK (seed_germ_percent < 1),  --cline
  seed_germ_date DATE NOT NULL DEFAULT '1111-11-11',  --cline
  cross_date DATE NOT NULL DEFAULT '1111-11-11',  --cline
  project_phase NUMERIC NOT NULL DEFAULT '-1', --cline - High Project Phases may span multiple years or be sub-sets (eg. 1.1, 1.2, 2, etc)
  id_taxa INTEGER NOT NULL,  --cline 
  web_photos VARCHAR NOT NULL DEFAULT '0',
  web_url VARCHAR NOT NULL DEFAULT '0',
  CONSTRAINT family_pk PRIMARY KEY (id),
  CONSTRAINT family_id_taxa_fk FOREIGN KEY(id_taxa) REFERENCES taxa(id)
);


CREATE TABLE plant ( 
  --plantTable    tline 
  plant_key VARCHAR(20) UNIQUE,
  id serial,
  notes VARCHAR NOT NULL DEFAULT '0',
  sex_mfbu CHAR NOT NULL DEFAULT 'U' CHECK (sex_mfbu in ('U','M','F','B')), -- eg Male, Female, Bisexual, Unknown  --cline
  published_botanical_name VARCHAR NOT NULL DEFAULT '0', --cline
  common_name VARCHAR NOT NULL DEFAULT '0',  --cline 
  alternate_name VARCHAR NOT NULL DEFAULT '0',  --cline
  aquired_from VARCHAR NOT NULL DEFAULT '0',  --cline
  female_external_parent VARCHAR NOT NULL DEFAULT '0',  -- The FEMALE parent name derived from an external breeding program   --cline
  male_external_parent VARCHAR NOT NULL DEFAULT '0',    -- The MALE parent name derived from an external breeding program   --cline
  form_fnmwu CHAR NOT NULL DEFAULT 'U' CHECK (form_fnmwu in ('U','F','N','M','W')),     --eg Unknown, Fastigate, Narrow, Medium, Wide  --cline
  is_plus CHAR NOT NULL DEFAULT 'U' CHECK (is_plus in ('N','Y','U')), -- eg Yes, No, Unknown  --cline
  is_cultivar CHAR NOT NULL DEFAULT 'U' CHECK (is_cultivar in ('N','Y','U')), --eg Yes, No, Unknown  --cline
  is_variety CHAR NOT NULL DEFAULT 'U' CHECK (is_variety in ('N','Y','U')),  --cline
  is_from_wild CHAR NOT NULL DEFAULT 'U' CHECK (is_from_wild in ('N','Y','U')),  --eg Was the plant found in the wild - Yes, No, Unknown  --cline
  ploidy_n INTEGER NOT NULL DEFAULT -1,  --eg -1 (Unknown), 2, 3, 4  --cline
  date_aquired DATE NOT NULL DEFAULT '1111-11-11',  --cline
  --alba_class notes: U=Unknown, A=Alba 100% alba, AH=Alba Hybrid >50% alba, H=Hybrid =50% alba, C=Control (non alba), ASO=Aspen Other, ASA=Aspen American native --cline
  alba_class VARCHAR(3) NOT NULL DEFAULT 'U' CHECK (alba_class in ('U','A','AH','ASH','ASA','ASO','H','C')), 
  id_taxa INTEGER NOT NULL,  --cline
  id_family INTEGER NOT NULL,  --cline
  web_photos VARCHAR NOT NULL DEFAULT '0',
  web_url VARCHAR NOT NULL DEFAULT '0',
  CONSTRAINT plant_pk PRIMARY KEY (id),
  CONSTRAINT plant_id_taxa_fk FOREIGN KEY(id_taxa) REFERENCES taxa(id),
  CONSTRAINT plant_id_family_fk FOREIGN KEY(id_family) REFERENCES family(id) -- temp may need to remove constraint...
);

CREATE TABLE pedigree ( 
id serial,
-- pedigreeTable tline
pedigree_key VARCHAR NOT NULL,
path VARCHAR NOT NULL UNIQUE
);

insert into taxa (taxa_key, id, notes, species_hybrid) VALUES ('TBD',1,'To Be Determined','NA');
insert into taxa (taxa_key, id, notes, species) VALUES ('NA',2,'Does Not Apply - See Taxa table for separate hybrid taxa definitions.','NA');

insert into family (family_key, id, notes, id_taxa) VALUES ('TBD',1,'To Be Determined',2);
insert into family (family_key, id, notes, id_taxa) VALUES ('NA',2,'Does Not Apply',2);

insert into plant (plant_key, id, notes, id_taxa, id_family) VALUES ('TBD',1,'To Be Determined',2,2);
insert into plant (plant_key, id, notes, id_taxa, id_family) VALUES ('NA',2,'Does Not Apply',2,2);

-- Lists the location of a site for the focus of the test
CREATE TABLE site ( 
  --siteTable    tline 
  site_key VARCHAR(50) NOT NULL	UNIQUE,
  id serial,
  location_code VARCHAR(5) NOT NULL UNIQUE, -- An abreviated location code for use in the spec/detail/score tables  --cline
  name_long VARCHAR NOT NULL DEFAULT '0',  --cline
  notes VARCHAR NOT NULL DEFAULT '0',  --cline
  address VARCHAR NOT NULL DEFAULT '0',  --cline
  loc_lat VARCHAR NOT NULL DEFAULT '0',  --cline
  loc_long VARCHAR NOT NULL DEFAULT '0',  --cline
  elevation_ft NUMERIC NOT NULL DEFAULT '0',  --cline
  aspen_site_index VARCHAR NOT NULL DEFAULT '0',  --cline
  usda_soil_texture VARCHAR NOT NULL DEFAULT '0',  --cline
  drainage_class_usda VARCHAR(3) NOT NULL DEFAULT 'U' CHECK (drainage_class_usda in ('U','VPD','PD','SPD','MWD','WD','SED','ED')), --eg Unknown  --cline
  mean_annual_precip_in NUMERIC NOT NULL DEFAULT '0',  --cline
  mean_annual_temp_f NUMERIC NOT NULL DEFAULT '0',  --cline
  frost_free_period_days NUMERIC NOT NULL DEFAULT '0',  --cline
  depth_to_water_table_in NUMERIC NOT NULL DEFAULT '0',  --cline
  usda_map_url VARCHAR NOT NULL DEFAULT '0',  --cline
  web_url VARCHAR NOT NULL DEFAULT '0',
  web_photos VARCHAR NOT NULL DEFAULT '0',
  contact VARCHAR NOT NULL DEFAULT '0',  --cline
  CONSTRAINT site_pk PRIMARY KEY (id)
);


-- Listing of test specifications for experimental tests
CREATE TABLE test_spec ( 
  --test_SpecTable    tline 
  test_spec_key VARCHAR(50) NOT NULL  UNIQUE, 
  id serial,
  notes VARCHAR NOT NULL DEFAULT '0',
  activity_type VARCHAR(5) NOT NULL DEFAULT '0' CHECK (activity_type in ('0','TRIAL','EVENT')),   --cline
  test_type VARCHAR(20) NOT NULL DEFAULT '0' CHECK (test_type in ('0','nursery','breeding','propagation','archive-planting','family-trial','clonal-trial','gpft')),   --cline
  -- stock_type: Unknown, Not-Apply, Dormant-Cuttings, MiniStools, SEedLings, BarerootStock= 1-0, 1-1, 1-2  
  stock_type CHAR(6) NOT NULL DEFAULT 'U' CHECK (stock_type in ('U','NA','MIX','WHIP','WASP','DC','MS','SEL','1-0','1-1','1-2')),   --cline
  stock_length_cm NUMERIC NOT NULL DEFAULT '-1',  --cline
  stock_collar_dia_mm NUMERIC NOT NULL DEFAULT '-1',  --cline
  research_hypothesis VARCHAR NOT NULL DEFAULT '0',  --cline
  web_protocol VARCHAR NOT NULL DEFAULT '0',  --cline
  web_url VARCHAR NOT NULL DEFAULT '0',  
  web_photos VARCHAR NOT NULL DEFAULT '0',  
  test_start_date DATE NOT NULL DEFAULT '1111-11-11',  --cline
  id_site INTEGER NOT NULL,  --cline
  CONSTRAINT test_spec_id_site_fk FOREIGN KEY(id_site) REFERENCES site(id),
  CONSTRAINT test_spec_pk PRIMARY KEY (id)
);

CREATE TABLE test_detail ( 
  --test_detail Table    tline 
  test_detail_key VARCHAR(50) NOT NULL DEFAULT '0',  -- Not unique, since it really represents a clone or familiy ID... 
  id serial,
  notes VARCHAR NOT NULL DEFAULT '0',
  notes2 VARCHAR NOT NULL DEFAULT '0',
  notes3 VARCHAR NOT NULL DEFAULT '0',
  todo VARCHAR NOT NULL DEFAULT '0',
  planted_order numeric NOT NULL DEFAULT '-1',  --cline
  -- selection_type: U=unknown, P=Primary/elite, S=Secondary/archive, T=Tertiary/Parent, F=Family, R=Retest, E=Exotic (figured) D=Discard
  selection_type CHAR NOT NULL DEFAULT 'U' CHECK (selection_type in ('U','P','S','T','F','R','H','E','D')),   --cline
  nursery_cuttings_ft NUMERIC NOT NULL DEFAULT '-1',  --cline
  start_quantity numeric NOT NULL DEFAULT '-1',  --cline
  end_quantity numeric NOT NULL DEFAULT '-1',  --cline
  this_start_date DATE NOT NULL DEFAULT '1111-11-11',  -- Some entries could have a later start date  --cline
  score_date DATE NOT NULL DEFAULT '1111-11-11',  --cline
  -- stock_type: Unknown, Dormant-Cuttings, Ortet DC, Family DC, MiniStools, DCMinisStools, Root Shoots, RooTLing, SEedLings, LayeredAspenWhips, BarerootStock= 1-0, 1-1  
  stock_type CHAR(6) NOT NULL DEFAULT 'U' CHECK (stock_type in ('U','ASP','SASP','WASP','DC','ODC','FDC','MS','DCMS','RS','RTL','SEL','LAW','1-0','1-1')),   --cline
  stock_length_cm NUMERIC NOT NULL DEFAULT '-1',  --cline
  stock_dia_mm NUMERIC NOT NULL DEFAULT '-1',  --cline
  is_plus_ynu CHAR DEFAULT '0' CHECK (is_plus_ynu in ('Y','N','U','0')), --  eg Yes, No, Unknown  --cline
  collar_median_dia_mm  NUMERIC NOT NULL DEFAULT '-1',  --cline
  collar_1_1_median_dia  NUMERIC NOT NULL DEFAULT '-1',  --cline
  stool_collar_median_dia_mm  NUMERIC NOT NULL DEFAULT '-1',  --cline
  height_cm NUMERIC NOT NULL DEFAULT '-1',  --cline
  -- leaf_score description: 
  -- -1= Not scored. 
  -- 1= Over 50% of crown defoliated by leaf issues. 
  -- 2= About 25% of crown defoliated by leaf issues.
  -- 3= Significant leaf issues without defoliation.
  -- 4= A few leaf issues, no defoliation,
  -- 5= No leaf issues.
  leaf_score INTEGER NOT NULL DEFAULT '-1' CHECK (leaf_score < 6),  --cline 
 -- Adventitious Rooting (AR) score description: Roots that arise from an organ other than the root (e.g. stem). 
 -- In this context it refers to adventitious rooting, regardless of size or quantity that originates from the side of a dormant stem cutting. 
  -- ar_score description: 
  -- -1= Not scored. 
  -- 1= No adventious rooting on any cuttings. 
  -- 2= Some cuttings have adventious rooting.
  -- 3= All cuttings should have some adventious rooting, with an average AR root sum < 15 mm.
  -- 4= All cuttings have adventious rooting, with an average AR root sum between 15 and 20 mm.
  -- 5= All cuttings have consistent adventious rooting, with an average AR root sum over 20 mm.  
  ar_score INTEGER NOT NULL DEFAULT '-1' CHECK (ar_score < 6),  --cline 
  id_test_spec INTEGER NOT NULL,  --cline
  row_nbr NUMERIC NOT NULL DEFAULT '-1',   --cline
  column_nbr NUMERIC NOT NULL DEFAULT '-1',   --cline
  replication_nbr INTEGER NOT NULL DEFAULT '-1',   --cline
  plot_nbr INTEGER NOT NULL DEFAULT '-1',  --cline
  block_nbr INTEGER NOT NULL DEFAULT '-1',   --cline
  CONSTRAINT test_detail_id_test_spec_fk FOREIGN KEY(id_test_spec) REFERENCES test_spec(id),
  CONSTRAINT test_detail_pk PRIMARY KEY (id)
);


CREATE TABLE field_trial ( 
  --field_trial Table    tline 
  field_trial_key VARCHAR(50) NOT NULL DEFAULT '0',  -- Not unique, since it can hold many copies of the same clones.
  id serial,
  notes VARCHAR NOT NULL DEFAULT '0',
  notes2 VARCHAR NOT NULL DEFAULT '0',
  notes3 VARCHAR NOT NULL DEFAULT '0',
  planted_order numeric NOT NULL DEFAULT '-1', 
  ft_stock_type CHAR(3) NOT NULL DEFAULT 'U' CHECK (ft_stock_type in ('U','DC','MS','SEL','LAW','1-0','1-1')),   --cline
  ft_stock_length_cm NUMERIC NOT NULL DEFAULT '-1',  --cline
  year_planted CHAR(4) NOT NULL DEFAULT '0', 
  live_quantity numeric NOT NULL DEFAULT '-1',  --cline
  is_plus_ynu CHAR DEFAULT '0' CHECK (is_plus_ynu in ('Y','N','U','0')), --  eg Yes, No, Unknown  --cline
  live_dbh_cm NUMERIC NOT NULL DEFAULT '-1',  --cline
  live_height_cm NUMERIC NOT NULL DEFAULT '-1',  --cline 
  -- leaf_score description: -1 = Not scored. 1= Over 50% of crown affected by leaf issues, major defoliation, 
  -- 2= About 25% of crown affected by leaf issues and defoliation. 3= Leaves moderately affected with minor defoliation,
  -- 4= A few leaf issues, no defoliation,
  -- 5= No leaf issues.
  field_cuttings_ft NUMERIC NOT NULL DEFAULT '-1',  --cline
  leaf_score INTEGER NOT NULL DEFAULT '-1' CHECK (leaf_score < 6),  --cline 
  canker_score INTEGER NOT NULL DEFAULT '-1' CHECK (canker_score < 6),  --cline 
  -- tree_spacing_ft: Unknown,NA,MIX,4x4,4x6,8x7,8x8,8x10,9x9
  tree_spacing_ft CHAR(5) NOT NULL DEFAULT 'U' CHECK (tree_spacing_ft in ('U','NA','MIX','4x4','4x6','5x8','5x10','8x7','8x8','9x9','8x10','10x10')),   --cline
  row_nbr NUMERIC NOT NULL DEFAULT '-1',   --cline
  column_nbr NUMERIC NOT NULL DEFAULT '-1',   --cline
  replication_nbr INTEGER NOT NULL DEFAULT '-1',   --cline
  plot_nbr INTEGER NOT NULL DEFAULT '-1',  --cline
  block_nbr INTEGER NOT NULL DEFAULT '-1',   --cline
  id_test_spec INTEGER NOT NULL,  --cline
  id_site INTEGER NOT NULL,  --cline
  CONSTRAINT field_trial_id_site_fk FOREIGN KEY(id_site) REFERENCES site(id),
  CONSTRAINT field_trial_id_test_spec_fk FOREIGN KEY(id_test_spec) REFERENCES test_spec(id),
  CONSTRAINT field_trial_pk PRIMARY KEY (id)
);


CREATE TABLE split_wood_tests ( 
  -- split_wood_tests Table    tline 
  swt_key VARCHAR(50) NOT NULL DEFAULT '0',  -- Not unique, since it can hold many copies of the same clones.
  id serial,
  notes VARCHAR NOT NULL DEFAULT '0',
  notes2 VARCHAR NOT NULL DEFAULT '0',
  cutting_order numeric NOT NULL DEFAULT '-1', 
  stem_dia_small_end_mm numeric NOT NULL DEFAULT '-1',  --cline
  length_of_split_in numeric NOT NULL DEFAULT '-1',  --cline
  grain_pull_force_lb numeric NOT NULL DEFAULT '-1',  --cline
  --undulation_level: -1=Unknown, 0=None (A502), 1=Low (AGRR1 light,inconsistent), 2=Med (25r61 heavier), 3=High (25r23 significant)
  undulation_level numeric NOT NULL DEFAULT '-1', CHECK (undulation_level < 4),  --cline 
  gpf_test_set CHAR(1) NOT NULL DEFAULT 'N' CHECK (gpf_test_set in ('Y','N')), --cline 
  replication_nbr INTEGER NOT NULL DEFAULT '-1',   --cline
  id_test_spec INTEGER NOT NULL,  --cline
  CONSTRAINT grain_pull_split_wood_tests_id_test_spec_fk FOREIGN KEY(id_test_spec) REFERENCES test_spec(id),
  CONSTRAINT split_wood_tests_pk PRIMARY KEY (id)
);


CREATE TABLE journal ( 
  --journalTable    tline 
  journal_key VARCHAR(50) NOT NULL DEFAULT '0',  -- Not unique, since it really represents a clone or familiy ID... 
  id serial,
  notes VARCHAR NOT NULL DEFAULT '0',
  author VARCHAR(50) NOT NULL DEFAULT '0',   --cline
  id_plant INTEGER NOT NULL,  --cline
  id_family INTEGER NOT NULL,  --cline
  id_test_spec INTEGER NOT NULL,  --cline
  id_site INTEGER NOT NULL,  --cline
  date DATE NOT NULL DEFAULT '1111-11-11',  --cline
  web_url VARCHAR NOT NULL DEFAULT '0',  --cline
  CONSTRAINT journal_id_family_fk FOREIGN KEY(id_plant) REFERENCES plant(id), 
  CONSTRAINT journal_id_plant_fk FOREIGN KEY(id_family) REFERENCES family(id), 
  CONSTRAINT journal_id_test_spec_fk FOREIGN KEY(id_test_spec) REFERENCES test_spec(id),
  CONSTRAINT journal_id_site_fk FOREIGN KEY(id_site) REFERENCES site(id),
  CONSTRAINT journal_pk PRIMARY KEY (id)
);


CREATE TABLE u07m_2013 ( 
  -- u07m_2013 Table  tline 
  id serial,
  dbh NUMERIC NOT NULL,
  dbh_rank INTEGER NOT NULL, 
  name VARCHAR NOT NULL, 
  area_index NUMERIC NOT NULL, 
  sum_dbh_ratio2_cd NUMERIC NOT NULL,
  sdbh_x_cavg NUMERIC NOT NULL, 
  CONSTRAINT u07m_2013_pk PRIMARY KEY (id)
);

insert into site (site_key, id, notes, location_code) VALUES ('TBD',1,'To Be Determined','TBD');
insert into site (site_key, id, notes, location_code) VALUES ('NA',2,'Does Not Apply','NA');

insert into test_spec (test_spec_key, id, notes, id_site) VALUES ('TBD',1,'To Be Determined',1);
insert into test_spec (test_spec_key, id, notes, id_site) VALUES ('NA',2,'Does Not Apply',2);

insert into test_detail (test_detail_key, id, notes, notes2, id_test_spec) VALUES ('TBD',-1,'Dummy record used for id_prev_test_detail null values',1,2);
insert into test_detail (test_detail_key, id, notes, notes2, id_test_spec) VALUES ('TBD',1,'To Be Determined',1,2);
insert into test_detail (test_detail_key, id, notes, notes2, id_test_spec) VALUES ('NA',2,'Does Not Apply',2,2);

insert into field_trial (field_trial_key, id, notes, notes2, id_test_spec, id_site) VALUES ('TBD',-1,'Dummy record used for id_prev_test_detail null values',1,2,2);
insert into field_trial (field_trial_key, id, notes, notes2, id_test_spec, id_site) VALUES ('TBD',1,'To Be Determined',1,2,2);
insert into field_trial (field_trial_key, id, notes, notes2, id_test_spec, id_site) VALUES ('NA',2,'Does Not Apply',2,2,2);

insert into split_wood_tests (swt_key, id, notes, notes2, id_test_spec) VALUES ('TBD',1,'To Be Determined',1,2);
insert into split_wood_tests (swt_key, id, notes, notes2, id_test_spec) VALUES ('NA',2,'Does Not Apply',2,2);

insert into journal (journal_key, id, notes, id_plant, id_family, id_test_spec, id_site) VALUES ('TBD',1,'To Be Determined',2,2,2,2);
insert into journal (journal_key, id, notes, id_plant, id_family, id_test_spec, id_site) VALUES ('NA',2,'Does Not Apply',2,2,2,2);

-- Command line code below to list the significant tables/columns for reporting:
---- tline - describes lines with table information - cline- describes lines with column information
-- egrep '(tline|cline)'  r4st-Load-AllTables.sql|awk '{print "The", $1 " column describes ", "|",$1,"|", $0}'|sed 's/--cline//g'

