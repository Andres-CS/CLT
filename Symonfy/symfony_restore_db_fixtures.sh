#!/bin/bash

folderPath="/tmp/"
folderName="1_SymfonyMigrations"
targetFolder=$folderPath$folderName

function createFolder()
{
    mkdir -p $1
}

function moveMigrations()
{
    error_msg=$(mv .."/migrations/"*.php $1 2>&1)
    code=$?
    if [ $code -eq 0 ]
    then
        echo 0
    fi
    #No success
    echo 1
}


echo "-----------------------------------------------------------------------------------------------"
echo " ⚠️ You MUST run this script from a folder under the project's ROOT dir!"
echo " ⚠️ This command will:"
echo " ⚠️ * Move your Migration PHP files to $targetFolder" 
echo " ⚠️ * Drop the database" 
echo " ⚠️ * Recreate the database"
echo "-----------------------------------------------------------------------------------------------"
read -r -p "Are you sure you want to do this? [y/n] " response
echo ""

if [ $response == "y" ]
then

    echo "📦 Start to move files 📦"

    if ! [ -d $targetFolder ]
    then
            echo " - Folder $targetFolder, does not exists."
            echo " - Creating folder $targetFolder"
            createFolder $targetFolder
    fi

    if [ $(mv .."/migrations/"*.php $targetFolder) ]
    then
        echo " 💀 Error 💀 - Error when moving migrations; Possible issue: folder creation💀"
    fi
    
    echo -e "📦 Files moved into $targetFolder 📦\n"
    echo "💣 DATABASE Operations 💣"
    echo " - symfony console doctrine:database:drop --force"
    symfony console doctrine:database:drop --force
    echo " - symfony console doctrine:database:create"
    symfony console doctrine:database:create
    echo " - symfony console d:m:diff --formatted"
    symfony console d:m:diff --formatted
    echo " - symfony console doctrine:migrations:migrate --no-interaction"
    symfony console doctrine:migrations:migrate --no-interaction
    echo " - symfony console doctrine:fixtures:load"
    symfony console doctrine:fixtures:load
fi

echo -e "✅ Done ✅\n"
