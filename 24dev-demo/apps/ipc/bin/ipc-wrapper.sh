#!/bin/bash
# File: ipc-wrapper.sh 

echo "Starting script on:" $(date)
echo BASE=$(pwd|cut -d"/" -f-6)
echo

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

echo "Verify that the Postgres server is alive by creating a database, test against it, restart if needed..."
psql postgres -c  "CREATE DATABASE ipct" 2>/dev/null
psql ipct -c "\d" 2>/dev/null
dbErr=$(echo $?)
if [[ $dbErr -ne 0 ]]; then
  echo "WARNING: The Postgres service is likely down, restarting now..."
  service postgresql restart
  echo "Restarted Postgres, checking status below..."
  /etc/init.d/postgresql status
  echo
else
   echo "Postgres server should be active..."
   echo "Drop all databases to ensure a clean system..." 
   psql postgres -c "DROP DATABASE IF EXISTS ipct" 2>/dev/null
   psql postgres -c "DROP DATABASE IF EXISTS ipcr" 2>/dev/null
fi 

echo
echo "Setup postgres IDC Salix databases 2 database environments..."
echo "  Database username/password credentials are: user/user"
psql postgres -c  "CREATE DATABASE ipct" 2>/dev/null
psql postgres -c  "CREATE DATABASE ipcr" 2>/dev/null
echo

echo "Install the dbkiss database viewer application..."
echo user | sudo -S cp -rf ${APPS}/ipc/files/ipc /var/www/html
echo user | sudo -S chmod 777 /var/www/html/ipc/dbkiss_sql
ls -ltr /var/www/html/ipc|grep '^drwxrwxrwx'
chkerr "$?" "1" "The dbkiss file copy and/or chmod process failed"
echo

echo "Run the primary ipc database processes..."
./ipc-loader.sh  > ../logs/ipc-loader.log 2>&1 


chkdberr=$(egrep -i 'error|fatal|hint|No such file or directory' ${APPS}/ipc/logs/ipc-loader.log)
if [[ -n $chkdberr ]]; then
   echo "FAILURE: Database load Errors found in ${APPS}/ipc/logs/ipc-loader.log" 
   echo "Fix the errors and re-run this process. Exiting now..."
   exit 1
fi

echo
grep DONE  ${APPS}/ipc/logs/ipc-loader.log
chkerr "$?" "1" "The ipc database process and log file did not complete"
echo "You can view the read only test IPC database at: http://localhost/ipc/ipcr.php" 
echo "You can view the editable test IPC database at: http://localhost/ipc/ipct.php" 

echo "Extract the last 3 lines of the log file to capture the DONE text for the Regression test comparisons..."
tail -3 ../logs/ipc-loader.log > ../output/verifyDone-ipc-loader.log

