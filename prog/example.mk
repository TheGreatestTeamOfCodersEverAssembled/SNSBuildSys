###
# File generated by "add-prog.sh prog/example.cxx".
#
# $Id$
###

# List here objects that should be explicitly built into the executable.
# NOTE: DO NOT include "example.o" in this list.
exampleOBJS := \
	

# List here library paths (-L) and libraries (-l) that the executable
# should be linked with.
exampleLINK := \
	`root-config --libs` \
	
# By default, add-prog.sh includes the ROOT Core library.
# Remove this if necessary.

# If all root libraries are needed, use:
#prog/exampleLINK := \
#	`root-config --libs`

# Similarly, for all SNS libraries, use:
#prog/exampleLINK := \
#	`build/sns-libs.sh`

################################################################################
# DO NOT EDIT BELOW
################################################################################
bin/example.$(EXEEXT):: prog/example.o $(exampleOBJS) prog/example.mk
	@$(MAKEEXE) $(MAKELIB) $(PLATFORM) $(LD) "$(LDFLAGS)" \
	"$(EXEFLAGS)" $@ "$<" \
	"$(exampleOBJS) $(exampleLINK)"

