DROP TABLE if exists ptst_family CASCADE;
DROP TABLE if exists ptst_plant CASCADE;
DROP TABLE if exists ptst_pedigree CASCADE;

CREATE TABLE ptst_family (  
  id serial,
  family_key VARCHAR(20) UNIQUE,
  female_plant_id INTEGER NOT NULL DEFAULT 1,  
  male_plant_id INTEGER NOT NULL DEFAULT 1,  
  is_root VARCHAR NOT NULL DEFAULT '0',  -- Root level familes are always the first level pedigree (F1)
  CONSTRAINT ptst_family_pk PRIMARY KEY (id)
);

CREATE TABLE ptst_plant (
  id serial,
  plant_key VARCHAR(20) UNIQUE,
  id_family INTEGER NOT NULL,  
  CONSTRAINT ptst_plant_pk PRIMARY KEY (id),
  CONSTRAINT ptst_plant_id_family_fk FOREIGN KEY(id_family) REFERENCES ptst_family(id) 
);

CREATE TABLE ptst_pedigree (
id serial,
pedigree_key VARCHAR NOT NULL,
path VARCHAR NOT NULL UNIQUE
);

-- Root Level families:
insert into ptst_family (id, family_key, female_plant_id, male_plant_id, is_root) VALUES (1,'N/A',1,1,'N'); -- Default place holder Family record
insert into ptst_family (id, family_key, female_plant_id, male_plant_id, is_root) VALUES (2,'1XGG',2,3,'Y');
-- F2 Level Family (Not Root Level):
insert into ptst_family (id, family_key, female_plant_id, male_plant_id, is_root) VALUES (3,'6XGG',4,5,'N');

-- PLANT Table DATA:
-- Root level Parents:
insert into ptst_plant (id, plant_key,  id_family) VALUES (1,'NA',1);      -- Default place holder record
insert into ptst_plant (id, plant_key,  id_family) VALUES (2,'BT044',1);
insert into ptst_plant (id, plant_key,  id_family) VALUES (3,'BT016',1);
insert into ptst_plant (id, plant_key,  id_family) VALUES (4,'GG102',2);
insert into ptst_plant (id, plant_key,  id_family) VALUES (5,'GG12',1);


