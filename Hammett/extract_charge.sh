#!/bin/bash
 list='H CH3 CF3 CHO CN COOCH3 COOH F COCH3 NO2 OCH3 OCOCH3 OH SCH3 NCH3CH3 NH2'
function charge_extrct {
name=${f1}
qmull=`grep 'MULL.POP.    CHARG' -A6 $i | tail -n 6 | awk '{print $4"," }'`
qlow=`grep 'MULL.POP.    CHARG' -A6 $i | tail -n 6 | awk '{print $6"," }'`
echo $name, $qmull $qlow >> $output
}

output=qcharge.txt
echo meta > $output
sub='.log'
for f1 in $list; do
i=Benz-${f1}${sub}
 charge_extrct
done

