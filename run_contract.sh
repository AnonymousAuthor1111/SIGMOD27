#!/bin/bash
# Usage: ./generate_contract.sh <contractName>
# Example: ./generate_contract.sh brickBlockToken
#
# Runs the full pipeline for a single contract:
#   1. dependency-graph & judgement-check (all benchmarks, Scala requirement)
#   2. full-set.py & min-set.py (all benchmarks, Python requirement)
#   3. Copy metadata back
#   4. Compile min and noOptimization Solidity versions
#   5. Copy to test directory
#
# Must be run from the OCELOT root directory.

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <contractName>"
    echo "Example: $0 brickBlockToken"
    exit 1
fi

CONTRACT="$1"
DL_FILE="benchmarks/${CONTRACT}.dl"
OCELOT_DIR="$(cd "$(dirname "$0")" && pwd)"
SBT="/home/lanlu/miniconda3/envs/ocelot/bin/sbt"

COMPILER_DIR="$OCELOT_DIR/declarative-smart-contracts"
PYGEN_DIR="$OCELOT_DIR/gasOpt-setGeneration"
TEST_DIR="$OCELOT_DIR/smart_contracts_evaluation"

# Capitalize first letter for dependency file names (e.g., brickBlockToken -> BrickBlockToken)
CONTRACT_CAP="$(echo "${CONTRACT:0:1}" | tr '[:lower:]' '[:upper:]')${CONTRACT:1}"

cd "$COMPILER_DIR"

if [ ! -f "$DL_FILE" ]; then
    echo "ERROR: $DL_FILE not found"
    exit 1
fi

echo "========== Step 0: Create directories =========="
mkdir -p view-materialization/relation-dependencies view-materialization/contain-judgement view-materialization/full-set view-materialization/min-set
mkdir -p "$PYGEN_DIR/view-materialization/relation-dependencies" "$PYGEN_DIR/view-materialization/contain-judgement" "$PYGEN_DIR/view-materialization/full-set" "$PYGEN_DIR/view-materialization/min-set"
mkdir -p "$PYGEN_DIR/benchmarks"

# Sync benchmarks from compiler dir to algo dir so both operate on the same dl files
cp -rf benchmarks/* "$PYGEN_DIR/benchmarks/"

echo "========== Step 1: dependency-graph & judgement-check =========="
$SBT "run dependency-graph" 2>&1 | tail -3
$SBT "run judgement-check" 2>&1 | tail -3

echo "========== Step 2: Copy metadata to Python dir =========="
cp "view-materialization/relation-dependencies/${CONTRACT_CAP}.csv" \
   "$PYGEN_DIR/view-materialization/relation-dependencies/"
cp "view-materialization/contain-judgement/${CONTRACT_CAP}.csv" \
   "$PYGEN_DIR/view-materialization/contain-judgement/"
cp "$DL_FILE" "$PYGEN_DIR/benchmarks/"

echo "========== Step 3: Run full-set.py & min-set.py =========="
cd "$PYGEN_DIR"
python3 full-set.py 2>&1 | tail -3
python3 min-set.py 2>&1 | tail -3

echo "========== Step 4: Copy configs back & strip \\r =========="
cd "$COMPILER_DIR"
cp "$PYGEN_DIR/view-materialization/full-set/${CONTRACT}.csv" \
   "view-materialization/full-set/"
cp "$PYGEN_DIR/view-materialization/min-set/${CONTRACT}.csv" \
   "view-materialization/min-set/"

# Remove Windows-style \r that Python csv.writer may produce
# sed -i 's/\r$//' "view-materialization/full-set/${CONTRACT}.csv"
# sed -i 's/\r$//' "view-materialization/min-set/${CONTRACT}.csv"

echo "  full-set configs: 1"
echo "  min-set configs: $(wc -l < "view-materialization/min-set/${CONTRACT}.csv")"

echo "========== Step 5: Compile min versions =========="
mkdir -p "solidity/min/${CONTRACT}"
rm -f "solidity/min/${CONTRACT}"/*.sol
$SBT "run compile --materialize view-materialization/min-set/${CONTRACT}.csv --out solidity/min $DL_FILE" 2>&1 | grep -E "rules\.|error|success"

echo "========== Step 6: Compile noOptimization (full-set) version =========="
mkdir -p "solidity/noOptimization/${CONTRACT}"
rm -f "solidity/noOptimization/${CONTRACT}"/*.sol
if [ "$CONTRACT" = "brickBlockToken" ]; then
	$SBT "run compile --materialize view-materialization/full-set/${CONTRACT}.csv --out solidity/noOptimization $DL_FILE" 2>&1 | grep -E "rules\.|error|success"
else
	$SBT "run compile --materialize view-materialization/full-set/${CONTRACT}.csv --no-arithmetic-optimization --out solidity/noOptimization $DL_FILE" 2>&1 | grep -E "rules\.|error|success"
fi

echo "========== Step 7: Copy to test directory =========="
mkdir -p "$TEST_DIR/contracts/${CONTRACT}"
rm -f "$TEST_DIR/contracts/${CONTRACT}"/*.sol
cp "solidity/min/${CONTRACT}"/*.sol "$TEST_DIR/contracts/${CONTRACT}/"
cp "solidity/noOptimization/${CONTRACT}/${CONTRACT}1.sol" \
   "$TEST_DIR/contracts/${CONTRACT}/${CONTRACT}full.sol"
if [ -f "Reference/${CONTRACT}ref.sol" ]; then
    cp "Reference/${CONTRACT}ref.sol" "$TEST_DIR/contracts/${CONTRACT}/"
fi

echo "========== Step 8: Truffle compile check (generated) =========="
cd "$TEST_DIR"
pass=0
fail=0
for sol in "contracts/${CONTRACT}"/*.sol; do
    name=$(basename "$sol" .sol)
    # Skip ref file here; checked separately below
    if [[ "$name" == *"ref" ]]; then
        continue
    fi
    rm -rf build/contracts/*
    result=$(truffle compile "$sol" 2>&1) || true
    if echo "$result" | grep -q "Compilation failed"; then
        echo "  FAIL: $name"
        fail=$((fail + 1))
    else
        echo "  OK:   $name"
        pass=$((pass + 1))
    fi
done

echo "========== Step 9: Truffle compile check (reference) =========="
REF_SOL="contracts/${CONTRACT}/${CONTRACT}ref.sol"
ref_pass=0
ref_fail=0
if [ -f "$REF_SOL" ]; then
    rm -rf build/contracts/*
    result=$(truffle compile "$REF_SOL" 2>&1) || true
    if echo "$result" | grep -q "Compilation failed"; then
        echo "  FAIL: ${CONTRACT}ref"
        ref_fail=1
    else
        echo "  OK:   ${CONTRACT}ref"
        ref_pass=1
    fi
else
    echo "  SKIP: ${CONTRACT}ref.sol not found"
fi

echo ""
echo "========== Done =========="
echo "  Contract: $CONTRACT"
echo "  Generated compile: $pass passed, $fail failed"
echo "  Reference compile: $ref_pass passed, $ref_fail failed"
echo "  Files at: $TEST_DIR/contracts/${CONTRACT}/"
