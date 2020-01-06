-- Update family.is_root with Y for each root level pedigree: 
UPDATE FAMILY SET is_root = 'Y' WHERE ID IN
(SELECT DISTINCT ON (f.id) f.id
FROM family f,
plant p
WHERE (f.female_plant_id = p.id OR f.male_plant_id = p.id)
AND p.id_family = 2
AND f.id not in (1,2) -- Omit first 2 description rows
AND f.female_plant_id =
  (SELECT p1.id FROM plant p1
   WHERE p1.id_family = 2
   AND p1.id = f.female_plant_id)
AND f.male_plant_id =
  (SELECT p2.id FROM plant p2
   WHERE p2.id_family = 2
   AND p2.id = f.male_plant_id)
ORDER BY f.id DESC);

