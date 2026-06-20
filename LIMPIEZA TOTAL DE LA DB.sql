-- =====================================================
-- LIMPIEZA TOTAL DEL PROYECTO
-- =====================================================

SET SQLBLANKLINES ON;

-- =====================================================
-- TRIGGERS
-- =====================================================

DROP TRIGGER TRG_AUDITORIA_LOG_ERRORES;

-- =====================================================
-- VISTAS
-- =====================================================

DROP VIEW V_DASHBOARD_EMPLEADOS;
DROP VIEW V_REPORTE_TAREAS;

-- =====================================================
-- VISTAS MATERIALIZADAS
-- =====================================================

DROP MATERIALIZED VIEW MV_RESUMEN_GERENCIAL_PROYECTOS;

-- =====================================================
-- PROCEDIMIENTOS
-- =====================================================

DROP PROCEDURE SP_ALERTAS_NEGOCIO;
DROP PROCEDURE SP_RESUMEN_PERIODO;
DROP PROCEDURE SP_INDICADORES_CATEGORIA;
DROP PROCEDURE SP_TOP_ELEMENTOS;

-- =====================================================
-- TABLAS DE AUDITORÍA
-- =====================================================

DROP TABLE AUDITORIA_LOG CASCADE CONSTRAINTS;
DROP TABLE AUDITORIA_PROYECTO CASCADE CONSTRAINTS;
DROP TABLE LOG_ERRORES CASCADE CONSTRAINTS;

-- =====================================================
-- TABLAS PRINCIPALES
-- =====================================================

DROP TABLE telefono CASCADE CONSTRAINTS;
DROP TABLE asignacion CASCADE CONSTRAINTS;
DROP TABLE tarea CASCADE CONSTRAINTS;
DROP TABLE documento CASCADE CONSTRAINTS;
DROP TABLE riesgo CASCADE CONSTRAINTS;
DROP TABLE hito CASCADE CONSTRAINTS;
DROP TABLE empleado CASCADE CONSTRAINTS;
DROP TABLE proyecto CASCADE CONSTRAINTS;
DROP TABLE categoria CASCADE CONSTRAINTS;
DROP TABLE recurso CASCADE CONSTRAINTS;

-- =====================================================
-- SECUENCIAS PERSONALIZADAS
-- =====================================================

DROP SEQUENCE SEQ_AUDITORIA;
DROP SEQUENCE SEQ_AUDITORIA_LOG;
DROP SEQUENCE SEQ_LOG_ERRORES;

-- =====================================================
-- USUARIOS DE SEGURIDAD
-- =====================================================

DROP USER usr_lectura CASCADE;
DROP USER usr_admin CASCADE;

COMMIT;