#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
BGFX_DIR=$SCRIPT_DIR/../../../bgfx

cd $SCRIPT_DIR

cp -f $BGFX_DIR/.build/linux64_gcc/bin/libbgfxDebug.a .
cp -f $BGFX_DIR/.build/linux64_gcc/bin/libbgfxRelease.a .
cp -f $BGFX_DIR/.build/linux64_gcc/bin/libbimgDebug.a .
cp -f $BGFX_DIR/.build/linux64_gcc/bin/libbimgRelease.a .
cp -f $BGFX_DIR/.build/linux64_gcc/bin/libbxDebug.a .
cp -f $BGFX_DIR/.build/linux64_gcc/bin/libbxRelease.a .
