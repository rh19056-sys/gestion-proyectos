
SET SERVEROUTPUT ON;

PROMPT ==========================================
PROMPT PRUEBAS DE PROCEDIMIENTOS
PROMPT ==========================================

BEGIN
    sp_resumen_periodo(
        DATE '2026-01-01',
        DATE '2026-12-31'
    );
END;
/

BEGIN
    sp_top_elementos(3);
END;
/

BEGIN
    sp_indicadores_categoria(
        DATE '2026-01-01',
        DATE '2026-12-31'
    );
END;
/

BEGIN
    sp_alertas_negocio(30);
END;
/

