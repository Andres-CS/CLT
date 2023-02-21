#!/bin/bash

ERROR_COLOR='\033[0;31m'
SUCCESS_COLOR='\033[0;32m'
NO_COLOR='\033[0m'

#Message Functions
function err_msg(){
    echo -e "${ERROR_COLOR}$1${NO_COLOR}"
} 

function succ_msg(){
    echo -e "${SUCCESS_COLOR}$1${NO_COLOR}"
} 


#Get Current user
active_user=$(echo $USER)

#Predefine .SSH folder path
target_path="/home/${active_user}/.ssh/confdig"

#Test predefine SSH folder path
if ! [ -f $target_path ]
then
    while [ ! -f $target_path ]
    do
        err_msg "** Error - Path: ${target_path} - NOT VALID."
        echo " ** Enter a new Path **"
        echo -n "Path:"
        read target_path
    done
    succ_msg "** Success - File: ${target_path} - Found"
fi