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
p.alba_class,
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
f.seed_germ_percent, 
f.seed_germ_date, 
f.cross_date, 
f.project_phase,
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

CREATE VIEW avw_family_phase_summary AS
select project_phase,
count(f.*) AS number_of_families_per_project_phase,
count(distinct f.female_parent) AS count_unique_female_parents,
count(distinct f.male_parent) AS count_unique_male_parents,
count(distinct f.taxa_key) AS count_unique_taxa_species,
sum(pt.is_plus_family) AS sum_of_plus_trees
--trunc(avg(seed_germ_percent),2) avg_seed_germ_percent, -- Use for this statistic
from avw_family f,
(SELECT family_key, id,
        CASE WHEN is_plus = 'Y' THEN 1
             WHEN is_plus = 'N' THEN 0 ELSE 0 END AS is_plus_family
        FROM avw_family
) pt
where f.project_phase != -1
--and seed_germ_percent  > -1 -- Use for this statistic
and f.family_key = pt.family_key
and f.id = pt.id
group by project_phase
order by project_phase;

CREATE VIEW avw_family_phase_seed_germ_summary AS
select project_phase,
count(f.*) AS number_of_families_per_project_phase,
count(distinct f.female_parent) AS count_unique_female_parents,
count(distinct f.male_parent) AS count_unique_male_parents,
count(distinct f.taxa_key) AS count_unique_taxa_species,
trunc(avg(seed_germ_percent),2) avg_seed_germ_percent -- Use for this statistic
from avw_family f
where seed_germ_percent  > -1 -- Use for this statistic
group by project_phase
order by project_phase;


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
ts.stock_type,
ts.stock_length_cm,
ts.stock_collar_dia_mm,
ts.research_hypothesis,
ts.web_protocol,
ts.web_url,
ts.web_photos,
ts.test_start_date,
s.site_key
from test_spec ts,
site s
where ts.id_site = s.id;


-- Combined test_detail and test_score tables - Less risk for data entry errors 
CREATE VIEW avw_test_detail as
select
td.test_detail_key,
td.id,
td.notes,
td.notes2,
td.notes3,
td.todo,
td.planted_order,
td.selection_type,
td.nursery_cuttings_ft,
td.start_quantity,
td.end_quantity,
td.this_start_date,
td.score_date,
td.stock_type,
td.stock_length_cm,
td.stock_dia_mm,
td.is_plus_ynu,
td.collar_median_dia_mm,
td.stool_collar_median_dia_mm,
td.height_cm,
td.leaf_score,
td.ar_score,
ts.test_spec_key,
td.row_nbr,
td.column_nbr,
td.replication_nbr,
td.plot_nbr,
td.block_nbr
from test_detail td,
test_spec ts
where td.id_test_spec = ts.id;


CREATE VIEW avw_field_trial as
SELECT
ft.field_trial_key,
ft.id,
ft.notes,
ft.notes2,
ft.notes3,
ft.planted_order,
ft.ft_stock_type,
ft.ft_stock_length_cm,
ft.year_planted,
ft.live_quantity,
ft.is_plus_ynu,
ft.live_dbh_cm,
ft.live_height_cm,
ft.field_cuttings_ft,
ft.leaf_score,
ft.canker_score,
ts.test_type,
ts.stock_type,
ts.stock_length_cm,
ts.stock_collar_dia_mm,
ft.tree_spacing_ft,
ft.row_nbr,
ft.column_nbr,
ft.replication_nbr,
ft.plot_nbr,
ft.block_nbr,
ts.test_spec_key,
s.site_key,
ft.id_test_spec,
ft.id_site
FROM field_trial ft,
test_spec ts,
site s
WHERE ft.id_test_spec = ts.id
AND ft.id_site = s.id;

CREATE VIEW avw_gpf_split_wood_tests AS 
select
s.swt_key,
s.id,
s.notes,
s.notes2,
s.cutting_order,
s.stem_dia_small_end_mm,
s.length_of_split_in,
s.grain_pull_force_lb,
--undulation_level: -1=Unknown, 0=None (A502), 1=Low (AGRR1 light,inconsistent), 2=Med (25r61 heavier), 3=High (25r23 significant)
s.undulation_level,
s.gpf_test_set,
s.replication_nbr,
s.id_test_spec,
ts.test_spec_key
from split_wood_tests s,
test_spec ts
where s.id_test_spec = ts.id
and s.gpf_test_set = 'Y';


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
------------------------------------------------------------------------------
-- split_wood_tests Views: Boo
CREATE VIEW  gpf1_figured_wood_split_tests AS 
SELECT swt_key AS swt_key,
undulation_level AS  undulation_level,
COUNT(replication_nbr) AS count_of_replications,
min(test_spec_key) AS min_test_spec_key,
min(id_test_spec) AS id_test_spec,
trunc(avg(stem_dia_small_end_mm),2) AS avg_stem_dia_mm,
trunc(avg(length_of_split_in),2) AS avg_length_of_split_in,
trunc(avg(grain_pull_force_lb),2) AS avg_grain_pull_force_lb,
trunc(avg(undulation_level),2) AS avg_undulation_level,
max(undulation_level) AS max_undulation_level
FROM avw_gpf_split_wood_tests
GROUP BY swt_key, undulation_level
ORDER BY swt_key DESC;

CREATE VIEW gpf2_figured_wood_split_tests_summary AS 
SELECT swt_key AS swt_key,
sum(count_of_replications) AS nbr_of_samples,
trunc(avg(avg_stem_dia_mm),2) AS avg_stem_dia_mm,
trunc(avg(avg_length_of_split_in),2) AS avg_length_of_split_in,
trunc(avg(avg_grain_pull_force_lb),2) AS avg_grain_pull_force_lb,
trunc(avg(avg_undulation_level) / COUNT(swt_key),2)  AS avg_undulations_per_sample,
trunc(min(avg_undulation_level),2) AS min_undulation_level,
trunc(max(avg_undulation_level),2) AS max_undulation_level,
trunc(stddev_pop(avg_undulation_level),2) AS pop_stddev_undulation_level,
trunc(avg(avg_undulation_level),2) AS avg_undulation_level
FROM gpf1_figured_wood_split_tests
GROUP BY swt_key
ORDER BY avg_undulation_level DESC;

