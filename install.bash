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



