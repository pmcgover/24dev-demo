DROP USER IF EXISTS pmcgover_tst;
CREATE USER pmcgover_tst WITH PASSWORD '4Gotu=';

-- Grant select privs for non-prd database access: 
GRANT SELECT ON 
ipc_original_salix_epithet,
ipc_pedigree,
ipc_salix_epithet,
ipc_salix_family,
ipc_salix_species,
associate_all_parents,
associate_orig_and_new_salix_tables,
associate_original_to_epithet_data,
original_minus_epithet_key_data,
vw1_all_ipc_salix_epithet_species_family,
vw2_basic_ipc_salix_epithet_species_family,
vw3_basic_with_new_2019_test_data,
vw4_basic_count_summary,
vw5_ipc_salix_family_with_parent_keys
TO pmcgover_tst;
