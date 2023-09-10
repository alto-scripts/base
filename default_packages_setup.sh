#!/bin/bash

# Liste der zu installierenden Pakete
pakete=(
    curl
    wget
    vim
    htop
    unetbootin
    vlc
    atom
)

# Prüfen, ob der Nutzer Root ist oder sudo verwendet werden muss
if [[ $EUID -ne 0 ]]; then
   SUDO='sudo'
else
   SUDO=''
fi

# Variable zur Speicherung der installierten Pakete
installierte_pakete=()

# Pakete installieren
for paket in "${pakete[@]}"; do
    if dpkg -l | grep -q "^ii  $paket "; then
        echo "$paket ist bereits installiert."
    else
        $SUDO apt install -y $paket
        if [[ $? -eq 0 ]]; then
            installierte_pakete+=($paket)
        fi
    fi
done

# Installierte Pakete auflisten
if [ ${#installierte_pakete[@]} -ne 0 ]; then
    echo "Erfolgreich installierte Pakete: ${installierte_pakete[*]}"
else
    echo "Keine neuen Pakete installiert."
fi
