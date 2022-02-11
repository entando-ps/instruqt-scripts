#!/bin/bash

echo "==============================START certificate installation =============================="
sudo kubectl create namespace entando

dns=$HOSTNAME.$INSTRUQT_PARTICIPANT_ID.instruqt.io
sed 's/CHANGE_THIS/'$dns'/' certificate-template.yaml > certificate.yaml
sudo kubectl apply -n entando -f certificate.yaml

certificateReady=`sudo kubectl -n entando get secret/entando-tls-secret | wc -l`
echo "1-certificateReady = $certificateReady"
while [ $certificateReady != "2" ]
do
certificateReady=`sudo kubectl -n entando get secret/entando-tls-secret | wc -l`
    echo "1-certificateReady = $certificateReady"
    sleep 5
done


echo "==============================END certificate installation =============================="
