-- Linear pedigree listing: 
-- See: http://stackoverflow.com/questions/13780843/postgresql-recursive-via-2-parent-child-tables
WITH RECURSIVE expanded_family AS (
    SELECT
        f.id_family,
        f.family_key,
        ef.family_id  ef_family,
        em.family_id  em_family,
        f.is_root, 
        f.family_key || '=(' || ef.epithet_key || ' x ' || em.epithet_key || ')' pretty_print
    FROM ipc_salix_family f
        JOIN ipc_salix_epithet ef ON f.mother_epithet_id = ef.id_epithet
        JOIN ipc_salix_epithet em ON f.father_epithet_id = em.id_epithet
),
search_tree AS
(
    SELECT
        f.id_family,
        f.family_key,
        f.id_family family_root,
        1 depth,
        '>F1 ' || f.pretty_print  path
    FROM expanded_family f
    WHERE
        f.id_family != 1
        AND f.is_root = 'Y'
    UNION ALL
    SELECT
        f.id_family,
        f.family_key,
        st.family_root,
        st.depth + 1,
        st.path || ' >F' || st.depth+1 || ' ' || f.pretty_print
    FROM search_tree st
        JOIN expanded_family f
            ON f.ef_family = st.id_family
            OR f.em_family = st.id_family
    WHERE
        f.id_family <> 1
)
SELECT
    family_key,
    path
FROM
(
    SELECT
        family_key,
        rank() over (partition by family_root order by depth desc),
        path
    FROM search_tree
) AS ranked
--WHERE rank = 1
WHERE path NOT LIKE '%(N/A x N/A)%' -- Remove rows with no filial output 
ORDER BY family_key, path
