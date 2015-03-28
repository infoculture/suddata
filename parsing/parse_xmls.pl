#!/usr/bin/perl
########
#
# by Dmitriy Skougarevskiy @ IHEID and IRL EUSPb
#
# Use as:
# perl parse_xmls.pl "path/to/documentid.xml"
# perl parse_xmls.pl "examples/sou/101-j-garnizonnyj-voennyj-sud-g-orenburg-orenburgskaya-oblast-1/2013/427203688.xml"
#
# This script will take an XML file with a court act and
# (i)  save documentid.html with body text in the same folder
# (ii) export CSV-formatted metadata of this court act to STDOUT
#
# Use case:
#
# cd "suddata"; echo -e "\"documentid\",\"region\",\"court\",\"judge\",\"vidpr\",\"case_number\",\"etapd\",\"category\",\"result\",\"date\",\"url\",\"vid_dokumenta\"" > "verdicts_metadata.csv"; find examples -type f -name "*.xml" -print0 | xargs -0 -n 1 -P 4 sh -c 'perl parse_xmls.pl "$1" >> verdicts_metadata.csv' sh;
#
# i.e.
# (i)	create verdicts_metadata.csv with a header to store all metadata
# (ii)	list all .xmls in examples and pipe it to xargs (NB: I suspect it might
#       be a bottleneck i.t.o memory when we pipe 33m files)
# (iii) initiate 4 parallel processes of ./parse_xmls.pl "documentid.xml"
#       and append the results to verdicts_metadata.csv (and save .htmls alongside .xmls)
#
# Since it is an embarrasingly parallel job, we can create hundreds of workers to
# achieve speedup on a full-scale data set.
# Execution time for all /examples xmls is ~4 seconds on my Intel Core i5 with SSD I/O
#
########
use strict;
use File::Basename;

# Get xml file name as ARGV
my $xmldocumentlocation=$ARGV[0];

# Document path (where to save htmls)
# Here we save alongside the source files
# Modify accordinly to cater to your needs
# ID is document name
my($documentid,$documentpath,$extension) = fileparse($xmldocumentlocation,'\..*');
#$xmldocumentlocation =~ m#^(.*?)([^/]*)$#;
#my ($documentpath,$xmlfilename) = ($1,$2);

#print $documentpath;
# Read document contents
my $xmldocument;
open(my $fh, '<', $xmldocumentlocation) or die $!;
{
	local $/;
	$xmldocument = <$fh>;
}
close($fh);

# Extract the body text and save it to .html
my ($bodyhtml) = $xmldocument =~ /<body>(.*)<\/body>/gs;

open(OUTPUT, '>', $documentpath . $documentid . ".html") or die $!;
{ print OUTPUT $bodyhtml; }
close(OUTPUT);

# Time is of the essence here, so use very simple regexps
# which are heavily optimised in Perl
my ($region) = $xmldocument =~ m/<region>(.*)<\/region>/gs;
my ($court) = $xmldocument =~ m/<court>(.*)<\/court>/gs;
my ($judge) = $xmldocument =~ m/<judge>(.*)<\/judge>/gs;
my ($vidpr) = $xmldocument =~ m/<vidpr>(.*)<\/vidpr>/gs;
my ($case_number) = $xmldocument =~ m/<case_number>(.*)<\/case_number>/gs;
my ($etapd) = $xmldocument =~ m/<etapd>(.*)<\/etapd>/gs;
my ($category) = $xmldocument =~ m/<category>(.*)<\/category>/gs;
my ($result) = $xmldocument =~ m/<result>(.*)<\/result>/gs;
my ($date) = $xmldocument =~ m/<date>(.*)<\/date>/gs;
my ($url) = $xmldocument =~ m/<url>(.*)<\/url>/gs;
my ($vid_dokumenta) = $xmldocument =~ m/<vid_dokumenta>(.*)<\/vid_dokumenta>/gs;

# Write a CSV line to STDOUT
print "\"$documentid\",\"$region\",\"$court\",\"$judge\",\"$vidpr\",\"$case_number\",\"$etapd\",\"$category\",\"$result\",\"$date\",\"$url\",\"$vid_dokumenta\"\n";
