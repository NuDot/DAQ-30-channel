#!/bin/bash
#Simple Bash Script that will read and set all channels in a MPOD crate to the same voltages and currents
#Pages 34-35 http://file.wiener-d.com/documentation/MPOD/WIENER_MPOD_Manual_2.7.1.pdf


#adjust variables as needed

#replace with proper ip and uncomment.
ip=198.125.161.201

path=/usr/share/snmp/mibs
setVoltage=1650
setCurrent=.100
setStatus=1
setRamp=100
channelCount=$(snmpget -Oqv -v 2c -M $path -m +WIENER-CRATE-MIB -c guru $ip outputNumber.0)
indices=$(snmpwalk -Oqv -v 2c -M $path -m +WIENER-CRATE-MIB -c guru $ip outputIndex)
x=(`echo $indices | tr ' ' ' '`)

COUNTER=0
while [ $COUNTER -lt $channelCount ]; do
        index=$(echo ${x[${COUNTER}]})
        voltage=$(snmpset -OqvU -v 2c -M $path -m +WIENER-CRATE-MIB -c guru $ip outputVoltage.$index F $setVoltage)
        iLimit=$(snmpset -OqvU -v 2c -M $path -m +WIENER-CRATE-MIB -c guru $ip outputCurrent.$index F $setCurrent)
        rampspeed=$(snmpset -OqvU -v 2c -M $path -m +WIENER-CRATE-MIB -c guru $ip outputVoltageRiseRate.$index F $setRamp)
        status=$(snmpset -OqvU -v 2c -M $path -m +WIENER-CRATE-MIB -c guru $ip outputSwitch.$index i $setStatus)
        voltage=$(snmpget -OqvU -v 2c -M $path -m +WIENER-CRATE-MIB -c guru $ip outputVoltage.$index)
        iLimit=$(snmpget -OqvU -v 2c -M $path -m +WIENER-CRATE-MIB -c guru $ip outputCurrent.$index)
        sense=$(snmpget -OqvU -v 2c -M $path -m +WIENER-CRATE-MIB -c guru $ip outputMeasurementSenseVoltage.$index)
        current=$(snmpget -OqvU -v 2c -M $path -m +WIENER-CRATE-MIB -c guru $ip outputMeasurementCurrent.$index)
        rampspeed=$(snmpget -OqvU -v 2c -M $path -m +WIENER-CRATE-MIB -c guru $ip outputVoltageRiseRate.$index)
        status=$(snmpget -OqvU -v 2c -M $path -m +WIENER-CRATE-MIB -c guru $ip outputSwitch.$index)
        echo "$voltage $iLimit $sense $current $rampspeed $status"
        let COUNTER=COUNTER+1
done