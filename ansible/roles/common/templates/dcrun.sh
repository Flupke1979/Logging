#!/bin/bash

# Wrapper script around the docker compose command, simplifying its usage.
# It calls the top level docker-compose.yml files along with all files found in
# the containers sub directory.
# It also specifies the .env file to use.

# Actual docker compose call
function dockerCompose {
    # shellcheck disable=SC2046
    # cSpell:ignore maxdepth
    sudo docker compose \
        --project-name monitoring \
        --env-file "{{ install_path }}/.env" \
        --file "{{ install_path }}/docker-compose.yml" \
        $(find "{{ containers_path }}" -maxdepth 2 2>/dev/null |
            grep --ignore-case docker-compose.yml |
            sed --expression "s=^=--file =") \
        "$@"
}

# Print usage
function printUsage {
    echo "Usage:"
    echo "    dcrun.sh <COMMAND> [SERVICE]"
    echo
    echo "    COMMAND:"
    echo "        (config|down):"
    echo "        Run the docker compose command using all docker-compose.yml"
    echo "        files in the Machine Metrics Monitoring stack with the given"
    echo "        docker compose subcommand."
    echo "        (build|logs|pull|restart|start|stop|up) [SERVICE]:"
    echo "        Run the docker compose command as above but also accept an"
    echo "        optional service name (container) defined in the"
    echo "        docker-compose.yml files. When SERVICE is provided, the"
    echo "        script will run the command only for this service."
    echo "        (help):"
    echo "        Outputs a usage message (this message) and exit."
}

COMMAND="$1"
shift

case $COMMAND in
build)
    dockerCompose build --pull "$@"
    ;;
config)
    dockerCompose config --quiet
    ;;
down)
    dockerCompose down --volumes
    ;;
help)
    printUsage
    ;;
logs)
    dockerCompose logs --follow --tail="50" "$@"
    ;;
pull)
    dockerCompose pull "$@"
    ;;
restart)
    dockerCompose restart "$@"
    ;;
start)
    dockerCompose start "$@"
    ;;
stop)
    dockerCompose stop "$@"
    ;;
up)
    dockerCompose up --detach --force-recreate --remove-orphans "$@"
    ;;
*)
    echo "Invalid parameter."
    printUsage >&2
    exit 1
    ;;
esac
