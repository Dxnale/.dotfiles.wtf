#!/bin/bash
cd buk-webapp/
read -p "Por favor, ingresa la URL del archivo: " archivo_url

DISABLE_SPRING=1 COVERAGE=1 bin/rails t "$archivo_url"

echo "holamundo"
