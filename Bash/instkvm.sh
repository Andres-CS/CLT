#!/bin/bash

echo "Installin KVM - Qemu - Libvirt"
echo
echo "Checking Pre-requisits"

#Color ECHO variables
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

#Count num of CPUs with kvm or svm flag
function kvmcpusupport () { 
    egrep -c '(vmx|svm)' /proc/cpuinfo 
}
#Count num of CPUs that are 64 bit
function cpu64bit () { 
    egrep -c ' lm ' /proc/cpuinfo 
}

#Check KVM is suppported
function kvmok () {
   echo "TEST START"
   if [ `kvm-ok | egrep "command not found"` ] 
   then
	echo -e "Installing cpu-checker ${RED}TEMPORARLY${NC}."
   	sudo apt-get install -y cpu-checker
	#CALL KVMOK() RECURSIBLY
	$kvmok
   elif [ egrep -c "KVM acceleration can be used" kvm-ok ]
   then
	echo -e "${GREEN}GOOD${NC}"
   fi
   echo "TEST ENDS"

}



#Check for KVM Support
kvmspt=$( kvmcpusupport )
#check return value 
if [ $kvmspt -gt 0 ]
then
    echo -e "KVM CPU support: ${GREEN}YES${NC}\tThis system has $kvmspt CPUs that support vitualization"
else
    echo -e "KVM CPU support: ${RED}NO${NC}\tThis system has $kvmspt CPUs that support vitualization"
    #Exit script
    exit 1
fi

#Check if Procesor is 64-bit
lmspt=$( cpu64bit ) 
if [ $lmspt -gt 0 ]
then 
    echo -e "64-bit Processor: ${GREEN}YES${NC}\tThis system has a 64-bit Processor"
else
    echo -e "64-bit Processor: ${RED}NO${NC}\tThis system does not have 64-bit Processor"
    #Exit script
    exit 1
fi

#Check if KVM is supported on the system
echo "T S"
$kvmok
echo `kvm-ok | egrep "command not found"`
echo "T E"

#sudo apt-get install -y qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager
