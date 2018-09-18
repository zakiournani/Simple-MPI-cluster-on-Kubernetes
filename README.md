# Simple MPI cluster on Kubernetes
A simple way to deploy  a MPI cluster on Kubernetes

## Environment (tested with)
1. Minukube V0.27 or kubeadm v1.10
2. Kubectl v1.10
3. Docker v18.03

## Deployment

As MPI communication is based on SSH, Node images need to run sshd. To achieve passwordless communication between nodes, you 
should generate a key pair and share it with all node (only in a provate LAN context, either way you will need to generate a unique
pair per node).

This Dockerfile could be used to run both master and slave nodes, the difference would be at the level of the Entrypoint.

In order to connect master to slaves through Kubernetes cluster, the solution here was to create a service per slave node,
the service would assure the nodes recognition from the master using kubernetes DNS. Statefullset is used to give an identity to the master deployment.

## How to run
1. Build the Master and worker image based on the base image here present ( you could use the same image for both and use a entrypoint script that executes differently according to the node type).

2. Change Values on servicemaster.yaml and serviceworker.yaml before you create the services/deployments (to create many workers and no to create a file for every worker, it's possible to define a template using Helm)

3. kubectl create -f <file.yaml>

4. Depending on you entrypoint, the master could initiate a preset job (that was the usecase in my context), or it could be deployed as a published service that recieves queries and launches executions (many things are imaginable in this area using replicas and proxies ...).
