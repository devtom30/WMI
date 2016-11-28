#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Win32::OLE qw(in);
use Win32::OLE::Variant;
use Win32::Registry;
use Data::Dumper;

$| = 1;

Win32::OLE->Option(Warn => 9);

use constant HKEY_LOCAL_MACHINE => 0x80000002;


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
#    my $dd = Data::Dumper->new([$obj]);
#    print $dd->Dump;
    print $obj->{Name}."\n";
}

#my $wmiObj = $service->GetObject("winmgmts:\\\\PKGFR-PC\\root\\cimv2");
#my $items = $service->Get('\\\\PKGFR-PC\\root\\cimv2:Win32_PhysicalMemory.Tag="Physical Memory 3"') or warn ('pas glop');

if (2==1) {
    #my $physMem = $service->GetObject('\\\\' . $computer . '\\root\\cimv2:Win32_PhysicalMemory.Tag="Physical Memory 3"') or warn ('pas glop');
    my $physMem = $service->GetObject( 'Win32_PhysicalMemory.Tag="Physical Memory 3"' ) or warn ('pas glop');
    my $dd = Data::Dumper->new( [ $physMem ] );
    print $dd->Dump;

    my $items = $service->Get( '\\\\.\\root\\cimv2:Win32_PhysicalMemory.Tag="Physical Memory 3"' ) or warn ('pas glop');
    foreach my $item (in($items)) {
        my $dd = Data::Dumper->new( [ $item ] );
        print $dd->Dump;
    }
}

#vbscript
#     $strComputer = "192.168.1.100"
#    $strUser = "administrator"
#    $strPassword = "password"
#
#my $HKEY_LOCAL_MACHINE = 0x80000002;
my $strKeyPath = "HARDWARE\\DESCRIPTION\\System\\CentralProcessor\\0\\";
my $strEntryName = "ProcessorNameString";
#$strValue = ""
#
my $objSWbemLocator = Win32::OLE->CreateObject("WbemScripting.SWbemLocator");
my $objSWbemServices = $objSWbemLocator->ConnectServer($computer, "root\\default", $user, $pass);
#
my $objReg = $objSWbemServices->Get("StdRegProv");
my $result = Variant(VT_BYREF|VT_BSTR,0);
my $strValue = $objReg->GetStringValue($Win32::Registry::HKEY_LOCAL_MACHINE, $strKeyPath, $strEntryName, $result);
print 'strValue : ' . $strValue;
print "\n";
print 'result : ' . $result;
print "\n";
print Win32::OLE->LastError() . "\n";

$strKeyPath = 'HARDWARE\DESCRIPTION\System\CentralProcessor\0';
$strValue = $objReg->GetStringValue($Win32::Registry::HKEY_LOCAL_MACHINE, $strKeyPath, $strEntryName, $result);
print 'strValue : ' . $strValue;
print "\n";
print 'result : ' . $result;
print "\n";
print Win32::OLE->LastError() . "\n";

my $arr = Variant( VT_ARRAY | VT_VARIANT | VT_BYREF  , [1,1] );
my $sPath = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall";
# Do not use Die for this method
my $iRC = $objReg->EnumKey($Win32::Registry::HKEY_LOCAL_MACHINE,
    $sPath, $arr); # or die "Cannot fetch registry key :",
print Win32::OLE->LastError;
foreach my $item ( in( $arr->Value ) ) {
    print "$item \n";
} # end foreach

$arr = Variant( VT_ARRAY | VT_VARIANT | VT_BYREF  , [1,1] );
$sPath = "HARDWARE\\Description\\System";
#$sPath = "HARDWARE\\DESCRIPTION\\System";
# Do not use Die for this method
$iRC = $objReg->EnumKey($Win32::Registry::HKEY_LOCAL_MACHINE,
    $sPath, $arr); # or die "Cannot fetch registry key :",
print Win32::OLE->LastError . "\n";
print 'ref($arr) : ' . ref($arr) . "\n";
print 'foreach ' . "\n";
foreach my $item ( in( $arr->Value ) ) {
    print $item . "\n";
    print 'ref($item) : ' . ref($item) . "\n";
} # end foreach

#$arr = Variant( VT_ARRAY | VT_VARIANT | VT_BYREF  , [1,1] );
#$sPath = "HARDWARE\\Description\\System\\BIOS";
my $i = 0;
foreach my $key (in( $objReg->EnumKey($Win32::Registry::HKEY_LOCAL_MACHINE, $sPath))) {
    print $i . ' - ' . ref($key) . "\n";
}
