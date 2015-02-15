#!/bin/sh

#
# $Id$
#

incs=`sed -n "s/ *include * '\([^']*\)'.*/\1/p" < $1 | sed "s/..*/   include\/& \\\\\\\\/" | sort -u `
incs2=`sed -n "s/ *#include * \"\([^']*\)\".*/\1/p" < $1 | sed "s/..*/   include\/& \\\\\\\\/" | sort -u `

base=`echo $1 | sed 's/\.f//'`

echo "$base.o $base.d: $base.f \\"
if test -n "$incs"; then echo "$incs"; fi
if test -n "$incs2"; then echo "$incs2"; fi
echo
