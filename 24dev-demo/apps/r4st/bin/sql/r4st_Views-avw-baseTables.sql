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
td.planted_order,
td.selection_type,
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
td.field_cuttings_ft,
td.height_cm,
td.leaf_score,
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
ft.live_quantity,
ft.is_plus_ynu,
ft.live_dbh_cm,
ft.live_height_cm,
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
-- split_wood_tests Views:
CREATE VIEW gpf1_split_wood_tests_summary AS 
select swt_key AS swt_key,
count(replication_nbr) AS count_of_replications,
min(stem_dia_small_end_mm) as min_stem_dia_small_end_mm,
max(stem_dia_small_end_mm) as max_stem_dia_small_end_mm,
trunc(avg(stem_dia_small_end_mm),2) AS avg_stem_dia_small_end_mm,
trunc(avg(length_of_split_in),2) AS avg_length_of_split_in,
min(grain_pull_force_lb) AS min_grain_pull_force_lb,
max(grain_pull_force_lb) AS max_grain_pull_force_lb,
trunc(stddev_samp(grain_pull_force_lb),2) as sample_stdev_grain_pull_force_lb,
trunc(avg(grain_pull_force_lb),2) AS avg_grain_pull_force_lb,
trunc(avg(undulation_level),2) AS avg_undulation_level,
max(undulation_level) AS max_undulation_level,
trunc(avg(stem_dia_small_end_mm) / avg(grain_pull_force_lb),2) as diameter_per_pound
from avw_gpf_split_wood_tests 
GROUP by swt_key, replication_nbr
order by swt_key, replication_nbr;


CREATE VIEW gpf2_split_wood_tests_undulation AS 
select 
count(swt_key) AS count_of_undulation_samples,
count(distinct swt_key) AS count_of_undulation_clones,
trunc(avg(avg_stem_dia_small_end_mm),2) as avg_stem_dia_small_end_mm, 
trunc(avg(avg_length_of_split_in),2) AS avg_length_of_split_in,
trunc(avg(avg_grain_pull_force_lb),2) as avg_grain_pull_force_lb,
trunc(avg(sample_stdev_grain_pull_force_lb),2) as avg_sample_stdev_grain_pull_force_lb,
trunc(avg(diameter_per_pound),2) as diameter_per_pound, 
trunc(avg(avg_undulation_level),2) as avg_undulation_level
from gpf1_split_wood_tests_summary 
GROUP by avg_undulation_level 
order by avg_undulation_level desc;





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
-- Field Trial Views 

CREATE VIEW v1_field_trial_summary AS
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


CREATE VIEW v2_field_trial_2016_planting AS
SELECT field_trial_key,
sum_live_quantity,
sum_plus_trees,
avg_dbh_cm,
avg_leaf_score,
sum_plus_dbh_leafscore,
DENSE_RANK() OVER (ORDER BY sum_plus_dbh_leafscore DESC) as ranked_score_16, 
replication_nbr,
test_spec_key
FROM v1_field_trial_summary
WHERE test_spec_key = '2017-PostNE-West-Measured'
AND block_nbr = 1
ORDER BY sum_plus_dbh_leafscore DESC;


CREATE VIEW v3_field_trial_2017_planting AS
SELECT field_trial_key,
sum_live_quantity,
sum_plus_trees,
avg_dbh_cm,
avg_leaf_score,
sum_plus_dbh_leafscore,
DENSE_RANK() OVER (ORDER BY sum_plus_dbh_leafscore DESC) as ranked_score_17, 
replication_nbr,
test_spec_key
FROM v1_field_trial_summary
WHERE test_spec_key = '2017-PostNE-West-Measured'
AND block_nbr = 2
ORDER BY sum_plus_dbh_leafscore DESC;

