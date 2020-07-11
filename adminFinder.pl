#!/usr/local/bin/perl

#-----------------------------------------------------------------------------------------#
# Injection tool by http://voixsec.blogspot.com
# Code version: 2.0
# Function file: Found the admin login
#-----------------------------------------------------------------------------------------#

@folders =  &get_list("brute/","admin.txt");

print "Mode: Admin finder v1.0\n\nTarget: ";
chomp($target = <STDIN>);

print "Find:\n\n";

for($i = 0; $i < @folders; $i++)
{
	$folders[$i] =~ s/[\r\n\s]/ /g;	
	$folders[$i] =~ s/\s+$//; 
	
	print "  *".$folders[$i]." - ";
	
	if(&finder($target.$folders[$i]))
	{
		print "True\n\nAdmin login is: ".$target.$folders[$i];
		$i = @folders;
	}
	else
	{
		print "False";
	}
	print "\n";
}

1;
