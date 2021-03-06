###
# DZ Smart Energy Project Library for Perl
# This module provides data processing functions for the
# Forest City Military Community Energy Audit project.
#
# @author Daniel Zhang (張道博)
# @copyright Copyright (c) 2013, University of Hawaii Smart Energy Project
# @license https://raw.github.com/Hawaii-Smart-Energy-Project/Forest-City-Military-Community-Energy-Audit/master/BSD-LICENSE.txt
##

package DZSEPLib;
use strict;
use warnings;

require Exporter;
our @ISA       = qw(Exporter);
our @EXPORT_OK = qw();

use DBI;

my $AUTOCOMMIT = 0;
my $RAISEERROR = 1;

# global vars
my $DBH;

###
# Constructor
#
# @return object reference
##
sub new {
    my $self = {};
    $self->{DBH} = undef;
    bless($self);
    return $self;
}

###
# Connect to the database.
#
# @param database name
# @param database host
# @param database port
# @param database user
# @param database password
##
sub connectDatabase {
    my ( $dbName, $dbHost, $dbPort, $dbUser, $dbPass ) = @_;
    if ( !$dbName ) { die "dbName $dbName is invalid!"; }

    $DBH = DBI->connect( "dbi:Pg:dbname=$dbName;host=$dbHost;port=$dbPort",
        "$dbUser", "$dbPass",
        { AutoCommit => $AUTOCOMMIT, RaiseError => $RAISEERROR } );

    return $DBH;
}

###
# Map the house numbers to the egauge numbers
#
# House numbers are referenced by egauge numbers as in
#
#     $egaugeHouseMap->{EGAUGE_NUMBER}
#
# @return hash reference
##
sub mapEgaugeNumbersToHouseID {

    # grab house data and make a hash mapping house numbers to egauge ids
    my $sql            = "SELECT house_id, egauge_no FROM house";
    my $sth            = $DBH->prepare($sql);
    my $result         = $sth->execute;
    my %egaugeHouseMap = ();

    # process each row
    while ( my $row = $sth->fetchrow_hashref ) {
        $egaugeHouseMap{ $row->{egauge_no} } = $row->{house_id};
    }
    return \%egaugeHouseMap;
}

###
# Map header columns to db columns for eGauge energy data.
#
# Data header columns are matched to $colAssoc->{HEADER_NAME}
#
# @return hash reference
##
sub mapCSVColumnsToDatabaseColumns {
    my %colAssoc = ();

    # column associations
    $colAssoc{"Date & Time"} = "datetime";
    $colAssoc{"use [kW]"}    = "use_kw";
    $colAssoc{"gen [kW]"}    = "gen_kw";

    # some have whole house, others have grid
    $colAssoc{"Whole House [kW]"} = "grid_kw";
    $colAssoc{"Grid [kW]"}        = "grid_kw";

    $colAssoc{"Fan [kW]"}    = "fan_kw";
    $colAssoc{"AC [kW]"}     = "ac_kw";
    $colAssoc{"AC+ [kW]"}    = "acplus_kw";
    $colAssoc{"DHW [kW]"}    = "dhw_kw";
    $colAssoc{"Stove [kW]"}  = "stove_kw";
    $colAssoc{"Dryer [kW]"}  = "dryer_kw";
    $colAssoc{"Washer [kW]"} = "clotheswasher_kw";

    $colAssoc{"Dishwasher [kW]"} = "dishwasher_kw";

    $colAssoc{"Solar [kW]"}      = "solarpump_kw";
    $colAssoc{"Solar Pump [kW]"} = "solarpump_kw";

    #$colAssoc{""} = "microwave_kw"; # only one house has microwave data

    return \%colAssoc;
}

