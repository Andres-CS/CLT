#!/bin/bash

#Checked default location is there otherwise create it.
default_location="/home/$USER/.local/bin/"

if [ ! -d $default_location ]
then
    mkdir -p $default_location
fi

figlet "Activate Script"
echo -e "\nPlease enter FULL path of script."
read -p "Path: " script_path

echo -e "\nPlease enter alias name for script, if desired."
read -p "Alias [enter if none]: " alias

#Checked file exits

if [ -f $script_path ]
then
    if [ $alias == "" ]
    then 
        ln -s $script_path $default_location
    else
        ln -s $script_path $default_location"/"$alias
    fi

else
    echo "File not found or path is wrong"
fi

#List files in location

ls -l $default_location