-- Parent Seed Germination Views
CREATE VIEW avx_female_parent_germination_rates AS
SELECT f.female_parent, 
COUNT(f.female_parent) AS count_of_this_female,
trunc(avg(f.seed_germ_percent),2) AS avg_seed_germ_percent_females,
trunc(max(f.seed_germ_percent),2) AS max_seed_germ_percent_females, 
trunc(min(f.seed_germ_percent),2) AS min_seed_germ_percent_females,
p.alba_class AS alba_class, min(p.is_plus) AS is_plus, min(p.is_from_wild) AS is_from_wild
FROM avw_family f,
(
  SELECT plant_key, alba_class, is_plus, is_from_wild
  FROM plant
  where id not in (1,2)
) p 
WHERE f.seed_germ_percent > -1
AND f.female_parent = p.plant_key
AND f.id not in (1,2)
GROUP BY f.female_parent, p.alba_class
ORDER BY avg_seed_germ_percent_females DESC;


CREATE VIEW avx_male_parent_germination_rates AS
SELECT f.male_parent, 
COUNT(f.male_parent) AS count_of_this_male,
trunc(avg(f.seed_germ_percent),2) AS avg_seed_germ_percent_males,
trunc(max(f.seed_germ_percent),2) AS max_seed_germ_percent_males, 
trunc(min(f.seed_germ_percent),2) AS min_seed_germ_percent_males,
p.alba_class AS alba_class, min(p.is_plus) AS is_plus, min(p.is_from_wild) AS is_from_wild
FROM avw_family f,
(
  SELECT plant_key, alba_class, is_plus, is_from_wild
  FROM plant
  where id not in (1,2)
) p
WHERE f.seed_germ_percent > -1
AND f.male_parent = p.plant_key
AND f.id not in (1,2)
GROUP BY f.male_parent, p.alba_class
ORDER BY avg_seed_germ_percent_males DESC;


CREATE VIEW avx_female_parent_germination_rate_summary AS
select alba_class as alba_class_female,
CASE WHEN alba_class = 'U' THEN 'Unknown, like Unknown female parentage'
     WHEN alba_class = 'A' THEN 'Alba, 100% P. alba'
     WHEN alba_class = 'H' THEN 'Hybrid, with 50% P. alba'
     WHEN alba_class = 'AH' THEN 'Alba Hybrid, with > 50% P. alba'
     WHEN alba_class = 'ASH' THEN 'Aspen Hybrid, with < 50% P. alba'
     WHEN alba_class = 'ASA' THEN 'Aspen American, native American aspen'
     WHEN alba_class = 'ASO' THEN 'Aspen Other, with 0% P. alba, (eg, P. tremula)'
     WHEN alba_class = 'C' THEN 'Control, with 0% P. alba'
ELSE 'NA' END AS alba_class_female_descriptions,
count(count_of_this_female) number_of_unique_females,
sum(count_of_this_female) sum_of_females,
trunc(avg(avg_seed_germ_percent_females),2) avg_seed_germ_female_parents,
max(max_seed_germ_percent_females) max_germ_female_parents,
min(min_seed_germ_percent_females) min_germ_female_parents
from avx_female_parent_germination_rates
group by alba_class
order by avg_seed_germ_female_parents desc;


CREATE VIEW avx_male_parent_germination_rate_summary AS
select alba_class as alba_class_male,
CASE WHEN alba_class = 'U' THEN 'Unknown, like Open Pollinated or Undetermined'
     WHEN alba_class = 'A' THEN 'Alba, 100% P. alba'
     WHEN alba_class = 'H' THEN 'Hybrid, with 50% P. alba'
     WHEN alba_class = 'AH' THEN 'Alba Hybrid, with > 50% P. alba'
     WHEN alba_class = 'ASH' THEN 'Aspen Hybrid, with < 50% P. alba'
     WHEN alba_class = 'ASA' THEN 'Aspen American, native American aspen'
     WHEN alba_class = 'ASO' THEN 'Aspen Other, with 0% P. alba, (eg, P. tremula)'
     WHEN alba_class = 'C' THEN 'Control, with 0% P. alba'
ELSE 'NA' END AS alba_class_male_descriptions,
count(count_of_this_male) number_of_unique_males,
sum(count_of_this_male) sum_of_males,
trunc(avg(avg_seed_germ_percent_males),2) avg_seed_germ_male_parents,
max(max_seed_germ_percent_males) max_germ_male_parents,
min(min_seed_germ_percent_males) min_germ_male_parents
from avx_male_parent_germination_rates
group by alba_class
order by avg_seed_germ_male_parents desc;


-----------------------
-- ft.ft_stock_type,
-- ft.ft_stock_length_cm,
-- ft.year_planted,

-- Field Trial Views 
CREATE VIEW v1_field_trial_master_summary AS
SELECT ft.field_trial_key AS field_trial_key,
COUNT(DISTINCT ft.site_key) AS nbr_of_sites,
COUNT(DISTINCT ft.year_planted) AS years_planted,
COUNT(DISTINCT ft.ft_stock_type) AS nbr_of_stock_types,
COUNT(ft.test_spec_key) AS planted_qty,
sum(ft.live_quantity) AS sum_live_qty,
trunc(avg(ft.live_quantity),2) AS avg_survival_rate,
sum(pt.is_plus_tree) AS sum_plus_trees,
trunc(avg(ft.live_dbh_cm),2) AS avg_dbh_cm,
trunc(avg(ft.field_cuttings_ft),2) AS avg_field_cuttings_ft,
trunc(avg(ft.canker_score),2) AS avg_canker_score,
trunc(avg(ft.leaf_score),2) AS avg_leaf_score,
(trunc( (COUNT(DISTINCT ft.site_key)* 3) + (sum(pt.is_plus_tree)* 2) + (avg(live_quantity)* 5),2)) AS sites_plustree_survival_score 
FROM avw_field_trial ft,
(SELECT field_trial_key, id,
        CASE WHEN is_plus_ynu = 'Y' THEN 1
             WHEN is_plus_ynu = 'N' THEN -1 ELSE 0 END AS is_plus_tree
        FROM field_trial
) pt
WHERE ft.field_trial_key = pt.field_trial_key
AND ft.id = pt.id
GROUP BY ft.field_trial_key
ORDER BY sites_plustree_survival_score desc; 


