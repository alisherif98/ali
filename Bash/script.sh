#!/bin/bash

# Define Oracle Environment Variables
export ORACLE_HOME=/c/oraclexe/app/oracle/product/11.2.0/server/
export ORACLE_SID=XE
export PATH=$ORACLE_HOME/bin:$PATH
schema_name=modern
password=123

# Define directory and file names for the dump and log
DIRECTORY_NAME=new_dir
DUMPFILE=Data_$(date +%Y%m%d_%H%M%S).dmp
LOGFILE=detailed_steps_$(date +%Y%m%d_%H%M%S).log

# Execute Data Pump Export
expdp $schema_name/$password@XE FULL=YES DIRECTORY=$DIRECTORY_NAME DUMPFILE=$DUMPFILE LOGFILE=$LOGFILE

# Check if expdp was successful
if [ $? -eq 0 ]; then
    echo "Export successful: $(date)"
else
    echo "Export failed: $(date)"
fi
