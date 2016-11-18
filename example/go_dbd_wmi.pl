#!/usr/bin/perl -W

use strict;

use DBI;
use DBD::WMI;

my $exMachine = $ARGV[2];
my $user = $ARGV[0];
my $pass = $ARGV[1];
print 'connecting now to ' . $exMachine . "\n";
my $params = {};
$params->{$ARGV[3]} = $ARGV[4];
my $dbh = DBI->connect( 'dbi:WMI:' . $exMachine,
    $user,
    $pass,
    $params
) or print 'uh!' . "\n";

my $req = 'SELECT * FROM Win32_Process';
my $sth = $dbh->prepare( $req );
$sth->execute();
print 'just executed request' . "\n";
while (my @row = $sth->fetchrow) {
    my $proc = $row[0];
    print join "\t", $proc->{Caption}, $proc->{ExecutablePath} || "<system>";
    # $proc->Terminate();
    print "\n";
}