-- Basic Summary View - Group by Key and test_spec keys
CREATE VIEW v2_field_trial_test_spec_summary AS
SELECT ft.field_trial_key AS field_trial_key,
ft.test_spec_key AS test_spec_key,
ft.id_test_spec AS id_test_spec,
ft.ft_stock_type AS ft_stock_type,
ft.year_planted AS year_planted,
min(ft.site_key) AS site_key,
count(ft.test_spec_key) AS planted_qty,
sum(ft.live_quantity) AS sum_live_qty,
trunc(avg(ft.live_quantity),2) AS avg_survival_rate,
sum(pt.is_plus_tree) AS sum_plus_trees,
trunc(avg(ft.live_dbh_cm),2) AS avg_dbh_cm,
sum(ft.field_cuttings_ft) AS sum_field_cuttings_ft,
DENSE_RANK() OVER (PARTITION BY ft.test_spec_key ORDER BY trunc(avg(ft.live_dbh_cm),2) DESC) as ranked_avgdbh,
trunc(avg(ft.live_height_cm),2) AS avg_height_cm,
DENSE_RANK() OVER (PARTITION BY ft.test_spec_key ORDER BY trunc(avg(ft.live_height_cm),2) DESC) as ranked_avgheight,
trunc(avg(ft.canker_score),2) AS avg_canker_score,
trunc(avg(ft.leaf_score),2) AS avg_leaf_score,
trunc((sum(pt.is_plus_tree)*.3) + (avg(ft.live_dbh_cm)*.5) + (avg(ft.leaf_score)*.2),2) AS sum_plus_dbh_leafscore
-- Enhancement: divide qty / plus_trees but need to resolve the divide by zero issue:
-- trunc(coalesce(( nullif(sum(ft.live_quantity),0) / sum(pt.is_plus_tree)*.3),0)+(avg(ft.live_dbh_cm)*.5)+(avg(ft.leaf_score)*.2),2) AS sum_plus_dbh_leafscore
FROM avw_field_trial ft,
(SELECT field_trial_key, id,
        CASE WHEN is_plus_ynu = 'Y' THEN 1
             WHEN is_plus_ynu = 'N' THEN -1 ELSE 0 END AS is_plus_tree
        FROM field_trial
) pt
WHERE ft.field_trial_key = pt.field_trial_key
AND ft.id = pt.id
GROUP BY ft.field_trial_key, ft.test_spec_key, ft.id_test_spec, ft.ft_stock_type, ft.year_planted
ORDER BY sum_plus_dbh_leafscore DESC;

-- Group by Key ,test_spec key, site, block, rep_nbr...
CREATE VIEW v3_field_trial_summary AS
SELECT ft.field_trial_key AS field_trial_key,
ft.test_spec_key AS test_spec_key,
ft.site_key AS site_key,
ft.id_test_spec AS id_test_spec,
ft.id_site AS id_site,
ft.replication_nbr AS replication_nbr,
ft.block_nbr AS block_nbr,
sum(ft.live_quantity) AS sum_live_quantity,
sum(pt.is_plus_tree) AS sum_plus_trees,
trunc(avg(ft.live_dbh_cm),2) AS avg_dbh_cm,
sum(ft.field_cuttings_ft) AS sum_field_cuttings_ft,
DENSE_RANK() OVER (ORDER BY trunc(avg(ft.live_dbh_cm),2) DESC) as ranked_avgdbh,
DENSE_RANK() OVER (PARTITION BY ft.test_spec_key  ORDER BY trunc(avg(ft.live_dbh_cm),2) DESC) as ranked_avgdbh_speckey,
DENSE_RANK() OVER (PARTITION BY ft.replication_nbr  ORDER BY trunc(avg(ft.live_dbh_cm),2) DESC) as ranked_avgdbh_repnbr,
DENSE_RANK() OVER (PARTITION BY ft.block_nbr ORDER BY trunc(avg(ft.live_dbh_cm),2) DESC) as ranked_avgdbh_blocknbr,
trunc(avg(ft.live_height_cm),2) AS avg_height_cm,
DENSE_RANK() OVER (ORDER BY trunc(avg(ft.live_height_cm),2) DESC) as ranked_avgheight,
trunc(avg(ft.canker_score),2) AS avg_canker_score,
trunc(avg(ft.leaf_score),2) AS avg_leaf_score,
trunc((sum(pt.is_plus_tree)*.3) + (avg(ft.live_dbh_cm)*.5) + (avg(ft.leaf_score)*.2),2) AS sum_plus_dbh_leafscore
-- Enhancement: divide qty / plus_trees but need to resolve the divide by zero issue: 
-- trunc(coalesce(( nullif(sum(ft.live_quantity),0) / sum(pt.is_plus_tree)*.3),0)+(avg(ft.live_dbh_cm)*.5)+(avg(ft.leaf_score)*.2),2) AS sum_plus_dbh_leafscore
FROM avw_field_trial ft,
(SELECT field_trial_key, id,
        CASE WHEN is_plus_ynu = 'Y' THEN 1
             WHEN is_plus_ynu = 'N' THEN -1 ELSE 0 END AS is_plus_tree  
        FROM field_trial
) pt
WHERE ft.field_trial_key = pt.field_trial_key
AND ft.id = pt.id
GROUP BY ft.field_trial_key, ft.test_spec_key, ft.site_key, ft.replication_nbr, ft.block_nbr, ft.id_test_spec, ft.id_site
ORDER BY sum_plus_dbh_leafscore DESC;