CREATE VIEW v4_field_trial_ranked_summary AS
SELECT field_trial_key,
sum_live_quantity,
sum_plus_trees,
avg_dbh_cm,
avg_leaf_score,
sum_plus_dbh_leafscore,
id_test_spec,
DENSE_RANK() OVER (PARTITION BY replication_nbr ORDER BY sum_plus_dbh_leafscore DESC) AS ranked_reps, 
DENSE_RANK() OVER (PARTITION BY block_nbr ORDER BY sum_plus_dbh_leafscore DESC) AS ranked_blocks, 
DENSE_RANK() OVER (PARTITION BY block_nbr, id_test_spec ORDER BY sum_plus_dbh_leafscore DESC) AS ranked_blocks_specs,
DENSE_RANK() OVER (PARTITION BY block_nbr, replication_nbr ORDER BY sum_plus_dbh_leafscore DESC) AS ranked_blocks_reps,
replication_nbr,
block_nbr,
test_spec_key
FROM v1_field_trial_summary
ORDER BY sum_plus_dbh_leafscore DESC;

CREATE VIEW v5_field_trial_tree_shelter_2017 AS
SELECT
ft.field_trial_key,
ft.id,
ft.notes,
ft.notes2 AS test_name,
ft.notes3 AS Tube_Sleeve_Control, --Treatment
ft.planted_order,
ft.live_quantity,
ft.is_plus_ynu,
ft.live_dbh_cm,
ft.live_height_cm,
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
AND ft.id_site = s.id
AND ft.id_site IN (12,13);

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
td.planted_order,
td.selection_type,
td.stock_type,
td.start_quantity,
td.end_quantity,
td.stock_dia_mm,
td.height_cm,
td.leaf_score,
td.stock_length_cm,
td.collar_median_dia_mm,
td.stool_collar_median_dia_mm,
td.field_cuttings_ft,
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
sum(field_cuttings_ft) as sum_of_field_cuttings_ft,
trunc(avg(field_cuttings_ft),2) as avg_field_cuttings_ft,
trunc(avg(stool_vigor_survival),2) as avg_stool_vigor_survival,
CASE WHEN trunc(avg(vigor_survival),2) > 0 THEN trunc(avg(vigor_survival),2) ELSE 0 END as avg_vigor_survival,
trunc(avg(vigor_survival),2) + sum(is_plus_tree)  as vigorsurvival_plus_plustrees,
trunc(avg(stool_vigor_survival),2) + trunc(avg(field_cuttings_ft),2) as stoolvs_plus_fcuttings,
trunc(avg(vigor_survival),2) + trunc(avg(field_cuttings_ft),2) as vigorsurvival_plus_fcuttings
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
sum(field_cuttings_ft) as sum_of_field_cuttings_ft,
trunc(avg(field_cuttings_ft),2) as avg_field_cuttings_ft,
trunc(avg(stool_vigor_survival),2) as avg_stool_vigor_survival,
CASE WHEN trunc(avg(vigor_survival),2) > 0 THEN trunc(avg(vigor_survival),2) ELSE 0 END as avg_vigor_survival,
trunc(avg(vigor_survival),2) + sum(is_plus_tree)  as vigorsurvival_plus_plustrees,
trunc(avg(stool_vigor_survival),2) + trunc(avg(field_cuttings_ft),2) as stoolvs_plus_fcuttings,
trunc(avg(vigor_survival),2) + trunc(avg(field_cuttings_ft),2) as vigorsurvival_plus_fcuttings
from va1_master_test_detail   
where test_type = 'nursery' 
group by test_detail_key
order by vigorsurvival_plus_fcuttings desc;


