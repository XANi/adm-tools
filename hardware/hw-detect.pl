#!/usr/bin/perl
use strict;
use warnings;
use XML::Simple;
use Data::Dumper;
my $xml_to_parse;
# TODO: make that accept stdin/file or execute lshw
#open(LSHW, '-|', 'lshw -xml');
while(<>) {
    $xml_to_parse .= $_;
}
my $machine_data = XMLin($xml_to_parse);

my $mem_slots = $machine_data->{'node'}{'node'}{'memory'}{'node'};
my $cpu = $machine_data->{'node'}{'node'}{'cpu'};
print &get_memory_slots($mem_slots);
print &get_cpu_info($cpu);


sub get_cpu_info() {
    my $out;
    $out .= 'CPU: ' . $cpu->{'version'} . " slot: " . $cpu->{'slot'} ."\n";
    return $out;
}



sub get_memory_slots {
    my $out;
    $out .= "Memory:\n";
    while(my($bank, $bank_info) = each (%$mem_slots)) {
	$out .=  " bank: $bank" .
	  " clock: " . &get_mhz($bank_info->{'clock'}{'content'}) . "MHz" .
	    " size: " . &get_mbytes($bank_info->{'size'}{'content'}) . 'MB' .
	      " D: " . $bank_info->{'description'} . "\n";
    }
    return $out;
}

sub get_mbytes() {
    my $bytes = shift;
    return int($bytes / 1024 / 1024);
}
sub get_mhz() {
    my $hz = shift;
    return int($hz / 1000 / 1000);
}