CREATE VIEW v4_field_trial_test_spec_2019postne AS
SELECT field_trial_key,
year_planted,
ft_stock_type,
planted_qty,
sum_live_qty,
sum_plus_trees,
avg_dbh_cm,
avg_leaf_score,
sum_field_cuttings_ft,
DENSE_RANK() OVER (ORDER BY sum_plus_dbh_leafscore DESC) as ranked_dbh_plus_leafscore, 
DENSE_RANK() OVER (ORDER BY avg_dbh_cm DESC) as ranked_avgdbh, 
sum_plus_dbh_leafscore,
test_spec_key
FROM v2_field_trial_test_spec_summary 
WHERE test_spec_key = '2019-PostNE-West-Measurement' -- FIX TODO - change 2-0-1-8 to 2-0-19
ORDER BY sum_plus_dbh_leafscore DESC;

CREATE VIEW v5_field_trial_stocktypes_2019_post_sites AS
SELECT field_trial_key, ft_stock_type, 
COUNT(DISTINCT site_key) nbr_of_sites,
sum(planted_qty) as planted_qty,
sum(sum_live_qty) AS live_qty,
trunc(avg(avg_survival_rate),2) AS survival_rate,
sum(sum_plus_trees) AS sum_plus_trees,
sum(sum_field_cuttings_ft) AS sum_field_cuttings_ft,
trunc(avg(avg_height_cm),2) AS avg_height_cm
FROM  v2_field_trial_test_spec_summary
WHERE year_planted = '2019'
GROUP BY  field_trial_key, ft_stock_type
ORDER BY avg(avg_height_cm) DESC;

CREATE VIEW v6_field_trial_stocktypes_2019_post_sites_summary AS
SELECT COUNT(DISTINCT field_trial_key) AS nbr_of_clones,
COUNT (DISTINCT ft_stock_type) AS nbr_of_stock_types,
COUNT (DISTINCT nbr_of_sites) AS nbr_of_sites,
sum(planted_qty) AS total_planted_qty,
sum(live_qty) AS total_live_qty,
trunc(avg(live_qty/planted_qty),2) AS sites_survival_rate,
sum(sum_plus_trees) AS sites_sum_plus_trees,
sum(sum_field_cuttings_ft) AS sites_field_cuttings_ft,
trunc(avg(avg_height_cm),2) AS sites_avg_height_cm
FROM v5_field_trial_stocktypes_2019_post_sites;

CREATE VIEW v7_field_trial_ranked_summary AS
SELECT field_trial_key,
sum_live_quantity,
sum_plus_trees,
avg_dbh_cm,
avg_leaf_score,
sum_plus_dbh_leafscore,
id_test_spec,
DENSE_RANK() OVER (PARTITION BY replication_nbr ORDER BY sum_plus_dbh_leafscore DESC) AS ranked_reps, 
DENSE_RANK() OVER (PARTITION BY block_nbr ORDER BY sum_plus_dbh_leafscore DESC) AS ranked_blocks, 
DENSE_RANK() OVER (PARTITION BY block_nbr ORDER BY avg_dbh_cm DESC) AS ranked_dbh_blocks, 
replication_nbr,
block_nbr,
test_spec_key
FROM v3_field_trial_summary
ORDER BY sum_plus_dbh_leafscore DESC;

------------------------------------------------------------------------------
------------------------------------------------------------------------------

-- Annual Nursery stock View
CREATE VIEW va1_master_test_detail AS 
select
td.test_detail_key,
td.id,
td.notes,
td.notes2,
td.notes3,
td.todo,
td.planted_order,
td.selection_type,
td.stock_type,
td.start_quantity,
td.end_quantity,
td.stock_dia_mm,
td.height_cm,
td.leaf_score,
td.ar_score,
td.stock_length_cm,
td.collar_median_dia_mm,
td.stool_collar_median_dia_mm,
td.nursery_cuttings_ft,
trunc((td.end_quantity / td.start_quantity),2) as survival_rate,
trunc((td.end_quantity / td.start_quantity),2) * td.collar_median_dia_mm  as vigor_survival, 
trunc((td.end_quantity / td.start_quantity),2) * td.stool_collar_median_dia_mm  as stool_vigor_survival,  
td.is_plus_ynu,
CASE WHEN is_plus_ynu = 'Y' THEN 1 ELSE 0 END as is_plus_tree, 
ts.test_spec_key,
ts.test_type,
td.row_nbr,
td.column_nbr,
td.replication_nbr,
td.plot_nbr,
---CASE WHEN td.replication_nbr < 1 THEN null ELSE td.replication_nbr END as replication_counting_nbrs,
EXTRACT(ISOYEAR FROM td.this_start_date) as year
from test_detail td,
test_spec ts
WHERE lower(td.notes) NOT LIKE lower('%willow%') 
AND td.id_test_spec = ts.id
order by vigor_survival desc;

-- BY nursery STOCK TYPE, test_spec_key: Vigor Survival selection model: survivalRate*vigorSurvivalRate
CREATE VIEW va2_nursery_stocktype_test_detail AS 
select 
test_detail_key,
stock_type,
count(replication_nbr) as nbr_of_replications, 
sum(start_quantity) as sum_of_start_qty,
sum(end_quantity) as sum_of_end_qty,
sum(is_plus_tree) as sum_of_plus_trees,
count(distinct year) as nbr_of_years,
trunc(avg(survival_rate),2) as avg_survival_rate,
trunc(avg(stock_dia_mm),2) as avg_stock_dia_mm,
trunc(avg(height_cm),2) as avg_heigth_cm,
trunc(avg(stock_length_cm),2) as avg_length_cm,
trunc(avg(collar_median_dia_mm),2) as avg_collar_median_dia_mm,
trunc(avg(stool_collar_median_dia_mm),2) as avg_stool_collar_mm,
sum(nursery_cuttings_ft) as sum_of_nursery_cuttings_ft,
trunc(avg(nursery_cuttings_ft),2) as avg_nursery_cuttings_ft,
trunc(avg(stool_vigor_survival),2) as avg_stool_vigor_survival,
CASE WHEN trunc(avg(vigor_survival),2) > 0 THEN trunc(avg(vigor_survival),2) ELSE 0 END as avg_vigor_survival,
trunc(avg(vigor_survival),2) + sum(is_plus_tree)  as vigorsurvival_plus_plustrees,
trunc(avg(stool_vigor_survival),2) + trunc(avg(nursery_cuttings_ft),2) as stoolvs_plus_fcuttings,
trunc(avg(vigor_survival),2) + trunc(avg(nursery_cuttings_ft),2) as vigorsurvival_plus_fcuttings
from va1_master_test_detail   
where test_type = 'nursery' 
group by test_detail_key, stock_type
order by vigorsurvival_plus_fcuttings desc; 

