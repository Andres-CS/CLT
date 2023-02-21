#!/bin/bash

ERROR_COLOR='\033[0;31m'
SUCCESS_COLOR='\033[0;32m'
NO_COLOR='\033[0m'

# --- Functions ---
function err_msg(){
    echo -e "${ERROR_COLOR}$1${NO_COLOR}"
} 

function succ_msg(){
    echo -e "${SUCCESS_COLOR}$1${NO_COLOR}"
} 

function create_host_array(){
    local declare -a tmp_array
    while read -r line
    do 
        tmp_array+=$(grep -w ^Host $line | cut -d " " -f2)
    done < $1
    echo ${tmp_array[@]}
}

# --- START SCRIPT ---

#Get Current user
active_user=$(echo $USER)

#Predefine .SSH folder path
target_path="/home/${active_user}/.ssh/config"

#Test predefine SSH folder path
#If bad, ask for a new path
if ! [ -f $target_path ]
then
    while [ ! -f $target_path ]
    do
        err_msg "** Error - Path: ${target_path} - NOT VALID."
        echo -n "** Enter a new Path: "
        read target_path
    done
    succ_msg "** Success - Path: ${target_path} - VALID"
fi


declare -a hostArray
hostArray+=$(create_host_array $target_path)

for i in ${hostArray[@]}
do 
    succ_msg $i
done
