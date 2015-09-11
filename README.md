# DAQ-30-channel-test
Collection of scripts to run and setup the HV crate 

I believe the PMT target voltage is 1750v

crate_voltage.txt
is where you write in the voltage/gain specifics for each pmt 

set_crate_voltages.sh
sets voltages based on values in crate_voltage.txt

turn_off_PMT_voltages.sh
sets all PMT voltages to 0

Page 21 is where all of the net-snmp commands start being explained.
http://file.wiener-d.com/documentation/MPOD/WIENER_MPOD_Manual_2.7.1.pdf

##########################################################################################
brief notes on commands, options and arguements to follow...
##########################################################################################

this prints out the channel, voltages, currents, and wether its on or off.
 same as when you type http://198.125.161.201 into a webrowser url.
it has 7 columns of data --------V
snmpwalk -Cp -Oqv -v 2c -m +WIENER-CRATE-MIB -c public 198.125.161.201 crate

this command tells you how many channels you have avaialable----V
snmpget -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru 198.125.161.201 outputNumber.0

the borrowed module has 16 channels
each of the other modules (4) has 48 each 
