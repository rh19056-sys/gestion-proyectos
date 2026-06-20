
-- CONSULTAS CON JOIN (6 INNER JOIN + 6 LEFT/RIGHT JOIN)
-- Basado en la estructura: 
--   tabla RECURSO, ASIGNACION con horas_reales/estimadas,
--   EMPLEADO con nombre/apellido, etc.



--INNER JOINS (6)        


-- INNER JOIN 1: Proyectos con sus tareas (y estado del proyecto)
SELECT p.id_proyecto, p.nombre_proyecto, p.estado_proyecto,
       t.id_tarea, t.titulo_tarea, t.estado_tarea
FROM proyecto p
INNER JOIN tarea t ON p.id_proyecto = t.id_proyecto
ORDER BY p.id_proyecto, t.id_tarea;

-- INNER JOIN 2: Tareas con asignaciones completas (empleado + recurso + horas)
SELECT t.id_tarea, t.titulo_tarea,
       e.id_empleado, e.nombre || ' ' || e.apellido AS empleado,
       r.id_recurso, r.nombre_recurso,
       a.horas_estimadas, a.horas_reales
FROM tarea t
INNER JOIN asignacion a ON t.id_tarea = a.id_tarea
INNER JOIN empleado e ON a.id_empleado = e.id_empleado
INNER JOIN recurso r ON a.id_recurso = r.id_recurso
ORDER BY t.id_tarea;

-- INNER JOIN 3: Empleados con sus teléfonos (solo los que tienen teléfono)
SELECT e.id_empleado, e.nombre, e.apellido, tel.telefono
FROM empleado e
INNER JOIN telefono tel ON e.id_empleado = tel.id_empleado
ORDER BY e.id_empleado;

-- INNER JOIN 4: Proyectos con sus documentos (incluye fecha y contenido)
SELECT p.id_proyecto, p.nombre_proyecto,
       d.id_documento, d.nombre_documento, d.fecha_creacion
FROM proyecto p
INNER JOIN documento d ON p.id_proyecto = d.id_proyecto
ORDER BY p.id_proyecto;

-- INNER JOIN 5: Proyectos con sus riesgos (incluye impacto y plan)
SELECT p.id_proyecto, p.nombre_proyecto,
       r.id_riesgo, r.descripcion_riesgo, r.impacto, r.probabilidad, r.plan_mitigacion
FROM proyecto p
INNER JOIN riesgo r ON p.id_proyecto = r.id_proyecto
ORDER BY p.id_proyecto;

-- INNER JOIN 6: Proyectos con sus hitos
SELECT p.id_proyecto, p.nombre_proyecto,
       h.id_hito, h.nombre_hito, h.fecha_hito
FROM proyecto p
INNER JOIN hito h ON p.id_proyecto = h.id_proyecto
ORDER BY p.id_proyecto, h.fecha_hito;


-- #   LEFT / RIGHT JOIN (6)  


-- LEFT JOIN 1: Proyectos con sus tareas (incluye proyectos sin tareas)
-- Nota: si algún proyecto recién creado no tiene tareas, aparecerá con NULL
SELECT p.id_proyecto, p.nombre_proyecto,
       t.id_tarea, t.titulo_tarea
FROM proyecto p
LEFT JOIN tarea t ON p.id_proyecto = t.id_proyecto
ORDER BY p.id_proyecto;

-- LEFT JOIN 2: Empleados con sus teléfonos (incluye empleados sin teléfono)
-- El empleado 103 en tus datos no tiene teléfono, aparecerá NULL
SELECT e.id_empleado, e.nombre, e.apellido, tel.telefono
FROM empleado e
LEFT JOIN telefono tel ON e.id_empleado = tel.id_empleado
ORDER BY e.id_empleado;

-- LEFT JOIN 3: Categorías con sus proyectos (incluye categorías sin proyectos)
SELECT c.id_categoria, c.nombre_categoria,
       p.id_proyecto, p.nombre_proyecto
FROM categoria c
LEFT JOIN proyecto p ON c.id_categoria = p.id_categoria
ORDER BY c.id_categoria;

-- LEFT JOIN 4: Tareas con asignaciones (incluye tareas sin asignaciones)
-- La tarea 206 (Levantamiento de columnas) no tiene asignación en tus datos
SELECT t.id_tarea, t.titulo_tarea,
       a.id_empleado, a.id_recurso, a.horas_estimadas, a.horas_reales
FROM tarea t
LEFT JOIN asignacion a ON t.id_tarea = a.id_tarea
ORDER BY t.id_tarea;

-- LEFT JOIN 5: Recursos con asignaciones (incluye recursos no usados)
-- Muestra recursos que aún no se han asignado a ninguna tarea
SELECT r.id_recurso, r.nombre_recurso, r.disponibilidad_recurso,
       a.id_tarea, a.horas_estimadas
FROM recurso r
LEFT JOIN asignacion a ON r.id_recurso = a.id_recurso
ORDER BY r.id_recurso;

-- RIGHT JOIN 1: Proyectos con categorías (todas las categorías aparecen)
-- Equivalente a LEFT JOIN de categoría a proyecto, pero usando RIGHT JOIN
SELECT c.id_categoria, c.nombre_categoria,
       p.id_proyecto, p.nombre_proyecto
FROM proyecto p
RIGHT JOIN categoria c ON p.id_categoria = c.id_categoria
ORDER BY c.id_categoria;


-- FIN DE CONSULTAS
