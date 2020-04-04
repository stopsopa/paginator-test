#!/bin/bash

cat << EOF

        # example usage
        /bin/bash $0 bash
        /bin/bash $0 nw  # turn on no warning mode - run inside container
        /bin/bash $0 php script.php - run command 'php script.php' inside docker container

EOF

if [ "$1" = "nw" ]; then # no warnings mode

cat <<EOF > /usr/local/etc/php/php.ini
short_open_tag = Off
extension=zip.so

error_reporting = off

EOF

  exit 0
fi

if [ "$1" = "install-composer" ]; then

    php composer.phar 1>> /dev/null 2>> /dev/null

    if [ "$?" = "0" ]; then
        echo "composer.phar already downloaded"
    else
        echo "downloadding composer.phar"

        # https://getcomposer.org/download/
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
        php -r "if (hash_file('sha384', 'composer-setup.php') === 'e0012edf3e80b6978849f5eff0d4b4e4c79ff1609dd1e613307e16318854d24ae64f26d17af3ef0bf7cfb710ca74755a') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
        php composer-setup.php
        php -r "unlink('composer-setup.php');"
    fi

    exit 0
fi

# further research: https://github.com/maxpou/docker-symfony

## Examples:
##   /bin/bash php.sh php composer.phar require stopsopa/jms-serializer-lite
##   /bin/bash php.sh bash
##   /bin/bash php.sh php bin/console debug:router
##   /bin/bash php.sh php bin/symfony_requirements
##
##   http://localhost:1025/endpoint/config.php
##     or
##   echo "<?php echo '<pre>'; require(dirname(__FILE__).'/../bin/symfony_requirements');" > php/web/sfr.php
##       curl http://localhost:1025/endpoint/sfr.php
##       /bin/bash php.sh php bin/symfony_requirements
##       rm php/web/sfr.php
##

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

set -e
set -x

source "$_DIR/.env"

if [ "$PROJECT_NAME" = "" ]; then

    echo "PROJECT_NAME is not defined or is empty"

    exit 1;
fi

NAME="7.2.1-cli-intl-git"
#        echo -e "\nListing all global variables:\n";
#
#        printenv
#
#        echo -e "\nListing all global variables (posix):\n";
#
#        set -o posix; # https://askubuntu.com/a/275972
#        set

if [ "$(docker images -a | grep $NAME)" == "" ]; then
    cd docker/cli
        docker build -t php:$NAME .
    cd ../..
fi

# -i only instead of -it because of travis-ci: "the input device is not a TTY"

# export TRAVIS_CI=true

if [ "$TRAVIS_CI" == "true" ]; then

    CONNAME="phpcli-$(openssl rand -hex 2)"

    DOCKERINTERACTIVEMODE_USE="-i"

    [ "$DOCKERINTERACTIVEMODE" != "" ] && DOCKERINTERACTIVEMODE_USE="$DOCKERINTERACTIVEMODE"

    [ "$DOCKERINTERACTIVEMODE_USE" == "-i" ] && echo -e "\nvvvv\n"

        docker run $DOCKERINTERACTIVEMODE_USE --rm \
            --name $CONNAME \
            -v "$_DIR":/usr/src/myapp \
            -v "$_DIR/../.composer_cache_directory_to_speed_up_deployments":/root/.composer \
            -w /usr/src/myapp php:$NAME $@

    [ "$DOCKERINTERACTIVEMODE_USE" == "-i" ] && echo -e "\n^^^^\n"
else

     NETWORK="${PROJECT_NAME}-network";

    CONNAME="phpcli-$(openssl rand -hex 2)"

    DOCKERINTERACTIVEMODE_USE="-it"

    [ "$DOCKERINTERACTIVEMODE" != "" ] && DOCKERINTERACTIVEMODE_USE="$DOCKERINTERACTIVEMODE"

        docker run $DOCKERINTERACTIVEMODE_USE --rm \
            --name $CONNAME \
            --network=$NETWORK \
            -v "$_DIR":/usr/src/myapp \
            -v "$_DIR/../.composer_cache_directory_to_speed_up_deployments":/root/.composer \
            -w /usr/src/myapp php:$NAME $@
fi