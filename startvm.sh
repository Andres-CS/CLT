#!/bin/bash

#Constants
cGREEN='\033[1;32m'
cBLUE='\033[0;34m'
cRED='\033[0;31m'
cYELLOW='\033[1;33m'
cNONE='\033[0m'


#Functions
function startNet (){
	sudo virsh net-start $1
}

function startVM (){
	sudo virsh start $1
}

function vmInfo (){
	while :
	do
		ipaddr=$(sudo virsh domifaddr $1 | grep  -E -o "([0-9]{1,3}\.){3}[0-9]{1,3}\/?[0-9]{1,3}")
		#Testi if there is an IP assigned yet
		if [ -z "$ipaddr" ]
		then
			continue
		else
			break
		fi
	done

	echo -e "IPv4 addres of $1: ${cGREEN}$ipaddr${cNONE}"
}



#START SCRIPT

echo -e "${cYELLOW}--------------------${cGREEN}START${cYELLOW}-------------------------${cNONE}"
echo -e "\t\t${cRED}KVM - Libvrt${cNONE}"

#Check Networks
echo "Checking Network"
if [[ $(sudo virsh net-list --all | grep -o inactive) == inactive ]]
then
	echo -e "Activating Network: ${cGREEN}default${cNONE}"
	startNet "default"
elif [[ $(sudo virsh net-list --all | grep -o active) == active ]]
then
	echo -e "${cBLUE}Network default is active${cNONE}"
fi


#Check Virtual Machines
echo "Virtual Machines"
sudo virsh list --all
printf "Select a VM: "
read VM
startVM $VM

#Give Info on the started VM
vmInfo $VM
echo


echo -e "${cYELLOW}----------------------${cGREEN}DONE${cYELLOW}-------------------------${cNONE}"
#END SCRIPT
