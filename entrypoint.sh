#!/bin/bash
set -e

# Afficher les logs sur stdout/stderr
exec > >(tee /var/log/entrypoint.log) 2>&1

# Mot de passe VNC (configurable via variable d'environnement)
VNC_PASSWORD="${VNC_PASSWORD:-changeme}"

# 1) Démarrer Xvfb sur DISPLAY :0
export DISPLAY=:0
Xvfb :0 -screen 0 1280x800x16 &
sleep 2

# 2) Désactiver screensaver et mise en veille
xset s off          # Désactiver screensaver
xset -dpms          # Désactiver DPMS (gestion alimentation écran)
xset s noblank      # Pas de blanking écran

# 3) Démarrer le bureau XFCE sous cet affichage
startxfce4 &

# 4) Lancer x11vnc pour partager :0 sur le port 5900 (avec mot de passe)
x11vnc -display :0 -passwd "$VNC_PASSWORD" -forever -shared -rfbport 5900 &

# 5) Lancer noVNC (websockify) en avant-plan sur 8080
websockify --web=/usr/share/novnc/ 8080 localhost:5900