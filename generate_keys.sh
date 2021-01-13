#!/usr/bin/env bash

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    echo "Usage: generate_keys.sh [SS_CLIENT_ID]"
    exit 1
fi

clear
export SS_CLIENT_ID=${1}

# Un-comment these two lines and update OPENSSL_HOME to point to LibreSSL if the script returns "organizationIdentifier=2.5.4.97" errors
export OPENSSL_HOME=/usr/local/Cellar/libressl/3.2.3
export PATH=$OPENSSL_HOME/bin:$PATH

export CONFIG_DIR="./config-files"
export DATE=$(date '+%Y%m%d.%H%M')
export OUTPUT_DIR="software_statements/OBWAC_OBSEAL/${SS_CLIENT_ID}_${DATE}"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

mkdir -p ${OUTPUT_DIR}
echo -e ""
echo -e "${YELLOW}Config: ${NC}"
echo -e "  ${YELLOW}Using OpenSSL Version:${NC} $(openssl version)"
echo -e "  ${YELLOW}SSA ID set to:${NC} ${SS_CLIENT_ID}"
echo -e "  ${YELLOW}Certificate output directory set to:${NC} ${OUTPUT_DIR}"

greenText() {
    echo
    echo -e "${GREEN}$1${NC}"
    echo
}
exitEarlyIfErrors() {
    if [ $? -ne 0 ]; then
        echo
        echo -e "${RED}Failed to create $1 for '${SS_CLIENT_ID}_${DATE}'${NC}"
        exit 1
    fi 
}

greenText "Generating keys and certificate sigining requests for '${SS_CLIENT_ID}_${DATE}'\nGenerating OBWAC key and certificate sigining requests..."
openssl req -new -config ${CONFIG_DIR}/obwac.cnf -out ${OUTPUT_DIR}/obwac.${SS_CLIENT_ID}.csr -keyout ${OUTPUT_DIR}/obwac.${SS_CLIENT_ID}-pass.key
exitEarlyIfErrors "OBWAC key and certificate sigining requests"

greenText "Generating a new OBWAC key without a password..."
openssl rsa -in ${OUTPUT_DIR}/obwac.${SS_CLIENT_ID}-pass.key -out ${OUTPUT_DIR}/obwac.${SS_CLIENT_ID}.key
exitEarlyIfErrors "a new OBWAC key without a password"

greenText "Generating OBSEAL key and certificate sigining requests..."
openssl req -new -config ${CONFIG_DIR}/obseal.cnf -out ${OUTPUT_DIR}/obseal.${SS_CLIENT_ID}.csr -keyout ${OUTPUT_DIR}/obseal.${SS_CLIENT_ID}-pass.key
exitEarlyIfErrors "OBSEAL key and certificate sigining requests"

greenText "Generating a new OBSEAL key without a password..."
openssl rsa -in ${OUTPUT_DIR}/obseal.${SS_CLIENT_ID}-pass.key -out ${OUTPUT_DIR}/obseal.${SS_CLIENT_ID}.key
exitEarlyIfErrors "a new OBSEAL key without a password"

greenText "Listing files created in '${OUTPUT_DIR}':"
ls -1 ${OUTPUT_DIR}