CREATE VIEW va4_nursery_dormant_cutting_summary AS
select
test_detail_key,
stock_type,
count(replication_nbr) as nbr_of_replications,
count(distinct year) as nbr_of_years,
sum(start_quantity) as sum_of_start_qty,
sum(end_quantity) as sum_of_end_qty,
sum(is_plus_tree) as sum_of_plus_trees,
trunc(avg(survival_rate),2) as avg_survival_rate,
trunc(avg(stock_dia_mm),2) as avg_stock_dia_mm,
--corr(survival_rate,stock_dia_mm)  AS correlate_survival_to_stock_dia, -- TEMP...
--CASE WHEN corr(survival_rate,stock_dia_mm) IS NULL THEN NULL
--     ELSE  trunc(to_number(corr(survival_rate,stock_dia_mm)),2) END AS corr_survival_stock_dia,
trunc(avg(collar_median_dia_mm),2) as avg_collar_median_dia_mm,
sum(field_cuttings_ft) as sum_of_field_cuttings_ft,
trunc(avg(field_cuttings_ft),2) as avg_field_cuttings_ft,
trunc(avg(stool_vigor_survival),2) as avg_stool_vigor_survival,
CASE WHEN trunc(avg(vigor_survival),2) > 0 THEN trunc(avg(vigor_survival),2) ELSE 0 END as avg_vigor_survival,
trunc(avg(vigor_survival),2) + sum(is_plus_tree)  as vigorsurvival_plus_plustrees,
trunc(avg(stool_vigor_survival),2) + trunc(avg(field_cuttings_ft),2) as stoolvs_plus_fcuttings,
trunc(avg(vigor_survival),2) + trunc(avg(field_cuttings_ft),2) as vigorsurvival_plus_fcuttings
from va1_master_test_detail
where test_type = 'nursery'
and stock_type in ('DC','FDC','ODC')
group by test_detail_key, stock_type
order by vigorsurvival_plus_fcuttings desc;


------------------------------------------------------------------------------
------------------------------------------------------------------------------

CREATE VIEW vw_2004_nursery_seedling_summary AS
select test_detail_key, 
min(notes) as min_notes,
count(test_detail_key) as count_test_detail_key,
sum(start_quantity) as sum_start_quantity,
sum(end_quantity) as sum_end_quantity,
trunc(sum(end_quantity) / sum(start_quantity),2) as survival_rate,
sum(stock_dia_mm) as sum_stock_dia_mm,
trunc(avg(nullif(stock_dia_mm,0)),2) as avg_dia_mm,
sum(height_cm) as sum_height_cm,
trunc(avg(nullif(height_cm,0)),2) as avg_height_cm,
trunc(sum(end_quantity) / sum(start_quantity) * avg(nullif(height_cm,0)),2) as avg_height_times_survivalrate,
trunc(sum(end_quantity) / sum(start_quantity) * avg(nullif(stock_dia_mm,0)),2) as avg_diameter_times_survivalrate,
min(replication_nbr) as min_rep_nbr,
min(stock_type) as min_stock_type
from avw_test_detail
where  test_spec_key = '2004-bell-nursery-hgt-dia-meas'
group by test_detail_key
order by avg_height_times_survivalrate desc; -- avg_diameter_times_survivalrate

------------------------------------------------------------------------------
------------------------------------------------------------------------------

CREATE VIEW vw_2017_1_nursery AS
select
td.test_detail_key,
td.id,
td.notes,
td.notes2 as ranks_2017,
td.notes3 as rank_class, 
td.planted_order,
td.selection_type,
td.stock_type,
td.stock_length_cm,
td.stock_dia_mm,
td.start_quantity,
td.end_quantity,
td.field_cuttings_ft, 
td.collar_median_dia_mm,
td.stool_collar_median_dia_mm,
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
and test_spec_key = '2017-bell-nursery' -- Master 2017 VIEW -----------------------
order by vigor_survival desc;

