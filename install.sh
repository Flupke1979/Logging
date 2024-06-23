#!/bin/bash

# Wrapper installer script providing a simpler interface than calling Ansible
# commands with many parameters.

# Print usage
function printUsage {
    echo "Usage:"
    echo "    install.sh --host <HOST> --user <REMOTE_USER> \\"
    echo "        [--configuration <CONFIGURATION_FILE>]"
    echo "    or"
    echo "    install.sh --help"
    echo
    echo "    -h, --help:"
    echo "        Outputs a usage message (this message) and exit."
    echo "    -c, --configuration:"
    echo "        (Optional) Configuration file."
    echo "        Default: \"./configuration.yml\""
    echo "    -i, --host:"
    echo "        Host name or IP address of the device to install or update"
    echo "        Machine Metrics Monitoring."
    echo "    -u, --user:"
    echo "        User for the SSH connection to the device."
}

# Error, print usage and exit if not 4 or 6 parameters (2 option names and 2
# values plus optional configuration file) or only one (--help, -h)
if [[ $# -ne 6 ]] && [[ $# -ne 4 ]] && [[ $# -ne 1 ]]; then
    echo "Missing parameters"
    printUsage >&2
    exit 1
fi

# Transform long options to short ones.
for ARGUMENT in "$@"; do
    shift
    case "$ARGUMENT" in
    "--configuration")
        set -- "$@" "-c"
        ;;
    "--help")
        set -- "$@" "-h"
        ;;
    "--host")
        set -- "$@" "-i"
        ;;
    "--user")
        set -- "$@" "-u"
        ;;
    *)
        set -- "$@" "$ARGUMENT"
        ;;
    esac
done

# Set default configuration file
CONFIGURATION_FILE=./configuration.yml

# Parse short options
while getopts hc:i:u: OPTIONS; do
    case "$OPTIONS" in
    h)
        printUsage
        exit 0
        ;;
    c)
        if [[ -f $OPTARG ]]; then
            CONFIGURATION_FILE=$OPTARG
        else
            echo "The given configuration file \"$OPTARG\" does not exist."
            exit 1
        fi
        ;;
    i)
        # cspell:ignore OPTARG
        HOST_NAME=$OPTARG
        ;;
    u)
        REMOTE_USER=$OPTARG
        ;;
    ?)
        printUsage >&2
        exit 1
        ;;
    esac
done

# Update control machine dependencies
echo "Update dependencies..."
pip install --user --requirement ansible/requirements.txt


echo "*************************************************************************"

# Write target HOST_NAME into hosts.ini
echo "[monitoring]" >hosts.ini
echo "$HOST_NAME" >>hosts.ini

# Conditionally add --extra-vars parameter to ansible-playbook if the
# configuration file exists (when default) and it is not empty. i.e. does not
# contain only commented values.
EXTRA_VARS=()
if [[ -f $CONFIGURATION_FILE ]]; then
    if grep --quiet "^\w.*:" "$CONFIGURATION_FILE"; then
        EXTRA_VARS+=(--extra-vars @"$CONFIGURATION_FILE")
    fi
fi

# Run the top level playbook
ansible-playbook \
    --ask-become-pass \
    --ask-pass \
    "${EXTRA_VARS[@]}" \
    --inventory ./hosts.ini \
    --user "$REMOTE_USER" \
    ./ansible/stack.yml

# Remove previously created host.ini
rm hosts.ini
