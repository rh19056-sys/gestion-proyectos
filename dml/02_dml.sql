-- =====================================================
-- 02_DML
-- =====================================================
-- INSERCIÓN DE DATOS

-- Limpieza rápida respetando estrictamente el orden de llaves foráneas
DELETE FROM telefono;
DELETE FROM hito;
DELETE FROM riesgo;
DELETE FROM documento;
DELETE FROM asignacion;
DELETE FROM recurso;
DELETE FROM tarea;
DELETE FROM empleado;
DELETE FROM proyecto;
DELETE FROM categoria;
COMMIT;

-- =====================================================
-- INSERTS: CATEGORIA
-- =====================================================

INSERT INTO categoria (id_categoria, nombre_categoria, descripcion_categoria)
VALUES (1, 'Construccion Residencial', 'Proyectos de viviendas y complejos habitacionales');

INSERT INTO categoria (id_categoria, nombre_categoria, descripcion_categoria)
VALUES (2, 'Construccion Comercial', 'Centros comerciales, oficinas y locales');

INSERT INTO categoria (id_categoria, nombre_categoria, descripcion_categoria)
VALUES (3, 'Infraestructura Vial', 'Carreteras, puentes y obras de transporte');

INSERT INTO categoria (id_categoria, nombre_categoria, descripcion_categoria)
VALUES (4, 'Obras Industriales', 'Plantas industriales y bodegas');

-- =====================================================
-- INSERTS: PROYECTO
-- =====================================================

INSERT INTO proyecto (
id_proyecto,
nombre_proyecto,
id_categoria,
fecha_inicio,
fecha_fin,
presupuesto,
estado_proyecto
)
VALUES (
1,
'Residencial Los Pinos',
1,
DATE '2026-01-15',
DATE '2026-12-20',
99999.99,
'EN_DESARROLLO'
);

INSERT INTO proyecto (
id_proyecto,
nombre_proyecto,
id_categoria,
fecha_inicio,
fecha_fin,
presupuesto,
estado_proyecto
)
VALUES (
2,
'Centro Comercial Plaza Norte',
2,
DATE '2026-02-01',
DATE '2026-11-30',
85000.00,
'POR_INICIAR'
);

INSERT INTO proyecto (
id_proyecto,
nombre_proyecto,
id_categoria,
fecha_inicio,
fecha_fin,
presupuesto,
estado_proyecto
)
VALUES (
3,
'Ampliacion Ruta Metropolitana',
3,
DATE '2026-03-10',
DATE '2026-10-15',
95000.50,
'EN_ESPERA'
);

INSERT INTO proyecto (
id_proyecto,
nombre_proyecto,
id_categoria,
fecha_inicio,
fecha_fin,
presupuesto,
estado_proyecto
)
VALUES (
4,
'Planta Industrial Delta',
4,
DATE '2026-04-01',
DATE '2026-12-01',
9800.75,
'EN_DESARROLLO'
);

-- =====================================================
-- INSERTS: EMPLEADO
-- =====================================================

INSERT INTO empleado (
id_empleado,
nombre,
apellido,
correo,
disponibilidad,
rol
)
VALUES (
1,
'Carlos',
'Martinez',
'carlos.martinez@empresa.com',
'DISPONIBLE',
'CARPINTERO'
);

INSERT INTO empleado (
id_empleado,
nombre,
apellido,
correo,
disponibilidad,
rol
)
VALUES (
2,
'Ana',
'Lopez',
'ana.lopez@empresa.com',
'OCUPADO',
'ALBAÑIL'
);

INSERT INTO empleado (
id_empleado,
nombre,
apellido,
correo,
disponibilidad,
rol
)
VALUES (
3,
'Luis',
'Hernandez',
'luis.hernandez@empresa.com',
'DISPONIBLE',
'CARPINTERO'
);

