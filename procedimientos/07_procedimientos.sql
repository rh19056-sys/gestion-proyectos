--  =====================================================================
--  ARCHIVO: 07_procedimientos.sql (VERSION CORREGIDA Y DEPURADA)
--  =====================================================================

CREATE OR REPLACE PROCEDURE sp_resumen_periodo (
    p_fecha_inicio IN DATE,
    p_fecha_fin    IN DATE
)
AS
    v_total_proyectos    NUMBER;
    v_tareas_por_iniciar NUMBER;
    v_tareas_en_dev      NUMBER;
    v_tareas_finalizadas NUMBER;
    v_tareas_en_pausa    NUMBER;
    v_total_tareas       NUMBER;
    v_total_horas        NUMBER;
    v_promedio_horas     NUMBER;
    v_total_documentos   NUMBER;
    v_total_riesgos      NUMBER;
    v_total_hitos        NUMBER;
    v_hitos_periodo      NUMBER;
    v_total_empleados    NUMBER;
    v_tareas_vencidas    NUMBER;
 
    -- Error personalizado: rango de fechas inválido
    e_rango_invalido EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_rango_invalido, -20001);
BEGIN
    -- Validación de parámetros
    IF p_fecha_inicio IS NULL OR p_fecha_fin IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'sp_resumen_periodo: Las fechas no pueden ser NULL.');
    END IF;
    IF p_fecha_inicio > p_fecha_fin THEN
        RAISE_APPLICATION_ERROR(-20001, 'sp_resumen_periodo: fecha_inicio no puede ser mayor que fecha_fin.');
    END IF;
 
    SELECT COUNT(*)
      INTO v_total_proyectos
      FROM proyecto
     WHERE fecha_inicio BETWEEN p_fecha_inicio AND p_fecha_fin;
 
    SELECT
        SUM(CASE WHEN estado_tarea = 'POR INICIAR'   THEN 1 ELSE 0 END),
        SUM(CASE WHEN estado_tarea = 'EN DESARROLLO' THEN 1 ELSE 0 END),
        SUM(CASE WHEN estado_tarea = 'FINALIZADO'    THEN 1 ELSE 0 END),
        SUM(CASE WHEN estado_tarea = 'EN PAUSA'      THEN 1 ELSE 0 END),
        COUNT(*)
      INTO
        v_tareas_por_iniciar, v_tareas_en_dev,
        v_tareas_finalizadas, v_tareas_en_pausa, v_total_tareas
      FROM tarea
     WHERE fecha_creacion BETWEEN p_fecha_inicio AND p_fecha_fin;
 
    SELECT COUNT(*)
      INTO v_tareas_vencidas
      FROM tarea
     WHERE fecha_creacion BETWEEN p_fecha_inicio AND p_fecha_fin
       AND fecha_entrega  < SYSDATE
       AND estado_tarea  <> 'FINALIZADO';
 
    SELECT NVL(SUM(a.horas_estimadas), 0), ROUND(NVL(AVG(a.horas_estimadas), 0), 2)
      INTO v_total_horas, v_promedio_horas
      FROM asignacion a
      JOIN tarea      t ON t.id_tarea = a.id_tarea
     WHERE t.fecha_creacion BETWEEN p_fecha_inicio AND p_fecha_fin;
 
    SELECT COUNT(*)
      INTO v_total_documentos
      FROM documento d
      JOIN proyecto  p ON p.id_proyecto = d.id_proyecto
     WHERE p.fecha_inicio BETWEEN p_fecha_inicio AND p_fecha_fin;
 
    SELECT COUNT(*)
      INTO v_total_riesgos
      FROM riesgo   r
      JOIN proyecto p ON p.id_proyecto = r.id_proyecto
     WHERE p.fecha_inicio BETWEEN p_fecha_inicio AND p_fecha_fin;
 
    SELECT COUNT(*)
      INTO v_total_hitos
      FROM hito     h
      JOIN proyecto p ON p.id_proyecto = h.id_proyecto
     WHERE p.fecha_inicio BETWEEN p_fecha_inicio AND p_fecha_fin;
 
    SELECT COUNT(*)
      INTO v_hitos_periodo
      FROM hito
     WHERE fecha_hito BETWEEN p_fecha_inicio AND p_fecha_fin;
 
    SELECT COUNT(DISTINCT a.id_empleado)
      INTO v_total_empleados
      FROM asignacion a
      JOIN tarea      t ON t.id_tarea = a.id_tarea
     WHERE t.fecha_creacion BETWEEN p_fecha_inicio AND p_fecha_fin;
 
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('  RESUMEN GERENCIAL DEL PERÍODO');
    DBMS_OUTPUT.PUT_LINE('  Desde : ' || TO_CHAR(p_fecha_inicio,'DD/MM/YYYY')
                      || '   Hasta: ' || TO_CHAR(p_fecha_fin,   'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('PROYECTOS INICIADOS EN EL PERÍODO : ' || v_total_proyectos);
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('TAREAS CREADAS EN EL PERÍODO      : ' || v_total_tareas);
    DBMS_OUTPUT.PUT_LINE('  - Por Iniciar                   : ' || v_tareas_por_iniciar);
    DBMS_OUTPUT.PUT_LINE('  - En Desarrollo                 : ' || v_tareas_en_dev);
    DBMS_OUTPUT.PUT_LINE('  - Finalizadas                   : ' || v_tareas_finalizadas);
    DBMS_OUTPUT.PUT_LINE('  - En Pausa                      : ' || v_tareas_en_pausa);
    DBMS_OUTPUT.PUT_LINE('  - Vencidas sin finalizar        : ' || v_tareas_vencidas);
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('HORAS TOTALES ASIGNADAS           : ' || v_total_horas);
    DBMS_OUTPUT.PUT_LINE('PROMEDIO DE HORAS POR TAREA       : ' || v_promedio_horas);
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('DOCUMENTOS REGISTRADOS            : ' || v_total_documentos);
    DBMS_OUTPUT.PUT_LINE('RIESGOS IDENTIFICADOS             : ' || v_total_riesgos);
    DBMS_OUTPUT.PUT_LINE('HITOS DEL PROYECTO (período)      : ' || v_total_hitos);
    DBMS_OUTPUT.PUT_LINE('HITOS POR FECHA DE OCURRENCIA     : ' || v_hitos_periodo);
    DBMS_OUTPUT.PUT_LINE('--------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('EMPLEADOS INVOLUCRADOS            : ' || v_total_empleados);
    DBMS_OUTPUT.PUT_LINE('============================================');
 
    COMMIT;
 
EXCEPTION
    WHEN e_rango_invalido THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
WHEN NO_DATA_FOUND THEN
    ROLLBACK;

    DECLARE 
        v_params  VARCHAR2(500);
        v_usuario VARCHAR2(100);
        v_error   VARCHAR2(4000);
    BEGIN
        v_usuario := USER;
        v_error   := 'NO_DATA_FOUND: sin datos para el período.';

        v_params := 'inicio=' || TO_CHAR(p_fecha_inicio,'DD/MM/YYYY')
                    || ' fin=' || TO_CHAR(p_fecha_fin,'DD/MM/YYYY');

        INSERT INTO log_errores (
            id_log,
            procedimiento,
            mensaje_error,
            usuario_oracle,
            parametros
        )
        VALUES (
            seq_log_errores.NEXTVAL,
            'SP_RESUMEN_PERIODO',
            v_error,
            v_usuario,
            v_params
        );

        COMMIT;
    END;

    DBMS_OUTPUT.PUT_LINE(
        '[sp_resumen_periodo] Sin datos para el período indicado.'
    );
    WHEN TOO_MANY_ROWS THEN
    ROLLBACK;

    DECLARE 
        v_params  VARCHAR2(500);
        v_usuario VARCHAR2(100);
        v_error   VARCHAR2(4000);
    BEGIN
        v_usuario := USER;
        v_error   := 'TOO_MANY_ROWS: consulta retornó múltiples filas inesperadamente.';

        v_params := 'inicio=' || TO_CHAR(p_fecha_inicio,'DD/MM/YYYY')
                    || ' fin=' || TO_CHAR(p_fecha_fin,'DD/MM/YYYY');

        INSERT INTO log_errores (
            id_log,
            procedimiento,
            mensaje_error,
            usuario_oracle,
            parametros
        )
        VALUES (
            seq_log_errores.NEXTVAL,
            'SP_RESUMEN_PERIODO',
            v_error,
            v_usuario,
            v_params
        );

        COMMIT;
    END;

    DBMS_OUTPUT.PUT_LINE(
        '[sp_resumen_periodo] Error: demasiadas filas. Ver LOG_ERRORES.'
    );

    RAISE;
END sp_resumen_periodo;
/

SHOW ERRORS;

create or replace PROCEDURE sp_top_elementos (
    p_n IN NUMBER
)
AS
    CURSOR cur_top_empleados IS
        SELECT e.nombre AS nombre_empleado, -- <--- Aquí tiene alias
               NVL(SUM(a.horas_estimadas), 0)       AS total_horas,
               COUNT(DISTINCT a.id_tarea)  AS tareas_asignadas
          FROM empleado e
          LEFT JOIN asignacion a ON a.id_empleado = e.id_empleado
         GROUP BY e.id_empleado, e.nombre, e.apellido
         ORDER BY total_horas DESC
         FETCH FIRST p_n ROWS ONLY;

    CURSOR cur_top_proyectos IS
        SELECT p.nombre_proyecto,
               c.nombre_categoria,
               COUNT(t.id_tarea)  AS total_tareas,
               SUM(CASE WHEN t.estado_tarea = 'FINALIZADO' THEN 1 ELSE 0 END) AS tareas_fin,
               ROUND(AVG(CASE WHEN t.estado_tarea = 'FINALIZADO'
                              THEN t.fecha_entrega - t.fecha_creacion END), 1) AS dias_prom_entrega
          FROM proyecto   p
          JOIN categoria  c ON c.id_categoria = p.id_categoria
          LEFT JOIN tarea t ON t.id_proyecto  = p.id_proyecto
         GROUP BY p.id_proyecto, p.nombre_proyecto, c.nombre_categoria
         ORDER BY total_tareas DESC
         FETCH FIRST p_n ROWS ONLY;

    CURSOR cur_top_categorias IS
        SELECT c.nombre_categoria,
               COUNT(DISTINCT p.id_proyecto) AS total_proyectos,
               COUNT(t.id_tarea)             AS total_tareas,
               NVL(SUM(a.horas_estimadas), 0)          AS total_horas
          FROM categoria   c
          LEFT JOIN proyecto   p ON p.id_categoria = c.id_categoria
          LEFT JOIN tarea      t ON t.id_proyecto  = p.id_proyecto
          LEFT JOIN asignacion a ON a.id_tarea     = t.id_tarea
         GROUP BY c.id_categoria, c.nombre_categoria
         ORDER BY total_proyectos DESC
         FETCH FIRST p_n ROWS ONLY;

    v_rank NUMBER := 0;
    v_pct  NUMBER;

    e_n_invalido EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_n_invalido, -20002);
BEGIN
    IF p_n IS NULL OR p_n <= 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'sp_top_elementos: el parámetro N debe ser mayor que 0.');
    END IF;

    -- Top N empleados
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('  TOP ' || p_n || ' EMPLEADOS POR HORAS ASIGNADAS');
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE(RPAD('#',4) || RPAD('EMPLEADO',32) || RPAD('HORAS',10) || 'TAREAS');
    DBMS_OUTPUT.PUT_LINE(RPAD('-',55,'-'));
    v_rank := 0;
    FOR rec IN cur_top_empleados LOOP
        v_rank := v_rank + 1;
        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_rank,              4) || RPAD(rec.nombre_empleado,32) || -- <--- CORREGIDO AQUÍ
            RPAD(rec.total_horas,    10) || rec.tareas_asignadas);
    END LOOP;

    -- Top N proyectos
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('  TOP ' || p_n || ' PROYECTOS POR VOLUMEN DE TAREAS');
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE(RPAD('#',4) || RPAD('PROYECTO',32)
                      || RPAD('TAREAS',8) || RPAD('% COMP.',9) || 'DÍAS PROM. ENTREGA');
    DBMS_OUTPUT.PUT_LINE(RPAD('-',65,'-'));
    v_rank := 0;
    FOR rec IN cur_top_proyectos LOOP
        v_rank := v_rank + 1;
        v_pct  := ROUND(rec.tareas_fin / NULLIF(rec.total_tareas,0) * 100, 1);
        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_rank,             4) || RPAD(rec.nombre_proyecto,32) ||
            RPAD(rec.total_tareas,   8) || RPAD(NVL(v_pct,0)||'%',9) ||
            NVL(TO_CHAR(rec.dias_prom_entrega),'N/D'));
    END LOOP;

    -- Top N categorías
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('  TOP ' || p_n || ' CATEGORÍAS POR CONCENTRACIÓN');
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE(RPAD('#',4) || RPAD('CATEGORÍA',28)
                      || RPAD('PROY.',8) || RPAD('TAREAS',8) || 'HORAS');
    DBMS_OUTPUT.PUT_LINE(RPAD('-',55,'-'));
    v_rank := 0;
    FOR rec IN cur_top_categorias LOOP
        v_rank := v_rank + 1;
        DBMS_OUTPUT.PUT_LINE(
            RPAD(v_rank,               4) || RPAD(rec.nombre_categoria,28) ||
            RPAD(rec.total_proyectos,  8) || RPAD(rec.total_tareas,8) || rec.total_horas);
    END LOOP;

    COMMIT;

