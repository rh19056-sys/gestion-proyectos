# Backup y restauracion

Esta carpeta contiene los recursos para cumplir la parte de **Backup y seguridad** de la rubrica:

* generar backups de la base de datos,
* restaurar el ultimo backup generado,
* dejar evidencia verificable despues de restaurar.

La estrategia usada es **Oracle Data Pump**, con `expdp` para exportar y `impdp` para importar. Es una copia logica del esquema: tablas, datos, vistas, procedimientos, triggers, secuencias y demas objetos del usuario propietario.

## Archivos

| Archivo                               | Uso                                                                               |
| ------------------------------------- | --------------------------------------------------------------------------------- |
| `10_configurar_directorio_backup.sql` | Crea el objeto Oracle `DIRECTORY` llamado `GP_BACKUP_DIR`.                        |
| `backup_exportar.bat`                 | Genera el ultimo backup en Windows.                                               |
| `backup_restaurar_ultimo.bat`         | Restaura el ultimo backup en Windows.                                             |
| `backup_exportar.sh`                  | Genera el ultimo backup en Linux/macOS/Docker.                                    |
| `backup_restaurar_ultimo.sh`          | Restaura el ultimo backup en Linux/macOS/Docker.                                  |
| `11_verificar_backup.sql`             | Consultas para comprobar que el backup restaurado contiene los objetos esperados. |

## 1. Preparar el directorio de Oracle

Ejecutar como `SYSTEM` o como un usuario con permisos para crear directories:

```sql
@backup_y_restauracion/10_configurar_directorio_backup.sql
```

El script crea el directorio Oracle utilizado por Data Pump:

```sql
CREATE OR REPLACE DIRECTORY GP_BACKUP_DIR AS 'C:\Users\Uber\gestion-proyectos\backup_y_restauracion';

GRANT READ, WRITE ON DIRECTORY GP_BACKUP_DIR TO gestionproyectosdpb;
```

Antes de ejecutar el script, verificar que la carpeta exista fisicamente:

```text
C:\Users\Uber\gestion-proyectos\backup_y_restauracion
```

## 2. Generar el backup

En Windows:

```bat
backup_y_restauracion\backup_exportar.bat usuario/password@localhost:1521/XEPDB1 gestionproyectosdpb
```

En Linux/macOS/Docker:

```bash
./backup_y_restauracion/backup_exportar.sh usuario/password@localhost:1521/XEPDB1 gestionproyectosdpb
```

El archivo generado queda en el directorio Oracle `GP_BACKUP_DIR` con este nombre:

```text
gestion_proyectos_gestionproyectosdpb_ultimo.dmp
```

El log queda como:

```text
gestion_proyectos_gestionproyectosdpb_backup.log
```

## 3. Restaurar el ultimo backup

En Windows:

```bat
backup_y_restauracion\backup_restaurar_ultimo.bat usuario/password@localhost:1521/XEPDB1 gestionproyectosdpb
```

En Linux/macOS/Docker:

```bash
./backup_y_restauracion/backup_restaurar_ultimo.sh usuario/password@localhost:1521/XEPDB1 gestionproyectosdpb
```

La restauracion usa:

```text
table_exists_action=replace
```

Por eso puede reemplazar tablas y datos existentes. Para la defensa academica, lo ideal es probar primero en una base o esquema de prueba.

## 4. Verificar la restauracion

Despues de restaurar, ejecutar como el usuario propietario:

```sql
@backup_y_restauracion/11_verificar_backup.sql
```

La evidencia esperada es:

* aparecen las tablas principales del modelo,
* aparecen vistas y procedimientos con estado `VALID`,
* los conteos de tablas coinciden con los datos cargados antes del backup.

## Flujo recomendado para evidencia

1. Ejecutar los scripts del proyecto en el orden indicado en el README principal.
2. Cargar datos de prueba.
3. Ejecutar `backup_exportar`.
4. Guardar captura del `.log` de exportacion sin errores.
5. Restaurar con `backup_restaurar_ultimo`.
6. Ejecutar `11_verificar_backup.sql`.
7. Guardar captura de tablas, vistas/procedimientos y conteos.
