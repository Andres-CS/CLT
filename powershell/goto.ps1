$locationFolder = $env:HOMEPATH
$folderName = ".gotoCommand"
$fileName = "gotoConfig.json"
$configFlag = 0 

function Create-gotoInfo {
    param(
        $location,
        $type,
        $fileName
        )
    
    if ($type -match "d"){
        Write-Host "D option"
        New-Item -ItemType "Directory" -Path $location -Name $fileName
    }
    
    if ($type -match "f"){
        Write-Host "F option"
        New-Item -ItemType "file" -Path $location -Name $fileName
    }
}

#Check goto folder exisits
if ( Test-Path -Path ($locationFolder+"\"+$folderName)){
    #Check config file exisists
    if(Test-Path -Path ($locationFolder+"\"+$folderName+"\"+$fileName)){  }
    else{ 
        $configFlag = 1
    }
}
else{ 
    $configFlag = 2
}




switch($configFlag){
    1 { 
        Write-Host " ** FILE CREATED"
        Create-gotoInfo -type "f" -location ($locationFolder+"\"+$folderName) -fileName $fileName
    }
    
    2 {
        Write-Host " ** FOLDER AND FILE CREATED"
        Create-gotoInfo -type "d" -location $locationFolder -fileName $folderName
        Create-gotoInfo -type "f" -location ($locationFolder+"\"+$folderName) -fileName $fileName
    }
}

