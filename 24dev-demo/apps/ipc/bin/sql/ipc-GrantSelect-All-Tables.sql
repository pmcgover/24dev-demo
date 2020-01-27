DROP USER IF EXISTS ipcr_ro;
CREATE USER ipcr_ro WITH PASSWORD 'user';

-- Grant select privs for non-prd database access: 
GRANT SELECT ON 
ipc_original_salix_epithet,
ipc_salix_epithet,
ipc_salix_family,
ipc_salix_pedigree,
associate_all_parents,
associate_orig_and_new_salix_tables,
associate_original_to_epithet_data,
avw_ipc_salix_epithet,
avw_ipc_salix_family,
vw1_test_original_minus_epithet_key_data,
vw2_all_ipc_salix_epithet_family,
vw3_checklist_root_level_epithet,
vw4_checklist_epithet_family,
vw5_basic_count_summary
TO ipcr_ro;
