#!/usr/bin/env perl
#
# $Id$
#

# Little script to generate C/C++ header
# files to be used together with cfortran.h

$infile = "@ARGV[0]";
$outfile = ">$infile";
$outfile =~ s/inc/h/;
$timenow = localtime time;

#read file to parse
open infile or die "Can't open file $infile!\n";
@text = <infile>;
close infile;

$len = @text;
$ind = 0; #index in array
%params = ();
while ($ind < $len) {
    $actline = @text[$ind];
    if ($actline =~ m/^      ( *)COMMON *\/(.*)\/(.*)/i) {
        $cbname=$2;
	$commonline = $3;
	chomp $commonline;
	$ind++; #search next line for extended cb def
	while (	@text[$ind] =~ m/^     \S/) {
	    $nxtline = @text[$ind];
	    $nxtline =~ s/^     \S//;
	    chomp $nxtline;
	    $commonline = $commonline . $nxtline; 
	    $ind++;
	} 
        last;
    } elsif ($actline =~ m/^\#include/i) {
	push @foundincludes, $actline;
    } elsif ($actline =~ m/^       *PARAMETER *\((.*)=(.*)\)/i) {
	$params{$1} = $2;
    }
    $ind++;
}

## print found parameters
#foreach $key ( keys %params){
#print $key." = ".$params{$key}."\n"
#}


$cbnamedef = $cbname;
$cbnameblock = $cbname . "_t";
$cblname = lc $cbname;

#open file to write
open outfile or die ("Could not open output file $outfile!\n");
print outfile "//\n// \$", "Id:\$\n//\n";
print outfile "// Created by gencbint.pl from $infile at $timenow\n//\n\n";
print outfile "#ifndef CMSROOT_$cblname\n#define CMSROOT_$cblname\n\n";
print outfile "#ifndef __CFORTRAN_LOADED\n#include \"cfortran.h\"\n\#endif\n";
print outfile "#ifndef ROOT_Rtypes\n#include \"Rtypes.h\"\n\#endif\n";
print outfile "#ifndef CMSROOT_Rtypes\n#include \"CMSROOT_Rtypes.h\"\n\#endif\n";
print outfile @foundincludes;
print outfile "\ntypedef struct {\n";

$ind = 0; #index in array
while ($ind < $len) {
    $actline = @text[$ind];
    if ($actline =~ m/^(C|\*)(.*)/i) {
	$ind++;
        next;
    } elsif ($actline =~ m/^      ( *)COMMON *\/(.*)( *)/i) {
        last;
    } elsif ($actline =~ m/^      ( *)REAL  *(.*)( *)/i) {
	convertvariable($2, "Float_t");
    } elsif ($actline =~ m/^      ( *)DOUBLE PRECISION  *(.*)( *)/i) {
	convertvariable($2, "Double_t");
    } elsif ($actline =~ m/^      ( *)DOUBLE COMPLEX  *(.*)( *)/i) {
	convertvariable($2, "DoubleComplex_t");
    } elsif ($actline =~ m/^      ( *)COMPLEX  *(.*)( *)/i) {
	convertvariable($2, "FloatComplex_t");
    } elsif ($actline =~ m/^      ( *)INTEGER  *(.*)( *)/i) {
	if ( !exists $params{$2} ) {
	    convertvariable($2, "Int_t");
	}
    } elsif ($actline =~ m/^      ( *)LOGICAL  *(.*)( *)/i) {
	convertvariable($2, "Int_t");
    } elsif ($actline =~ m/^      ( *)CHARACTER  *(.*)\*(\d+)/i) {
	convertvariable($2, "Char_t", $3);
    } elsif ($actline =~ m/^      ( *)PARAMETER  *(.*)( *)/i) {
        ; #       *** ignore this since it is implicitly taken care off ***
    } elsif ($actline =~ m/^      ( *)(.*)( *)/i) {
        print "Unknown line: ", $actline;
    }
    $ind++;
}

print outfile "} ${cbnameblock};\n\n";
print outfile "#define $cbnamedef COMMON_BLOCK(${cbname}, ${cblname})\n";
print outfile "COMMON_BLOCK_DEF(${cbnameblock}, ${cbnamedef});\n\n";
print outfile "#endif\n";
close outfile;


# 
sub convertvariable($,$,$)
{
    my $string = shift;
    my $type = shift;
    my $charlength = shift;
    my $cl=$commonline;
    my $strarray="";

    if ($cl =~ m/$string/) {
	if ($cl =~ m/$string\(([^)]+)\)/) {
	    my $arrindex = $1;
	    @indices = split (",",$arrindex);
	    my $len = @indices; 
	    for(my $i = $len-1 ; $i >= 0 ; $i--) {
		my $key = @indices[$i];
		my $val = $key;
		if ( $val =~ m/([A-Z]|[a-z])/ ) {
		    $val = $params{$key};
		} elsif ( $val =~ m/(.+):(.+)/) {
		    my $valorig = $val;
		    $val = $2 - $1 + 1;
		    print "Converted index from $valorig to $val in $infile\n";
		}
		$strarray = $strarray . "[" . $val . "]";
	    }
	} 
    }
if ($charlength > 0) {$strarray = $strarray . "[" . $charlength . "]";}
    $string = lc $string;
    print outfile "      $type $string$strarray;\n";
    return;
}


# Remove whitespace from the start and end of the string
sub trimwhitespace($)
{
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}
