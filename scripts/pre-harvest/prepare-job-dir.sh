#!/bin/bash
# Script for heritrix dir initiation on multiple machines.

job=CZ-2015-12
job_dir=/opt/heritrix/jobs

# check for existence of job directory, if it does not exist, create it.

if [ ! -d $job_dir/$job ]; then
	echo creating $job_dir/$job
	mkdir $job_dir/$job
else
	echo "Directory $job_dir/$job already exists."
fi
