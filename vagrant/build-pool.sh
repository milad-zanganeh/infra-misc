#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <pool_name>"
    exit 1
fi
POOL_NAME="$1"
sudo mkdir -p /var/lib/libvirt/images/vagrant_pool
sudo virsh pool-define-as $POOL_NAME dir --target /var/lib/libvirt/images/$POOL_NAME
sudo virsh pool-build $POOL_NAME
sudo virsh pool-start $POOL_NAME
sudo virsh pool-autostart vagrant_pool

virsh pool-list --all  

