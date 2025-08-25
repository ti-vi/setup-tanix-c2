#!/bin/bash
# Verifica si hay dispositivos ADB conectados
if ! adb devices | awk 'NR>1 && $2=="device"' | grep -q .; then
  echo "No hay dispositivos ADB detectados. Conecta un dispositivo y vuelve a intentar."
  exit 1
fi

# Script para desactivar aplicaciones y luego instalar archivos APK en un dispositivo Android usando ADB.
echo "Desactivando apps..."
# Archivo que contiene la lista de paquetes a desactivar, uno por línea.
APP_LIST_FILE="desactivar.txt"
# Lee la lista de paquetes, ignorando líneas vacías y comentarios, y los une en una sola línea separada por espacios.
APP_LIST=$(grep -v '^\s*#' "$APP_LIST_FILE" | grep -v '^\s*$' | xargs)
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
fi

echo "Instalando apps..."
# Carpeta donde se encuentran los archivos APK a instalar.
APK_DIR="apps"
# Busca archivos con extensión .apk en el directorio especificado.
APK_FILES=("$APK_DIR"/*.apk)
# Si no hay archivos APK, muestra un mensaje y termina el script.
if [ ! -e "${APK_FILES[0]}" ]; then
  echo "No hay archivos apk en $APK_DIR. Nada para instalar."
  exit 0
fi
# Instala cada archivo APK encontrado en el directorio.
for apk in "${APK_FILES[@]}"; do
  echo "Instalando $apk ..."
  adb install -r "$apk"
done

# Pregunta al usuario si desea reiniciar el dispositivo
read -p "¿Deseas reiniciar el dispositivo ahora? (y/n): " respuesta
if [[ "$respuesta" =~ ^[sSyY]$ ]]; then
  echo "Reiniciando el dispositivo..."
  adb reboot
else
  echo "Reinicio cancelado."
fi

exit 0
