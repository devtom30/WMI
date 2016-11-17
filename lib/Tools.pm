package Tools;
use strict;
use warnings FATAL => 'all';


sub extractXmlFromResponse {
    my ($response) = @_;

    my $xmls = [];
    my @split = split /</, $response;
    my $xml = '';
    my $line;
    while ($line = shift @split) {
        $xml .= $line;
        if ($line =~ /\/s:Envelope>/) {
            push @$xmls, $xml;
            $xml = '';
        }
    }

    return $xmls;
}

1;
