#!/bin/bash
#
# @author Daniel Zhang (張道博)

export PERL5LIB=/usr/local/lib/perl5
/usr/local/egauge-automatic-data-services/bin/getEgaugeData.pl
/usr/local/egauge-automatic-data-services/bin/insertEgaugeData.pl
