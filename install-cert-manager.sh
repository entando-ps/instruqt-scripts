#!/bin/bash
echo "==============================START cert manager installation =============================="
sudo kubectl create ns cert-manager
sudo kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.7.0/cert-manager.yaml
sleep 60
sudo kubectl apply -f cluster-issuer.yaml
echo "==============================END cert manager installation =============================="
