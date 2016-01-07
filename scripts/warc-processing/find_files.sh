#!/bin/bash
# Find all ARC/WARC files
# Script from: https://github.com/iipc/openwayback/wiki/How-to-configure
ARCHIVE_BASE_DIR=$1;
TARGET_FILE=$2;

tempfile="$TARGET_FILE.tmp";

unset a i
while IFS= read -r -d $'\0' file; do

  archive=$(basename $file);
  echo -e "$archive\t$file" >> $tempfile;

done < <(find $ARCHIVE_BASE_DIR -type f -regex ".*\.w?arc\.gz$" -print0)

# Now sort the file
export LC_ALL=C;
sort $tempfile > $TARGET_FILE;

rm $tempfile