INSERT INTO empleado (
id_empleado,
nombre,
apellido,
correo,
disponibilidad,
rol
)
VALUES (
4,
'Maria',
'Gomez',
'maria.gomez@empresa.com',
'EN_VACACIONES',
'CONSTRUCTOR'
);
-- =====================================================
-- INSERTS: TELEFONO
-- Compatible con chk_telefono_formato
-- =====================================================

INSERT INTO telefono (id_empleado, telefono)
VALUES (1, '+503 7000-1001');

INSERT INTO telefono (id_empleado, telefono)
VALUES (2, '+503 7000-1002');

INSERT INTO telefono (id_empleado, telefono)
VALUES (3, '+503 7000-1003');

INSERT INTO telefono (id_empleado, telefono)
VALUES (4, '+503 7000-1004');

-- =====================================================
-- INSERTS:TAREA
-- Necesarios para las FK de ASIGNACION
-- =====================================================
INSERT INTO tarea (
    id_tarea,
    id_proyecto,
    titulo_tarea,
    estado_tarea,
    fecha_creacion,
    fecha_entrega,
    descripcion_tarea
)
VALUES (
    1,
    1,
    'Diseño Arquitectonico',
    'FINALIZADO',
    DATE '2026-01-20',
    DATE '2026-02-15',
    'Diseño inicial del complejo residencial'
);

INSERT INTO tarea (
    id_tarea,
    id_proyecto,
    titulo_tarea,
    estado_tarea,
    fecha_creacion,
    fecha_entrega,
    descripcion_tarea
)
VALUES (
    2,
    2,
    'Levantamiento Topografico',
    'EN DESARROLLO',
    DATE '2026-02-10',
    DATE '2026-04-01',
    'Estudio topográfico del terreno'
);

INSERT INTO tarea (
    id_tarea,
    id_proyecto,
    titulo_tarea,
    estado_tarea,
    fecha_creacion,
    fecha_entrega,
    descripcion_tarea
)
VALUES (
    3,
    3,
    'Construccion de Base',
    'POR INICIAR',
    DATE '2026-03-15',
    DATE '2026-05-30',
    'Preparación y construcción de base vial'
);

INSERT INTO tarea (
    id_tarea,
    id_proyecto,
    titulo_tarea,
    estado_tarea,
    fecha_creacion,
    fecha_entrega,
    descripcion_tarea
)
VALUES (
    4,
    4,
    'Instalacion Electrica',
    'EN PAUSA',
    DATE '2026-04-10',
    DATE '2026-07-15',
    'Instalación eléctrica industrial'
);
-- =====================================================
-- INSERTS: RECURSO
-- Necesarios para las FK de ASIGNACION
-- =====================================================

INSERT INTO recurso (
id_recurso,
nombre_recurso,
tipo_recurso,
descripcion_recurso,
disponibilidad_recurso
)
VALUES (
1,
'Retroexcavadora CAT',
'MAQUINARIA',
'Equipo pesado para excavaciones',
'DISPONIBLE'
);

INSERT INTO recurso (
id_recurso,
nombre_recurso,
tipo_recurso,
descripcion_recurso,
disponibilidad_recurso
)
VALUES (
2,
'Estacion Topografica',
'EQUIPO',
'Equipo de medicion topografica',
'OCUPADO'
);

INSERT INTO recurso (
id_recurso,
nombre_recurso,
tipo_recurso,
descripcion_recurso,
disponibilidad_recurso
)
VALUES (
3,
'Camion Volteo',
'VEHICULO',
'Transporte de materiales',
'DISPONIBLE'
);

INSERT INTO recurso (
id_recurso,
nombre_recurso,
tipo_recurso,
descripcion_recurso,
disponibilidad_recurso
)
VALUES (
4,
'Generador Industrial',
'EQUIPO',
'Suministro electrico temporal',
'EN_MANTENIMIENTO'
);

-- =====================================================
-- INSERTS: ASIGNACION
-- Corregido:
-- antes usaba columna HORAS (inexistente)
-- =====================================================

INSERT INTO asignacion (
id_tarea,
id_empleado,
id_recurso,
horas_reales,
horas_estimadas
)
VALUES (
1,
1,
1,
40,
45
);

