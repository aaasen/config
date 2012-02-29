#!/bin/bash

#makes a backup of local config files for safety

#copy files from fileroster into directory
#tar and gzip that directory; name with date and time

declare -a FILES
arcconfigdir=$HOME/.arcconfig

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
#expandfiles(file)
# TODO: /home/aasen/ should be replaced with $HOME
expandfiles () {
    sed -i $(echo s/~/$(echo $HOME | sed 's/\//\\\//g')/g) $1
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

    mkdir ~/.arcconfig > /dev/null 2>&1
    export VERSION_CONTROL=numbered
    cp --backup tmpgzip/a.tar.gz $arcconfigdir/${1%/}`generateuuid`.tar.gz

    rm -R tmpgzip
}

#archives local config files from fileroster
#arcconfig()
arcconfig () {
    expandfiles $1
    loadfileroster $1
    cpfilestodir config
    touch {pre,post}gz
    ls $arcconfigdir > pregz
    gzdir config
    ls $arcconfigdir > postgz
    echo "local config archived in \""$arcconfigdir/`diff pregz postgz | grep -o ">.*" | grep -o "[^> ]*"`"\""
    
    rm {pre,post}gz
    rm -R config
}

#clears out the config archive directory
#cleanconfigarc()
cleanconfigarc () {
    rm $arcconfigdir/*
}

#archives local config files and then replaces them with those from local clone of the local repo clone
#updateconfig(files)
# TODO: make pullconfig work for a list of files
updateconfig () {
    arcconfig fileroster
    for (( i=0; i<${#FILES[@]}; i++ )); do
	cp ../home/`echo ${FILES[${i}]} | grep -Eo '[^/]+$'` ${FILES[${i}]}
    done
}

#copies local files into local clone of git repo then adds the changes to git
#commitconfig(files)
commitconfig () {
    expandfiles fileroster
    loadfileroster fileroster
    for (( i=0; i<${#FILES[@]}; i++ )); do
        cp ${FILES[${i}]} ../home/`echo ${FILES[${i}]} | grep -Eo '[^/]+$'`
	git add ../home/`echo ${FILES[${i}]} | grep -Eo '[^/]+$'`
    done
}

#echo ${FILES[@]}

arcconfig fileroster

#pullconfig

#expandfiles fileroster

#commitconfig

#updateconfig