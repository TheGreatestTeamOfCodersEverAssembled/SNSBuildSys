#
# $Id$
#

PLATFORM = linux.x86_64

CPPFLAGS = $(PRODCPPFLAGS) -D_GNU_SOURCE -Iinclude -I$(ROOTINC)

ifeq ($(CCBASE),)
CCBASE   = gcc
endif
CC       = $(CCBASE)$(GCCVERSION)
CCFLAGS  = -fPIC $(WRNFLAGS) $(CPPFLAGS)

ifeq ($(CXXBASE),)
CXXBASE  = g++
endif
CXX      = $(CXXBASE)$(GCCVERSION)
ifeq ($(IsRootSix),1)
CXXFLAGS = -fPIC -std=c++11 $(WRNFLAGS) $(CPPFLAGS)
else
CXXFLAGS = -fPIC --ansi $(WRNFLAGS) $(CPPFLAGS)
endif

ifeq ($(F77BASE),)
F77BASE  = g77
endif
F77      = $(F77BASE)$(GCCVERSION)
F77FLAGS = -fPIC -fno-f2c -Wall $(CPPFLAGS)
F77LIBS  = -L$(shell dirname `$(F77) -print-file-name=libg2c.so`) -lg2c



LD       = $(CXXBASE)$(GCCVERSION)
LDFLAGS  = $(DBGFLAGS)
SOFLAGS  = -fPIC -shared -Wl,-soname,
SOEXT    = so

EXEFLAGS = -fPIE
EXEEXT   = exe

# gnu compiler version
GCC_MAJOR     := $(shell $(CXX) -dumpversion 2>&1 | cut -d'.' -f1)
GCC_MINOR     := $(shell $(CXX) -dumpversion 2>&1 | cut -d'.' -f2)
GCC_PATCH     := $(shell $(CXX) -dumpversion 2>&1 | cut -d'.' -f3)
GCC_VERS      := gcc-$(GCC_MAJOR).$(GCC_MINOR)
GCC_VERS_FULL := gcc-$(GCC_MAJOR).$(GCC_MINOR).$(GCC_PATCH)
