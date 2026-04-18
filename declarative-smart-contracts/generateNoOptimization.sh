#!/bin/bash

dlDir="./benchmarks"
planDir="./view-materialization/full-set"
outDir="./solidity/noOptimization"

for file in "$dlDir"/*.dl; do
	filename=$(basename -- "$file")
	basename="${filename%.*}"
	mkdir -p "$outDir/$basename"
	# sbt "run compile --materialize $planDir/$basename.csv --no-arithmetic-optimization --no-projection --out $outDir/ $dlDir/$filename"
	# sbt "run compile --materialize $planDir/$basename.csv --no-arithmetic-optimization --out $outDir/ $dlDir/$filename"
	if [ "$basename" = "brickBlockToken" ]; then
		sbt "run compile --materialize $planDir/$basename.csv --out $outDir/ $dlDir/$filename"
	else
		sbt "run compile --materialize $planDir/$basename.csv --no-arithmetic-optimization --out $outDir/ $dlDir/$filename"
	fi
done