#Name space to be used for k8s cluster for the application
#If no name space is defined k8s have default namespace
NAMESPACE=kubeflowsample

#App name is name of the app
APP_NAME=dcs

#Environment 
KF_ENV=test

## GITHUB version for official kubeflow components
KUBEFLOW_GITHUB_VERSION=v0.3.0-rc.3

#CiscoAI version for nfs server
CISCOAI_GITHUB_VERSION=master

## Name of the NFS Persistent Volume
NFS_PVC_NAME=nfs
