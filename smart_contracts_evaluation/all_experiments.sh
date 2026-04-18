#!/bin/bash
set -x
folder_path='./contracts'
if [ ! -d "$folder_path" ]; then
    echo "Error: Folder does not exist."
    exit 1
fi

# Iterate through subfolders and run tests
for subfolder in "$folder_path"/*/; do
    subfolder_name=$(basename "$subfolder")
    ./test.sh "$subfolder_name"
done