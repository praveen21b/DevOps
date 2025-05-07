# Velero with MinIO for Kubernetes Backup and Restore

This guide walks you through deploying Velero using MinIO as an S3-compatible storage backend for storing backup data.

## Prerequisites

- A Kubernetes cluster
- Helm installed
- Velero CLI installed: https://velero.io/docs/

## Step 1: Deploy MinIO

>NOTE: You can run MinIO as a container or deploy it directly in your Kubernetes cluster.

To run MinIO locally using Podman:
```shell
podman run --privileged --rm -d  -p 9000:9000 -p 9001:9001 \
    -v ~/minio/data:/data:Z \
    -e "MINIO_ROOT_USER=ROOTNAME" \
    -e "MINIO_ROOT_PASSWORD=CHANGEME123" \
    quay.io/minio/minio server /data --console-address ":9001"
```
This starts MinIO with the console accessible on port 9001 and the S3-compatible API on port 9000.

>**MinIO Web Console (UI):** `http://<node_ip>:9001`

>**S3 Endpoint URL:** `http://<node_ip>:9000`

---

## Step 2.1: Create an S3 Bucket

Once MinIO is running, access the Web Console at `http://<node_ip>:9001` using the credentials you set (`MINIO_ROOT_USER` / `MINIO_ROOT_PASSWORD`).  
From the dashboard:

1. Log in to the MinIO console.
2. Click **Buckets** in the left sidebar.
3. Click **Create Bucket**.
4. Enter a bucket name (e.g., `test`) and confirm creation.

Make sure this bucket name matches what you’ll configure Velero to use later.

![alt text](image.png)
---
## Step 2.2: Create Access and Secret Key
![alt text](image-1.png)
## Step 3: Install Velero via Helm