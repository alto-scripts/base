#!/bin/bash

# Dieses Skript benennt alle Dateien im aktuellen Ordner um.
# Die Dateien werden nach ihrer Größe sortiert und dann nummeriert.

# Anzahl aller Dateien im Verzeichnis (Ordner, Skript und Dateien ohne Erweiterung ausgeschlossen)
total_count=$(find . -maxdepth 1 -type f -name "*.*" -print | grep -v "./$(basename "$0")" | wc -l)

# Anzahl der anzuzeigenden Dateien (mindestens 0, höchstens 5)
display_count=$(( total_count > 5 ? 5 : total_count ))

# Anzahl der "weiteren" Dateien
remaining_count=$((total_count > 5 ? total_count - 5 : 0))

# Erste 5 oder weniger Dateien in hellem Rot anzeigen
clear
echo "------------------------"
echo -e "\e[31mWARNUNG: Alle Dateien im aktuellen Ordner werden umbenannt (außer Ordner und Dateien ohne Namenserweiterung)\n\e[0m"
echo -e "\e[91mErste ${display_count} Dateien im aktuellen Verzeichnis:"
find . -maxdepth 1 -type f -name "*.*" -print | sed 's|^\./||' | grep -v "$(basename "$0")" | sort | head -${display_count}
if [ $remaining_count -gt 0 ]; then
  echo -e "... und $remaining_count weitere\e[0m"
else
  echo -e "\e[0m"
fi
echo "------------------------"

# Bestätigung
read -p "Möchten Sie fortfahren? (j/n): " confirm

# Name des laufenden Skripts
script_name=$(basename "$0")

# Statistik-Zähler
renamed_count=0
ignored_folder_count=0
ignored_no_extension_count=0

if [[ $confirm == "j" || $confirm == "J" ]]; then
  read -p "Welchen Erkennungszusatz möchten Sie verwenden? (Leer lassen für keinen): " suffix

  # Dateien und Ordner erfassen
  mapfile -t all_items < <(find . -maxdepth 1 -type f -printf '%s %p\n' | sort -rn -k1,1 | cut -d ' ' -f2- | sed 's|^\./||')
  mapfile -t all_folders < <(find . -maxdepth 1 -type d | sed 's|^\./||' | grep -v "^\.$" | grep -v "$(basename "$0")")

  # Zähler initialisieren
  counter=1

  for item in "${all_items[@]}"; do
    if [[ "$item" == "$script_name" ]]; then
      continue
    fi

    extension="${item##*.}"

    if [[ "$extension" == "$item" ]]; then
      ((ignored_no_extension_count++))
      continue
    fi

    padded_counter=$(printf "%04d" $counter)

    if [[ -z $suffix ]]; then
      new_name="${padded_counter}.${extension}"
    else
      new_name="${padded_counter}-${suffix}.${extension}"
    fi

    mv "$item" "$new_name"
    ((counter++))
    ((renamed_count++))
  done

  ignored_folder_count=${#all_folders[@]}

  # Ausgabe der Statistik
  echo -e "Umbenannte Dateien: \e[32m$renamed_count\e[0m"
  echo -e "Ignorierte Ordner: \e[33m$ignored_folder_count\e[0m"
  echo -e "Dateien ohne Namenserweiterung: \e[31m$ignored_no_extension_count\e[0m"
else
  echo "Vorgang abgebrochen."
fi
