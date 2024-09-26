#!/bin/bash

# Step 1: Backup the existing repository file
REPO_FILE="/etc/yum.repos.d/CentOS-Base.repo"
BACKUP_FILE="${REPO_FILE}-backup"

echo "Backing up the current CentOS repo file..."
if [ -f "$REPO_FILE" ]; then
    cp -v "$REPO_FILE" "$BACKUP_FILE"
    echo "Backup created at $BACKUP_FILE"
else
    echo "Repository file not found. Exiting."
    exit 1
fi

# Step 2: Update the CentOS repo file with the new configuration
echo "Updating the CentOS repo file with the new configuration..."

cat << EOF > "$REPO_FILE"
[base]
name=CentOS-\$releasever - Base
baseurl=https://vault.centos.org/7.9.2009/os/\$basearch
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

# released updates
[updates]
name=CentOS-\$releasever - Updates
baseurl=https://vault.centos.org/7.9.2009/updates/\$basearch
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

# additional packages that may be useful
[extras]
name=CentOS-\$releasever - Extras
baseurl=https://vault.centos.org/7.9.2009/extras/\$basearch
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7

# additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-\$releasever - Plus
baseurl=https://vault.centos.org/7.9.2009/centosplus/\$basearch
gpgcheck=1
enabled=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
EOF

echo "Repository file updated."

# Step 3: Clean the yum cache and regenerate it
echo "Cleaning yum cache and regenerating..."
yum clean all && yum makecache

echo "Process completed successfully."
