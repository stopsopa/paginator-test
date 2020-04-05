#!/bin/bash

if [ "$1" = "--help" ]; then

cat << EOF

/bin/bash $0 patch|minor|major
/bin/bash $0 force patch|minor|major

EOF

    exit 0
fi

FORCE="0";
if [ "$1" = "force" ]; then
    FORCE="1";
    shift;
fi

MODE="$1"
if [ "$MODE" = "" ]; then
    MODE="patch"
fi

TEST="^(patch|minor|major)$"

if ! [[ $MODE =~ $TEST ]]; then

    echo -e "MODE: should match one of values (patch|minor|major) but it is >>>$MODE<<<";

    exit 3;
fi

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

exec 3<> /dev/null
function red {
    printf "\e[91m$1\e[0m\n"
}
function green {
    printf "\e[32m$1\e[0m\n"
}

set -e
set -x

ORIGIN="origin"
LOCALBRANCH="master"
REMOTEBRANCH="master"

trim() {
    local var="$*"
    # remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

if [ "$(git rev-parse --abbrev-ref HEAD)" != $LOCALBRANCH ]; then

    { red "switch first branch to <$LOCALBRANCH>"; } 2>&3

    exit 1;
fi

{ green "\ncurrent branch: $LOCALBRANCH"; } 2>&3

DIFF="$(git diff --numstat)"

DIFF="$(trim "$DIFF")"

if [ "$DIFF" != "" ]; then

    { red "\n\n    Error: First commit changes ...\n\n"; } 2>&3

    exit 2;
fi

DIFF="$(git diff --numstat $LOCALBRANCH $ORIGIN/$REMOTEBRANCH)"

DIFF="$(trim "$DIFF")"

if [ "$DIFF" != "" ] || [ "$FORCE" = "1" ]; then

    VER="$(node "$_DIR/bash/node/json/get.js" "$_DIR/composer.json" version)";

    VER="$(/bin/bash "$_DIR/bash/semver.sh" "$VER")"

    VER="$(node "$_DIR/bash/node/json/set.js" "$_DIR/composer.json" version "$VER")";

    git commit --amend --no-edit

    git tag "$VER"

    git push $ORIGIN $REMOTEBRANCH --tags

    if [ "$?" != "0" ]; then

        { red "\n\nCan't git push\n"; } 2>&3

        exit 5
    fi

else

    { red "\n\n    Nothing new to publish, \n        run '/bin/bash update.sh force patch' if you're sure that there is still something that should be published\n\n"; } 2>&3
fi