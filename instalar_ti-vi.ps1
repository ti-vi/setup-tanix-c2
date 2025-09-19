# Verifica si hay dispositivos ADB conectados
$adbDevices = & adb devices
if (-not ($adbDevices -match "device`r?`n")) {
    Write-Host "No hay dispositivos ADB detectados. Conecta un dispositivo y vuelve a intentar."
    exit 1
}

# Solo instalar si existe Ti-Vi.apk localmente y no existe la carpeta en el Android
if (Test-Path "ti-vi/Ti-Vi.apk") {
    $folderExists = & adb shell test -d /system/priv-app/Ti-Vi/
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Instalando Ti-Vi..."
        & adb root
        & adb remount
        & adb shell mount -o rw,remount /system
        & adb shell mkdir /system/priv-app/Ti-Vi
        & adb push ti-vi/Ti-Vi.apk /system/priv-app/Ti-Vi/
        & adb shell chmod 644 /system/priv-app/Ti-Vi/Ti-Vi.apk
        Start-Sleep -Seconds 3
        & adb reboot
    } else {
        Write-Host "Saltando la instalacion ya que Ti-Vi ya existe en el dispositivo."
    }
} else {
    Write-Host "Saltando la instalacion ya que no esta el archivo Ti-Vi.apk localmente"
}

# Esperar a que el dispositivo esté disponible por adb tras el reinicio
Write-Host "Esperando a que el dispositivo se reinicie y se conecte por adb..."
do {
    Start-Sleep -Seconds 3
    $adbDevices = & adb devices
} until ($adbDevices -match "device`r?`n")
Write-Host "Dispositivo disponible. Ejecutando configuración de permisos."

# Habilitar los permisos estandard
& adb shell pm grant com.signage.mipqayfgwg android.permission.ACCESS_FINE_LOCATION
& adb shell pm grant com.signage.mipqayfgwg android.permission.ACCESS_COARSE_LOCATION
& adb shell pm grant com.signage.mipqayfgwg android.permission.READ_EXTERNAL_STORAGE
& adb shell pm grant com.signage.mipqayfgwg android.permission.WRITE_EXTERNAL_STORAGE
& adb shell pm grant com.signage.mipqayfgwg android.permission.READ_PHONE_STATE

# Habilitar los permisos especiales
& adb shell appops set com.signage.mipqayfgwg SYSTEM_ALERT_WINDOW allow
& adb shell appops set com.signage.mipqayfgwg REQUEST_INSTALL_PACKAGES allow
& adb shell appops set com.signage.mipqayfgwg SCHEDULE_EXACT_ALARM allow

# Evitar que el sistema cierre la app por inactividad
& adb shell dumpsys deviceidle whitelist +com.signage.mipqayfgwg

exit 0
