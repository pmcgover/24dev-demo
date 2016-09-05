#!/bin/bash
# File: install2Osgeo.sh

# Check function to validate succesful process completion: 
chkerr()
{
if [[ ${1} -gt 0 ]] ; then
   ###  Error message in lines below, do not change spacing: ###
   errMsg="`date`
   FAILURE: UnixExitCode=${1}, ScriptExitCode=${2}
   ${3}"
   ###  Error message in lines Above, do not change spacing: ###
   echo
   echo "${errMsg}"
   echo
   exit ${2}
fi
}

echo "Starting script on:" $(date)
echo

echo "Update the 24dev profile with the base pathname, all scripts should source this profile..."
BASE=$(readlink -f ../../..)
echo BASE=$BASE
sed -i.bak "s%BASE=.*$%BASE=$BASE%" ${BASE}/.24dev.profile 
chkerr "$?" "1" "The ${BASE}/.24dev.profile file was not available or the sed command failed."

echo "Source the 24dev profile and display the global variables..."
. ${BASE}/.24dev.profile 
chkerr "$?" "1" "The ${BASE}/.24dev.profile file was not available."

echo "Display profile Global variables:"
echo "BASE=$BASE"
echo "APPS=$APPS"
echo "DOCS=$DOCS"
echo "MYDEV_NAME=$MYDEV_NAME"
echo

echo "Make sure all files are executable..." 
chmod -R 755 ${BASE}
chkerr "$?" "1" "The following command failed: chmod -R 755 ${BASE}" 
echo

cat <<-EOF 
This script will install the $MYDEV_NAME addon to OSGeo.
Please test on an OSGeo Live DVD before installing to your system!

Usage: ./install2Osgeo.sh  
EOF
echo

echo "Display the associated License file header:"
head -4 ../../../../LICENSE 
chkerr "$?" "1" "The following command failed: head -4 ../../../../LICENSE"   
echo

echo "Display the associated README.md file:"
cat  ../../../../README.md
chkerr "$?" "1" "The following command failed: head -4 ../../../../LICENSE"   
echo

echo
echo "Setup postgres database for r4st with 4 environments..."
echo "  Database username/password credentials are: user/user"
psql postgres -c  "CREATE DATABASE r4d"
psql postgres -c  "CREATE DATABASE r4t"
psql postgres -c  "CREATE DATABASE r4s"
psql postgres -c  "CREATE DATABASE r4p"
echo

##########   Start Profile Updates ############
echo "Checking if this install script previously updated the .bashrc profile..."
if [[ -r ~/.bashrc.ORIG ]] ; then
  cp ~/.bashrc.ORIG ~/.bashrc
  echo "The .bashrc was previously updated..."
else
  cp ~/.bashrc ~/.bashrc.ORIG
  echo "The .bashrc was NOT previously updated..."
fi
 
echo "Appending custom aliases to the .bashrc profile ..."
echo >>  ~/.bashrc
echo "# Source the 24dev profile to enable the aliases below." >>  ~/.bashrc
echo ". ${BASE}/.24dev.profile"  >>  ~/.bashrc

echo
cat << 'EOF' >> ~/.bashrc

# 24dev Custom Aliases: 
alias cp='cp '
alias mv='mv '
alias rm='rm '
alias l='ls -ltr' 
alias ll='ls -ltra'
alias sql='cd ${APPS}/r4st/sql'
alias csv='cd ${APPS}/r4st/csv'
alias rr='cd ${APPS}/r4st/bin'
alias rrr='cd ${APPS}/r4st/bin;./r.sh '
alias RSC='cd ${APPS}/RScripts/'
alias ins='cd ${APPS}/install2Osgeo/bin'
alias base='cd ${BASE}'
alias apps='cd ${APPS}'
alias bac='cd ${BASE}/backup'
alias bak='cd ${BASE}/backup'

#Vi settings: command line is vi style,
set -o vi
set -o ignoreeof
export EDITOR=vi

export PS1='\u> `pwd` \n> '
EOF

echo "Now sourcing the updated .bashrc file..."
.  ~/.bashrc
chkerr "$?" "1" "The updated .bashrc file has an error."

echo "Enable vi syntax colors via the ~/.vimrc file ..."
cat << EOF > ~/.vimrc
syntax on
colorscheme pablo
EOF

ls -ltr  ~/.vimrc
chkerr "$?" "1" "The vimrc update process failed."
echo
##########   End Profile Updates ############

echo "The .bashrc and .vimrc profiles were updated..." 
echo

echo "Install the dbkiss database viewer application..."
sudo cp -rf ${APPS}/r4st/files/r4stdb /var/www/html
sudo chmod 777 /var/www/html/r4stdb/dbkiss_sql
ls -ltr /var/www/html/r4stdb|grep '^drwxrwxrwx'
chkerr "$?" "1" "The dbkiss file copy and/or chmod process failed" 
echo

echo "Test primary r4st database processes..."
echo "Run the r4st prgram to load the r4st r4p database..."
ls -ltr ${APPS}/r4st/bin/r.sh
cd ${APPS}/r4st/bin
./r.sh >/dev/null 2>&1

chkdberr=$(egrep -i 'error|fatal|hint' ${APPS}/r4st/bin/r.log ) 
if [[ -n $chkdberr ]]; then
   echo "FAILURE: Database load Errors found in ${APPS}/r4st/bin/r.log" 
   echo "Fix the errors and re-run this process. Exiting now..."
   exit 1
fi

echo
grep DONE  ${APPS}/r4st/bin/r.log 
chkerr "$?" "1" "The r4st database process and log file did not complete"  
echo "You can view the r4st PRD datbase at: http://localhost/r4stdb/dbkiss.php" 


echo
echo "Create a backup tar file, stored under ${BASE}/backup..."
datestamp=$(date +%Y%m%d_%H%M)
tar -cpf ${BASE}/backup/${MYDEV_NAME}.${datestamp}.tar -C ~/Desktop ${MYDEV_NAME} 
chkerr "$?" "1" "The backup tar file process failed..."

echo
echo "Success! Your $MYDEV_NAME system has been installed."
echo
