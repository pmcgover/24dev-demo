#!/bin/bash
# File: regressionTester.sh 

echo "Starting script on:" $(date)
echo BASE=$(pwd|cut -d"/" -f-6)
echo

echo "Source the 24dev profile to set variables and display license/program details..."
if [[  -r ${BASE}/.24dev.profile ]]; then
   . ${BASE}/.24dev.profile
else 
   echo "Failure: The profile is not readable or could not be found: ${BASE}/.24dev.profile"
   exit 1   
fi

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

sed '1d' ${APPS}/regressionTester/input/inputRegressionTests.csv > ${APPS}/regressionTester/input/inputRegressionTests.csv.noHeader
inputRegTests=${APPS}/regressionTester/input/inputRegressionTests.csv.noHeader
outputRegTests=${APPS}/regressionTester/output/outputRegressionTests.csv
logsRegTests=${APPS}/regressionTester/logs/outputRegressionTests.csv
RegTesterDir=${APPS}/regressionTester/bin
cd $RegTesterDir

cnt=1
echo "Load input regression tests for each application..."
# for testrun in $(cat "${inputRegTests}"); do 
while IFS='' read -r testrun || [[ -n "$testrun" ]]; do
  testApp=$(echo  "$testrun"|cut -d"|" -f1)    #Application Name:  eg.  RScripts 
  testName=$(echo "$testrun"|cut -d"|" -f2)    #Input filename or script name:  eg. basicGraph, u07m-6yrStacks-Input
  getCommand=$(echo  "$testrun"|cut -d"|" -f3) #Command: egs. ./r4st-wrapper.sh, ./basicGraph.r ./competitionIndexerCLI.sh -f ../../u07m-1yrDataSet-Input.csv
  outputFileName=$(echo "$testrun"|cut -d"|" -f4) #Output filename.  Also needs to be same as the Good output filename. 
  echo
  echo "#################################################" 
  echo "Processing the application, $testApp regression Test $cnt with input details below:"
  echo "${testrun}"
  echo "#################################################" 
  echo
  echo "Application Name= $testApp"
  echo "Test Name= $testName"
  echo "Command= $getCommand"
  echo "Output File Name= $outputFileName"
  echo

  appPath=${APPS}/${testApp}  
  appLogs=${APPS}/${testApp}/logs  
  appGoodTest=${APPS}/${testApp}/output/goodtests
  appOutput=${APPS}/${testApp}/output
  appInput=${APPS}/${testApp}/input 
  datestamp=$(date +%Y%m%d_%H%M)
  logFile="${appLogs}/${testName}.TestID-${cnt}.${datestamp},log"  
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
  commandStatus=$(echo $?)
  echo "The post COMMAND exit status is: $commandStatus..."
  echo
  echo "Change back to the regressionTester working directory: $RegTesterDir..." 
  cd $RegTesterDir

  echo "Validate that the output files are availalble..." 
  echo
  if [[ -r ${appOutput}/${outputFileName} && -r ${appGoodTest}/${outputFileName} ]]; then
     echo "The Applicaiton output and good test files are available..."
     outputFileTest=0
  else
     echo "FAILURE: The Applicaiton output and good test files are NOT available..."   
     outputFileTest=1
     echo "The expected aplication and good file paths are listed below..." 
     ls -ltr ${appOutput}/${outputFileName}
     ls -ltr ${appGoodTest}/${outputFileName} 
  fi
 
  echo "Comparing this test run with previous good files..."  
  echo "Using cksum command to compare the output file to the known good test file..."
  appCksum=$(cksum ${appOutput}/${outputFileName})    
  goodCksum=$(cksum ${appGoodTest}/${outputFileName})    
  echo "Compare the Application and Good test cksum command details below (cksum, file size, output files:"
  echo "$appCksum" 
  echo "$goodCksum"
  echo
   
  appCksumValue=$(echo $appCksum|awk '{print $1}')  
  goodCksumValue=$(echo $goodCksum|awk '{print $1}')  
  if [[ $appCksumValue -eq $goodCksumValue ]]; then
     echo "The output chksum is the same as the good test file."
     cksumStatus=0
  else 
     echo "FAILURE: The output file is not the same as the good test file, using diff command to compare differences..."
     echo 
     cksumStatus=1
     echo 
     diff ${appOutput}/${outputFileName} ${appGoodTest}/${outputFileName}    
     getdiff=$(diff ${appOutput}/${outputFileName} ${appGoodTest}/${outputFileName})    
     diffStatus=$(echo $?)
     echo "FYI: The diff exit status was: $diffStatus" 
     echo "The diff command details are displayed below:"
     echo "$getdiff"
     echo
  fi   

  echo "The $testApp output log file is located at $logFile" 
  echo "Output log file ls details..."
  ls -ltr $logFile
  #cat $logFile
   
  echo
  echo "Grep the log file for ERROR or FATAL strings and warn if any found..."  
  getErrors=$(egrep -i '(error|fatal)' $logFile)  
  cntErrors=$(egrep -i '(error|fatal)' $logFile|wc -l)
  if [[ -n $getErrors ]]; then
     echo "WARNING! Found $cntErrors Error or Fatal stirngs in the log file!"
     echo "Investigate log file: $logFile"
     echo
     echo "Displaying the Error/Fatal strings below..."
     echo "$getErrors" 
 fi      

  echo "Create a summary report with: pass/fail, log location, elapsed time, output cksum, file size,..."
  if [[ $commandStatus -eq 0 && $cksumStatus -eq 0 && $cntErrors -eq 0 && $outputFileTest -eq 0 ]]; then
     echo
     echo "###### SUCESS!!! ############"
     echo "All regression tests passed for application $testApp, test number: $cnt" 
     echo "###### SUCESS!!! ############"
     echo
  else
     echo
     echo "###### WARNING - Will Robinson! #################################"
     echo "Not all regression tests passed for application $testApp, test number: $cnt"
     echo "###### WARNING - Will Robinson! ##################################"
  fi
  cnt=$((cnt+1))
done  <  "${inputRegTests}"
 

