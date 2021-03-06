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
echo user | sudo -S chmod -R 755 ${BASE}
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
alias sql='cd ${APPS}/r4st/sql'
alias csv='cd ${APPS}/r4st/csv'
alias rr='cd ${APPS}/r4st/bin'
alias rrr='cd ${APPS}/r4st/bin;./r4st-wrapper.sh '
alias rlog='cd ${APPS}/r4st/logs'
alias RSC='cd ${APPS}/RScripts/'
alias ins='cd ${APPS}/install2Osgeo/bin'
alias igo='cd ${APPS}/install2Osgeo/bin;./install2Osgeo.sh'
alias reg='cd ${APPS}/regressionTester/bin'
alias regr='cd ${APPS}/regressionTester/bin;./regressionTester.sh'
alias runrt='cd ${APPS}/regressionTester/bin;./regressionTester.sh'
alias rtlog='cd ${APPS}/regressionTester/logs'
alias base='cd ${BASE}'
alias apps='cd ${APPS}'
alias bac='cd ${BASE}/backup'
alias bak='cd ${BASE}/backup'
alias docs='find ${APPS}/*/docs|grep README'
alias logs='find ${APPS}/*/logs'
alias ipc='cd ${APPS}/ipc/bin;./ipc-wrapper.sh '
alias ilog='cd ${APPS}/ipc/logs'

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

echo "Remove previous backup tar files..."
rm -f $BASE/backup/*.tar.gz 
rm -f /var/tmp/${MYDEV_NAME}*.tar.gz
echo

echo "Create a backup tar file, stored under ${BASE}/backup..."
#tar -cpf ${BASE}/backup/${MYDEV_NAME}.${datestamp}.tar -C ~/Desktop ${MYDEV_NAME} 
tar -czpf /var/tmp/${MYDEV_NAME}.${datestamp}.tar.gz -C ~/Desktop ${MYDEV_NAME} 
mv /var/tmp/${MYDEV_NAME}*.tar.gz  ${BASE}/backup/.
chkerr "$?" "1" "The backup tar file process failed..."

echo "Remove previous backup zip file..."
rm -f $BASE/backup/*.zip
echo

#echo "Create a backup zip file, stored under ${BASE}/backup..."
#zip -r /var/tmp/${MYDEV_NAME}.${datestamp}.zip  ${MYDEV_NAME_PATH} 
#chkerr "$?" "1" "The backup zip file process failed..."

echo 
echo "Run apt-get update before installing programs..."
sudo apt-get update
echo

echo
echo "Check and install the screengrab program to take screenshots..." 
dpkg-query -l screengrab
checkStatus=$(echo $?)
if [[ $checkStatus -ne 0 ]]; then
  echo "The screengrab program is not installed, lets add it..."
  echo user | sudo -S apt -y install screengrab
  # Sleep for a bit to allow the above program to install.
  sleep 5
fi

echo
echo "Check and install the retext program to edit markdown files..." 
dpkg-query -l retext 
checkStatus=$(echo $?)
if [[ $checkStatus -ne 0 ]]; then
  echo "The retext program is not installed, lets add it..."
  echo user | sudo -S apt -y install retext 
  # Sleep for a bit to allow the above program to install.
  sleep 5
fi

echo
echo "Check and install the Simple Screen Recorder program to record computer screen sessions..." 
dpkg-query -l simplescreenrecorder 
checkStatus=$(echo $?)
if [[ $checkStatus -ne 0 ]]; then
  echo "The simplescreenrecorder program is not installed, lets add it..."
  echo user | sudo -S apt -y install simplescreenrecorder 
  # Sleep for a bit to allow the above program to install.
  sleep 5
fi

echo 
echo "Run apt-get update after installing programs..."
sudo apt-get update
echo

#Reload the profile to reload the current shell: 
source ~/.profile

echo
echo "Run the regressionTester application that will load/install/test the apps..."
source ${APPS}/regressionTester/bin/regressionTester.sh


echo
echo "Success! Your $MYDEV_NAME system has been installed."
echo "Consider testing your programs with the regressionTester application"
echo
echo "Reload the profile with the command, "source ~/.profile" or open a new terminal." 
echo "The installation log files are located at: $APPS/install2Osgeo/logs/install2Osgeo.log "



