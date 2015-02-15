#!/bin/sh
#
# generate a g++ option list that will include all libraries of SNS
# except those specified in the $exclude list below

snslibdir="$SNS/lib"

snslibs="-L$snslibdir "

# space-separated list of libraries to exclude
exclude="libprog.so"

for i in `ls $snslibdir/lib*so`; do
   
   for j in $exclude ; do
      if [ $j = $i ]; then
         continue 2
      fi
   done

   i=${i#$snslibdir/lib}
   i=${i%\.so}
   snslibs="$snslibs -l$i"
done

echo $snslibs
