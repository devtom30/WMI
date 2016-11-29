#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Win32::OLE;
use Win32::OLE::Variant;

use TheWin32;


my $computer = $ARGV[2];
my $user = $ARGV[0];
my $pass = $ARGV[1];

my $service = TheWin32::_connectToService(
    $computer,
    $user,
    $pass,
    "root\\default"
);
if (!$service) {
    print 'sa race de service';
    exit;
}

print 'service ok ';
print "\n";

my $objReg = $service->Get("StdRegProv");
if (!$objReg) {
    print 'sa race de objReg';
    exit;
}
print 'objReg ok' . "\n";

my $strKeyPath = "HARDWARE/Description/System/BIOS";
$strKeyPath =~ s/\//\\\\/;
print '$strKeyPath is : ' . $strKeyPath . "\n";
my $strEntryName = "BIOSReleaseDate";
my $result = Variant(VT_BYREF()|VT_BSTR(),0);
my $strValue = $objReg->GetStringValue($Win32::Registry::HKEY_LOCAL_MACHINE, $strKeyPath, $strEntryName);
if (!$strValue || $strValue != 0) {
    print 'usciamo di qua subito' . "\n";
    exit;
}
print 'strValue : ' . $strValue;

$strValue = $objReg->GetStringValue($Win32::Registry::HKEY_LOCAL_MACHINE, $strKeyPath, $strEntryName, $result);

print 'result : ' . $result;

