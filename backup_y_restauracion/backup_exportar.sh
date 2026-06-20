#!/usr/bin/env bash
set -euo pipefail

# =====================================================================
# ARCHIVO: backup_exportar.sh
# DESCRIPCION:
#   Genera el ultimo backup logico del esquema usando Oracle Data Pump.
#
# USO:
#   ./backup_exportar.sh usuario/password@localhost:1521/XEPDB1 NOMBRE_ESQUEMA
# =====================================================================

if [ "$#" -lt 2 ]; then
  echo "Uso: ./backup_exportar.sh usuario/password@host:puerto/servicio NOMBRE_ESQUEMA"
  exit 1
fi

CONEXION="$1"
ESQUEMA="$2"
DIRECTORIO="GP_BACKUP_DIR"
DUMPFILE="gestion_proyectos_${ESQUEMA}_ultimo.dmp"
LOGFILE="gestion_proyectos_${ESQUEMA}_backup.log"

echo "Generando backup del esquema ${ESQUEMA}..."
expdp "${CONEXION}" \
  schemas="${ESQUEMA}" \
  directory="${DIRECTORIO}" \
  dumpfile="${DUMPFILE}" \
  logfile="${LOGFILE}" \
  reuse_dumpfiles=Y

echo "Backup generado correctamente: ${DUMPFILE}"
