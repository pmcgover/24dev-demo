#!/bin/bash
# File: ipc-loader.sh 
# purpose: Execute the pgsql commands to create and load ipc database objects 
# open4st via Patrick N McGovern  
# Distributed via the Apache License


echo  "INFO: Drop the TST Test tables..."   
psql r4t -f ../sql/TST/TST_DropAll-Objects.sql

########################
<<COMMENT_OUT
echo "INFO: Create the separate PTST Pedigree process for POC development..."
psql r4t -f  ../sql/PTST/ptst-load-pedigree.sql
psql r4t -f  ../sql/PTST/ptst-pedigree.sql
psql r4t -F "|" -t -f ../sql/PTST/ptst-pedigree.sql|grep . > ../csv/PTST/ptst_pedigree.csv
psql r4t -f ../sql/PTST/ptst-Copy.filelist -a
echo
COMMENT_OUT
########################

echo
echo  "INFO: Drop and Load the TST Test tables..."   
psql r4t -f ../sql/TST/ipc-Load-Tables.sql
psql r4t -f ../sql/TST/ipc-Load-Views.sql
psql r4t -f ../sql/TST/ipc-Copy.filelist -a
psql r4t -f  ../sql/TST/ipc-Updates.sql
echo  "INFO: Create TST pedigree csv file from the recursive SQL file and load into the pedigree table:"     
psql r4t -F "|" -t -f ../sql/TST/ipc-pedigree.sql|grep . > ../csv/TST/ipc_pedigree.csv
psql r4t -f  ../sql/TST/ipc-Copy-PostLoad.filelist  -a

echo "###########################"
echo "Start TST r4t database copy process..."
echo "Make TST r4st_GrantSelect file with current table names...."
echo "###########################"

TSTtableListFile=../sql/TST/TST_tablelist.txt
cat << EOF > $TSTtableListFile 
DROP USER IF EXISTS pmcgover_tst;
CREATE USER pmcgover_tst WITH PASSWORD '4Gotu=';

-- Grant select privs for non-prd database access: 
GRANT SELECT ON 
EOF
psql r4t -c "\dt" |grep table|cut -f2 -d"|"|awk '{print $1","}' >> $TSTtableListFile 
psql r4t -c "\dv" |grep view|cut -f2 -d"|"|awk '{print $1","}'  >> $TSTtableListFile 
# Now replace last comma with text:
sed '$ s/,//g' $TSTtableListFile > ../sql/TST/TST_GrantSelect-All-Tables.sql 
echo "TO pmcgover_tst;" >> ../sql/TST/TST_GrantSelect-All-Tables.sql
echo "#### End Make GrantSelect file #######################"

echo "Load the TST select privs into the TST database... "
 psql r4t < ../sql/TST/TST_GrantSelect-All-Tables.sql
echo

echo 
echo "Create a dump of the master SIT database for export..."
 pg_dump r4t > r4t.dump.sql
echo

echo "Create a new version of the TST_DropAll-Objects.sql file..."
psql r4t -c "\dt" |grep table|cut -f2 -d"|"|awk '{print "DROP TABLE if exists " $1 " CASCADE;"}' > ../sql/TST/TST_DropAll-Objects.sql 
psql r4t -c "\dv" |grep view|cut -f2 -d"|"|awk '{print "DROP VIEW if exists " $1";"}' >> ../sql/TST/TST_DropAll-Objects.sql 
echo

<<COMMENT_OUT
boo
COMMENT_OUT

echo "DONE"
psql --version

