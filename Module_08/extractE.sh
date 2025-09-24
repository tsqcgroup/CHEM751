#!/bin/bash
method='hf mp2 ccsdt'
basis='ccq'
atom='HF F'
 echo 'method, HF, H, F'
for imethod in $method; do
  for ibasis in $basis; do
  name=${imethod}_${ibasis}.log
  hf=HF_${name}
  h=H_${name}
  f=F_${name}
  EHF=`grep 'FINAL SINGLE POINT ENERGY' $hf | tail -n 1 | awk '{print $5}'`
  EH='-0.5'
  EF=`grep 'FINAL SINGLE POINT ENERGY' $f | tail -n 1 | awk '{print $5}'`
  echo $imethod, $EHF, $EH, $EF
  done
done