-- Summary line output 
CREATE VIEW va2_all_nursery_rankings AS
SELECT v1.test_detail_key,
max(v2.ms_rank)||max(v2.dc_rank)||max(v2.dc_reps)||max(v2.dc_srate) AS all_ms_dc_rankings
FROM va2_nursery_stocktype_test_detail v1,
(select test_detail_key, stock_type,
test_detail_key||
 CASE WHEN stock_type = 'MS' THEN '~rankms='|| trunc(stoolvs_plus_fcuttings,1) ELSE NULL END AS ms_rank,
 CASE WHEN stock_type = 'DC' THEN '_rankdc='|| trunc(vigorsurvival_plus_fcuttings,1) ELSE NULL END AS dc_rank,
 CASE WHEN stock_type = 'DC' THEN '_dcreps='|| nbr_of_replications ELSE NULL END AS dc_reps,
 CASE WHEN stock_type = 'DC' THEN '_dcsrate='|| trunc(avg_survival_rate,2) ELSE NULL END AS dc_srate
 from  va2_nursery_stocktype_test_detail
) v2
WHERE v1.test_detail_key = v2.test_detail_key
AND v1.stock_type = v2.stock_type
GROUP BY v1.test_detail_key
ORDER BY v1.test_detail_key;


-- By test_detail_key.  Vigor Survival selection model: survivalRate*vigorSurvivalRate
CREATE VIEW va3_nursery_summary_test_detail AS 
select 
test_detail_key,
count(replication_nbr) as nbr_of_replications,
count(distinct stock_type) as nbr_of_stock_types,
count(distinct year) as nbr_of_years,
sum(start_quantity) as sum_of_start_qty,
sum(end_quantity) as sum_of_end_qty,
sum(is_plus_tree) as sum_of_plus_trees,
trunc(avg(survival_rate),2) as avg_survival_rate,
trunc(avg(stock_dia_mm),2) as avg_stock_dia_mm,
trunc(avg(height_cm),2) as avg_heigth_cm,
trunc(avg(collar_median_dia_mm),2) as avg_collar_median_dia_mm,
trunc(avg(stool_collar_median_dia_mm),2) as avg_stool_collar_mm,
sum(nursery_cuttings_ft) as sum_nursery_cuttings_ft,
trunc(avg(nursery_cuttings_ft),2) as avg_nursery_cuttings_ft,
trunc(avg(stool_vigor_survival),2) as avg_stool_vigor_survival,
CASE WHEN trunc(avg(vigor_survival),2) > 0 THEN trunc(avg(vigor_survival),2) ELSE 0 END as avg_vigor_survival,
trunc(avg(vigor_survival),2) + sum(is_plus_tree)  as vigorsurvival_plus_plustrees,
trunc(avg(stool_vigor_survival),2) + trunc(avg(nursery_cuttings_ft),2) as stoolvs_plus_fcuttings,
trunc(avg(vigor_survival),2) + trunc(avg(nursery_cuttings_ft),2) as vigorsurvival_plus_fcuttings
from va1_master_test_detail   
where test_type = 'nursery' 
group by test_detail_key
order by vigorsurvival_plus_fcuttings desc;


CREATE VIEW va4_nursery_dormant_cutting_summary AS
select
td.test_detail_key,
td.stock_type,
count(td.replication_nbr) as nbr_of_replications,
count(distinct td.year) as nbr_of_years,
sum(td.start_quantity) as sum_of_start_qty,
sum(td.end_quantity) as sum_of_end_qty,
sum(td.is_plus_tree) as sum_of_plus_trees,
max(swt.avg_undulation_level) as avg_undulation_level,
trunc(avg(td.survival_rate),2) as avg_survival_rate,
trunc(avg(td.stock_dia_mm),2) as avg_stock_dia_mm,
-- round(corr(survival_rate,stock_dia_mm)::numeric,2)  AS correlate_survival_to_stock_dia, -- TEMP...
trunc(avg(td.collar_median_dia_mm),2) as avg_collar_median_dia_mm,
sum(td.nursery_cuttings_ft) as sum_of_nursery_cuttings_ft,
trunc(avg(td.nursery_cuttings_ft),2) as avg_nursery_cuttings_ft,
trunc(avg(td.stool_vigor_survival),2) as avg_stool_vigor_survival,
CASE WHEN trunc(avg(td.vigor_survival),2) > 0 THEN trunc(avg(td.vigor_survival),2) ELSE 0 END as avg_vigor_survival,
trunc(avg(td.vigor_survival),2) + sum(td.is_plus_tree)  as vigorsurvival_plus_plustrees,
trunc(avg(td.stool_vigor_survival),2) + trunc(avg(td.nursery_cuttings_ft),2) as stoolvs_plus_fcuttings,
trunc(avg(td.vigor_survival),2) + trunc(avg(td.nursery_cuttings_ft),2) as vigorsurvival_plus_fcuttings
from va1_master_test_detail td
LEFT JOIN (
  select swt_key AS swt_key, 
  avg_undulation_level AS avg_undulation_level
  from  gpf2_figured_wood_split_tests_summary 
) swt
ON td.test_detail_key = swt.swt_key
where td.test_type = 'nursery'
and td.stock_type in ('DC','FDC','ODC','DCMS')
group by td.test_detail_key, td.stock_type
order by vigorsurvival_plus_fcuttings desc;


------------------------------------------------------------------------------
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- Annual process to enroll new test_detail data into r4st after Fall Nursery data entry:
-- Enter the nursery and field data into the test_detail and field tables.
-- Ensure that the first Replication record has the Notes field updated with: "Start Rep N: Rep description".  
-- ** Eg:  Start Rep 4. FDC - 1 MS with 5, 8 inch DC cuttings, planted 5" apart. Score only DCs.
-- Update the plot number for the above record to be the same as the Replication number.
-- Update the r4st_Views-avw-baseTables.sql script with the new year data.  Under the view code: 
-- ** "vw_20NN_1_nursery" Where NN is the last 2 digits of the target year.
-- Copy the last 2 column data from the vw_2019_5_nursery_field_summary view to the test_detail notes2 and 3 columns
-- Update the test_detail "todo" column for what todo next year.  
------------------------------------------------------------------------------