CREATE VIEW vw_2017_2_nursery_key_stock_summary AS
select distinct test_detail_key,
stock_type,
min(id) as id_order,
min(rank_class) as rank_class,
--CASE WHEN min(rank_class) LIKE '%~%' THEN 'Primary - Elite'
--     WHEN min(rank_class) LIKE '%#%' THEN 'Secondary - Archive'
--     WHEN min(rank_class) LIKE '%@%' THEN 'Tertiary - Parent'
--     WHEN min(rank_class) LIKE '%&%' THEN 'Pending - Decision'
--     WHEN min(rank_class) LIKE '%?%' THEN 'Families - Re-test' ELSE 'Discard' END AS selection_type,
-- Class: U=unknown, P=Primary/elite, S=Secondary/archive, T=Tertiary/Parent, F=Family, R=Retest, D=Discard
CASE WHEN min(selection_type) = 'P' THEN 'Primary - Elite'
WHEN min(selection_type) = 'S' THEN 'Secondary - Archive'
WHEN min(selection_type) = 'T' THEN 'Tertiary - Parent'
WHEN min(selection_type) = 'F' THEN 'Family - Retest'
WHEN min(selection_type) = 'R' THEN 'Retest - Clone'
WHEN min(selection_type) = 'U' THEN 'Unknown'
WHEN min(selection_type) = 'D' THEN 'Discard' ELSE 'ERROR - Mislabeled'  END AS selection_type,
count(replication_nbr) as nbr_of_replications,
sum(start_quantity) as sum_of_start_qty,
sum(end_quantity) as sum_of_end_qty,
sum(field_cuttings_ft) as sum_field_cuttings,
sum(is_plus_tree) as sum_of_plus_trees,
trunc(avg(survival_rate),2) as avg_survival_rate,
trunc(avg(vigor_survival),2) as avg_vigor_survival_rate,
trunc(avg(stool_vigor_survival),2) as avg_stool_vigor_survival_rate,
trunc(avg(stock_dia_mm),2) as avg_stock_dia_mm,
--corr(survival_rate,stock_dia_mm) as corr_survival_stock_dia_mm,
trunc(avg(collar_median_dia_mm),2) as avg_collar_median_dia_mm,
trunc(avg(stool_collar_median_dia_mm),2) as avg_stool_collar_mm,
-- CASE WHEN trunc(avg(vigor_survival),2) > 0 THEN trunc(avg(vigor_survival),2) ELSE 0 END as avg_vigor_survival,
-- trunc(avg(vigor_survival),2) + sum(is_plus_tree)  as vs_and_plustrees,
--  trunc(avg(vigor_survival),2) + sum(is_plus_tree) + sum(stool_vigor_survival) as vs_and_plustrees_and_stoolvs,
--trunc(  trunc(avg(stool_vigor_survival),2) + trunc(avg(field_cuttings_ft),2) * (count(replication_nbr) *.1),2) as stoolvs_fcuttings_reps,
trunc(avg(stool_vigor_survival) + avg(field_cuttings_ft) * (count(replication_nbr) *.1),2) as stools_cut_fcut_reps,
trunc(avg(vigor_survival) + avg(field_cuttings_ft) * (count(replication_nbr) *.1),2) as cut_fcut_reps
from vw_2017_1_nursery
GROUP BY test_detail_key, stock_type
order by cut_fcut_reps desc;

CREATE VIEW vw_2017_3_nursery_stock_summary AS
select stock_type,
count(stock_type) as stock_type_count,
sum(sum_of_start_qty) as planted_trees,
sum(sum_of_end_qty) as available_trees,
sum(sum_field_cuttings) as field_grade_cuttings,
sum(sum_of_plus_trees) as plus_trees,
trunc(avg(avg_survival_rate),2) as avg_survival_rate,
CASE WHEN trunc(avg(avg_stock_dia_mm),2) > 0 THEN trunc(avg(avg_stock_dia_mm),2) ELSE NULL END as avg_stock_dia_mm,
CASE WHEN trunc(avg(avg_collar_median_dia_mm),2) > 0 THEN trunc(avg(avg_collar_median_dia_mm),2) ELSE NULL END as avg_1_0_collar_median_dia_mm,
CASE WHEN trunc(avg(avg_stool_collar_mm),2) > 0 THEN trunc(avg(avg_stool_collar_mm),2) ELSE NULL END as avg_stool_collar_median_dia_mm
from vw_2017_2_nursery_key_stock_summary 
group by stock_type
order by stock_type_count desc;


