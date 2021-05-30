#!/bin/bash

path1=$(realpath  "${BASH_SOURCE[0]}")
path2=$(dirname "${path1}")
path3=$(dirname "${path2}")
functions_path="${path3}/functions"
export functions_path

for file in "${functions_path}"/*.sh
do
    source "${file}"
done
