# Setup and Guide

This README.md markdown file will guide users to set up a project directory system with required software to use the included scripts to subset and obtain REVEL scores for missense mutation ClinVar and gnomAD datasets of any gene of interest then model and calculate ΔG thermodynamics for a selection of mutant structures using a PDB file of the translated protein of a gene that are ready for visualisation with PyMOL.

Please read carefully each step and run any code chunks within a terminal window using UNIX.

Part of this project will use SLURM to run scripts creating batch jobs. It will require access to a supercomputer remote server such as HAWK from Supercomputing Wales, which features SLURM. However, instructions and alternate scripts (without slurm in script name) are provided for users without access to a remote server to run this process locally.

FoldX and Modeller provided for execution of the project is done so under an academic license. Please do not use these softwares for commercial purposes.

**System and Software Requirements**

* Local System terminal using UNIX
* OSX or Linux operating system
* Minimum 3 GB free space (dependant on number of models to be created)
* Anaconda Navigator, Python, R and RStudio installed beforehand

Ensure you have Anaconda, Python, R and RStudio installed on your local system before continuing:

**Download Links**

If you do not have the required software please use the following links to download and install:

* Anaconda Navigator: [https://www.anaconda.com/download](https://www.anaconda.com/download)
* Python: [https://www.python.org/downloads/](https://www.python.org/downloads/)
* R and RStudio: [https://posit.co/download/rstudio-desktop/](https://posit.co/download/rstudio-desktop/)

## 1. Setup Project with project_setup.sh

The Shell script project_setup.sh is designed to set up a missense mutation project for any gene and model.

To set up the project enter `bash project_setup.sh` **within the SETUP directory** in a terminal window on both **local and remote server system**. Follow the instructions appropriately to correctly set up the project on each system.

If you do not have access to a remote server system, please refer to the subsection 'Installation of Modeller' below after completing the setup on your local system.

The `project_setup.sh` script will download REVEL scores for all regions of a chromosome number for the gene of interest when prompted. However, you must know the chromosome number beforehand.

### *FKRP* Missense Mutation Project

Options are given to install files required for running a prepared example project for *FKRP* missense mutations. If you intend to set up a *FKRP* missense mutation project please enter **6kam** when prompted for the pdb model of choice. If chosen for a remote system, proceed to step 4 of README.md after the script has completed its run.

### Manual Setup

If there are errors running project_setup.sh on your system, use the following commands to execute production of the directories in the desired location of your remote server account **and** desired local system location:

```
# FKRP is used as an example for the gene variable - change accordingly

# enter home directory of HAWK account or any desired directory locally and set working directory
working=$(pwd)

# enter working directory
cd $working

# set name of gene of interest for project
gene=FKRP

# create main directory with gene name
 mkdir -p $gene"_missense_mutation_project"

# set project main directory as working 
project_working=$working/$gene"_missense_mutation_project"
```

Then using the code chunk above both locally and remotely enter the code chunk below according to local or remote location:

```
# LOCAL FOLDER STRUCTURE SETUP
mkdir -p $project_working/{resources,bin,tmp,output/{data_subset,REVEL_scores,mutated_pdb_files/{benign,pathogenic},structure_energies/{wild_type,benign,pathogenic}}}
```

``` 
# REMOTE FOLDER STRUCTURE SETUP
mkdir -p $project_working/{resources,bin/{ERR,OUT},tmp,output/{mutated_pdb_files/{benign,pathogenic},structure_energies/{wild_type,benign,pathogenic}},repository/software/modeller}
```

Then move all the scripts and R markdown file to the bin directory, FoldX directory to the software directory within the repository directory (ClinVar and gnomAD datasets to the resources directory if local).

### Data Required

**ClinVar and GNOMAD databank query**

The raw query results for *FKRP* missense mutations from ClinVar and GNOMAD used for this project have been provided as .txt and .csv files.

The R Markdown data_manipulation.Rmd for this project is designed to be applicable to ClinVar and gnomAD databank query results for any type of missense mutation from any gene of interest.

If performing the prepared FKRP missense mutation project on a remote system **skip** to step 4 **after** completing step 1.

If using different missense query results, the ClinVar and gnomAD datasets must be downloaded into the local system project resources directory.

**REVEL**

REVEL is an ensemble method for predicting the pathogenicity of missense variants. It integrates scores from MutPred, FATHMM v2.3, VEST 3.0, PolyPhen-2, SIFT, PROVEAN, MutationAssessor, MutationTaster, LRT, GERP++, SiPhy, phyloP, and phastCons. Scores range from 0 to 1 and variants with higher scores are predicted to be more likely to be pathogenic.

REVEL scores for only the chromosome region of FKRP missense mutations are provided within the SETUP directory.

The Shell script `project_setup.sh` can download all regions within a chromosome. Delete any uneeded regions after completing step 2 of this guide to preserve space.

**REVEL file format:**

* **chr**: Chromosome number
* **Chromosome hg19_pos**: Sequence position on the hg19 (GRCh37) human
genome build (1-based coordinates)
* **grch38_pos**: Sequence position on the GRCh38 human genome build (1-based coordinates). Value is "." when there is no corresponding GRCh38 position for the variant.
* **ref**: Reference nucleotide
* **alt**: Alternate nucleotide 
* **aaref**: Reference amino acid
* **aaalt**: Alternate amino acid
* **REVEL**: REVEL score
* **Ensembl_transcriptid**: Ensemble transcript ID(s) corresponding to the given amino acid substitution (multiple transcript IDs are delimited by ";")

For more information and manual download links: [https://sites.google.com/site/revelgenomics/]()

**PDB Model**

project_setup.sh will download any pdb model of choice when the user is prompted to give the model name.
 
Any model from the RCSB PDB databank can be downloaded manually in the terminal by changing the variable `modelname` within the following code chunk

```
# Run the following within the resources directory
# change to name of pdb structure in lowercase
modelname=<model>
# download structure
wget https://files.rcsb.org/download/$modelname.pdb
```

### Installation of Modeller

project_setup.sh will install modeller on a remote server account system and provides installation instructions. However, instruction in this section is provided for local system users.

**The license key for Modeller is MODELIRANJE**

#### Download Modeller Locally using Anaconda

If running mutant pdb structure production on a local system use the following Anaconda commands in a UNIX terminal to install Modeller:

```
conda config --add channels salilab
conda install modeller
```
The user will be guided through a set of instructions and will require the user to append a file with the license key.

The pathway for the location of Modeller will be: `/users/<username>/anaconda3/lib/modeller-10.4` If using Mac OSX.

For more information on downloading Modeller visit: [https://salilab.org/modeller/download_installation.html](https://www.anaconda.com/download)

#### Remote Server Manual download instructions

If there is an issue with running installation of modeller within project_setup.sh run the following on your account:

```
# set variables for gene of interest and working directory
gene=FKRP
working=~/$gene"_missense_mutation_project"

# enter modeller directory
cd $working/repository/software/modeller

# download UNIX version of Modeller
wget https://salilab.org/modeller/10.4/modeller-10.4.tar.gz

# Unpack the file with the following commands:

gunzip modeller-10.4.tar.gz
tar -xvf modeller-10.4.tar

# Enter the `./modeller-10.4` directory and run the installation script:
cd modeller-10.4
./Install
```

The Install.sh script will guide you through a set of instructions and will require the user to enter the license key.

Select option 2 when prompted to choose type of computer by entering `2`.

Set the download location to the repository directory by typing out the pathway to the project repository directory starting from home (example for FKRP: `/home/<username>/FKRP_missense_mutation_project/repository/software/modeller`) when prompted and pressing enter.

Remove the tarball file once installation is complete:

```
# return to modeller directory
cd ..
# remove tarball
rm modeller-10.4.tar
```

## 2. Run data_manipulation.Rmd in RStudio

Once project_setup.sh has completed running, open and run data_manipulation.Rmd in RStudio.

There is an optional choice of creating lists from data manipulation all putatively pathogenic mutation residue types and positions for mutation to res_pos.txt and res_ty.txt. 

If you are creating a considerable (>10) amount of mutations and performing mutations on remote server, please change the Slurm parameter `--time=` in scripts `create_mutations_slurm.sh` and `create_benign_mutations.sh` to 20-30 minutes.

Upon completion, transfer benign_res_ty.txt, benign_res_pos.txt, res_ty.txt and res_pos.txt created in data_manipulation.Rmd to the remote resources directory of the project using command `scp` in preparation as input for the Modeller scripts.

This process will ask for you to enter your remote server account password.

The code below uses a HAWK remote server account as an example (change <>):

Change <> to the pathways to the project.

```
# enter HAWK account username
username=<c.c22085422>

# gene of interest for project
gene=<gene_name>

# enter local tmp directory
cd <local/pathway>/$gene"_missense_mutation_project"/tmp

# execute the following in the directory containing the .txt files
# transfer all residue lists to remote account
scp *pos.txt *ty.txt $username"@hawklogin.cf.ac.uk":/<remote/pathway>/$gene"_missense_mutation_project"/resources
```

## 3. Run 

### 3.1 Run *In Silico* Mutagenesis for Visualisation

**This section is only for conduting a *FKRP* missense mutations project**

For *FKRP* missense mutation mutant PDB visualisation from experimental PDB model 6KAK, two shell scripts are provided:

1. pathogenic_visualisation_slurm.sh/pathogenic_visualisation.sh
2. benign_visualisation_slurm.sh/benign_visualisation.sh 

These scripts will create mutant models from an orginal experimental model instead of a FoldX repaired model. This will allow unrecognised substrates in FKRP to be visualised - FoldX will remove unrecognised substrates from a PDB. The experimental PDB model of 6KAM will be downloaded when running the first script; there is no need to manually download it.


#### Remote Server System Instructions

To begin, enter `sbatch pathogenic_visualisation_slurm.sh` within the bin directory.

The subsequent slurm script benign_visualisation_slurm.sh will be submitted to slurm and executed automatically in serial fashion.

The submission of scripts as batch jobs ensures that scripts will run even if the user is disconnected from the server. Comments will be printed in the stdout file within the OUT directory to let the user know what processes took place and if it completed sucessfully. Error reports will be within the ERR directory if errors are encountered. 

#### Local Server System Instructions

To begin, enter `bash pathogenic_visualisation.sh` within the bin directory.

The subsequent scripts will be executed automatically in serial fashion. Comments will be printed within the terminal to let the user know what processes are taking place and when it is complete.

### 3.2 Run *In Silico* Mutagenesis for Thermodynamic Analysis with Foldx and Modeller

There are four Shell scripts included in this directory that must be run in this order:

1. foldx_repair_slurm.sh/foldx_repair.sh
2. create_mutations_slurm.sh/create_mutations_slurm.sh
3. create_benign_mutations_slurm.sh/create_benign_mutations.sh
4. foldx_stability_slurm.sh/foldx_stability.sh

**NOTE**: Shell scripts are set to the default gene name of FKRP for project directory and FKRP PDB model of 6kak and will use Python script mutate_model_2chains.py for create_mutations Shell scripts. Each script has a section highlighted by hashes (#) to indicate which variables should be edited. The Shell (.sh) scripts must be edited to user specifics prior to execution. This can be done by entering `nano <scriptname>.sh` in a terminal window within the directory they exist using `ctrl x` to save changes or edited externally using TextEdit (OSX).

**Execution of Scripts**

All Shell scripts (local/remote) **must** be **submitted/executed** within the **bin directory**.

#### Remote Server System Instructions

To begin, enter `sbatch foldx_repair_slurm.sh` within the bin directory.

The subsequent slurm scripts will be submitted to slurm and executed automatically in serial fashion.

The submission of scripts as batch jobs ensures that scripts will run even if the user is disconnected from the server. Comments will be printed in the stdout file within the OUT directory to let the user know what processes took place and if it completed sucessfully. Error reports will be within the ERR directory if errors are encountered. 

#### Local Server System Instructions

To begin, enter `bash foldx_repair.sh` within the bin directory.

The subsequent scripts will be executed automatically in serial fashion. Comments will be printed within the terminal to let the user know what processes are taking place and when it is complete.

## Shell Script Notes

Please refer to these notes for optimisation at each step according to model being analysed.

### foldx_repair Shell Scripts

The process wil take ~15-40 minutes depending on model file size and system.

The repaired model will be output to the tmp directory.

**NOTE**: The repaired structure was not used in visualisation of *FKRP* mutants. If you plan to use the energy minimized structure for visual comparison bewtween mutants save a copy of the repaired PDB before deleting the tmp directory once the project is complete.

### visualisation and create mutations Shell Scripts

Python scripts are provided that will mutate a single residue in a single chain (`mutate_model.py`) and a single residue simultaneously within 2 (should be a pair) chains (`mutate_model_2chains.py`). Shell scripts create_mutations.sh/create_mutations_slurm.sh and create_benign_mutations.sh/create_benign_mutations_slurm.sh execute these Python scripts.

The scripts should each take roughly 5 minutes to complete If approximately 10 mutated structures are being produced.

Log files are created that are deposited in the tmp directory. These can be used to check which residues have been recognised by Modeller and if it has successfully built the mutant models

#### Script Usage Notes

Explanation of Python scripts execution without Shell scripts.

Local execution using Modeller installed with Anaconda:

```
# Usage for the mutate_model.py script if executed without Shell script: 
mod10.4 mutate_model.py modelname respos resname chain > logfile
```

```
#  Usage for the mutate_model_2chains.py script if executed without Shell script:
mod10.4 mutate_model_2chain.py modelname respos resname chain > logfile
```

### foldx_stability Shell Scripts

ΔG reports will be stored in the structure_energies directory within the output directory.

## 4. Transfer Output Files from Remote Server to Local System

If Modeller scripts were executed locally ignore this step and continue to step 5.

Transfer the output subdirectories to the output directory of your local system.

This process will ask for you to enter your remote server account password.

An example is provided using a HAWK remote server account (change pathway within <>):

```
# alter variables to preference
account=c.c22085422
gene=FKRP

# transfer all subdirectories within output to local sytem output directory

scp -r $account@hawklogin.cf.ac.uk:/home/$account/<pathway/to>/$gene'_missense_mutation_project'/output/* \
/<pathway/to>/Desktop/$gene'_missense_mutation_project'/output/
``` 

All temporary files of the tmp directory may now be deleted. To save more space, delete the REVEL files within the resources directory. To delete a directory use `rm -r` then directory name after a space.

## 5. Install PyMOL

Download opensource PyMOL, which is free to use as an Anaconda package on the local system terminal:

```
conda install -c tpeulen pymol-open-source
```

## 6. Visualise Mutant Structures using PyMOL

Enter the directory mutated_pdb_structures in a terminal window and open PyMOL by entering `pymol`.

To load a structure type in the console eg. `load pathogenic/<name>.pdb` or use the PyMOL GUI: File -> Open...

### Viewing mutated residues

To view the reisdue open the sequence viewer click Display on the GUI and then click Sequence. 

Now that the sequence viewer is open select the mutated residue using the horizontal scroll bar to search for the mutated residue type and number and click on the mutant residue.

Right click the selected residue and select show sticks then orient to zoom onto the selection.

click and move the mouse to move the model around

Load in the wild type model (6kam.pdb if for *FKRP* wild type)to compare with the mutant model.

To change colours of structures use the one letter menu to the right of the structure names (grey area) and click the multicolour icon 'C' then select 'by element' and choose from the list of colour sets.

## 7. Calculate ΔΔG

The FoldX stabiliy reports have ΔG listed as in kcal/mol

How to caluclate ΔΔG

ΔΔG = mutant ΔG - repaired wild type ΔG