INSERT INTO asignacion (
id_tarea,
id_empleado,
id_recurso,
horas_reales,
horas_estimadas
)
VALUES (
2,
2,
2,
55,
60
);

INSERT INTO asignacion (
id_tarea,
id_empleado,
id_recurso,
horas_reales,
horas_estimadas
)
VALUES (
3,
3,
3,
30,
35
);

INSERT INTO asignacion (
id_tarea,
id_empleado,
id_recurso,
horas_reales,
horas_estimadas
)
VALUES (
4,
4,
4,
25,
30
);

-- =====================================================
-- INSERTS: DOCUMENTO
-- Corregido:
-- fecha_creacion y contenido son NOT NULL
-- =====================================================

INSERT INTO documento (
id_documento,
id_proyecto,
nombre_documento,
fecha_creacion,
contenido
)
VALUES (
1,
1,
'Plano General Residencial.pdf',
DATE '2026-01-25',
'Plano general del proyecto residencial'
);

INSERT INTO documento (
id_documento,
id_proyecto,
nombre_documento,
fecha_creacion,
contenido
)
VALUES (
2,
2,
'Estudio Comercial.pdf',
DATE '2026-02-15',
'Documento de estudio comercial'
);

INSERT INTO documento (
id_documento,
id_proyecto,
nombre_documento,
fecha_creacion,
contenido
)
VALUES (
3,
3,
'Informe Tecnico Vial.pdf',
DATE '2026-03-20',
'Informe tecnico de infraestructura vial'
);

INSERT INTO documento (
id_documento,
id_proyecto,
nombre_documento,
fecha_creacion,
contenido
)
VALUES (
4,
4,
'Memoria de Calculo Industrial.pdf',
DATE '2026-04-25',
'Memoria de calculo del proyecto industrial'
);

-- =====================================================
-- INSERTS: RIESGO
-- Corregido:
-- probabilidad y plan_mitigacion son NOT NULL
-- =====================================================

INSERT INTO riesgo (
id_riesgo,
id_proyecto,
descripcion_riesgo,
impacto,
probabilidad,
plan_mitigacion
)
VALUES (
1,
1,
'Retraso en entrega de materiales',
'ALTO',
'MEDIA',
'Mantener proveedores alternativos'
);

INSERT INTO riesgo (
id_riesgo,
id_proyecto,
descripcion_riesgo,
impacto,
probabilidad,
plan_mitigacion
)
VALUES (
2,
2,
'Incremento de costos de construccion',
'MEDIO',
'ALTA',
'Negociar contratos anticipadamente'
);

INSERT INTO riesgo (
id_riesgo,
id_proyecto,
descripcion_riesgo,
impacto,
probabilidad,
plan_mitigacion
)
VALUES (
3,
3,
'Condiciones climaticas adversas',
'ALTO',
'MEDIA',
'Reprogramar actividades criticas'
);

INSERT INTO riesgo (
id_riesgo,
id_proyecto,
descripcion_riesgo,
impacto,
probabilidad,
plan_mitigacion
)
VALUES (
4,
4,
'Falla de equipos especializados',
'MEDIO',
'BAJA',
'Mantenimiento preventivo'
);

-- =====================================================
-- INSERTS: HITO
-- Corregido:
-- fecha_estimada -> fecha_hito
-- =====================================================

INSERT INTO hito (
id_hito,
id_proyecto,
nombre_hito,
fecha_hito
)
VALUES (
1,
1,
'Aprobacion de Diseños',
DATE '2026-02-01'
);

INSERT INTO hito (
id_hito,
id_proyecto,
nombre_hito,
fecha_hito
)
VALUES (
2,
2,
'Finalizacion de Cimentacion',
DATE '2026-05-15'
);

INSERT INTO hito (
id_hito,
id_proyecto,
nombre_hito,
fecha_hito
)
VALUES (
3,
3,
'Entrega de Tramo Principal',
DATE '2026-08-20'
);

