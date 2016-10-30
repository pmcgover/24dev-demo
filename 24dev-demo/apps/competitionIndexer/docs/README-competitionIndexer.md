# competitionIndexer Documentation 
* Usage: competitionIndexerCLI.sh -f ../input/<inputFileName.csv>
* Example: ./competitionIndexerCLI.sh -f ../input/u07m-6yrStacks-Input.csv 

## General Program Details 
* The Competition Indexer is a program to compare and analyze each plantation tree to its neighboring tree: 
* The tree of interest is called the subject tree or: sub or s 
* The neighbor trees are called competitors or: c
* Referencing the competitors relative from the subject is via 8 diirectional positions or: N NE E SE S SW W NW 
* The input data file contains 4 columns, ID, Row, Col, DBH, Name.  
* Formula Document: http://treesearch.fs.fed.us/pubs/7354

## Program Requirements 
* FYI - To initially setup the databases, you must first run the [r4st Plant Database process]($APPS/r4st/bin/r4st-wrapper.sh).
* Postgresql database
* Bash shell 
* The program requires a comma separated input file (CSV)
* Input.csv file fields: id,setid,long_ft,short_ft,row,col,block,dbh,year,site,name,optCol1,optCol2,...] 
* The first input CSV fields must include:  id,setid,long_ft,short_ft,row,col,block,dbh,year,site,name 
* ... You can add other optional columns that will be installed as text fields 
* The ID field should have integers and be in ascending order.
* The name field should  list the clone/family name. 
* The input CSV file should not have any blank spaces.
