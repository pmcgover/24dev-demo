CREATE TABLE taxa (          
  --taxaTable  tline
  taxa_key VARCHAR(20) UNIQUE,      -- eg AxGA --cline
  id serial,
  notes VARCHAR NOT NULL DEFAULT '0',
  species VARCHAR NOT NULL DEFAULT '0', -- grandidentata Michaux   --cline
  species_hybrid VARCHAR NOT NULL DEFAULT '0', -- eg. Populus ×rouleauiana Boivin  --cline
  common_name VARCHAR NOT NULL DEFAULT '0', --cline
  binomial_name VARCHAR NOT NULL DEFAULT '0', --cline
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
  ploidy_n INTEGER NOT NULL DEFAULT -1,  --eg 2, 3, 4  --cline
  seed_germ_percent NUMERIC NOT NULL DEFAULT '-1' CHECK (seed_germ_percent < 1),  --cline
  seed_germ_date DATE NOT NULL DEFAULT '1111-11-11',  --cline
  cross_date DATE NOT NULL DEFAULT '1111-11-11',  --cline
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
  ploidy_n INTEGER NOT NULL DEFAULT 0,  --eg 2, 3, 4  --cline
  date_aquired DATE NOT NULL DEFAULT '1111-11-11',  --cline
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
  test_type VARCHAR(20) NOT NULL DEFAULT '0' CHECK (test_type in ('0','nursery','breeding','field-planting','field-trial','propagation')),   --cline
  research_hypothesis VARCHAR NOT NULL DEFAULT '0',  --cline
  null_hypothesis VARCHAR NOT NULL DEFAULT '0',  --cline
  reject_null_hypothesis CHAR DEFAULT '0' CHECK (reject_null_hypothesis in ('Y','N','0')), --  eg Yes, No  --cline
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
  start_quantity numeric NOT NULL DEFAULT '-1',  --cline
  end_quantity numeric NOT NULL DEFAULT '-1',  --cline
  this_start_date DATE NOT NULL DEFAULT '1111-11-11',  -- Some entries could have a later start date  --cline
  score_date DATE NOT NULL DEFAULT '1111-11-11',  --cline
  -- stock_type: Unknown, Dormant-Cuttings, Ortet Dormant Cuttings, Root Shoots, SEed, SEedLings, BarerootStock= 1-0, 1-1, 1-2  
  stock_type CHAR(4) NOT NULL DEFAULT 'U' CHECK (stock_type in ('U','ASP','SASP','WASP','SCP','DC','ODC','RS','SE','SEL','1-0','1-1','1-2')),   --cline
  stock_length_cm NUMERIC NOT NULL DEFAULT '-1',  --cline
  stock_dia_mm NUMERIC NOT NULL DEFAULT '-1',  --cline
  nbr_of_stems INTEGER NOT NULL DEFAULT '-1',  --cline
  is_plus_ynu CHAR DEFAULT '0' CHECK (is_plus_ynu in ('Y','N','U','0')), --  eg Yes, No, Unknown  --cline
  collar_median_dia_mm  NUMERIC NOT NULL DEFAULT '-1',  --cline
  dbh_circ_cm NUMERIC NOT NULL DEFAULT '-1',  --cline
  height_cm NUMERIC NOT NULL DEFAULT '-1',  --cline
  bias_3_3 NUMERIC NOT NULL DEFAULT '-4' CHECK (bias_3_3 < 4 AND bias_3_3 > -5), --cline Note that default is -4...  
  leaf_score INTEGER NOT NULL DEFAULT '-1' CHECK (leaf_score < 6),  --cline 
  canker_score INTEGER NOT NULL DEFAULT '-1' CHECK (canker_score < 6),  --cline 
  swasp_score INTEGER NOT NULL DEFAULT '-1' CHECK (swasp_score < 6),  --cline
  id_plant INTEGER NOT NULL,  --cline
  id_family INTEGER NOT NULL,  --cline
  id_test_spec INTEGER NOT NULL,  --cline
  row_nbr NUMERIC NOT NULL DEFAULT '-1',   --cline
  column_nbr NUMERIC NOT NULL DEFAULT '-1',   --cline
  replication_nbr INTEGER NOT NULL DEFAULT '-1',   --cline
  plot_nbr INTEGER NOT NULL DEFAULT '-1',  --cline
  block_nbr INTEGER NOT NULL DEFAULT '-1',   --cline
  CONSTRAINT test_detail_id_family_fk FOREIGN KEY(id_plant) REFERENCES plant(id), 
  CONSTRAINT test_detail_id_plant_fk FOREIGN KEY(id_family) REFERENCES family(id), 
  CONSTRAINT test_detail_id_test_spec_fk FOREIGN KEY(id_test_spec) REFERENCES test_spec(id),
  CONSTRAINT test_detail_pk PRIMARY KEY (id)
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


insert into site (site_key, id, notes, location_code) VALUES ('TBD',1,'To Be Determined','TBD');
insert into site (site_key, id, notes, location_code) VALUES ('NA',2,'Does Not Apply','NA');

insert into test_spec (test_spec_key, id, notes, id_site) VALUES ('TBD',1,'To Be Determined',1);
insert into test_spec (test_spec_key, id, notes, id_site) VALUES ('NA',2,'Does Not Apply',2);

insert into test_detail (test_detail_key, id, notes, notes2, id_plant, id_family, id_test_spec) VALUES ('TBD',-1,'Dummy record used for id_prev_test_detail null values',1,1,2,2);
insert into test_detail (test_detail_key, id, notes, notes2, id_plant, id_family, id_test_spec) VALUES ('TBD',1,'To Be Determined',1,1,2,2);
insert into test_detail (test_detail_key, id, notes, notes2, id_plant, id_family, id_test_spec) VALUES ('NA',2,'Does Not Apply',2,2,2,2);

insert into journal (journal_key, id, notes, id_plant, id_family, id_test_spec, id_site) VALUES ('TBD',1,'To Be Determined',2,2,2,2);
insert into journal (journal_key, id, notes, id_plant, id_family, id_test_spec, id_site) VALUES ('NA',2,'Does Not Apply',2,2,2,2);

-- Command line code below to list the significant tables/columns for reporting:
-- tline - describes lines with table information - cline- describes lines with column information
-- egrep '(tline|cline)'  r4st-Load-AllTables.sql|awk '{print "The", $1 " column describes ", "|",$1,"|", $0}'|sed 's/--cline//g'