CREATE VIEW vw_2019_1_nursery AS
select
td.test_detail_key,
td.id,
td.notes,
td.notes2 as ranks_2019,
td.notes3 as rank_class, 
td.todo,
td.planted_order,
td.selection_type,
td.stock_type,
td.stock_length_cm,
td.stock_dia_mm,
td.start_quantity,
td.end_quantity,
td.nursery_cuttings_ft, 
td.collar_median_dia_mm,
td.stool_collar_median_dia_mm,
td.leaf_score,
td.ar_score,
trunc((td.end_quantity / td.start_quantity),2) as survival_rate,
trunc((td.end_quantity / td.start_quantity),2) * td.collar_median_dia_mm  as vigor_survival, 
trunc((td.end_quantity / td.start_quantity),2) * td.stool_collar_median_dia_mm  as stool_vigor_survival,  
td.is_plus_ynu,
CASE WHEN is_plus_ynu = 'Y' THEN 1 ELSE 0 END as is_plus_tree,
td.row_nbr,
td.column_nbr,
td.replication_nbr,
td.block_nbr
from test_detail td,
test_spec ts
WHERE td.id_test_spec = ts.id
and test_spec_key = '2019-bell-nursery' -- Master 2019 VIEW -----------------------
order by vigor_survival desc;


CREATE VIEW vw_2019_2_nursery_key_stock_summary AS
select distinct td.test_detail_key,
td.stock_type,
min(td.notes) as notes,
min(td.id) as id_order,
min(td.rank_class) as rank_class,
min(td.todo) as todo,
-- Class: U=unknown, P=Primary/elite, S=Secondary/archive, T=Tertiary/Parent, F=Family, R=Retest
CASE WHEN min(td.selection_type) = 'P' THEN 'Primary - Elite'
WHEN min(td.selection_type) = 'S' THEN 'Secondary - Archive'
WHEN min(td.selection_type) = 'T' THEN 'Tertiary - Parent'
WHEN min(td.selection_type) = 'F' THEN 'Retest - Family'
WHEN min(td.selection_type) = 'R' THEN 'Retest - Clone'
WHEN min(td.selection_type) = 'H' THEN 'Retest - High Priority'
WHEN min(td.selection_type) = 'E' THEN 'Exotic - Figured Grain'
WHEN min(td.selection_type) = 'U' THEN 'Unknown'
WHEN min(td.selection_type) = 'D' THEN 'Discard' ELSE 'ERROR - Mislabeled'  END AS selection_type,
count(td.replication_nbr) as nbr_of_replications,
sum(td.start_quantity) as sum_of_start_qty,
sum(td.end_quantity) as sum_of_end_qty,
sum(td.nursery_cuttings_ft) as sum_nursery_cuttings_ft,
sum(td.is_plus_tree) as sum_of_plus_trees,
max(swt.avg_undulation_level) as avg_undulation_level,
trunc(avg(td.survival_rate),2) as avg_survival_rate,
trunc(avg(td.vigor_survival),2) as avg_vigor_survival_rate,
trunc(avg(td.stool_vigor_survival),2) as avg_stool_vigor_survival_rate,
trunc(avg(td.stock_dia_mm),2) as avg_stock_dia_mm,
--corr(td.survival_rate,stock_dia_mm) as corr_survival_stock_dia_mm,
trunc(avg(td.collar_median_dia_mm),2) as avg_collar_median_dia_mm,
trunc(avg(td.stool_collar_median_dia_mm),2) as avg_stool_collar_mm,
trunc(avg(td.leaf_score),2) as avg_leaf_score,
trunc(avg(td.ar_score),2) as avg_ar_score,
trunc(avg(td.stool_vigor_survival) + avg(td.nursery_cuttings_ft) * (count(td.replication_nbr) *.1),2) as stools_cut_fcut_reps,
trunc(avg(td.vigor_survival) + avg(td.nursery_cuttings_ft) * (count(td.replication_nbr) *.1),2) as cut_fcut_reps
from vw_2019_1_nursery td
LEFT JOIN (
  select swt_key AS swt_key,
  avg_undulation_level AS avg_undulation_level
  from  gpf2_figured_wood_split_tests_summary
) swt
ON td.test_detail_key = swt.swt_key
GROUP BY test_detail_key, stock_type
order by cut_fcut_reps desc;


CREATE VIEW vw_2019_3_nursery_stock_summary AS
select stock_type,
count(stock_type) as stock_type_count,
sum(sum_of_start_qty) as planted_trees,
sum(sum_of_end_qty) as available_trees,
sum(sum_nursery_cuttings_ft) as sum_nursery_cuttings_ft,
sum(sum_of_plus_trees) as plus_trees,
trunc(avg(avg_survival_rate),2) as avg_survival_rate,
CASE WHEN trunc(avg(avg_stock_dia_mm),2) > 0 THEN trunc(avg(avg_stock_dia_mm),2) ELSE NULL END as avg_stock_dia_mm,
CASE WHEN trunc(avg(avg_collar_median_dia_mm),2) > 0 THEN trunc(avg(avg_collar_median_dia_mm),2) ELSE NULL END as avg_1_0_collar_median_dia_mm,
CASE WHEN trunc(avg(avg_stool_collar_mm),2) > 0 THEN trunc(avg(avg_stool_collar_mm),2) ELSE NULL END as avg_stool_collar_median_dia_mm,
CASE WHEN trunc(avg(avg_leaf_score),2) > 0 THEN trunc(avg(avg_leaf_score),2) ELSE NULL END as avg_leaf_score,
CASE WHEN trunc(avg(avg_ar_score),2) > 0 THEN trunc(avg(avg_ar_score),2) ELSE NULL END as avg_ar_score
from vw_2019_2_nursery_key_stock_summary 
group by stock_type
order by stock_type_count desc;


