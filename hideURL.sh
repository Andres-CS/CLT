#!/bin/bash

while getopts ":p:e:m:" arg
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
        m) 
            S_TEXT=${OPTARG}
            if [ "$S_TEXT" == "" ]
            then
                S_TEXT="SERVER ADDRESS"
            fi
            #echo $S_TEXT
            ;;
        :)
            echo "PLEASE PROVIE A path AND A FILE extension."
            ;;
    esac
done

#RegEx URL Patter
HTTPulr="(https|HTTPS).*[a-zA-Z]"
sed_HTTPurl="\(https\|HTTPS\).*[a-zA-Z]"

#Files In Directory
FID=`ls $uPath`

declare -a allFiles=($FID) 
declare -a regFiles=()
declare -a urlLine=()

for file in ${allFiles[@]}
do 
    #Adding files names to the regFiles array
    if [ ! -d $file ]
    then
        #Check files match Extension
        if [ ${file: -${#uExt}} == "$uExt" ]
        then
            #Concatenate user uPath provided with files f in the path to get full path of file.
            regFiles[${#regFiles[@]}]=$uPath$file
        fi
    fi
done 

#Find line num that contains the RegEx pattern looked for and store it. 
for f in ${regFiles[@]}
do
    linum=`grep -n -E $HTTPulr $f | cut -d: -f 1`
    if [ ! linum == "" ]
    then
        urlLine[${#urlLine[@]}]=$linum
    fi
done

for ((i=0; i<${#regFiles[@]};i++))
do
    if [ "${urlLine[$i]}" == "" ]
    then
        printf '\e[33;1m%s | %s | %s \e[m' "${regFiles[$i]}" "__" "None"
    else
        sed=$(sed -n "${urlLine[$i]}s/$sed_HTTPurl/ $S_TEXT /g" ${regFiles[$i]})
        if [ ! "$sed" == "0" ]
        then
            sed=$(sed -n "${urlLine[$i]}p" ${regFiles[$i]})
            rsed=$(sed -i "${urlLine[$i]}s/$sed_HTTPurl/ $S_TEXT /" ${regFiles[$i]})
            sed=$(sed -n "${urlLine[$i]}p" ${regFiles[$i]})
            printf '\e[1;35m%s\e[m | \e[1;34m%d\e[m | \e[0;32m%s\e[m | \e[0;34m%s\e[m' "${regFiles[$i]}" ${urlLine[$i]} "$sed" "$sed"
        fi
    fi
    echo 
done