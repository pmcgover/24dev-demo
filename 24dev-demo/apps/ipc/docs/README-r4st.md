# r4st Plant Database Documentation
The r4st database application provides online access to the project clones, families and related experimental data. It uses the open source Postgresql database and the online DBKiss database application to access the database tables and views. It is designed to be used as a central repository by importing data via csv files, creating SQL queries for specific reports and views for "big picture" cumulative annual summaries that can be exported back to csv files for R Programming and further analysis.

The DBKiss application provides manual or SQL query tools at the table and view level for reporting.  It contains an SQL editor that allows custom SQL queries for more in-depth custom reports and save previous queries for later retrieval.    

Usage:
* The r4st-wrapper.sh program performs system setup (creates databases) and runs/verifies the r4st-loader.sh process.
* It is recommended to first run the regression test process to initialize and verify the database. 
* To execute and re-load the database, execute the command: $APPS/r4st/bin/r4st-wrapper.sh
* You can browse the local r4st database tables and views at: http://localhost/r4stdb/dbkiss.php
* For more details about this process and the online version see: [Using the r4st database](https://sites.google.com/site/open4st/faq/what-is-the-open4st-database) 