EXCEPTION
    WHEN e_n_invalido THEN
        ROLLBACK;
        DECLARE 
            v_params  VARCHAR2(500);
            v_usuario VARCHAR2(100);
            v_error   VARCHAR2(4000);
        BEGIN
            v_usuario := USER;
            v_error   := 'RAISE_APPLICATION_ERROR: sp_top_elementos: el parámetro N debe ser mayor que 0.';
            v_params := 'N=' || TO_CHAR(p_n);
            INSERT INTO log_errores (id_log, procedimiento, mensaje_error, usuario_oracle, parametros)
            VALUES (seq_log_errores.NEXTVAL, 'SP_TOP_ELEMENTOS', v_error, v_usuario, v_params);
            COMMIT;
        END;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DECLARE 
            v_params  VARCHAR2(500);
            v_usuario VARCHAR2(100);
            v_error   VARCHAR2(4000);
        BEGIN
            v_usuario := USER;
            v_error   := 'NO_DATA_FOUND: sin datos para el ranking.';
            v_params := 'N=' || TO_CHAR(p_n);
            INSERT INTO log_errores (id_log, procedimiento, mensaje_error, usuario_oracle, parametros)
            VALUES (seq_log_errores.NEXTVAL, 'SP_TOP_ELEMENTOS', v_error, v_usuario, v_params);
            COMMIT;
        END;
        DBMS_OUTPUT.PUT_LINE('[sp_top_elementos] Sin datos. Ver LOG_ERRORES.');

    WHEN TOO_MANY_ROWS THEN
        ROLLBACK;
        DECLARE 
            v_params  VARCHAR2(500);
            v_usuario VARCHAR2(100);
            v_error   VARCHAR2(4000);
        BEGIN
            v_usuario := USER;
            v_error   := 'TOO_MANY_ROWS inesperado.';
            v_params := 'N=' || TO_CHAR(p_n);
            INSERT INTO log_errores (id_log, procedimiento, mensaje_error, usuario_oracle, parametros)
            VALUES (seq_log_errores.NEXTVAL, 'SP_TOP_ELEMENTOS', v_error, v_usuario, v_params);
            COMMIT;
        END;
        DBMS_OUTPUT.PUT_LINE('[sp_top_elementos] Error: demasiadas filas. Ver LOG_ERRORES.');
        RAISE;
