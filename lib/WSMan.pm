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

1;