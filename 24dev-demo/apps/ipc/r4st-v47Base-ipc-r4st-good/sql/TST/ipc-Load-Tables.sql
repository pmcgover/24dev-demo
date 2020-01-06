DROP TABLE if exists ipc_original_salix_epithet CASCADE;
DROP TABLE if exists ipc_salix_epithet CASCADE;
DROP TABLE if exists ipc_salix_species CASCADE;
DROP TABLE if exists ipc_salix_family CASCADE;

CREATE TABLE ipc_original_salix_epithet ( 
id_sorted serial,
id_orig INTEGER NOT NULL,  
epithet_cleaned VARCHAR,
species_cleaned VARCHAR,
mother_cleaned VARCHAR,
father_cleaned VARCHAR,
epithet VARCHAR,
synonyms_experimental_codes VARCHAR,
trade_designations VARCHAR,
species_orig VARCHAR,
section VARCHAR,
etymology VARCHAR,
propagation VARCHAR,
sex VARCHAR,
reference_to_publication_of_the_epithet VARCHAR,
reference_to_breeders_right VARCHAR,
reference_to_identification_tests VARCHAR,
awards VARCHAR,
source_of_the_base_material VARCHAR,
year VARCHAR,
Interspecific VARCHAR, 
mother VARCHAR,
father VARCHAR,
latitude_and_longitude_of_mother VARCHAR,
latitude_and_longitude_of_father VARCHAR,
latitude_and_longitude_of_place_of_origin VARCHAR,
place_of_origin VARCHAR,
description_o VARCHAR,
originator_breeder VARCHAR,
registrant VARCHAR,
nominator VARCHAR,
introducer VARCHAR,
keeper VARCHAR,
originator_description VARCHAR,
registrant_breeder_description VARCHAR,
nominator_description VARCHAR,
introducer_description VARCHAR,
keeper_description VARCHAR,
reference_related_to_DNA VARCHAR,
Standard_Herbarium VARCHAR,
Name_status VARCHAR,
Note_on_name_status VARCHAR,
Current_cultivation VARCHAR,
record_in_Checklist_Register VARCHAR,
CONSTRAINT ipc_original_salix_epithet_pk PRIMARY KEY (id_sorted)
);

CREATE TABLE ipc_salix_family ( 
id_family serial,
family_key VARCHAR NOT NULL UNIQUE, 
mother VARCHAR NOT NULL DEFAULT 'N/A',
father  VARCHAR NOT NULL DEFAULT 'N/A',	
mother_epithet_id INTEGER NOT NULL DEFAULT 1,  
father_epithet_id INTEGER NOT NULL DEFAULT 1,  
is_root varCHAR NOT NULL DEFAULT '0',
description_f VARCHAR NOT NULL DEFAULT 'N/A',
year_bred VARCHAR NOT NULL DEFAULT 'N/A',
female_parent_species VARCHAR NOT NULL DEFAULT 'N/A',
female_parent_clone VARCHAR NOT NULL DEFAULT 'N/A',
male_parent_species VARCHAR NOT NULL DEFAULT 'N/A',
male_parent_clone VARCHAR NOT NULL DEFAULT 'N/A',
f_web_url_1 VARCHAR NOT NULL DEFAULT 'N/A',
f_web_url_2 VARCHAR NOT NULL DEFAULT 'N/A',
CONSTRAINT ipc_salix_family_pk PRIMARY KEY (id_family)
);

CREATE TABLE ipc_salix_epithet ( 
id_epithet serial,
epithet_key VARCHAR NOT NULL UNIQUE,
epithet VARCHAR NOT NULL DEFAULT 'N/A',
alternate_name VARCHAR,
trade_designations VARCHAR,
species_id INTEGER NOT NULL,
etymology VARCHAR,
sex VARCHAR, 
reference_epithet VARCHAR,
reference_breeders VARCHAR,
reference_tests VARCHAR,
awards VARCHAR,
source_type VARCHAR,
year_selected VARCHAR,
Interspecific_hybrid VARCHAR,
family_id INTEGER NOT NULL,
origin_place VARCHAR, 
description_e VARCHAR,
originator_breeder VARCHAR,
registrant VARCHAR, nominator VARCHAR, introducer VARCHAR,
keeper VARCHAR,
nominator_desc VARCHAR,
standard_herbarium VARCHAR, 
name_status VARCHAR, 
name_status_note VARCHAR, 
current_cultivation VARCHAR,
checklist_record VARCHAR,
contact_info VARCHAR,
CONSTRAINT ipc_salix_epithet_pk PRIMARY KEY (id_epithet)
);

CREATE TABLE ipc_salix_species ( 
id_species serial,
species VARCHAR NOT NULL UNIQUE,
description_s VARCHAR  NOT NULL DEFAULT 'N/A',
s_web_url_1 VARCHAR NOT NULL DEFAULT 'N/A',
s_web_url_2 VARCHAR NOT NULL DEFAULT 'N/A',
CONSTRAINT ipc_salix_species_pk PRIMARY KEY (id_species)
);

CREATE TABLE ipc_pedigree ( 
id serial,
-- pedigreeTable tline
pedigree_key VARCHAR NOT NULL,
path VARCHAR NOT NULL UNIQUE
);

