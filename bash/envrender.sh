
# it would be good to implement also --rm flag, to remove old files matching to pattern

CLEANOLD="0";
if [ "$3" = "--clear" ] || [ "$3" = "--clean" ] || [ "$4" = "--clear" ] || [ "$4" = "--clean" ] ; then
  CLEANOLD="1";
fi

REMOVEFIRST="0";
if [ "$3" = "--rmfirst" ] || [ "$4" = "--rmfirst" ] ; then
  REMOVEFIRST="1";
fi

if [ "$1" = "--help" ]; then

cat << EOF

It's just envsubst but with some additional error handling and
overall this script generates also temporary filename
and new file under this name/location and return name of
this file on the stdout

TMP="\$(/bin/bash bash/envrender.sh .env docker/docker-compose.yml --clear)"
TMP="\$(/bin/bash bash/envrender.sh .env docker/docker-compose.yml --clear --rmfirst)"
TMP="\$(/bin/bash bash/envrender.sh .env docker/docker-compose.yml --rmfirst)"
TMP="\$(/bin/bash bash/envrender.sh .env docker/docker-compose.yml --rmfirst --clear)"
TMP="\$(/bin/bash bash/envrender.sh .env docker/docker-compose.yml)"
# do something
function cleanup {
    echo "cleanup...";
    unlink "\$TMP" || true
}
trap cleanup EXIT

EOF

    exit 1
fi

_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

source "$_DIR/colours.sh";

if [ "$#" -lt "2" ]; then

    { red "There should be at least two arguments given"; } 2>&3

    exit 1
fi

realpath . &> /dev/null

if [ "$?" != "0" ]; then

    { red "realpath is not installed run: brew install coreutils"; } 2>&3

    exit 1;
fi

envsubst --help &> /dev/null

if [ "$?" != "0" ]; then

    # https://stackoverflow.com/a/23622446
    { red "envsubst is not installed run: brew install gettext && brew link --force gettext"; } 2>&3

    exit 1;
fi

if [ ! -e "$1" ]; then  # not exist (fnode, directory, socket, etc.)

    # https://stackoverflow.com/a/23622446
    { red "$1 file doesn't exist"; } 2>&3

    exit 1;
fi

if [ ! -e "$2" ]; then  # not exist (fnode, directory, socket, etc.)

    # https://stackoverflow.com/a/23622446
    { red "$2 file doesn't exist"; } 2>&3

    exit 1;
fi

set -e

P="$(realpath -m "$2")"
PD="$(dirname "$P")"
PB="$(basename "$P")"

# https://stackoverflow.com/a/965069
EXTENSION="${PB#*.}"
FILENAME="${PB%%.*}"

if [ "$CLEANOLD" = "1" ]; then

  PREG="$(/bin/bash "$_DIR/preg_quote.sh" "$FILENAME")"
  EREG="$(/bin/bash "$_DIR/preg_quote.sh" "$EXTENSION")"

  CLEARLIST="$(find "$PD" -type f -maxdepth 1 | sed -nE "/\/$PREG-[a-f0-9]{4}\.$EREG$/p")"

  for file in $CLEARLIST
  do
      unlink "$file" || true
  done
fi

TMPFILE=""

while true
do
    TMPFILE="$PD/$FILENAME-$(openssl rand -hex 2).$EXTENSION"

    if [ ! -e "$TMPFILE" ]; then  # not exist (fnode, directory, socket, etc.)

        break;
    fi
done

function cleanup {

    unlink "$TMPFILE" || true
}

trap cleanup EXIT

# https://stackoverflow.com/a/30969768
set -o allexport
source "$1"
set +o allexport

TMPTMP="$(envsubst < "$2")"

if [ "$REMOVEFIRST" = "1" ]; then

  echo "$TMPTMP" > "$TMPFILE"

  # https://unix.stackexchange.com/a/209070
  TMPTMP="$(sed -e '1d;$d' "$TMPFILE")"
fi

echo "$TMPTMP" > "$TMPFILE"

# clear trap
trap - EXIT

echo "$TMPFILE"
