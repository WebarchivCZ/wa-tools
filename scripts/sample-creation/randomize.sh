#!/bin/bash
# randomize file content at puts it into another folder.  it expects field order as below:
# YEAR URL MIME SIZE ARC/WARC
# 2001 http://001.webpark.cz/1/1.jpg image/jpeg 27510694 NEDLIB--20051107130524-00000.arc.gz
for f in $*
do	
	filename="${f##*/}"
	tempname="${filename%.*}"
	echo "Processing $f"
	sort -R -T . --random-source /dev/random "$f" > uri-years-random/"$tempname".random.cdx
done
