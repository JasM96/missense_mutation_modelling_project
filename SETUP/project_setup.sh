#!/bin/bash

#set working directory
working=$(pwd)
echo
echo
echo "Welcome to the project setup"
echo
echo "If at any point you make a mistake please press ctrl + c to cancel then run the setup again by entering bash project_setup.sh"
echo
echo "If conditional answers are not answered using the options setup will exit itself but if not please cancel by pressing press ctrl + c"
echo
echo
echo "Please enter full directory pathway of desired installation location on this system:"
echo
read location
echo
echo
echo "Is $location the location you wish to proceed with (y/n)?"
echo
read yn
# dictate and execute decision
# [yY] and [nN] will allow inputs of either case (upper/lower) 
case $yn in
# if answer is yes (y or Y) 
	[yY] ) ;;
# if anything else is typed in error
    * ) echo;
        echo "please retry the setup, exiting...";
        echo
        exit 1;;
# if answer is no (n or N) 
	[nN] ) echo;
        echo Please enter the location you wish to proceed with;
        echo;
		read location;
        echo;
        echo "Is $location the location you wish to proceed with (y/n)?";
        echo;
        read yn2;
        case $yn2 in 
        # if answer is yes (y or Y) 
            [yY] ) ;;
        # if answer is no (n or N)
            [nN] ) echo;
                echo please retry the setup, exiting...
                echo
                exit 1;;
                # if anything else is typed
            * ) echo;
                echo please retry the setup, exiting...
                echo
                exit 1;;
        esac
esac
echo
echo
echo "Enter the symbol of the gene of interest for this project:"
echo
# set name of gene of interest for project directory name
read gene 
echo
echo
echo "Main project directory will be called ${gene}_missense_mutation_project"
echo
echo
# acquire PDB structure
echo "Enter the name of the PDB model with letters in lowercase you wish to use for this project:"
echo
read modelname
echo
echo
echo "Downloading PDB model $modelname from RCSB PDB databank..."
echo
echo
# download structure to resources directory
wget -P $location/$gene"_missense_mutation_project"/resources https://files.rcsb.org/download/$modelname.pdb
echo
echo
echo "Download of $modelname.pdb is complete"
echo
echo
echo "Which type of system are you using to set up this project?:"
echo
echo "1. Local System"
echo "2. Remote System"
echo
echo "Please enter a number for the option that applies (1/2):"
echo
read LclorRmte
echo
echo

