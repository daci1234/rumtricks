#!/bin/bash

#TODO
# add check if archive is already downloaded?
# conflict check?

##########

# Forbid root rights
[ "$EUID" = "0" ] && echo -e "\e[91mDon't use sudo or root user to execute chadtricks!\e[0m" && exit

# Use default prefix if nothing is exported
[ -z "$WINEPREFIX" ] && export WINEPREFIX="$HOME/.wine"

# Wine: don't complain about mono/gecho
export WINEDLLOVERRIDES="mscoree=d;mshtml=d"

# Download path (default)
DL_PATH="$PWD"
echo "download path is $DL_PATH"

download()
{
    command -v aria2c >/dev/null 2>&1 && aria2c "$1" -d "$DL_PATH" && return
    command -v wget >/dev/null 2>&1 && wget -N "$1" -P "$DL_PATH" && return
    command -v curl >/dev/null 2>&1 && cd "$DL_PATH" && curl -LO "$1" && cd "$OLDPWD" && return
}

import_dlls()
{
    echo "importing dlls" && wine regedit "$1" 2>/dev/null && wineserver -w
}

extract()
{
    echo "extracting $1" && cd "$DL_PATH" && tar -xf "$1" && cd "$OLDPWD" || exit
}

update()
{
    echo "updating prefix" && wineboot -u 2>/dev/null && wineserver -w
}

check()
{   
    [ "$(sha256sum "$DL_PATH/$1" | awk '{print $1}')" = "$2" ] && return 0 || return 1
}

vcrun2015()
{   
    update
    echo "downloading vcrun2015"
    download "https://github.com/john-cena-141/chadtricks/raw/main/vcrun2015.tar.zst"
    check vcrun2015.tar.zst 2b0bc92d4bd2a48f7e4d0a958d663baa5f3165eab95521e71f812b9030b03eb6
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && return
    extract "vcrun2015.tar.zst"
    cp -r "$DL_PATH"/vcrun2015/drive_c/windows/* "$WINEPREFIX"/drive_c/windows/
    import_dlls "$DL_PATH"/vcrun2015/vcrun2015.reg
    echo "vcrun2015" >> "$WINEPREFIX/chadtricks.log" 
    echo "vcrun2015 installed"
}

vcrun2017()
{
    update
    echo "downloading vcrun2017"
    download https://github.com/john-cena-141/chadtricks/raw/main/vcrun2017.tar.zst
    check vcrun2017.tar.zst 2bcf9852b02f6e707905f0be0a96542225814a3fc19b3b9dcf066f4dd2789773
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && return
    extract vcrun2017.tar.zst
    cp -r "$DL_PATH"/vcrun2017/drive_c/windows/* "$WINEPREFIX"/drive_c/windows/
    import_dlls "$DL_PATH"/vcrun2017/vcrun2017.reg
    echo "vcrun2017" >> "$WINEPREFIX/chadtricks.log" 
    echo "vcrun2017 installed"
}

vcrun2019()
{
    #update
    #echo "downloading vcrun2019"
    #download https://github.com/john-cena-141/chadtricks/raw/main/vcrun2019.tar.zst
    #extract vcrun2019.tar.zst
    #cp -r "$PWD"/vcrun2019/drive_c/windows/* "$WINEPREFIX"/drive_c/windows/*
    #import_dlls "$PWD"/vcrun2019/vcrun2019.reg
    #echo "vcrun2019" >> "$WINEPREFIX/chadtricks.log" 
    echo "vcrun2019 installed"
}

# Running chadtricks
[ $# = 0 ] && echo "add chadtricks" && exit 1
for i in "$@"
do
   "$i" 
done
