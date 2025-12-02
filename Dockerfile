FROM kalilinux/kali-rolling

# 1. Installer environnement graphique, VNC, Firefox, Ping, etc.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xfce4 xfce4-goodies \
    curl \
    wget \
    nano \
    x11vnc \
    novnc \
    sudo \
    python3-websockify \
    xvfb \
    xauth \
    dbus-x11 \
    firefox-esr \
    iputils-ping \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Créer utilisateur non-root (user:user)
RUN useradd -m user && echo "user:user" | chpasswd && adduser user sudo && \
    mkdir -p /home/user/.vnc && chown -R user:user /home/user

# 3. Copier le script d'entrée
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 4. Exposer ports VNC et noVNC
EXPOSE 5900 8080

# 5. Commande de démarrage
CMD ["/entrypoint.sh"]