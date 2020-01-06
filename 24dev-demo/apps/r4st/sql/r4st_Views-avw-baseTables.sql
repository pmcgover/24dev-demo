CREATE VIEW avw_taxa AS
select * from taxa 
order by id;

CREATE VIEW avw_plant AS
select 
p.plant_key, 
p.id, 
p.notes,
p.sex_mfbu,
p.published_botanical_name, 
p.common_name, 
p.alternate_name, 
p.aquired_from, 
p.female_external_parent, 
p.male_external_parent, 
p.form_fnmwu, 
p.is_plus, 
p.is_cultivar, 
p.is_variety, 
p.is_from_wild, 
p.ploidy_n, 
p.date_aquired, 
t.taxa_key, 
f.family_key, 
p.web_photos, 
p.web_url
from plant p,
taxa t,
family f
where p.id_taxa = t.id
and p.id_family = f.id
order by p.id;


CREATE VIEW avw_family AS
select
f.family_key, 
f.id, 
f.notes,
p1.plant_key as female_parent,
p2.plant_key as male_parent,
f.seed_notes, 
f.form_fnmwu, 
f.is_plus, 
f.is_root,
f.seeds_in_storage, 
f.ploidy_n,
f.seed_germ_percent, 
f.seed_germ_date, 
f.cross_date, 
t.taxa_key,
f.web_photos, 
f.web_url
from family f,
taxa t,
plant p1,
plant p2
where f.id_taxa = t.id 
and f.female_plant_id = p1.id
and f.male_plant_id = p2.id;


CREATE VIEW avw_site AS
select * from site 
order by id;

CREATE VIEW avw_test_spec as
select
ts.test_spec_key,
ts.id,
ts.notes,
ts.activity_type,
ts.test_type,
ts.research_hypothesis,
ts.null_hypothesis,
ts.reject_null_hypothesis,
ts.web_protocol,
ts.web_url,
ts.web_photos,
ts.test_start_date,
s.site_key
from test_spec ts,
site s
where ts.id_site = s.id;


CREATE VIEW avw_test_detail as
select
td.test_detail_key,
td.id,
td.notes,
td.notes2,
td.start_quantity,
td.end_quantity,
td.this_start_date,
td.score_date,
td.stock_type,
td.stock_length_cm,
td.stock_dia_mm,
td.nbr_of_stems,
td.is_plus_ynu,
td.collar_median_dia_mm,
td.dbh_circ_cm,
td.height_cm,
td.bias_3_3,
td.leaf_score,
td.canker_score,
td.swasp_score,
p.plant_key,
f.family_key,
ts.test_spec_key,
td.row_nbr,
td.column_nbr,
td.replication_nbr,
td.plot_nbr,
td.block_nbr
from test_detail td,
test_spec ts,
family f,
plant p
where td.id_test_spec = ts.id
AND td.id_plant = p.id
AND td.id_family = f.id;

CREATE VIEW avw_journal AS
select
j.journal_key,
j.id,
j.notes,
j.author,
p.plant_key,
f.family_key,
ts.test_spec_key,
s.site_key,
j.date,
j.web_url
from journal j,
site s,
plant p,
family f,
test_spec ts
where j.id_test_spec = ts.id
and j.id_site = s.id
AND j.id_plant = p.id
AND j.id_family = f.id;

------------------------------------------------------------------------------

-- Annual Nursery stock View
CREATE VIEW vw1_master_test_detail AS 
select
td.test_detail_key,
td.id,
td.notes,
td.notes2,
td.stock_type,
td.start_quantity,
td.end_quantity,
td.dbh_circ_cm,
td.height_cm,
td.stock_length_cm,
td.collar_median_dia_mm,
trunc((td.end_quantity / td.start_quantity),3) as survival_rate,
trunc((td.end_quantity / td.start_quantity),3) * td.collar_median_dia_mm  as vigor_survival, 
td.is_plus_ynu,
CASE WHEN is_plus_ynu = 'Y' THEN 1 ELSE 0 END as is_plus_tree, 
td.bias_3_3,
ts.test_spec_key,
ts.test_type,
td.row_nbr,
td.column_nbr,
td.replication_nbr,
---CASE WHEN td.replication_nbr < 1 THEN null ELSE td.replication_nbr END as replication_counting_nbrs,
EXTRACT(ISOYEAR FROM td.this_start_date) as year
from test_detail td,
test_spec ts
WHERE lower(td.notes) NOT LIKE lower('%willow%') 
AND td.id_test_spec = ts.id
order by vigor_survival desc;

-- BY nursery STOCK TYPE, test_spec_key: Vigor Survival selection model: survivalRate*vigorSurvivalRate
CREATE VIEW vw2_nursery_stocktype_test_detail AS 
select 
test_detail_key,
stock_type,
count(replication_nbr) as nbr_of_replications, 
sum(end_quantity) as sum_of_end_qty,
sum(is_plus_tree) as sum_of_plus_trees,
count(distinct year) as nbr_of_years,
trunc(avg(survival_rate),3) as avg_survival_rate,
trunc(avg(height_cm),3) as avg_heigth_cm,
trunc(avg(collar_median_dia_mm),3) as avg_collar_median_dia_mm,
CASE WHEN trunc(avg(vigor_survival),3) > 0 THEN trunc(avg(vigor_survival),3) ELSE 0 END as avg_vigor_survival,
trunc(avg(vigor_survival),3) + sum(is_plus_tree)  as vigorsurvival_plus_plustrees
from vw1_master_test_detail   
where test_type = 'nursery' 
group by test_detail_key, stock_type
order by vigorsurvival_plus_plustrees desc; 


-- By test_detail_key.  Vigor Survival selection model: survivalRate*vigorSurvivalRate
CREATE VIEW vw3_nursery_summary_test_detail AS 
select 
test_detail_key,
count(replication_nbr) as nbr_of_replications,
count(distinct stock_type) as nbr_of_stock_types,
count(distinct year) as nbr_of_years,
sum(start_quantity) as sum_of_start_qty,
sum(end_quantity) as sum_of_end_qty,
sum(is_plus_tree) as sum_of_plus_trees,
trunc(avg(survival_rate),3) as avg_survival_rate,
trunc(avg(height_cm),3) as avg_heigth_cm,
trunc(avg(collar_median_dia_mm),3) as avg_collar_median_dia_mm,
CASE WHEN trunc(avg(vigor_survival),3) > 0 THEN trunc(avg(vigor_survival),3) ELSE 0 END as avg_vigor_survival,
trunc(avg(vigor_survival),3) + sum(is_plus_tree)  as vigorsurvival_plus_plustrees
from vw1_master_test_detail   
where test_type = 'nursery' 
group by test_detail_key
order by avg_vigor_survival desc;

