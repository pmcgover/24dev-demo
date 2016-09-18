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

# Check error  function to validate or fail after command completion:
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

