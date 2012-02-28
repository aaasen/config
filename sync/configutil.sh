#!/bin/bash

#makes a backup of local config files for safety

#copy files from fileroster into directory
#tar and gzip that directory; name with date and time

declare -a FILES

#loads files from a fileroster file which contains file paths delimited by newlines
#loadfileroster(filename)
#currently loads files into global array FILES
loadfileroster () {
    exec 10<&0
    exec < $1
    let count=0

    while read LINE; do
	FILES[$count]=$LINE
	((count++))
    done

    exec 0<&10 10<&-
}

#goes through FILES and replaces ~ with $HOME etc.
#expandfiles()
# TODO: /home/aasen/ should be replaced with $HOME
expandfiles () {
    for (( i=0; i<${#FILES[@]}; i++ )); do
	FILES[$i]=`echo ${FILES[${i}]} | sed 's/~/\/home\/aasen/g'`
    done
}

#copies all files listed in FILES into a directory
#cpfilestodir(dirname)
cpfilestodir () {
    mkdir $1
    for (( i=0; i<${#FILES[@]}; i++ )); do
	cp ${FILES[${i}]} $1/
    done
}

#generates a uuid (currently just uses date)
#generateuuid()
generateuuid () {
    echo `date +%d-%m-%y`
}

#gzips directory
#name of output is input name + generateuuid() + .tar.gz
#gzdir(dir)
gzdir () {
    mkdir tmpgzip
    tar -czvf tmpgzip/a.tar.gz $1

    export VERSION_CONTROL=numbered
    cp --backup tmpgzip/a.tar.gz ${1%/}`generateuuid`.tar.gz

    rm -R tmpgzip
}

#archives local config files from fileroster
#arcconfig()
arcconfig () {
    loadfileroster $1
    expandfiles
    cpfilestodir config
    gzdir config
    rm -R config
}

#echo ${FILES[@]}

arcconfig fileroster