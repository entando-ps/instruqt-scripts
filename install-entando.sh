#!/bin/bash

echo "==============================START entando installation =============================="
echo "\${HOSTNAME}.\${INSTRUQT_PARTICIPANT_ID}" ${HOSTNAME}.${INSTRUQT_PARTICIPANT_ID}


sudo kubectl create namespace entando #can remove this from here because ns is already created in install-certificate.sh 
sudo kubectl apply -f https://raw.githubusercontent.com/entando/entando-releases/v7.0.0/dist/ge-1-1-6/namespace-scoped-deployment/cluster-resources.yaml
sudo kubectl apply -n entando -f https://raw.githubusercontent.com/entando/entando-releases/v7.0.0/dist/ge-1-1-6/namespace-scoped-deployment/namespace-resources.yaml

curl -sLO "https://raw.githubusercontent.com/entando/entando-releases/v7.0.0/dist/ge-1-1-6/samples/entando-app.yaml"
sed -i 's/  ingressHostName: YOUR-HOST-NAME/  ingressHostName: '${HOSTNAME}.${INSTRUQT_PARTICIPANT_ID}'.instruqt.io/g' entando-app.yaml
sed -i 's/  environmentVariables: null/  environmentVariables:/g' entando-app.yaml
sed -i '9i\    - name: "APPLICATIONBASEURL"' entando-app.yaml
sed -i '10i\      value: "https://'${HOSTNAME}.${INSTRUQT_PARTICIPANT_ID}'.instruqt.io/entando-de-app/"' entando-app.yaml

chmod 777 entando-app.yaml

curl -sLO "https://raw.githubusercontent.com/entando/entando-releases/v7.0.0/dist/ge-1-1-6/samples/entando-operator-config.yaml"
sed -i "8i\  entando.tls.secret.name: entando-tls-secret" entando-operator-config.yaml

sudo kubectl apply -f entando-operator-config.yaml -n entando
sleep 1
sudo kubectl apply -f entando-app.yaml -n entando

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


#"==============================Start welcome wizard disable =============================="
# PODNAME="$(sudo kubectl -n entando get pod | grep quickstart-server-deployment | cut -d ' ' -f 1)"

# sudo kubectl -n entando cp databases $PODNAME:/entando-data/

# sudo kubectl -n entando scale deployment quickstart-server-deployment --replicas=0
# sleep 2
# sudo kubectl -n entando scale deployment quickstart-server-deployment --replicas=1

# podsAreReady=0
# echo "3-podsAreReady = $podsAreReady"
# while [ $podsAreReady != "1" ]
# do
#     podsAreReady=`sudo kubectl -n entando get pods "$PODNAME" | grep "1/1" | wc -l`
#     echo "4-podsAreReady = $podsAreReady"
#     sleep 5
# done
#"==============================End welcome wizard disable =============================="

echo "==============================Start Install new content=============================="
# sudo kubectl apply -f test-content.yaml -n entando
# sleep 3

# bash <(curl -L "https://get.entando.org/cli") --update --release="v7.0.1" --cli-version="v7.0.0"

# sleep 3

# source "$HOME/.entando/activate" --force
# sleep 1

# ent appname quickstart
# ent namespace entando
# # ent pod list -n entando
# # ent ecr list
# ent k get entandodebundle
# ent ecr install test-content --conflict-strategy="OVERRIDE"
echo "==============================End Install new content=============================="
