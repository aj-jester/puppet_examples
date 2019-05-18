#!/usr/bin/perl

# nagios: -epn
# --
# check_cdot_interfaces.pl - Check cDOT Interface Groups Status
# Copyright (C) 2013 noris network AG, http://www.noris.net/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see http://www.gnu.org/licenses/gpl.txt.
# --

use strict;
use warnings;

use lib "/usr/lib64/nagios/plugins/contrib/lib/NetApp";
use NaServer;
use NaElement;
use Getopt::Long;

GetOptions(
    'hostname=s' => \my $Hostname,
    'username=s' => \my $Username,
    'password=s' => \my $Password,
    'help|?'     => sub { exec perldoc => -F => $0 or die "Cannot execute perldoc: $!\n"; },
) or Error("$0: Error in command line arguments\n");

sub Error {
    print "$0: " . $_[0] . "\n";
    exit 2;
}
Error('Option --hostname needed!') unless $Hostname;
Error('Option --username needed!') unless $Username;
Error('Option --password needed!') unless $Password;

my $s = NaServer->new( $Hostname, 1, 3 );
$s->set_transport_type("HTTPS");
$s->set_style("LOGIN");
$s->set_admin_user( $Username, $Password );

my $iterator = NaElement->new("net-port-get-iter");
my $tag_elem = NaElement->new("tag");
$iterator->child_add($tag_elem);

my $next = "";
my @failed_ports;

while(defined($next)){
    unless($next eq ""){
        $tag_elem->set_content($next);    
    }

    $iterator->child_add_string("max-records", 100);
    my $lif_output = $s->invoke_elem($iterator);

	if ($lif_output->results_errno != 0) {
	    my $r = $lif_output->results_reason();
	    print "UNKNOWN: $r\n";
	    exit 3;
	}

	my $lifs = $lif_output->child_get("attributes-list");
	my @lif_result = $lifs->children_get();
	
	foreach my $lif (@lif_result){
	
	    my $type = $lif->child_get_string("port-type");

	    if($type eq "if_group"){
	
	        my $name = $lif->child_get_string("port");
	        my $node = $lif->child_get_string("node");
	        my $state = $lif->child_get_string("link-status");
	
	        if($state ne "up"){
	            push(@failed_ports, "$node:$name");
	        }
	    }
	}
	$next = $lif_output->child_get_string("next-tag");
}

my $failed_count = @failed_ports;

if($failed_count != 0){
    print "CRITICAL: ";
    foreach (@failed_ports){
        print "$_ not up, ";
    }
    print "\n";
    exit 2;
} else {
    print "OK: All IFGRP fully active\n";
    exit 0;
}

__END__

=encoding utf8

=head1 NAME

check_cdot_interfaces - Check cDOT Interface Group Status

=head1 SYNOPSIS

check_cdot_interfaces.pl --hostname HOSTNAME --username USERNAME \
           --password PASSWORD

=head1 DESCRIPTION

Checks if all Interface Groups have every single link up

=head1 OPTIONS

=over 4

=item --hostname FQDN

The Hostname of the NetApp to monitor

=item --username USERNAME

The Login Username of the NetApp to monitor

=item --password PASSWORD

The Login Password of the NetApp to monitor

=item -help

=item -?

to see this Documentation

=back

=head1 EXIT CODE

3 on Unknown Error
2 if any link is down
0 if everything is ok

=head1 AUTHORS

 Alexander Krogloth <git at krogloth.de>
