#!/usr/bin/env bash

##############################
# DEFAULT PATHS TO CONFIGURE #
##############################

XLX_DIR_DEF=/opt/Xilinx
VIV_DIR_DEF=${XLX_DIR_DEF}/Vivado/2024.2

######################

Help()
{
    echo "Starts Vivado without bloating home directory with logs."
    echo
    echo "Syntax: start.sh [-h|i]"
    echo
    echo "Options:"
    echo "-h, --help"
    echo	"prints this message"
    echo "-i, --input-path"
    echo 	"path to project to open"
    echo
}

PROJ_TO_OPEN_DEF=""
PROJ_TO_OPEN="${PROJ_TO_OPEN:=${PROJ_TO_OPEN_DEF}}"

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
        Help
        POSITIONAL+=("$1")
        shift # past argument
        ;;
    -i|--input-path)
        PROJ_TO_OPEN=$(realpath "$2")
        shift # past argument
        shift # past value
        ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

#####
# COMMENT OUT IF YOU DON'T USE SQUASHFS IMAGE
# Check if Vivado squashfs image is mounted:
#XLX_DIR="${XLX_DIR:=${XLX_DIR_DEF}}"
#VIV_DIR="${VIV_DIR:=${VIV_DIR_DEF}}"
#findmnt ${VIV_DIR} || { echo "Vivado squashfs image is not mounted!"; echo "Use: mount.sh"; echo; exit 2; }
#####

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd ${SCRIPT_DIR}

source ./envset.sh "$@" || exit $?

# Run from new directory in tmp so Vivado won't leave trash logs in home
mkdir -p /tmp/Xlx_${USER}
cd /tmp/Xlx_${USER}
# Default PROJ_TO_OPEN is an empty string
vivado ${PROJ_TO_OPEN}
