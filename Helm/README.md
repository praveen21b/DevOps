# Helm
[Helm](https://helm.sh/) is a package manager for Kubernetes. Helm is the bset wat to find, share, and use software built for Kubernetes.

> Lets say we have been tasked with installing the relational database service, e.g. `mysql` into the cluster, before installing we need to know how many pods we need for this service, pod definition, stateful or daemonset etc. So, we need to do quite bit of configuretion here. Also, we need to need to know about the `mysql` to configure it in a best possible way that it works efficiently. Here Helm gives us a solution by providing the idempotent configuration for the respective service (and provides the simple commands to install it e.g. `helm install mysql`).

## Prerequites

- [Install Helm](https://helm.sh/docs/intro/install/)
    ```bash
    curl -O https://get.helm.sh/helm-v3.12.2-linux-amd64.tar.gz

    tar -zxvf helm-v3.12.2-linux-amd64.tar.gz

    mv linux-amd64/helm /usr/local/bin/helm
    ```
- Kubernetes cluster (Here we are using minikube, [Minikube installation](https://minikube.sigs.k8s.io/docs/start/))
  ```bash
  # Minikube installation
  curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
  sudo rpm -Uvh minikube-latest.x86_64.rpm
  minikube start --driver=none --force
  ```

## Contents