INSERT INTO hito (
id_hito,
id_proyecto,
nombre_hito,
fecha_hito
)
VALUES (
4,
4,
'Inicio de Operaciones',
DATE '2026-11-15'
);

-- =====================================================
-- PROYECTOS ADICIONALES
-- =====================================================

INSERT INTO proyecto VALUES (
5,'Residencial Las Palmeras',1,
DATE '2026-05-01',DATE '2027-03-15',
125000,'EN_DESARROLLO');

INSERT INTO proyecto VALUES (
6,'Torre Empresarial Central',2,
DATE '2026-06-01',DATE '2027-01-20',
230000,'EN_DESARROLLO');

INSERT INTO proyecto VALUES (
7,'Puente Rio Grande',3,
DATE '2026-07-10',DATE '2027-06-30',
350000,'EN_DESARROLLO');

INSERT INTO proyecto VALUES (
8,'Bodega Industrial Orion',4,
DATE '2026-08-01',DATE '2027-04-10',
180000,'POR_INICIAR');

INSERT INTO proyecto VALUES (
9,'Complejo Habitacional El Encino',1,
DATE '2026-09-01',DATE '2027-05-30',
275000,'EN_DESARROLLO');

INSERT INTO proyecto VALUES (
10,'Centro Comercial Santa Elena',2,
DATE '2026-10-01',DATE '2027-09-15',
450000,'POR_INICIAR');

INSERT INTO empleado VALUES (
5,'Ricardo','Ramirez',
'ricardo.ramirez@empresa.com',
'DISPONIBLE','ELECTRICISTA');

INSERT INTO empleado VALUES (
6,'Sofia','Morales',
'sofia.morales@empresa.com',
'DISPONIBLE','SOLDADOR');

INSERT INTO empleado VALUES (
7,'Daniel','Castro',
'daniel.castro@empresa.com',
'OCUPADO','PLOMERO');

INSERT INTO empleado VALUES (
8,'Paola','Navarro',
'paola.navarro@empresa.com',
'DISPONIBLE','ARQUITECTO');

INSERT INTO empleado VALUES (
9,'Miguel','Pineda',
'miguel.pineda@empresa.com',
'DISPONIBLE','DIRECTOR_EJECUCION');

INSERT INTO empleado VALUES (
10,'Lucia','Reyes',
'lucia.reyes@empresa.com',
'EN_VACACIONES','CONTRATISTA');

INSERT INTO telefono VALUES (5,'+503 7000-1005');
INSERT INTO telefono VALUES (6,'+503 7000-1006');
INSERT INTO telefono VALUES (7,'+503 7000-1007');
INSERT INTO telefono VALUES (8,'+503 7000-1008');
INSERT INTO telefono VALUES (9,'+503 7000-1009');
INSERT INTO telefono VALUES (10,'+503 7000-1010');


INSERT INTO recurso VALUES (
5,'Grua Torre Liebherr',
'MAQUINARIA',
'Grua principal',
'DISPONIBLE');

INSERT INTO recurso VALUES (
6,'Mezcladora Industrial',
'EQUIPO',
'Equipo de concreto',
'DISPONIBLE');

INSERT INTO recurso VALUES (
7,'Camion Cisterna',
'VEHICULO',
'Abastecimiento',
'OCUPADO');

INSERT INTO recurso VALUES (
8,'Compresor Atlas',
'EQUIPO',
'Compresor neumático',
'DISPONIBLE');

INSERT INTO recurso VALUES (
9,'Excavadora Volvo',
'MAQUINARIA',
'Movimiento de tierra',
'DISPONIBLE');

INSERT INTO recurso VALUES (
10,'Montacargas Toyota',
'VEHICULO',
'Manipulación de carga',
'EN_MANTENIMIENTO');

-- =====================================================
-- TAREAS ADICIONALES
-- =====================================================

INSERT INTO tarea VALUES (
5,5,
'Estudio de Suelos',
'FINALIZADO',
DATE '2026-05-05',
DATE '2026-05-25',
'Analisis geotecnico del terreno');

