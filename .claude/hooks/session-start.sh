#!/bin/bash
# Install the hyperresearch CLI in fresh cloud sessions.
set -euo pipefail
if ! command -v hyperresearch >/dev/null 2>&1; then
  pip install -q hyperresearch
fi
