#
# $Id$
#
# This build system relies on features of GNU make
#
# see: http://www.gnu.org/software/make/manual/html_mono/make.html
#

# Keep handy macros that tell what ROOT version is available
rootversion_major := $(shell $(ROOTSYS)/bin/root-config --version | sed -n 's/\([0-9]*\)\..*\/.*/\1/p')
rootversion_minor := $(shell $(ROOTSYS)/bin/root-config --version | sed -n 's/.*\.\([0-9]*\)\/.*/\1/p')
rootversion_patch := $(shell $(ROOTSYS)/bin/root-config --version | sed -n 's/.*\..*\/\([0-9]*\)/\1/p')

IsRootSix := $(shell expr $(rootversion_major) \= 6)

ifeq ($(findstring $(MAKECMDGOALS:%-clean=-clean),clean distclean -clean),)

# Give a quick and clear error message
ifeq ($(wildcard config.mk),)
dummy := $(error No config.mk found, please run './configure')
endif

current_version := $(shell sed -n 's/.*BuildSystemVersion: *\([0-9]*\) */\1/p' build/Version)
old_version := $(shell sed -n 's/.*BuildSystemVersion: *\([0-9]*\) */\1/p' config.mk)

ifneq ($(old_version),$(current_version))
dummy := $(error config.mk out of date, please run './configure')
endif

include config.mk

# Create ROOTINC and ROOTLIB for backward compatibility with old config.mk
# this can be removed eventually
ifeq ($(ROOTINC),)
ROOTINC := $(ROOTSYS)/include
endif
ifeq ($(ROOTLIB),)
ROOTLIB := $(ROOTSYS)/lib
endif

else

-include config.mk

endif

# Bring the build system upto date
result := $(shell make -f build/Makefile.boot MOD="$(MOD)" 1>&2 && echo MAKEFILES_OK)
ifeq ($(findstring $(result),MAKEFILES_OK),)
dummy := $(error Error making Module.mk files.)
endif

ifeq ($(strip $(MOD)),)
MODULES :=
include Modules
else
MODULES := $(MOD)
endif


#
# Variables will go to config file
#

OPTFLAGS = -O2 
DBGFLAGS = -g
ifeq ($(IsRootSix),1)
WRNFLAGS = -Wall -Werror -Wno-error=deprecated-declarations -Wno-long-long
else
WRNFLAGS = -Wall -Werror -Wno-long-long
endif

OPT      = $(DBGFLAGS) $(OPTFLAGS) 
F77OPT   = $(DBGFLAGS) -O0
NOOPT    = $(DBGFLAGS)
F77NOOPT = $(DBGFLAGS)

ifeq ($(IsRootSix),1)
ROOTCINT = $(ROOTSYS)/bin/rootcling
else
ROOTCINT = $(ROOTSYS)/bin/rootcint
endif
MAKEDEP  = build/depend.sh
F77DEP   = build/f77dep.sh
MAKELIB  = build/makelib.sh $(MKLIBOPTIONS)
MAKEPAR  = TOPVAR=$(TOPVAR) build/makepar.sh
ifeq ($(IsRootSix),1)
MAKEMAP  = $(ROOTSYS)/bin/rootcling
else
MAKEMAP  = $(ROOTSYS)/bin/rlibmap
endif
ROOTMAPEXT = rootmap

# ROOT changed the naming of rootmap at version ~5.18
ifeq ($(shell expr $(rootversion_major) \= 5 \& $(rootversion_minor) \< 18),1)
MAPFILE  = $(LIBDIR)/$(ROOTMAPEXT)
else
MAPFILE  = $(LIBDIR)/$(TOPVAR).$(ROOTMAPEXT)
endif

MAKEEXE  = build/makeexe.sh

ifneq ($(CERNLIB),)
CERNLIBS := $(shell cernlib geant pawlib graflib packlib mathlib)
endif

#
# Targets that do not correspond to a file
#
.PHONY: all libs pars extras map test htmldoc htmldoc-clean clean distclean printmods


all: libs pars extras map

#
# Include module makefiles and build file lists
#

ALLHDRS :=
ALLLIBS :=
ALLPARS :=

# Include modules.mk if modules are defined
ifneq ($(MODULES),)

include $(patsubst %,%/Module.mk,$(MODULES))

#
# Include dependency files
# use -include to not warn in case the dep files are missing
#
ifeq ($(findstring $(MAKECMDGOALS:%-clean=-clean),clean distclean -clean),)
include $(INCLUDEFILES)
include build/dummy.d
endif
else
dummy := $(warning No Modules found in Modules.mk.)
endif

printmods:
	@echo ""
	@echo ""
	@echo ">>> Will make modules: $(MODULES)"
	@echo ""

htmldoc: libs
	rm -rf htmldoc/*
	root -b -q build/make_doc.C+\(\"$$$(TOPVAR)\"\)

htmldoc-clean: 
	rm -rf htmldoc/*

ifeq ($(IsRootSix),1)
map:
else
map: $(MAPFILE)
endif

ifneq ($(strip $(ALLMAPS)),)
$(MAPFILE): $(ALLMAPS)
	cat $(ALLMAPS) | sort -u > $(MAPFILE)
else
$(MAPFILE): $(ALLMAPS)
	touch $(MAPFILE)
endif


#
# Make sure the libs and exec's are cleaned, in case some module is
# removed from the build before 'make clean' is called.
# 
ifeq ($(IsRootSix),1)
clean::
else
clean::
	rm -f $(MAPFILE)
endif

distclean: clean
	rm -f include/*.h include/*.inc
	rm -rf htmldoc/*
	rm -f config.mk
	rm -f bin/*.$(EXEEXT)
	rm -f lib/*.$(SOEXT)
	find . -name Module.mk -exec rm -f {} \;

build/dummy.d: $(ALLHDRS)
	@(if [ ! -f $@ ] ; then \
	   touch $@; \
	fi)

# Special rule for dictionaries
G__%.o: G__%.cxx
	$(CXX) $(NOOPT) -I. $(CXXFLAGS) -o $@ -c $<

%.o: %.cxx
	$(CXX) $(OPT) $(CXXFLAGS) -o $@ -c $<

%.o: %.c
	$(CC) $(OPT) $(CFLAGS) -o $@ -c $<

%.o: %.f
	$(F77) $(F77OPT) $(F77FLAGS) -o $@ -c $<


#
# Local Variables:
# mode:Makefile
# End:
#
# vim: set filetype=Makefile 
#
