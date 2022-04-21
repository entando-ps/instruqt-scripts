#!/bin/bash
#patch-cm.sh is used to patch the quickstart-eci ingress with /k8s/(adding trailing slash)
echo "==============================START patch entando cm ingress =============================="
sudo kubectl -n entando get deployment quickstart-cm-deployment -o yaml > entandocm.yaml
sed -i 's/  replicas: 1/  replicas: 0/g' entandocm.yaml
sudo kubectl -n entando apply -f entandocm.yaml

sudo kubectl -n entando get deployment quickstart-cm-deployment -o yaml > entandocm.yaml
sed -i 's/\/k8s/\/k8s\//g' entandocm.yaml
sed -i 's/  replicas: 0/  replicas: 1/g' entandocm.yaml
sudo kubectl -n entando apply -f entandocm.yaml

podsAreReady=`sudo kubectl -n entando get pods | grep "quickstart-cm-deployment-" | grep "1/1" | wc -l`
echo "3-cmPodIsReady = $podsAreReady"
while [ $podsAreReady != "1" ]
do
    podsAreReady=`sudo kubectl -n entando get pods | grep "quickstart-cm-deployment-" | grep "1/1" | wc -l`
    echo "4-cmPodIsReady = $podsAreReady"
    sleep 5
done


echo "==============================END patch entando cm ingress =============================="
