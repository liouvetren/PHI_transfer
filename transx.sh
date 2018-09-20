#!/bin/bash
module load hpss

if   [[ $1 == "/hpss/"* && $2 == "/hpss/"* ]]; then

    echo "Moving data from SDA folder $1 to SDA folder $2"
    hsi "mkdir $2; ccp -R $1/* $2"

elif [[ $1 != "/hpss/"* && $2 != "/hpss/"* ]]; then

    echo "Transfer between DC2"
    if [ ! -d "$1" ]; then
        echo "DC2 folder $1 does not exist"
    else
        mkdir -p $2
        cp -ru $1/* $2
    fi
    
elif [[ $1 != "/hpss/"* && $2 == "/hpss/"* ]]; then

    echo "Moving data from DC2 folder $1 to SDA folder $2"
    if [ ! -d "$1" ]; then
        echo "DC2 folder $1 does not exist"
    else

        TMP=/N/dc2/scratch/$USER/tranx_tmp
        mkdir -p $TMP
        for file in $(find $1 -type f); do
            filebase=${file##*/}
            PRE=${filebase:0:3}
            FIX=${filebase:3:3}
            file_tmp=$TMP/$filebase.gpg
            file_des=$2/$PRE/$FIX/$filebase.gpg
            hsi -P ls $file_des
            isexistcode=$?
            if [ $isexistcode != 0 ]; then
                gpg --cipher-algo AES256 --passphrase $PHI_PASSWORD --batch  -o $file_tmp --symmetric $file
                hsi "cput -P $file_tmp : $file_des"
                rm $file_tmp
            fi
        done
        
    fi
    
else

    echo "Moving data from SDA folder $1 to DC2 folder $2"
    mkdir -p $2
    cd $2
    hsi "cget -R $1/*"
    echo "Waiting for decryption"
    for file_encrypt in $(find . -type f -name "*.gpg"); do
        file=${file_encrypt%.gpg}
        if [ ! -f $file ]; then # not decrypted yet
            gpg --cipher-algo AES256 --passphrase $PHI_PASSWORD --batch -o $file --decrypt $file_encrypt
        fi
    done
fi

