#!/bin/sh
#
# $Id$
#
# generate an executable
#
# use the .L file to make the library linking list if available
# otherwise use the specified default
#
# calls makelib.sh
#
# assumes that the OBJS is only the one object: [name].o
# any other objects that need to be linked can be put in [name].L

MAKELIB=$1
PLATFORM=$2
LD=$3
LDFLAGS=$4
EXEFLAGS=$5
EXE=$6
OBJS=$7
EXTRA=$8

$MAKELIB $PLATFORM $LD "$LDFLAGS" "$EXEFLAGS" " " "$EXE" "$OBJS $EXTRA"
