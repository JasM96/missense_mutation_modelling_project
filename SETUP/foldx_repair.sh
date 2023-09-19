#!/bin/bash

# edit these variables
###################################
# enter modelname
model=6kak
# variable to call foldx - change to either foldx_mac/foldx_linux depending on local system
foldx=./foldx_mac
###################################

# bin as working directory
working=$(pwd)

# directory locations
foldxdir=../repository/software/foldx5
tmp=../tmp
resources=../resources



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

# move repaired pdb and log to output
mv ${model}_Repair.pdb ${model}_Repair.log ../../$tmp

# delete copy of starting model and uneeded .fxout
rm $model.pdb *.fxout

# return to bin directory
cd $working
