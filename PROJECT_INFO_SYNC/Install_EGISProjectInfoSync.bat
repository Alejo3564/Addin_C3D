@echo off
setlocal

echo.
echo  ============================================================
echo   EGIS Smart Tools - EGISProjectInfoSync
echo   Plugin Installer for Civil 3D 2026
echo  ============================================================
echo.

set "BUNDLE_NAME=EGISProjectInfoSync_Plugin.bundle"
set "DEST=%APPDATA%\Autodesk\ApplicationPlugins\%BUNDLE_NAME%"
set "SOURCE=%~dp0%BUNDLE_NAME%"

:: Check that the bundle folder exists next to the .bat
if not exist "%SOURCE%" (
    echo  [ERROR] Folder "%BUNDLE_NAME%" not found.
    echo          Make sure the .bat file is in the same folder as "%BUNDLE_NAME%".
    echo.
    pause
    exit /b 1
)

:: Check that Civil 3D / AutoCAD is not running
tasklist /FI "IMAGENAME eq acad.exe" 2>nul | find /I "acad.exe" >nul
if not errorlevel 1 (
    echo  [WARNING] Civil 3D / AutoCAD is currently open.
    echo            Please close it before continuing to avoid conflicts.
    echo.
    pause
    exit /b 1
)

:: Create destination folder if it does not exist
if not exist "%APPDATA%\Autodesk\ApplicationPlugins" (
    mkdir "%APPDATA%\Autodesk\ApplicationPlugins"
)

:: Remove previous installation if it exists
if exist "%DEST%" (
    echo  Removing previous version...
    rmdir /s /q "%DEST%"
)

:: Copy the full bundle
echo  Installing plugin...
xcopy /e /i /q "%SOURCE%" "%DEST%"

if errorlevel 1 (
    echo.
    echo  [ERROR] Installation failed. Please check write permissions.
    echo.
    pause
    exit /b 1
)

echo.
echo  ============================================================
echo   Plugin installed successfully at:
echo   %DEST%
echo.
echo   Launch Civil 3D 2026 and look for the ribbon tab:
echo   "EGIS Smart Tools"  ^>  panel "Parameter Sync"
echo  ============================================================
echo.
pause
endlocal
