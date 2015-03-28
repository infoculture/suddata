#!/bin/bash
########
#
# by Dmitriy Skougarevskiy @ IHEID and IRL EUSPb
#
# Use as:
# ./parse_xmls.sh "path/to/documentid.xml"
# ./parse_xmls.sh "examples/sou/101-j-garnizonnyj-voennyj-sud-g-orenburg-orenburgskaya-oblast-1/2013/427203688.xml"
#
# This script will take an XML file with a court act and
# (i)  save documentid.html with body text in the same folder;
# (ii) export CSV-formatted metadata of this court act to STDOUT
#
# Use case:
#
# cd "suddata"; echo -e "\"documentid\",\"region\",\"court\",\"judge\",\"vidpr\",\"case_number\",\"etapd\",\"category\",\"result\",\"date\",\"url\",\"vid_dokumenta\"" > "verdicts_metadata.csv"; find examples -type f -name "*.xml" -print0 | xargs -0 -n 1 -P 4 sh -c './parse_xmls.sh "$1" >> verdicts_metadata.csv' sh;
#
# i.e.
# (i)	 create verdicts_metadata.csv with a header to store all metadata
# (ii)	list all .xmls in examples and pipe it to xargs (NB: I suspect it might
#			 be a bottleneck i.t.o memory when we pipe 33m files)
# (iii) initiate 4 parallel processes of ./parse_xmls.sh "documentid.xml"
#			 and append the results to verdicts_metadata.csv (and save .htmls alongside .xmls)
#
# Since it is an embarrasingly parallel job, we can create hundreds of workers to
# achieve speedup on a full-scale data set.
# Execution time for all /examples xmls is 1 minute on my Intel Core i5 with SSD I/O.
#
########
 
# Get xml file name as ARGV
xmldocumentlocation="$1"
# ID is document name
documentid=$(basename "$xmldocumentlocation")
documentid="${documentid%.*}"
# Document path (where to save htmls)
# Here we save alongside the source files
# Modify accordinly to cater to your needs
documentpath=$(dirname "${xmldocumentlocation}")

# Read document contents
xmldocument=$(<$xmldocumentlocation)

# Extract the body text and save it to .html
# Time is of the essence here, so no slow AWK or sed
bodyhtml=${xmldocument##*<body>}

# Write the body text to an html 
echo "$bodyhtml" > "$documentpath/$documentid.html"

# Get the metadata (net of body text)
xmlmetadata=${xmldocument%%<body*}

# Parse the XML metadata
# To ensure speed, no external parsers are used
# via http://stackoverflow.com/questions/893585/how-to-parse-xml-in-bash

while IFS=\> read -d \< ENTITY CONTENT; do
	if [ "$ENTITY" = "region" ]; then
		region=$CONTENT
	fi
	if [ "$ENTITY" = "court" ]; then
		court=$CONTENT
	fi
	if [ "$ENTITY" = "judge" ]; then
		judge=$CONTENT
	fi
	if [ "$ENTITY" = "vidpr" ]; then
		vidpr=$CONTENT
	fi
	if [ "$ENTITY" = "case_number" ]; then
		case_number=$CONTENT
	fi
	if [ "$ENTITY" = "etapd" ]; then
		etapd=$CONTENT
	fi
	if [ "$ENTITY" = "category" ]; then
		category=$CONTENT
	fi
	if [ "$ENTITY" = "result" ]; then
		result=$CONTENT
	fi
	if [ "$ENTITY" = "date" ]; then
		date=$CONTENT
	fi
	if [ "$ENTITY" = "url" ]; then
		url=$CONTENT
	fi
	if [ "$ENTITY" = "vid_dokumenta" ]; then
		vid_dokumenta=$CONTENT
	fi
done <<< "$xmlmetadata"

echo "\"$documentid\",\"$region\",\"$court\",\"$judge\",\"$vidpr\",\"$case_number\",\"$etapd\",\"$category\",\"$result\",\"$date\",\"$url\",\"$vid_dokumenta\""
