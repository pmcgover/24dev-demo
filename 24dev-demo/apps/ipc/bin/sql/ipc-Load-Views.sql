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

CREATE VIEW vw1_all_ipc_salix_epithet_family AS 
SELECT  *
FROM ipc_salix_epithet e,
ipc_salix_family f
WHERE e.family_id = f.id_family
order by e.id_epithet;

CREATE VIEW original_minus_epithet_key_data AS
select id_sorted, epithet_cleaned, species_cleaned, mother_cleaned,father_cleaned
from ipc_original_salix_epithet
EXCEPT
select id_epithet, epithet, species,  mother, father
from vw1_all_ipc_salix_epithet_family;

CREATE VIEW vw2_basic_ipc_salix_epithet_family AS 
SELECT
e.id_epithet  e_id_epithet,
e.epithet_key e_epithet_key,
e.epithet e_epithet,
e.year_selected e_year_selected,
e.interspecific_hybrid e_interspecific_hybrid,
e.name_status e_name_status,
e.species e_species,
e.species e_species_web_url,
e.sex e_sex,
f.id_family f_id_family,
f.mother_epithet_id f_mother_epithet_id,
f.father_epithet_id f_father_epithet_id,
f.mother f_mother,
f.father f_father,
f.is_root  f_is_root
FROM ipc_salix_epithet e,
ipc_salix_family f
WHERE  e.family_id = f.id_family
--AND f.id_family < 97
--AND e.id_epithet < 970
ORDER BY e.id_epithet;

CREATE VIEW vw3_basic_with_new_2019_test_data AS
select * from vw2_basic_ipc_salix_epithet_family
where  e_id_epithet > 968
order by e_id_epithet;

CREATE VIEW vw4_basic_count_summary AS
SELECT
COUNT(e_id_epithet) nbr_of_epithets,
COUNT(DISTINCT(e_epithet)) unique_epithets,
COUNT(e_id_epithet) - COUNT(DISTINCT(e_epithet)) duplicate_epithets,
COUNT(DISTINCT(e_year_selected)) unique_years_selected,
COUNT(DISTINCT(e_interspecific_hybrid)) unique_interspecific_hybrids,
COUNT(DISTINCT(e_name_status)) unique_name_status,
COUNT(DISTINCT(e_species)) unique_species,
COUNT(DISTINCT(e_sex)) unique_sex,
COUNT(DISTINCT( f_id_family)) unique_families,
COUNT(DISTINCT(f_mother)) unique_mothers,
COUNT(DISTINCT(f_father)) unique_fathers
FROM  vw2_basic_ipc_salix_epithet_family;

CREATE VIEW vw5_ipc_salix_family_with_parent_keys AS
select f.*,
e1.epithet_key as e_mother_key,
e2.epithet_key as e_father_key
from ipc_salix_family f,
ipc_salix_epithet e1,
ipc_salix_epithet e2
where f.mother_epithet_id = e1.id_epithet
and f.father_epithet_id = e2.id_epithet
order by id_family desc;




