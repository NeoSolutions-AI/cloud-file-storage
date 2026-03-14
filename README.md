# ☁️ Cloud File Storage System

A command-line cloud storage system built with **Azure Blob Storage** and **Bash scripting** — similar to Dropbox or Google Drive, operated entirely from the terminal.

---

## 🏗️ Architecture
```
User Terminal
      │
      ▼
storage.sh (Bash CLI)
      │
      ▼
Azure CLI
      │
      ▼
Azure Blob Storage (mitailive)
      │
      ▼
Container: files (Public Access)
```

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| Cloud Storage | Azure Blob Storage |
| CLI Tool | Bash Script |
| Automation | Azure CLI |
| CI/CD | GitHub Actions |
| Logging | Bash + tee |

---

## 📁 Project Structure
```
cloud-file-storage/
├── storage.sh              # Main CLI tool
├── deploy.sh               # Deployment automation script
├── .github/
│   └── workflows/
│       └── deploy.yml      # GitHub Actions CI/CD
├── logs/
│   └── storage.log         # Activity log (BONUS)
└── README.md
```

---

## 🚀 How to Use

### Prerequisites
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- Azure account with active subscription

### Setup
```bash
# Clone the repo
git clone https://github.com/NeoSolutions-AI/cloud-file-storage.git
cd cloud-file-storage

# Make scripts executable
chmod +x storage.sh deploy.sh

# Run full deployment
./deploy.sh
```

### Commands
```bash
# Upload a file
./storage.sh upload myfile.txt

# List all files
./storage.sh list

# Download a file
./storage.sh download myfile.txt ./downloads/myfile.txt

# Delete a file
./storage.sh delete myfile.txt

# Get public URL
./storage.sh url myfile.txt

# Show help
./storage.sh help
```

---

## ☁️ Azure Resources

| Resource | Name |
|----------|------|
| Storage Account | mitailive |
| Resource Group | mitailive-rg |
| Container | files |
| Region | East US |
| Access | Public |

---

## 📋 Logging (BONUS)

All operations are automatically logged to `logs/storage.log`:
```
[2026-03-14 17:30:00] UPLOAD SUCCESS: report.pdf
[2026-03-14 17:31:00] LIST: Fetching all blobs
[2026-03-14 17:32:00] DOWNLOAD SUCCESS: report.pdf -> ./report.pdf
[2026-03-14 17:33:00] DELETE SUCCESS: report.pdf
```

---

## ⚙️ CI/CD Pipeline (BONUS)

The GitHub Actions pipeline in `.github/workflows/deploy.yml` automatically runs on every push to `main`:

1. ✅ Installs Azure CLI
2. 🔐 Logs into Azure using service principal secrets
3. 📁 Creates the storage container if it doesn't exist
4. ⬆️ Uploads a test file to verify deployment
5. ✅ Confirms successful deployment

### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AZURE_CLIENT_ID` | Service principal app ID |
| `AZURE_CLIENT_SECRET` | Service principal password |
| `AZURE_TENANT_ID` | Azure tenant ID |
| `AZURE_STORAGE_KEY` | Storage account access key |

---

## 👤 Author

**Mitaire Oteri** — Techcrush Cloud Computing & DevOps Bootcamp