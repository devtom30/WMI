#!/usr/bin/perl
use strict;
use warnings;
use Test::More;
use Data::Dumper;

use Tools;
use WSMan;


my $user = $ARGV[0];
my $password = $ARGV[1];
my $host = $ARGV[2];
my $port = $ARGV[3];
my $wsman = Tools::createWSManConnection(
    $user,
    $password,
    $host,
    $port
);
my $services = WSMan::getWin32Services($wsman);
ok ($services);
ok (ref ($services->[0]) eq 'HASH', );


my $disks = WSMan::getWin32LogicalDisks($wsman);
ok ($disks);
my $dd = Data::Dumper->new([$disks]);
print $dd->Dump;

my $procs = WSMan::getWin32Processor($wsman);
ok ($procs);
$dd = Data::Dumper->new([$procs]);
print $dd->Dump;

done_testing();

