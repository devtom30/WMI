#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Win32::OLE qw/in/;
use Win32::OLE::Variant;
use Win32::Registry;
use Data::Dumper;

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

my $rrr = Win32::OLE::Variant->new(Win32::OLE::Variant::VT_BYREF()|Win32::OLE::Variant::VT_BSTR(),0);

my $retretret = $params{objReg}->GetStringValue($hkey, "SYSTEM\\CurrentControlSet\\Control\\Network", '{4D36E972-E325-11CE-BFC1-08002BE10318}', $rrr);


my $arr = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
# Do not use Die for this method
my %params = (
    objReg => $objReg,
    keyName => 'SYSTEM/CurrentControlSet/Control/Network/{4D36E972-E325-11CE-BFC1-08002BE10318}',
);
$params{keyName} =~ tr#/#\\#;
my $hkey = $Win32::Registry::HKEY_LOCAL_MACHINE;
my $return = $params{objReg}->EnumKey($hkey, $params{keyName}, $arr);

exit unless defined $return && $return == 0;
my $ddd = Data::Dumper->new([$arr]);
print $ddd->Dump;

my $subKeys = [];
foreach my $item ( in( $arr->Value ) ) {
    next unless $item;
    push @$subKeys, sprintf $item;
    $ddd = Data::Dumper->new([$item]);
    print $ddd->Dump;
} # end foreach
$ddd = Data::Dumper->new([$subKeys]);
print $ddd->Dump;

$arr = Win32::OLE::Variant->new( Win32::OLE::Variant::VT_ARRAY() | Win32::OLE::Variant::VT_VARIANT() | Win32::OLE::Variant::VT_BYREF()  , [1,1] );
# Do not use Die for this method
%params = (
    objReg => $objReg,
    keyName => 'SYSTEM/CurrentControlSet/Control/Network/{4D36E972-E325-11CE-BFC1-08002BE10318}/Descriptions',
);
$params{keyName} =~ tr#/#\\#;
$hkey = $Win32::Registry::HKEY_LOCAL_MACHINE;
$return = $params{objReg}->EnumKey($hkey, $params{keyName}, $arr) or warn('uh');

exit unless defined $return && $return == 0;
$ddd = Data::Dumper->new([$arr]);
print $ddd->Dump;

$subKeys = [];
foreach my $item ( in( $arr->Value ) ) {
    next unless $item;
    push @$subKeys, sprintf $item;
} # end foreach
$ddd = Data::Dumper->new([$subKeys]);
print $ddd->Dump;

my $res = Win32::OLE::Variant->new(Win32::OLE::Variant::VT_DATE(), 0);
my $kn = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion";
my $kv = "InstallDate";
my $ret = $objReg->GetDWORDValue($Win32::Registry::HKEY_LOCAL_MACHINE, $kn, $kv, $res);
print '$ret : ' . $ret . "\n";
print '$res : ' . $res . "\n";
if (defined $ret && $ret == 0 && $res) {
    my $v = $res->Date("dd MM yyyy");
    $v .= ' - '.$res->Date('yyyy/MM/dd');
    $v .= ' - '.$res->Date(Win32::OLE::NLS::DATE_LONGDATE());
    $v .= ' - '.$res->Number({ ThousandSep => '', DecimalSep => '.' });
    print $v . "\n";
} else {
    print "didn't get the value !" . "\n";
}
#
#my $objSWbemLocator = Win32::OLE->CreateObject("WbemScripting.SWbemLocator");
#my $objSWbemServices = $objSWbemLocator->ConnectServer($computer, "root\\default", $user, $pass);
##
#$objReg = $objSWbemServices->Get("StdRegProv");

my $strKeyPathT = "HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0\\";
my $strEntryNameT = "ProcessorNameString";
my $resultT = Variant(VT_BYREF()|VT_BSTR(),0);
my $strValueT = $objReg->GetStringValue($Win32::Registry::HKEY_LOCAL_MACHINE, $strKeyPathT, $strEntryNameT, $resultT);
print '>>>>>>>>>>>>>>>>>>>>> TEMOIN' . "\n";
print 'strValue : ' . $strValueT;
print "\n";
print 'result : ' . $resultT;
print "\n";
print Win32::OLE->LastError() . "\n";
print '<<<<<<<<<<<<<<<<<<<< TEMOIN' . "\n";

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

my $p;
my $e;
my $result;

#my $p = "HARDWARE";
#my $e = "Description";
#my $result = Variant(VT_BYREF|VT_BSTR,0);
#print $p . ' - ' . $e . ' ? ';
#my $res = $objReg->GetStringValue( $Win32::Registry::HKEY_LOCAL_MACHINE, $p, $e, $result );
#if ( $res && $res == 0 ) {
#    print 'ok' . "\n";
#}
#else {
#    print 'pas glop' . "\n";
#}

$p = "HARDWARE\\DESCRIPTION\\System\\BIOS";
$e = "BIOSReleaseDate";
print $p . ' - ' . $e . ' ? ';
$result = Variant(VT_BYREF()|VT_BSTR(),0);
$res = $objReg->GetStringValue( $Win32::Registry::HKEY_LOCAL_MACHINE, $p, $e, $result );
print '$res : ' . $res . "\n";
print '$result : ' . $result . "\n";

$p = "HARDWARE\\DESCRIPTION\\System\\BIOS";
$e = "BIOSReleaseDate";
print $p . ' - ' . $e . ' ? ';
$result = Variant(VT_BYREF|VT_BSTR,0);
$res = $objReg->GetStringValue( $Win32::Registry::HKEY_LOCAL_MACHINE, $p, $e, $result );
print '$res : ' . $res . "\n";
print '$result : ' . $result . "\n";

$p = "HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0\\";
$e = "ProcessorNameString";
print $p . ' - ' . $e . ' ? ';
$result = Variant(VT_BYREF|VT_BSTR,0);
$res = $objReg->GetStringValue( $Win32::Registry::HKEY_LOCAL_MACHINE, $p, $e, $result );
print '$res : ' . $res . "\n";
print '$result : ' . $result . "\n";

$p = "HARDWARE";
$e = "Description";
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
$result = Variant( VT_BYREF() | VT_BSTR(), 0 );
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
      $objReg->EnumKey( $Win32::Registry::HKEY_LOCAL_MACHINE, $path . '\\' . $entry );

    my $ret;
    if ( !$strValue || $strValue != 0 ) {
        $ret = 0;
    }
    else {
        $ret = 1;
    }
    return $ret;
}
