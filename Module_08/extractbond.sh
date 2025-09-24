#!/bin/bash
method='hf mp2'
basis='ccd cct ccq'
for imethod in $method; do
 echo $imethod
 echo 'basis, distance'
  for ibasis in $basis; do
  name=${imethod}_${ibasis}.log
  hf=HF_${name}
  bHF=`grep 'OldVal' -A2 $hf | tail -n 1 | awk '{print $NF}'`
  echo $ibasis, $bHF
  done
done
