#!/bin/bash
# File: ipc-loader.sh
# Usage: Execute ipc-wrapper.sh which calls this loader script, creates a log file and displays errors to stdout.
# open4st via Patrick N McGovern  
# Distributed via the Apache License

echo
echo BASE=$(pwd|cut -d"/" -f-6)
echo BASE=$BASE

echo
echo "This program is copyrighted under the MIT license.  See: https://github.com/pmcgover/24dev-demo/blob/master/LICENSE"
echo "Source the 24dev profile to set variables and display license/program details..."
if [[  -r ${BASE}/.24dev.profile ]]; then
   . ${BASE}/.24dev.profile
   echo
   echo "Display the associated MIT License file:"
   cat  ${MYDEV_NAME_PATH}/LICENSE
   echo
   echo "Display the associated README.md file header:"
   head -3 ${MYDEV_NAME_PATH}/README.md
   echo
else 
   echo "Failure: The profile is not readable or could not be found: ${BASE}/.24dev.profile"
   exit 1   
fi
echo 

cat <<-EOF 
Usage: ipc-loader.sh  
This program will execute the pgsql commands to create and load ipc plant database objects 
EOF
echo 

echo  "INFO: Drop the ipc database objects..."   
psql ipct -f $APPS/ipc/bin/sql/ipc-DropAll-Objects.sql
echo
echo  "INFO: Load the ipc database Tables..."   
psql ipct -f $APPS/ipc/bin/sql/ipc-Load-Tables.sql
echo
echo  "INFO: Load the ipc database Views..."   
psql ipct -f $APPS/ipc/bin/sql/ipc-Load-Views.sql
echo
echo  "INFO: Load the ipc database tables from the file list..."   
psql ipct -f $APPS/ipc/bin/sql/ipc-Copy.filelist -a
echo
echo  "INFO: Run SQL updates..."   
psql ipct -f $APPS/ipc/bin/sql/ipc-Updates.sql
echo
echo  "INFO: Create pedigree csv file from the recursive SQL and load into the pedigree table:"     
psql ipct -F "|" -t -f $APPS/ipc/bin/sql/ipc-pedigree.sql|grep . > ../csv/ipc_pedigree.csv
psql ipct -f $APPS/ipc/bin/sql/ipc-Copy-PostLoad.filelist  -a

echo 
echo "Create a new version of the ipc_DropAll-Objects.sql file..."
psql ipct -c "\dt" |grep table|cut -f2 -d"|"|awk '{print "DROP TABLE if exists " $1 " CASCADE;"}' > $APPS/ipc/bin/sql/ipc-DropAll-Objects.sql 
psql ipct -c "\dv" |grep view|cut -f2 -d"|"|awk '{print "DROP VIEW if exists " $1";"}' >> $APPS/ipc/bin/sql/ipc-DropAll-Objects.sql 
echo

echo "###########################"
echo "Start ipcr database to create a read-only database instance via logging in with the ro user..."
echo "###########################"
echo 
echo "Create a dump of the master ipct database, then load it into an existing but empty ipcr database... "
pg_dump ipct > $APPS/ipc/output/ipct.dump.sql
echo

echo  "INFO: Drop all existing tables and views from the ipcr database..."
psql ipcr -f $APPS/ipc/bin/sql/ipc-DropAll-Objects.sql
echo
echo "Load the ipct data into the ipcr database... "
psql ipcr < $APPS/ipc/output/ipct.dump.sql 
echo
echo

echo "Update the ipcr database to be read only (select priveleges)..." 
tableListFile="$APPS/ipc/bin/sql/ipc-tablelist.txt"
ipcGrantSelectAllTables="$APPS/ipc/bin/sql/ipc-GrantSelect-All-Tables.sql"
cat << EOF >    $tableListFile 
DROP USER IF EXISTS ipcr_ro;
CREATE USER ipcr_ro WITH PASSWORD 'user';

-- Grant select privs for non-prd database access: 
GRANT SELECT ON 
EOF
psql ipct -c "\dt" |grep table|cut -f2 -d"|"|awk '{print $1","}' >> $tableListFile 
psql ipct -c "\dv" |grep view|cut -f2 -d"|"|awk '{print $1","}'  >> $tableListFile 
# Now replace last comma with text:
sed '$ s/,//g' $tableListFile > $ipcGrantSelectAllTables
echo "TO ipcr_ro;" >> $ipcGrantSelectAllTables 
echo "#### End Make GrantSelect file #######################"

echo "Load the read only select privs into the ipcr database... "
psql ipcr <  $ipcGrantSelectAllTables
echo

echo 
echo "Create a dump of the read only ipcr database that could be used for export to another instance..."
pg_dump ipcr > $APPS/ipc/output/ipcr.dump.sql
echo


echo
echo "You can view the ipc database at: http://localhost/ipc/dbkiss.php"
echo "Login to the ipct database via the username: user and password: user"
echo "Login to the ipcr database via the username: ro and password: user"
psql --version
echo "The ipc database process is: DONE"
