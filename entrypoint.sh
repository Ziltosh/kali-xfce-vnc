#!/bin/bash
set -e

# Afficher les logs sur stdout/stderr
exec > >(tee /var/log/entrypoint.log) 2>&1

# 1) Démarrer Xvfb sur DISPLAY :0
export DISPLAY=:0
Xvfb :0 -screen 0 1280x800x16 &

# 2) Démarrer le bureau XFCE sous cet affichage
startxfce4 &

# 3) Lancer x11vnc pour partager :0 sur le port 5900
x11vnc -display :0 -nopw -forever -shared -rfbport 5900 &

# 4) Lancer noVNC (websockify) en avant-plan sur 8080
websockify --web=/usr/share/novnc/ 8080 localhost:5900