#!/usr/bin/perl
use Socket;
use Getopt::Std;

getopts("p:h:d:l:m:", \%args);

print ":::;:::::::::::::::::::::::::::::::::::\n";
print ":: CGI scanner by Azizjon Mamashoev  ::\n";
print "::             Paradox               ::\n";
print ":::::::::::::::::::::::::::::::::::::::\n";

if (!defined $args{h} && !defined $args{m}) {
print qq~

 -p    =  specifies port.
 -h    =  specifies host.
 -d    =  specifies what file should be used as database.
 -l    =  specifies if the scanner should log the scan.
 -m    =  specifies if the scanner should mass scan.

Check the script for Example scans.
~; exit;}

$log=0;
$port=$args{p};

if (defined $args{d}) {
if ($args{d} != 0) { $file = "cgi.ls"; }
else { $file=$args{d} }
open(DB, $file) || die "Can't open database.";
@cgilist = <DB>;
close (DB);
}

if (defined $args{l}) {
$log=1;
open(LOG, ">>$args{l}") || die "Cannot open log file.";
print LOG <<EOT
::::::::::::::::::::::::::::::::::::::::::::::::\n";
::  CGI scanner by Azizjon Mamashoev          ::\n";
:: ________/\________  /\_____  ________ ____ ::\n";
:: \_____  \ \_____  \/  \___ \/    \   |   / ::\n";
::   /  ___/| \|  /  /  | \ |  \  |  \     /  ::\n";
::  /   |   _  \  \  \  _  \    \    /     \  ::\n";
:: /    |___|   \_|\__\_|   \___/___/___|   \ ::\n";
::/_____|---|____\------|____\----------|____\::\n";
::  ... I WILL NEVER STOP LIVING THIS WAY ... ::\n";
::        -ENJOY THE POWER OF MY WORK-        ::\n";
::          -AZIZJON[AT]GMAIL.COM-            ::\n";
::           -TWITTER: @AZIZJONM-             ::\n";
::::::::::::::::::::::::::::::::::::::::::::::::\n";
EOT
;}


if (defined $args{h}) {
$host=$args{h};
&start;
}

if (defined $args{m}) {
$host = $args{m};
($s,$e) = split(/-/,$host);
($ia, $ib, $id, $ix) = split(/\./,$s);
print "Scaning from $s to $ia.$ib.$id.$e\n";
for($i=$ix; $i<=$e; $i++)
{
$host = "$ia.$ib.$id.$i";
&start
 }
}


sub start {
        print "\n Now scanning $host\n\n";
        if ($log) {print LOG "\n Now scanning $host\n\n";}
        foreach $cgilist (@cgilist)
{

        chomp $cgilist;
        print "Scanning - $cgilist :: ";
        $sl=$cgilist;
        &scan;
        }
}


sub scan {

my($iaddr,$paddr,$proto);

$iaddr = inet_aton($host) || die "Error: $!";
$paddr = sockaddr_in($port, $iaddr) || die "Error: $!";
$proto = getprotobyname('tcp') || die "Error: $!";

socket(SOCK, PF_INET, SOCK_STREAM, $proto) || &error("Failed to open socket: $!");
connect(SOCK, $paddr) || &error("Unable to connect: $!");
send(SOCK,"GET $sl HTTP/1.0\r\n\r\n",0);

  $check=<SOCK>;
	($http,$code,$blah) = split(/ /,$check);
        if($code == 200)
	{
                print "Found!\n";
                if ($log) {print LOG "$sl - Found!\n";}
	}
	else
	{
                print "Not Found!\n";

	}
        close(SOCK);
}

sub error
{
$error = shift(@_);
print "Error - $error\n";
exit;
}

