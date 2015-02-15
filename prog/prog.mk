#
# $Id$
#

# special make file for automatically building executables
# there should be no header needed files here

################################################################################
#
# Don't edit this file unless you know how it works.
#
################################################################################

.PHONY: prog-exec prog-clean-execs

# turn off .so creation
progNOLIB  := true

# make the list of execs (use all .cxx files except G__)
progEXE    := $(progS:.cxx=.$(EXEEXT))
progEXEOUT := $(progEXE:prog/%=bin/%)

# progO isn't defined until after this file is included, so...
progEO     := $(progS:.cxx=.o)

# if we need any flags to be common to all programs
pqinc=
ifneq ($(PQXXINC),)
	pqinc=-I$(PQXXINC)
endif
progCXXFLAGSEXTRA := \
	$(pqinc)

# extra build target for this module
progEXTRAS := \
	prog-exec

# depend on all libs so we build last
progLIBDEP := \
	$(MODULES) \

# Include all the various .mk files for the .cxx's in prog.
# This defines all the xxxxOBJS and xxxxLINK variables
# and the targets for the $(progEXEOUT) list
include $(patsubst %.cxx,%.mk,$(progS))

# add the list of execs to the dependencies of this build target
prog-exec: $(progEO) $(progEXEOUT) prog/Module.mk prog/prog.mk

# append the cleaner
progLOCALCLEAN :=\
	prog-clean-execs

prog-clean-execs:
	rm -f $(progEXEOUT)

##
#  The target below would cause all exe's to be remade whenever any
#  one .o that links to any one exe is changed.
##

#progALLOBJS := $(foreach file,$(progS),\
#	$($(subst prog/,,$(subst .cxx,,$(file)))OBJS))

# link an exe
#bin/%.$(EXEEXT):: prog/%.o $(progALLOBJS)
#	@$(MAKEEXE) $(MAKELIB) $(PLATFORM) $(LD) "$(LDFLAGS)" \
#	"$(EXEFLAGS)" $@ "$<" \
#	"$($(*)OBJS) $($(*)LINK)"

