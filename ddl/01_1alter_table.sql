-- =====================================================
-- RESTRICCIONES ADICIONALES
-- Ejecutar despues de 01_ddl.sql
-- =====================================================


SET SQLBLANKLINES ON;

-- =====================================================
-- CATEGORIA
-- =====================================================

ALTER TABLE categoria
ADD CONSTRAINT uq_categoria_nombre
UNIQUE (nombre_categoria);

ALTER TABLE categoria
ADD CONSTRAINT chk_categoria_nombre_trim
CHECK (TRIM(nombre_categoria) IS NOT NULL);

-- =====================================================
-- PROYECTO
-- =====================================================

ALTER TABLE proyecto
ADD CONSTRAINT uq_proyecto_nombre
UNIQUE (nombre_proyecto);

ALTER TABLE proyecto
ADD CONSTRAINT chk_proyecto_nombre_trim
CHECK (TRIM(nombre_proyecto) IS NOT NULL);

ALTER TABLE proyecto
ADD CONSTRAINT chk_proyecto_fechas
CHECK (
    fecha_inicio IS NULL
    OR fecha_fin IS NULL
    OR fecha_fin >= fecha_inicio
);

-- =====================================================
-- EMPLEADO
-- =====================================================


ALTER TABLE empleado ADD (
    CONSTRAINT chk_empleado_nombre_trim CHECK (TRIM(nombre) IS NOT NULL),
    CONSTRAINT chk_empleado_apellido_trim CHECK (TRIM(apellido) IS NOT NULL)
);

ALTER TABLE empleado
ADD CONSTRAINT chk_empleado_correo
CHECK (
    correo IS NULL
    OR REGEXP_LIKE(correo, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$')
);

-- =====================================================
-- TELEFONO
-- =====================================================

ALTER TABLE telefono
DROP CONSTRAINT chk_telefono_formato;

ALTER TABLE telefono
ADD CONSTRAINT chk_telefono_formato
CHECK (
    REGEXP_LIKE(
        telefono,
        '^[[:digit:][:space:]+-]{7,20}$'
    )
);
-- =====================================================
-- TAREA
-- =====================================================

ALTER TABLE tarea
ADD CONSTRAINT chk_tarea_titulo_trim
CHECK (TRIM(titulo_tarea) IS NOT NULL);

ALTER TABLE tarea
ADD CONSTRAINT chk_tarea_fechas
CHECK (
    fecha_creacion IS NULL
    OR fecha_entrega IS NULL
    OR fecha_entrega >= fecha_creacion
);

-- =====================================================
-- DOCUMENTO
-- =====================================================

ALTER TABLE documento
ADD CONSTRAINT chk_documento_nombre_trim
CHECK (TRIM(nombre_documento) IS NOT NULL);

-- =====================================================
-- RIESGO
-- =====================================================

ALTER TABLE riesgo
ADD CONSTRAINT chk_riesgo_desc_trim
CHECK (TRIM(descripcion_riesgo) IS NOT NULL);

-- =====================================================
-- HITO
-- =====================================================

ALTER TABLE hito
ADD CONSTRAINT chk_hito_nombre_trim
CHECK (TRIM(nombre_hito) IS NOT NULL);
     