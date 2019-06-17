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

S_TEXT="SERVER ADDRESS"
PADDING=0

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

            #Get length Largest path stored.
            if [ "${#regFiles[-1]}" -gt "$PADDING" ]
            then
                PADDING=${#regFiles[-1]}
            fi
        fi
    fi
done 

#Find line num that contains the RegEx pattern looked for and store it. 
for j in ${regFiles[@]}
do
    linum=`grep -n :.*php $j | cut -d: -f 1`
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
        printf '\e[1;35m %s \e[m| \e[1;34m %s \e[m| \e[0;32m %s \e[m' "${regFiles[$i]}" "__" "None"
    else
        printf '\e[1;35m %s \e[m| \e[1;34m %d \e[m| \e[0;32m %s \e[m | \e[0;31m %s \e[m' "${regFiles[$i]}" ${urlLine[$i]} "$(sed -n "${urlLine[$i]} p" ${regFiles[$i]})" "$S_TEXT"
    fi
    echo
done