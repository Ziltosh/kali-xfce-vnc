#!/bin/sh

export WINEPREFIX="/root/.wine"
export WINEARCH="win64"

# Forcer Windows 10 avant installation
wine reg add "HKEY_CURRENT_USER\\Software\\Wine" /v Version /t REG_SZ /d "win10" /f 2>/dev/null || true
winecfg -v win10

# Installer vcrun2019
winetricks -q vcrun2019

# Re-forcer Windows 10 après (winetricks peut le changer)
wine reg add "HKEY_CURRENT_USER\\Software\\Wine" /v Version /t REG_SZ /d "win10" /f 2>/dev/null || true
winecfg -v win10

# Installer MetaTester
wine /root/.wine/drive_c/mt5tester.setup.exe /auto