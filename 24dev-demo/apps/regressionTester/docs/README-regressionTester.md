# regressionTester Documentation 
* An automated regression testing process that loads a list of tests then runs and verifies their output. 
* Usage: Execute $APPS/regressionTester/bin/regressionTester.sh
* All applications are expected to have a bin, docs, logs, output and output/goodtests directories. 
* Configure your input regression test entries in the file: $APPS/regressionTester/input/inputRegressionTests.csv.
* The "testApp" column contains the exact name of the test app as listed under: $APPS/*.
* The "testName" column contains the input filename (which may have variable data) or script name. 
* The "command" column contains the full command with any necessary options.
* The "outputFileName" must be the same as the application output AND output/goodtests filename (for cksum comparison). 
