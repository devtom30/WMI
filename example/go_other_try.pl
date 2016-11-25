#!/usr/bin/perl
use strict;
use warnings FATAL => 'all';

use Win32::OLE qw(in);
use Win32::OLE::Variant;
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

$service = $locator->ConnectServer($computer, "root\\default",
    "domain\\" . $user, $pass);
if ($service) {
    print 'connected to root\\default';
    my $registry = $service->GetObject('StdRegProv');
    my $dd = Data::Dumper->new([$registry]);
    print $dd->Dump;
}


$service = $locator->ConnectServer($computer, "root\\default:StdRegProv",
    "domain\\" . $user, $pass);
print Win32::OLE->LastError() . "\n";
if ($service) {
    print "root\\default:StdRegProv";
    print 'querying for keys ' . "\n";
    foreach my $key (in($service->EnumKey(
        HKEY_LOCAL_MACHINE,
        "Hardware\\Description\\System\\BIOS"
    ))) {
        print $key . "\n";
    }
    print Win32::OLE->LastError() . "\n";
}

