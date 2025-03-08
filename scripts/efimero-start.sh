#!/bin/bash

# Ejecuta los comandos en pestañas separadas
gnome-terminal --tab --title="Buk Server" -- zsh -c "cd ~/buk/buk-webapp; okteto exec web -- bash -c 'bin/rails s -b 0.0.0.0 -p 8080'";
gnome-terminal --tab --title="Front" -- zsh -c "cd ~/buk/buk-webapp; okteto exec web -- bash -c 'bin/webpack-dev-server'";
gnome-terminal --tab --title="Jobs" -- zsh -c "cd ~/buk/buk-webapp; okteto exec web -- bash -c 'bin/rails jobs:work'";
gnome-terminal --tab --title="Console" -- zsh -c "cd ~/buk/buk-webapp; okteto exec web -- bash -c 'bin/rails c'";

# Espera 5 segundos
sleep 5

# Cierra la pestaña del terminal donde se ejecutó el script
exit 0