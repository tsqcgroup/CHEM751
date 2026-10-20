#!/bin/bash
# Extract energies and <S^2> from the GAMESS logs

method=UHF
dist='0.45 0.55 0.65 0.75 0.85
 0.95 1.00 1.25 1.50 1.75 2.00
 2.25 2.50 2.75 3.00'

# Header row of the output file
echo "R, E(hartree)" > H2_${method}.csv
# TODO 1: add a third column name for <S^2>


for i in $dist; do
    name=H2_${method}_${i}.log

    # Example: get the total energy from the log file
    #   grep         : find lines containing 'TOTAL ENERGY ='
    #   tail -n 1    : keep the last one
    #   awk          : print the last word (the number)
    En=$(grep 'TOTAL ENERGY =' $name | tail -n 1 | awk '{print $NF}')

    # TODO 2: get <S^2> the same way and store it in a variable called S2
    #   Hint: in the log file, <S^2> is on a line containing 'S-SQUARED ='


    # TODO 3: add $S2 as a third column in this line
    echo "$i, $En" >> H2_${method}.csv
done

cat H2_${method}.csv

