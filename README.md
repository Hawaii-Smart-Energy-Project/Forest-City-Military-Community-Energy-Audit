Forest City Military Community Energy Audit
===========================================

The software downloads eGauge data using the eGauge web API.

The data is then parsed and uploaded to a data store (PostgreSQL 9.1).

The software is written in Perl 5 and designed for automatic operation through a cron job.

## Example Usage

A cron job is set up using `crontab -e`.

    MAILTO=user@server.com
    20 * * * * /usr/local/egauge-automatic-data-services/bin/runWithEnvGetEgaugeData.sh
  
This runs the retrieval and insertion scripts in a predefined environment setup for Perl.
