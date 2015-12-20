#!/bin/bash
random_count=1001
for f in $*
do	
	filename="${f##*/}"
	tempname="${filename%.*}"
	echo "Processing $f"
	count=0
	while read line && [[ ! "$count" -eq "$random_count" ]]
	do
		warc=$( awk '{print $NF}' <<< "$line" )
		grep "$warc" warcs.links && ((count++)) && echo "$line" >> vav-formats/"$tempname".selected.cdx
	done < "$f"
#	sort -R -T . --random-source /dev/random "$f" > uri-years-random/"$tempname".random.cdx
done
