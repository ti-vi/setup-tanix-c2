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

# Solo instalar si existe Ti-Vi.apk localmente y no existe la carpeta en el Android
tivifile=$(find ti-vi/ -type f -name "tivi_android_*.apk" -exec basename {} \;|head -n 1)
if [ -f ti-vi/$tivifile ]; then
    echo "Instalando Ti-Vi..."
    adb root
    adb remount
    adb shell mount -o rw,remount /system
    adb shell mkdir /system/priv-app/Ti-Vi
    adb push ti-vi/$tivifile /system/priv-app/Ti-Vi/
    adb shell chmod 644 /system/priv-app/Ti-Vi/$tivifile
    echo "Reiniciando equipo, deberá habilitar la conexion ADB nuevamente..."
    sleep 3
    adb reboot
else
  echo "Saltando la instalacion ya que no esta el archivo Ti-Vi.apk localmente"
fi

dispositivos_adb

echo "Asignando permisos a Ti-Vi..."
# Habilitar los permisos estandard
adb shell pm grant com.signage.mipqayfgwg android.permission.ACCESS_FINE_LOCATION
adb shell pm grant com.signage.mipqayfgwg android.permission.ACCESS_COARSE_LOCATION
adb shell pm grant com.signage.mipqayfgwg android.permission.READ_EXTERNAL_STORAGE
adb shell pm grant com.signage.mipqayfgwg android.permission.WRITE_EXTERNAL_STORAGE
adb shell pm grant com.signage.mipqayfgwg android.permission.READ_PHONE_STATE

# Habilitar los permisos especiales
adb shell appops set com.signage.mipqayfgwg SYSTEM_ALERT_WINDOW allow
adb shell appops set com.signage.mipqayfgwg REQUEST_INSTALL_PACKAGES allow
adb shell appops set com.signage.mipqayfgwg SCHEDULE_EXACT_ALARM allow

# Evitar que el sistema cierre la app por inactividad
adb shell dumpsys deviceidle whitelist +com.signage.mipqayfgwg

echo "Finalizado el proceso de instalacion y configuracion de Ti-Vi."

exit 0
