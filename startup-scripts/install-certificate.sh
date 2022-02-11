#!/bin/bash
sudo kubectl create ns cert-manager
sudo kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.7.0/cert-manager.yaml
sudo kubectl apply -f cluster-issuer.yaml


dns=$HOSTNAME.$INSTRUQT_PARTICIPANT_ID.instruqt.io
sed 's/CHANGE_THIS/'$dns'/' certificate-template.yaml > certificate.yaml
sudo kubectl apply -n entando -f certificate.yaml
