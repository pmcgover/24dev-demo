# regressionTester Documentation 
* An automated regression testing process that loads a list of tests then runs and verifies their output. 
* Usage: Execute $APPS/regressionTester/bin/regressionTester.sh
* All applications are expected to have a bin, docs, logs, output and output/goodtests directories. 
* Configure your input regression test entries in the file: $APPS/regressionTester/input/inputRegressionTests.csv.
* The "testApp" column contains the exact name of the test app as listed under: $APPS/*.
* The "testName" column contains the input filename (which may have variable data) or script name. 
* The "command" column contains the full command with any necessary options.
* The "outputFileName" must be the same as the application output AND output/goodtests filename (for cksum comparison). 
* If you encounter regression test issues, first check the [regression log file]($APPS/regressionTester/logs/regressionTests.log).

## Screenshot Verification Process 
You can optionally include a verification screenshot with these steps: 
* Run your 24dev regression tests.
* Login to your 24dev github account, navigate to your latest tags/releases. 
* Click on your upper right profile tab that shows you are signed in.
* Open a terminal window and enter the verification commands listed on the [Project-Summary.md page](../../../../Project-Summary.md).
* Position the terminal and browser windows then execute the "screengrab" command.
* Save the image as "screen.png" into the [backup directory](24dev-demo/backup).
* Run the [install.sh](24dev-demo/install.sh) command, which will post your screenshot to the Project-Summary.md page. 
