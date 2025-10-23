#!/bin/bash

# Ejecutar primero el script de ti-vi y luego el de tanix
run_scripts_in_order() {
  # Ruta a los scripts
  local TI_VI_SCRIPT="ti-vi/ti-vi.bash"
  local TANIX_SCRIPT="tanix/tanix.bash"

  if [ -f "$TI_VI_SCRIPT" ]; then
    echo "Ejecutando $TI_VI_SCRIPT..."
    bash "$TI_VI_SCRIPT"
  else
    echo "Advertencia: $TI_VI_SCRIPT no existe, se omite."
  fi

  if [ -f "$TANIX_SCRIPT" ]; then
    echo "Ejecutando $TANIX_SCRIPT..."
    bash "$TANIX_SCRIPT"
  else
    echo "Advertencia: $TANIX_SCRIPT no existe, se omite."
  fi
}

# Llamada principal
run_scripts_in_order

