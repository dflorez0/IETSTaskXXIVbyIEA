#!/usr/bin/env bash
#
# Builds the HTML website, the only format deployed, into _book/.

set -euo pipefail
cd "$(dirname "$0")"

if ! command -v quarto &>/dev/null; then
  echo "Error: quarto is not installed or not on PATH." >&2
  echo "Install it from https://quarto.org/docs/get-started/" >&2
  exit 1
fi

quarto render

echo
echo "Output in _book/"
