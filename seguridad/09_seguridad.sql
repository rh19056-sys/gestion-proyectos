-- =====================================================================
-- ARCHIVO: 08_seguridad.sql
-- DESCRIPCIÓN: Creación de usuarios y asignación de privilegios.
-----------------------------------------------------------------

-- IMPORTANTE:
-- 1. Este script está diseñado para ejecutarse en una PDB
--    (XEPDB1, XEPDB21, etc.).
-- 2. NO utiliza usuarios C## ni _ORACLE_SCRIPT.
-- 3. La creación de usuarios debe ejecutarse como SYSTEM.
-- 4. Los GRANT sobre tablas, vistas, secuencias, funciones,
--    procedimientos y paquetes deben ejecutarse desde el
--    esquema propietario de dichos objetos.
-- =====================================================================

-- =====================================================================
-- PARTE 1 - EJECUTAR COMO SYSTEM
-- =====================================================================

CREATE USER usr_lectura IDENTIFIED BY "Lectura2026#";

CREATE USER usr_admin IDENTIFIED BY "Admin2026#";

ALTER USER usr_lectura QUOTA UNLIMITED ON USERS;
ALTER USER usr_admin QUOTA UNLIMITED ON USERS;

GRANT CREATE SESSION TO usr_lectura;
GRANT CREATE SESSION TO usr_admin;

-- =====================================================================
-- PARTE 2 - EJECUTAR COMO EL USUARIO DUEÑO DEL ESQUEMA
-- =====================================================================
------------------------------------------------------------------------

-- Ejemplo:
-- Si las tablas PROYECTO, TAREA, ASIGNACION, etc. fueron creadas
-- por el usuario GO25003, entonces debe iniciarse sesión con
-- GO25003 para ejecutar los siguientes GRANT.
----------------------------------------------

-- Para verificar el propietario:

-- SELECT owner, table_name
-- FROM all_tables
-- WHERE table_name IN (
--     'PROYECTO',
--     'TAREA',
--     'ASIGNACION',
--     'EMPLEADO',
--     'CATEGORIA',
--     'DOCUMENTO',
--     'RIESGO',
--     'HITO',
--     'LOG_ERRORES'
-- );
-----

-- =====================================================================

-- =====================================================================
-- PRIVILEGIOS PARA usr_lectura
-- =====================================================================

GRANT SELECT ON proyecto   TO usr_lectura;
GRANT SELECT ON tarea      TO usr_lectura;
GRANT SELECT ON asignacion TO usr_lectura;
GRANT SELECT ON empleado   TO usr_lectura;
GRANT SELECT ON categoria  TO usr_lectura;
GRANT SELECT ON documento  TO usr_lectura;
GRANT SELECT ON riesgo     TO usr_lectura;
GRANT SELECT ON hito       TO usr_lectura;
GRANT SELECT ON recurso    TO usr_lectura;

GRANT SELECT ON v_reporte_tareas               TO usr_lectura;
GRANT SELECT ON v_dashboard_empleados          TO usr_lectura;
GRANT SELECT ON mv_resumen_gerencial_proyectos TO usr_lectura;

-- Si existen vistas de consulta:

-- GRANT SELECT ON vista_resumen_proyectos TO usr_lectura;
-- GRANT SELECT ON vista_xxxxx             TO usr_lectura;

-- =====================================================================
-- PRIVILEGIOS PARA usr_admin
-- =====================================================================

-- Acceso a tabla de auditoría / errores

GRANT SELECT, INSERT, UPDATE, DELETE ON log_errores        TO usr_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON auditoria_proyecto TO usr_admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON auditoria_log      TO usr_admin;

-- Si existe alguna tabla adicional de auditoría:

-- GRANT SELECT, INSERT, UPDATE, DELETE
-- ON auditoria
-- TO usr_admin;

-- =====================================================================
-- EJECUCIÓN DE PROCEDIMIENTOS ALMACENADOS
-- =====================================================================

GRANT EXECUTE ON sp_resumen_periodo       TO usr_admin;
GRANT EXECUTE ON sp_top_elementos         TO usr_admin;
GRANT EXECUTE ON sp_indicadores_categoria TO usr_admin;
GRANT EXECUTE ON sp_alertas_negocio       TO usr_admin;


-- Si existen funciones:

-- GRANT EXECUTE ON fn_nombre_funcion TO usr_admin;

-- =====================================================================
-- PRUEBAS DE SEGURIDAD
-- =====================================================================

/*

PRUEBA 1 - USUARIO DE LECTURA

Conectarse como:

Usuario: usr_lectura
Password: Lectura2026#

Debe funcionar:

SELECT * FROM proyecto;

SELECT * FROM tarea;

SELECT * FROM nombre_esquema.recurso;

SELECT * FROM nombre_esquema.v_dashboard_empleados;

SELECT * FROM nombre_esquema.v_reporte_tareas;

Debe fallar:

INSERT INTO proyecto
VALUES (...);

UPDATE proyecto
SET nombre_proyecto = 'TEST';

DELETE FROM proyecto
WHERE id_proyecto = 1;

-- Intentar ejecutar un procedimiento almacenado (debe fallar por falta de privilegios)

EXEC nombre_esquema.sp_alertas_negocio(7);
---

PRUEBA 2 - USUARIO ADMINISTRADOR

Conectarse como:

Usuario: usr_admin
Password: Admin2026#

Debe funcionar:

SELECT * FROM log_errores;

EXEC sp_alertas_negocio(7);

EXEC sp_resumen_periodo(...);

Debe fallar:

CREATE TABLE prueba (
id NUMBER
);

ALTER TABLE proyecto
ADD columna_prueba NUMBER;

DROP TABLE proyecto;

---

VERIFICACIÓN DE PRIVILEGIOS

SELECT *
FROM user_role_privs;

SELECT *
FROM user_sys_privs;

SELECT *
FROM user_tab_privs;

*/

-- =====================================================================
-- FIN DEL SCRIPT
-- =====================================================================


