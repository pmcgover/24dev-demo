UPDATE ipc_salix_family SET is_root = 'Y' WHERE id_family IN
(SELECT DISTINCT ON (f.id_family) f.id_family
FROM ipc_salix_family f,
ipc_salix_epithet p
WHERE (f.mother_epithet_id = p.id_epithet OR f.father_epithet_id = p.id_epithet)
AND p.family_id = 1
AND f.id_family <> 1 -- Omit first 2 description rows
AND f.mother_epithet_id =
  (SELECT p1.id_epithet FROM ipc_salix_epithet p1
   WHERE p1.family_id = 1
   AND p1.id_epithet = f.mother_epithet_id)
AND f.father_epithet_id =
  (SELECT p2.id_epithet FROM ipc_salix_epithet p2
   WHERE p2.family_id = 1
   AND p2.id_epithet = f.father_epithet_id)
ORDER BY f.id_family DESC);

ALTER TABLE ipc_salix_epithet ADD CONSTRAINT 
epithet_family_id_fk FOREIGN KEY(family_id) REFERENCES ipc_salix_family(id_family);

