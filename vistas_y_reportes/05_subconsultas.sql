 -- 1. Proyectos cuyo presupuesto es superior al promedio general de todos los proyectos
SELECT id_proyecto, nombre_proyecto, presupuesto
FROM proyecto
WHERE presupuesto > (SELECT AVG(presupuesto) FROM proyecto);

-- 2. Empleados que no tienen ninguna asignación registrada (Uso de NOT EXISTS)
SELECT id_empleado, nombre, apellido, rol
FROM empleado e
WHERE NOT EXISTS (
    SELECT 1 
    FROM asignacion a 
    WHERE a.id_empleado = e.id_empleado
);

-- 3. Proyectos que tienen al menos una tarea en estado 'POR INICIAR' o 'EN PAUSA'
SELECT id_proyecto, nombre_proyecto
FROM proyecto
WHERE id_proyecto IN (
    SELECT DISTINCT id_proyecto 
    FROM tarea 
    WHERE estado_tarea = 'EN PAUSA' OR estado_tarea = 'POR INICIAR'
);

-- 4. Obtener el nombre del proyecto y su porcentaje de tareas completadas (Subconsulta correlacionada en el SELECT)
SELECT 
    p.nombre_proyecto,
    (SELECT COUNT(*) FROM tarea t WHERE t.id_proyecto = p.id_proyecto) AS total_tareas,
    (SELECT COUNT(*) FROM tarea t WHERE t.id_proyecto = p.id_proyecto AND t.estado_tarea = 'FINALIZADO') AS completadas
FROM proyecto p;

-- 5. Listar los empleados que ganan o tienen un rango asignado superior al promedio de su mismo cargo (Correlacionada)
-- Nota: Adaptable si manejas tabla de salarios, o rendimiento/horas en asignación
SELECT id_empleado, nombre, rol
FROM empleado e
WHERE e.id_empleado IN (
    SELECT id_empleado 
    FROM asignacion 
    WHERE horas_estimadas > (SELECT AVG(horas_estimadas) FROM asignacion)
);

-- 6. Obtener el riesgo con la probabilidad más alta de cada proyecto (Subconsulta en el FROM)
SELECT p.nombre_proyecto, r.descripcion_riesgo, r.probabilidad
FROM riesgo r
JOIN proyecto p ON r.id_proyecto = p.id_proyecto
WHERE (r.id_proyecto, r.probabilidad) IN (
    SELECT id_proyecto, MAX(probabilidad)
    FROM riesgo
    GROUP BY id_proyecto
);
