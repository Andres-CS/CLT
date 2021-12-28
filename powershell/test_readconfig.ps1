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
Write-Host 'Welcome to RunSSH V2'
Write-Host 'Servers availables:'
Write-Host


#Display Servers
foreach($i in $connections.Keys){
    Write-Host $i " - " $connections[$i]["Host"]
}


#User Input
Write-Host " "
$ui = Read-Host "Connect to"
Write-Host " "
Write-Host $ui


#Runner Container
foreach ($ssh in $connections.Keys){
    if ($ui -eq $ssh){
        Write-Host "You are connecting to: " $connections[$ssh]["Host"]
        $ipath = $connections[$ssh]["IdentityFile"]
        RESULTS=$(docker run --rm -it --mount type=bind,source=$ipath,destination=/home/ssh/ sshtool ssh -i /home/ssh -p $connections[$ssh]["Port"] $connections[$ssh]["Hostname"])
        
    }
}