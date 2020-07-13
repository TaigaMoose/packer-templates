#!/bin/bash -eux

# Enable time sync
sed -i 's/server.*iburst/pool\ 2.centos.pool.ntp.org\ iburst/g' /etc/chrony.conf
systemctl enable --now chronyd

# Sudo без пароля для пользователя
groupadd all-sudoers
echo "%all-sudoers ALL=(ALL:ALL) NOPASSWD:ALL" | tee -a /etc/sudoers.d/all-sudoers
chmod 440 /etc/sudoers.d/all-sudoers
usermod -aG all-sudoers packer

# Добавление ssh ключей
mkdir -p /home/packer/.ssh
touch /home/packer/.ssh/authorized_keys
echo 'SSH_KEY_PUB' >> /home/packer/.ssh/authorized_keys
chmod -R go= /home/packer/.ssh
chown -R packer:packer /home/packer/.ssh

# Отключение использования пароля для SSH
sed -i 's/PasswordAuthentication\ yes/PasswordAuthentication\ no/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin\ yes/PermitRootLogin\ no/g' /etc/ssh/sshd_config
sed -i 's/UsePAM\ yes/UsePAM\ no/g' /etc/ssh/sshd_config

# Настройка автоматического обновления системы
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

#Установка пакетов
dnf install -y epel-release
dnf config-manager --set-enabled PowerTools
dnf update
dnf install -y htop mc ncdu net-tools dnf-automatic nano vim
