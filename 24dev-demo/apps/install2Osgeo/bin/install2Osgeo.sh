#!/bin/bash
# File: install2Osgeo.sh

echo "Starting script on:" $(date)
echo
echo "Update the 24dev profile with the base pathname, all scripts should source this profile..."
BASE=$(pwd|cut -d"/" -f-6)
echo BASE=$BASE
sed -i.bak "s%BASE=.*$%BASE=$BASE%" ${BASE}/.24dev.profile 

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

echo "Display the system platform details via the command: uname -a"
uname -a
echo
echo "Display the Linux distribution release details via the command: lsb_release -a" 
lsb_release -a
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
alias cdsql='cd ${APPS}/r4st/sql'
alias cdcsv='cd ${APPS}/r4st/csv'
alias cdrr='cd ${APPS}/r4st/bin'
alias runrr='cd ${APPS}/r4st/bin;./r4st-wrapper.sh '
alias cdrlog='cd ${APPS}/r4st/logs'
alias cdrs='cd ${APPS}/RScripts/'
alias cdinsbin='cd ${APPS}/install2Osgeo/bin'
alias runins='cd ${APPS}/install2Osgeo/bin;./install2Osgeo.sh'
alias cdrtbin='cd ${APPS}/regressionTester/bin'
alias cdrtlog='cd ${APPS}/regressionTester/logs'
alias runrt='cd ${APPS}/regressionTester/bin;./regressionTester.sh'
alias mdps='retext  ${MYDEV_NAME_PATH}/Project-Summary.md'
alias mdrme='retext ${MYDEV_NAME_PATH}/README.md'
alias cdbase='cd ${BASE}'
alias cdapps='cd ${APPS}'
alias cddev='cd ${MYDEV_NAME_PATH}' 
alias cdbac='cd ${BASE}/backup'
alias cdbak='cd ${BASE}/backup'
alias mycsv='csvtool readable '  #For view mode append with: view - 
alias mymd='retext '  #For editing markdown files 
alias mysg='screengrab '  #For capturing screenshots

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

echo "Remove all but the 3 most recent application log files..."
for dir in $(dirname $(find $APPS/*/logs)|grep logs|sort|uniq); do
  echo "Remove all but the most recent files under: $dir" 
  find $dir -type f -name "*log" -printf '%T@ %p\n'|sort -n|cut -d' ' -f2-|head -n -3|xargs rm -vf
done
echo


echo "List and Remove any previous screenshot files..."
ls -ltr ${BASE}/backup/24dev-screenshot*
rm -f ${BASE}/backup/24dev-screenshot* 

echo
echo "Rename the new screenshot screen.png file with hostid, datestamp and post to Project-Summary.md..."
datestamp=$(date +%Y%m%d-%H%M)
hostName=$(hostname)
fileName="24dev-screenshot_${hostName}_${datestamp}.png"
if [[ -r $BASE/backup/screen.png ]]; then
  echo "Renaming ${BASE}/backup/screen.png file to: $fileName"
  ls -ltr ${BASE}/backup
  mv ${BASE}/backup/screen.png  ${BASE}/backup/${fileName}
  if [[ -r ${MYDEV_NAME_PATH}/Project-Summary.md ]]; then
    echo "Posting the new screenshot file name to the Project-Summary.md..." 
    echo "24dev Verification screenshot|[$fileName](24dev-demo/backup/${fileName})" >> $MYDEV_NAME_PATH/Project-Summary.md
  else
    echo "Warning: The Project-Summary.md file is not available to post your screenshot"
  fi
fi

echo "Remove previous backup tar file..."
rm -f $BASE/backup/*.tar 
echo

echo "Create a backup tar file, stored under ${BASE}/backup..."
tar -cpf ${BASE}/backup/${MYDEV_NAME}.${datestamp}.tar -C ~/Desktop ${MYDEV_NAME} 
chkerr "$?" "1" "The backup tar file process failed..."

echo
echo "Check and install the screengrab program to take screenshots..." 
dpkg-query -l screengrab
checkStatus=$(echo $?)
if [[ $checkStatus -ne 0 ]]; then
  echo "The screengrab program is not installed, lets add it..."
  sudo apt-get install -y screengrab
  # Sleep for a bit to allow the above program to install.
  sleep 5
  dpkg-query -l screengrab || echo "WARNING - The screengrab app did not install"
fi
echo
echo "Check and install csvtool to take view CSV files..." 
dpkg-query -l csvtool 
checkStatus=$(echo $?)
if [[ $checkStatus -ne 0 ]]; then
  echo "The csvtool  program is not installed, lets add it..."
  sudo apt-get install -y csvtool 
  # Sleep for a bit to allow the above program to install.
  sleep 5
  dpkg-query -l csvtool || echo "WARNING - The csvtool app did not install"
fi
echo
echo "Check and install the retext program to edit and view Markdown (.md) files..." 
dpkg-query -l retext 
checkStatus=$(echo $?)
if [[ $checkStatus -ne 0 ]]; then
  echo "The retext  program is not installed, lets add it..."
  sudo apt-get install -y retext
  sudo apt-get install -y python3-docutils python3-markdown
  # Sleep for a bit to allow the above program to install.
  sleep 5
  dpkg-query -l retext || echo "WARNING - The retext app did not install"
fi

echo
echo "Success! Your $MYDEV_NAME system has been installed."
echo "Consider testing your programs with the regressionTester application"
echo
echo "The installation log files are located at: $APPS/install2Osgeo/logs/install2Osgeo.log "
echo
