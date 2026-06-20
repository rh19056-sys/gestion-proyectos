-- ARCHIVO: master.sql
-- DESCRIPCIÓN:
--   Ejecuta en orden todos los scripts del proyecto.
--   Debe correrse desde SQL*Plus estando conectado a XEPDB1
--   con el usuario adecuado (ej. gestionproyectosdpb).

-- 1. Estructura de base de datos
@C:\Users\Uber\gestion-proyectos\ddl\01_ddl.sql
@C:\Users\Uber\gestion-proyectos\ddl\01_1alter_table.sql

-- 2. Triggers (antes de procedimientos)
@C:\Users\Uber\gestion-proyectos\triggers\08_triggers.sql

-- 3. Procedimientos
@C:\Users\Uber\gestion-proyectos\procedimientos\07_procedimientos.sql

-- 4. Datos de prueba (DML)
@C:\Users\Uber\gestion-proyectos\dml\02_dml.sql

-- 5. Subconsultas y vistas
@C:\Users\Uber\gestion-proyectos\vistas_y_reportes\03_innerjoins.sql
@C:\Users\Uber\gestion-proyectos\vistas_y_reportes\04_agregados.sql
@C:\Users\Uber\gestion-proyectos\vistas_y_reportes\05_subconsultas.sql
@C:\Users\Uber\gestion-proyectos\vistas_y_reportes\06_vistas.sql

-- 6. Seguridad (roles y permisos)
@C:\Users\Uber\gestion-proyectos\seguridad\09_seguridad.sql

-- FIN DEL SCRIPT MAESTRO
