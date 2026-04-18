#!/bin/bash

contractOriginPath=./declarative-smart-contracts/solidity
contractRefPath=./declarative-smart-contracts/Reference
contractsTestAllPath=./smart_contracts_evaluation/contracts

contractList=(
    "$contractOriginPath/min"
    "$contractOriginPath/noOptimization"
)
for path in "${contractList[@]}"; do
    for folder in ${path}/*; do
        if [ -d "$folder" ]; then
            foldername=$(basename "$folder")
            echo $path
            echo "$foldername"

            for file in "$folder"/*.sol; do
                if [ -f "$file" ]; then
                    filename=$(basename -- "$file")
                    newFileName=""
                    if [[ $path == *min ]]; then
                        newFileName=$filename
                    else
                        newFileName="${foldername}full.sol"
                    fi
                    mkdir -p "$contractsTestAllPath/$foldername"
                    cp -f $path/$foldername/$filename $contractsTestAllPath/$foldername/$newFileName
                fi
            done
        fi
    done
done

# Copy reference contracts
for refFile in "$contractRefPath"/*ref.sol; do
    if [ -f "$refFile" ]; then
        filename=$(basename -- "$refFile")
        # Extract benchmark name by removing "ref.sol" suffix
        foldername="${filename%ref.sol}"
        echo "ref: $foldername"
        mkdir -p "$contractsTestAllPath/$foldername"
        cp -f "$refFile" "$contractsTestAllPath/$foldername/${filename}"
    fi
done
