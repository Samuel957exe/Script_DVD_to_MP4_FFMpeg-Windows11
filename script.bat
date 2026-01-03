@echo off
setlocal enabledelayedexpansion

:: --- CONFIGURACIÓN ---
SET "BASE_OUTPUT=C:\Users\Samuel\Desktop\Copia_araujo"

:: --- INICIO ---
cls
echo ========================================================
echo   AUTOMATIZACION COMPLETA (FOTOS + VIDEO - SIN MENU)
echo ========================================================
echo.

:: 1. Solicitar letra de unidad (solo una vez)
set /p DRIVE_LETTER="Introduce la letra de tu unidad de DVD (ejemplo D o E): "
SET "DVD_PATH=%DRIVE_LETTER%:\VIDEO_TS"
SET "DCIM_PATH=%DRIVE_LETTER%:\DCIM"

:LOOP_START
cls
echo --------------------------------------------------------
echo NUEVO DISCO
echo --------------------------------------------------------
echo.

:: 2. Preguntar numero de disco
set "DISC_COUNT="
set /p DISC_COUNT="Que numero de disco es este? (Escribe el numero): "

:: Si el usuario da Enter sin escribir, vuelve a preguntar
if "!DISC_COUNT!"=="" goto :LOOP_START

echo.
echo ========================================================
echo   PROCESANDO DISCO NUMERO: !DISC_COUNT!
echo ========================================================
echo.
echo Por favor, inserta el DVD numero !DISC_COUNT! en la unidad %DRIVE_LETTER%:.
echo.
pause

:: ----------------------------------------------------------
:: BLOQUE 1: PROCESAMIENTO DE FOTOS (DCIM)
:: ----------------------------------------------------------
echo.
echo [PASO 1] Comprobando si hay carpeta DCIM (Fotos)...

if exist "!DCIM_PATH!" (
    echo    - Carpeta DCIM detectada. Preparando copia...
    
    :: Crear carpeta de destino para fotos
    SET "FOTOS_DEST=!BASE_OUTPUT!\VideosDisco!DISC_COUNT!\Fotos"
    if not exist "!FOTOS_DEST!" mkdir "!FOTOS_DEST!"
    
    :: Copiar fotos
    xcopy "!DCIM_PATH!" "!FOTOS_DEST!" /S /E /I /Y >nul
    
    echo.
    echo    [OK] Fotos copiadas correctamente en:
    echo    !FOTOS_DEST!
) else (
    echo    - No se encontro carpeta DCIM en este disco.
    echo    - Saltando al proceso de video...
)
echo.
echo --------------------------------------------------------

:: ----------------------------------------------------------
:: BLOQUE 2: PROCESAMIENTO DE VIDEO (VIDEO_TS)
:: ----------------------------------------------------------
echo [PASO 2] Procesando Videos...

:: Verificar si existe la carpeta VIDEO_TS
if not exist "!DVD_PATH!" (
    echo.
    echo [AVISO] No se encuentra la carpeta VIDEO_TS en la unidad.
    echo Si este disco solo tenia fotos, esto es normal.
    echo.
) else (
    :: Crear carpeta de destino para video
    SET "VIDEO_DEST=!BASE_OUTPUT!\VideosDisco!DISC_COUNT!\Video"
    if not exist "!VIDEO_DEST!" mkdir "!VIDEO_DEST!"

    echo    - Analizando archivos VOB...
    echo    - Guardando en: !VIDEO_DEST!
    echo.

    :: Bucle FFmpeg CON FILTRO DE EXCLUSIÓN
    for %%f in ("!DVD_PATH!\*.VOB") do (
        
        :: AQUI ESTA EL FILTRO: Si el nombre es VIDEO_TS.VOB, lo salta
        if /I "%%~nxf"=="VIDEO_TS.VOB" (
            echo    [INFO] Saltando archivo de Menu: %%~nxf
        ) else (
            echo    Procesando: %%~nxf ...
            ffmpeg -n -i "%%f" -c:v h264_nvenc -cq 19 -c:a aac "!VIDEO_DEST!\%%~nf.mp4"
            echo    [OK] %%~nxf convertido.
        )
    )
    echo.
    echo    [OK] Procesamiento de video completado.
)

echo.
echo ========================================================
echo   DISCO !DISC_COUNT! FINALIZADO
echo ========================================================
echo.

:: Preguntar si continuar
set "CONTINUE=N"
set /p CONTINUE="Quieres procesar otro disco? (S para Si, Enter para salir): "

if /I "!CONTINUE!"=="S" goto :LOOP_START

:: --- SALIDA AUTOMATICA ---
cls
echo.
echo ========================================================
echo   GRACIAS - CERRANDO SCRIPT EN...
echo ========================================================
echo.
timeout /t 3
exit