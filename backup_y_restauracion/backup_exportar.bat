@echo off
setlocal

REM =====================================================================
REM ARCHIVO: backup_exportar.bat
REM DESCRIPCION:
REM   Genera el ultimo backup logico del esquema usando Oracle Data Pump.
REM
REM USO:
REM   backup_exportar.bat usuario/password@localhost:1521/XEPDB1 NOMBRE_ESQUEMA
REM
REM EJEMPLO:
REM   backup_exportar.bat system/Admin123@localhost:1521/XEPDB1 GO25003
REM
REM REQUISITOS:
REM   1. Tener expdp disponible en PATH.
REM   2. Ejecutar antes 10_configurar_directorio_backup.sql.
REM   3. Reemplazar NOMBRE_ESQUEMA por el propietario real de las tablas.
REM =====================================================================

if "%~1"=="" (
    echo Error: falta la cadena de conexion.
    echo Uso: backup_exportar.bat usuario/password@host:puerto/servicio NOMBRE_ESQUEMA
    exit /b 1
)

if "%~2"=="" (
    echo Error: falta el nombre del esquema.
    echo Uso: backup_exportar.bat usuario/password@host:puerto/servicio NOMBRE_ESQUEMA
    exit /b 1
)

set "CONEXION=%~1"
set "ESQUEMA=%~2"
set "DIRECTORIO=GP_BACKUP_DIR"
set "DUMPFILE=gestion_proyectos_%ESQUEMA%_ultimo.dmp"
set "LOGFILE=gestion_proyectos_%ESQUEMA%_backup.log"

echo Generando backup del esquema %ESQUEMA%...
echo Archivo dump: %DUMPFILE%
echo Archivo log : %LOGFILE%

expdp "%CONEXION%" ^
    schemas=%ESQUEMA% ^
    directory=%DIRECTORIO% ^
    dumpfile=%DUMPFILE% ^
    logfile=%LOGFILE% ^
    reuse_dumpfiles=Y

if errorlevel 1 (
    echo.
    echo Error: el backup no se genero correctamente. Revisar el log de Data Pump.
    exit /b 1
)

echo.
echo Backup generado correctamente.
echo Ultimo backup disponible: %DUMPFILE%
endlocal
