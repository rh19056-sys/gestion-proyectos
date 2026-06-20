#!/usr/bin/env bash
set -euo pipefail

# =====================================================================
# ARCHIVO: backup_restaurar_ultimo.sh
# DESCRIPCION:
#   Restaura el ultimo backup logico generado con backup_exportar.sh.
#
# USO:
#   ./backup_restaurar_ultimo.sh usuario/password@localhost:1521/XEPDB1 NOMBRE_ESQUEMA
# =====================================================================

if [ "$#" -lt 2 ]; then
  echo "Uso: ./backup_restaurar_ultimo.sh usuario/password@host:puerto/servicio NOMBRE_ESQUEMA"
  exit 1
fi

CONEXION="$1"
ESQUEMA="$2"
DIRECTORIO="GP_BACKUP_DIR"
DUMPFILE="gestion_proyectos_${ESQUEMA}_ultimo.dmp"
LOGFILE="gestion_proyectos_${ESQUEMA}_restore.log"

echo "ADVERTENCIA: esta accion puede reemplazar tablas y datos existentes."
read -r -p "Desea continuar? [s/N] " RESPUESTA
if [ "${RESPUESTA}" != "s" ] && [ "${RESPUESTA}" != "S" ]; then
  echo "Restauracion cancelada."
  exit 0
fi

echo "Restaurando ultimo backup del esquema ${ESQUEMA}..."
impdp "${CONEXION}" \
  schemas="${ESQUEMA}" \
  directory="${DIRECTORIO}" \
  dumpfile="${DUMPFILE}" \
  logfile="${LOGFILE}" \
  table_exists_action=replace

echo "Restauracion finalizada correctamente."
