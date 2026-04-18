#!/bin/bash
set -x
# make sure the test file does not have the min_version to start with
bm="$1"
folder_min="./contracts/${bm}"
file="./testScripts/${bm}_test_gas.js"

# Remove any stale min_version line from previous interrupted runs
if head -1 "$file" | grep -q "^const min_version"; then
	sed -i '1d' "$file"
fi
build_path="./build/contracts"
i=1
for min in "$folder_min"/*
do 
	# compile solidity after removing all files in build
	if [ -n "$(ls -A $build_path)" ]; then
	    # Use rm -r to delete all files and subdirectories in the folder
	    rm -r "$build_path"/*
	fi
	if [ -f "$file" ]; then
		truffle compile "${min}"
	fi
	# add the min_versoin to the test file
	# Extract the base name without extension
	# min_filename=$(basename "$min")
	base_name=$(basename "$min" | cut -d. -f1)
	if [[ $min == *full* ]]; then
		suffix='full'
	elif [[ $min == *ref* ]]; then
		suffix='ref'
	else
		suffix="min_${base_name#${bm}}" #min_1
	fi
	echo "suffix: ${suffix}"
	new_line="const min_version = '${suffix}';"
	temp_file=$(mktemp)
	echo "$new_line" | cat - "$file" > "$temp_file"
	mv "$temp_file" "$file"
	# run test
	truffle test "./testScripts/${bm}_test_gas.js" --compile-none
	# delete the first line of the test file
	if [[ $(uname) == "Darwin" ]]; then
    	# macOS (BSD sed)
    	sed -i '' 1d "${file}"
	elif [[ $(uname) == "Linux" ]]; then
    	# Linux (GNU sed)
    	sed -i 1d "${file}"
    fi
done


