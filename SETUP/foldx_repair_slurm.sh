#!/bin/bash

###
# project account
#SBATCH --account=<insert_project_id>
# type of node
#SBATCH --partition=compute
# memory per process in GB
#SBATCH --mem=20G
# number of parallel processes (tasks) you are requesting - maps to MPI processes
#SBATCH --ntasks=8
# tasks to run per node (change for hybrid OpenMP/MPI)
#SBATCH --tasks-per-node=8
# maximum job time in hours:minutes:seconds
#SBATCH --time=0-00:50
# job stdout file
#SBATCH -o OUT/repair_pdb.%J
# job stderr file
#SBATCH -e ERR/repair_pdb.%J
# job name id
#SBATCH --job-name=repair_pdb
###

# change variable
#########################################
# enter modelname
model=6kak
########################################

# bin as working directory
working=$(pwd)

# directory locations
foldxdir=../repository/software/foldx5
tmp=../tmp
resources=../resources

# variable to call foldx
foldx=./foldx_linux

# copy model to FoldX directory
cd $resources
cp *.pdb $foldxdir

# enter FoldX directory
cd $foldxdir

# begin repair of pdb

echo
echo "Minimizing and Optimizing" $model "with FoldX RepairPDB command"

$foldx --command=RepairPDB --pdb=$model.pdb  > ${model}_Repair.log
echo
echo "Repair complete"
echo
echo "Moving repaired pdb to output directory"

# move repaired pdb and log to tmp
mv ${model}_Repair.pdb ${model}_Repair.log ../../$tmp

# delete copy of starting model and uneeded .fxout
rm $model.pdb *.fxout

# return to bin directory
cd $working

echo "Submitting create_mutations_slurm.sh to SLURM"
echo
# start in-silico mutagenesis by submitting create_mutations_slurm.sh script to slurm
sbatch create_mutations_slurm.sh
