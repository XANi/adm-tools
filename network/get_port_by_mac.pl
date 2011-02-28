#!/usr/bin/perl
# TODO make it less ugly
use Data::Dumper;
my %mac_port;
my %id_mac;
my %id_port;
if(!defined($ARGV[0])) {
    print "usage: \n";
    print " snmpwalk -Os -c public -v 2c switch_ip/host | ./get_port_by_mac de:ad:be:ef\n";
    exit;
}
while(<STDIN>) {
    chomp;
    if ($_ =~ /mib-2\.17\.4\.3\.1\.1/) {# mac-id
	my ($mib, $mac) = split(/=/);
	my @tmp = split(/\./,$mib);
	my $id_mac;
	my $id=join('-',@tmp[6..11]);
	# clean up leading/trailing spaces
	$id =~ s/^\s+//;
	$id =~ s/\s+$//;

	$mac =~ s/^\s+//;
	$mac =~ s/\s+$//;

	$mac =~ s/Hex-STRING: //gi;
	$mac =~ s/ /:/gi;

	$id_mac{$id}=$mac;
    }
    elsif ($_ =~ /mib-2\.17\.7\.1\.2\.2\.1\.2\.1/) {
	my ($mib, $port) = split(/=/);
	my @tmp = split(/\./,$mib);
	my $id=join('-',@tmp[9..14]);
	# clean up leading/trailing spaces
	$id =~ s/^\s+//;
	$id =~ s/\s+$//;

	$port =~ s/INTEGER: //gi;

	$port =~ s/^\s+//;
	$port =~ s/\s+$//;

	$id_port{$id}=$port;
    }
}

# find MAC
while (my ($id, $mac) = each(%id_mac) ) {
    my $mac_to_find = $ARGV[0];
    $mac_to_find =~ tr/[a-z]/[A-Z]/;
    if ( $mac =~ /$mac_to_find/ ) {
	print "$mac - $id_port{$id}\n";
    }
}