END sp_top_elementos;
/
--ULTIMA MODIFICACION SUBIR A GITHUB




CREATE OR REPLACE PROCEDURE sp_indicadores_categoria (
    p_fecha_inicio IN DATE,
    p_fecha_fin    IN DATE
)
AS
    v_duracion  NUMBER;
    v_ant_ini   DATE;
    v_ant_fin   DATE;
    v_pct_tar   NUMBER;
    v_pct_hrs   NUMBER;
    v_pct_fin   NUMBER;
    v_pct_hit   NUMBER;
 
    CURSOR cur_cat IS
        SELECT
            c.nombre_categoria,
            COUNT(CASE WHEN t.fecha_creacion BETWEEN p_fecha_inicio AND p_fecha_fin
                       THEN t.id_tarea END)                          AS tar_act,
            NVL(SUM(CASE WHEN t.fecha_creacion BETWEEN p_fecha_inicio AND p_fecha_fin
                         THEN a.horas_estimadas END), 0)                       AS hrs_act,
            COUNT(CASE WHEN t.fecha_creacion BETWEEN p_fecha_inicio AND p_fecha_fin
                       AND t.estado_tarea = 'FINALIZADO'
                       THEN t.id_tarea END)                          AS fin_act,
            COUNT(CASE WHEN h.fecha_hito BETWEEN p_fecha_inicio AND p_fecha_fin
                       THEN h.id_hito END)                           AS hit_act,
            COUNT(CASE WHEN t.fecha_creacion BETWEEN v_ant_ini AND v_ant_fin
                       THEN t.id_tarea END)                          AS tar_ant,
            NVL(SUM(CASE WHEN t.fecha_creacion BETWEEN v_ant_ini AND v_ant_fin
                         THEN a.horas_estimadas END), 0)                       AS hrs_ant,
            COUNT(CASE WHEN t.fecha_creacion BETWEEN v_ant_ini AND v_ant_fin
                       AND t.estado_tarea = 'FINALIZADO'
                       THEN t.id_tarea END)                          AS fin_ant,
            COUNT(CASE WHEN h.fecha_hito BETWEEN v_ant_ini AND v_ant_fin
                       THEN h.id_hito END)                           AS hit_ant
        FROM categoria   c
        LEFT JOIN proyecto   p ON p.id_categoria = c.id_categoria
        LEFT JOIN tarea      t ON t.id_proyecto  = p.id_proyecto
        LEFT JOIN asignacion a ON a.id_tarea     = t.id_tarea
        LEFT JOIN hito       h ON h.id_proyecto  = p.id_proyecto
        GROUP BY c.id_categoria, c.nombre_categoria
        ORDER BY c.nombre_categoria;
 
    e_rango_invalido EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_rango_invalido, -20001);
