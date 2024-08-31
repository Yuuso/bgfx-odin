@echo off

set SCRIPT_DIR=%~dp0
set TARGET_FILE=%SCRIPT_DIR%\..\bgfx\bgfx.odin
set BGFX_DIR=%SCRIPT_DIR%\..\..\bgfx

if exist %TARGET_FILE% ( del /q %TARGET_FILE% )
cd %BGFX_DIR%\scripts
lua %~dp0\bindings-odin.lua >> %TARGET_FILE%
