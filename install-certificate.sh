#!/bin/bash
sudo kubectl create namespace entando

dns=$HOSTNAME.$INSTRUQT_PARTICIPANT_ID.instruqt.io
sed 's/CHANGE_THIS/'$dns'/' certificate-template.yaml > certificate.yaml
sudo kubectl apply -n entando -f certificate.yaml
