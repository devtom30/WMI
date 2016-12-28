#!/usr/bin/perl
use strict;
#use warnings FATAL => 'all';
use Data::Dumper;

use sigtrap qw(handler errorHandler untrapped);


sub errorHandler {
    print 'error !' . "\n";
    print Dumper %SIG;
    exit;
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

#my $keyName = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\AddressBook';
my $keyName = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\AMD Catalyst Install Manager';

my $values;
my $types;
my $arrValueTypes = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF() , [1,1] );
my $arrValueNames = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF() , [1,1] );
my $return = $objReg->EnumValues($hkey, $keyName, $arrValueNames, $arrValueTypes);
    $types = [];
print Dumper %SIG;
    foreach my $item (in( $arrValueTypes->Value )) {
        push @$types, sprintf $item;
    }
    if (scalar (@$types) > 0) {
        my $i = 0;
        $values = { };
        foreach my $item (in( $arrValueNames->Value )) {
            my $valueName = sprintf $item;

            $i++;
        }
    }

