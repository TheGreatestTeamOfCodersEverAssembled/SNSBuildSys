#
# $Id$
#

PLATFORM = macosx

# OS version
MACOSX_MAJOR := $(shell sw_vers -productVersion | cut -d . -f 1)
MACOSX_MINOR := $(shell sw_vers -productVersion | cut -d . -f 2)
MACOSX_CPU   := $(shell uname -p)
FINK_DIR     := $(shell which fink 2>&1 | sed -ne "s/\/bin\/fink//p")
MACOSXTARGET := MACOSX_DEPLOYMENT_TARGET=$(MACOSX_MAJOR).$(MACOSX_MINOR)

CPPFLAGS = $(PRODCPPFLAGS) -D_GNU_SOURCE -Iinclude -I$(ROOTINC)

ifeq ($(CCBASE),)
CCBASE   = gcc
endif
CC       = $(CCBASE)$(GCCVERSION)
CCFLAGS  = $(WRNFLAGS) $(CPPFLAGS)


ifeq ($(CXXBASE),)
CXXBASE  = g++
endif
CXX      = $(CXXBASE)$(GCCVERSION)
CXXFLAGS = $(WRNFLAGS) $(CPPFLAGS)


ifeq ($(MACOSX_MINOR),5)
MACOSX_MINOR  = 4
endif
ifeq ($(MACOSX_MINOR),4)
SOFLAGS       = $(OPT) -dynamiclib -single_module \
                -undefined dynamic_lookup -install_name $(LIBDIR)/
CXXFLAGS     += -fvisibility-inlines-hidden
else
ifeq ($(MACOSX_MINOR),3)
SOFLAGS       = $(OPT) -dynamiclib -single_module \
                -undefined dynamic_lookup -install_name $(LIBDIR)/
CXXFLAGS     += -Wno-long-double
CFLAGS       += -Wno-long-double
else
SOFLAGS       = $(OPT) -dynamiclib -single_module \
                -undefined suppress -install_name $(LIBDIR)/
CXXFLAGS     += -Wno-long-double
CFLAGS       += -Wno-long-double
endif
endif

LD       = $(CXXBASE)$(GCCVERSION)
LDFLAGS  = $(DBGFLAGS) -bind_at_load
SOEXT         = dylib

EXEFLAGS = -Wl
EXEEXT   = exe

# Fortran:
ifeq ($(MACOSX_MINOR),4)
ifeq (g95,$(findstring g95,$(ROOTBUILD)))
F77           = g95
F77LIBS       = -L`$(F77) -print-search-dirs | awk '/^install:/{print $$2}'` \
                -lf95
else
F77           = gfortran
F77LIBS      := $(shell $(F77) -print-file-name=libgfortran.$(SOEXT))
F77LIBS      += $(shell $(F77) -print-file-name=libgfortranbegin.a)
endif
else
F77           = g77
F77LIBS       =
endif

# We add libg2c only in case of ppc because then we probably have cernlib
# compiled with g77. In case of Intel Mac it should be compiled with the
# same fortran we use.
ifeq ($(MACOSX_CPU),powerpc)
F77LIBS += -L$(FINK_DIR)/lib -lg2c
endif

