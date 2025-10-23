# Setup Tanix C2

Este proyecto contiene scripts para preparar un dispositivo Tanix C2 usando ADB en Linux.

## Requisitos

- Tener instalado **ADB** (Android Debug Bridge).
  - **Linux:** Instala ADB con tu gestor de paquetes (por ejemplo, `sudo apt install adb`).

## Uso en Linux

1. Descargar la ultima version del Laucher kiss desde aqui https://f-droid.org/packages/fr.neamar.kiss/ y ubicarlo en la carpeta "tanix/apps/" junto al resto de apps que se quiera instalar (por ejemplo https://github.com/lsrom/webview-tester/releases y https://github.com/zhanghai/MaterialFiles/releases).
2. Descargar la ultima version de Ti-Vi desde [aquí](https://docs.ti-vi.com) y poner el archivo en la carpeta ti-vi.
3. Asegúrate de tener permisos de ejecución:
   ```bash
   chmod +x instalar.bash
   ```
4. Conecta el dispositivo Android por USB y habilita la depuración USB.
5. Ejecuta el script:
   ```bash
   ./instalar.bash
   ```

## ¿Qué hacen los scripts?

- Desactivan las aplicaciones listadas en `tanix/desactivar.txt`.
- Instalan los archivos APK encontrados en la carpeta `tanix/apps/`.
- Instala el software Ti-Vi como aplicación de sistema.

## Notas

- Si es necesario edita el archivo `tanix/desactivar.txt` para agregar o quitar los paquetes que deseas desactivar.
- Coloca los archivos APK que quieras instalar en la carpeta `tanix/apps/`.
