package WSMan;
use strict;
use warnings FATAL => 'all';


sub getWin32Services {
    my ($wsmanConnection) = @_;

    my $uri = 'http://schemas.microsoft.com/wbem/wsman/1/wmi/root/cimv2/Win32_Service';
    my $obj = Tools::getEnumerateResponseObjectForURI($wsmanConnection, $uri);

    my @filteredKeys = (
        'Name',
        'DisplayName',
        'SystemName',
        'Description',
        'Started',
        'State'
    );
    my $services = Tools::extractDataFromItemsInSoapDataObj($obj, 'Win32_Service', \@filteredKeys);

    return $services;
}

sub getWin32LogicalDisks {
    my ($wsmanConnection) = @_;

    my $uri = 'http://schemas.microsoft.com/wbem/wsman/1/wmi/root/cimv2/Win32_LogicalDisk';
    my $obj = Tools::getEnumerateResponseObjectForURI($wsmanConnection, $uri);

    my $disks = Tools::extractDataFromItemsInSoapDataObj($obj, 'Win32_LogicalDisk');

    return $disks;
}

sub getWin32Processor {
    my ($wsmanConnection) = @_;

    my $uri = 'http://schemas.microsoft.com/wbem/wsman/1/wmi/root/cimv2/Win32_Processor';
    my $obj = Tools::getEnumerateResponseObjectForURI($wsmanConnection, $uri);

    my $procs = Tools::extractDataFromItemsInSoapDataObj($obj, 'Win32_Processor');

    return $procs;
}

1;
