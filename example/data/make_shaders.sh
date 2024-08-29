#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BGFX_DIR=$SCRIPT_DIR/../../../bgfx

if [ ! -f $BGFX_DIR/tools/bin/linux/shaderc ]; then
	echo "shaderc not found!"
	exit 1
fi

cd $SCRIPT_DIR

cp -f $BGFX_DIR/src/bgfx_shader.sh .

make build
