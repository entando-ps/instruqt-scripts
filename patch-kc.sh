#!/bin/bash
echo "==============================START patch kc =============================="
user=$(sudo kubectl -n entando get secrets/default-sso-in-namespace-admin-secret --template={{.data.username}} | base64 -d)
pass=$(sudo kubectl -n entando get secrets/default-sso-in-namespace-admin-secret --template={{.data.password}} | base64 -d)
dns=$(echo $HOSTNAME.$INSTRUQT_PARTICIPANT_ID.instruqt.io)
./kc-adapter -u  https://$dns $user $pass
echo "==============================END patch kc =============================="
