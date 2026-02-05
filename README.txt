HSYMDOCK suite 1.1 -- Homo-multimer protein-protein docking with Cn and Dn symmetry

Required Linux system: CentOS 6.0 or later

======================================================================

New features in v1.1:

1. Some command options are added for chdock.
 -spacing [1.2]         Grid spacing for translation
 -angle   [15]          Angle interval for rotation
 -cont    [cont.txt]    Receptor-ligand contacts
 -itscore [true/false]  Default is true
 -out     [CHdock.out]  Output filename

2. Allowing input of residue-residue contacts by adding "-cont" option.
The contact file should look like this

23:A 26:A 0.9
12:A 68:A 0.8
...

where each line stands for the first residue, second residue, 
and their contact probability. Only the contacts with probability>0.5
are considered during the docking.

3. Add a "modcheck" program, which can be used to remove the disorder 
region in the terminal regions of the monomer.
    
      modcheck monomer.pdb > monomer_check.pdb

=======================================================================


*****************************
USAGE EXAMPLES: 
*****************************

First, set the enviroment PATH to include the directory of "hsymdock_v1.1".

Users may remove the hydrogens, alternative atoms, and waters from the pdb 
file before docking by running the following command.

	clean_pdb monomer.pdb monomer_clean.pdb

Users may also  want to remove the disorder parts at the beginning and ending
of the monomer before docking by running the following command.

	modcheck monomer.pdb > monomer_check.pdb


#############################################
#####       Cn symmetric docking     ########
#############################################
To dock a C2 symmetric protein, run the command like the following

	chdock  monomer.pdb monomer.pdb -symmetry 2 -angle 10 -out CHDock.out 

To dock a C3 symmetric protein, run the command like the following

	chdock  monomer.pdb monomer.pdb -symmetry 3 -angle 10 -out CHDock.out 

Then, create the symmetric complexes from "CHDock.out"

	compcn CHDock.out models.pdb -nmax 100 -rcut 5 -complex


#############################################
#####       Dn symmetric docking     ########
#############################################

To dock a D2 symmetric protein, run the command like the following

	dhdock.sh  monomer.pdb -dn 2 -angle 10 -out dhdock.out 

To dock a D3 symmetric protein, run the command like the following

	dhdock.sh  monomer.pdb -dn 3 -angle 10 -out dhdock.out 

Then, create the symmetric complexes from "dhock.out"

	compdn dhdock.out models.pdb -nmax 100 -rcut 5 -complex

	dncluster models.pdb models_clu.pdb  -rcut 5


References:

1. Yan Y, Tao H, Huang SY. HSYMDOCK: a docking web server for predicting the
structure of protein homo-oligomers with Cn or Dn symmetry. Nucleic Acids Res.
2018 Jul 2;46(W1):W423-W431. doi: 10.1093/nar/gky398. 

2. Yan Y, Huang S-Y. CHDOCK: a hierarchical docking approach for modeling Cn 
symmetric homo-oligomeric complexes. Biophysics Reports, 5: 65-72, 2019.


For questions, please contact us at huangsy@hust.edu.cn.


Sheng-You Huang, PhD
---------------------
The Huang Lab
Biophysics and Molecular Modeling Group
School of Physics
Huazhong University of Science and Technology
Email: huangsy@hust.edu.cn
Web: http://huanglab.phys.hust.edu.cn/

