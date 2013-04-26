Forest City Military Community Energy Audit
===========================================

Daniel Zhang (張道博), Software Developer

## Overview

This software provides automated data operations for a collection of
energy monitoring devices installed at the [Forest City Military
Community](http://www.forestcity.net) in Hawaii.

Using this software will require appropriate modification based on
your system configuration. It is licensed under a BSD license
contained in the repository.

### Features 

* Open-source (BSD license) code in Perl 5.x.
* Downloads eGauge data using the [eGauge web API](http://www.egauge.net/docs/egauge-xml-api.pdf). 
* Data is then parsed and uploaded to a data store (PostgreSQL 9.1).

The software is designed for automatic operation through a cron job.

## Configuration

Configuration is provided by a text file. An example is listed here.

    fc_dbname = "DBNAME"
    data_dir = "/usr/local/egauge-automatic-data-services/egauge-data-download"
    insert_table = "energy_autoload_new"
    loaded_data_dir = "/usr/local/egauge-automatic-data-services/data-that-has-been-loaded"
    invalid_data_dir = "/usr/local/egauge-automatic-data-services/invalid-data"
    db_pass = "${PASSWORD}"
    db_user = "${USERNAME}"
    db_host = "${IP.ADDRESS.OR.HOSTNAME}"
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

## License

Copyright (c) 2013, University of Hawaii Smart Energy Project  
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

* Neither the name of the University of Hawaii at Manoa nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
