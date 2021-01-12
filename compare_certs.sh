export CERTIFICATE_FILE=$1
export PRIVATE_KEY_FILE=$2
echo "Checking private key file [${PRIVATE_KEY_FILE}] can be used to read files encrypted with public certificate [${CERTIFICATE_FILE}]"
echo "You should only see one row below if they match"
echo "---------------------------------"
(openssl x509 -noout -modulus -in ${CERTIFICATE_FILE} | openssl md5 ;\
   openssl rsa -noout -modulus -in ${PRIVATE_KEY_FILE} | openssl md5) | uniq
echo "---------------------------------"
