-- =====================================================================
-- ARCHIVO: 10_configurar_directorio_backup.sql
-- DESCRIPCION:
--   Prepara el objeto DIRECTORY que Oracle Data Pump usa para guardar
--   y leer los archivos .dmp y .log de backup.
--
-- EJECUTAR COMO:
--   SYSTEM o un usuario con privilegio CREATE ANY DIRECTORY.
--
-- IMPORTANTE:
--   La ruta debe existir en el servidor donde corre Oracle, no
--   necesariamente en la computadora cliente donde se ejecuta SQL Developer.
--   Si Oracle está en Docker, usar una ruta dentro del contenedor o un
--   volumen montado.
-- =====================================================================

-- Crear el DIRECTORY para Oracle Data Pump
-- reemplazar la ruta por la ubicación donde usted guardará los archivos de backup:
CREATE OR REPLACE DIRECTORY GP_BACKUP_DIR AS
'C:\backup_y_restauracion';

-- Verificación recomendada

SELECT directory_name,
       directory_path
FROM all_directories
WHERE directory_name = 'GP_BACKUP_DIR';

-- =====================================================================
-- FIN DEL SCRIPT
-- =====================================================================