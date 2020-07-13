#!/bin/bash -eux

export VM_USERNAME='packer'

# Enable time sync
sed -i 's/server.*iburst/pool\ 2.centos.pool.ntp.org\ iburst/g' /etc/chrony.conf
systemctl enable --now chronyd

# Group with passwordless sudo enabled
groupadd all-sudoers
echo "%all-sudoers ALL=(ALL:ALL) NOPASSWD:ALL" | tee -a /etc/sudoers.d/all-sudoers
chmod 440 /etc/sudoers.d/all-sudoers
usermod -aG all-sudoers $VM_USERNAME

# Add ssh key
mkdir -p /home/$VM_USERNAME/.ssh
touch /home/$VM_USERNAME/.ssh/authorized_keys
echo 'SSH_KEY_PUB' >> /home/$VM_USERNAME/.ssh/authorized_keys
chmod -R go= /home/$VM_USERNAME/.ssh
chown -R $VM_USERNAME:$VM_USERNAME /home/$VM_USERNAME/.ssh

# Disable login with password for SSH
sed -i 's/PasswordAuthentication\ yes/PasswordAuthentication\ no/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin\ yes/PermitRootLogin\ no/g' /etc/ssh/sshd_config
sed -i 's/UsePAM\ yes/UsePAM\ no/g' /etc/ssh/sshd_config

# Setting up security updates
tee -a /etc/dnf/automatic.conf << EOF
[commands]
upgrade_type = security
random_sleep = 0
download_updates = yes
apply_updates = yes
[emitters]
emit_via = stdio
[email]
email_from = root@myserver.example.com
email_to = root
email_host = localhost
[base]
debuglevel = 1
EOF

# Install some packets
dnf install -y epel-release
dnf config-manager --set-enabled PowerTools
dnf update
dnf install -y htop mc ncdu net-tools dnf-automatic nano vim
