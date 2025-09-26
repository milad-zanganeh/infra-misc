#!/bin/bash

if [ -z "$SSH_USER" ] || [ -z "$SSH_PASS" ]; then
    echo "Missing SSH_USER or SSH_PASS environment variable."
    exit 1
fi

useradd -m -s /usr/sbin/nologin "$SSH_USER"
echo "$SSH_USER:$SSH_PASS" | chpasswd

echo "AllowUsers $SSH_USER" >> /etc/ssh/sshd_config

exec /usr/sbin/sshd -D

