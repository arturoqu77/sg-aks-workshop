# variables
# NOTE: Please make sure PREFIX is unique in your tenant, you must not have any hyphens '-' in the value.
PREFIX="aqfin" 
RG="${PREFIX}-rg"
LOC="eastus"
NAME="${PREFIX}"
ACR_NAME="${NAME}acr"
VNET_NAME="${PREFIX}vnet"
AKSSUBNET_NAME="${PREFIX}akssubnet"
SVCSUBNET_NAME="${PREFIX}svcsubnet"
APPGWSUBNET_NAME="${PREFIX}appgwsubnet"
# these modified instructions do not install the AZURE FIREWALL piece, for cost reasons

# Get ARM Access Token and Subscription ID - This will be used for AuthN later.
ACCESS_TOKEN=$(az account get-access-token -o tsv --query 'accessToken')
# NOTE: Update Subscription Name
# Use list command to get list of Subscription IDs & Names
az account list -o table

# Get subscription ID
SUBID=$(az account show -s 'ARTURO-DEV' -o tsv --query 'id')

# Create Resource Group
az group create --name $RG --location $LOC

# Create Virtual Network & Subnets for AKS, k8s Services, ACI, Firewall and WAF
az network vnet create \
    --resource-group $RG \
    --name $VNET_NAME \
    --address-prefixes 100.64.0.0/16 \
    --subnet-name $AKSSUBNET_NAME \
    --subnet-prefix 100.64.1.0/24
az network vnet subnet create \
    --resource-group $RG \
    --vnet-name $VNET_NAME \
    --name $SVCSUBNET_NAME \
    --address-prefix 100.64.2.0/24
az network vnet subnet create \
    --resource-group $RG \
    --vnet-name $VNET_NAME \
    --name $APPGWSUBNET_NAME \
    --address-prefix 100.64.3.0/26

# Create SP and Assign Permission to Virtual Network
az ad sp create-for-rbac -n "http://${PREFIX}sp" --skip-assignment
# ********************************************************************************
# Take the SP Creation output from above command and fill in Variables accordingly
# ********************************************************************************
APPID="de92c317-cf59-48f6-9a48-2136bd0d2dff"
PASSWORD="sz5~rEQCfaB6-Hj8A09.pFQidb2KTyu-9b"
VNETID=$(az network vnet show -g $RG --name $VNET_NAME --query id -o tsv)
# Assign SP Permission to VNET
az role assignment create --assignee $APPID --scope $VNETID --role Contributor
# View Role Assignment
az role assignment list --assignee $APPID --all -o table

# Create Public IP for use with WAF (Azure Application Gateway)
az network public-ip create -g $RG -n $AGPUBLICIP_NAME -l $LOC --sku "Standard"


