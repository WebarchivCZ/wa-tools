#!/bin/bash
# Archive log directories in current working path and tar/gz them into defined path, it will check for preexisting archives.

current=$(pwd)
hostname=$(hostname)
warc_dir=$1
logs_dir=$warc_dir/logs/crawl
tar_prefix=`basename $warc_dir`-$hostname-
tar_suffix=".tar.gz"
tar_i=0
tar_name=$logs_dir/$tar_prefix`printf "%02d" $tar_i`$tar_suffix

if [ $# -lt 1 ]; then
	echo "As argument I will accept path to WARC directory, I will create logs/crawl directory there, then I will check for existence of WARC_DIR_NAME-HOSTNAME-[0-9]{2}.tar.gz and append tar after last log archive."
        exit 1
else
	if [ -d $warc_dir ]; then
		echo "$logs_dir will be used as log archive"
	else
		echo "$warc_dir is not directory, please use WARC directory as argument"
		exit 1
	fi
			
fi

function prepare_log_dir {
	if [ ! -d $logs_dir ]; then
		echo mkdir -p $logs_dir
	else
		echo "$logs_dir already exists"
	fi
}

function iterate_tar {
	tar_i=$((tar_i+1))
	tar_name=$logs_dir/$tar_prefix`printf "%02d" $tar_i`$tar_suffix

}

prepare_log_dir

# sort each dir with pattern [0-9]{14} from older to newer and do tar
for d in `ls -d [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]| sort -V`; do 
	if [ -f $tar_name ]; then 
		while [ -f $tar_name ]; do
			echo $tar_name already exists
			iterate_tar
		done
		echo $tar_name will be created from $d
		tar czvf $tar_name $d
		iterate_tar
	else
		echo $tar_name will be created from $d
		tar czvf $tar_name $d
		iterate_tar
	fi
	
done
