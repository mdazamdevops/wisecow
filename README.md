# Accuknox DevOps Trainee - Practical Assessment Solution

This repository contains the complete solution for the practical assessment, which involves containerizing, deploying, and securing the "Wisecow" application.

## Table of Contents
1. [Original Wisecow Application](#original-wisecow-application)
2. [Problem Statement 1: Kubernetes Deployment](#problem-statement-1-kubernetes-deployment)
3. [Problem Statement 2: DevOps Scripts](#problem-statement-2-devops-scripts)
4. [Problem Statement 3: KubeArmor Security Policy](#problem-statement-3-kubearmor-security-policy)
5. [Final Directory Structure](#final-directory-structure)

---

## Original Wisecow Application

The base application is a simple "Cow wisdom" web server from the original [wisecow repository](https://github.com/nyrahul/wisecow). It can be run locally with the following prerequisites.

* **Prerequisites**: `sudo apt install fortune-mod cowsay -y`
* **How to use?**: Run `./wisecow.sh` and point a browser to the server port (default 4499).

---

## Problem Statement 1: Kubernetes Deployment

### Objective
The goal was to containerize the Wisecow application, deploy it to a Kubernetes environment, and implement a CI pipeline.

### Solution Artifacts
* **`Dockerfile`**: Creates a lightweight Debian-based container for the application.
* **Kubernetes Manifests (`/k8s`)**:
    * `deployment.yaml`: Deploys the application with 2 replicas into the `wisecow` namespace.
    * `service.yaml`: Exposes the pods internally via a ClusterIP service.
    * `ingress.yaml`: Manages external access and is configured for TLS.
* **GitHub Actions (`/.github/workflows/`)**: A CI workflow that automatically builds and pushes the Docker image to a container registry on every push to the `main` branch.

### How to Deploy and Verify
1.  **Prerequisites**:
    * A running Kubernetes cluster (e.g., Minikube, Kind).
    * An Ingress controller (e.g., NGINX Ingress) installed.
    * `kubectl` configured to your cluster.

2.  **Create Namespace**:
    ```shell
    kubectl create namespace wisecow
    ```

3.  **Deploy the Application**:
    ```shell
    kubectl apply -f k8s/ -n wisecow
    ```

4.  **Access the Application**:
    * Map the Ingress host `wisecow.local` to your cluster's IP (usually `127.0.0.1` for local setups) in your `/etc/hosts` file.
    * Open your browser and navigate to **`http://wisecow.local`**.

### Screenshots for Problem 1

**Building and Pushing the Docker Image**
![Building and Pushing Docker Image](./screenshots/01-docker-build-push.png)

**Deploying the Wisecow Application to Kubernetes**
![Deploying Wisecow to Kubernetes](./screenshots/02-deploying-to-kubernetes.png)

**Troubleshooting a Port-Forward Conflict**
![Troubleshooting Port-Forward Conflict](./screenshots/03-troubleshooting-port-forward.png)

**Accessing the Wisecow App via Port-Forward**
![Accessing the Wisecow App](./screenshots/04-accessing-the-app.png)

---

## Problem Statement 2: DevOps Scripts

Two Bash scripts were created to fulfill this requirement.

* **System Health Monitor (`/Problem Statement 2/scripts/system_health_monitor.sh`)**
    * **Description**: Monitors CPU, memory, and disk usage, printing an alert if they exceed predefined thresholds.
    * **Usage**: `chmod +x "Problem Statement 2/scripts/system_health_monitor.sh"` and then run `./"Problem Statement 2/scripts/system_health_monitor.sh"`

* **Application Health Checker (`/Problem Statement 2/scripts/app_health_checker.sh`)**
    * **Description**: Checks an application's uptime by analyzing its HTTP status code.
    * **Usage**: `chmod +x "Problem Statement 2/scripts/app_health_checker.sh"` and then run `./"Problem Statement 2/scripts/app_health_checker.sh" http://wisecow.local`

### Screenshots for Problem 2

**Making the DevOps Scripts Executable**
![Making Scripts Executable](./Problem%20Statement%202/scripts/screenshots/05-making-scripts-executable.png)

**Testing the Application Health Checker Script**
![Testing the App Health Checker](./Problem%20Statement%202/scripts/screenshots/06-testing-health-checker.png)

---

## Problem Statement 3: KubeArmor Security Policy

### Objective
To write and test a zero-trust KubeArmor policy to restrict unwanted behavior in the `wisecow` pods.

### Policy Details
* **File**: `/Problem Statement 3/kubearmor-policy-wisecow.yaml`
* **Description**: A KubeArmor policy that applies to pods labeled `app: wisecow` in the `wisecow` namespace. It is configured with `action: Block` to prevent the execution of shells, package managers, and the `/bin/sleep` command.

### How to Test the Policy
1.  **Prerequisites**: KubeArmor must be installed in the cluster.

2.  **Apply the Policy**:
    ```shell
    kubectl apply -f "Problem Statement 3/kubearmor-policy-wisecow.yaml" -n wisecow
    ```

3.  **Trigger a Violation**:
    ```shell
    # Get a pod name
    POD=$(kubectl get pods -n wisecow -l app=wisecow -o jsonpath='{.items[0].metadata.name}')
    
    # Attempt to run the blocked command
    kubectl exec -n wisecow -it $POD -- sleep 10
    ```
    This command will fail with a **`Permission denied`** error.

4.  **Check Violation Logs**:
    In a separate terminal, view the live security alerts from KubeArmor.
    ```shell
    karmor logs
    ```
    A log entry with `"result":"Blocked"` will appear, confirming the policy worked.

### Screenshots for Problem 3

**Installing the KubeArmor CLI and Service**
![Installing KubeArmor](./Problem%20Statement%203/screenshots/07-installing-kubearmor.png)

**Applying and Verifying the KubeArmor Policy**
![Applying KubeArmor Policy](./Problem%20Statement%203/screenshots/08-applying-kubearmor-policy.png)

**Final Proof: Policy Violation and Logged Alert**
![Policy Violation Proof](./Problem%20Statement%203/screenshots/09-policy-violation-proof.png)

---

## Final Directory Structure
```
.
├── Dockerfile
├── k8s
│   ├── deployment.yaml
│   ├── ingress.yaml
│   └── service.yaml
├── LICENSE
├── Problem Statement 2
│   └── scripts
│       ├── app_health_checker.sh
│       └── system_health_monitor.sh
├── Problem Statement 3
│   ├── kubearmor-policy-wisecow.yaml
│   └── screenshots
│       └── ...
└── wisecow.sh
```