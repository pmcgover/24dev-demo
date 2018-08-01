# 24dev-demo Software Digital Portfolio
An unofficial OSGeo addon to demonstrate and showcase your Software Portfolio via github.com.

This software is intended to provide users with an smart way to develop, test drive and
share applications alongside the Linux [OSGeo Live](https://live.osgeo.org/en/index.html) 
project and the open source community. Developers, students and prospective employers will 
benefit by viewing the code and project summary on github and verify the user's applications 
on OSGeo.  The "24dev" name is a play on words for: "Two For DEVelopment", via the Open Source 
Community and the Open Source developer. 

## 24dev High Level Use Cases
The 24dev process involves 3 [Use Case Actors](https://en.wikipedia.org/wiki/Actor_(UML)): student, teacher and 
employer. The list below describes how the 24dev system should interact with these users:

* As a student, I would like to learn marketable [CS](https://en.wikipedia.org/wiki/Computer_science) or [IT](https://en.wikipedia.org/wiki/Information_technology) skills which can be accessed online by teachers and potential employers.
* As a teacher, I would like my students to learn marketable [CS](https://en.wikipedia.org/wiki/Computer_science) or [IT](https://en.wikipedia.org/wiki/Information_technology) skills and showcase them on github.
* As an employer, I would like to hire [CS](https://en.wikipedia.org/wiki/Computer_science) or [IT](https://en.wikipedia.org/wiki/Information_technology) employees with an impressive online portfolio where I can view code, documentation and test drive applications.

## 24Dev Features
* Users can install 24dev applications to a live OSGeo DVD, flash drive or virtual machine by 
running one administrative installation script.
* Users can re-run the install script to update profiles, and accept different 24dev-* programs.  
The install script also creates a backup and purges application log files. 
* Users can test their programs with the [regressionTester](24dev-demo/apps/regressionTester) application 
and have statistics and Pass/Fail results published to the: [Project-Sumary.md](Project-Summary.md).
* Scripts can display applicable license and README.md files.
* All user applications are expected to have a bin, docs, logs, output and output/goodtests folders/files.
* Users can optionally include a verification screenshot of their 24dev program and github account. 
* Users are encouraged to create their own customized releases via github renamed as: 24dev-[myForkName]. 

## Installing 24dev-demo to an OSGeo Live DVD system
* Download the latest version of the [24dev-demo release](https://github.com/pmcgover/24dev-demo/releases) 
tar file and install on a USB flash drive.
* Boot your computer with the [OSGeo Live DVD](https://live.osgeo.org/en/download.html). 
* Copy the tar file to the OSGeo Desktop.
* Right click on the tar file and select "Extact Here".
* Navigate into the extracted folder, open a terminal window there and run the following commands:
```
   chmod -R 755 *; cd 24dev-demo; ./install.sh
```
* The above command sets up the environment and runs the installation script. 
* This 24dev program is documented online at: https://github.com/pmcgover/24dev-demo  

## Using 24dev-demo on OSGeo
* Install the 24dev application on OSGeo, open a new terminal window and type "alias" to 
view the custom 24dev-demo commands.
* Enter the "apps" alias and browse through the available applications. 
* Note that each application has a similar folder structure for programs (bin), input/ouput files, logs, docs, etc. 
* First run the [regresson test process](24dev-demo/apps/regressionTester/bin/regressionTester.sh) to verify programs and initiate the database.  
    * If you encounter regression test issues, check the [regression log file](24dev-demo/apps/regressionTester/logs/regressionTests.log)
    * View the summary regression test results via the [Project-Sumary.md](Project-Summary.md). 
* Navigate to the desired apps **doc** folder and view the related docs/README-\<appName\>.md file. View and update your .md files with the "retext" program.
* Navigate to the desired apps **bin** folder and execute the program per the documentation. 
* View .csv files with the csvtool application via the alias "mycsv <fileName.csv\> |view -"

## Create your own 24dev Software Digital Portfolio 
* Learn about git and github: [Github Help](https://help.github.com) 
* Open a free github account: [Github Account Signup](https://help.github.com/articles/signing-up-for-a-new-github-account)
* Fork the [24dev-demo repository](https://github.com/pmcgover/24dev-demo) then clone to your computer: [Fork A Repo](https://help.github.com/articles/fork-a-repo)
* Rename the new repo as needed (e.g.  *mv 24dev-demo 24dev-\<yourUserName\>* )
* Update your new 24dev instance with your applications, custom settings, documentation and license. 
* If using the MIT license, append your copyright details below existing copyright entries. See example below:
```
   Original work Copyright (c) 2015 Patrick Noel McGovern
   Modified <appName>, Added <appName> Copyright 2016 Mary Carol Doe
```
* Install, run and test your applications on a live OSGeo DVD, flash drive or virtual machine. 
* Run the install script to clean up the 24dev file system.  Perhaps retain the last [backup tar file](24dev-demo/backup).  
* Optionally include a verification screenshot of your 24dev program and github account. See [README-install2Osgeo.md](24dev-demo/apps/install2Osgeo/docs/README-install2Osgeo.md) 
* Copy/push your changes to your local github repository or see: [Working with remote git repositories](https://git-scm.com/book/en/v2/Git-Basics-Working-with-Remotes) 
* Below are commands to commit your changes:
    * Navigate to your local git working directory.
    * Add your new changes: *git add -A*
    * Commit your changes:  git commit -m 'Updated the ABC application'
    * Push your changes to the remote repository: *git push origin*
    * Create tags and releases to mark important change sets and push them to github: *git tag v.N.N.N*; git push --tags origin  
* Rinse and Repeat: Navigate to your github remote repository, download the most recent tagged release and deploy/test on OSGeo. 
* Update your resume with a link to your github 24dev repository. 

