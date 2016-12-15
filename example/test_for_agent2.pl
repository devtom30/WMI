#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Win32::OLE qw/in/;
$Win32::OLE::Warn = 3;
use Win32::OLE::Variant;
use Win32::Registry;
use Data::Dumper;
use Data::Structure::Util qw( unbless );

use TheWin32;

my $computer = $ARGV[2];
my $user     = $ARGV[0];
my $pass     = $ARGV[1];

my $service =
  TheWin32::_connectToService( $computer, $user, $pass, "root\\default" );
if ( !$service ) {
    print 'sa race de service';
    exit;
}

print 'service ok ';
print "\n";

my $objReg = $service->Get("StdRegProv");

my $hkey = $Win32::Registry::HKEY_LOCAL_MACHINE;

my $func = sub {
    my $str = shift;
    print $str . "\n" if $str;
    print 'mouarf' . "\n";
};

eval {
    my $rrr = Win32::OLE::Variant->new(Win32::OLE::Variant::VT_BYREF()|Win32::OLE::Variant::VT_BSTR(),0);
    my $retretret = $objReg->GetStringValue($Win32::Registry::HKEY_LOCAL_MACHINE, "HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0",
        "ProcessorNameString", $rrr);
    print 'Quoi (unexisting keyName) : ' . $retretret . "\n";
};
&$func if $@;
print 'error message : ' . Win32::OLE->LastError(0);