CREATE VIEW vw_2017_4_nursery_action_stock_summary AS
select selection_type,
stock_type,
count(stock_type) as stock_type_count,
sum(sum_of_start_qty) as planted_trees,
sum(sum_of_end_qty) as available_trees, 
sum(sum_field_cuttings) as field_grade_cuttings,
sum(sum_of_plus_trees) as plus_trees,
trunc(avg(avg_survival_rate),2) as avg_survival_rate,
CASE WHEN trunc(avg(avg_stock_dia_mm),2) > 0 THEN trunc(avg(avg_stock_dia_mm),2) ELSE NULL END as avg_stock_dia_mm,
CASE WHEN trunc(avg(avg_stool_collar_mm),2) > 0 THEN trunc(avg(avg_stool_collar_mm),2) ELSE NULL END as avg_stool_collar_median_dia_mm,
CASE WHEN trunc(avg(avg_collar_median_dia_mm),2) > 0 THEN trunc(avg(avg_collar_median_dia_mm),2) ELSE NULL END as avg_1_0_collar_median_dia_mm
from vw_2017_2_nursery_key_stock_summary 
group by selection_type, stock_type
order by selection_type desc;


CREATE VIEW vw_2017_5_nursery_field_summary AS
select
ss.test_detail_key,
ss.stock_type,
ss.id_order,
ss.rank_class,
ss.selection_type,
ss.nbr_of_replications,
ss.sum_of_start_qty,
ss.sum_of_end_qty,
ss.sum_field_cuttings,
ss.sum_of_plus_trees,
ss.avg_survival_rate,
ss.avg_stock_dia_mm,
ss.avg_collar_median_dia_mm,
ss.avg_stool_collar_mm,
ss.stools_cut_fcut_reps,
ss.cut_fcut_reps,
CASE WHEN ss.stock_type = 'MS' THEN DENSE_RANK() OVER (ORDER BY ss.stools_cut_fcut_reps DESC) ELSE '-1' END AS stool_rank,
CASE WHEN ss.stock_type = 'DC' THEN DENSE_RANK() OVER (ORDER BY ss.cut_fcut_reps DESC) ELSE '-1' END AS dc_rank,
CASE WHEN ft.archived_trees IS NULL THEN 0 ELSE ft.archived_trees END as archived_trees,
-- REGEXP_REPLACE(rank_class, '^.*class=', '') as family_class, -- need to store/access this from the taxa table.
/* Comment out rank_class_summary that is now duplicated in the rank_class field:
*/
ss.test_detail_key||
   -- Display "-1" MS values for Mini-Stool (MS) stats:
   '~rankms= '||CASE WHEN ss.stock_type = 'MS' THEN DENSE_RANK() OVER (ORDER BY ss.stools_cut_fcut_reps DESC) ELSE '-1' END||
   -- Display "-1" DC values for Dormant Cutting (DC) stats:
   '_rankdc= '||CASE WHEN ss.stock_type = 'DC' THEN DENSE_RANK() OVER (ORDER BY ss.cut_fcut_reps DESC) ELSE '-1' END ||
   '_reps='||ss.nbr_of_replications||'_srate='||trunc(avg_survival_rate,2)  as ms_dc_rankings_2017,
nr.all_ms_dc_rankings||'_archived='||ft.archived_trees||'_field_score='||fts.sum_score AS all_ms_dc_archived_score
from vw_2017_2_nursery_key_stock_summary ss
LEFT JOIN (
  select field_trial_key, SUM(live_quantity) as archived_trees
  from avw_field_trial
  where id_test_spec = 30
  GROUP BY field_trial_key
) ft
ON ss.test_detail_key = ft.field_trial_key
LEFT JOIN (
  select test_detail_key, all_ms_dc_rankings from va2_all_nursery_rankings
) nr
ON ss.test_detail_key = nr.test_detail_key
LEFT JOIN (
 select field_trial_key, sum(sum_plus_dbh_leafscore) AS sum_score
 from v1_field_trial_summary
 where id_test_spec = 30
 GROUP BY field_trial_key
) fts
ON  ss.test_detail_key = fts.field_trial_key
order by ss.cut_fcut_reps desc;
--order by ss.test_detail_key;