INSERT INTO tarea VALUES (
6,5,
'Cimentacion Principal',
'EN DESARROLLO',
DATE '2026-05-26',
DATE '2026-08-20',
'Construccion de cimentaciones');

INSERT INTO tarea VALUES (
7,6,
'Diseño Estructural',
'EN DESARROLLO',
DATE '2026-06-10',
DATE '2026-08-15',
'Modelado estructural');

INSERT INTO tarea VALUES (
8,6,
'Instalacion de Elevadores',
'POR INICIAR',
DATE '2026-08-20',
DATE '2026-11-30',
'Preparacion del sistema de elevadores');

INSERT INTO tarea VALUES (
9,7,
'Excavacion de Pilotes',
'EN DESARROLLO',
DATE '2026-07-20',
DATE '2026-10-01',
'Movimiento de tierra');

INSERT INTO tarea VALUES (
10,7,
'Construccion de Columnas',
'POR INICIAR',
DATE '2026-10-05',
DATE '2027-01-15',
'Construccion de soportes');

INSERT INTO tarea VALUES (
11,8,
'Montaje de Estructura Metalica',
'EN PAUSA',
DATE '2026-08-15',
DATE '2026-11-10',
'Instalacion de estructura');

INSERT INTO tarea VALUES (
12,8,
'Instalacion de Cubierta',
'POR INICIAR',
DATE '2026-11-15',
DATE '2027-01-10',
'Techos industriales');

INSERT INTO tarea VALUES (
13,9,
'Urbanizacion Interna',
'EN DESARROLLO',
DATE '2026-09-10',
DATE '2027-01-15',
'Calles y drenajes');

INSERT INTO tarea VALUES (
14,10,
'Diseño de Fachada',
'POR INICIAR',
DATE '2026-10-20',
DATE '2027-02-01',
'Arquitectura exterior');

INSERT INTO tarea VALUES (
15,10,
'Instalacion Electrica Comercial',
'POR INICIAR',
DATE '2026-11-01',
DATE '2027-03-10',
'Red electrica principal');

-- =====================================================
-- ASIGNACIONES ADICIONALES
-- =====================================================

INSERT INTO asignacion VALUES (
5,5,5,
10,
15);

INSERT INTO asignacion VALUES (
6,1,6,
12,
18);

INSERT INTO asignacion VALUES (
7,6,5,
8,
15);

INSERT INTO asignacion VALUES (
8,7,6,
0,
12);

INSERT INTO asignacion VALUES (
9,3,9,
10,
18);

INSERT INTO asignacion VALUES (
10,8,9,
0,
15);

INSERT INTO asignacion VALUES (
11,4,8,
0,
10);

INSERT INTO asignacion VALUES (
12,5,10,
0,
12);

INSERT INTO asignacion VALUES (
13,8,7,
6,
15);

INSERT INTO asignacion VALUES (
14,9,5,
0,
18);

INSERT INTO asignacion VALUES (
15,6,8,
0,
12);


-- =====================================================
-- DOCUMENTOS ADICIONALES
-- =====================================================

INSERT INTO documento VALUES (
5,5,
'Estudio Geotecnico Las Palmeras.pdf',
DATE '2026-05-15',
'Resultados de estudio geotecnico');

INSERT INTO documento VALUES (
6,6,
'Memoria Estructural Torre Central.pdf',
DATE '2026-06-25',
'Calculos estructurales');

INSERT INTO documento VALUES (
7,7,
'Informe Geologico Rio Grande.pdf',
DATE '2026-07-28',
'Informe geologico del proyecto');

INSERT INTO documento VALUES (
8,8,
'Planos Bodega Orion.pdf',
DATE '2026-08-30',
'Planos generales');

INSERT INTO documento VALUES (
9,9,
'Plano Urbanistico Encino.pdf',
DATE '2026-09-20',
'Diseño urbanistico');

INSERT INTO documento VALUES (
10,10,
'Estudio Comercial Santa Elena.pdf',
DATE '2026-10-25',
'Analisis de factibilidad');

