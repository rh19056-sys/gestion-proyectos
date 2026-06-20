# Gestion de Proyectos - Oracle DB 

Proyecto universitario de base de datos en Oracle para un sistema de gestion de proyectos. El repositorio modela categorias, proyectos, empleados, telefonos, tareas, recursos, asignaciones, documentos, riesgos e hitos. Tambien incorpora restricciones de integridad, procedimientos PL/SQL, triggers, auditoria, log de errores, seguridad por usuarios y una capa inicial de vistas/reportes.

## Estado Del Proyecto

**Estado academico: terminado para fines del proyecto de DPB135**

El proyecto ya cuenta con modelo relacional, restricciones, procedimientos almacenados, triggers de auditoria e integridad, seguridad por roles y vistas de reporteria. Para efectos de la entrega academica de DPB135, los componentes principales estan completos y alineados entre si. Las tareas restantes se consideran mejoras o validaciones posteriores, no bloqueantes para la defensa del proyecto.

| Modulo | Estado | Avance |
| --- | --- | ---: |
| Modelo relacional y DDL | Implementado | 100% |
| Restricciones adicionales | Implementado | 100% |
| Procedimientos almacenados | Implementado | 100% |
| Triggers, auditoria y logs | Implementado | 100% |
| Seguridad, usuarios y permisos | Implementado | 100% |
| Vistas y reporteria | Implementado | 100% |
| Datos de prueba DML | Insertados | 100% |
| Portal/API de reportes | Estructura inicial | 100% |
| Pruebas integrales en Oracle | Ejecutadas por los integrantes | 100% |
| Pruebas integrales en Oracle | Pendiente de demostración en defensa | 0% |


## Tecnologias