CREATE VIEW vw_2017_6_nursery_summary_by_rep_nbr AS
SELECT min(a.test_detail_key) as min_test_detail, 
b.notes, 
a.replication_nbr,
min(stock_type) as min_stock_type,
min(selection_type) as min_selection_type,
trunc(avg(a.leaf_score),2) as avg_leaf_score,
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
sum(a.field_cuttings_ft) as sum_of_field_cuttings_ft
FROM va1_master_test_detail a,
(
  SELECT replication_nbr, notes
  FROM va1_master_test_detail
  WHERE year = '2017'
  AND test_type = 'nursery'
  AND plot_nbr > 0
) b
WHERE a.year = '2017'
AND test_type = 'nursery'
AND a.replication_nbr = b.replication_nbr
GROUP BY a.replication_nbr, b.notes
ORDER BY a.replication_nbr;

--/*
-- Fix below or remove as needed 
CREATE VIEW vw_2017_7_stock AS
select test_detail_key,
rank_class,
selection_type,
stock_type,
nbr_of_replications,
sum_field_cuttings,
sum_of_plus_trees,
avg_survival_rate,
avg_stock_dia_mm,
archived_trees,
dc_rank
--family_class
from vw_2017_5_nursery_field_summary 
order by dc_rank;


CREATE VIEW vw_2017_8_stock_summary AS
select selection_type,
--family_class,
count(test_detail_key) as count_of_selection_types, 
trunc(avg(nbr_of_replications),2) as avg_replications,
trunc(avg(sum_field_cuttings),2) as avg_field_grade_cuttings,
trunc(sum(sum_field_cuttings),0) as sum_of_field_grade_cuttings,
trunc(avg(avg_survival_rate),2) as avg_survival_rate,
trunc(avg(avg_stock_dia_mm),2) as avg_stock_dia_mm,
trunc(sum(sum_of_plus_trees),0) as sum_of_plus_trees,
sum(archived_trees) as sum_of_archived_trees
from vw_2017_7_stock
group by selection_type
order by avg_survival_rate desc; 

--*/

CREATE VIEW vw_2017_9_te_law_test AS
SELECT
td.test_detail_key,
td.id,
td.notes,
td.planted_order,
td.selection_type,
td.stock_type,
td.stock_length_cm,
td.stock_dia_mm,
td.start_quantity,
td.end_quantity,
td.field_cuttings_ft AS onefoot_cuttings,
td.stool_collar_median_dia_mm,
trunc((td.end_quantity / td.start_quantity),2) AS survival_rate,
trunc((td.end_quantity / td.start_quantity),2) * td.stool_collar_median_dia_mm  AS stool_vigor_survival,
trunc((td.end_quantity / td.start_quantity),2) * td.field_cuttings_ft  AS onefoot_cuttings_survival,
td.is_plus_ynu,
CASE WHEN is_plus_ynu = 'Y' THEN 1 ELSE 0 END AS is_plus_tree,
td.row_nbr,
td.column_nbr,
td.replication_nbr,
td.block_nbr
FROM test_detail td,
test_spec ts
WHERE td.id_test_spec = ts.id
AND test_spec_key = '2017-bell-nursery' -- Master 2017 VIEW --
AND test_detail_key LIKE 'te%'
ORDER BY onefoot_cuttings_survival DESC;


CREATE VIEW vwa_2017_10_te_law_test_summary AS
SELECT 
min(test_detail_key) AS min_test_detail_key,
min(notes) AS test_description,
trunc(avg(stock_length_cm),1) AS avg_planted_stock_length_cm,
trunc(avg(stock_dia_mm),1) AS avg_planted_stock_dia_mm,
sum(start_quantity) AS sum_start_qty,
sum(end_quantity) AS sum_end_qty,
trunc(avg(onefoot_cuttings),1) AS avg_onefoot_cuttings,
sum(onefoot_cuttings) AS sum_onefoot_cuttings,
trunc(avg(stool_collar_median_dia_mm),1) AS stool_collar_median_dia_mm,
trunc(avg(survival_rate),1) AS avg_survival_rate,
trunc(avg(stool_vigor_survival),1) AS avg_stool_vigor_survival,
trunc(avg(onefoot_cuttings_survival),1) AS avg_onefoot_cuttings_survival,
sum(is_plus_tree) AS sum_is_plus_tree
FROM vw_2017_9_te_law_test
GROUP BY block_nbr
ORDER BY avg_onefoot_cuttings_survival DESC;


