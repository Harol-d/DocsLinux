#!/usr/bin/env bash

#1 se define un archivo en la carpeta /tmp que desaparece cuando se inicia el sistema
FILE="/tmp/reload"

if [ ! -f "$FILE" ]; then 
	echo "comprobado actualizaciones"
	sudo pacman -Suy

	touch "$FILE"		
	echo "Sistema actualizado"
else 
	:
fi

