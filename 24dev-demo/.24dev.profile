#!/bin/bash
# All scripts should first call this profile

# Only Set Global variables here:  
export BASE=/home/user/Desktop/24dev-demo/24dev-demo
export APPS=${BASE}/apps
# MYDEV_NAME is most likely the source github repo name: 
export MYDEV_NAME=$(pwd|cut -d"/" -f5)

echo  "Source the 24devShared.profile for shared script processes..." 
. .24devShared.profile