BEGIN
    IF p_fecha_inicio IS NULL OR p_fecha_fin IS NULL THEN
        RAISE_APPLICATION_ERROR(-20001, 'sp_indicadores_categoria: fechas no pueden ser NULL.');
    END IF;
    IF p_fecha_inicio > p_fecha_fin THEN
        RAISE_APPLICATION_ERROR(-20001, 'sp_indicadores_categoria: fecha_inicio mayor que fecha_fin.');
    END IF;
 
    v_duracion := p_fecha_fin - p_fecha_inicio + 1;
    v_ant_ini  := p_fecha_inicio - v_duracion;
    v_ant_fin  := p_fecha_inicio - 1;
 
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('  INDICADORES POR CATEGORÍA CON COMPARATIVO');
    DBMS_OUTPUT.PUT_LINE('  Período actual  : '
        || TO_CHAR(p_fecha_inicio,'DD/MM/YYYY') || ' al '
        || TO_CHAR(p_fecha_fin,  'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('  Período anterior: '
        || TO_CHAR(v_ant_ini,'DD/MM/YYYY') || ' al '
        || TO_CHAR(v_ant_fin,'DD/MM/YYYY'));
    DBMS_OUTPUT.PUT_LINE('============================================');
 
    FOR rec IN cur_cat LOOP
        v_pct_tar := CASE WHEN rec.tar_ant = 0 AND rec.tar_act > 0 THEN 100
                          WHEN rec.tar_ant = 0 THEN 0
                          ELSE ROUND((rec.tar_act-rec.tar_ant)/rec.tar_ant*100,1) END;
        v_pct_hrs := CASE WHEN rec.hrs_ant = 0 AND rec.hrs_act > 0 THEN 100
                          WHEN rec.hrs_ant = 0 THEN 0
                          ELSE ROUND((rec.hrs_act-rec.hrs_ant)/rec.hrs_ant*100,1) END;
        v_pct_fin := CASE WHEN rec.fin_ant = 0 AND rec.fin_act > 0 THEN 100
                          WHEN rec.fin_ant = 0 THEN 0
                          ELSE ROUND((rec.fin_act-rec.fin_ant)/rec.fin_ant*100,1) END;
        v_pct_hit := CASE WHEN rec.hit_ant = 0 AND rec.hit_act > 0 THEN 100
                          WHEN rec.hit_ant = 0 THEN 0
                          ELSE ROUND((rec.hit_act-rec.hit_ant)/rec.hit_ant*100,1) END;
 
        DBMS_OUTPUT.PUT_LINE(' ');
        DBMS_OUTPUT.PUT_LINE('  CATEGORÍA : ' || rec.nombre_categoria);
        DBMS_OUTPUT.PUT_LINE('  ' || RPAD('-',52,'-'));
        DBMS_OUTPUT.PUT_LINE('  ' || RPAD('MÉTRICA',22) || RPAD('ACTUAL',10) || RPAD('ANTERIOR',12) || 'VAR %');
        DBMS_OUTPUT.PUT_LINE('  ' || RPAD('-',52,'-'));
        DBMS_OUTPUT.PUT_LINE('  ' || RPAD('Tareas creadas',   22) || RPAD(rec.tar_act,10) || RPAD(rec.tar_ant,12) || v_pct_tar || '%');
        DBMS_OUTPUT.PUT_LINE('  ' || RPAD('Tareas finalizadas',22) || RPAD(rec.fin_act,10) || RPAD(rec.fin_ant,12) || v_pct_fin || '%');
        DBMS_OUTPUT.PUT_LINE('  ' || RPAD('Horas asignadas',  22) || RPAD(rec.hrs_act,10) || RPAD(rec.hrs_ant,12) || v_pct_hrs || '%');
        DBMS_OUTPUT.PUT_LINE('  ' || RPAD('Hitos ocurridos',  22) || RPAD(rec.hit_act,10) || RPAD(rec.hit_ant,12) || v_pct_hit || '%');
    END LOOP;
 
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('============================================');
 
    COMMIT;
 
EXCEPTION
    WHEN e_rango_invalido THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
WHEN NO_DATA_FOUND THEN
    ROLLBACK;

    DECLARE 
        v_params  VARCHAR2(500);
        v_usuario VARCHAR2(100);
        v_error   VARCHAR2(4000);
    BEGIN
        v_usuario := USER;
        v_error   := 'NO_DATA_FOUND: sin categorías registradas.';

        v_params := 'inicio=' || TO_CHAR(p_fecha_inicio,'DD/MM/YYYY')
                    || ' fin=' || TO_CHAR(p_fecha_fin,'DD/MM/YYYY');

        INSERT INTO log_errores (
            id_log,
            procedimiento,
            mensaje_error,
            usuario_oracle,
            parametros
        )
        VALUES (
            seq_log_errores.NEXTVAL,
            'SP_INDICADORES_CATEGORIA',
            v_error,
            v_usuario,
            v_params
        );

        COMMIT;
    END;

    DBMS_OUTPUT.PUT_LINE(
        '[sp_indicadores_categoria] Sin datos. Ver LOG_ERRORES.'
    );
    WHEN TOO_MANY_ROWS THEN
    ROLLBACK;

    DECLARE 
        v_params  VARCHAR2(500);
        v_usuario VARCHAR2(100);
        v_error   VARCHAR2(4000);
    BEGIN
        v_usuario := USER;
        v_error   := 'TOO_MANY_ROWS inesperado.';

        v_params := 'inicio=' || TO_CHAR(p_fecha_inicio,'DD/MM/YYYY')
                    || ' fin=' || TO_CHAR(p_fecha_fin,'DD/MM/YYYY');

        INSERT INTO log_errores (
            id_log,
            procedimiento,
            mensaje_error,
            usuario_oracle,
            parametros
        )
        VALUES (
            seq_log_errores.NEXTVAL,
            'SP_INDICADORES_CATEGORIA',
            v_error,
            v_usuario,
            v_params
        );

        COMMIT;
    END;

    DBMS_OUTPUT.PUT_LINE(
        '[sp_indicadores_categoria] Error: demasiadas filas. Ver LOG_ERRORES.'
    );
    WHEN OTHERS THEN
    ROLLBACK;

    DECLARE 
        v_params  VARCHAR2(500);
        v_usuario VARCHAR2(100);
        v_error   VARCHAR2(4000);
    BEGIN
        v_usuario := USER;
        v_error   := SQLERRM;

        v_params := 'inicio=' || TO_CHAR(p_fecha_inicio,'DD/MM/YYYY')
                    || ' fin=' || TO_CHAR(p_fecha_fin,'DD/MM/YYYY');

        INSERT INTO log_errores (
            id_log,
            procedimiento,
            mensaje_error,
            usuario_oracle,
            parametros
        )
        VALUES (
            seq_log_errores.NEXTVAL,
            'SP_INDICADORES_CATEGORIA',
            v_error,
            v_usuario,
            v_params
        );

        COMMIT;
    END;

    DBMS_OUTPUT.PUT_LINE(
        '[sp_indicadores_categoria] Error no controlado. Ver LOG_ERRORES.'
    );

    RAISE;
END sp_indicadores_categoria;
/
 
CREATE OR REPLACE PROCEDURE sp_alertas_negocio (
    p_dias_alerta IN NUMBER DEFAULT 7
)
AS
    v_cnt NUMBER;

    CURSOR cur_a1 IS
        SELECT p.id_proyecto, p.nombre_proyecto, c.nombre_categoria
          FROM proyecto p JOIN categoria c ON c.id_categoria = p.id_categoria
         WHERE NOT EXISTS (SELECT 1 FROM tarea t WHERE t.id_proyecto = p.id_proyecto)
         ORDER BY p.nombre_proyecto;

    CURSOR cur_a2 IS
        SELECT t.id_tarea, t.titulo_tarea, p.nombre_proyecto,
               t.fecha_entrega,
               ROUND(SYSDATE - t.fecha_entrega) AS dias_pausa_vencida
          FROM tarea t JOIN proyecto p ON p.id_proyecto = t.id_proyecto
         WHERE t.estado_tarea = 'EN PAUSA'
         ORDER BY t.fecha_entrega NULLS LAST;

    CURSOR cur_a3 IS
        SELECT p.nombre_proyecto, COUNT(t.id_tarea) AS total_tareas
          FROM proyecto p JOIN tarea t ON t.id_proyecto = p.id_proyecto
         WHERE NOT EXISTS (
               SELECT 1 FROM asignacion a
                JOIN tarea t2 ON t2.id_tarea = a.id_tarea
               WHERE t2.id_proyecto = p.id_proyecto)
         GROUP BY p.id_proyecto, p.nombre_proyecto
         ORDER BY total_tareas DESC;

    CURSOR cur_a4 IS
        SELECT e.id_empleado, 
               e.nombre AS nombre_empleado, -- <--- CORREGIDO: Se añade el alias aquí
               NVL(e.correo,'(sin correo)') AS correo
          FROM empleado e
         WHERE NOT EXISTS (SELECT 1 FROM asignacion a WHERE a.id_empleado = e.id_empleado)
         ORDER BY e.nombre;

    CURSOR cur_a5 IS
        SELECT p.nombre_proyecto, COUNT(r.id_riesgo) AS total_riesgos
          FROM proyecto p JOIN riesgo r ON r.id_proyecto = p.id_proyecto
         WHERE NOT EXISTS (SELECT 1 FROM hito h WHERE h.id_proyecto = p.id_proyecto)
         GROUP BY p.id_proyecto, p.nombre_proyecto
         ORDER BY total_riesgos DESC;

    CURSOR cur_a6 IS
        SELECT p.nombre_proyecto,
               TO_CHAR(p.fecha_fin,'DD/MM/YYYY') AS fecha_fin,
               ROUND(p.fecha_fin - SYSDATE)       AS dias_rest
          FROM proyecto p
         WHERE p.fecha_fin BETWEEN SYSDATE AND SYSDATE + p_dias_alerta
         ORDER BY p.fecha_fin;

    CURSOR cur_a7 IS
        SELECT p.nombre_proyecto,
               TO_CHAR(p.fecha_fin,'DD/MM/YYYY') AS fecha_fin,
               COUNT(t.id_tarea)                 AS tareas_pend
          FROM proyecto p JOIN tarea t ON t.id_proyecto = p.id_proyecto
         WHERE p.fecha_fin < SYSDATE
           AND t.estado_tarea <> 'FINALIZADO'
         GROUP BY p.id_proyecto, p.nombre_proyecto, p.fecha_fin
         ORDER BY p.fecha_fin;

    CURSOR cur_a8 IS
        SELECT t.titulo_tarea, p.nombre_proyecto,
               TO_CHAR(t.fecha_entrega,'DD/MM/YYYY') AS fecha_entrega,
               ROUND(SYSDATE - t.fecha_entrega)       AS dias_retraso,
               COUNT(a.id_empleado)                  AS asignados
          FROM tarea      t
          JOIN proyecto   p ON p.id_proyecto  = t.id_proyecto
          LEFT JOIN asignacion a ON a.id_tarea = t.id_tarea
         WHERE t.fecha_entrega < SYSDATE
           AND t.estado_tarea <> 'FINALIZADO'
         GROUP BY t.id_tarea, t.titulo_tarea, p.nombre_proyecto, t.fecha_entrega
         ORDER BY dias_retraso DESC;

    CURSOR cur_a9 IS
        SELECT h.nombre_hito, p.nombre_proyecto,
               TO_CHAR(h.fecha_hito,'DD/MM/YYYY') AS fecha_hito,
               ROUND(h.fecha_hito - SYSDATE)       AS dias_rest
          FROM hito     h
          JOIN proyecto p ON p.id_proyecto = h.id_proyecto
         WHERE h.fecha_hito BETWEEN SYSDATE AND SYSDATE + p_dias_alerta
         ORDER BY h.fecha_hito;

    e_umbral_invalido EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_umbral_invalido, -20003);
