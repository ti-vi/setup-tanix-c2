#!/bin/bash
# Verifica si hay dispositivos ADB conectados
if ! adb devices | awk 'NR>1 && $2=="device"' | grep -q .; then
  echo "No hay dispositivos ADB detectados. Conecta un dispositivo y vuelve a intentar."
  exit 1
fi

# Solo instalar si existe Ti-Vi.apk localmente y no existe la carpeta en el Android
if [ -f ti-vi/Ti-Vi.apk ]; then
  if ! adb shell test -d /system/priv-app/Ti-Vi/ ; then
    echo "Instalando Ti-Vi..."
    adb root
    adb remount
    adb shell mount -o rw,remount /system
    adb shell mkdir /system/priv-app/Ti-Vi
    adb push ti-vi/Ti-Vi.apk /system/priv-app/Ti-Vi/
    adb shell chmod 644 /system/priv-app/Ti-Vi/Ti-Vi.apk
    sleep 3
    adb reboot
  else
    echo "Saltando la instalacion ya que Ti-Vi ya existe en el dispositivo."
  fi
else
  echo "Saltando la instalacion ya que no esta el archivo Ti-Vi.apk localmente"
fi

  # Esperar a que el dispositivo esté disponible por adb tras el reinicio
  echo "Esperando a que el dispositivo se reinicie y se conecte por adb..."
  while true; do
    sleep 3
    if adb devices | awk 'NR>1 && $2=="device"' | grep -q .; then
      break
    fi
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
