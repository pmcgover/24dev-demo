# IPC Tree Database Documentation
The IPC database application provides online access to the IPC Salix project clones, families and related experimental data. It uses the open source Postgresql database and the online DBKiss database application to access the database tables and views. It is designed to be used as a central repository by importing data via csv files, creating SQL queries for specific reports and views for "big picture" cumulative annual summaries that can be exported back to csv files for R Programming and further analysis.  The DBKiss application provides manual or SQL query tools at the table and view level for reporting.  It contains an SQL editor that allows custom SQL queries for more in-depth custom reports and save previous queries for later retrieval.

## Usage
* Review and install 24dev-demo to an OSGeo-Live system via: https://github.com/pmcgover/24dev-demo.
* The install process will install, test, log and verify all applications with Pass or Fail output.
* Opening a terminal shell and running the alias command "ipc", will re-load the ipc database objects.
* You can browse and update the local ipct development database at: http://localhost/ipc/ipct.php
* You can browse the local ipcr "read only" database at: http://localhost/ipc/ipcr.php

## Additional Resources
* Screencast demonstrating the IPC Salix database process: [IPC Salix Database POC - Flash Drive Installation and Creating Checklists](https://youtu.be/9nTnQYbhxSA).

 