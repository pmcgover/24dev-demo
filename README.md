# 24dev-demo Digital Portfolio
An unofficial OSGeo addon to demonstrate software and showcase your Digital Portfolio 
via github.com.

This software is intended to provide users with an easy way to develop, test drive and
share applications alongside OSGeo and the open source community. Developers, students
and prospective employers should benefit by viewing the code on github and running the 
applications on OSGeo.  The "24dev" name is a play on words for: "Two For DEVelopment",
via the Open Source Community (OSC) and you, the Open Source Developer (OSD). 

## 24Dev Features
* Users can install 24dev applications to a live OSGeo DVD or flash drive by running one script.
* Users can re-run the install script to update profiles and accept different 24dev-* programs.  
* The install script creates a backup tar file and tests for command success.
* OSD user scripts can display applicable license and README.md files.
* OSD users are encouraged to fork new releases via github renamed as: 24dev-[myForkName]. 

## Installing 24dev-demo to an OSGeo Live DVD system
* Download the latest version of the 24dev-demo tar file and install on a USB flash drive.
* Boot your computer with the OSGeo Live DVD.
* Copy the tar file to the OSGeo Desktop.
* Right click on the tar file and select "Extact Here".
* Navigate to the extracted folder, open a terminal window and run the following commands:
*  chmod -R 755 *; ./24dev-demo/apps/install2Osgeo/bin/install2Osgeo.sh 
* The above command will create databases, install and test the required programs.
* The program documentation is located online at:  https://github.com/pmcgover/24dev-demo  

## Using 24dev-demo on OSGeo
* Install the 24dev application on OSGeo, open a new terminal window and type "alias" to 
  view the custom 24dev-demo commands.
* Type "apps" to navigate to the available applications. 
* Note that each application has a similar folder structure for binary programs (bin), 
  input/ouput files, logs, docs, etc. 
* Navigate to the desired apps **doc** folder and view the related docs/README-<appName>.md file. 
* Navigate to the desired apps **bin** folder and execute the program per the documentation. 

## Creating your own 24dev version
* Learn about git and github: [Github Help](https://help.github.com) 
* Open a free github account: [Github Account Signup](https://help.github.com/articles/signing-up-for-a-new-github-account)
* Clone the 24dev-demo repo to yours: *git clone --bare git@github.com:pmcgover/24dev-demo.git*
* Rename the repo as needed: *mv 24dev-demo 24dev-<yourRepo>*  
* Add your new changes: *git add -A*
* Commit your changes: git commit -m 'Add working directory'
* Push your changes to the remote repository: *git push origin*
* Update your 24dev instance with your own applications and custome settings. 
* Create tags to mark important change sets and push them : *git tag v.N.N.N*; git push --tags origin  
* Navigate to your github remote repository, download the most recent tagged release and deploy/test on OSGeo. 

