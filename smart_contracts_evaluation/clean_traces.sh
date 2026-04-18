#!/bin/bash
# Clean generated trace files and/or opcode files in testTraces
# Usage: ./clean_traces.sh [--opcode-only]

TRACES_DIR="$(dirname "$0")/testTraces"

if [ ! -d "$TRACES_DIR" ]; then
    echo "Error: testTraces directory not found at $TRACES_DIR"
    exit 1
fi

if [[ "$1" == "--opcode-only" ]]; then
    count=$(find "$TRACES_DIR" -type f -name "opcode_*.txt" | wc -l)
    if [ "$count" -eq 0 ]; then
        echo "Nothing to clean — no opcode files found."
        exit 0
    fi
    echo "Will delete $count opcode files, keeping traces and setup.txt."
    read -p "Continue? [y/N] " confirm
    if [[ "$confirm" != [yY] ]]; then
        echo "Aborted."
        exit 0
    fi
    find "$TRACES_DIR" -type f -name "opcode_*.txt" -delete
else
    count=$(find "$TRACES_DIR" -type f ! -name "setup.txt" | wc -l)
    if [ "$count" -eq 0 ]; then
        echo "Nothing to clean — only setup.txt files remain."
        exit 0
    fi
    echo "Will delete $count files (traces + opcodes), keeping all setup.txt files."
    read -p "Continue? [y/N] " confirm
    if [[ "$confirm" != [yY] ]]; then
        echo "Aborted."
        exit 0
    fi
    find "$TRACES_DIR" -type f ! -name "setup.txt" -delete
fi

echo "Done. Cleaned $count files."
