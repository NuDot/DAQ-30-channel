# DAQ-30-channel-test
Collection of scripts to run and setup the HV crate 


Page 21 is where all of the net-snmp commands start being explained.
http://file.wiener-d.com/documentation/MPOD/WIENER_MPOD_Manual_2.7.1.pdf

Possible brief explanation of commands, options and arguements to follow...

#this prints out the channel, voltages, currents, and wether its on or off.
# same as when you type http://198.125.161.201 into a webrowser url
#this has 7 columns of data 

snmpwalk -Cp -Oqv -v 2c -m +WIENER-CRATE-MIB -c public 198.125.161.201 crate
