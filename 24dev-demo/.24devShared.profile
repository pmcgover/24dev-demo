#!/bin/bash
#File: .24devShared.profile - Loads shared script processes.  

echo "Display profile Global variables:"
echo "BASE=$BASE"
echo "APPS=$APPS"
echo "MYDEV_NAME_PATH=$MYDEV_NAME_PATH"
echo "MYDEV_NAME=$MYDEV_NAME"
echo
echo "Display the associated License file header:"
head -4 ${MYDEV_NAME_PATH}/LICENSE
echo
echo "Display the associated README.md file header:"
head -3 ${MYDEV_NAME_PATH}/README.md
echo
echo

