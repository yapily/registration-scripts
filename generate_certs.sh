clear
export TEMPLATES_DIR=~/software_statements/zz_OBWAC_OBSEAL_TEMPLATES
if [ -d ${TEMPLATES_DIR} ] 
then
    echo "Directory [${TEMPLATES_DIR}] exists." 
else
    echo "Error: Directory [${TEMPLATES_DIR}] does not exists."
    exit 1
fi

export ROOT_DIR=~/software_statements/
echo "Root directory set to: [${ROOT_DIR}]"
echo

export DATE=$(date '+%Y%m%d.%H%M')
echo "Date set to: [${DATE}]"

export SSA_ID=${1}
echo "SSA ID set to: [${SSA_ID}]"
echo

export SSA_DIR="${ROOT_DIR}/${SSA_ID}/${DATE}"
echo "SSA directory set to: [${SSA_DIR}]"
echo creating "SSA directory"
mkdir -p ${SSA_DIR}
if [ $? != 0 ]
then
  exit 1;
fi

echo "Changing to SSA directory"
cd ${SSA_DIR}
echo "Generating private key and certificate sigining requests for ${SSA_ID}_${DATE}"
openssl req -new -newkey rsa:2048 -nodes -out tran_${SSA_ID}_${DATE}.csr -keyout tran_${SSA_ID}_${DATE}.key -subj "/C=GB/ST=/L=/O=OpenBanking/OU=0014H00001lFE7VQAW/CN=${SSA_ID}" -sha256
openssl req -new -newkey rsa:2048 -nodes -out sign_${SSA_ID}_${DATE}.csr -keyout sign_${SSA_ID}_${DATE}.key -subj "/C=GB/ST=/L=/O=OpenBanking/OU=0014H00001lFE7VQAW/CN=${SSA_ID}" -sha256
openssl req -new -config ${TEMPLATES_DIR}/obwac.cnf -out obwac.${SSA_ID}.${DATE}.csr -keyout obwac.${SSA_ID}.${DATE}.key
openssl req -new -config ${TEMPLATES_DIR}/obseal.cnf -out obseal.${SSA_ID}.${DATE}.csr -keyout obseal.${SSA_ID}.${DATE}.key

echo "Created files..."
ls -la /${SSA_DIR}
