@echo off
setlocal
cd /D %~dp0

set SCRIPT_DIR=%~dp0
set BGFX_DIR=%SCRIPT_DIR%\..\..\..\bgfx

copy /y %BGFX_DIR%\.build\win64_vs2022\bin\bgfxDebug.lib   bgfxDebug.lib
copy /y %BGFX_DIR%\.build\win64_vs2022\bin\bgfxRelease.lib bgfxRelease.lib
copy /y %BGFX_DIR%\.build\win64_vs2022\bin\bimgDebug.lib   bimgDebug.lib
copy /y %BGFX_DIR%\.build\win64_vs2022\bin\bimgRelease.lib bimgRelease.lib
copy /y %BGFX_DIR%\.build\win64_vs2022\bin\bxDebug.lib     bxDebug.lib
copy /y %BGFX_DIR%\.build\win64_vs2022\bin\bxRelease.lib   bxRelease.lib
