# -------------------- 
#   G VARIABLES 
# -------------------- 

$locationFolder = $env:HOMEPATH
$folderName = ".gotoCommand"
$fileName = "gotoConfig.json"
$configFlag = 0 

# -------------------- 
#   FUNCTIONS Def
# -------------------- .

function greetingMsg {
    param(
        $msg
    )

    Write-Ascii -InputObject $msg
    Write-Host "This are the following paths: "
    Write-Host
}

function Create-gotoInfo {
    param(
        $location,
        $type,
        $fileName
        )
    
    switch($type){
        "d" { 
            New-Item -ItemType "Directory" -Path $location -Name $fileName
            break
         }
         "f" {
            New-Item -ItemType "file" -Path $location -Name $fileName
            break
         }
    }
}

# -------------------- 
#   START SCRIPT 
# -------------------- 

#Check "goto" folder exisits
if ( Test-Path -Path ($locationFolder+"\"+$folderName)){
    #Check "config" file exisists
    if(Test-Path -Path ($locationFolder+"\"+$folderName+"\"+$fileName)){  }
    else{  $configFlag = 1  }
}
else{  $configFlag = 2  }

switch($configFlag){
    1 { 
        Write-Host " ** FILE CREATED ** "
        Create-gotoInfo -type "f" -location ($locationFolder+"\"+$folderName) -fileName $fileName
    }
    
    2 {
        Write-Host " ** FOLDER AND FILE CREATED ** "
        Create-gotoInfo -type "d" -location $locationFolder -fileName $folderName
        Create-gotoInfo -type "f" -location ($locationFolder+"\"+$folderName) -fileName $fileName
    }
}

#Read gotoConfig file
$gotoData = Get-Content ($locationFolder+"\"+$folderName+"\"+$fileName) | ConvertFrom-Json -AsHashtable 


#Greeting message
greetingMsg -msg 'Go-To'

If ($gotoData.count -lt 1) {
    Write-Host "`tNo Active paths to follow"
    Write-Host "`tPlease go to " $locationFolder"\"$folderName"\"$fileName" and fill it up.`r"
    Write-Host
}
else {
    foreach ($k in $gotoData.keys){
        Write-Host "`t"$k"`r"
    }
}