BEGIN
    IF p_dias_alerta IS NULL OR p_dias_alerta < 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'sp_alertas_negocio: p_dias_alerta debe ser >= 0.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('  PANEL DE ALERTAS OPERATIVAS');
    DBMS_OUTPUT.PUT_LINE('  Generado : ' || TO_CHAR(SYSDATE,'DD/MM/YYYY HH24:MI'));
    DBMS_OUTPUT.PUT_LINE('  Umbral   : ' || p_dias_alerta || ' días');
    DBMS_OUTPUT.PUT_LINE('============================================');

    SELECT COUNT(*) INTO v_cnt FROM proyecto p
     WHERE NOT EXISTS (SELECT 1 FROM tarea t WHERE t.id_proyecto = p.id_proyecto);
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('[A1] PROYECTOS SIN TAREAS: ' || v_cnt);
    IF v_cnt > 0 THEN
        FOR rec IN cur_a1 LOOP
            DBMS_OUTPUT.PUT_LINE('     ' || RPAD(rec.nombre_proyecto,38) || rec.nombre_categoria);
        END LOOP;
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM tarea WHERE estado_tarea = 'EN PAUSA';
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('[A2] TAREAS EN PAUSA: ' || v_cnt);
    IF v_cnt > 0 THEN
        DBMS_OUTPUT.PUT_LINE('     ' || RPAD('TAREA',30) || RPAD('PROYECTO',28) || 'ENT. VENCIDA');
        FOR rec IN cur_a2 LOOP
            DBMS_OUTPUT.PUT_LINE('     '
                || RPAD(rec.titulo_tarea,   30)
                || RPAD(rec.nombre_proyecto,28)
                || CASE WHEN rec.fecha_entrega < SYSDATE
                        THEN rec.dias_pausa_vencida || ' días de retraso'
                        ELSE NVL(TO_CHAR(rec.fecha_entrega,'DD/MM/YYYY'),'-') END);
        END LOOP;
    END IF;

    SELECT COUNT(DISTINCT p.id_proyecto) INTO v_cnt
      FROM proyecto p JOIN tarea t ON t.id_proyecto = p.id_proyecto
     WHERE NOT EXISTS (
           SELECT 1 FROM asignacion a
            JOIN tarea t2 ON t2.id_tarea = a.id_tarea
           WHERE t2.id_proyecto = p.id_proyecto);
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('[A3] PROYECTOS SIN EQUIPO ASIGNADO: ' || v_cnt);
    IF v_cnt > 0 THEN
        FOR rec IN cur_a3 LOOP
            DBMS_OUTPUT.PUT_LINE('     ' || RPAD(rec.nombre_proyecto,40)
                              || rec.total_tareas || ' tarea(s) sin asignar');
        END LOOP;
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM empleado e
     WHERE NOT EXISTS (SELECT 1 FROM asignacion a WHERE a.id_empleado = e.id_empleado);
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('[A4] EMPLEADOS SIN ASIGNACIONES: ' || v_cnt);
    IF v_cnt > 0 THEN
        FOR rec IN cur_a4 LOOP
            DBMS_OUTPUT.PUT_LINE('     ' || RPAD(rec.nombre_empleado,32) || rec.correo); -- <--- Aquí usa nombre_empleado
        END LOOP;
    END IF;

    SELECT COUNT(DISTINCT p.id_proyecto) INTO v_cnt
      FROM proyecto p JOIN riesgo r ON r.id_proyecto = p.id_proyecto
     WHERE NOT EXISTS (SELECT 1 FROM hito h WHERE h.id_proyecto = p.id_proyecto);
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('[A5] PROYECTOS CON RIESGOS Y SIN HITOS: ' || v_cnt);
    IF v_cnt > 0 THEN
        FOR rec IN cur_a5 LOOP
            DBMS_OUTPUT.PUT_LINE('     ' || RPAD(rec.nombre_proyecto,40)
                              || rec.total_riesgos || ' riesgo(s)');
        END LOOP;
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM proyecto
     WHERE fecha_fin BETWEEN SYSDATE AND SYSDATE + p_dias_alerta;
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('[A6] PROYECTOS QUE VENCEN EN ' || p_dias_alerta || ' DÍAS: ' || v_cnt);
    IF v_cnt > 0 THEN
        DBMS_OUTPUT.PUT_LINE('     ' || RPAD('PROYECTO',38) || RPAD('FECHA FIN',14) || 'DÍAS REST.');
        FOR rec IN cur_a6 LOOP
            DBMS_OUTPUT.PUT_LINE('     '
                || RPAD(rec.nombre_proyecto,38) || RPAD(rec.fecha_fin,14) || rec.dias_rest);
        END LOOP;
    END IF;

    SELECT COUNT(DISTINCT p.id_proyecto) INTO v_cnt
      FROM proyecto p JOIN tarea t ON t.id_proyecto = p.id_proyecto
     WHERE p.fecha_fin < SYSDATE AND t.estado_tarea <> 'FINALIZADO';
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('[A7] PROYECTOS VENCIDOS CON TAREAS PENDIENTES: ' || v_cnt);
    IF v_cnt > 0 THEN
        DBMS_OUTPUT.PUT_LINE('     ' || RPAD('PROYECTO',38) || RPAD('FECHA FIN',14) || 'TAREAS PEND.');
        FOR rec IN cur_a7 LOOP
            DBMS_OUTPUT.PUT_LINE('     '
                || RPAD(rec.nombre_proyecto,38) || RPAD(rec.fecha_fin,14) || rec.tareas_pend);
        END LOOP;
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM tarea
     WHERE fecha_entrega < SYSDATE AND estado_tarea <> 'FINALIZADO';
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('[A8] TAREAS CON ENTREGA VENCIDA: ' || v_cnt);
    IF v_cnt > 0 THEN
        DBMS_OUTPUT.PUT_LINE('     ' || RPAD('TAREA',28) || RPAD('PROYECTO',28)
                          || RPAD('VENCIÓ',13) || RPAD('RETRASO',10) || 'ASIGN.');
        FOR rec IN cur_a8 LOOP
            DBMS_OUTPUT.PUT_LINE('     '
                || RPAD(rec.titulo_tarea,   28) || RPAD(rec.nombre_proyecto,28)
                || RPAD(rec.fecha_entrega,  13) || RPAD(rec.dias_retraso||'d',10)
                || rec.asignados);
        END LOOP;
    END IF;

    SELECT COUNT(*) INTO v_cnt FROM hito
     WHERE fecha_hito BETWEEN SYSDATE AND SYSDATE + p_dias_alerta;
    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('[A9] HITOS EN LOS PRÓXIMOS ' || p_dias_alerta || ' DÍAS: ' || v_cnt);
    IF v_cnt > 0 THEN
        DBMS_OUTPUT.PUT_LINE('     ' || RPAD('HITO',30) || RPAD('PROYECTO',30)
                          || RPAD('FECHA',13) || 'DÍAS REST.');
        FOR rec IN cur_a9 LOOP
            DBMS_OUTPUT.PUT_LINE('     '
                || RPAD(rec.nombre_hito,    30) || RPAD(rec.nombre_proyecto,30)
                || RPAD(rec.fecha_hito, 13) || rec.dias_rest);
        END LOOP;
    END IF;

    DBMS_OUTPUT.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('============================================');
    DBMS_OUTPUT.PUT_LINE('  FIN DEL PANEL DE ALERTAS');
    DBMS_OUTPUT.PUT_LINE('============================================');

    COMMIT;

