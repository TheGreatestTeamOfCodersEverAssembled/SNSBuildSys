#
# config.mk
#
# Created at: Mon Mar 26 19:14:34 PDT 2012  
#         by: $Id$
#

TOPVAR=

# Package variables
_CONF=


#
# Main package
#
LIBDIR=/lib

# Compiler and Linker configuration
include build/config/linux.i386.mk


#
# Validate external package configuration
#
ifneq ($(_CONF),)
ifneq ($(),$(_CONF))
dummy:=$(error $$ has changed, please run './configure' or set correctly)
endif
endif

