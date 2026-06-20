-- 1. Total de presupuesto invertido y promedio por categoría de proyecto
SELECT 
    c.nombre_categoria,
    COUNT(p.id_proyecto) AS total_proyectos,
    SUM(p.presupuesto) AS presupuesto_total,
    ROUND(AVG(p.presupuesto), 2) AS presupuesto_promedio
FROM categoria c
JOIN proyecto p ON c.id_categoria = p.id_categoria
GROUP BY c.nombre_categoria;

-- 2. Cantidad de tareas por estado en proyectos con presupuesto mayor a $50,000
SELECT 
    p.nombre_proyecto,
    t.estado_tarea,
    COUNT(t.id_tarea) AS cantidad_tareas
FROM proyecto p
JOIN tarea t ON p.id_proyecto = t.id_proyecto
WHERE p.presupuesto > 50000
GROUP BY p.nombre_proyecto, t.estado_tarea
ORDER BY p.nombre_proyecto;

-- 3. Empleados con más de 3 asignaciones activas (Control de sobrecarga con HAVING)
SELECT 
    e.id_empleado,
    e.nombre || ' ' || e.apellido AS empleado,
    COUNT(*) AS total_asignaciones
FROM empleado e
JOIN asignacion a 
    ON e.id_empleado = a.id_empleado
JOIN tarea t
    ON a.id_tarea = t.id_tarea
WHERE t.estado_tarea IN ('EN DESARROLLO')   -- filtro de tareas activas
GROUP BY e.id_empleado, e.nombre, e.apellido
HAVING COUNT(*) > 3;


-- 4. Costo total estimado de horas asignadas por proyecto
-- (Asumiendo que asignacion guarda horas e ingresos/costos estimados)
SELECT 
    p.nombre_proyecto,
    SUM(a.horas_estimadas) AS total_horas_proyecto,
    MAX(a.horas_estimadas) AS hora_maxima_dedicada
FROM proyecto p
JOIN tarea t
    ON p.id_proyecto = t.id_proyecto
JOIN asignacion a
    ON t.id_tarea = a.id_tarea
GROUP BY p.nombre_proyecto;

-- 5. Cantidad de riesgos críticos/altos identificados por categoría de proyecto
SELECT 
    c.nombre_categoria,
    COUNT(r.id_riesgo) AS riesgos_detectados
FROM categoria c
JOIN proyecto p ON c.id_categoria = p.id_categoria
JOIN riesgo r ON p.id_proyecto = r.id_proyecto
WHERE r.impacto IN ('ALTO', 'CRITICO')
GROUP BY c.nombre_categoria;

-- 6. Promedio de días de duración estimada de los hitos por proyecto
SELECT 
    p.nombre_proyecto,
    ROUND(
        AVG(h.fecha_hito - p.fecha_inicio),
        1
    ) AS promedio_dias_hasta_hitos
FROM proyecto p
JOIN hito h
    ON p.id_proyecto = h.id_proyecto
GROUP BY p.nombre_proyecto
HAVING AVG(h.fecha_hito - p.fecha_inicio) > 0;
