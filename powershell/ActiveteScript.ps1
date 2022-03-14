$active_scripts_path = "C:\Users\ACTIVEUSER\AppData\Local\Programs\UserScript"

$currentUser = (Get-ChildItem Env:\USERNAME).Value

$active_scripts_path = $active_scripts_path.Replace("ACTIVEUSER",$currentUser)

$path = Read-Host -Prompt "Path of script to activate"

try{
    Copy-Item $path -Destination $active_scripts_path
}
catch{
    Write-Host -ForegroundColor Magenta "Error please read:"
    Write-Host -ForegroundColor Red $_
}
