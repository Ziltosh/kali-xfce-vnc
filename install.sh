#!/bin/sh

export WINEPREFIX="/root/.wine"
export WINEARCH="win64"

# Forcer Windows 11 (meilleure compatibilité MT5 selon retours utilisateurs)
wine reg add "HKEY_CURRENT_USER\\Software\\Wine" /v Version /t REG_SZ /d "win11" /f 2>/dev/null || true

# Installer les dépendances requises (configuration GE-Proton qui fonctionne)
winetricks -q dotnet48
winetricks -q vcrun2015
winetricks -q vcrun2019
winetricks -q corefonts

# Re-forcer Windows 11 après winetricks
wine reg add "HKEY_CURRENT_USER\\Software\\Wine" /v Version /t REG_SZ /d "win11" /f 2>/dev/null || true

# Installer MetaTester
wine /root/.wine/drive_c/mt5tester.setup.exe /auto