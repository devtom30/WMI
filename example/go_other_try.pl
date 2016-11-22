#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Win32::OLE qw(in);
use Data::Dumper;

$| = 1;

Win32::OLE->Option(Warn => 9);

my $computer = $ARGV[2];
my $user = $ARGV[0];
my $pass = $ARGV[1];

my $locator = Win32::OLE->CreateObject('WbemScripting.SWbemLocator') or
    warn;
my $service = $locator->ConnectServer($computer, "root\\cimv2",
    "domain\\" . $user, $pass);

my @col = in($service->ExecQuery('Select * From Win32_Process'));

foreach my $proc(@col){
    print $proc->{Name}."\n";
}


@col = in($service->ExecQuery('Select * From Win32_PhysicalMemory'));

foreach my $obj (@col){
    my $dd = Data::Dumper->new([$obj]);
    print $dd->Dump;
}
