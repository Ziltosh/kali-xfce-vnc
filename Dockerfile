FROM kalilinux/kali-rolling

ENV TITLE=Metatrader5
ENV WINEPREFIX="/root/.wine"
ENV WINEDEBUG=-all

# 1. Installer environnement graphique, VNC, Firefox, Ping, etc.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    xfce4 xfce4-goodies \
    curl \
    wget \
    gedit \
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
    && wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key \
    && wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install --install-recommends -y winehq-stable \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 2. Créer utilisateur non-root (user:user)
RUN useradd -m user && echo "user:user" | chpasswd && adduser user sudo && \
    mkdir -p /home/user/.vnc && chown -R user:user /home/user

# 3. Créer un index.html pour noVNC
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# 4. Copier le script d'entrée
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 5. Copier le script de MT5
COPY mt5.sh /root/mt5.sh
RUN chmod +x /root/mt5.sh

RUN /root/mt5.sh

# 5. Exposer ports VNC et noVNC
EXPOSE 8080

# 6. Commande de démarrage
CMD ["/entrypoint.sh"]