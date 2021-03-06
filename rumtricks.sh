#!/bin/bash

#TODO
# new structure for archives

##########

# Forbid root rights
[ "$EUID" = "0" ] && echo -e "\e[91mDon't use sudo or root user to execute rumtricks!\e[0m" && exit

# Base download URL for the archive
BASE_URL="https://github.com/goldenboy313/rumtricks/raw/main"

# Use default prefix if nothing is exported
[ -z "$WINEPREFIX" ] && export WINEPREFIX="$HOME/.wine"

# Wine: don't complain about mono/gecho
export WINEDLLOVERRIDES="mscoree=d;mshtml=d"
export WINEDEBUG="-all"

# All operations are relative to rumtricks' location
cd "$(dirname "$(realpath "$0")")" || exit 1

# Download path (default)
echo "download path is $PWD"

# Support custom Wine versions
[ -z "$WINE" ] && WINE="$(command -v wine)"
[ ! -x "$WINE" ] && echo "${WINE} is not an executable, exiting" && exit 1

[ -z "$WINE64" ] && WINE64="${WINE}64"
[ ! -x "$WINE64" ] && echo "${WINE64} is not an executable, exiting" && exit 1

[ -z "$WINESERVER" ] && WINESERVER="${WINE}server"
[ ! -x "$WINESERVER" ] && echo "${WINESERVER} is not an executable, exiting" && exit 1

download()
{
    command -v aria2c >/dev/null 2>&1 && aria2c "$1" && return
    command -v wget >/dev/null 2>&1 && wget -N "$1" && return
    command -v curl >/dev/null 2>&1 && curl -LO "$1" && return
}

import_dlls()
{
    echo "importing dlls" && "$WINE" regedit "$1" && "$WINE64" regedit "$1" && "$WINESERVER" -w
}

extract()
{
    echo "extracting $1" && tar -xf "$1"
}

update()
{
    echo "updating prefix" && "$WINE" wineboot.exe -u && "$WINESERVER" -w
}

check()
{
    [ "$(sha256sum "$PWD/$1" | awk '{print $1}')" = "$2" ] && return 0 || return 1
}

register_dll()
{
    for i in "$@"
    do
    "$WINE" regsvr32 "$i" && "$WINE64" regsvr32 "$i"
    done
}

update-self()
{
    echo "updating rumtricks"
    download "$BASE_URL/rumtricks.sh"
    chmod +x "$PWD/rumtricks.sh"
    [ "$PWD/rumtricks.sh" != "$(realpath "$0")" ] && mv "$PWD/rumtricks.sh" "$(realpath "$0")"
    echo "done"
}

isolate()
{
	update
    echo "disabling desktop integrations"
    cd "$WINEPREFIX/drive_c/users/${USER}"
    for entry in *
    do
        if [ -L "$entry" ] && [ -d "$entry" ]
        then
            rm -f "$entry"
            mkdir -p "$entry"
        fi
    done
    cd "$OLDPWD"
    echo "isolate" >> "$WINEPREFIX/rumtricks.log"
    echo "done"
}

directx()
{
    update
    echo "downloading directx"
    [ ! -f "directx.tar.zst" ] && download "$BASE_URL/directx.tar.zst"
    check directx.tar.zst 22ef60f2e9700aecbb0303019d8310445796d3b52b2244870e9f47fba17953ab
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm directx.tar.zst && return
    extract directx.tar.zst
    cp -r "$PWD"/directx/files/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/directx/directx.reg
    echo "directx" >> "$WINEPREFIX/rumtricks.log"
    rm -rf "$PWD"/directx
    echo "directx installed"
}

vcrun2010()
{
    update
    echo "downloading vcrun2010"
    [ ! -f "vcrun2010.tar.zst" ] && download "$BASE_URL/vcrun2010.tar.zst"
    check vcrun2010.tar.zst bb58b714c95373f4ad2d3757d27658c6ce37de5fa4cbc85c16e5ca01178fb883
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm vcrun2010.tar.zst && return
    extract vcrun2010.tar.zst
    cp -r "$PWD"/vcrun2010/files/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/vcrun2010/vcrun2010.reg
    echo "vcrun2010" >> "$WINEPREFIX/rumtricks.log"
    rm -rf "$PWD"/vcrun2010
    echo "vcrun2010 installed"
}

vcrun2012()
{
    update
    echo "downloading vcrun2012"
    [ ! -f "vcrun2012.tar.zst" ] && download "$BASE_URL/vcrun2012.tar.zst"
    check vcrun2012.tar.zst 6ff3e8896d645c76ec8ef9a7fee613aea0a6b06fad04a35ca8a1fb7a4a314ce6
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm vcrun2012.tar.zst && return
    extract vcrun2012.tar.zst
    cp -r "$PWD"/vcrun2012/files/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/vcrun2012/vcrun2012.reg
    echo "vcrun2012" >> "$WINEPREFIX/rumtricks.log"
    rm -rf "$PWD"/vcrun2012
    echo "vcrun2012 installed"
}

