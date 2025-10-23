#!/usr/bin/env bash
# Helper functions shared across scripts

# Esperar a que el dispositivo se conecte por adb
dispositivos_adb() {
  echo "Esperando a que el dispositivo se conecte por adb..."
  while true; do
    sleep 5
    if adb devices | awk 'NR>1 && $2=="device"' | grep -q .; then
      break
    fi
    echo ""
    echo "*****************************************************************************"
    echo "*    Debe habilitar o re-habilitar nuevamente la opcion de depuración       *"
    echo "*    en el dispositivo.                                                     *"
    echo "*    CTRL + C para cancelar                                                 *"
    echo "*****************************************************************************"
    echo ""
  done
  echo "Dispositivo disponible."
}
