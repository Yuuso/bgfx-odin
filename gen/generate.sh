#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
TARGET_FILE=$SCRIPT_DIR/../bgfx/bgfx.odin
BGFX_DIR=$SCRIPT_DIR/../../bgfx

[ -f "$TARGET_FILE" ] && rm "$TARGET_FILE"
cd $BGFX_DIR/scripts
lua $SCRIPT_DIR/bindings-odin.lua >> $TARGET_FILE
