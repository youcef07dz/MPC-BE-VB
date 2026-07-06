@ECHO OFF
REM Sets up environments.bat from local toolchains.
REM Run this once after checkout or toolchain update.

SET "SCRIPT_DIR=%~dp0"
SET "REPO_ROOT=%~dp0.."

IF NOT EXIST "%SCRIPT_DIR%msys\mingw\bin\gcc.exe" (
    ECHO MinGW not found in %SCRIPT_DIR%msys.
    ECHO Run toolchains\setup-msys.ps1 first.
    EXIT /B 1
)

> "%REPO_ROOT%\environments.bat" (
    ECHO @ECHO OFF
    ECHO SET "MPCBE_MSYS=%SCRIPT_DIR%msys"
    ECHO SET "MPCBE_MINGW=%SCRIPT_DIR%msys\mingw"
)

ECHO Created %REPO_ROOT%\environments.bat
ECHO   MPCBE_MSYS=%SCRIPT_DIR%msys
ECHO   MPCBE_MINGW=%SCRIPT_DIR%msys\mingw
