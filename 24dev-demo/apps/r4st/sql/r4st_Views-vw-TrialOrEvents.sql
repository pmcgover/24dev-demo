--- NOTE this needs to be optimized for the new test_detail columns....

CREATE VIEW vw_trials AS 
select
tsp.test_spec_key,
tsp.id test_spec_id,
tsp.research_hypothesis,
tsp.reject_null_hypothesis,
tsp.activity_type,
s.site_key,
s.notes site_notes,
s.drainage_class_usda,
td.test_detail_key,
td.id test_detail_id,
td.notes test_detail_notes,
td.start_quantity,
td.this_start_date test_start_date,
td.score_date,
td.end_quantity,
trunc((td.end_quantity / td.start_quantity),3) as survival_rate,
td.stock_type,
td.stock_length_cm,
td.stock_dia_mm,
td.dbh_circ_cm,
p.plant_key,
p.id plant_id,
f.family_key,
f.id family_id,
td.row_nbr,
td.column_nbr,
td.replication_nbr,
td.plot_nbr,
td.block_nbr
FROM
site s,
test_spec tsp,
plant p,
family f,
test_detail td 
WHERE tsp.id_site = s.id
AND td.id_test_spec = tsp.id
AND td.id_plant = p.id
AND td.id_family = f.id
AND tsp.activity_type = 'TRIAL'
ORDER BY tsp.test_spec_key, td.this_start_date;

