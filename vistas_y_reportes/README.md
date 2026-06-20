#  Módulo de Consultas Avanzadas y Reporting
> **Componente Core de Analítica e Inteligencia de Negocio** > *Desarrollado por: Integrante 3 (ca04073)*

¡Bienvenido al motor de reportería del sistema **Gestión de Proyectos**! Mientras que las capas previas se encargan de registrar y proteger las transacciones (DDL, Triggers), este módulo tiene como objetivo **transformar los datos crudos en información estratégica** para la toma de decisiones gerenciales.

---

## Estado del Arte y Tecnologías

![Oracle Database](https://img.shields.io/badge/Oracle-Database--F80000?style=for-the-badge&logo=oracle&logoColor=white)
![SQL-Advanced](https://img.shields.io/badge/SQL-Advanced%20Queries-336791?style=for-the-badge)
![PL/SQL](https://img.shields.io/badge/PL%2FSQL-Optimization-4F4F4F?style=for-the-badge)

* **Motor Base:** Oracle Database 19c/21c.
* **Enfoque Arquitectónico:** Desacoplamiento de consultas complejas mediante abstracción en Vistas.
* **Preparación Web:** Estructuras optimizadas listas para ser consumidas por APIs en entornos backend (Go/Rust) mediante payloads JSON.

---

## Inventario de Artefactos

El módulo está estrictamente segmentado en tres archivos secuenciales para facilitar su auditoría y ejecución:

### 1. `04_agregados.sql` — Métricas e Indicadores Clave
Contiene **6 consultas agregadas** estructuradas con funciones de agrupación (`SUM`, `AVG`, `COUNT`, `MAX`).
* **¿Qué resuelve?** Agrupa grandes volúmenes de registros para calcular KPIs como presupuestos por categoría, carga de tareas por estado y alertas de sobrecarga de personal mediante cláusulas `HAVING`.

### 2. `05_subconsultas.sql` — Lógica Avanzada de Aislamiento
Implementa **6 subconsultas** utilizando operadores de comparación múltiple y correlación directa (`IN`, `NOT EXISTS`, `MAX` anidados).
* **¿Qué resuelve?** Permite cruzar entidades sin sobrecargar el hilo principal, aislando por ejemplo los proyectos que superan el presupuesto promedio o detectando empleados sin asignaciones de forma óptima.

### 3. `06_vistas.sql` — Capa de Abstracción y Optimización
Define la interfaz de lectura que utilizará el portal web del sistema.
* **¿Qué resuelve?** Centraliza los joins más complejos en "tablas virtuales" (`CREATE OR REPLACE VIEW`) para simplificar el código del frontend.

---

## Innovación Técnica: Optimización Básica

> [!IMPORTANT]
> **Estrategia de Rendimiento para Entornos Web**
> Para mitigar la latencia que producen las consultas pesadas al conectar la base de datos con nuestro frontend (Astro/Tailwind), se implementó una **Vista Materializada** (`mv_resumen_gerencial_proyectos`).

```sql
-- Vista orientada al rendimiento (Snapshot en Disco)
CREATE MATERIALIZED VIEW mv_resumen_gerencial_proyectos
BUILD IMMEDIATE
REFRESH COMPLETE ON DEMAND
AS ...

```

### ¿Por qué es una mejora crítica?

A diferencia de una vista estándar que calcula los joins en tiempo real cada vez que un usuario recarga el sitio web, la **Vista Materializada almacena físicamente los resultados resumidos en el disco**. Esto reduce el costo computacional en la base de datos de $O(N)$ a una lectura directa de tiempo constante, garantizando una experiencia de usuario fluida en el portal.

## Orden de Ejecución Sugerido

Para garantizar que el diccionario de datos y las dependencias se carguen correctamente, ejecuta los scripts en el siguiente orden desde tu CLI o SQL Developer:

1. Ejecutar primero el modelo base de tablas de la rama `main`.
    
2. `@@04_agregados.sql` (Validación de métricas).
    
3. `@@05_subconsultas.sql` (Verificación de filtros lógicos).
    
4. `@@06_vistas.sql` (Despliegue de la capa analítica final).
    
