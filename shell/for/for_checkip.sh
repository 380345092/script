#!/bin/bash
netsub="192.168.220."

for ip in {1..254}
   do
      (	
	if ping -c1 $netsub$ip &>/dev/null;then
		echo "$netsub$ip is open"
        else
                echo "$netsub$ip is close"
	fi
       ) &
done
