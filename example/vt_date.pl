#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Win32::OLE qw/in/;
$Win32::OLE::Warn = 3;
use Win32::OLE::Variant;
use Win32::OLE::NLS;
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


my $res = Win32::OLE::Variant->new(Win32::OLE::Variant::VT_DATE(), 0);
my $kn = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion";
my $kv = "InstallDate";
my $ret = $objReg->GetDWORDValue($Win32::Registry::HKEY_LOCAL_MACHINE, $kn, $kv, $res);
print '$ret : ' . $ret . "\n";
print '$res : ' . $res . "\n";
if (defined $ret && $ret == 0) {
    my $v = $res->Date("dd MM yyyy");
    $v .= ' - '.$res->Date('yyyy/MM/dd');
    $v .= ' - '.$res->Date(Win32::OLE::NLS::DATE_LONGDATE());
    $v .= ' - '.$res->Number({ ThousandSep => '', DecimalSep => '.' });
    print $v . "\n";
} else {
    print "didn't get the value !" . "\n";
}
