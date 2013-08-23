#!/usr/bin/perl -w

# Installation script for
# eGauge Automatic Data Services
#
# @author Daniel Zhang (張道博)
# @copyright Copyright (c) 2013, University of Hawaii Smart Energy Project
# @license https://raw.github.com/Hawaii-Smart-Energy-Project/Forest-City-Military-Community-Energy-Audit/master/BSD-LICENSE.txt
#
# Usage:
#
# sudo ./installEgaugeAutomaticDataServices.pl

use strict;

my $binDest = "/usr/local/egauge-automatic-data-services/bin";
my $libDest = "/usr/local/lib/perl5";
my $configDest = "/usr/local/egauge-automatic-data-services/config";

`cp getEgaugeData.pl $binDest`;
`cp insertEgaugeData.pl $binDest`;
`cp DZSEPLib.pm $libDest`;
#`cp ../config/egauge-automatic-data-services.config $configDest`;

