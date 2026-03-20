#!/bin/bash
# ============================================================
# Deployment Script — Azure Blob Storage Setup
# Automates the entire cloud storage deployment
# Security: Credentials loaded from environment variables
# ============================================================

STORAGE_ACCOUNT="mitailive"
CONTAINER_NAME="files"
RESOURCE_GROUP="mitailive-rg"
LOCATION="eastus"
LOG_FILE="./logs/storage.log"

# NOTE: Never hardcode credentials in scripts.
# Set this environment variable before running:
# export AZURE_CONNECTION_STRING="your-connection-string"
CONNECTION_STRING="${AZURE_CONNECTION_STRING}"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

echo "╔══════════════════════════════════════════════╗"
echo "║     Cloud Storage Deployment — Azure         ║"
echo "╚══════════════════════════════════════════════╝"
echo ""

# Step 1 — Check Azure CLI
echo "🔍 Step 1: Checking Azure CLI..."
if ! command -v az &> /dev/null; then
    echo "❌ Azure CLI not found. Install from: https://aka.ms/installazurecliwindows"
    exit 1
fi
echo "✅ Azure CLI found"
log "DEPLOY: Azure CLI verified"

# Step 2 — Login check
echo ""
echo "🔐 Step 2: Checking Azure login..."
az account show &> /dev/null
if [ $? -ne 0 ]; then
    echo "🔑 Not logged in. Logging in..."
    az login
fi
echo "✅ Azure login confirmed"
log "DEPLOY: Azure login verified"

# Step 3 — Create resource group
echo ""
echo "📦 Step 3: Creating resource group '$RESOURCE_GROUP'..."
az group create \
    --name "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --output none
echo "✅ Resource group ready"
log "DEPLOY: Resource group $RESOURCE_GROUP created"

# Step 4 — Create storage account
echo ""
echo "🗄️  Step 4: Creating storage account '$STORAGE_ACCOUNT'..."
az storage account create \
    --name "$STORAGE_ACCOUNT" \
    --resource-group "$RESOURCE_GROUP" \
    --location "$LOCATION" \
    --sku Standard_LRS \
    --kind StorageV2 \
    --output none
echo "✅ Storage account ready"
log "DEPLOY: Storage account $STORAGE_ACCOUNT created"

# Step 5 — Enable public blob access
echo ""
echo "🌐 Step 5: Enabling public blob access..."
az storage account update \
    --name "$STORAGE_ACCOUNT" \
    --resource-group "$RESOURCE_GROUP" \
    --allow-blob-public-access true \
    --output none
echo "✅ Public access enabled"
log "DEPLOY: Public blob access enabled"

# Step 6 — Create container
echo ""
echo "📁 Step 6: Creating container '$CONTAINER_NAME'..."
az storage container create \
    --connection-string "$CONNECTION_STRING" \
    --name "$CONTAINER_NAME" \
    --public-access blob
echo "✅ Container created with public access"
log "DEPLOY: Container $CONTAINER_NAME created"

# Step 7 — Done
echo ""
echo "╔══════════════════════════════════════════════╗"
echo "║         ✅ DEPLOYMENT COMPLETE!              ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
echo "Storage Account : $STORAGE_ACCOUNT"
echo "Container       : $CONTAINER_NAME"
echo "Public URL Base : https://${STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER_NAME}/"
echo ""
echo "Run './storage.sh help' to see available commands"
log "DEPLOY: Complete. Storage ready at https://${STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER_NAME}/"