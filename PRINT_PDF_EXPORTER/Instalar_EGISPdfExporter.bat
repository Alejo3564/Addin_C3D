@echo off
setlocal

echo.
echo  ============================================================
echo   EGIS Smart Tools - PDF Sheet Exporter
echo   Instalador de plugin para Civil 3D 2026
echo  ============================================================
echo.

set "BUNDLE_NAME=EGISPdfExporter.bundle"
set "DEST=%APPDATA%\Autodesk\ApplicationPlugins\%BUNDLE_NAME%"
set "SOURCE=%~dp0%BUNDLE_NAME%"

:: Verificar que la carpeta bundle existe junto al .bat
if not exist "%SOURCE%" (
    echo  [ERROR] No se encontro la carpeta "%BUNDLE_NAME%"
    echo          Asegurese de que el .bat este en la misma carpeta que "%BUNDLE_NAME%"
    echo.
    pause
    exit /b 1
)

:: Verificar que Civil 3D no esta abierto
tasklist /FI "IMAGENAME eq acad.exe" 2>nul | find /I "acad.exe" >nul
if not errorlevel 1 (
    echo  [AVISO] Civil 3D / AutoCAD esta abierto.
    echo          Cierrelo antes de continuar para evitar conflictos.
    echo.
    pause
    exit /b 1
)

:: Crear carpeta destino si no existe
if not exist "%APPDATA%\Autodesk\ApplicationPlugins" (
    mkdir "%APPDATA%\Autodesk\ApplicationPlugins"
)

:: Eliminar instalacion anterior si existe
if exist "%DEST%" (
    echo  Eliminando version anterior...
    rmdir /s /q "%DEST%"
)

:: Copiar bundle completo
echo  Instalando plugin...
xcopy /e /i /q "%SOURCE%" "%DEST%"

if errorlevel 1 (
    echo.
    echo  [ERROR] La instalacion fallo. Verifique permisos de escritura.
    echo.
    pause
    exit /b 1
)

echo.
echo  ============================================================
echo   Plugin instalado correctamente en:
echo   %DEST%
echo.
echo   Inicie Civil 3D 2026 y busque la pestana:
echo   "EGIS Smart Tools" ^> grupo "Sheets ^& Print"
echo  ============================================================
echo.
pause
endlocal
