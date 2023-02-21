#!/bin/bash

YELLOW='\033[1;33m'

ERROR_COLOR='\033[0;31m'
SUCCESS_COLOR='\033[0;32m'
NO_COLOR='\033[0m'


# --- Functions ---

wlcm_msg(){
    echo -e "${YELLOW}"
    figlet "RunnSSH"
    echo -e "${NO_COLOR}"
    echo -e "Welcome to ${YELLOW}RunSSH${NO_COLOR} please select the host you want to access\n"
}

err_msg(){
    echo -e "${ERROR_COLOR}$1${NO_COLOR}"
} 

succ_msg(){
    echo -e "${SUCCESS_COLOR}$1${NO_COLOR}"
} 

create_host_array(){
    local -a tmp_array=()
    while read -r line
    do
        tmp_array+=($(grep -w ^Host $line | cut -d " " -f2))
    done < $1
    echo ${tmp_array[@]}
}

# --- START SCRIPT ---

# --- CHECK CONFIG --- 

#Get Current user
active_user=$(echo $USER)

#Predefine .SSH folder path
target_path="/home/${active_user}/.ssh/config"

# --- ACQUIRE HOSTS --- 

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

# --- STORE HOSTS IN ARRAY
declare -a hostArray=()
for n in $(create_host_array $target_path)
do
    hostArray+=($n)
done

# --- USER UI --- 

wlcm_msg

err_msg ${#hostArray[@]}

count=0

for i in ${hostArray[@]}
do 
    succ_msg "$count - $i"
    count=$(($count + 1))
done

read -p "Select a host:" answ
err_msg ${hostArray[$answ]}

# --- CONNECT SSH ---

ssh $answ