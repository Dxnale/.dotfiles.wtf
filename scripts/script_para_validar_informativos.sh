#!/bin/bash

# Ruta del repositorio buk-webapp
REPO_PATH="/home/benja/buk-webapp"

#Carpeta para buscar en los archivos
CARPETA="$REPO_PATH/packs/integraciones/colombia/contabilidad/app/services/exportador/contabilidad/colombia/personalizadas/"

if [ ! -d "$CARPETA" ]; then
    echo "La carpeta $CARPETA no existe. Verifica la ruta del repositorio."
    exit 1
fi

archivos_totales=$(find "$CARPETA" -type f | wc -l)

lista_archivos=$(grep -rl "employee" "$CARPETA" 2>/dev/null) #Aquí cambiamos vacaciones_disfrutadas por la linea de código que queremos buscar entre los archivos

cantidad_archivos=$(echo "$lista_archivos" | wc -l)

if [ "$archivos_totales" -eq 0 ]; then
    porcentaje=0
else
    porcentaje=$(echo "scale=2; ($cantidad_archivos/$archivos_totales)*100" | bc)
fi

if [ -z "$lista_archivos" ]; then
    echo "No se encontraron archivos con 'vacaciones_disfrutadas' en $CARPETA."
else
    echo "Se encontraron los siguientes archivos:"
    echo "$lista_archivos"
    echo "Total de archivos en la carpeta: $archivos_totales"
    echo "Total de archivos a encontrados: $cantidad_archivos"
    echo "Porcentaje de archivos encontrados (100% es el total de todos los archivos)': $porcentaje%"
fi
