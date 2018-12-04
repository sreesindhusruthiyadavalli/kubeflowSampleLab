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

## Used in training.bash
# Enviroment variables for mnist training job (See mnist_model.py)
TF_DATA_DIR=/mnt/data
TF_MODEL_DIR=/mnt/model
NFS_MODEL_PATH=/mnt/export
TF_EXPORT_DIR=${NFS_MODEL_PATH}

# If you want to use your own image,
# make sure you have a dockerhub account and change
# DOCKER_BASE_URL and IMAGE below.
DOCKER_BASE_URL=docker.io/sryadava
IMAGE=${DOCKER_BASE_URL}/tf-mnist-demo:v3
#docker build . --no-cache  -f Dockerfile -t ${IMAGE}
#docker push ${IMAGE}
