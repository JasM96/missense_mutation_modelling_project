#!bin/bash

# Setup

# please change these variables before commencing:
##################################################
# gene symbol name
gene=FKRP
# full directory pathway to output
output=~/Desktop/SETUP/$gene'_missense_mutation_project'/output
# enter the name of the .pdb file to be mutated
model=6kak
# enter mutate_model.py for mutating 1 chain, mutate_model_2chains.py for mutating 2 chains
script=mutate_model_2chains.py
#################################################

# working directory
working=$(pwd)
# resources directory
resources=../resources
# tmp directory
tmp=../tmp
# repaired pdb
model=${model}_Repair
# modeller location
modeller=~/anaconda3/lib/modeller-10.4

# create array variables to ieterate through in for loop
resPos=( $(<"$tmp/res_pos.txt") ) # reisdue position number
resTy=( $(<"$tmp/res_ty.txt") ) # residue type

# chain letter in capital
chain1=A 
chain2=B # must be pair of chain1

#################################################

echo
echo "Creating Mutations"

# copy script and pdb model to modeller directory
cp $script $tmp/$model.pdb $modeller
# enter the directory of modeller 
cd $modeller

# for loop to enter command to create different mutations - see README.md for notes on script usage
for ((i=0; i<${#resPos[@]}; i++)); do
    python $script $model ${resPos[i]} ${resTy[i]} $chain1 $chain2 > $model${resTy[i]}${resPos[i]}.log
done

echo
echo "Mutated model creation complete and log files with energies written"
echo
echo "Moving mutated PDB files and logs to output directory"

# move created files to output directory 
for ((i=0; i<${#resPos[@]}; i++)); do
    mv $model${resTy[i]}${resPos[i]}.pdb $output/mutated_PDB_files/pathogenic
    mv $model${resTy[i]}${resPos[i]}.log $tmp
done

# delete copy of script and wildtype model from modeller
rm $script $model.pdb
# return to home directory
cd $working

echo
echo "Process Complete"
echo
