-- =====================================================================
-- ARCHIVO: 11_verificar_backup.sql
-- DESCRIPCION:
--   Consultas de evidencia despues de restaurar el ultimo backup.
--   Sirven para demostrar que los objetos principales existen y tienen
--   datos/estructura disponible.
--
-- EJECUTAR COMO:
--   Usuario propietario del esquema restaurado.
-- =====================================================================

SET SERVEROUTPUT ON;

PROMPT ================================================================
PROMPT VERIFICACION DE OBJETOS PRINCIPALES
PROMPT ================================================================

SELECT table_name
FROM user_tables
WHERE table_name IN (
    'CATEGORIA',
    'PROYECTO',
    'EMPLEADO',
    'TELEFONO',
    'TAREA',
    'RECURSO',
    'ASIGNACION',
    'DOCUMENTO',
    'RIESGO',
    'HITO',
    'AUDITORIA_PROYECTO',
    'LOG_ERRORES',
    'AUDITORIA_LOG'
)
ORDER BY table_name;

PROMPT ================================================================
PROMPT CONTEO DE REGISTROS POR TABLA DE NEGOCIO
PROMPT ================================================================

SELECT 'CATEGORIA' AS tabla, COUNT(*) AS total FROM categoria
UNION ALL SELECT 'PROYECTO', COUNT(*) FROM proyecto
UNION ALL SELECT 'EMPLEADO', COUNT(*) FROM empleado
UNION ALL SELECT 'TELEFONO', COUNT(*) FROM telefono
UNION ALL SELECT 'TAREA', COUNT(*) FROM tarea
UNION ALL SELECT 'RECURSO', COUNT(*) FROM recurso
UNION ALL SELECT 'ASIGNACION', COUNT(*) FROM asignacion
UNION ALL SELECT 'DOCUMENTO', COUNT(*) FROM documento
UNION ALL SELECT 'RIESGO', COUNT(*) FROM riesgo
UNION ALL SELECT 'HITO', COUNT(*) FROM hito;

PROMPT ================================================================
PROMPT VISTAS Y PROCEDIMIENTOS
PROMPT ================================================================

SELECT object_name, object_type, status
FROM user_objects
WHERE object_name IN (
    'V_REPORTE_TAREAS',
    'V_DASHBOARD_EMPLEADOS',
    'MV_RESUMEN_GERENCIAL_PROYECTOS',
    'SP_RESUMEN_PERIODO',
    'SP_TOP_ELEMENTOS',
    'SP_INDICADORES_CATEGORIA',
    'SP_ALERTAS_NEGOCIO'
)
ORDER BY object_type, object_name;

-- =====================================================================
-- FIN DEL SCRIPT
-- =====================================================================
