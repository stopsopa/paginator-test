
set -e
set -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"

source "$DIR/../.env"

set -x
TMP="$(/bin/bash "$DIR/../bash/envrender.sh" "$DIR/../.env" docker-compose.yml --clear)"
TMPLOCAL="$(/bin/bash "$DIR/../bash/envrender.sh" "$DIR/../.env" docker-compose.local.yml --clear)"
set +x

if [ "$1" = "--help" ]; then

cat << EOF

  # to run container
  /bin/bash $0

  # to just generate config file
  /bin/bash $0 --gen

EOF

    exit 0;
fi

if [ "$1" = "--gen" ]; then

  echo "Config generated: $TMP"

  exit 0;
fi

if [ "$1" = "up" ]; then

    docker-compose -f "$TMP" -f "$TMPLOCAL" build
    docker-compose -f "$TMP" -f "$TMPLOCAL" up -d --build

    MYSQL="${PROJECT_NAME}_mysql"

    if [ "$(docker inspect -f {{.State.Health.Status}} $MYSQL)" != "healthy" ]; then

      set +x

      printf "Waiting for status \"HEALTHY\": ";
      until [ "$(docker inspect -f {{.State.Health.Status}} $MYSQL)" = "healthy" ]; do
          printf "."
          sleep 3;
      done;
      echo ""
      set -x

    fi

    echo "all good";

    exit 0;
fi

if [ "$1" = "stop" ]; then

    docker-compose -f "$TMP" -f "$TMPLOCAL" stop
fi