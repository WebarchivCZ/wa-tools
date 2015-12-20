#!/bin/bash
export JAVA_HOME=/opt/java/latest
indexer=/opt/install/openwayback/bin/cdx-indexer
cdx_dir=/mnt/archives/archive14/NDK-2014/logs/index/
while read path; do
warc=$(basename "$path")
cdx=$warc.cdx
if [ -e $cdx_dir$cdx ]
then
	echo there is already cdx file for: $warc
else
	$indexer $path $cdx_dir$cdx 2>> /mnt/archives/archive14/NDK-2014-cdx_indexer-error.log
fi
done < $1
