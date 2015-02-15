# SNSBuildSys
SnowShovel build system

Build system builds shared object libraries for C/C++/Fortran files in each subdirectory.

Each subdirectory has a [subdir name].mk file that is used to control various build options specific to that package. See build/template/module.mk.example for an explanation of each option.

The subdirectory should be added to the "Modules" file, in the appropriate location (with respect to its dependence on external libraries).

Users can edit the main "configure" file to set a few options. Most importantly is the "TOPVAR" variable, which must reference an existing environment variable that points to the location of the build system. For example, if TOPVAR=SNS and the build system is located in $HOME/sns, then the user should have an environment variable $SNS = $HOME/sns.

New features implement since the PHOBOS build system:

 * Ability to set "use_root=0" in configure and still build packages that don't depend on ROOT. However, the build system is not (yet) set up to run on a computer that does not have ROOT installed at all.

 * Ability to specify (in configure) the copying or soft-linking of headers into the include directory.

 * Works with both ROOT v5 and v6. Automatically compile with rootcint for ROOT v5 and rootcling for ROOT v6.

 * Properly build library loading order into rootmap (in ROOT v5, for example) for subdirectories that depend on other subdirectories.

 * Ability to easily change compilers (e.g. use clang instead of gcc) by editting the main configure file.

 * Makes a special "prog" directory available that does not build a shared object library, but instead compiles each .cxx file into a binary .exe file. Each .cxx file needs its own .mk file, which is generated using the "add-prog.sh" script. For example, one would edit the "prog/myprogram.cxx" file first, and then from the TOPVAR directory, run "./add-prog.sh prog/myprogram.cxx" to generate the prog/myprogram.mk file. The .mk file is used to specify linking options.


To get started (after checkout):

 * Edit the "configure" file and change "TOPVAR" to be the environment variable of your choice.

 * Make sure $({$TOPVAR}) is a valid environment variable whose value is the location of this build system. For example, if TOPVAR=SNS and the build system is located in $HOME/sns, then the user should have an environment variable $SNS = $HOME/sns.

 * Add a new package by running "build/add_package [package name]". Package names are expected to not contain white space. A directory will be generated with the package name.

 * Edit the Modules file and add the line "MODULES += [package name]" where appropriate. For example, if this package needs to link against ROOT, it should be within the "ifneq ($(ROOTSYS_CONF),)" block.

 * In the [package name] directory, add the source code files. Files to be compiled must have the following extensions: .cxx for C++ files, .c for C files and .f for Fortran files. Header files are not automatically compiled to object files (so don't forget a .cxx file for your templated classes!), but are expected to have the following extensions: .h, .hxx and .inc.

 * Edit the [package name]/[package name].mk file to specify the various make options as required. See build/template/module.mk.example for an explanation of each option. Common options are [package name]DH (lists the header files needed by rootcint/rootcling), [package name]LIBEXTRA (lists external shared libraries to link against) and [package name]LIBDEP (lists other packages in the build system upon which this package depends, so that the other packages should be built first and their libraries auto-loaded first).

 * From the TOPVAR directory, run "./configure". This will generate dependency files.

 * From the TOPVAR directory, run make. If all [package name]LIBDEP variables have been properly set, make will function well in parallel with the "-j" option.

