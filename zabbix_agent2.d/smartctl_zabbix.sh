#!/bin/bash

# Problem: smart discovery fails, because the exit code is 8 (there is a smart error) and != 0
# So we suppress potential non fatal exit codes while scanning

smartctl $@
RETURN_CODE=$?

# Check if --scan is in arguments

for arg in "$@"; do
  if [ "$arg" = "--scan" ]; then
    # For discovery: ignore SMART-related exit codes
    if [ "$RETURN_CODE" -lt 128 ]; then
      exit 0
    fi
    exit "$RETURN_CODE"
  fi
done

exit 0