# Script de PowerShell para preparar el dispositivo Tanix (versión Windows)
# Verifica dispositivos ADB, desactiva apps, instala APKs y reinicia opcionalmente

# Verifica si hay dispositivos ADB conectados
$adbDevices = & adb devices | Select-Object -Skip 1 | Where-Object { $_ -match '\bdevice$' }
if (-not $adbDevices) {
    Write-Host "No hay dispositivos ADB detectados. Conecta un dispositivo y vuelve a intentar."
    exit 1
}

# Definir zona horaria desde opciones.txt, si existe
$opcionesFile = "opciones.txt"
$zonahoraria = ""
if (Test-Path $opcionesFile) {
    $linea = Get-Content $opcionesFile | Where-Object { $_ -match '^zonahoraria=' }
    if ($linea) {
        $zonahoraria = $linea -replace '^zonahoraria=', ''
        if ($zonahoraria) {
            Write-Host "Definiendo zona horaria a: $zonahoraria"
            & adb shell setprop persist.sys.timezone $zonahoraria
        } else {
            Write-Host "No se definió zona horaria. Se mantiene la actual."
        }
    }
}

Write-Host "Desactivando apps..."
$appListFile = "desactivar.txt"
if (-not (Test-Path $appListFile)) {
    Write-Host "No se encontró el archivo $appListFile."
    exit 1
}
# Lee la lista de paquetes, ignorando líneas vacías y comentarios
$appList = Get-Content $appListFile | Where-Object { $_ -notmatch '^\s*#' -and $_.Trim() -ne '' }
if (-not $appList) {
    Write-Host "No hay apps para desactivar en $appListFile."
} else {
    foreach ($pkg in $appList) {
        $isDisabled = & adb shell pm list packages -d | Select-String $pkg
        if ($isDisabled) {
            Write-Host "Saltando $pkg (ya está desactivada)"
            continue
        }
        Write-Host "Procesando $pkg ..."
        & adb shell am force-stop $pkg | Out-Null
        & adb shell pm clear $pkg | Out-Null
        & adb shell pm disable-user --user 0 $pkg | Out-Null
    }
}

Write-Host "Instalando apps..."
$apkDir = "apps"
if (-not (Test-Path $apkDir)) {
    Write-Host "No se encontró el directorio $apkDir. Nada para instalar."
    exit 0
}
$apkFiles = Get-ChildItem -Path $apkDir -Filter *.apk
if (-not $apkFiles) {
    Write-Host "No hay archivos apk en $apkDir. Nada para instalar."
    exit 0
}
foreach ($apk in $apkFiles) {
    Write-Host "Instalando $($apk.FullName) ..."
    & adb install -r $apk.FullName
}

# Pregunta al usuario si desea reiniciar el dispositivo
do {
    $respuesta = Read-Host "¿Deseas reiniciar el dispositivo ahora? (y/n)"
} while ($respuesta -notmatch '^[yYnN]$')
if ($respuesta -match '^[yY]$') {
    Write-Host "Reiniciando el dispositivo..."
    & adb reboot
} else {
    Write-Host "Reinicio cancelado."
}

exit 0