CREATE VIEW vw_2019_4_nursery_action_stock_summary AS
select selection_type,
stock_type,
count(stock_type) as stock_type_count,
sum(sum_of_start_qty) as planted_trees,
sum(sum_of_end_qty) as available_trees, 
sum(sum_nursery_cuttings_ft) as sum_nursery_cuttings_ft,
sum(sum_of_plus_trees) as plus_trees,
trunc(avg(avg_survival_rate),2) as avg_survival_rate,
CASE WHEN trunc(avg(avg_stock_dia_mm),2) > 0 THEN trunc(avg(avg_stock_dia_mm),2) ELSE NULL END as avg_stock_dia_mm,
CASE WHEN trunc(avg(avg_stool_collar_mm),2) > 0 THEN trunc(avg(avg_stool_collar_mm),2) ELSE NULL END as avg_stool_collar_median_dia_mm,
CASE WHEN trunc(avg(avg_collar_median_dia_mm),2) > 0 THEN trunc(avg(avg_collar_median_dia_mm),2) ELSE NULL END as avg_1_0_collar_median_dia_mm,
CASE WHEN trunc(avg(avg_leaf_score),2) > 0 THEN trunc(avg(avg_leaf_score),2) ELSE NULL END as avg_leaf_score,
CASE WHEN trunc(avg(avg_ar_score),2) > 0 THEN trunc(avg(avg_ar_score),2) ELSE NULL END as avg_ar_score
from vw_2019_2_nursery_key_stock_summary 
group by selection_type, stock_type
order by selection_type desc;

---    ####################

CREATE VIEW vw_2019_5_nursery_field_summary AS
select
ss.test_detail_key,
ss.stock_type,
ss.id_order,
ss.rank_class,
ss.todo,
ss.selection_type,
ss.nbr_of_replications,
ss.sum_of_start_qty,
ss.sum_of_end_qty,
ss.sum_nursery_cuttings_ft,
ft.sum_field_cuttings_ft,
ss.sum_of_plus_trees,
swt.avg_undulation_level as avg_undulation_level,
ss.avg_survival_rate,
ss.avg_stock_dia_mm,
ss.avg_collar_median_dia_mm,
ss.avg_leaf_score,
ss.avg_ar_score,
ss.avg_stool_collar_mm,
ss.stools_cut_fcut_reps,
ss.cut_fcut_reps,
-- round(corr(ss.avg_survival_rate,ss.avg_stock_dia_mm)::numeric,2)  AS correlate_survival_to_stock_dia, -- experimental...
CASE WHEN ss.stock_type = 'MS' THEN DENSE_RANK() OVER (ORDER BY ss.stools_cut_fcut_reps DESC) ELSE '-1' END AS stool_rank,
CASE WHEN ss.stock_type = 'DC' THEN DENSE_RANK() OVER (ORDER BY ss.cut_fcut_reps DESC) ELSE '-1' END AS dc_rank,
CASE WHEN ss.stock_type = 'DCMS' THEN DENSE_RANK() OVER (ORDER BY ss.cut_fcut_reps DESC) ELSE '-1' END AS dcms_rank,
CASE WHEN ft.archived_trees IS NULL THEN 0 ELSE ft.archived_trees END as archived_trees,
-- REGEXP_REPLACE(rank_class, '^.*class=', '') as family_class, -- need to store/access this from the taxa table.
/* Comment out rank_class_summary that is now duplicated in the rank_class field:
*/
fts.arc_avg_dbh_cm  AS arc_avg_dbh_cm,
ftms.ftms_nbr_of_sites,
ftms.ftms_years_planted,
ftms.ftms_nbr_of_stock_types,
ftms_sites_plustree_survival_score,
ss.test_detail_key||
   -- Display "-1" DC values for Dormant Cutting (DC) stats:
   '#rankdc= '||CASE WHEN ss.stock_type = 'DC' THEN DENSE_RANK() OVER (ORDER BY ss.cut_fcut_reps DESC) ELSE '-1' END ||
   '#reps='||ss.nbr_of_replications||'#srate='||trunc(avg_survival_rate,2)||'#avg_ar='||ss.avg_ar_score||'#avgleaf='||ss.avg_leaf_score  as dc_rankings_2019,
   nr.all_ms_dc_rankings||'#arc='||ft.archived_trees||'#arc_leaf='||ft.arc_avg_leaf_score||'#arc_dbh_leaf='||fts.sum_score||
   '#arc_avg_dbh='||fts.arc_avg_dbh_cm || 'avg17dbh_rank='||ftms.ftms_sites_plustree_survival_score AS all_dc_archived_score
from vw_2019_2_nursery_key_stock_summary ss
LEFT JOIN (
  select field_trial_key, SUM(live_quantity) as archived_trees, SUM(field_cuttings_ft) as sum_field_cuttings_ft, trunc(AVG(leaf_score),2) as arc_avg_leaf_score
  from avw_field_trial
  WHERE id_test_spec = 60
  AND year_planted = '2017'  
  GROUP BY field_trial_key
) ft
ON ss.test_detail_key = ft.field_trial_key
LEFT JOIN (
  select test_detail_key, all_ms_dc_rankings from va2_all_nursery_rankings
) nr
ON ss.test_detail_key = nr.test_detail_key
LEFT JOIN (
 select field_trial_key, sum(sum_plus_dbh_leafscore) AS sum_score, trunc(AVG(avg_dbh_cm),2) AS arc_avg_dbh_cm
 from v2_field_trial_test_spec_summary
 WHERE id_test_spec = 60
 AND year_planted = '2017' 
 GROUP BY field_trial_key
) fts
ON ss.test_detail_key = fts.field_trial_key
LEFT JOIN (
select field_trial_key, 
nbr_of_sites as ftms_nbr_of_sites,
years_planted as ftms_years_planted,
nbr_of_stock_types as ftms_nbr_of_stock_types,
sites_plustree_survival_score as ftms_sites_plustree_survival_score
from v1_field_trial_master_summary 
) ftms
ON ss.test_detail_key = ftms.field_trial_key
LEFT JOIN (
  select swt_key AS swt_key,
  avg_undulation_level AS avg_undulation_level
  from  gpf2_figured_wood_split_tests_summary
) swt
ON ss.test_detail_key = swt.swt_key
order by ss.cut_fcut_reps desc;
--order by ss.test_detail_key;

