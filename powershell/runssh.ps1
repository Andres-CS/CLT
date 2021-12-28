$connections = @{
    1 =@{
        name ='Vultr'
        port = 2016
        remotehost = "anthophila@japc.me"
        keypath = "C:\Users\Jarvis\Development\SSH\VULTR_id_rsa_BeeHive"
    }
    2 = @{
        name ='GS69'
        port = 22
        remotehost = "jarvis@192.168.1.34"
        keypath = "C:\Users\Jarvis\Development\SSH\gs69-rsa-10192021"
    }
}

#Display Menu
foreach($k in $connections.Keys){
    Write-Host $k " - " $connections[$k]["name"]
}

#User Input
Write-Output " "
$ui = Read-Host "Connect to"
Write-Output " "

#Runner Container
foreach ($ssh in $connections.Keys){
    if ($ui -eq $ssh){
        Write-Host "You are connecting to: " $connections[$ssh]["name"]
        $ipath = $connections[$ssh]["keypath"]
        RESULTS=$(docker run --rm -it --mount type=bind,source=$ipath,destination=/home/ssh/ sshtool ssh -i /home/ssh -p $connections[$ssh]["port"] $connections[$ssh]["remotehost"])
    }
}