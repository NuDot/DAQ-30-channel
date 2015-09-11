#!/bin/bash
#this code now works with our setup no more errors :)
#I fixed some path issues, by removing the path option it searches default paths and by moving some 
#files in the home directories and the /usr/share/snmp/mibs i.e. the 2 default directories

#maybe add a on/off protection
#maybe add an if/fi statement for wether or not their are enough values in text file for the channels
#and if there isn't set the voltage for such lines as 0

############################################
#double check ip address&values within file#
############################################
ip=198.125.161.201
file='crate_voltages.txt'
setCurrent=.100
setStatus=1
setRamp=100
channelCount=$(snmpget -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputNumber.0)
indices=$(snmpwalk -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputIndex)
x=(`echo $indices | tr ' ' ' '`)

COUNTER=0
while [ "$COUNTER" -lt $channelCount ]; do
        index=$(echo ${x[${COUNTER}]})
        let line=COUNTER+1
        #this line pulls the value from file with line number from $line
        setVoltage=$(sed ""$line"q;d" "$file")
        voltage=$(snmpset -OqvU -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputVoltage.$index F $setVoltage)
        iLimit=$(snmpset -OqvU -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputCurrent.$index F $setCurrent)
        rampspeed=$(snmpset -OqvU -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputVoltageRiseRate.$index F $setRamp)
        status=$(snmpset -OqvU -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputSwitch.$index i $setStatus)
        voltage=$(snmpget -OqvU -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputVoltage.$index)
        iLimit=$(snmpget -OqvU -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputCurrent.$index)
        sense=$(snmpget -OqvU -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputMeasurementSenseVoltage.$index)
        current=$(snmpget -OqvU -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputMeasurementCurrent.$index)
        rampspeed=$(snmpget -OqvU -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputVoltageRiseRate.$index)
        status=$(snmpget -OqvU -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputSwitch.$index)
        echo "$voltage $iLimit $sense $current $rampspeed $status"
        let COUNTER=COUNTER+1
done
#end
