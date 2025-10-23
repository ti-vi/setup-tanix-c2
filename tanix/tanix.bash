#!/bin/bash

# Source shared helper functions
_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
if [ -f "$_SCRIPT_DIR/../lib/adb_helpers.sh" ]; then
  # shellcheck source=/dev/null
  . "$_SCRIPT_DIR/../lib/adb_helpers.sh"
else
  echo "Advertencia: helper 'lib/adb_helpers.sh' no encontrado. Se espera que dispositivos_adb esté disponible en el entorno."
fi

dispositivos_adb

echo "Instalando apps..."
# Busca archivos con extensión .apk en el directorio especificado.
APK_FILES=($_SCRIPT_DIR/apps/*.apk)
# Si no hay archivos APK, muestra un mensaje y termina el script.
ls $APK_FILES
if [ ! -e "${APK_FILES[0]}" ]; then
  echo "No hay archivos apk en $APK_DIR. Nada para instalar."
  exit 0
fi
# Instala cada archivo APK encontrado en el directorio.
for apk in "${APK_FILES[@]}"; do
  echo "Instalando $apk ..."
  adb install -r "$apk"
done

# Definir zona horaria desde opciones.txt
OPCIONES_FILE="$_SCRIPT_DIR/opciones.txt"
if [ -f "$OPCIONES_FILE" ]; then
  zonahoraria=$(grep '^zonahoraria=' "$OPCIONES_FILE" | cut -d'=' -f2)
  if [ -n "$zonahoraria" ]; then
    echo "Definiendo zona horaria a: $zonahoraria"
    adb shell settings put global auto_time_zone 0
    adb shell setprop persist.sys.timezone "$zonahoraria"
  else
    echo "No se definió zona horaria. Se mantiene la actual."
  fi
fi

# Función para desactivar aplicaciones usando la lista de desactivar.txt
desactivar_apps() {
  echo "Depurando apps..."
  # Archivo que contiene la lista de paquetes a desactivar, uno por línea.
  local APP_LIST_FILE="$_SCRIPT_DIR/desactivar.txt"
  # Lee la lista de paquetes, ignorando líneas vacías y comentarios, y los une en una sola línea separada por espacios.
  local APP_LIST=$(grep -v '^\s*#' "$APP_LIST_FILE" | grep -v '^\s*$' | xargs)
  # Si la lista está vacía, sale con un mensaje.
  if [ -z "$APP_LIST" ]; then
    echo "No hay apps para desactivar en $APP_LIST_FILE."
  else
    # Para cada paquete en la lista, verifica primero si ya está desactivado.
    for pkg in $APP_LIST; do
      # Comprueba si el paquete ya está desactivado
      if adb shell pm list packages -d | grep -q "$pkg"; then
        echo "Saltando $pkg (ya está desactivada)"
        continue
      fi
      echo "Procesando $pkg ..."
      adb shell am force-stop "$pkg" > /dev/null 2>&1
      adb shell pm clear "$pkg" > /dev/null 2>&1
      adb shell pm disable-user --user 0 "$pkg" > /dev/null 2>&1
    done
    sleep 3
    adb reboot
  fi
}

# Llamar a la función para desactivar apps
desactivar_apps
echo "Reiniciando equipo, deberá habilitar la conexion ADB nuevamente..."

dispositivos_adb
echo "Ejecutando segundo paso de depuración."
# Llamar a la función para desactivar apps
desactivar_apps

exit 0
