
SET SERVEROUTPUT ON;

PROMPT ==========================================
PROMPT PRUEBAS DE ERRORES CONTROLADOS
PROMPT ==========================================

BEGIN
    sp_top_elementos(0);
END;
/

BEGIN
    sp_resumen_periodo(
        DATE '2026-12-31',
        DATE '2026-01-01'
    );
END;
/

BEGIN
    sp_indicadores_categoria(
        DATE '2026-12-31',
        DATE '2026-01-01'
    );
END;
/

PROMPT ==========================================
PROMPT CONTENIDO DE LOG_ERRORES
PROMPT ==========================================

SELECT *
FROM log_errores
ORDER BY id_log DESC;
