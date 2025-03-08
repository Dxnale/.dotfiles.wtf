#!/bin/bash

# Verifica si el comando anterior se ejecutó correctamente
check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: El comando anterior falló. Saliendo del script."
        exit 1
    fi
}

EXPECTED_DIR=~/buk/buk-webapp
CONFIG_FILE=~/.teleport_user

# Verificar si el directorio existe
if [ -d "$EXPECTED_DIR" ]; then
    echo "Cambiando al directorio: $EXPECTED_DIR"
    cd "$EXPECTED_DIR" || { echo "Error: No se pudo cambiar al directorio $EXPECTED_DIR"; exit 1; }
else
    echo "Error: No se encontró el directorio esperado '$EXPECTED_DIR'."
    exit 1
fi

# Verificar si se proporcionaron los argumentos correctos
if [ "$#" -ne 3 ]; then
    echo "Uso: $0 <namespace> <puerto local para 8080> <puerto local para postgres>"
    echo "Ejemplo: $0 postgres-14-43889 8080 5433"
    exit 1
fi

NAMESPACE="$1"
PORT1="$2"
PORT2="$3"

# Validar namespace (debe contener solo caracteres alfanuméricos y guiones)
if [[ ! "$NAMESPACE" =~ ^[a-zA-Z0-9-]+$ ]]; then
    echo "Error: Namespace inválido. Solo se permiten caracteres alfanuméricos y guiones."
    exit 1
fi

# Validar que los puertos sean números entre 1 y 65535
if ! [[ "$PORT1" =~ ^[0-9]+$ ]] || [ "$PORT1" -lt 1 ] || [ "$PORT1" -gt 65535 ]; then
    echo "Error: El puerto '$PORT1' no es válido. Debe estar entre 1 y 65535."
    exit 1
fi

if ! [[ "$PORT2" =~ ^[0-9]+$ ]] || [ "$PORT2" -lt 1 ] || [ "$PORT2" -gt 65535 ]; then
    echo "Error: El puerto '$PORT2' no es válido. Debe estar entre 1 y 65535."
    exit 1
fi

# Modificar el archivo okteto.yml
sed -i "s/^namespace: .*/namespace: $NAMESPACE/" okteto.yml
sed -i "s|    - [0-9]\+:[0-9]\+|    - $PORT1:8080|" okteto.yml
sed -i "s|    - [0-9]\+:postgres:[0-9]\+|    - $PORT2:postgres:$PORT2|" okteto.yml

# Eliminar la sección de recursos completamente, incluyendo cualquier línea residual de configuración
sed -i '/resources:/,/limits:/d' okteto.yml
sed -i '/cpu:/d' okteto.yml
sed -i '/memory:/d' okteto.yml

# Modificar el archivo .env.development.batman
if [ -f ".env.development.batman" ]; then
    echo "Modificando .env.development.batman"
    sed -i "s/^OKTETO_NAMESPACE=.*/OKTETO_NAMESPACE= $NAMESPACE/" .env.development.batman
    echo "Modificaciones aplicadas con éxito a .env.development.batman"
else
    echo "Advertencia: No se encontró el archivo .env.development.batman"
fi

echo "Modificaciones aplicadas con éxito a okteto.yml"

# Verificar si existe el archivo de configuración y obtener el usuario de Teleport
teleport_user=""
if [ -f "$CONFIG_FILE" ]; then
    teleport_user=$(cat "$CONFIG_FILE")
    echo "Usuario de Teleport encontrado: $teleport_user"
else
    # Solicitar el usuario de Teleport si no se encuentra
    read -p "Introduce el usuario de Teleport: " teleport_user

    # Guardar el usuario de Teleport para futuras ejecuciones
    echo "$teleport_user" > "$CONFIG_FILE"
    echo "Usuario de Teleport guardado para futuras ejecuciones"
fi

# Paso 4: Iniciar sesión en Teleport
echo "Iniciando sesión en Teleport..."
tsh login --proxy=teleport.infra.buk.cl:443 --auth=local --user="$teleport_user"
check_success

# Paso 5: Iniciar sesión en el cluster de Kubernetes
echo "Iniciando sesión en el cluster de Kubernetes..."
tsh kube login sandbox-prod
check_success

# Paso 6: Configurar el contexto de Okteto
echo "Configurando el contexto de Okteto..."
okteto context use teleport.infra.buk.cl-sandbox-prod --namespace="$NAMESPACE"
check_success

echo "¡Todos los pasos se han completado con éxito!"
okteto up