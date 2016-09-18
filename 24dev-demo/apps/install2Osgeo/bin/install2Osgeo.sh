#!/bin/bash
# File: install2Osgeo.sh

echo "Starting script on:" $(date)
echo
echo "This program is copyrighted under the MIT license.  See: https://github.com/pmcgover/24dev-demo/blob/master/LICENSE"
echo
echo "Update the 24dev profile with the base pathname, all scripts should source this profile..."
BASE=$(pwd|cut -d"/" -f-6)
echo BASE=$BASE
sed -i.bak "s%BASE=.*$%BASE=$BASE%" ${BASE}/.24dev.profile 

echo
echo "Source the 24dev profile to set variables and display license/program details..."
if [[  -r ${BASE}/.24dev.profile ]]; then
   . ${BASE}/.24dev.profile
else 
   echo "Failure: The profile is not readable or could not be found: ${BASE}/.24dev.profile"
   exit 1   
fi
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
alias rrr='cd ${APPS}/r4st/bin;./r4st-wraper.sh '
alias rlog='cd ${APPS}/r4st/logs'
alias RSC='cd ${APPS}/RScripts/'
alias ins='cd ${APPS}/install2Osgeo/bin'
alias reg='cd ${APPS}/regressionTester/bin'
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

echo "Create a backup tar file, stored under ${BASE}/backup..."
datestamp=$(date +%Y%m%d_%H%M)
tar -cpf ${BASE}/backup/${MYDEV_NAME}.${datestamp}.tar -C ~/Desktop ${MYDEV_NAME} 
chkerr "$?" "1" "The backup tar file process failed..."

echo
echo "Success! Your $MYDEV_NAME system has been installed."
echo

