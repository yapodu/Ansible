#!/bin/sh

#################################
# SET VARIABLE
#################################
RSA_PUB="${HOME}/.ssh/id_rsa.pub"
KEYS="${HOME}/.ssh/authorized_keys"

#################################
# MAIN
#################################

ssh-keygen -t rsa -P "" << EOF

EOF

if [ ! -f ${RSA_PUB} ]; then
        echo "ERROR : File not found [${DSA_PUB}]"

else
        cat ${RSA_PUB} >> ${KEYS}
        chmod 600 ${KEYS}

fi