![Oracle](https://img.shields.io/badge/Oracle-Database-F80000?style=for-the-badge&logo=oracle&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-DDL%20%7C%20DML-336791?style=for-the-badge)
![PLSQL](https://img.shields.io/badge/PL%2FSQL-Procedures%20%26%20Triggers-2F4F4F?style=for-the-badge)
![Docker](https://img.shields.io/badge/Docker-Containerization-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Git](https://img.shields.io/badge/Git-Version%20Control-F05032?style=for-the-badge&logo=git&logoColor=white)

- **Oracle Database:** motor relacional principal.
- **SQL DDL:** definicion de tablas, llaves primarias, llaves foraneas y restricciones.
- **PL/SQL:** procedimientos almacenados, excepciones, triggers, auditoria y logs.
- **Oracle Security:** usuarios, cuotas y privilegios.
- **Docker:** estructura inicial para portal/API de reportes.
- **Git:** control de versiones del proyecto.

## Estructura Del Repositorio

```text
gestion-proyectos/
|-- ddl (Estructura de base de datos)/
|   |-- 01_ddl.sql
|   `-- 01_1alter_table.sql
|-- dml (inserts)/
|-- procedimientos/
|   `-- 07_procedimientos.sql
|-- triggers/
|   `-- 08_triggers.sql
|-- seguridad (roles y permisos)/
|   `-- 09_seguridad.sql
|-- vistas_y_reportes/
|   |-- README.md
|   |-- 04_agregados.sql
|   |-- 05_subconsultas.sql
|   `-- 06_vistas.sql
|-- vistas_y_reportes_portal_web/
|   |-- Dockerfile
|   `-- docker-compose.yml
|-- index.html
`-- README.md
```

## Modelo Relacional

El archivo `ddl (Estructura de base de datos)/01_ddl.sql` define las tablas principales:

- `categoria`
- `proyecto`
- `empleado`
- `telefono`
- `tarea`
- `recurso`
- `asignacion`
- `documento`
- `riesgo`
- `hito`

El modelo incluye restricciones `PRIMARY KEY`, `FOREIGN KEY`, `UNIQUE`, `NOT NULL`, `CHECK` y reglas `ON DELETE CASCADE` para proteger la integridad referencial.

## Restricciones Adicionales

El archivo `ddl (Estructura de base de datos)/01_1alter_table.sql` agrega validaciones complementarias:

- nombres sin espacios vacios,
- formato de correo,
- formato de telefono,
- consistencia de fechas,
- validaciones adicionales por entidad.

Este script debe ejecutarse despues de crear las tablas base.

## Procedimientos Almacenados

El archivo `procedimientos/07_procedimientos.sql` contiene procedimientos PL/SQL para analisis y control operativo:

- `sp_resumen_periodo`: genera un resumen gerencial por rango de fechas.
- `sp_top_elementos`: muestra rankings de empleados, proyectos y categorias.
- `sp_indicadores_categoria`: calcula indicadores por categoria comparando periodos.
- `sp_alertas_negocio`: genera alertas sobre proyectos, tareas, empleados e hitos.

Los procedimientos usan `log_errores` y `seq_log_errores` para registrar excepciones controladas.

## Triggers Y Auditoria

El archivo `triggers/08_triggers.sql` implementa:

- `auditoria_proyecto`
- `log_errores`
- `auditoria_log`
- `seq_auditoria`
- `seq_log_errores`
- `seq_auditoria_log`
- `trg_auditoria_log_errores`
- `trg_auditoria_proyecto`
- `trg_integridad_horas_empleado`

El trigger `trg_integridad_horas_empleado` controla que un empleado no supere 40 horas activas asignadas. Para esta regla de capacidad debe usarse `horas_estimadas`, porque representa planificacion/asignacion antes de registrar el trabajo real.

## Vistas Y Reporteria

La carpeta `vistas_y_reportes/` contiene consultas avanzadas y vistas:

- `04_agregados.sql`: consultas agregadas e indicadores. Conserva deudas tecnicas conocidas y no se considera parte del flujo estable.
- `05_subconsultas.sql`: subconsultas y filtros avanzados.
- `06_vistas.sql`: vistas de abstraccion y vista materializada.

Vistas principales:

- `v_reporte_tareas`: control operativo de tareas segun fecha de entrega.
- `v_dashboard_empleados`: carga laboral del personal.
- `mv_resumen_gerencial_proyectos`: resumen gerencial materializado.

## Seguridad

El archivo `seguridad (roles y permisos)/09_seguridad.sql` implementa una politica de usuarios alineada con la consigna academica.

### Usuarios

| Usuario | Rol | Puede acceder a | No debe acceder a |
| --- | --- | --- | --- |
| `usr_lectura` | Solo lectura / consultas | `SELECT` sobre tablas del negocio y vistas | Tablas de auditoria, procedimientos almacenados, funciones, triggers; no puede hacer `INSERT`, `UPDATE` ni `DELETE` |
| `usr_admin` | Administracion / PL/SQL | `EXECUTE` sobre procedimientos; `SELECT` y DML sobre logs/auditoria | No debe modificar estructura de tablas ni recibir permisos DDL |

### Requisitos Cubiertos

- Creacion de usuarios con `CREATE USER`.
- Asignacion de cuota con `ALTER USER ... QUOTA UNLIMITED ON USERS`.
- Privilegio de conexion con `GRANT CREATE SESSION`.
- `GRANT SELECT` sobre tablas del negocio para `usr_lectura`.
- `GRANT EXECUTE` sobre procedimientos para `usr_admin`.
- Permisos DML controlados sobre `log_errores` para `usr_admin`.

### Pruebas Recomendadas

Conectado como `usr_lectura`, debe funcionar:

```sql
SELECT * FROM esquema.proyecto;
SELECT * FROM esquema.tarea;
SELECT * FROM nombre_esquema.recurso;
SELECT * FROM nombre_esquema.v_dashboard_empleados;
SELECT * FROM nombre_esquema.v_reporte_tareas;
```

Conectado como `usr_lectura`, debe fallar:

```sql
INSERT INTO nombre_esquema.proyecto (...) VALUES (...);
UPDATE nombre_esquema.proyecto SET nombre_proyecto = 'TEST';
DELETE FROM nombre_esquema.proyecto WHERE id_proyecto = 1;
EXEC nombre_esquema.sp_alertas_negocio(7);
```

Conectado como `usr_admin`, debe funcionar:

```sql
SELECT * FROM nombre_esquema.log_errores;
EXEC nombre_esquema.sp_alertas_negocio(7);
EXEC nombre_esquema.sp_resumen_periodo(DATE '2026-01-01', DATE '2026-12-31');
```

Conectado como `usr_admin`, debe fallar:

```sql
CREATE TABLE prueba (id NUMBER);
ALTER TABLE nombre_esquema.proyecto ADD columna_prueba NUMBER;
DROP TABLE nombre_esquema.proyecto;
```

> `nombre_esquema` debe reemplazarse por el usuario propietario real de las tablas, procedimientos y vistas cuando el equipo defina el nombre definitivo.

## Portal/API De Reportes

La carpeta `vistas_y_reportes_portal_web/` contiene una estructura inicial para exponer informacion de reporteria mediante servicios web:

- `Dockerfile`
- `docker-compose.yml`

Esta capa esta planteada como base para una futura API conectada a Oracle Database.

### Orden Sugerido De Ejecucion

## Creación del superusuario `USR_PROYECTOS`

Este usuario se utiliza como **administrador interno** del proyecto.  
Con él se pueden crear y gestionar esquemas, tablas, procedimientos, triggers y demás objetos de base de datos.

### Orden Sugerido De Ejecución

## Creación del superusuario `USR_PROYECTOS`

Este usuario se utiliza como **administrador interno** del proyecto.  
Con él se pueden crear y gestionar esquemas, tablas, procedimientos, triggers y demás objetos de base de datos.  
Desde este superusuario se recomienda crear el esquema principal del proyecto (`GESTIONPROYECTOSDPB`).

### Ejecución

Conéctate como `SYSTEM` o cualquier usuario con privilegios de DBA en la PDB correspondiente (`XEPDB1`):

```sql
ALTER SESSION SET CONTAINER=XEPDB1;

CREATE USER usr_proyectos IDENTIFIED BY ClaveProyectos
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;

-- Privilegios básicos
GRANT CONNECT, RESOURCE TO usr_proyectos;

-- Privilegios avanzados (equivalentes a SYSTEM)
GRANT DBA TO usr_proyectos;
GRANT EXP_FULL_DATABASE TO usr_proyectos;
GRANT IMP_FULL_DATABASE TO usr_proyectos;
GRANT SELECT_CATALOG_ROLE TO usr_proyectos;
GRANT EXECUTE_CATALOG_ROLE TO usr_proyectos;
```

### Notas

- Cambia `ClaveProyectos` por una contraseña segura.
- Este usuario tiene permisos de administración, por lo que puede crear otros usuarios/esquemas.
- El esquema principal del proyecto (ej. `GESTIONPROYECTOSDPB`) puede ser creado posteriormente desde este superusuario.

### Creación del esquema principal GESTIONPROYECTOSDPB
Conéctate como USR_PROYECTOS en la PDB XEPDB1:

```sql
CREATE USER gestionproyectosdpb IDENTIFIED BY ClaveProyectos
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA UNLIMITED ON users;

-- Privilegios básicos
GRANT CONNECT, RESOURCE TO gestionproyectosdpb;

-- Privilegios avanzados
GRANT DBA TO gestionproyectosdpb;
GRANT EXP_FULL_DATABASE TO gestionproyectosdpb;
GRANT IMP_FULL_DATABASE TO gestionproyectosdpb;

-- Privilegios sobre directorio de backups
GRANT READ, WRITE ON DIRECTORY GP_BACKUP_DIR TO gestionproyectosdpb;

´´´
### Para conectarte

```bash
sqlplus usr_proyectos/ClaveProyectos@localhost:1521/XEPDB1
```

### Orden de ejecución

1. Ejecutar `ddl (Estructura de base de datos)/01_ddl.sql`.
2. Ejecutar `ddl (Estructura de base de datos)/01_1alter_table.sql`.
3. Ejecutar `triggers/08_triggers.sql`.
4. Ejecutar `procedimientos/07_procedimientos.sql`.
5. Ejecutar `dml (inserts)02_dml.sql`  para cargar datos de prueba.
6. Ejecutar `vistas_y_reportes/05_subconsultas.sql`.
7. Ejecutar `vistas_y_reportes/06_vistas.sql`.
8. Ejecutar `seguridad (roles y permisos)/09_seguridad.sql desde el usuario correspondiente`.

En la raíz del repo hallará también un archivo llamado master.sql que ejecuta estos comandos en orden, solo asegurese de modificar la ruta. 

## Ultima Actualizacion

2026-06-08
