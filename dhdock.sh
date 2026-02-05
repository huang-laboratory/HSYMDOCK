#!/bin/sh
#
# DHdock.sh - A protein-protein docking protocol for Dn symmtry
# Copyright (C) 2016-2020  Huazhong University of Science and Technology
# All Rights Reserved.
#
# written by Sheng-You Huang.
#
#References:
#
#
EXE_PATH=`dirname $(which $0)`

nargs=$#
if [ $nargs -lt 1 ]; then
   echo ''
   echo ' HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH'
   echo ' S                                                     T'
   echo ' S  DDDDD    H      H  DDDDD                           T'
   echo ' S  D    D   H      H  D    D    oOOo    cCCc   K   K  T'
   echo ' S  D     D  H      H  D     D  O    O  C    C  K  K   T'
   echo ' S  D     D  HHHHHHHH  D     D  O    O  C       KkK    T'
   echo ' S  D     D  H      H  D     D  O    O  C       K K    T'
   echo ' S  D    D   H      H  D    D   O    O  C    C  K  K   T'
   echo ' S  DDDDD    H      H  DDDDD     OOOO    CCCC   K   K  T'
   echo ' S                                                     T'
   echo ' UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU'
   echo " Protein-protein docking with Dn symmetry."
   echo ' VERSION 1.0, (C) 2016-2020 Huazhong University of Science and Technology'
   echo ''
   echo -e "\033[1m USAGE:\033[0m `basename $0`  filename.pdb  [options]"
   echo ''
   echo -e "\033[1m Options:\033[0m"
   echo "      -dn  	[2]    		Number of dihedral symmetries."
   echo "      -ncmer 	[100]  		Number of complexes for Cn symmetry."
   echo "      -crmsd	[2.0]		RMSD used to cluster Cn complexes."
   echo "      -keep	[2000]		Number of complexes for Dn complexes."
   echo "      -out	[dhdock.out]   	Output filename."
   echo ""
   echo -e "\033[1m Examples:\033[0m"
   echo "       `basename $0` prot.pdb -dn 2 -out dhdock4.out"
   echo ""
   exit 1
fi

pdbfile=$1
dn=2
ncmer=100
nkeep=2000
fout=dhdock.out

angle=15
spacing=1.2
rmsdclu=2.0

while [ $# -ge 2 ]; do

        case $2 in
        -dn)
                shift
                dn=$2;;
        -ncmer)
                shift
                ncmer=$2;;
        -keep)
                shift
                nkeep=$2;;
        -angle)
                shift
                angle=$2;;
        -spacing)
                shift
                spacing=$2;;
        -crmsd)
                shift
                rmsdclu=$2;;
        -out)
                shift
                fout=$2;;
        *)
                echo ""
                echo " ERROR: wrong command argument \"$2\" !!"
                echo ""
                echo " Type \"dhdock.sh\" for usage details."
                echo ""
                exit 2;;
        esac

        shift
done

if [ `which chdock 2>/dev/null | wc -l` -eq 0 ]; then
        echo ""
        echo "ERROR: \"chdock\" does not exist!!"
        echo ""
        exit 2
fi

if [ `which createnmer 2>/dev/null | wc -l` -eq 0 ]; then
        echo ""
        echo "ERROR: \"createnmer\" does not exist!!"
        echo ""
        exit 2
fi

if [ `which dhdock 2>/dev/null | wc -l` -eq 0 ]; then
        echo ""
        echo "ERROR: \"dhdock\" does not exist!!"
        echo ""
        exit 2
fi

if [ ! -f $pdbfile ]; then
        echo ""
        echo "ERROR: file $pdbfile does not exist!!"
        echo ""
        exit 3
fi

echo ""
echo "Protein-protein docking with D$dn symmetry"
echo ""
echo "Start C$dn protein-protein docking.............."

chdock $pdbfile $pdbfile -symmetry $dn

nmax=`createnmer CHdock.out -nmax $ncmer -rcut $rmsdclu | tail -1 | awk '{print $1+1}'`	

id=$$
>tempdock$id.out

for i in `seq 1 $nmax`; do
	echo "Docking the No.$i C$dn complex......"	
	dhdock complex_$i.pdb complex_$i.pdb
	tail -n +7 DHdock.out >> tempdock$id.out
done
        
head -6 CHdock.out > $fout
sort -n -k 10 tempdock$id.out | head -$nkeep >> $fout

rm complex_*.pdb tempdock$id.out

if [ -f $fout ]; then
        echo ''
        echo "Docking is finished. Please check \"$fout\" for results."
        echo 'You can use "dcompp" to construct NMR-style binding modes'
        echo ''
fi