INSERT INTO documento VALUES (
11,5,
'Memoria Hidraulica.pdf',
DATE '2026-06-05',
'Calculos hidraulicos');

INSERT INTO documento VALUES (
12,6,
'Planos Arquitectonicos.pdf',
DATE '2026-07-01',
'Arquitectura general');

INSERT INTO documento VALUES (
13,7,
'Informe Ambiental.pdf',
DATE '2026-08-01',
'Impacto ambiental');

INSERT INTO documento VALUES (
14,9,
'Diseño de Areas Verdes.pdf',
DATE '2026-10-10',
'Distribucion de zonas verdes');

INSERT INTO documento VALUES (
15,10,
'Memoria Electrica.pdf',
DATE '2026-11-15',
'Especificaciones electricas');

-- =====================================================
-- RIESGOS ADICIONALES
-- =====================================================

INSERT INTO riesgo VALUES (
5,5,
'Escasez de materiales',
'ALTO',
'MEDIA',
'Contratacion de proveedores alternos');

INSERT INTO riesgo VALUES (
6,6,
'Retraso en permisos municipales',
'MEDIO',
'ALTA',
'Gestion anticipada');

INSERT INTO riesgo VALUES (
7,7,
'Crecida del rio durante invierno',
'ALTO',
'MEDIA',
'Modificar cronograma');

INSERT INTO riesgo VALUES (
8,8,
'Fallas en estructura metalica',
'MEDIO',
'BAJA',
'Inspecciones periodicas');

INSERT INTO riesgo VALUES (
9,9,
'Aumento en costo del concreto',
'ALTO',
'ALTA',
'Compras anticipadas');

INSERT INTO riesgo VALUES (
10,10,
'Demora en instalaciones electricas',
'MEDIO',
'MEDIA',
'Supervision adicional');

INSERT INTO riesgo VALUES (
11,6,
'Escasez de mano de obra',
'ALTO',
'BAJA',
'Subcontratacion');

INSERT INTO riesgo VALUES (
12,7,
'Problemas geotecnicos',
'ALTO',
'MEDIA',
'Estudios complementarios');

INSERT INTO riesgo VALUES (
13,8,
'Retraso de proveedores',
'MEDIO',
'MEDIA',
'Inventario preventivo');

INSERT INTO riesgo VALUES (
14,9,
'Lluvias intensas',
'MEDIO',
'ALTA',
'Reprogramacion');

INSERT INTO riesgo VALUES (
15,10,
'Variacion del acero',
'ALTO',
'MEDIA',
'Compras por volumen');

-- =====================================================
-- HITOS ADICIONALES
-- =====================================================

INSERT INTO hito VALUES (
5,5,
'Aprobacion Geotecnica',
DATE '2026-06-01');

INSERT INTO hito VALUES (
6,5,
'Finalizacion de Cimentacion',
DATE '2026-08-25');

INSERT INTO hito VALUES (
7,6,
'Entrega de Diseño Estructural',
DATE '2026-09-01');

INSERT INTO hito VALUES (
8,6,
'Inicio de Construccion',
DATE '2026-10-15');

INSERT INTO hito VALUES (
9,7,
'Finalizacion de Pilotes',
DATE '2026-11-15');

INSERT INTO hito VALUES (
10,8,
'Montaje Completo de Estructura',
DATE '2027-01-20');

INSERT INTO hito VALUES (
11,9,
'Urbanizacion Terminada',
DATE '2027-02-15');

INSERT INTO hito VALUES (
12,10,
'Entrega de Fachada',
DATE '2027-03-15');

INSERT INTO hito VALUES (
13,7,
'Pruebas de Resistencia',
DATE '2027-04-01');

INSERT INTO hito VALUES (
14,8,
'Entrega de Bodega',
DATE '2027-04-20');

INSERT INTO hito VALUES (
15,10,
'Inicio de Operaciones Comerciales',
DATE '2027-08-01');


COMMIT;
