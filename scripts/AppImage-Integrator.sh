#!/bin/bash

set -e

EXIT_SUCCESS=0
EXIT_FAIL=1

# Tool to help me integrate AppImage binaries
# Should set user execute bit, place file
# in ~/.local/bin, and create a .desktop
# file in ~/.local/share/applications

DSK_TEMPLATE=template.desktop

BIN_DST_DIR=~/.local/bin/
DSK_DST_DIR=~/.local/share/applications/

# Does not have first argument
if [[ -z $1 ]]; then
  echo "Usage: $0 <AppImage File> <App Name>"
  exit $EXIT_FAIL
fi

# Does not have second argument
if [[ -z $2 ]]; then
  echo "Usage: $0 <AppImage File> <App Name>"
  exit $EXIT_FAIL
fi

# Check if AppImage file is valid
if [[ ! -f $1 ]]; then
  if [[ -d $1 ]]; then
    echo "$1 is a directory."
  else
    echo "File does not exist."
  fi

  exit $EXIT_FAIL
fi

# Set executable bit
chmod u+x $1

NEW_PATH=$BIN_DST_DIR$(basename -- $1)

# Move to ~/.local/bin
mv $1 $NEW_PATH

# Prepare new desktop file
DSK_FILE_NAME="${2// /}.desktop"

EXEC_PATH=$NEW_PATH NAME=$2 envsubst <template.desktop >$DSK_FILE_NAME

mv $DSK_FILE_NAME $DSK_DST_DIR$DSK_FILE_NAME

exit $EXIT_SUCCESS
