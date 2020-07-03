# r4st Tree Database Documentation
The r4st database application provides an online prototype of the [Open4st project](https://sites.google.com/site/open4st/) clones, families and related experimental data. It uses the open source Postgresql database and the online DBKiss database application to access the database tables and views. It is designed to be used as a central repository by importing data via csv files, creating SQL queries for specific reports and views for "big picture" cumulative annual summaries that can be exported back to csv files for R Programming and further analysis.

The DBKiss application provides manual or SQL query tools at the table and view level for reporting.  It contains an SQL editor that allows custom SQL queries for more in-depth custom reports and save previous queries for later retrieval.    

## Usage
* Review and install 24dev-demo to an OSGeo-Live system via: https://github.com/pmcgover/24dev-demo.
* The install process will install, test, log and verify all applications with Pass or Fail output.
* Opening a terminal shell and runing the alias command "rrr", will re-load the r4st database objects via the r4st-wrapper.sh program
* You can browse the local r4st database tables and views at: http://localhost/r4stdb/r4p.php
* For more details about this process and the online version see: [Using the r4st database](https://sites.google.com/site/open4st/faq/what-is-the-open4st-database) 
