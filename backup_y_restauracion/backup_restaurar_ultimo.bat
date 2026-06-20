@echo off
setlocal

REM =====================================================================
REM ARCHIVO: backup_restaurar_ultimo.bat
REM DESCRIPCION:
REM   Restaura el ultimo backup logico generado con backup_exportar.bat.
REM
REM USO:
REM   backup_restaurar_ultimo.bat usuario/password@localhost:1521/XEPDB1 NOMBRE_ESQUEMA
REM
REM EJEMPLO:
REM   backup_restaurar_ultimo.bat system/Admin123@localhost:1521/XEPDB1 GO25003
REM
REM ADVERTENCIA:
REM   Esta restauracion puede reemplazar datos existentes del esquema.
REM   Usar primero en una base de pruebas si hay dudas.
REM =====================================================================

if "%~1"=="" (
    echo Error: falta la cadena de conexion.
    echo Uso: backup_restaurar_ultimo.bat usuario/password@host:puerto/servicio NOMBRE_ESQUEMA
    exit /b 1
)

if "%~2"=="" (
    echo Error: falta el nombre del esquema.
    echo Uso: backup_restaurar_ultimo.bat usuario/password@host:puerto/servicio NOMBRE_ESQUEMA
    exit /b 1
)

set "CONEXION=%~1"
set "ESQUEMA=%~2"
set "DIRECTORIO=GP_BACKUP_DIR"
set "DUMPFILE=gestion_proyectos_%ESQUEMA%_ultimo.dmp"
set "LOGFILE=gestion_proyectos_%ESQUEMA%_restore.log"

echo Restaurando ultimo backup del esquema %ESQUEMA%...
echo Archivo dump: %DUMPFILE%
echo Archivo log : %LOGFILE%
echo.
echo ADVERTENCIA: esta accion puede reemplazar tablas y datos existentes.
choice /C SN /M "Desea continuar"
if errorlevel 2 (
    echo Restauracion cancelada.
    exit /b 0
)

impdp "%CONEXION%" ^
    schemas=%ESQUEMA% ^
    directory=%DIRECTORIO% ^
    dumpfile=%DUMPFILE% ^
    logfile=%LOGFILE% ^
    table_exists_action=replace

if errorlevel 1 (
    echo.
    echo Error: la restauracion no finalizo correctamente. Revisar el log de Data Pump.
    exit /b 1
)

echo.
echo Restauracion finalizada correctamente.
endlocal
