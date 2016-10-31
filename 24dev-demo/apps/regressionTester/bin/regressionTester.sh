#!/bin/bash
# File: regressionTester.sh 

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

cat <<-EOF 
Usage: regressionTester.sh 
This program will run the pre-loaded regression commands and test for successfull completion.
EOF
echo 

if [[ $#  -gt 1 ]] ; then
  echo "No arguments required for this program."
  echo
  exit 1
fi



echo "Load and display App Lines Of Code (LOC) stats..."
totalAppLOC=$( (find $APPS/*/bin -type f -print0|xargs -0 cat)|wc -l)
echo "totalAppLOC=$totalAppLOC"
echo
find $APPS/*/bin -type f| xargs wc -l  


totalStartTime=$(date +'%s')
sed '1d' ${APPS}/regressionTester/input/inputRegressionTests.csv > ${APPS}/regressionTester/input/inputRegressionTests.csv.noHeader
inputRegTests=${APPS}/regressionTester/input/inputRegressionTests.csv.noHeader
logsRegTests=${APPS}/regressionTester/logs/regressionTests.log
RegTesterDir=${APPS}/regressionTester/bin
outputRegTests=${APPS}/regressionTester/output/regressionTestSummary.csv
rm -f  $outputRegTests
cd $RegTesterDir


cnt=0
echo "Load input regression tests for each application..."
while IFS='' read -r testrun || [[ -n "$testrun" ]]; do
   # Declare an associative array to store/display regression test checkItems with their itemStatus exit number (0=Success)
   startTime=$(date +'%s')
   declare -A REGCHECK  

  testApp=$(echo  "$testrun"|cut -d"|" -f1)    #Application Name:  eg.  RScripts 
  testName=$(echo "$testrun"|cut -d"|" -f2)    #Input filename or script name:  eg. basicGraph, u07m-6yrStacks-Input
  getCommand=$(echo  "$testrun"|cut -d"|" -f3) #Command: egs. ./r4st-wrapper.sh, ./basicGraph.r ./competitionIndexerCLI.sh -f ../../u07m-1yrDataSet-Input.csv
  outputFileName=$(echo "$testrun"|cut -d"|" -f4) #Output filename.  Also needs to be same as the Good output filename. 
  echo
  echo 
  echo "#################################################" 
  echo "STARTING the application, $testApp regression Test $cnt with test input details below:"
  echo "${testrun}"
  echo "#################################################" 
  echo "Application Name= $testApp"
  echo "Test Name= $testName"
  echo "Command= $getCommand"
  echo "Output File Name= $outputFileName"
  echo
  echo "Display the system platform details via the command: uname -a"
       uname -a
  echo
  echo "Display the Linux distribution release details via the command: lsb_release -a" 
       lsb_release -a
  echo

  appPath=${APPS}/${testApp}  
  appLogs=${APPS}/${testApp}/logs  
  appGoodTest=${APPS}/${testApp}/output/goodtests
  appOutput=${APPS}/${testApp}/output
  appInput=${APPS}/${testApp}/input 
  datestamp=$(date +%Y%m%d_%H%M)
  logFile="${appLogs}/${testName}.TestID-${cnt}.${datestamp}.log"  
  echo "The logfile will be located at: ${appLogs}/${testName}.TestID-${cnt}.${datestamp},log"
  echo
  echo "Change to the sourced script directory: ${appPath}/bin..."
  cd ${appPath}/bin
  chkerr "$?" "1" "FAILURE: Regression test failed to cd to:  ${appPath}/bin" 
  echo "The current directory is:" $(pwd)
  echo
  exCommand=$(echo  "${appPath}/bin/${getCommand}")
  echo "The executed command will be: $exCommand" 

  echo "#######################" 
  echo "Running regression test: nbr: $cnt, TestApp=$testApp, TestName=$testName..."
  ${exCommand} > ${logFile}  2>&1
  # Load output results into the Array 
  status=$(echo $?)
  echo "The post COMMAND exit status is: $status"
  REGCHECK[commandExitStatus]=$status
  echo "Display the command array exit status ${REGCHECK[commandExitStatus]} "

  echo
  echo "Change back to the regressionTester working directory: $RegTesterDir..." 
  cd $RegTesterDir

  echo "Validate that the output files are availalble..." 
  echo
  if [[ -r ${appOutput}/${outputFileName} && -r ${appGoodTest}/${outputFileName} ]]; then
     echo "The Applicaiton output and good test files are available..."
     status=0
  else
     echo "FAILURE: The Applicaiton output and good test files are NOT available..."   
     status=1
     echo "The expected aplication and good file paths are listed below..." 
     ls -ltr ${appOutput}/${outputFileName}
     ls -ltr ${appGoodTest}/${outputFileName} 
  fi
  # Load output results into the Array 
  echo "The output file availability test exit value is: $status"
  REGCHECK[outputFileTest]=$status
  echo "Display the command array exit status ${REGCHECK[outputFileTest]} "

  echo "Comparing this test run with previous good files..."  
  echo "Using cksum command to compare the output file to the known good test file..."
  appCksum=$(cksum ${appOutput}/${outputFileName})    
  goodCksum=$(cksum ${appGoodTest}/${outputFileName})    
  echo "Compare the application and good test cksum command details below (cksum, file size, output files:"
   
  appCksumValue=$(echo $appCksum|awk '{print $1}')  
  goodCksumValue=$(echo $goodCksum|awk '{print $1}')  
  if [[ $appCksumValue -eq $goodCksumValue ]]; then
     echo "The output chksum is the same as the good test file."
     status=0
     echo "Display the application and good test file cksum file outputs below..."
     echo "$appCksum"
     echo "$goodCksum"
     echo
  else 
     echo "FAILURE: The output file is not the same as the good test file, using diff command to compare differences..."
     echo 
     status=1
     echo 
     diff ${appOutput}/${outputFileName} ${appGoodTest}/${outputFileName}    
     getdiff=$(diff ${appOutput}/${outputFileName} ${appGoodTest}/${outputFileName})    
     diffStatus=$(echo $?)
     echo "FYI: The diff exit status was: $diffStatus" 
     echo "The diff command details are displayed below:"
     echo "$getdiff"
     echo
  fi   
  # Load output results into the Array 
  echo "The output file cksumStatus test exit value is: $status"
  REGCHECK[cksumStatus]=$status
  echo "Display the command array exit status ${REGCHECK[cksumStatus]} "

  echo "The $testApp output log file is located at $logFile" 
  echo "Output log file ls details..."
  ls -ltr $logFile
  #cat $logFile
   
  echo
  echo "Grep the log file for ERROR or FATAL strings and warn if any found..."  
  getErrors=$(egrep -i '(error|fatal)' $logFile)  
  status=$(egrep -i '(error|fatal)' $logFile|wc -l)
  if [[ -n $getErrors ]]; then
     echo "WARNING! Found $cntErrors Error or Fatal stirngs in the log file!"
     echo "Investigate log file: $logFile"
     echo
     echo "Displaying the Error/Fatal strings below..."
     echo "$getErrors" 
  fi      
  # Load output results into the Array 
  echo "The output file cntErrors test exit value is: $status"
  REGCHECK[cntErrors]=$status
  echo "Display the command array exit status ${REGCHECK[cntErrors]} "
 
  echo
  echo "Verify that each application has a README-<appName>.md file..."  
    if [[ -s ${APPS}/${testApp}/docs/README-${testApp}.md ]]; then
       status=0
       echo "The $dir application has a README-<appName>.md file. File listing below:" 
       ls -ltr ${APPS}/${testApp}/docs/README-${testApp}.md
    else  
       echo "WARNING! The required README-<appName>.md file was not found in: ${APPS}/${testApp}/docs/README-${testApp}.md" 
       status=1
    fi  
  # Load output results into the Array 
  REGCHECK[hasDocs]=$status
  echo "Display the command array exit status ${REGCHECK[hasDocs]}"
  echo

  appLOC=$( (find $APPS/${testApp}/bin -type f -print0|xargs -0 cat)|wc -l)
  echo "Process, display and report the REGCHECK array values to validate all tests..." 
  endTime=$(date +'%s')
  runTime=$((endTime - startTime))
  sumExitValues=
  arrayLength=${#REGCHECK[@]}
  for key in "${!REGCHECK[@]}"
  do
    echo "REGCHECK KEY is: $key and its exit VALUE is ${REGCHECK[$key]}"
    # echo "Display all array keys: ${!REGCHECK[@]}"
    # echo "Display the sumExitValues=$sumExitValues"
    sumExitValues=$((sumExitValues + REGCHECK[$key]))
    if [[ $key -ne 0 ]]; then
      echo "WARNING: The Test Nbr $cnt regression test: $key failed with exit code: REGCHECK[$key]"   
      echo
    fi
  done 

  echo "Create a summary report with test run summary details..."
  if [[ $sumExitValues -eq 0 ]]; then
     echo
     echo "###### SUCESS!!! ############"
     echo "All regression tests PASSED for application $testApp, test number: $cnt" 
     echo "###### SUCESS!!! ############"
     echo
     echo "$cnt|$testApp|$testName|$runTime|$appLOC|Pass" >> $outputRegTests   
  else
     echo
     echo "###### Danger, Will Robinson! #################################"
     echo "There were $sumExitValues regression tests FAILURES for application $testApp, test number: $cnt"
     echo "###### WARNING ##################################################"
     echo 
     echo "$cnt|$testApp|$testName|$runTime|$appLOC|Fail" >> $outputRegTests   
  fi
  cnt=$((cnt+1))
  unset -v REGCHECK 
done  <  "${inputRegTests}" > ${logsRegTests} 2>&1 

if [[ $sumExitValues -eq 0 ]]; then
  testResults="Success! - All regression tests PASSED!"
  echo "$testResults"
else
  testResults="Sorry, there were $sumExitValues regression test failures, please try again..."
  echo "Sum of Exit values is: $sumExitValues"
  echo "$testResults"
fi
echo
 
echo "The 24dev regression test process has completed." 
echo "The Regression test logs are located at: ${logsRegTests}" 
echo "Regression summary .csv file at: "$outputRegTests"" 
echo "Project Summary file at: $ProjectSummaryFile"
echo "Checking log files for failed regression test runs..."
echo
grep 'There were 24dev regression tests FAILURES for application' "${logsRegTests}"
echo 
echo "Display 24dev regression summary .csv file below:" 
echo "Regression Test Nbr|Application Name|Test Name|Run Time Seconds|App Lines Of Code|Pass or Fail"
cat $outputRegTests

echo 
echo "Creating the 24dev Project-Summary.md file based on the above results..." 
ProjectSummaryFile=$MYDEV_NAME_PATH/Project-Summary.md
appCount=$(ls -ltr $APPS|grep -v 'total 0'|wc -l)
totalEndTime=$(date +'%s')
totalRunTime=$((totalEndTime - totalStartTime))
# datestamp=$(date +%m/%/d%/Y %H%M)
datestamp=$(date)

cat <<-EOF > $ProjectSummaryFile 
# $MYDEV_NAME Project Summary 
Welcome to Patrick McGovern's $MYDEV_NAME Software Digital Portfolio. Created on $datestamp with the following details:
* Total number of applications: $appCount
* Total regression test run time in seconds: $totalRunTime 
* Total regression test runs: $cnt  
* Number of regression test checks: $arrayLength
* Total Project Lines Of Code: $totalAppLOC
* $testResults

Regression Test Nbr|Application Name|Test Name|Run Time Seconds|App Lines Of Code|Pass or Fail
 --- | --- | --- | --- | --- | --- 
EOF

# Append the regression test output details to the Project-Summary.md file: 
cat $outputRegTests >>  $ProjectSummaryFile 

echo
echo "If you have failures - first check the Regression test logs at: ${logsRegTests}" 
echo
