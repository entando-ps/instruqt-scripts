#!/bin/bash
sudo kubectl create ns cert-manager
sudo kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.7.0/cert-manager.yaml
sudo kubectl apply -f cluster-issuer.yaml
