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
the service would assure the nodes recognition from the master using kubernetes DNS. Statefullsets are used to give an identity to every deployment
