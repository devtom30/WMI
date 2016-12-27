#!/usr/bin/perl
use strict;
#use warnings FATAL => 'all';

use sigtrap qw(handler errorHandler untrapped);


sub errorHandler {
    print 'error !' . "\n";
};

use Win32::OLE qw/in/;
#$Win32::OLE::Warn = 3;
use Win32::OLE::Variant;

use Data::Dumper;


use TheWin32;

my $HKLM = 0x80000002;

my $computer = $ARGV[2];
my $user     = $ARGV[0];
my $pass     = $ARGV[1];

my $service =
    TheWin32::_connectToService( $computer, $user, $pass, "root\\default" );
if ( !$service ) {
    print 'sa race de service';
    exit;
}

Win32::OLE->Option(Warn => 3);

print 'service ok ';
print "\n";

my $objReg = $service->Get("StdRegProv");

my $hkey = $Win32::Registry::HKEY_LOCAL_MACHINE;

