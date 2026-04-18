#!/bin/bash

# Usage: bash run_with_log.sh [--test-only]

LOGFILE="$(pwd)/run_errors_$(date +%Y%m%d_%H%M%S).log"

echo "=== Run started at $(date) ===" | tee "$LOGFILE"
echo "Log file: $LOGFILE"

# Filter out known noisy warnings
FILTER='grep -v "Cannot find module.*uws_linux_x64_141.node" | grep -v "Falling back to a NodeJS implementation" | grep -v "This version of µWS is not compatible" | grep -v "Require stack:" | grep -v "uws-js-unofficial/src/uws.js" | grep -v "ganache/dist/node/core.js" | grep -v "truffle/build/test.bundled.js" | grep -v "truffle/node_modules/original-require/index.js" | grep -v "truffle/build/cli.bundled.js"'

if [ "$1" = "--test-only" ]; then
    echo "Mode: test-only (skipping compilation, running experiments only)" | tee -a "$LOGFILE"
    cd ./smart_contracts_evaluation
    bash ./all_experiments.sh 2>&1 | eval "$FILTER" | tee -a "$LOGFILE"
    EXIT_CODE=${PIPESTATUS[0]}
else
    echo "Mode: full run" | tee -a "$LOGFILE"
    bash run.sh 2>&1 | eval "$FILTER" | tee -a "$LOGFILE"
    EXIT_CODE=${PIPESTATUS[0]}
fi

echo "=== Run finished at $(date) with exit code $EXIT_CODE ===" | tee -a "$LOGFILE"