###
# Get last unix timestamp where energy_autoload data was retrieved.
#
# @param house ID
# @return unix timestamp or 0 if nothing was found
##
sub getLastUnixTimestampForEnergyAutoloadHouse {
    my ($houseID) = @_;

    my $tableName = "energy_autoload_new_dates"; # @todo remove hardcoding

    # convert postgres timestamps to unix timestamps
    my $sql
        = "SELECT house_id, date_part('epoch',\"E Latest Date\") as unix_timestamp FROM $tableName";
    my $sth    = $DBH->prepare($sql);
    my $result = $sth->execute;

    # process each row
    while ( my $row = $sth->fetchrow_hashref ) {
        if ( $row->{house_id} eq $houseID ) {
            return $row->{unix_timestamp};
        }
    }
    return 0;
}

###
# Get the last sequence value used to assign a database key.
#
# @param column for which to return the last sequence value.
# @return last sequence value for a given column
##
sub getLastSequenceValue {
    my ($column) = @_;

    my $sql    = "SELECT currval(pg_get_serial_sequence('$column')";
    my $sth    = $DBH->prepare($sql);
    my $result = $sth->execute();

    while ( my $row = $sth->fetchrow_hashref ) {
        if ( $row ne "0E0" && $row ) {
            return $row->{$column};
        }
        return 0;
    }
}

###
# Print the current local date in y-mon-d-day-hh-mm-ss format.
#
# @return formatted data string
##
sub getDateString {
    use Time::localtime;
    my $local = localtime();
    return sprintf(
        "%s-%s-%02d-%s-%02d-%02d-%02d",
        $local->year() + 1900,
        qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec) [ $local->mon ],
        $local->mday,
        (qw(Sun Mon Tue Wed Thu Fri Sat Sun))[ $local->wday() ],
        $local->hour,
        $local->min,
        $local->sec
    );
}

###
# If energy record exists, given house ID and datetime as Unix timestamp than return 1; else return 0
#
# @param table name
# @param house ID
# @param datetime
# @return 1 if record exists | 0 if it doesn't exist
##
sub energyRecordExists {
    my ( $tableName, $houseID, $datetime ) = @_;
    my $sql
        = "select house_id, datetime from $tableName where house_id = ? and datetime = to_timestamp(?)";
    my $sth = $DBH->prepare($sql);

    my $result = $sth->execute( $houseID, $datetime );

    if ( $result eq "0E0" ) {
        return 0;
    }
    if ( $result == 1 ) {
        return 1;
    }
    return 0;
}

###
# Perform moving of a directory in a reliable way.
#
# from http://www.perlmonks.org/?node_id=586537
#
# @param source directory
# @param destination directory
# @return 1 if success | 0 if fail
##
sub moveReliable {
    use File::Copy;
    use Carp qw(croak);

    my ( $source_dir, $destination_dir ) = @_;

    if ( !-d $source_dir ) {
        die "$source_dir is not a directory!";
    }
    if ( !-d $destination_dir ) {
        die "$destination_dir is not a directory!";
    }
    print "moving from $source_dir to $destination_dir/$source_dir\n";

    if ( move( "$source_dir", "$destination_dir/$source_dir" ) ) {
        print "successful move\n";
        return 1;
    }
    else {
        print "failed move\n";
        return 0;
    }
}

###
# Verify that data is valid.
# If it is invalid move the file to an invalid data directory.
#
# @param filename
# @return 0 if invalid
# @return 1 if valid
##
sub verifyData {
    my ($filename) = @_;

    my $colCount      = 0;
    my $firstColCount = 0;
    my $lineCnt       = 0;    # initial state

    print "\tverifying $filename\n";

    open( FILE, "<$filename" );
    my @data = <FILE>;
    close(FILE);

    my @dataCols;

    foreach my $line (@data) {
        @dataCols = split( /\,/, $line );

        if ( $lineCnt == 0 ) {
            $firstColCount = scalar(@dataCols);
        }
        else {
            $colCount = scalar(@dataCols);
        }
        if ( $colCount != $firstColCount && $colCount != 0 ) {
            return 0;    # mismatched column counts are NOT ok
        }
        $lineCnt++;
    }
    if ( $lineCnt > 0 ) {
        return 1;
    }
    return 1;   # empty files are ok b/c they don't kill the insertion process
}

1;

