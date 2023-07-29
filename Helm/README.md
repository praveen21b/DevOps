# Helm
[Helm](https://helm.sh/) is a package manager for Kubernetes. Helm is the bset wat to find, share, and use software built for Kubernetes.

> Lets say we have been tasked with installing the relational database service, e.g. `mysql` into the cluster, before installing we need to know how many pods we need for this service, pod definition, stateful or daemonset etc. So, we need to do quite bit of configuretion here. Also, we need to need to know about the `mysql` to configure it in a best possible way that it works efficiently. Here Helm gives us a solution by providing the idempotent configuration for the respective service (and provides the simple commands to install it e.g. `helm install mysql`).

> IMPORTANT:
> Helm charts can be found in [Artifact Hub](https://artifacthub.io/).

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
1. [Install MYSQL (Demo)](#install-mysql-demo)

## Install MYSQL (Demo)
- Visit [ArtifactHub](https://artifacthub.io/packages/helm/bitnami/mysql)
- ```bash
  helm install mysql oci://registry-1.docker.io/bitnamicharts/mysql
  ```
  This will install the mysql charts/packages.

  Check the created `mysql` pod using below command.
  ```bash
  [root@vm-home projects]# kubectl get pod -A
  NAMESPACE     NAME                               READY   STATUS    RESTARTS        AGE
  default       mysql-0                            1/1     Running   0               84s
  kube-system   coredns-5d78c9869d-99md5           1/1     Running   0               5m24s
  kube-system   etcd-minikube                      1/1     Running   0               5m36s
  kube-system   kube-apiserver-minikube            1/1     Running   0               5m36s
  kube-system   kube-controller-manager-minikube   1/1     Running   0               5m39s
  kube-system   kube-proxy-kjt9m                   1/1     Running   0               5m25s
  kube-system   kube-scheduler-minikube            1/1     Running   0               5m37s
  kube-system   storage-provisioner                1/1     Running   1 (4m54s ago)   5m34s
  ```

  ```bash
  [root@vm-home projects]# kubectl get all
  NAME          READY   STATUS    RESTARTS   AGE
  pod/mysql-0   1/1     Running   0          5m9s

  NAME                     TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
  service/kubernetes       ClusterIP   10.96.0.1       <none>        443/TCP    9m23s
  service/mysql            ClusterIP   10.102.103.65   <none>        3306/TCP   5m9s
  service/mysql-headless   ClusterIP   None            <none>        3306/TCP   5m9s

  NAME                     READY   AGE
  statefulset.apps/mysql   1/1     5m9s
  ```
  > **Note**: statefulset will give the guaranteed name to the pod*

- List out all the installed chart
  ```bash
  helm list
  ```

- Uninstalling the helm chart
  ```bash
  helm delete mysql
  ```

- To list the helm repositories
  ```bash
  helm repo list
  ```