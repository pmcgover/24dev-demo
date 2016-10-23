#!/bin/bash
# All scripts should first call this profile

# Only Set Global variables here:  
export BASE=/home/user/Desktop/24dev-demo-0.9.5.6/24dev-demo
export APPS=${BASE}/apps
# MYDEV_NAME is most likely the source github repo name: 
export MYDEV_NAME_PATH=$(dirname $(echo ${BASE}))
export MYDEV_NAME=$(basename ${MYDEV_NAME_PATH})

# Source the 24devShared.profile for shared script processes:
. ${BASE}/.24devShared.profile
