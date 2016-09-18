# 24dev-demo Digital Portfolio
An unofficial OSGeo addon to demonstrate software and showcase your Digital Portfolio 
via github.com.

This software is intended to provide users with an easy way to develop, test drive and
share applications alongside OSGeo and the open source community. Developers, students
and prospective employers should benefit by viewing the code on github and running the 
applications on OSGeo.  The "24dev" name is a play on words for: "Two For DEVelopment",
via the Open Source Community (OSC) and you, the Open Source Developer (OSD). 

## 24Dev Features
* Users can install 24dev applications to a live OSGeo DVD, flash drive  or VM by running one script.
* Users can re-run the install script to update profiles and accept different 24dev-* programs.  
* Users can test programs with the **regressionTester** application with results published to the: 
  [Project-Sumary.md](Project-Summary.md)
* The install script creates a backup tar file and tests for command success.
* OSD user scripts can display applicable license and README.md files.
* OSD users are encouraged to fork customized releases via github renamed as: 24dev-[myForkName]. 

## Installing 24dev-demo to an OSGeo Live DVD system
* Download the latest version of the 24dev-demo tar file and install on a USB flash drive.
* Boot your computer with the OSGeo Live DVD. 
* Copy the tar file to the OSGeo Desktop.
* Right click on the tar file and select "Extact Here".
* Navigate to the extracted folder, open a terminal window there and run the following commands:
Quote  **chmod -R 755 *; cd 24dev-demo; ./apps/install2Osgeo/bin/install2Osgeo.sh** 
* The above command will create databases, install and test the required programs.
* The program is documented and located at:  https://github.com/pmcgover/24dev-demo  

## Using 24dev-demo on OSGeo
* Install the 24dev application on OSGeo, open a new terminal window and type "alias" to 
  view the custom 24dev-demo commands.
* Type "apps" to navigate to the available applications. 
* Note that each application has a similar folder structure for binary programs (bin), 
  input/ouput files, logs, docs, etc. 
* Navigate to the desired apps **doc** folder and view the related docs/README-\<appName\>.md file. 
* Navigate to the desired apps **bin** folder and execute the program per the documentation. 

## Create your own 24dev Digital Portfolio 
* Learn about git and github: [Github Help](https://help.github.com) 
* Open a free github account: [Github Account Signup](https://help.github.com/articles/signing-up-for-a-new-github-account)
* Fork the [24dev-demo repository](https://github.com/pmcgover/24dev-demo)
* Clone the fork: [Fork A Repo](https://help.github.com/articles/fork-a-repo)
* Rename the new repo as needed: e.g.  *mv 24dev-demo 24dev-\<yourUserName\>*  
* Add your new changes: *git add -A*
* Commit your changes: git commit -m 'Initial 24dev addition'
* Push your changes to the remote repository: *git push origin*
* Update your 24dev instance with your own applications, custom settings and license. 
* If using the MIT license, append your copyright details below existing copyright entries. See example below:
Quote   **Original work Copyright (c) 2015 Patrick Noel McGovern** 
Quote   **Modified work Copyright 2016 John David Doe**  
* Create tags to mark important change sets and push them : *git tag v.N.N.N*; git push --tags origin  
* Navigate to your github remote repository, download the most recent tagged release and deploy/test on OSGeo. 

