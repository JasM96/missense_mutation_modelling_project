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
#SBATCH --time=0-00:10
# job stdout file
#SBATCH -o OUT/stability.%J
# job stderr file
#SBATCH -e ERR/stability.%J
# job name id
#SBATCH --job-name=stability
###

# change variable
#########################################
# enter modelname
model=6kak
########################################

# repaired model name
model=${model}_Repair

# directory locations
working=$(pwd)
foldxdir=../repository/software/foldx5
tmp=../tmp
output=../output

# copy wild type repaired model to foldX directory
cd $tmp
cp *_Repair.pdb $foldxdir

# create array of pathogenic mutants to pass into for loop
cd $output/mutated_pdb_files/pathogenic
echo *.pdb > path_list.txt
pathogenic=( $(<"path_list.txt") )
rm path_list.txt

# copy models to FoldX directory
cp *.pdb ../../$foldxdir

# create array of benign mutants to pass into for loop
cd ../benign
echo *.pdb > ben_list.txt
benign=( $(<"ben_list.txt") )
rm ben_list.txt

# copy models to foldX directory
cp *.pdb ../../$foldxdir

# enter FoldX directory
cd ../../$foldxdir

# variable to call foldx
foldx=./foldx_linux

# begin repair of pdb
echo

echo "Calculating Stability for Wild Type model"
 
# wild type stability
$foldx --command=Stability --pdb=${model}.pdb > ${model}_stability.log

echo

echo "Moving stability report log to output directory"


# move stability report logs to output
mv *.log ../../$output/structure_energies/wild_type

echo

echo "Calculating Stability for pathogenic mutations with FoldX Stability command"

# for loop for pathogenic mutations
for ((i=0; i<${#pathogenic[@]}; i++)); do
    $foldx --command=Stability --pdb=${pathogenic[i]} > ${pathogenic[i]}_stability.log
done

echo

echo "Moving stability report logs to output directory"

echo

# move stability report logs to output
mv *.log ../../$output/structure_energies/pathogenic


echo "Calculating Stability for benign mutations with FoldX Stability command"

# for loop for benign mutations
for ((i=0; i<${#benign[@]}; i++)); do
    $foldx --command=Stability --pdb=${benign[i]} > ${benign[i]}_stability.log
done

echo

echo "Moving stability report logs to output directory"

echo

# move stability report logs to output
mv *.log ../../$output/structure_energies/benign

# delete copies of models from foldx directory
rm *.pdb

echo "Stability calculations complete"

# return to bin directory
cd $working