case $LclorRmte in
# option 2: REMOTE
	[2] ) echo "Setting up remote system directory structure...";
	   # REMOTE FOLDER STRUCTURE SETUP 
       mkdir -p $location/$gene"_missense_mutation_project"/{resources,bin/{ERR,OUT},tmp,output/{mutated_pdb_files/{benign,pathogenic},structure_energies/{wild_type,benign,pathogenic}},repository/software/modeller};
       echo
       echo
       echo "Transferring scripts to $location/$gene"_missense_mutation_project"/bin";
       echo
       # TRANSFER COPY OF SCRIPTS TO BIN
       cp *slurm.sh *.py $location/$gene"_missense_mutation_project"/bin;
       echo
       echo "Transferring FoldX to $location/$gene"_missense_mutation_project"/repository/software";
       # TRANSFER FOLDX TO SOFTWARE DIRECTORY
       cp -r foldx5 $location/$gene"_missense_mutation_project"/repository/software;
       echo
       echo
       echo "Do you wish install prepared FKRP residue positions and types to create FKRP missense mutation PDB structures? (y/n)"
       echo
       read yn3
       echo
       case $yn3 in
       # if answer is yes (y or Y)   
           [yY] ) echo "Moving lists of FKRP residue positions and alternate types to resources directory";
               # MOVE RESIDUE POSITION AND ALTERNATE TYPE LISTS TO RESOURCES DIRECTORY
               cp *pos.txt *ty.txt $location/$gene"_missense_mutation_project"/resources;;
        # if answer is no (n or N) 
           [nN] ) echo " Custom residue positions and alternate types files can be created for producing mutant $gene PDB structure production when data_manipulation.Rmd is run on a local system in RStudio";
               echo
               echo
               echo "more information can be found in README.md";;
        # if anything else is typed in
           * ) echo;
               echo "please retry the setup, exiting...";
               # delete pdb to prevent copy buildup
               rm $location/$gene"_missense_mutation_project"/resources/*.pdb;
               echo
               exit 1;;
        esac
       # DOWNLOAD MODELLER
       echo "Downloading Modeller package to $location/$gene"_missense_mutation_project"/repository/software/modeller directory";
       wget -P $location/$gene"_missense_mutation_project"/repository/software/modeller https://salilab.org/modeller/10.4/modeller-10.4.tar.gz;
       # unzip and extract modeller-10.4.tar.gz
       tar -zxf $location/$gene"_missense_mutation_project"/repository/software/modeller/modeller-10.4.tar.gz -C $location/$gene"_missense_mutation_project"/repository/software/modeller
       # remove tarball to save space
       rm $location/$gene"_missense_mutation_project"/repository/software/modeller/modeller-10.4.tar.gz
       echo
       echo "Installation of Modeller will commence shortly"
       echo
       echo
       read -p "Please read carefully the following infomation:"
       echo
       echo
       echo "When prompted enter the directory path:";
       echo "$location/$gene"_missense_mutation_project"/repository/software/modeller "; 
       echo
       echo
       echo "The installation key is MODELIRANJE"
       echo
       echo
       read -p "This message will dissapear after 10 seconds" -t 10
       echo
       echo
       echo
       # enter location of installation script and begin installation
       cd $location/$gene"_missense_mutation_project"/repository/software/modeller/modeller-10.4
       bash Install
       echo;;

# option 1: LOCAL
	[1] ) echo "Setting up local system directory structure...";
       mkdir -p $location/$gene"_missense_mutation_project"/{resources,bin,tmp,output/{data_subset,REVEL_scores,mutated_pdb_files/{benign,pathogenic},structure_energies/{wild_type,benign,pathogenic}},repository/software};
       echo
       echo "Transferring scripts to $location/$gene"_missense_mutation_project"/bin";
       # TRANSFER COPY OF SCRIPTS TO BIN DIRECTORY
       cp data_manipulation.Rmd *mutations.sh *visualisation.sh foldx_stability.sh foldx_repair.sh *.py $location/$gene"_missense_mutation_project"/bin;
       echo
       echo "Transferring FoldX to $location/$gene"_missense_mutation_project"/repository/software";
       # TRANSFER FOLDX TO SOFTWARE DIRECTORY
       cp -r foldx5 $location/$gene"_missense_mutation_project"/repository/software;
       echo
       echo "Do you wish install the default data and REVEL scores used for producing FKRP missense mutation PDB structures? (y/n)"
       echo
       read yn3
       echo
       case $yn3 in
       # if answer is yes (y or Y) 
           [yY] ) echo "Moving FKRP input data to tmp and resources directory";
               # TRANSFER COPY OF DATASETS TO RESOURCES DIRECTORY
               cp -r clinvar_result.txt gnomAD_v2.1.1_ENSG00000181027_2023_06_09_14_03_06.csv revel-v1.3_segments_chrom_19 $location/$gene"_missense_mutation_project"/resources;
               cp *pos.txt *ty.txt $location/$gene"_missense_mutation_project"/tmp
               echo
               echo
               echo;;
        # if answer is no (n or N)
           [nN] ) echo; 
               echo "What chromosome number is $gene located at?"
               echo
               echo "For single digit chromosome numbers enter 0 before the number eg. 01"
               echo
               read chr
               echo
               echo "Downloading REVEL scores for regions within Chromosome $chr to resources directory"
               echo
               # download REVEL scores into resources directory for chromosome number entered
               curl -JLO https://zenodo.org/record/7072866/files/revel-v1.3_segments_chrom_${chr}.zip?download=1 > $location/$gene"_missense_mutation_project"/resources/revel-v1.3_segments_chrom_${chr}.zip
               echo
               echo
               echo
               echo "Please transfer other obtained ClinVar, gnomAD data to the resources directory once setup is complete";;
        # if anything else is typed
           * ) echo;
               # delete pdb to prevent copy buildup
               rm $location/$gene"_missense_mutation_project"/resources/*.pdb;
               echo
               exit 1;;      
       esac
esac
echo
echo "Project setup is now complete"
echo
echo
# return to working directory
cd $working