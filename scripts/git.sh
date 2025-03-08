#!/bin/bash

function show_links {
  echo "\nLinks generados al hacer push:"
  git remote -v | grep fetch | awk '{print $2}' | while read remote_url; do
    branch_name=$(git branch --show-current)
    echo "${remote_url%.git}/tree/$branch_name"
  done
}

cd ~/buk/buk-webapp || { echo "No se pudo acceder al repositorio."; exit 1; }

echo "¿Qué tipo de rama estás creando? (hotfix, bugfix, feature, refactor, chore):"
read -r branch_type

valid_types=(hotfix bugfix feature refactor chore)
if [[ ! " ${valid_types[@]} " =~ " ${branch_type} " ]]; then
  echo "Tipo de rama inválido. Debe ser uno de: ${valid_types[*]}"
  exit 1
fi

echo "Cambiando a la rama base adecuada..."
if [[ $branch_type == "hotfix" ]]; then
  git checkout production
  git pull
else
  git checkout master
  git pull
fi

echo "¿Cuál es el nombre del cliente?"
read -r client_name

echo "¿Qué hiciste en esta rama? (Descripción corta)"
read -r branch_description
branch_description=${branch_description// /-}

branch_name="${branch_type}/integraciones/${client_name}/${branch_description}"
git checkout -b "$branch_name"

echo "\nArchivos modificados disponibles para agregar al commit:"
git status -s

echo "¿Son estos los archivos correctos para el commit? (S/N):"
read -r confirm_files

if [[ $confirm_files == "S" || $confirm_files == "s" ]]; then
  git add .
else
  echo "Ingresa los archivos que deseas agregar separados por espacios:"
  read -r files_to_add
  git add $files_to_add
fi

echo "¿Cuál es el mensaje del commit?"
read -r commit_message

git commit -m "$commit_message"

git push --set-upstream origin "$branch_name"

show_links

echo "\n¡Proceso completado!"
