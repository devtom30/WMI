#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Win32::OLE;
use Win32::OLE::Variant;

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
if ( !$objReg ) {
    print 'sa race de objReg';
    exit;
}
print 'objReg ok' . "\n";

my $path = "HARDWARE/Description/System/BIOS/BIOSReleaseDate";
$path =~ s/\//\\\\/g;
print '$path is : ' . $path . "\n";
print 'trying all paths ' . "\n";
tryAllPath( $objReg, $path );

my $p = "HARDWARE";
my $e = "Description";
print $p . ' - ' . $e . ' ? ';
my $res = $objReg->EnumKey( $Win32::Registry::HKEY_LOCAL_MACHINE, $p, $e );
if ( $res && $res == 0 ) {
    print 'ok' . "\n";
}
else {
    print 'pas glop' . "\n";
}

$p = "HARDWARE\\DESCRIPTION\\System\\BIOS";
$e = "BIOSReleaseDate";
print $p . ' - ' . $e . ' ? ';
$res = $objReg->EnumKey( $Win32::Registry::HKEY_LOCAL_MACHINE, $p, $e );
if ( $res && $res == 0 ) {
    print 'ok' . "\n";
}
else {
    print 'pas glop' . "\n";
}

$p = "HARDWARE\\DESCRIPTION\\System\\BIOS";
$e = "BIOSReleaseDate";
print $p . ' - ' . $e . ' ? ';
$res = $objReg->EnumKey( $Win32::Registry::HKEY_LOCAL_MACHINE, $p, $e );
if ( $res && $res == 0 ) {
        print 'ok' . "\n";
}
else {
    print 'pas glop' . "\n";
}

$p = "HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0\\";
$e = "ProcessorNameString";
print $p . ' - ' . $e . ' ? ';
$res = $objReg->EnumKey( $Win32::Registry::HKEY_LOCAL_MACHINE, $p, $e );
if ( $res && $res == 0 ) {
    print 'ok' . "\n";
}
else {
    print 'pas glop' . "\n";
}


my $strKeyPath = "HARDWARE/Description/System/BIOS";
$strKeyPath =~ s/\//\\\\/g;
print '$strKeyPath is : ' . $strKeyPath . "\n";
my $strEntryName = "BIOSReleaseDate";
my $result = Variant( VT_BYREF() | VT_BSTR(), 0 );
my $strValue = $objReg->GetStringValue( $Win32::Registry::HKEY_LOCAL_MACHINE,
    $strKeyPath, $strEntryName );
if ( !$strValue || $strValue != 0 ) {
    print 'usciamo di qua subito' . "\n";
    exit;
}
print 'strValue : ' . $strValue;

$strValue = $objReg->GetStringValue( $Win32::Registry::HKEY_LOCAL_MACHINE,
    $strKeyPath, $strEntryName, $result );

print 'result : ' . $result;

sub tryAllPath {
    my ( $objReg, $path ) = @_;

    my @path = split /\\\\/, $path;
    my $pathToEntry = shift @path;
    my $entry;

    while (@path) {
        if ( $entry && $entry =~ /[a-z]+/ ) {
            $entry = uc $entry;
        }
        else {
            $entry = shift @path;
        }
        if ( tryPath( $objReg, $pathToEntry, $entry ) ) {
            print 'good for ' . $pathToEntry . ' ' . $entry . "\n";
            $pathToEntry .= "\\" . $entry;
        }
        else {
            print 'foirade for ' . $pathToEntry . ' ' . $entry . "\n";
            next if ( $entry && $entry =~ /[a-z]+/ );
            last;
        }
    }
}

sub tryPath {
    my ( $objReg, $path, $entry ) = @_;

    my $strValue =
      $objReg->EnumKey( $Win32::Registry::HKEY_LOCAL_MACHINE, $path, $entry );

    my $ret;
    if ( !$strValue || $strValue != 0 ) {
        $ret = 0;
    }
    else {
        $ret = 1;
    }
    return $ret;
}
