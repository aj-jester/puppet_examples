#!/usr/bin/perl
################################################################################
#                                                                              #
#  Copyright (C) 2012 Chad Columbus <ccolumbu@hotmail.com>                     #
#                                                                              #
#   This program is free software; you can redistribute it and/or modify       #
#   it under the terms of the GNU General Public License as published by       #
#   the Free Software Foundation; either version 2 of the License, or          #
#   (at your option) any later version.                                        #
#                                                                              #
#   This program is distributed in the hope that it will be useful,            #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of             #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              #
#   GNU General Public License for more details.                               #
#                                                                              #
#   You should have received a copy of the GNU General Public License          #
#   along with this program; if not, write to the Free Software                #
#   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA  #
#                                                                              #
################################################################################

###############################################################################
#                                                                             #
# Nagios plugin to /proc for network link up.                          #
# Written in Perl (and uses Getopt::Std module).                              #
#                                                                             #
###############################################################################

use strict;
use Getopt::Std;

my $VERSION = "Version 1.0";
my $AUTHOR = '(c) 2012 Chad Columbus <ccolumbu@hotmail.com>';
my %opts;
getopts('hn:', \%opts);

# Exit codes
my $STATE_OK = 0;
my $STATE_WARNING = 1;
my $STATE_CRITICAL = 2;
my $STATE_UNKNOWN = 3;

# Default values:
my $nic = 'eth0';
my $error = 0;
my $message = '';

# Parse command line options
if ($opts{'h'}) {
  &print_help();
  exit($STATE_OK);
}

# Check if a NIC is passed in:
if (defined $opts{'n'}) {
  # NIC provded use it:
  $nic = $opts{'n'};
}

if (! -e "/sys/class/net/$nic") {
  $message .= "CRITICAL - $nic interface is down, try 'ifup $nic' \n";
  $error = $STATE_CRITICAL;
} else {
  my $file = "/sys/class/net/$nic/operstate";
  if (! open (FILE, "$file")) {
    $message .= "CRITICAL - Can't open $file for reading! \n";
    $error = $STATE_CRITICAL;
  } else {
    my $status = <FILE>;
    close(FILE);
    if ($status !~ /up/si) {
      $message .= "CRITICAL - $nic interface is up, but link is down. Check network cable \n";
      $error = $STATE_CRITICAL;
    }
  }
}

if ($error) {
  print "$message\n";
  exit($error);
}

# If we get here the temperature is ok
print "LINK OK - $nic both interface and link are up.\n";
exit($STATE_OK);

####################################
# Start Subs:
####################################
sub print_help() {
        print << "EOF";
Monitor NIC link is up
$VERSION
$AUTHOR

Options:
-h
   Print detailed help screen
-n 'NIC'
   Set what to monitor. This looks for the name of your NIC: eth0, eth1, bond0, wlan0, etc. Default is eth0.

EOF
}
