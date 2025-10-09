#!/bin/bash
# Verifica si hay dispositivos ADB conectados
if ! adb devices | awk 'NR>1 && $2=="device"' | grep -q .; then
  echo "No hay dispositivos ADB detectados. Conecta un dispositivo y vuelve a intentar."
  exit 1
fi

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
    sleep 3
    adb reboot
else
  echo "Saltando la instalacion ya que no esta el archivo Ti-Vi.apk localmente"
fi

# Esperar a que el dispositivo esté disponible por adb tras el reinicio
echo "Esperando a que el dispositivo se reinicie y se conecte por adb..."
while true; do
  sleep 5
  if adb devices | awk 'NR>1 && $2=="device"' | grep -q .; then
    break
  fi
  echo ""
  echo "*****************************************************************************"
  echo "*    Debe habilitar nuevamente la opcion de depuración en el dispositivo.   *"
  echo "*         Developer Options > Debugging > USB0 device mode enable           *"
  echo "*                           CTRL + C para cancelar                          *"
  echo "*****************************************************************************"
  echo ""
done
echo "Dispositivo disponible. Ejecutando configuración de permisos."

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

exit 0
