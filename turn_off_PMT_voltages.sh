#!/bin/bash

#this code now works with our setup no more errors :)
#I fixed some path issues, by removing the path option it searches default paths and by moving some files in the home directories and the /usr/share/snmp/mibs i.e. the 2 default directories

#maybe add a on/off protection
#then change to python and import vaules from .txt

#adjust variables as needed

#double check ip address.
ip=198.125.161.201

setVoltage=0
setCurrent=.100
setStatus=1
setRamp=100

channelCount=$(snmpget -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputNumber.0)
#^ prints 16 ie total channels in slot 1 currently
indices=$(snmpwalk -Oqv -v 2c -m +WIENER-CRATE-MIB -c guru $ip outputIndex)
#prints u100-u115
x=(`echo $indices | tr ' ' ' '`)
#prints u100 even inside the while loop



COUNTER=0
while [ "$COUNTER" -lt $channelCount ]; do
        index=$(echo ${x[${COUNTER}]})
        #prints u100 then u101...

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
