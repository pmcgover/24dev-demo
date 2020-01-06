# IPC Tree Database Documentation
The IPC database application provides online access to the project clones, families and related experimental data. It uses the open source Postgresql database and the online DBKiss database application to access the database tables and views. It is designed to be used as a central repository by importing data via csv files, creating SQL queries for specific reports and views for "big picture" cumulative annual summaries that can be exported back to csv files for R Programming and further analysis.  The DBKiss application provides manual or SQL query tools at the table and view level for reporting.  It contains an SQL editor that allows custom SQL queries for more in-depth custom reports and save previous queries for later retrieval.

## Usage
* Review and install 24dev-demo to an OSGeo-Live system via: https://github.com/pmcgover/24dev-demo.
* Open a terminal shell and run the alias command "ipc", which will load the ipc database objects and the dbkiss database tool.
* You can browse and update the local ipct database at: http://localhost/ipc/ipct.php
* You can browse (in read only mode) the local ipcr database at: http://localhost/ipc/ipcr.php
* The similar, "r4st" application is also installed.  For more details see: [Using the r4st database](https://sites.google.com/site/open4st/faq/what-is-the-open4st-database).

## Create new ipct database records
* TBD