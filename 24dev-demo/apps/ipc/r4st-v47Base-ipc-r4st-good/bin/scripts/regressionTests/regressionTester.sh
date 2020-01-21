#!/bin/bash
# File: regressionTester.sh 
<<COMMENT_OUT
Copyright (C) 2013 Patrick McGovern 
    This file is part of competitionIndexerCLI.sh
    competitionIndexerCLI.sh is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    competitionIndexerCLI.sh is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with competitionIndexerCLI.sh.  If not, see <http://www.gnu.org/licenses/>.
COMMENT_OUT

echo "Starting script on:" $(date)
echo
read -r -d '' usage <<-'EOF'
Usage: regressionTester.sh 
This program will run all available r4st regression tests for scripts under this directory.
EOF

if [[ $#  -gt 1 ]] ; then
  echo "No arguments required for this program."
  echo "$usage"
  echo
  exit 1
fi

echo "Load the current directory and paths for cron to work properly..."
regressionTester_sh=/home/dad/r4st/bin/scripts/regressionTests/regressionTester.sh
competitionIndexerCLI_sh=/home/dad/r4st/bin/scripts/competitionIndexer/competitionIndexerCLI.sh
cindexerRegTests=/home/dad/r4st/bin/scripts/regressionTests/inputFiles/cindexer

echo "Load the competitionIndexerCLI.sh script with regresion tests..."
for file in $(find $cindexerRegTests -name "*.csv")
do
  echo
  echo "#######################################" 
  echo "Processing file: $file"
  $competitionIndexerCLI_sh -f $file
  getStatus=$(echo $?)
  if [[ $getStatus -gt 0 ]]; then
      echo
      echo "FAILURE: Exit status is: $getStatus"
      echo "The Regression test failed on input file: $file" 
      exit 1
  fi 
done

 
