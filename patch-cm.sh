#!/bin/bash
sudo kubectl -n entando get deployment quickstart-cm-deployment -o yaml > entandocm.yaml
sed -i 's/  replicas: 1/  replicas: 0/g' entandocm.yaml
sudo kubectl -n entando apply -f entandocm.yaml

sudo kubectl -n entando get deployment quickstart-cm-deployment -o yaml > entandocm.yaml
sed -i 's/\/k8s/\/k8s\//g' entandocm.yaml
sed -i 's/  replicas: 0/  replicas: 1/g' entandocm.yaml
sudo kubectl -n entando apply -f entandocm.yaml
