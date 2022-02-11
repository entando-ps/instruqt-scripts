#!/bin/bash
echo "\${HOSTNAME}.\${INSTRUQT_PARTICIPANT_ID}" ${HOSTNAME}.${INSTRUQT_PARTICIPANT_ID}


sudo kubectl create namespace entando
sudo kubectl apply -n entando -f https://raw.githubusercontent.com/entando/entando-releases/v6.3.2/dist/ge-1-1-6/namespace-scoped-deployment/orig/namespace-resources.yaml
sudo kubectl apply -f https://raw.githubusercontent.com/entando/entando-releases/v6.3.2/dist/ge-1-1-6/namespace-scoped-deployment/cluster-resources.yaml
curl -sfL https://github.com/entando-k8s/entando-helm-quickstart/archive/v6.3.2.tar.gz | tar xvz

chmod 777 -R entando-helm-quickstart-6.3.2
cd entando-helm-quickstart-6.3.2 || exit

#Updating entando-operator-config.yaml
sed -i 's/#  entando.tls.secret.name: sample-tls-secret/  entando.tls.secret.name: entando-tls-secret/g' sample-configmaps/entando-operator-config.yaml
sed -i 's/#  entando.default.routing.suffix: your.domain.com/  entando.default.routing.suffix: '${HOSTNAME}.${INSTRUQT_PARTICIPANT_ID}'.instruqt.io/g' sample-configmaps/entando-operator-config.yaml


#Updating values.yml
sed -i 's/##singleHostName:  test.mycluster.com/singleHostName: '${HOSTNAME}.${INSTRUQT_PARTICIPANT_ID}'.instruqt.io/g' values.yaml



sudo kubectl apply -f sample-configmaps/entando-operator-config.yaml -n entando

sudo helm template quickstart ./ > output.yaml
sed -i "41i\        environmentVariables: " output.yaml
sed -i '42i\        - name: "APPLICATIONBASEURL"' output.yaml
sed -i '43i\          value: "https://'${HOSTNAME}.${INSTRUQT_PARTICIPANT_ID}'.instruqt.io/entando-de-app/"' output.yaml
sudo kubectl apply -f output.yaml -n entando
echo '****************App Builder will be ready****************'
echo '****************Please wait for 10-15 mins***************'
echo '*********************************************************'