#!/bin/bash

#TODO
# new structure for archives

##########

# Forbid root rights
[ "$EUID" = "0" ] && echo -e "\e[91mDon't use sudo or root user to execute chadtricks!\e[0m" && exit

# Use default prefix if nothing is exported
[ -z "$WINEPREFIX" ] && export WINEPREFIX="$HOME/.wine"

# Wine: don't complain about mono/gecho
export WINEDLLOVERRIDES="mscoree=d;mshtml=d"
export WINEDEBUG="-all"

# All operations are relative to chadtricks' location
cd "$(dirname "$(realpath "$0")")" || exit 1

# Download path (default)
echo "download path is $PWD"

download()
{
    command -v aria2c >/dev/null 2>&1 && aria2c "$1" && return
    command -v wget >/dev/null 2>&1 && wget -N "$1" && return
    command -v curl >/dev/null 2>&1 && curl -LO "$1" && return
}

import_dlls()
{
    echo "importing dlls" && wine regedit "$1" && wine64 regedit "$1" && wineserver -w
}

extract()
{
    echo "extracting $1" && tar -xf "$1"
}

update()
{
    echo "updating prefix" && wineboot -u && wineserver -w
}

check()
{
    [ "$(sha256sum "$PWD/$1" | awk '{print $1}')" = "$2" ] && return 0 || return 1
}

register_dll()
{
    for i in "$@"
    do
    wine regsvr32 "$i" && wine64 regsvr32 "$i"
    done
}

update-self()
{
    echo "updating chadtricks"
    download https://raw.githubusercontent.com/john-cena-141/chadtricks/main/chadtricks.sh
    chmod +x "$PWD/chadtricks.sh"
    [ "$PWD/chadtricks.sh" != "$(realpath "$0")" ] && mv "$PWD/chadtricks.sh" "$(realpath "$0")"
    echo "done"
}

vcrun2010()
{
    update
    echo "downloading vcrun2010"
    [ ! -f "vcrun2010.tar.zst" ] && download https://github.com/john-cena-141/chadtricks/raw/main/vcrun2010.tar.zst
    check vcrun2010.tar.zst f4ca1c716fd4f33426d0074c2c21561893a61d253a45a41dff53f6c638acd151
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm vcrun2010.tar.zst && return
    extract vcrun2010.tar.zst
    cp -r "$PWD"/vcrun2010/files/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/vcrun2010/vcrun2010.reg
    echo "vcrun2010" >> "$WINEPREFIX/chadtricks.log"
    rm -rf "$PWD"/vcrun2010
    echo "vcrun2010 installed"
}

vcrun2012()
{
    update
    echo "downloading vcrun2012"
    [ ! -f "vcrun2012.tar.zst" ] && download https://github.com/john-cena-141/chadtricks/raw/main/vcrun2012.tar.zst
    check vcrun2012.tar.zst ba5a5110f96f12ac49eecd4896a11baaabfdf6efad2d029a069d9680a30a2b0b
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm vcrun2012.tar.zst && return
    extract vcrun2012.tar.zst
    cp -r "$PWD"/vcrun2012/files/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/vcrun2012/vcrun2012.reg
    echo "vcrun2012" >> "$WINEPREFIX/chadtricks.log"
    rm -rf "$PWD"/vcrun2012
    echo "vcrun2012 installed"
}

vcrun2013()
{
    update
    echo "downloading vcrun2013"
    [ ! -f "vcrun2013.tar.zst" ] && download https://github.com/john-cena-141/chadtricks/raw/main/vcrun2013.tar.zst
    check vcrun2013.tar.zst 3669fd43ae62a31c4a608b011af7ba97b2f25e25915f7e66d441b46e9d55a39c
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm vcrun2013.tar.zst && return
    extract vcrun2013.tar.zst
    cp -r "$PWD"/vcrun2013/files/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/vcrun2013/vcrun2013.reg
    echo "vcrun2013" >> "$WINEPREFIX/chadtricks.log"
    rm -rf "$PWD"/vcrun2013
    echo "vcrun2013 installed"
}

vcrun2015()
{
    update
    echo "downloading vcrun2015"
    [ ! -f "vcrun2015.tar.zst" ] && download "https://github.com/john-cena-141/chadtricks/raw/main/vcrun2015.tar.zst"
    check vcrun2015.tar.zst 2b0bc92d4bd2a48f7e4d0a958d663baa5f3165eab95521e71f812b9030b03eb6
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm vcrun2015.tar.zst && return
    extract "vcrun2015.tar.zst"
    cp -r "$PWD"/vcrun2015/files/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/vcrun2015/vcrun2015.reg
    echo "vcrun2015" >> "$WINEPREFIX/chadtricks.log"
    rm -rf "$PWD"/vcrun2015
    echo "vcrun2015 installed"
}

vcrun2017()
{
    update
    echo "downloading vcrun2017"
    [ ! -f "vcrun2017.tar.zst" ] && download https://github.com/john-cena-141/chadtricks/raw/main/vcrun2017.tar.zst
    check vcrun2017.tar.zst 2bcf9852b02f6e707905f0be0a96542225814a3fc19b3b9dcf066f4dd2789773
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm vcrun2017.tar.zst && return
    extract vcrun2017.tar.zst
    cp -r "$PWD"/vcrun2017/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/vcrun2017/vcrun2017.reg
    echo "vcrun2017" >> "$WINEPREFIX/chadtricks.log"
    rm -rf "$PWD"/vcrun2017
    echo "vcrun2017 installed"
}

vcrun2019()
{
    update
    echo "downloading vcrun2019"
    [ ! -f "vcrun2019.tar.zst" ] && download https://github.com/john-cena-141/chadtricks/raw/main/vcrun2019.tar.zst
    check vcrun2019.tar.zst 4368f81681d98a77e3dfba4b381213f0a717d03c29f874a693581bd1cc8734f3
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm vcrun2019.tar.zst && return
    extract vcrun2019.tar.zst
    cp -r "$PWD"/vcrun2019/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/vcrun2019/vcrun2019.reg
    echo "vcrun2019" >> "$WINEPREFIX/chadtricks.log"
    rm -rf "$PWD"/vcrun2019
    echo "vcrun2019 installed"
}

mf()
{
    update
    echo "downloading mf"
    [ ! -f "mf.tar.zst" ] && download "https://github.com/john-cena-141/chadtricks/raw/main/mf.tar.zst"
    check mf.tar.zst e61b9a8e062d585adb2dd840df3e65b099dd19085bcf0058d5d50318ddf9ce80
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm mf.tar.zst && return
    extract "mf.tar.zst"
    cp -r "$PWD"/mf/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/mf/mf.reg
    register_dll colorcnv.dll msmpeg2adec.dll msmpeg2vdec.dll
    echo "mf" >> "$WINEPREFIX/chadtricks.log"
    rm -rf "$PWD"/mf
    echo "mf installed"
}

template()
{
    #update
    #echo "downloading template"
    #[ ! -f "template.tar.zst"] && download https://github.com/john-cena-141/chadtricks/raw/main/template.tar.zst
    #check template.tar.zst 2bcf9852b02f6e707905f0be0a96542225814a3fc19b3b9dcf066f4dd2781337
    #[ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm template.tar.zst && return
    #extract template.tar.zst
    #cp -r "$PWD"/template/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    #import_dlls "$PWD"/template/template.reg
    #echo "template" >> "$WINEPREFIX/chadtricks.log"
    #rm -rf "$PWD"/template
    echo "template installed"
}


# Running chadtricks
[ $# = 0 ] && echo "add chadtricks" && exit 1
for i in "$@"
do
   "$i"
done
