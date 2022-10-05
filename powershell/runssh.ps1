#Parameters
param ($docker='N')
#Adjust Parameters
$docker = $docker.ToUpper()


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

#--Extraction--
#Read Data from config file

$rawData = Get-Content $target_path

#--Transformation--
#Create Hash Tables to store in-memory data from read file. 

$connections = @{}
$tmphastable = @{}
$counter = 0
$dictEntries = 1

#--Load--
#Read each line
#Remove empty spaces at start & split lines at space
#If empty line populate connections and clear tmphashtable
#loop through file lines
foreach ($line in $rawData){
    $line = ($line.trimstart(" ")).split(" ")
    $counter += 1
    #If empty line or end of read lines
    if ((-not $line) -or ($counter -eq $rawData.Count)){
        $connections.Add($dictEntries, @{})
        foreach($k in $tmphastable.Keys){
            $connections[$dictEntries].Add($k, $tmphastable[$k])
        }
        $dictEntries += 1 
        $tmphastable.Clear()
    }
    else{
        $tmphastable.Add($line[0], $line[1])
    }
}

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
            If ($docker -eq 'Y'){
                docker run --rm -it --mount type=bind,source=$ipath,destination=/home/ssh/ sshtool ssh -i /home/ssh -p $connections[$ui]["Port"] $connections[$ui]["Hostname"] -l $connections[$ui]["User"]
            }
            else{
                ssh $connections[$ui]["Host"] #Write-Host $connections[$ui]["Host"]
            }
            
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


