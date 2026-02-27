#!/bin/bash
# FORGE Agent Orchestrator Integration Installer (Shell Wrapper)
#
# Usage: ./install.sh [--workspace <path>] [--mode ao|standalone]

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run Node installer
exec node "${SCRIPT_DIR}/install.mjs" "$@"
