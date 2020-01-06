#!/bin/bash
# File: r4st-wrapper.sh 

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
psql postgres -c  "CREATE DATABASE r4d" 2>/dev/null
psql r4d -c "\d" 2>/dev/null
dbErr=$(echo $?)
if [[ $dbErr -ne 0 ]]; then
  echo "WARNING: The Postgres service is likely down, restarting now..."
  service postgresql restart
  echo "Restarted Postgres, checking status below..."
  /etc/init.d/postgresql status
  echo
else
   echo "Postgres server should be active..."
fi 


echo
echo "Setup postgres database for r4st with 4 environments..."
echo "  Database username/password credentials are: user/user"
psql postgres -c  "CREATE DATABASE r4d" 2>/dev/null
psql postgres -c  "CREATE DATABASE r4t" 2>/dev/null
psql postgres -c  "CREATE DATABASE r4s" 2>/dev/null
psql postgres -c  "CREATE DATABASE r4p" 2>/dev/null
echo

echo "Install the dbkiss database viewer application..."
sudo cp -rf ${APPS}/r4st/files/r4stdb /var/www/html
sudo chmod 777 /var/www/html/r4stdb/dbkiss_sql
ls -ltr /var/www/html/r4stdb|grep '^drwxrwxrwx'
chkerr "$?" "1" "The dbkiss file copy and/or chmod process failed"
echo

echo "Run the primary r4st database processes..."
./r4st-loader.sh  > ../logs/r4st-loader.log 2>&1 


chkdberr=$(egrep -i 'error|fatal|hint' ${APPS}/r4st/logs/r4st-loader.log)
if [[ -n $chkdberr ]]; then
   echo "FAILURE: Database load Errors found in ${APPS}/r4st/logs/r4st-loader.log" 
   echo "Fix the errors and re-run this process. Exiting now..."
   exit 1
fi

echo
grep DONE  ${APPS}/r4st/logs/r4st-loader.log
chkerr "$?" "1" "The r4st database process and log file did not complete"
echo "You can view the r4st PRD datbase at: http://localhost/r4stdb/dbkiss.php" 

echo "Extract the last 3 lines of the log file to capture the DONE text for the Regression test comparisons..."
tail -3 ../logs/r4st-loader.log > ../output/verifyDone-r4st-loader.log

