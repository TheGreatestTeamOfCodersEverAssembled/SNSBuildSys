#!/bin/sh

#
# $Id$
#

if [ $# -lt 4 ]; then
   echo "usage: $0 parfile parlib parincludes parextra [parinit]" >&2
   exit 1
fi

parfile=$1
parlib=$2
parincludes=$3
parextra=$4
parinit=$5

pardir=`echo $parfile | sed 's/\.par//'`
parbase=`basename $parfile .par`


mkdir $pardir || exit 1
mkdir $pardir/PROOF-INF || exit 1

cp $parlib $pardir

if expr "$parincludes" : ".*[a-zA-Z0-9_].*" > /dev/null ; then
   cp $parincludes $pardir
fi

setupfile=$pardir/PROOF-INF/SETUP.C

echo "{" > $setupfile

for i in $parextra
do
   cp $i $pardir
   idir=`dirname $i`
   ibase=`basename $i`
   echo "gSystem->Exec(\"mkdir -p \$PROOF_SANDBOX/$idir\");" >> $setupfile
   echo "gSystem->Exec(\"ln -s \`pwd\`/$ibase \$PROOF_SANDBOX/$idir\");" >> $setupfile
done

echo "  gSystem->Setenv(\"$TOPVAR\",gSystem->Getenv(\"PROOF_SANDBOX\"));" >> $setupfile
if [ -n "$parinit" -a -e "$parinit" ]; then
    cp $parinit $pardir/PROOF-INF
    echo "  gROOT->Macro(\"PROOF-INF/`basename $parinit`\");" >> $setupfile
else
    echo "  gSystem->Load(\"`basename $parlib`\");" >> $setupfile
fi
echo "}" >> $setupfile

tar czf $parfile -C par $parbase

rm -fr $pardir

exit 0
