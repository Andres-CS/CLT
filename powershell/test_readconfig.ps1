#Get Current user 
$active_User = (Get-ChildItem Env:\USERNAME).Value

#Predefined .SSH folder path
$target_path = "C:\Users\TARGETUSER\.ssh\config"

#Test predefine SSH folder path 1st
#If bad, Then request new path by user input
#Else continue with script
try {
    $target_path = $target_path.Replace("TARGETUSER",$active_User)

    while( -not $(Test-Path -Path $target_path -PathType leaf) ){
        Write-Host "Error: file target not in path."
        Write-Host "Error Path: $target_path"
        Write-Host " --- Provide New Path --- "
        Write-Host "Type 'q' to quit"
        $target_path =  Read-Host "New Path"
        if ($target_path -eq 'q'){
            #End script
            exit
        }
    }
}
catch {
    "Something occured with the use of -> Test-Path -Path $target_path -PathType leaf"
}

# --- ETL ---- 

#Extraction 

$rawData = Get-Content $target_path

#Transformation 
$connections = @{}
$tmphastable = @{}
$count = 1

#-------------- START FIXING/REFACTORING --------------

#Read each line
#Remove empty spaces at start & split lines at space
#If empty line populate connections and clear tmphashtable
#loop through file lines
foreach ($line in $rawData){
    $line = ($line.trimstart(" ")).split( " ")
    #If empty line
    if (-not $line){
        $connections.Add($count, @{})
        foreach($k in $tmphastable.Keys){
            $connections[$count].Add($k, $tmphastable[$k])
        }
        $count = $count + 1 
        $tmphastable.Clear()
    }
    else{
        $tmphastable.Add($line[0], $line[1])
    }
}

$connections.Add($count, @{})
foreach($k in $tmphastable.Keys){
    $connections[$count].Add($k, $tmphastable[$k])
}

#-------------- END FIXING/REFACTORING --------------

#Welcome Message
Write-Host -ForegroundColor Green 'Welcome to RunSSH V2'
Write-Host -ForegroundColor Green 'Servers availables:'
Write-Host


#Display Servers
foreach($i in $connections.Keys){
    Write-Host $i " - " $connections[$i]["Host"]
}


#User Input
Write-Host " "
$ui = Read-Host "Connect to"
$ui = $ui -as [int] #Casting $ui to INT32 
Write-Host " "

#Runner Container
try {
    foreach ($ssh in $connections.Keys){
        if ($ui -eq $ssh){
            Write-Host -ForegroundColor Green "You are connecting to: " $connections[$ui]["Host"]
            $ipath = $connections[$ui]["IdentityFile"]
            docker run --rm -it --mount type=bind,source=$ipath,destination=/home/ssh/ sshtool ssh -i /home/ssh -p $connections[$ui]["Port"] $connections[$ui]["Hostname"] -l $connections[$ui]["User"]
        }
    }
}
catch [System.Exception]{ 
    Write-Host -ForegroundColor Yellow $_ 
}
finally{  
    Write-Host -foregroundColor Cyan "Thank you $active_User, you have logged out of your SSH session from " -NoNewline
    Write-Host -foregroundColor Magenta $connections[$ui]["Host"] 
}


