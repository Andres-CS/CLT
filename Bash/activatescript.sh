#!/bin/bash

#Checked default location is there otherwise create it.
location="/home/$USER/.local/bin/"

if [ ! -d $location ]
then
    mkdir -p $location
fi


read -p "Script: " script_path

#Checked file exits

if [ -f $script_path ]
then
    cp $script_path $location
else
    echo "File not found or path is wrong"
fi

#List files in location

ls -l $location




