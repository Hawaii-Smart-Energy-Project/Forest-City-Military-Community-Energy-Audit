Forest City Military Community Energy Audit
===========================================

Daniel Zhang, Software Developer

## Overview

This software provides automated data operations for a collection of
energy monitoring devices installed at the [Forest City Military
Community](www.forestcity.net) in Hawaii.

Using this software will require appropriate modification based on
your system configuration. It is licensed under a BSD license
contained in the repository.

### Features 

* Downloads eGauge data using the eGauge web API. 
* Data is then parsed and uploaded to a data store (PostgreSQL 9.1).

The software is written in Perl 5 and is designed for automatic operation
through a cron job.

## Configuration

Configuration is provided by a text file. An example is listed here.

    fc_dbname = "DBNAME"
    data_dir = "/usr/local/egauge-automatic-data-services/egauge-data-download"
    insert_table = "energy_autoload_new"
    loaded_data_dir = "/usr/local/egauge-automatic-data-services/data-that-has-been-loaded"
    invalid_data_dir = "/usr/local/egauge-automatic-data-services/invalid-data"
    db_pass = "PASSWORD"
    db_user = "USERNAME"
    db_host = "IP.ADDRESS.OR.HOSTNAME"
    db_port = "5432"
    egauge = "process-me1"
    egauge = "process-me2"
    egauge = "process-me3"
    egauge = "process-me..."

Data is downloaded to data_dir. It is inserted to insert_table and
archived in loaded_data_dir. If the data cannot be successfully
loaded, then the data is stored in invalid_data_dir.

## Cron Job

Here is an example crontab that handles running the entire process.

    MAILTO=USER@IP.ADDRESS.OR.HOSTNAME
    20 * * * * /usr/local/egauge-automatic-data-services/bin/runWithEnvGetEgaugeData.sh

## Database Schema

Table and view creation scripts are provided.

## Dependencies

The following Perl modules are used.

1. Getopt::Long
2. Config::General
3. DBI
4. DBD::Pg
