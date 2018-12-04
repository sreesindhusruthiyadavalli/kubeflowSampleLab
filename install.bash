#!/usr/bin/env bash

#Read the variables for the ksonnet configuration
source variable.bash

#Create name space - an optional one(good to have namespace)
kubectl create namespace ${NAMESPACE}

#Intialize the ksonnet app create ksonnet environment. Environment makes it easy to manage app versions
ks init ${APP_NAME}
cd ${APP_NAME}

ks env add ${KF_ENV}
ks env set ${KF_ENV} --namespace ${NAMESPACE}

#4. Add Ksonnet registries for adding prototypes. Prototypes are ksonnet templates
ks registry add kubeflow github.com/kubeflow/kubeflow/tree/${KUBEFLOW_GITHUB_VERSION}/kubeflow
ks pkg install kubeflow/core@${KUBEFLOW_GITHUB_VERSION}
ks pkg install kubeflow/tf-serving@${KUBEFLOW_GITHUB_VERSION}

#Adding nfs server components to the ksonnet
ks registry add ciscoai github.com/CiscoAI/kubeflow-examples/tree/${CISCOAI_GITHUB_VERSION}/tf-mnist/pkg

ks pkg install ciscoai/nfs-server@${CISCOAI_GITHUB_VERSION}
ks pkg install ciscoai/nfs-volume@${CISCOAI_GITHUB_VERSION}
ks pkg install ciscoai/tf-mnistjob@${CISCOAI_GITHUB_VERSION}

#Deploy kubeflow core components to K8s cluster.
# If you are doing this on GCP, you need to run the following command first:
# kubectl create clusterrolebinding your-user-cluster-admin-binding --clusterrole=cluster-admin --user=<your@email.com>

ks generate centraldashboard centraldashboard
#Apply the component to the cluster
ks apply ${KF_ENV} -c centraldashboard
#ks show to see the applied configuration
#ks show ${KF_ENV}
ks generate tf-job-operator tf-job-operator
ks apply ${KF_ENV} -c tf-job-operator

#Deploy nfs server components to K8s cluster.
ks generate nfs-server nfs-server
ks apply ${KF_ENV} -c nfs-server

#Deploy nfs pv/pvc components to K8s cluster.
NFS_SERVER_IP=`kubectl -n ${NAMESPACE} get svc/nfs-server  --output=jsonpath={.spec.clusterIP}`
echo "NFS Server IP: ${NFS_SERVER_IP}"
ks generate nfs-volume nfs-volume  --name=${NFS_PVC_NAME}  --nfs_server_ip=${NFS_SERVER_IP}
ks apply ${KF_ENV} -c nfs-volume

#Get the list of pods
kubectl get pods -n ${NAMESPACE}

#ensure pvc is created ans status is bound
kubectl get pvc -n ${NAMESPACE}
