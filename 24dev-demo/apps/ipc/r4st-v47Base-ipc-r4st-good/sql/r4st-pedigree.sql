-- Linear pedigree listing: 
-- See: http://stackoverflow.com/questions/13780843/postgresql-recursive-via-2-parent-child-tables
WITH RECURSIVE expanded_family AS (
    SELECT
        f.id,
        f.family_key,
        pf.id_family    pf_family,
        pm.id_family    pm_family,
        f.is_root,
        f.family_key || '=(' || pf.plant_key || ' x ' || pm.plant_key || ')' pretty_print
    FROM family f
        JOIN plant pf ON f.female_plant_id = pf.id
        JOIN plant pm ON f.male_plant_id = pm.id
),
search_tree AS
(
    SELECT
        f.id,
        f.family_key,
        f.id family_root,
        1 depth,
        '>F1 ' || f.pretty_print  path
    FROM expanded_family f
    WHERE
        f.id != 1
        AND f.is_root = 'Y' 
    UNION ALL
    SELECT
        f.id,
        f.family_key,
        st.family_root,
        st.depth + 1,
        st.path || ' >F' || st.depth+1 || ' ' || f.pretty_print
    FROM search_tree st
        JOIN expanded_family f
            ON f.pf_family = st.id
            OR f.pm_family = st.id
    WHERE
        f.id <> 1
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
ORDER BY family_key, path
