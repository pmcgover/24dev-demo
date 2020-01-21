-- Linear pedigree listing: 
-- See: http://stackoverflow.com/questions/13780843/postgresql-recursive-via-2-parent-child-tables
WITH RECURSIVE expanded_family AS (
    SELECT
        f.id_family,
        f.family_key,
        ef.id_family  ef_family,
        em.id_family  em_family,
        f.filial_n,
        f.family_key || '=(' || ef.epithet_key || ' x ' || em.epithet_key || ')' pretty_print
    FROM ipc_salix_family f
        JOIN ipc_salix_epith ef ON f.mother_epithet_id = ef.id_epithet
        JOIN ipc_salix_epith em ON f.father_epithet_id = em.id_epithet
),
search_tree AS
(
    SELECT
        f.id_family,
        f.family_key,
        f.id family_root,
        1 depth,
        '>F1 ' || f.pretty_print  path
    FROM expanded_family f
    WHERE
        f.id_family != 1
        AND f.filial_n = 1
    UNION ALL
    SELECT
        f.id_family,
        f.family_key,
        st.family_root,
        st.depth + 1,
        st.path || ' >F' || st.depth+1 || ' ' || f.pretty_print
    FROM search_tree st
        JOIN expanded_family f
            ON f.ef_family = st.id
            OR f.em_family = st.id
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
---- WHERE rank = 1
ORDER BY family_key, path;
