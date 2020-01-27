CREATE VIEW associate_orig_and_new_salix_tables AS 
SELECT o.id_sorted o_id_sorted,
o.epithet_cleaned o_epithet_cleaned,
o.species_cleaned o_species_cleaned,
o.mother_cleaned o_mother_cleaned,
o.father_cleaned o_father_cleaned,
e.id_epithet e_id_epithet,
e.epithet e_epithet,
e.family_id e_family_id,
f.id_family f_id_family,
f.mother f_mother,
f.father f_father
FROM  ipc_original_salix_epithet o,
ipc_salix_epithet e,
ipc_salix_family f
WHERE o.id_sorted = e.id_epithet
AND e.family_id = f.id_family
ORDER BY o.id_sorted;

CREATE VIEW associate_original_to_epithet_data AS
SELECT o.id_sorted o_id_sorted,
o.epithet_cleaned o_epithet_cleaned,
o.species_cleaned o_species,
o.mother_cleaned o_mother_cleaned,
o.father_cleaned o_father_cleaned,
e.id_epithet e_id_epithet,
e.epithet e_epithet_name,
e.family_id e_family_id,
f.id_family f_id_family,
f.mother f_mother,    
f.father f_father
FROM ipc_original_salix_epithet o,
ipc_salix_epithet e,
ipc_salix_family f
WHERE o.id_sorted = e.id_epithet
AND e.family_id = f.id_family   
ORDER BY o.id_sorted;

CREATE VIEW associate_all_parents AS
SELECT o.id_sorted o_id_sorted,
o.epithet_cleaned o_epithet_cleaned,
o.mother_cleaned o_mother_cleaned,
o.father_cleaned o_father_cleaned,
e.id_epithet e_id_epithet,
e.epithet e_epithet_name,
e.family_id e_family_id,
f.id_family f_id_family,
f.mother f_mother,    
f.father f_father
FROM ipc_original_salix_epithet o,
ipc_salix_epithet e,
ipc_salix_family f
WHERE o.id_sorted = e.id_epithet
AND o.mother_cleaned = f.mother 
AND o.father_cleaned = f.father
ORDER BY o.id_sorted;


CREATE VIEW avw_ipc_salix_epithet AS
SELECT e.id_epithet,
e.epithet_key,
e.epithet,
e.alternate_name,
e.trade_designations,
e.species,
e.species_web_url,
e.etymology,
e.sex,
e.reference_epithet,
e.reference_breeders,
e.reference_tests,
e.end_use,
e.awards,
e.source_type,
e.year_selected,
e.interspecific_hybrid,
e.family_id,
f.family_key AS f_family_name,
e.origin_place,
e.description_e,
e.originator_breeder,
e.registrant,
e.keeper,
e.nominator_desc,
e.standard_herbarium,
e.name_status,
e.name_status_note,
e.current_cultivation,
e.checklist_record
FROM ipc_salix_epithet e,
ipc_salix_family f
WHERE e.family_id = f.id_family;

CREATE VIEW avw_ipc_salix_family AS
SELECT
f.id_family,
f.family_key, 
f.mother,
f.father,
e1.epithet_key AS mother_epithet_key,
e2.epithet_key AS father_epithet_key,
f.is_root,
f.description_f,
f.year_bred
FROM ipc_salix_family f,
ipc_salix_epithet e1,
ipc_salix_epithet e2
WHERE f.mother_epithet_id = e1.id_epithet
AND f.father_epithet_id = e2.id_epithet
ORDER BY id_family;

CREATE VIEW vw1_test_original_minus_epithet_key_data AS
SELECT o.id_sorted, epithet_cleaned, o.species_cleaned, o.mother_cleaned,father_cleaned
FROM ipc_original_salix_epithet o
EXCEPT
SELECT e.id_epithet, e.epithet, e.species,  f.mother, f.father
FROM ipc_salix_family f,
ipc_salix_epithet e
WHERE e.family_id = f.id_family;

CREATE VIEW vw2_all_ipc_salix_epithet_family AS 
SELECT e.* , f.*
FROM avw_ipc_salix_family f
LEFT JOIN avw_ipc_salix_epithet e
ON e.family_id = f.id_family
order by e.id_epithet;


CREATE VIEW vw3_checklist_root_level_epithet AS 
SELECT *
FROM avw_ipc_salix_epithet e
WHERE e.description_e LIKE 'Hypothetical, for Pedigree testing%'
AND family_id = 1
ORDER BY e.id_epithet;


CREATE VIEW vw4_checklist_epithet_family AS 
SELECT e.* , f.*
FROM avw_ipc_salix_family f
LEFT JOIN avw_ipc_salix_epithet e
ON e.family_id = f.id_family
where f.description_f like 'Hypothetical, for Pedigree testing%'
order by e.id_epithet;

CREATE VIEW vw5_basic_count_summary AS
SELECT
COUNT(id_epithet) nbr_of_epithets,
COUNT(DISTINCT(epithet)) unique_epithets,
COUNT(id_epithet) - COUNT(DISTINCT(epithet)) duplicate_epithets,
COUNT(DISTINCT(year_selected)) unique_years_selected,
COUNT(DISTINCT(interspecific_hybrid)) unique_interspecific_hybrids,
COUNT(DISTINCT(name_status)) unique_name_status,
COUNT(DISTINCT(species)) unique_species,
COUNT(DISTINCT(sex)) unique_sex,
COUNT(DISTINCT(id_family)) unique_families,
COUNT(DISTINCT(mother)) unique_mothers,
COUNT(DISTINCT(father)) unique_fathers
FROM  vw2_all_ipc_salix_epithet_family;



