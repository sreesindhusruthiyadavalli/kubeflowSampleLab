{
  global: {
    // User-defined global parameters; accessible to all component and environments, Ex:
    // replicas: 4,
  },
  components: {
    // Component-level parameters, defined initially from 'ks prototype use ...'
    // Each object below should correspond to a component in the components/ directory
    centraldashboard: {
      image: "gcr.io/kubeflow-images-public/centraldashboard:v0.3.0",
      name: "centraldashboard",
    },
    "tf-job-operator": {
      cloud: "null",
      deploymentNamespace: "null",
      deploymentScope: "cluster",
      name: "tf-job-operator",
      namespace: "null",
      tfDefaultImage: "null",
      tfJobImage: "gcr.io/kubeflow-images-public/tf_operator:v0.3.0",
      tfJobUiServiceType: "ClusterIP",
      tfJobVersion: "v1alpha2",
    },
  },
}