---    ####################

CREATE VIEW vw_2019_6_nursery_summary_by_rep_nbr AS
SELECT min(a.test_detail_key) as min_test_detail, 
b.notes, 
--a.todo,
a.replication_nbr,
min(stock_type) as min_stock_type,
min(selection_type) as min_selection_type,
trunc(avg(a.leaf_score),2) as avg_leaf_score,
trunc(avg(a.ar_score),2) as avg_ar_score,
sum(a.start_quantity) AS sum_start_qty,
sum(a.end_quantity) AS sum_end_qty,
trunc((sum(a.end_quantity) / sum(a.start_quantity)),2) AS survival_rate,
trunc(avg(a.stock_dia_mm),2) AS avg_stock_dia_mm,
trunc(avg(a.stock_length_cm),2) AS avg_stock_length_cm,
trunc(avg(a.collar_median_dia_mm),2) AS avg_collar_median_dia_mm,
trunc(avg(a.stool_collar_median_dia_mm),2) avg_stool_collar_median_dia_mm,
trunc(avg(a.vigor_survival),2) as avg_vigor_survival,
trunc(avg(a.stool_vigor_survival),2) as avg_stool_vigor_survival,
sum(a.is_plus_tree) as sum_of_plus_trees,
sum(a.nursery_cuttings_ft) as sum_nursery_cuttings_ft
FROM va1_master_test_detail a,
(
  SELECT replication_nbr, notes
  FROM va1_master_test_detail
  WHERE year = '2019'
  AND test_type = 'nursery'
  AND plot_nbr > 0
) b
WHERE a.year = '2019'
AND test_type = 'nursery'
AND a.replication_nbr = b.replication_nbr
GROUP BY a.replication_nbr, b.notes 
ORDER BY a.replication_nbr;

CREATE VIEW vw_2019_7_stock AS
select test_detail_key,
rank_class,
selection_type,
stock_type,
nbr_of_replications,
sum_of_end_qty, 	
sum_nursery_cuttings_ft,
sum_field_cuttings_ft,
sum_of_plus_trees,
avg_survival_rate,
avg_stock_dia_mm,
archived_trees,
dc_rank,
dcms_rank
--family_class
from vw_2019_5_nursery_field_summary 
order by dc_rank;

CREATE VIEW vw_2019_8_stock_summary AS
select selection_type,
--family_class,
count(test_detail_key) as count_of_selection_types, 
trunc(avg(nbr_of_replications),2) as avg_replications,
sum(sum_of_end_qty) as sum_of_end_qty,
trunc(sum(sum_nursery_cuttings_ft),0) as sum_nursery_cuttings_ft,
trunc(sum(sum_field_cuttings_ft),0) as sum_field_cuttings_ft,
trunc(avg(avg_survival_rate),2) as avg_survival_rate,
trunc(avg(avg_stock_dia_mm),2) as avg_stock_dia_mm,
trunc(sum(sum_of_plus_trees),0) as sum_of_plus_trees,
sum(archived_trees) as sum_of_archived_trees
from vw_2019_7_stock
group by selection_type
order by avg_survival_rate desc; 


CREATE VIEW vw_2019_nursery_field_clone_summary AS
select
td.test_detail_key,
sum(td.nursery_cuttings_ft) AS sum_nursery_cuttings_ft,
min(vwfs.sum_field_cuttings_ft) AS sum_field_cuttings_ft,
min(vwfs.sum_of_plus_trees) as nursery_plus_trees, 
min(td.nursery_cuttings_ft) + min(vwfs.sum_field_cuttings_ft) AS total_cuttings_ft,
--max(td.notes2) AS Dormant_Cutting_2019_stats_notes2,
--max(td.notes3) AS Field_trial_stats_notes3,
max(p.alba_class) AS Alba_class,
max(td.selection_type) AS Selection_type,
min(arc_avg_dbh_cm) AS field_avg_dbh_cm,
min(archived_trees) AS field_trees,
--min(vwfs.all_ms_dc_archived_score) AS all_ms_dc_archived_scores
min(vwfs.ftms_sites_plustree_survival_score) as ftms_sites_plustree_survival_score,
min(dc_rankings_2019) as dc_rankings_2019, 
min(all_dc_archived_score) as all_dc_archived_score
from avw_test_detail td
LEFT JOIN (
  select test_detail_key,
  sum_field_cuttings_ft,
  dcms_rank,
  arc_avg_dbh_cm,
  archived_trees,
  dc_rankings_2019,
  all_dc_archived_score,
  sum_of_plus_trees,
  ftms_sites_plustree_survival_score
  from vw_2019_5_nursery_field_summary
) vwfs
ON td.test_detail_key = vwfs.test_detail_key  -- NOTE that records must be in nursery to get key.....
LEFT JOIN (
  select plant_key, alba_class from plant
) p
ON upper(td.test_detail_key) = upper(p.plant_key)
where td.test_spec_key  in ('2019-PostNE-West-Measurement','2019-bell-nursery')
group by td.test_detail_key
order by ftms_sites_plustree_survival_score desc NULLS Last, sum_nursery_cuttings_ft desc;

CREATE VIEW vw_2019_field_plus_clones AS
select * 
from test_detail
where id_test_spec = 63
order by planted_order;



/* Start multi-line comment
-- End Muli-line comment
*/ 
-- OPTIONAL todo ----------------------------
-- Update the Notes2 and Notes3 columns with the ms_dc_rankings_20NN and all_ms_dc_archived_score data for final action in the test_detail table. 
--UPDATE test_detail SET notes2 = (
--select coalesce(ms_dc_rankings_2019,'X') 
--from vw_2019_5_nursery_field_summary 
--where vw_2019_5_nursery_field_summary.id_order = test_detail.id
--and vw_2019_5_nursery_field_summary.test_detail_key = test_detail.test_detail_key
--order by test_detail.id desc limit 240); 
---------------------------------------