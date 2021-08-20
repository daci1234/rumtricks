#!/bin/bash

download()
{
    wget $1
}

override_dlls()
{
    wine regedit $1
}

extract()
{
    tar -xvf $1
}



load_vcrun2015()
{
    download https://github.com/john-cena-141/chadtricks/raw/main/vcrun2015.tar.zst

    extract vcrun2015.tar.zst

    override_dlls $PWD/vcrun2015.reg

    cp -r $PWD/vcrun2015/drive_c/windows/* $WINEPREFIX/drive_c/windows/*

}


[ $1 = vcrun2015 ] && load_vcrun2015
