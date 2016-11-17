package Tools;
use strict;
use warnings FATAL => 'all';


sub extractXmlFromResponse {
    my ($response) = @_;

    my $xmls = [];
    my @split = split /</, $response;
    @split = grep /\w/, @split;
    my $xml = '';
    my $line;
    while ($line = shift @split) {
        $line = '<' . $line;
        $xml .= $line;
        if ($line =~ /\/s:Envelope>/) {
            push @$xmls, $xml;
            $xml = '';
        }
    }

    return $xmls;
}

1;
