#!/bin/bash

# Forbid root rights
[ "$EUID" = "0" ] && echo -e "\e[91mDon't use sudo or root user to execute chadtricks!\e[0m" && exit

# Use default prefix if nothing is exported
[ -z "$WINEPREFIX" ] && export WINEPREFIX="$HOME/.wine"

# Download path (default) 
DL_PATH="$PWD"

while getopts g: flag
do
    case "${flag}" in
        g) DL_PATH="$PWD/game";;
        *) exit 1;;
    esac
done

echo "$DL_PATH"


download()
{
    aria2c "$1" -d "$DL_PATH" 2>/dev/null || wget "$1" -P "$DL_PATH" 2>/dev/null || cd "$DL_PATH" && curl -LO "$1" 2>/dev/null && cd - || exit
}

import_dlls()
{
    echo "importing dlls" && wine regedit "$1" 2>/dev/null
}

extract()
{
    echo "extracting $1" && cd "$DL_PATH" && tar -xf "$1" && cd - || exit
}

update()
{
    echo "updating prefix" && wineboot -u 2>/dev/null
}

vcrun2015()
{
    update
    download https://github.com/john-cena-141/chadtricks/raw/main/vcrun2015.tar.zst
    extract "vcrun2015.tar.zst"
    cp -r "$DL_PATH"/vcrun2015/drive_c/windows/* "$WINEPREFIX"/drive_c/windows/*
    import_dlls "$DL_PATH"/vcrun2015/vcrun2015.reg
    echo "vcrun2015" >> "$WINEPREFIX/chadtricks.log" 
    echo "vcrun2015 installed"
}

vcrun2017()
{
    #update
    #download https://github.com/john-cena-141/chadtricks/raw/main/vcrun2017.tar.zst
    #extract vcrun2017.tar.zst
    #cp -r "$PWD"/vcrun2017/drive_c/windows/* "$WINEPREFIX"/drive_c/windows/*
    #import_dlls "$PWD"/vcrun2017/vcrun2017.reg
    #echo "vcrun2017" >> "$WINEPREFIX/chadtricks.log" 
    echo "vcrun2017 installed"
}

vcrun2019()
{
    #update
    #download https://github.com/john-cena-141/chadtricks/raw/main/vcrun2019.tar.zst
    #extract vcrun2019.tar.zst
    #cp -r "$PWD"/vcrun2019/drive_c/windows/* "$WINEPREFIX"/drive_c/windows/*
    #import_dlls "$PWD"/vcrun2019/vcrun2019.reg
    #echo "vcrun2019" >> "$WINEPREFIX/chadtricks.log" 
    echo "vcrun2019 installed"
}

[ $# = 0 ] && echo "add chadtricks"

# Verbs
for i in "$@"
do
   "$i" 2>/dev/null
done