EXCEPTION
    WHEN e_umbral_invalido THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
    WHEN NO_DATA_FOUND THEN
        ROLLBACK;
        DECLARE 
            v_params  VARCHAR2(500);
            v_usuario VARCHAR2(100);
            v_error   VARCHAR2(4000);
        BEGIN
            v_usuario := USER;
            v_error   := 'NO_DATA_FOUND inesperado.';
            v_params := 'dias_alerta=' || TO_CHAR(p_dias_alerta);
            INSERT INTO log_errores (id_log, procedimiento, mensaje_error, usuario_oracle, parametros)
            VALUES (seq_log_errores.NEXTVAL, 'SP_ALERTAS_NEGOCIO', v_error, v_usuario, v_params);
            COMMIT;
        END;
        DBMS_OUTPUT.PUT_LINE('[sp_alertas_negocio] Sin datos. Ver LOG_ERRORES.');

    WHEN TOO_MANY_ROWS THEN
        ROLLBACK;
        DECLARE 
            v_params  VARCHAR2(500);
            v_usuario VARCHAR2(100);
            v_error   VARCHAR2(4000);
        BEGIN
            v_usuario := USER;
            v_error   := 'TOO_MANY_ROWS inesperado.';
            v_params  := 'dias_alerta=' || TO_CHAR(p_dias_alerta); -- <--- COMPLETADO AQUÍ (Corte de texto original)
            INSERT INTO log_errores (id_log, procedimiento, mensaje_error, usuario_oracle, parametros)
            VALUES (seq_log_errores.NEXTVAL, 'SP_ALERTAS_NEGOCIO', v_error, v_usuario, v_params);
            COMMIT;
        END;
        DBMS_OUTPUT.PUT_LINE('[sp_alertas_negocio] Error: demasiadas filas. Ver LOG_ERRORES.');
        RAISE;

    WHEN OTHERS THEN
        ROLLBACK;
        DECLARE 
            v_params  VARCHAR2(500);
            v_usuario VARCHAR2(100);
            v_error   VARCHAR2(4000);
        BEGIN
            v_usuario := USER;
            v_error   := SQLERRM;
            v_params  := 'dias_alerta=' || TO_CHAR(p_dias_alerta);
            INSERT INTO log_errores (id_log, procedimiento, mensaje_error, usuario_oracle, parametros)
            VALUES (seq_log_errores.NEXTVAL, 'SP_ALERTAS_NEGOCIO', v_error, v_usuario, v_params);
            COMMIT;
        END;
        DBMS_OUTPUT.PUT_LINE('[sp_alertas_negocio] Error no controlado. Ver LOG_ERRORES.');
        RAISE;
END sp_alertas_negocio;
/

SHOW ERRORS;
