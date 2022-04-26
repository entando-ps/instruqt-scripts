#!/bin/bash

echo "==============================START entando installation =============================="
echo "\${HOSTNAME}.\${INSTRUQT_PARTICIPANT_ID}" ${HOSTNAME}.${INSTRUQT_PARTICIPANT_ID}


sudo kubectl create namespace entando #can remove this from here because ns is already created in install-certificate.sh 
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
sed -i "10i\  environmentVariables: " output.yaml
sed -i '11i\    - name: "APPLICATIONBASEURL"' output.yaml
sed -i '12i\      value: "https://'${HOSTNAME}.${INSTRUQT_PARTICIPANT_ID}'.instruqt.io/entando-de-app/"' output.yaml


#sed -i "43i\        environmentVariables: " output.yaml
#sed -i '44i\         - name: "APPLICATIONBASEURL"' output.yaml
#sed -i '45i\           value: "https://'${HOSTNAME}.${INSTRUQT_PARTICIPANT_ID}'.instruqt.io/entando-de-app/"' output.yaml
sudo kubectl apply -f output.yaml -n entando

echo '****************Waiting Entando to start****************'
podsAreReady=`sudo kubectl -n entando get pods | grep "quickstart-cm-deployment-" | grep "1/1" | wc -l`
echo "1-podsAreReady = $podsAreReady"
while [ $podsAreReady != "1" ]
do
    podsAreReady=`sudo kubectl -n entando get pods | grep "quickstart-cm-deployment-" | grep "1/1" | wc -l`
    echo "2-podsAreReady = $podsAreReady"
    sleep 5
done
echo '****************Entando is started****************'

cd ..

echo "==============================END entando installation =============================="

PODNAME="$(sudo kubectl -n entando get pod | grep quickstart-server-deployment | cut -d ' ' -f 1)"

sudo kubectl -n entando cp databases $PODNAME:/entando-data/

sudo kubectl -n entando scale deployment quickstart-server-deployment --replicas=0
sleep 2
sudo kubectl -n entando scale deployment quickstart-server-deployment --replicas=1

podsAreReady=0
echo "3-podsAreReady = $podsAreReady"
while [ $podsAreReady != "1" ]
do
    podsAreReady=`sudo kubectl -n entando get pods "$PODNAME" | grep "1/1" | wc -l`
    echo "4-podsAreReady = $podsAreReady"
    sleep 5
done


echo "==============================Start Install new content=============================="
sudo kubectl apply -f test-content.yaml -n entando
sleep 3

bash <(curl -L "https://get.entando.org/cli") --update --release="v7.0.1" --cli-version="v7.0.0"

sleep 3

source "$HOME/.entando/activate" --force
sleep 1

ent appname quickstart
ent namespace entando
# ent pod list -n entando
# ent ecr list
ent k get entandodebundle
ent ecr install test-content --conflict-strategy="OVERRIDE"
echo "==============================End Install new content=============================="
