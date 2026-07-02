@echo off
REM setup-msys2.bat - Install/update MSYS2 + MinGW, set env vars for MPC-BE
REM Run this script as Administrator

:: Check for elevation
net session >nul 2>&1
if %errorlevel% NEQ 0 (
  echo This script must be run as Administrator.
  pause
  exit /b 1
)

setlocal enabledelayedexpansion

set "MSYS_ROOT="
for %%d in ("C:\msys64" "C:\MSYS") do (
  if exist %%~d (
	set "MSYS_ROOT=%%~d"
	goto :found_msys
  )
)
:found_msys
if not defined MSYS_ROOT (
  echo MSYS not found. Installing via winget...
  winget install --id MSYS2.MSYS2 -e
  if %errorlevel% NEQ 0 (
	echo winget install failed. Please install MSYS2 manually from https://www.msys2.org/
	pause
	exit /b 1
  )
  set "MSYS_ROOT=C:\msys64"
  timeout /t 5 /nobreak >nul
)

if not exist "%MSYS_ROOT%\usr\bin\bash.exe" (
  echo bash.exe not found in %MSYS_ROOT%\usr\bin
  pause
  exit /b 1
)
set "BASH=%MSYS_ROOT%\usr\bin\bash.exe"

echo Updating MSYS2 packages (this can take several minutes)...
"%BASH%" -lc "pacman -Syu --noconfirm"

:: pacman may require a second update after core package upgrade
"%BASH%" -lc "pacman -Su --noconfirm"

necho Installing MinGW toolchain packages...
"%BASH%" -lc "pacman -S --noconfirm base-devel mingw-w64-x86_64-toolchain mingw-w64-x86_64-gcc"

n:: Determine mingw root (prefer mingw64)
if exist "%MSYS_ROOT%\mingw64" (
  set "MINGW_ROOT=%MSYS_ROOT%\mingw64"
) else if exist "%MSYS_ROOT%\mingw32" (
  set "MINGW_ROOT=%MSYS_ROOT%\mingw32"
) else (
  echo No mingw directory found under %MSYS_ROOT%
  pause
  exit /b 1
)

necho Setting environment variables (user scope)...
setx MPCBE_MSYS "%MSYS_ROOT%" >nul
setx MPCBE_MINGW "%MINGW_ROOT%" >nul

nset "MINGW_BIN=%MINGW_ROOT%\bin"

necho Adding %MINGW_BIN% to user PATH if needed...
echo %PATH% | find /I "%MINGW_BIN%" >nul
if errorlevel 1 (
  setx PATH "%PATH%;%MINGW_BIN%" >nul
  echo Added %MINGW_BIN% to user PATH.
) else (
  echo %MINGW_BIN% already in PATH.
)

necho Verifying libgcc.a presence (from MSYS shell):
"%BASH%" -lc "ls /mingw64/lib/gcc/*/*/libgcc.a || echo libgcc.a not found"

necho Finished.
echo IMPORTANT: Restart any open shells (or sign out/in) so new environment variables take effect.
echo To build MPC-BE, open an MSYS2 MinGW 64-bit shell or a new PowerShell and run from the repo root:
echo     ffmpeg.bat 64 rebuild debug
pause
endlocal
