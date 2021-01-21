#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

### Helper Functions
printUsage() {
    echo 
    echo "Usage:" 
    echo "rename_files.sh \ "
    echo "   -company-name [your-company] \ "
    echo "   -ssid         [software-statement-id] \ "
    echo "   -obseal-pem   [obseal-pem-file] \ "
    echo "   -obseal-key   [obseal-key-file] \ "
    echo "   -obwac-pem    [obwac-pem-file] \ "
    echo "   -obwac-key    [obwac-key-file]"
}
greenText() {
    echo -e "${GREEN}$1${NC} $2"
}
yellowText() {
    echo -e "${YELLOW}$1${NC} $2"
}
convertFileName() {
    cred_type=$1
    cred_file=${2%.*}
    cred_file_ext=$3
    echo "$cred_type.$COMPANY_NAME.SSID.$SSID.KID.$cred_file.$cred_file_ext"
}
stripKeyFileName() {
    key_file_name=$1
    ext=${key_file_name##*.}
    echo $ext
    echo 
}
renameFile(){
    oldFile=$1
    newFile=$2
    cp $oldFile $newFile
}

### Capture input
if [ $# -eq 6 ]; then
    printUsage
    exit 1
fi

while [[ $# -gt 0 ]]; do
    case "$1" in
    -obwac-pem)
        if [[ ${2: -4} != ".pem" ]]; then
            echo
            echo "Option argument to '-obwac-pem' must be a .pem file."
            exit 1
        fi
        OBWAC_PEM_FILE_AND_PATH=${2}
        OBWAC_PEM_FILE=${2##*/}
        shift
        ;;
    -obwac-key)
        if [[ ${2: -4} != ".key" ]]; then
            echo
            echo "Option argument to '-obwac-key' must be a .key file."
            exit 1
        fi
        OBWAC_KEY_FILE_AND_PATH=${2}
        OBWAC_KEY_FILE=${2##*/}
        shift
        ;;
    -obseal-pem)
        if [[ ${2: -4} != ".pem" ]]; then
            echo
            echo "Option argument to '-obseal-pem' must be a .pem file."
            exit 1
        fi
        OBSEAL_PEM_FILE_AND_PATH=${2}
        OBSEAL_PEM_FILE=${2##*/}
        shift
        ;;
    -obseal-key)
        if [[ ${2: -4} != ".key" ]]; then
            echo
            echo "Option argument to '-obseal-key' must be a .key file."
            exit 1
        fi
        OBSEAL_KEY_FILE_AND_PATH=${2}
        OBSEAL_KEY_FILE=${2##*/}
        shift
        ;;
    -company-name)
        COMPANY_NAME=${2/[[:blank:]]/}
        shift
        ;;
    -ssid)
        SSID=${2}
        shift
        ;;
    *)
        echo "Invalid argument: $1"
        printUsage
        exit 1
    esac
    shift
done

### Verify all required properties are set
if [[ -z $SSID || -z $OBSEAL_PEM_FILE || -z $OBWAC_PEM_FILE || -z $OBSEAL_KEY_FILE || -z $OBWAC_KEY_FILE || -z $COMPANY_NAME ]]; then
    echo "All required parameters are not set!"
    printUsage
    exit 1
fi

### Print properies
echo
yellowText "Config:"
yellowText "  Company name set to:" $COMPANY_NAME
yellowText "  Software Statement ID set to:" $SSID
yellowText "  OB Wac pem file set to:" $OBWAC_PEM_FILE_AND_PATH
yellowText "  OB Wac key file set to:" $OBWAC_KEY_FILE_AND_PATH
yellowText "  OB Seal pem file set to:" $OBSEAL_PEM_FILE_AND_PATH
yellowText "  OB Seal key file set to:" $OBSEAL_KEY_FILE_AND_PATH
echo

### Get user to verify config
read -p "Are you happy with these settings? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Exiting."
    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
fi
echo

### Rename files
NEW_OBWAC_PEM_PATH=$(convertFileName "obwac" $OBWAC_PEM_FILE "pem")
greenText "Renaming OB Wac PEM to:" $NEW_OBWAC_PEM_PATH
renameFile $OBWAC_PEM_FILE_AND_PATH $NEW_OBWAC_PEM_PATH

NEW_OBWAC_KEY_PATH=$(convertFileName "obwac" $OBWAC_PEM_FILE "key")
greenText "Renaming OB Wac KEY to:" $NEW_OBWAC_KEY_PATH
renameFile $OBWAC_KEY_FILE_AND_PATH $NEW_OBWAC_KEY_PATH

NEW_OBSEAL_PEM_FILE=$(convertFileName "obseal" $OBSEAL_PEM_FILE "pem")
greenText "Renaming OB Seal PEM to:" $NEW_OBSEAL_PEM_FILE
renameFile $OBSEAL_PEM_FILE_AND_PATH $NEW_OBSEAL_PEM_FILE

NEW_OBSEAL_KEY_FILE=$(convertFileName "obseal" $OBSEAL_PEM_FILE "key")
greenText "Renaming OB Seal KEY to:" $NEW_OBSEAL_KEY_FILE
renameFile $OBSEAL_KEY_FILE_AND_PATH $NEW_OBSEAL_KEY_FILE