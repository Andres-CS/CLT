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
    tmp_array=$(grep -w "^Host" $1 | cut -d " " -f2)
    echo ${tmp_array[@]}
}

create_hostname_array(){
    local -a tmp_array=()
    tmp_array=$(grep -w Hostname $1 | cut -d " " -f3)
    echo ${tmp_array[@]}
}

install_figma(){
    os_release="/etc/os-release"
    insystem=$(which figlet)
    echo $insystem | grep -o "no figlet"
    #sudo dnf install figlet

}

# --- START SCRIPT ---

# --- CHECK CONFIG --- 

#Get Current user
active_user=$(echo $USER)

#Predefine .SSH folder path
target_path="/home/${active_user}/.ssh/config"

#install_figma

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
declare -a hostnameArray=()

for n in $(create_host_array $target_path)
do
    hostArray+=($n)
done

for m in $(create_hostname_array $target_path)
do 
    hostnameArray+=($m)
done



# --- USER UI --- 

wlcm_msg

if [ ${#hostArray[@]} == ${#hostnameArray[@]} ]
then
    c=0
    for ((c=0; c<${#hostArray[@]}; c++))
    do 
        succ_msg "$c - ${hostArray[$c]} -> ${hostnameArray[$c]}"
    done
else
    count=0
    for i in ${hostArray[@]}
    do 
        succ_msg "$count - $i"
        count=$(($count + 1))
    done
    count=0
    for j in ${hostnameArray[@]}
    do 
        succ_msg "$count - $j"
        count=$(($count + 1))
    done

fi

read -p "Host Number:" answ
succ_msg ${hostArray[$answ]}

# --- CONNECT SSH ---

gnome-terminal -- bash -c "ssh ${hostArray[$answ]}; exec bash -i "