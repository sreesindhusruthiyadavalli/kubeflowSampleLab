local env = std.extVar("__ksonnet/environments");
local params = std.extVar("__ksonnet/params").components["tf-mnist-client"];

local k = import "k.libsonnet";
local util = import "ciscoai/tf-mnistjob/util.libsonnet";

// updatedParams uses the environment namespace if
// the namespace parameter is not explicitly set
local updatedParams = params {
  namespace: if params.namespace == "null" then env.namespace else params.namespace,
};

local name = params.name;
local namespace = updatedParams.namespace;
local replicas = params.replicas;
local host = params.mnist_serving_ip;
local port = params.mnist_serving_port;
local lbip = params.lbip;
local lb = 
  if lbip == "null" then
    ""
  else
    lbip;

local image = params.image;

local deployment = {
   "apiVersion": "apps/v1",
   "kind": "Deployment",
   "metadata": {
      "name": name,
      "namespace": namespace,
      "labels": {
         "app": "mnist-client",
      }
   },
   "spec": {
      "replicas" : std.parseInt(replicas),
      "selector": {
         "matchLabels": {
            "app": "mnist-client"
         }
      },
      "template": {
         "metadata": {
            "labels": {
               "app": "mnist-client",
            }
         },
         "spec": {
            "containers": [
               {
                  "name": "mnist-client",
                  "image": image,
                  "env": [
                     {
                        "name": "TF_MODEL_SERVER_HOST",
                        "value": host
                     },
                     {
                        "name": "TF_MODEL_SERVER_PORT",
                        "value": port
                     }   
                  ],
                  "ports": [
                     {
                        "containerPort": 80
                     }
                  ],
                  "resources": {
                        "requests": {
                            "memory": "1Gi",
                            "cpu": "1",
                                    },
                        "limits": {
                            "memory": "4Gi",
                            "cpu": "4",
                         },
                    },
               }
            ]
         }
      }
   }
};

local service = {
   "apiVersion": "v1",
   "kind": "Service",
   "metadata": {
      "name": name,
      "namespace": namespace,
      "labels": {
         "app": "mnist-client"
      }
   },
   "spec": {
      "type": "LoadBalancer",
      "loadBalancerIP": lb,
      "ports": [
         {
            "port": 80,
            targetPort: 80
         }
      ],
      "selector": {
         "app": "mnist-client"
      }
   }
};

std.prune(k.core.v1.list.new([deployment,service]))
