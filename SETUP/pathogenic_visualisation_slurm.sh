#!/bin/bash

###
# project account
#SBATCH --account=<insert_project_id>
# type of node
#SBATCH --partition=compute
# memory per process in GB
#SBATCH --mem=10G
# number of parallel processes (tasks) you are requesting - maps to MPI processes
#SBATCH --ntasks=4
# tasks to run per node (change for hybrid OpenMP/MPI)
#SBATCH --tasks-per-node=4
# maximum job time in hours:minutes:seconds
#SBATCH --time=0-00:05
# job stdout file
#SBATCH -o OUT/mutate_pth.%J
# job stderr file
#SBATCH -e ERR/mutate_pth.%J
# job name id
#SBATCH --job-name=mutate_pth
###

######################################################################
# Variable setup

# enter gene name for project
gene=FKRP
# enter the name of the .pdb file to be mutated
model=6kam
# enter mutate_model.py for mutating 1 chain, mutate_model_2chains.py for mutating 2 chains
script=mutate_model_2chains.py
# enter protein structure chain letter in capital
chain1=A
# ignore if running mutate_model.py
chain2=B # must be pair of chain1

######################################################################

# working directory
working=$(pwd)
# location for repaired pdb file, residue types and positions files
tmp=$working/../tmp
resources=$working/../resources
# output location
output=$working/../output
# modeller location
modeller=$working/../repository/software/modeller

# create array variables to iterate through the for loop
resPos=( $(<"$resources/res_pos.txt") ) # reisdue position number
resTy=( $(<"$resources/res_ty.txt") ) # residue type

######################################################################

# download pdb for visualisation
wget -P $resources https://files.rcsb.org/download/$model.pdb

# copy model and script to modeller-10.4 directory
cp $resources/$model.pdb $modeller/modeller-10.4
cp $script $modeller/modeller-10.4

echo
echo "Creating Mutations"

# enter modeller-10.4 directory
cd $modeller/modeller-10.4

# for loop to enter command to create different mutations - see README.md for notes on script usage
for ((i=0; i<${#resPos[@]}; i++)); do
    $modeller/bin/modpy.sh python3 $script $model ${resPos[i]} ${resTy[i]} $chain1 $chain2 > $model${resTy[i]}${resPos[i]}.log
done

echo
echo "Mutated model creation complete and log files with energies written"
echo
echo "Moving mutated PDB files and logs to output directory"

# move created files to output sub directories 
for ((i=0; i<${#resPos[@]}; i++)); do
    mv $model${resTy[i]}${resPos[i]}.pdb $output/mutated_pdb_files/pathogenic
    mv $model${resTy[i]}${resPos[i]}.log $tmp
done

# remove model and script copy from modeller-10.4 directory
rm $model.pdb $script

# return to bin directory
cd $working

echo
echo "Process Complete"
echo
echo "Submitting benign_visualisation_slurm.sh to SLURM"
echo
# submit create_benign_mutations_slurm.sh to create putatively benign mutations
sbatch benign_visualisation_slurm.sh