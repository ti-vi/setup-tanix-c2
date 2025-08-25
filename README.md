# Setup Tanix C2

Este proyecto contiene scripts para preparar un dispositivo Tanix C2 usando ADB, tanto en Linux como en Windows.

## Requisitos

- Tener instalado **ADB** (Android Debug Bridge).
  - **Linux:** Instala ADB con tu gestor de paquetes (por ejemplo, `sudo apt install adb`).
  - **Windows:** Descarga el SDK Platform Tools desde [aquí](https://developer.android.com/tools/releases/platform-tools).

## Uso en Linux

1. Asegúrate de tener permisos de ejecución:
   ```bash
   chmod +x preparar_tanix.bash
   ```
2. Conecta el dispositivo Android por USB y habilita la depuración USB.
3. Ejecuta el script:
   ```bash
   ./preparar_tanix.bash
   ```

## Uso en Windows

1. Descarga el SDK Platform Tools desde [aquí](https://developer.android.com/tools/releases/platform-tools).
2. Extrae el contenido y copia `adb.exe` a la carpeta de este proyecto.
3. Habilita la ejecución de scripts de PowerShell (solo la primera vez):
   - Abre PowerShell como administrador y ejecuta:
     ```powershell
     Set-ExecutionPolicy Unrestricted
     ```
4. Conecta el dispositivo Android por USB y habilita la depuración USB.
5. Ejecuta el script:
   ```powershell
   .\preparar_tanix.ps1
   ```

## ¿Qué hacen los scripts?

- Desactivan las aplicaciones listadas en `desactivar.txt`.
- Instalan los archivos APK encontrados en la carpeta `apps/`.
- Preguntan si deseas reiniciar el dispositivo al finalizar.

## Notas

- Si es necesario edita el archivo `desactivar.txt` para agregar o quitar los paquetes que deseas desactivar.
- Coloca los archivos APK que quieras instalar en la carpeta `apps/`.
- Si tienes problemas con permisos en Windows, asegúrate de haber ejecutado el paso 3 de la sección de Windows.
