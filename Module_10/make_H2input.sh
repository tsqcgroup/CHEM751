#!/bin/bash
# Make GAMESS inputs for H2 at many H-H distances.
method=UHF        # change to RHF for the RHF scan
# 1. Write a template input. RVALUE and METHOD are placeholders.
echo ' $contrl scftyp=METHOD coord=zmt $end
 $system mwords=100 $end
 $basis gbasis=n31 ngauss=6 ndfunc=1 npfunc=1 $end
 $guess mix=.true. $end
 $data
 h2
 c1
 H
 H  1  RVALUE
 $end' > template.inp
# 2. Make a folder for the new inputs
mkdir -p $method
# 3. Example loop: R = 0.45 to 0.95 Angstrom, step 0.1
#    seq START STEP END  makes the list 0.45 0.55 0.65 ... 0.95
for i in $(seq 0.45 0.1 0.95); do
  new=$method/H2_${method}_${i}.inp
  cp template.inp $new
  sed -i "s/RVALUE/$i/gI" $new
  sed -i "s/METHOD/$method/gI" $new
done
# 4. TODO: YOUR TURN: write a loop for R = 1.00 to 3.00 Angstrom, step 0.25

echo "Done. Inputs are in the folder $method"

