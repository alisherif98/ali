#!/bin/bash

# Threshold for disk usage (%)
THRESHOLD=80

# Check each mounted filesystem using human-readable format
df -h | awk -v threshold=$THRESHOLD 'NR>1 {gsub(/%/, "", $5); if ($5 >= threshold) print "Warning: Partition", $1, "mounted on", $6, "is at", $5"% usage.";}'
