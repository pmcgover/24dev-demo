#!/bin/bash
# File: install.sh 
# A wrapper script to install the install2Osgeo.sh process.

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
else 
   echo "Failure: The profile is not readable or could not be found: ${BASE}/.24dev.profile"
   exit 1   
fi
echo 

echo "Run the install2Osgeo.sh and tee output to the install2Osgeo.log file..."
if [[ -r ./apps/install2Osgeo/bin/install2Osgeo.sh ]]; then
  echo "Instaling the OSGeo Addon..."
  ./apps/install2Osgeo/bin/install2Osgeo.sh|tee ./apps/install2Osgeo/logs/install2Osgeo.log
else
  echo "FAILURE: The ./apps/install2Osgeo/bin/install2Osgeo.sh file was not readable or available..."
fi  

