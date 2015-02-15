#
# $Id$
#
# Makefile.boot -- Bootstrap makefile to get module make files up to date
#
#

.PHONY: all

include config.mk

ifeq ($(strip $(MOD)),)
MODULES :=
include Modules
else
MODULES := $(MOD)
endif

MODULEMKS := $(patsubst %,%/Module.mk,$(MODULES))

all: $(MODULEMKS)
	@true

%/Module.mk: build/template/Module.mk.in
	@echo "Creating $@"
	@sed "s/AAAA/$*/g" < build/template/Module.mk.in > $@


#
# Local Variables:
# mode:Makefile
# End:
#
# vim: set filetype=Makefile 
#
