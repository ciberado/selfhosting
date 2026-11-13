#!/bin/sh
# Ensure question-bank directories and files are readable by all users.
# The app server runs as a non-root user (nodejs uid=1001), so world-read/execute
# bits must be set on every directory and file under question-banks/.

set -e

BANKS_DIR="$(dirname "$0")/question-banks"

echo "Fixing permissions under $BANKS_DIR ..."
find "$BANKS_DIR" -type d -exec chmod o+rx {} +
find "$BANKS_DIR" -type f -exec chmod o+r  {} +
echo "Done."
