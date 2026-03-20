#!/bin/bash
# ============================================================
# Cloud File Storage CLI — Azure Blob Storage
# Author: Mitaire Oteri
# Description: Upload, download, list, delete, manage files
# Security: Credentials loaded from environment variables
# ============================================================

STORAGE_ACCOUNT="mitailive"
CONTAINER_NAME="files"
RESOURCE_GROUP="mitailive-rg"
LOG_FILE="./logs/storage.log"

# NOTE: Never hardcode credentials in scripts.
# Set this environment variable before running:
# export AZURE_CONNECTION_STRING="your-connection-string"
CONNECTION_STRING="${AZURE_CONNECTION_STRING}"

# ── Logging Function ─────────────────────────────────────────
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# ── Validate Connection String ───────────────────────────────
if [ -z "$CONNECTION_STRING" ]; then
    echo "❌ Error: AZURE_CONNECTION_STRING environment variable is not set."
    echo "Run: export AZURE_CONNECTION_STRING='your-connection-string'"
    exit 1
fi

# ── Help Menu ────────────────────────────────────────────────
show_help() {
    echo ""
    echo "╔══════════════════════════════════════════════╗"
    echo "║     Cloud File Storage CLI — Azure Blob      ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    echo "Usage: ./storage.sh [command] [arguments]"
    echo ""
    echo "Commands:"
    echo "  upload   <file>           Upload a file to storage"
    echo "  download <blob> <dest>    Download a file from storage"
    echo "  list                      List all files in storage"
    echo "  delete   <blob>           Delete a file from storage"
    echo "  url      <blob>           Get public URL of a file"
    echo "  help                      Show this help menu"
    echo ""
}

# ── Upload ───────────────────────────────────────────────────
upload_file() {
    if [ -z "$1" ]; then
        echo "❌ Error: Please provide a file path"
        echo "Usage: ./storage.sh upload <file>"
        exit 1
    fi

    FILE_PATH="$1"
    BLOB_NAME=$(basename "$FILE_PATH")

    if [ ! -f "$FILE_PATH" ]; then
        echo "❌ Error: File '$FILE_PATH' not found"
        exit 1
    fi

    echo "⬆️  Uploading '$BLOB_NAME' to Azure Blob Storage..."
    log "UPLOAD STARTED: $BLOB_NAME"

    az storage blob upload \
        --connection-string "$CONNECTION_STRING" \
        --container-name "$CONTAINER_NAME" \
        --file "$FILE_PATH" \
        --name "$BLOB_NAME" \
        --overwrite

    if [ $? -eq 0 ]; then
        echo "✅ Upload successful!"
        echo "🌐 Public URL: https://${STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER_NAME}/${BLOB_NAME}"
        log "UPLOAD SUCCESS: $BLOB_NAME"
    else
        echo "❌ Upload failed!"
        log "UPLOAD FAILED: $BLOB_NAME"
        exit 1
    fi
}

# ── Download ─────────────────────────────────────────────────
download_file() {
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "❌ Error: Please provide blob name and destination"
        echo "Usage: ./storage.sh download <blob-name> <destination>"
        exit 1
    fi

    BLOB_NAME="$1"
    DEST_PATH="$2"

    echo "⬇️  Downloading '$BLOB_NAME'..."
    log "DOWNLOAD STARTED: $BLOB_NAME"

    az storage blob download \
        --connection-string "$CONNECTION_STRING" \
        --container-name "$CONTAINER_NAME" \
        --name "$BLOB_NAME" \
        --file "$DEST_PATH"

    if [ $? -eq 0 ]; then
        echo "✅ Download successful! Saved to: $DEST_PATH"
        log "DOWNLOAD SUCCESS: $BLOB_NAME -> $DEST_PATH"
    else
        echo "❌ Download failed!"
        log "DOWNLOAD FAILED: $BLOB_NAME"
        exit 1
    fi
}

# ── List ─────────────────────────────────────────────────────
list_files() {
    echo "📋 Listing all files in storage..."
    log "LIST: Fetching all blobs"

    az storage blob list \
        --connection-string "$CONNECTION_STRING" \
        --container-name "$CONTAINER_NAME" \
        --output table

    log "LIST: Complete"
}

# ── Delete ───────────────────────────────────────────────────
delete_file() {
    if [ -z "$1" ]; then
        echo "❌ Error: Please provide a blob name"
        echo "Usage: ./storage.sh delete <blob-name>"
        exit 1
    fi

    BLOB_NAME="$1"

    echo "🗑️  Deleting '$BLOB_NAME'..."
    log "DELETE STARTED: $BLOB_NAME"

    az storage blob delete \
        --connection-string "$CONNECTION_STRING" \
        --container-name "$CONTAINER_NAME" \
        --name "$BLOB_NAME"

    if [ $? -eq 0 ]; then
        echo "✅ Deleted successfully!"
        log "DELETE SUCCESS: $BLOB_NAME"
    else
        echo "❌ Delete failed!"
        log "DELETE FAILED: $BLOB_NAME"
        exit 1
    fi
}

# ── Get Public URL ───────────────────────────────────────────
get_url() {
    if [ -z "$1" ]; then
        echo "❌ Error: Please provide a blob name"
        echo "Usage: ./storage.sh url <blob-name>"
        exit 1
    fi

    BLOB_NAME="$1"
    URL="https://${STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER_NAME}/${BLOB_NAME}"
    echo "🌐 Public URL: $URL"
    log "URL GENERATED: $URL"
}

# ── Main Router ──────────────────────────────────────────────
case "$1" in
    upload)   upload_file "$2" ;;
    download) download_file "$2" "$3" ;;
    list)     list_files ;;
    delete)   delete_file "$2" ;;
    url)      get_url "$2" ;;
    help|*)   show_help ;;
esac