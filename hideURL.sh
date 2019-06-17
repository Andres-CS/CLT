#!/bin/bash

while getopts ":p:e:" arg
do
    case $arg in
        p)
            uPath="$OPTARG"
            #Test if USER path provided is correct
            if [ ! -d $uPath ]
            then 
                echo "THE PATH PROVIDED IS NOT A VALID DIRECTORY."
                exit 1
            fi
            ;;
        e)
            uExt=${OPTARG}
            if [ $uExt == "" ]
            then
                uExt=$(read -p "Extension file: ")
                echo $uExt
            fi
            ;;
        :)
            echo "PLEASE PROVIE A path AND A FILE extension."
            ;;
    esac
done

#Files In Directory
FID=`ls $uPath`

declare -a allFiles=($FID)
declare -a dirFiles=()
declare -a regFiles=()
declare -a urlLine=()

for f in ${allFiles[@]}
do 
    #Adding dir names to the dirFiles array
    if [ -d $f ]
    then
        dirFiles[${#dirFiles[@]}]=$f
    #Adding files name to the regFiles array
    else
        #Check files match Extension
        if [ ${f: -${#uExt}} == "$uExt" ]
        then
            #Concatenate user uPath provided with files f in the path to get full path of file.
            regFiles[${#regFiles[@]}]=$uPath$f
        fi
    fi
done 

#Find line num that contains the RegEx pattern looked for and store it. 
for j in ${regFiles[@]}
do
    linum=`grep -n https[:/.~/\a-zA-Z0-9]* $j | cut -d: -f 1`
    if [ ! linum == "" ]
    then
        urlLine[${#urlLine[@]}]=$linum
    #else
        #urlLine[${#urlLine[@]}]=0
    fi
done

for ((i=0; i<${#regFiles[@]};i++))
do
    if [ "${urlLine[$i]}" == "" ]
    then
        printf "%s | %s | %s" "${regFiles[$i]}" "__" "None"
    else
        printf "%s | %d | %s" "${regFiles[$i]}" ${urlLine[$i]} "$(sed -n "${urlLine[$i]} p" ${regFiles[$i]})"
    fi
    echo
done