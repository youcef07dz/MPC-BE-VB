param(
    [string]$MsysUrl = "https://github.com/Aleksoid1978/MSYS/raw/main/MSYS_MinGW-w64_GCC_1521_x86-x64.7z",
    [string]$ExtractDir = "$PSScriptRoot\msys"
)

$ErrorActionPreference = "Stop"

$repoRoot = Resolve-Path "$PSScriptRoot\.."
$envFile = "$repoRoot\environments.bat"

if (Test-Path "$ExtractDir\mingw\bin\gcc.exe") {
    Write-Host "MSYS/MinGW already set up in $ExtractDir"
    if (-not (Test-Path $envFile)) {
        @"
@ECHO OFF
SET "MPCBE_MSYS=$ExtractDir"
SET "MPCBE_MINGW=$ExtractDir\mingw"
"@ | Set-Content $envFile -Encoding ASCII
        Write-Host "Created $envFile"
    }
    exit 0
}

Write-Host "Downloading MSYS/MinGW toolchain from $MsysUrl ..."
$archive = "$env:TEMP\MSYS.7z"
curl.exe -sSL -o $archive $MsysUrl
if (-not $?) { throw "Download failed" }

Write-Host "Extracting to $ExtractDir ..."
if (Test-Path $ExtractDir) { Remove-Item -Recurse -Force $ExtractDir }
New-Item -ItemType Directory -Path $ExtractDir -Force | Out-Null
& 7z x $archive -o"$ExtractDir" -y | Out-Null
if (-not $?) { throw "Extraction failed" }

if (-not (Test-Path "$ExtractDir\mingw\bin\gcc.exe")) {
    $mingwDirs = Get-ChildItem -Directory "$ExtractDir" | Where-Object { $_.Name -like 'mingw*' }
    if ($mingwDirs) {
        $mingwDir = $mingwDirs[0].FullName
        Write-Host "Renaming $mingwDir -> $ExtractDir\mingw"
        Rename-Item -Path $mingwDir -NewName "mingw"
    }
}

@"
@ECHO OFF
SET "MPCBE_MSYS=$ExtractDir"
SET "MPCBE_MINGW=$ExtractDir\mingw"
"@ | Set-Content $envFile -Encoding ASCII

Write-Host "MSYS/MinGW toolchain ready at $ExtractDir"
