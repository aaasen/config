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

#copies all files listed in FILES into a directory
#cpfilestodir(dirname)
cpfilestodir () {
    mkdir $1
    for (( i=0; i<${#FILES[@]}; i++ )); do
	cp ${FILES[${i}]} dirname/
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

    export VERSION_CONTROL=existing
    cp --backup tmpgzip/a.tar.gz ${1%/}`generateuuid`.tar.gz

    echo ${1%/}`generateuuid`.tar.gz
}

loadfileroster $1

echo num elements: ${#FILES[@]}
echo ${FILES[@]}
