#!/bin/bash

purple='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${purple}** Creating Skeleton APP for Symfony 5.4 with PHP 8.0 **${NC}"
echo -n -e "${purple}Project Name:${NC} "
read prjname

composer create-project symfony/skeleton:"^5.4" $prjname
cd $prjname && echo 8.0 >> .php-version
composer require --dev symfony/maker-bundle
composer require doctrine/annotations
symfony console make:controller ConferenceController

echo -e "${purple}** Skeleton Set up - Read to use **${NC}"
#symfony server:start
