# Setup Tanix C2

Este proyecto contiene scripts para preparar un dispositivo Tanix C2 usando ADB, tanto en Linux como en Windows.

## Requisitos

- Tener instalado **ADB** (Android Debug Bridge).
  - **Linux:** Instala ADB con tu gestor de paquetes (por ejemplo, `sudo apt install adb`).
  - **Windows:** Descarga el SDK Platform Tools desde [aquí](https://developer.android.com/tools/releases/platform-tools).

## Uso en Linux

1. Descargar la ultima version del Laucher kiss desde aqui https://f-droid.org/packages/fr.neamar.kiss/ y ubicarlo en la carpeta "apps" junto al resto de apps que se quira instalar (por ejemplo https://github.com/lsrom/webview-tester/releases).
2. Descargar la ultima version de Ti-Vi desde [aquí](https://docs.ti-vi.com) y poner el archivo en la carpeta ti-vi con el nombre Ti-Vi.apk.
3. Asegúrate de tener permisos de ejecución:
   ```bash
   chmod +x preparar_tanix.bash
   ```
4. Conecta el dispositivo Android por USB y habilita la depuración USB.
5. Ejecuta el script:
   ```bash
   ./preparar_tanix.bash
   ```
6. Ejecutar despues de reinicial el script:
   ```bash
   ./instalar_ti-vi.bash
   ```

## Uso en Windows

1. Descarga el SDK Platform Tools desde [aquí](https://developer.android.com/tools/releases/platform-tools) y extrae el contenido y copia `adb.exe` a la carpeta de este proyecto.
2. Descargar la ultima version del Laucher kiss desde aqui https://f-droid.org/packages/fr.neamar.kiss/ y ubicarlo en la carpeta "apps" junto al resto de apps que se quira instalar (por ejemplo https://github.com/lsrom/webview-tester/releases).
3. Descargar la ultima version de Ti-Vi desde [aquí](https://docs.ti-vi.com) y poner el archivo en la carpeta ti-vi con el nombre Ti-Vi.apk.
4. Habilita la ejecución de scripts de PowerShell (solo la primera vez):
   - Abre PowerShell como administrador y ejecuta:
     ```powershell
     Set-ExecutionPolicy Unrestricted
     ```
5. Conecta el dispositivo Android por USB y habilita la depuración USB.
6. Ejecuta el script:
   ```powershell
   .\preparar_tanix.ps1
   ```
7. Ejecutar despues de reinicial el script:
   ```powershell
   .\instalar_ti-vi.ps1
   ```

## ¿Qué hacen los scripts?

- Desactivan las aplicaciones listadas en `desactivar.txt`.
- Instalan los archivos APK encontrados en la carpeta `apps/`.
- Instala el software Ti-Vi como aplicación de sistema.
- Preguntan si deseas reiniciar el dispositivo al finalizar.

## Notas

- Si es necesario edita el archivo `desactivar.txt` para agregar o quitar los paquetes que deseas desactivar.
- Coloca los archivos APK que quieras instalar en la carpeta `apps/`.
- Si tienes problemas con permisos en Windows, asegúrate de haber ejecutado el paso 4 de la sección de Windows.
