# Welcome! This guide will walk you through installing Kubecost into your Kubernetes cluster. The Kubecost helm chart inludes all product dependencies and takes only a few minutes to install.
https://kubecost.com/install?ref=home
http://docs.kubecost.com/#getting-started

# HELM CHART is here:
https://github.com/kubecost/cost-analyzer-helm-chart/blob/master/README.md#manifest

# Before you begin
# In order to deploy the Kubecost helm chart, ensure the following are completed:

# 1. Helm client (version 2.14+) installed open_in_new
# 2. When using helm 2 on clusters with RBAC enabled, run the following commands to grant Tiller permissions. Learn more
USERID=$(az ad user show --id arturoqu@arturo1970.onmicrosoft.com --query objectId --out tsv)
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$USERID kubectl create clusterrolebinding cluster-self-admin-binding --clusterrole=cluster-admin --serviceaccount=kube-system:default

# Step 1: Install Kubecost
# Running the following commands will also install Prometheus, Grafana, and kube-state-metrics in the namespace supplied. View install configuration options here.
helm repo add kubecost https://kubecost.github.io/cost-analyzer/
helm install kubecost/cost-analyzer --namespace kubecost --name kubecost --set kubecostToken="YXJ0dXJvcXVAaG90bWFpbC5jYQ==xm343yadf98"
kubectl create namespace kubecost
helm repo add kubecost https://kubecost.github.io/cost-analyzer/
helm install kubecost kubecost/cost-analyzer --namespace kubecost --set kubecostToken="YXJ0dXJvcXVAaG90bWFpbC5jYQ==xm343yadf98"

# Note: if you receive a message stating the installation is "forbidden" then see the instructions above on granting RBAC permissions.
# Having installation issues? View our Troubleshooting Guide or contact us directly at team@kubecost.com.


# Updating Kubecost
# Now that your Kubcost chart is installed, you can update with the following commands:
helm repo update && helm upgrade kubecost kubecost/cost-analyzer file_copy
helm repo update && helm upgrade kubecost kubecost/cost-analyzer -n kubecost

# Deleting Kubecost
# To uninstall Kubecost and it's dependancies, run the following command:
helm del --purge kubecost file_copy
helm uninstall kubecost -n kubecost
