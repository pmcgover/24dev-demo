# competitionIndexer Documentation
 
## Abstract
Tree research field trials may involve complex interactions between clones, families and their environment which develop bias differences impacting statistical analysis.  The use of competition indices may offer a tool to help interpret treatment effects by understanding how each tree interacts with its surrounding trees and borders.  The Competition Indexer (CI) program was developed to automate the formulas used in the paper, [Evaluation of field performance of poplar clones using selected competition indices](http://www.treesearch.fs.fed.us/pubs/7354) [1].

## Introduction
The Competition Indexer (CI) program is an experimental program to compare and analyze each plantation tree to its neighboring tree.  It uses 5 competition indice formulas derived from Brodie's research that compared 8 competition indices [1].  It takes an input CSV file containing at least 11 default columns describing each tree in a field trial.  The CI program enters these values into a database, computes the DBH of the surrounding 8 competing trees and then computes the indices.  Each record of the output CSV file contains the original records along with the computed competition index values.  The input file can contain multiple trial data sites (aka "sets") with each having its unique "Set ID".

## Materials and Methods

### Program Usage Instructions:

The Competition Indexer program is available via the [24devdemo](https://github.com/pmcgover/24dev-demo) addon prototyping scripts for the [OSGeo Live DVD](https://live.osgeo.org/en/index.html).  This option allows the user to review, modify and execute the source code and optionally run custom indices.  The following outlines how to access and use this program:
* To initially setup the databases, you must first run the [r4st Plant Database process]($APPS/r4st/bin/r4st-wrapper.sh).
* Postgresql database
* Bash shell 
* The program requires a comma separated input file (CSV)
* The input CSV file should not have any blank spaces.
* Command Line Usage: competitionIndexerCLI.sh -f ../input/<inputFileName.csv>
    * Example: ./competitionIndexerCLI.sh -f ../input/az7m-6yrStacks-Input.csv 


### Program Input Requirements 
* Download and run the latest [24dev-demo release version](https://github.com/pmcgover/24dev-demo/releases).  
* Required Input CSV Fields: 
* Input.csv file fields: id,setid,long_ft,short_ft,row,col,block,dbh,year,site,name,optCol1,optCol2,...] 
* The first input CSV fields must include:  id,setid,long_ft,short_ft,row,col,block,dbh,year,site,name 
    * You can add other optional columns that will be installed as text fields 
* Required column descriptions below:
    * id (unique incremented row id) integers only
    * setid (set ID for the given data set)
    * long_ft (longest tree spacing in feet)
    * short_ft (shortest tree spacing in feet)
    * row (row number)
    * col (column number)
    * block (block number)
    * dbh (tree DBH)
    * year (4 digit year)
    * site (site name)
    * name (clone or variety name)
* View sample Input files: Sample input files and the logical file path are located under: [Competition Indexer input files](https://github.com/pmcgover/24dev-demo/tree/master/24dev-demo/apps/competitionIndexer/input).

### Optional Inputs
* Optional Fields:  Users can add other optional CSV input fields for informational purposes.
* Variable Space Distances:  Users can add square (eg. 9x9) or rectangle space (eg. 7x9) parameters for each set.
* Multiple Trial Sets: Users can add multiple trial data sets with each set having its unique Set ID.  For example, a user could input data with 10 different sites and each site having 4 years of trial data for a total of 40 trial sets.
* Regression Test Process:  The program uses a regression process that tests various Use Cases and is executed after program changes.
* Program Terms: 
    * The tree of interest is called the subject tree or: "sub" or "s".
    * The neighbor trees are called competitors or: "c".
    * Referencing the competitors relative from the subject is via 8 diirectional positions or: N NE E SE S SW W NW.

## Results

The CI program output results are generated after running the [competitionIndexerCLI.sh](https://github.com/pmcgover/24dev-demo/blob/master/24dev-demo/apps/competitionIndexer/bin/competitionIndexerCLI.sh) shell script.  Relevant output details are listed below: 
* Notable Output CSV file result fields:
    * line_index: The sum of competition tree line lengths.  Derived from Brodie's "Sum Line Length" indice.
    * area_index: The area of CI line endpoints.  Derived from Brodie's "Area" indice and was top rated.
    * dbh_count: Count of live competition trees (maximum 8, minimum 0).
    * Sum_DBH_Ratio1_sd: The sum of DBH ratio.  Derived from Brodie's "Sum DBH Ratio" indice.
    * BA_ratio: Basal Area ratio.  Derived from Brodie's "BA Ratio" indice.
    * Sum_BA_ratio: Basal Area ratio.  Derived from Brodie's "Sum BA Ratio" indice.
    * Other fields were developed by Bender and McGovern for descriptive and experimental purposes.
    * View sample Output files: Sample output files and the logical file path are located under: [Competition Indexer output files](https://github.com/pmcgover/24dev-demo/tree/master/24dev-demo/apps/competitionIndexer/output).

## Discussion

The Competition Indexer program was designed to execute a variety of competition indice scenarios.  Recommended program improvements include adding columns for mean square error (MSE), MSE % and coefficients of determination similar to Brodie's indice comparisons.  These additions would simplify optimal indice selection by sorting field trial set values on decreasing MSE values.

## References

1. Brodie, L.C. and D. S. DeBell (2004) Evaluation of Field Performance of Poplar Clones Using Selected Competition Indices. New Forests 27 (3), pp. 201-214.
