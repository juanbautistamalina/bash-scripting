#!/bin/bash

function ctrl_c(){
	echo -e "\n\n[!] Saliendo...\n"
	tput cnorm; exit 1
}

# Ctrl + C
trap ctrl_c INT

tput civis # Ocultar el cursor

# Recorrer del 1 al 65535, mostrando los puertos abiertos
for port in $(seq 1 65535); do
	(timeout 1 bash -c echo '' > /dev/tcp/127.0.0.1/$port) 2>/dev/null && echo "[!] $port - OPEN" &
done; wait

tput cnorm # Recuperar el cursor
