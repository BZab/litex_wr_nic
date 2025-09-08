#!/bin/bash

##############################
# DEFAULT PATHS TO CONFIGURE #
##############################

VERSION_DEF=2024.2
XLX_DIR_DEF=/opt/Xilinx
VIV_DIR_DEF=${XLX_DIR_DEF}/Vivado/${VERSION_DEF}

######################

Help()
{
    echo "Exports all needed variables for Vivado"
    echo
    echo "Syntax: source setenv.sh [-h|l]"
    echo
    echo "Options:"
    echo "-h, --help"
    echo	"prints this message"
    echo "-l, --license=\"some_name\"|address"
    echo 	"allows to specify license server for Vivado"
#    echo "-n, --no-peta-linux"
#    echo 	"don't export petalinux environmental variables"
#    echo "-p, --peta-linux=PETA_DIR"
#    echo 	"overrides path to peta linux"
    echo "-u, --vivado=VIV_DIR"
    echo 	"overrides vivado's path"
    echo "-v, --version=VERSION"
    echo 	"overrides version number"
    echo
}

# 'hidden' variable to test for to avoid sourcing this file multiple times
_ENVSET_SH_ALREADY_RUN=true

# Instead of passing as options, let alternatively variables be exported before calling this script
# TODO: UNTESTED!
VERSION="${VERSION:=${VERSION_DEF}}"
XLX_DIR="${XLX_DIR:=${XLX_DIR_DEF}}"
VIV_DIR="${VIV_DIR:=${VIV_DIR_DEF}}"
#PETA_DIR="${PETA_DIR:=${PETA_DIR_DEF}}"

#DONT_EXPORT_PETA="${DONT_EXPORT_PETA:=false}"

POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in 
    -h|--help)
        Help
        shift # past argument
        return 1 # EXIT
        ;;
    -l|--license)
        LICENSE="$2"
        shift # past argument
        shift # past value
        ;;
#    -n|--no-peta-linux)
#        DONT_EXPORT_PETA=true
#        shift # past argument
#        ;;
#    -p|--peta-linux)
#        PETA_DIR="$2"
#        shift # past argument
#        shift # past value
#        ;;
    -u|--vivado)
        VIV_DIR="$2"
        shift # past argument
        shift # past value
        ;;
     -v|--version)
        VERSION="$2"
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

# Vivado variables
case $LICENSE in
    #"some_name")
    #    export XILINXD_LICENSE_FILE=PORT@IP
    #    ;;
    *)
        if [ -n "$LICENSE" ]; then
        	export XILINXD_LICENSE_FILE=$LICENSE
        fi
        ;;
esac
	
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

source ${VIV_DIR}/settings64.sh
