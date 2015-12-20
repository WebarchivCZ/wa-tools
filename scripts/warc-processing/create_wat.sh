#!/bin/bash

# WAT Generator
# Expects file with list of paths to WARC/ARCs
# For Each line in file, it checks for existence of WARC/logs/wat directory and WAT file
# If false, then generate WAT

# JAVA
java=/opt/java/latest/bin/java
#export JAVA_HOME=/opt/java/latest/
#export JAVA_OPTS="-Xmx13000m"

# Metadata extractor: https://webarchive.jira.com/wiki/display/Iresearch/archive-metadata-extractor.jar
metadataExtractor=/opt/tools/archive-metadata-extractor-20110430.jar

# Date of running script and name of script for logger
date=`date +%Y-%m-%d`
host=$(hostname)

# Log path for troubles
list=$(basename "$1")
log_dir=$(dirname "$1")/logs
log=$log_dir/$date-$list-$host-wat-output.log


if [ ! -d $log_dir ]; then
        echo Creating: $log_dir
        mkdir $log_dir
fi

while read path; do
warc=$(basename "$path")
wat_dir=$(dirname "$path")/logs/wat/
wat=$warc.wat

# Create directory in WARC direcotry for CDX
if [ ! -d $wat_dir ]; then
	echo Creating $wat_dir
        mkdir -p $wat_dir
fi

# Check if CDX is already created
if [ -e $wat_dir$wat ]; then
        echo there is already WAT file: $wat_dir$wat
else   
	echo extracting matedata from $warc into: $wat_dir$wat
        $java -Xmx13000m -jar $metadataExtractor -wat $path > $wat_dir$wat 2>> $log
fi
done < $1
