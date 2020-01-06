#!/bin/bash
# File: r4st-loader.sh 
# purpose: Execute the pgsql commands to create and load r4st database objects 
# r4st by Patrick McGovern  
# Distributed via the Apache License

echo "Backup the r4st folder...."
cp -rf /home/dad/myGoogleDocs/Pat-Private/r4st /home/dad/myGoogleDocs/Pat-Private/r4st-BAK-auto
# Copy a file every other day: https://unix.stackexchange.com/questions/16093/how-can-i-tell-cron-to-run-a-command-every-other-day-odd-even
test $(($(date +%j) % 2)) == 0 && cp -rf /home/dad/myGoogleDocs/Pat-Private/r4st /home/dad/myGoogleDocs/Pat-Private/r4st-BAK-auto2 #even days 
test $(($(date +%j) % 2)) != 0 && cp -rf /home/dad/myGoogleDocs/Pat-Private/r4st /home/dad/myGoogleDocs/Pat-Private/r4st-BAK-auto1 #odd days 

echo
echo  "INFO: Drop all existing tables and views from the PRD database..."
psql r4p -f ../sql/r4st_DropAll-Objects.sql
echo

echo
echo  "INFO: Load the primary tables with the default initial inserts..."
psql r4p -f ../sql/r4st-Load-AllTables.sql

echo
echo  "INFO: Load the primary data for the above tables..." 
psql r4p -f  ../sql/r4st-Copy.filelist -a
echo

echo
echo  "INFO: Load updates for the above tables..." 
psql r4p -f  ../sql/r4st_Updates.sql
echo

# Run PRD pedigree process
echo  "INFO: Create PRD pedigree csv file from the recursive SQL file and load into the pedigree table:"     
psql r4p -F "|" -t -f ../sql/r4st-pedigree.sql|grep . > ../csv/r4st-pedigree.csv
psql r4p -f  ../sql/r4st-Copy-PostLoad.filelist  -a
echo

echo
echo  "INFO: Load the r4stdb AVW basic table VIEWS with foreign keys..." 
psql r4p -f  ../sql/r4st_Views-avw-baseTables.sql
echo

echo
echo  "INFO: Load the r4stdb descriptive table VIEWS..." 
psql r4p -f  ../sql/r4st_Views-vw-TrialOrEvents.sql
echo

echo 
echo "Create a dump of the master PRD database, then load it into an existing but empty SIT database... "
 pg_dump r4p > r4p.dump.sql
echo

echo  "INFO: Drop all existing tables and views from the SIT database..."
 psql r4s -f ../sql/r4st_DropAll-Objects.sql
echo
echo "Load the PRD data into the SIT database... "
echo "... Only works on an empty database so only run once - Need to add repeatability..."  
  psql r4s < r4p.dump.sql 
echo
echo

echo "###########################"
echo "Start SIT r4s database copy process..."
echo "Make r4st_GrantSelect file with current table names...."
echo "###########################"

tableListFile=../sql/tablelist.txt
cat << EOF > $tableListFile 
DROP USER IF EXISTS pmcgover_r;
CREATE USER pmcgover_r WITH PASSWORD 'go4pop';

-- Grant select privs for non-prd database access: 
GRANT SELECT ON 
EOF
psql r4p -c "\dt" |grep table|cut -f2 -d"|"|awk '{print $1","}' >> $tableListFile 
psql r4p -c "\dv" |grep view|cut -f2 -d"|"|awk '{print $1","}'  >> $tableListFile 
# Now replace last comma with text:
sed '$ s/,//g' $tableListFile > ../sql/r4st_GrantSelect-All-Tables.sql 
echo "TO pmcgover_r;" >> ../sql/r4st_GrantSelect-All-Tables.sql
echo "#### End Make GrantSelect file #######################"

echo "Load the SIT select privs into the SIT database... "
 psql r4s < ../sql/r4st_GrantSelect-All-Tables.sql
echo

echo 
echo "Create a dump of the master SIT database for export..."
 pg_dump r4s > r4s.dump.sql
echo

######################################################################
echo 
echo "Create a new version of the r4st_DropAll-Objects.sql file..."
psql r4p -c "\dt" |grep table|cut -f2 -d"|"|awk '{print "DROP TABLE if exists " $1 " CASCADE;"}' > ../sql/r4st_DropAll-Objects.sql 
psql r4p -c "\dv" |grep view|cut -f2 -d"|"|awk '{print "DROP VIEW if exists " $1";"}' >> ../sql/r4st_DropAll-Objects.sql 
echo

echo
echo "Extract all table description data via pgsql and load into a text file" 
echo "id~table_name~table_description" > ../csv/table_description.txt
for tableName in $(psql r4p -c "\dt" |grep table|cut -f2 -d"|")
do
    idCount=$((idCount+1))
    echo "#################  Table Nbr: $idCount ######  Table Name: $tableName ##############################################" >> ../csv/table_description.txt
    psql r4p -c "\d $tableName" |sed 's/"//g' > ../csv/TMP.txt                
    cat ../csv/TMP.txt   >> ../csv/table_description.txt
done
echo
rm ../csv/TMP.txt


<<COMMENT_OUT
echo "Check for undesireable characters in the CSV files..."
chkBadChars=$(grep -R '"' ../csv/*)
if [[ -n $chkBadChars ]]; then
  echo "ERROR: Found double quotes in the CSV files! Please remove them..."
  echo "See log file for details..."
  grep -R '"' ../csv/*
fi   
COMMENT_OUT

echo "DONE"
psql --version