vcrun2013()
{
    update
    echo "downloading vcrun2013"
    [ ! -f "vcrun2013.tar.zst" ] && download "$BASE_URL/vcrun2013.tar.zst"
    check vcrun2013.tar.zst b9c990f6440e31b8b53ad80e1f1b524a4accadea2bdcfa7f2bddb36c40632610
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm vcrun2013.tar.zst && return
    extract vcrun2013.tar.zst
    cp -r "$PWD"/vcrun2013/files/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/vcrun2013/vcrun2013.reg
    echo "vcrun2013" >> "$WINEPREFIX/rumtricks.log"
    rm -rf "$PWD"/vcrun2013
    echo "vcrun2013 installed"
}

vcrun2015()
{
    update
    echo "downloading vcrun2015"
    [ ! -f "vcrun2015.tar.zst" ] && download "$BASE_URL/vcrun2015.tar.zst"
    check vcrun2015.tar.zst 2b0bc92d4bd2a48f7e4d0a958d663baa5f3165eab95521e71f812b9030b03eb6
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm vcrun2015.tar.zst && return
    extract "vcrun2015.tar.zst"
    cp -r "$PWD"/vcrun2015/files/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/vcrun2015/vcrun2015.reg
    echo "vcrun2015" >> "$WINEPREFIX/rumtricks.log"
    rm -rf "$PWD"/vcrun2015
    echo "vcrun2015 installed"
}

vcrun2017()
{
    update
    echo "downloading vcrun2017"
    [ ! -f "vcrun2017.tar.zst" ] && download "$BASE_URL/vcrun2017.tar.zst"
    check vcrun2017.tar.zst 2bcf9852b02f6e707905f0be0a96542225814a3fc19b3b9dcf066f4dd2789773
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm vcrun2017.tar.zst && return
    extract vcrun2017.tar.zst
    cp -r "$PWD"/vcrun2017/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/vcrun2017/vcrun2017.reg
    echo "vcrun2017" >> "$WINEPREFIX/rumtricks.log"
    rm -rf "$PWD"/vcrun2017
    echo "vcrun2017 installed"
}

vcrun2019()
{
    update
    echo "downloading vcrun2019"
    [ ! -f "vcrun2019.tar.zst" ] && download "$BASE_URL/vcrun2019.tar.zst"
    check vcrun2019.tar.zst f84542198789d35db77ba4bc73990a2122d97546db5aca635b3058fc1830961d
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm vcrun2019.tar.zst && return
    extract vcrun2019.tar.zst
    cp -r "$PWD"/vcrun2019/files/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/vcrun2019/vcrun2019.reg
    echo "vcrun2019" >> "$WINEPREFIX/rumtricks.log"
    rm -rf "$PWD"/vcrun2019
    echo "vcrun2019 installed"
}

mf()
{
    update
    echo "downloading mf"
    [ ! -f "mf.tar.zst" ] && download "$BASE_URL/mf.tar.zst"
    check mf.tar.zst e61b9a8e062d585adb2dd840df3e65b099dd19085bcf0058d5d50318ddf9ce80
    [ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm mf.tar.zst && return
    extract "mf.tar.zst"
    cp -r "$PWD"/mf/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    import_dlls "$PWD"/mf/mf.reg
    register_dll colorcnv.dll msmpeg2adec.dll msmpeg2vdec.dll
    echo "mf" >> "$WINEPREFIX/rumtricks.log"
    rm -rf "$PWD"/mf
    echo "mf installed"
}

template()
{
    #update
    #echo "downloading template"
    #[ ! -f "template.tar.zst"] && download "$BASE_URL/template.tar.zst"
    #check template.tar.zst 2bcf9852b02f6e707905f0be0a96542225814a3fc19b3b9dcf066f4dd2781337
    #[ $? -eq 1 ] && echo "archive is corrupted (invalid hash), skipping" && rm template.tar.zst && return
    #extract template.tar.zst
    #cp -r "$PWD"/template/drive_c/windows/* "$WINEPREFIX/drive_c/windows/"
    #import_dlls "$PWD"/template/template.reg
    #echo "template" >> "$WINEPREFIX/rumtricks.log"
    #rm -rf "$PWD"/template
    echo "template installed"
}


# Running rumtricks
[ $# = 0 ] && echo "add rumtricks" && exit 1
for i in "$@"
do
   "$i"
done
