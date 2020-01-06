DROP TABLE if exists family CASCADE;
DROP TABLE if exists plant CASCADE;
DROP TABLE if exists pedigree CASCADE;

CREATE TABLE family (   
  id serial,
  family_key VARCHAR(20) UNIQUE,
  female_plant_id INTEGER NOT NULL DEFAULT 1,  
  male_plant_id INTEGER NOT NULL DEFAULT 1,   
  filial_n INTEGER NOT NULL DEFAULT -1,  -- eg 0,1,2...  Which would represent None, F1, F2... 
  CONSTRAINT family_pk PRIMARY KEY (id)
);

CREATE TABLE plant ( 
  id serial,
  plant_key VARCHAR(20) UNIQUE,
  id_family INTEGER NOT NULL,  
  CONSTRAINT plant_pk PRIMARY KEY (id),
  CONSTRAINT plant_id_family_fk FOREIGN KEY(id_family) REFERENCES family(id) -- temp may need to remove constraint...
);

CREATE TABLE pedigree ( 
id serial,
pedigree_key VARCHAR NOT NULL,
path VARCHAR NOT NULL UNIQUE
);

-- FAMILY Table DATA:
insert into family (id, family_key, female_plant_id, male_plant_id, filial_n) VALUES (1,'NA',1,1,1); -- Default place holder record
-- Root level Alba families
insert into family (id, family_key, female_plant_id, male_plant_id, filial_n) VALUES (2,'family1AA',2,3,1);
insert into family (id, family_key, female_plant_id, male_plant_id, filial_n) VALUES (3,'family2AA',4,5,1);
insert into family (id, family_key, female_plant_id, male_plant_id, filial_n) VALUES (4,'family3AA',6,7,1);
-- F2 Hybrid Families
insert into family (id, family_key, female_plant_id, male_plant_id, filial_n) VALUES (5,'family4AE',8,11,0); 
insert into family (id, family_key, female_plant_id, male_plant_id, filial_n) VALUES (6,'family5AG',9,12,0);
insert into family (id, family_key, female_plant_id, male_plant_id, filial_n) VALUES (7,'family6AT',10,13,0); 

-- F3 Double Hybrid family:
insert into family (id, family_key, female_plant_id, male_plant_id, filial_n) VALUES (9,'family7AEAG',14,15,0);
-- F3 Tri-hybrid backcross family:
insert into family (id, family_key, female_plant_id, male_plant_id, filial_n) VALUES (10,'family8AEAGAT',17,16,0);
-- Yet another root level family:
insert into family (id, family_key, female_plant_id, male_plant_id, filial_n) VALUES (11,'family9EG',20,12,1); 

-------------------- Families with plant used from previous crosses (same plants different familiy names (same plants different familiy names)): 
-- Repeat an F1 family (family6AT -> family11repeatAA) using the same plant parents:    
insert into family (id, family_key, female_plant_id, male_plant_id, filial_n) VALUES (12,'family11repeatAA',2,3,1);
-- Repeat an F2 family (family6AT -> family66repeatAT) using the same plant parents:    
insert into family (id, family_key, female_plant_id, male_plant_id, filial_n) VALUES (13,'family66repeatAT',10,13,0); 
-- Repeat an F3 family (family8AEAGAT > family88repeatAEAGAT) using the same plant parents:
insert into family (id, family_key, female_plant_id, male_plant_id, filial_n) VALUES (14,'family88repeatAEAGAT',17,16,0);
--------------------

-- PLANT Table DATA:
-- Root level Alba Parents: 
insert into plant (id, plant_key,  id_family) VALUES (1,'NA',1);      -- Default place holder record
insert into plant (id, plant_key,  id_family) VALUES (2,'female1A',1); 
insert into plant (id, plant_key,  id_family) VALUES (3,'male1A',1);
insert into plant (id, plant_key,  id_family) VALUES (4,'female2A',1);
insert into plant (id, plant_key,  id_family) VALUES (5,'male2A',1);
insert into plant (id, plant_key,  id_family) VALUES (6,'female3A',1); 
insert into plant (id, plant_key,  id_family) VALUES (7,'male3A',1);
-- Female Alba progeny:
insert into plant (id, plant_key,  id_family) VALUES (8,'female4A',2);
insert into plant (id, plant_key,  id_family) VALUES (9,'female5A',3);
insert into plant (id, plant_key,  id_family) VALUES (10,'female6A',4);
-- Male Aspen Root level parents:
insert into plant (id, plant_key,  id_family) VALUES (11,'male1E',1); 
insert into plant (id, plant_key,  id_family) VALUES (12,'male1G',1);  
insert into plant (id, plant_key,  id_family) VALUES (13,'female1T',1);
-- F1 Hybrid progeny:
insert into plant (id, plant_key,  id_family) VALUES (14,'female1AE',5); 
insert into plant (id, plant_key,  id_family) VALUES (15,'male1AG',6);  
insert into plant (id, plant_key,  id_family) VALUES (16,'male1AT',7);
-- Hybrid progeny
insert into plant (id, plant_key,  id_family) VALUES (17,'female1AEAG',9);
-- Tri-hybrid backcross progeny:
insert into plant (id, plant_key,  id_family) VALUES (18,'female1AEAGAT',10);
insert into plant (id, plant_key,  id_family) VALUES (19,'female2AEAGAT',10);
-- A root level E parent:
insert into plant (id, plant_key,  id_family) VALUES (20,'female1E',1);


-- Below is the desired linear output for the above data: 
--F1 family1AA=(female1A x male1A) > F2 family4AE=(female4A x male1E) > F3 family7AEAG=(female1AE x male1AG) > F4 family8AEAGAT=(female1AEAG x male1AT)  
--F1 family2AA=(female2A x male2A) > F2 family5AG=(female5A x male1G) > F3 family7AEAG=(female1AE x male1AG) > F4 family8AEAGAT=(female1AEAG x male1AT) 
--F1 family3AA=(female3A x male3A) > F2 family6AT=(female6A x female1T) > F3 family8AEAGAT=(female1AEAG x male1AT) 
--F1 family3AA=(female3A x male3A) > F2 family66AT=(female6A x female1T)

