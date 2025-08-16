# Debian Vagrant Setup with KVM

This repository contains a Vagrant configuration for creating a Debian Bookworm (12) virtual machine using KVM (Kernel-based Virtual Machine).

## Prerequisites

Before using this Vagrant setup, ensure you have the following installed:

- [Vagrant](https://www.vagrantup.com/downloads) (latest version)
- [KVM](https://help.ubuntu.com/community/KVM) and libvirt
- [Vagrant libvirt plugin](https://github.com/vagrant-libvirt/vagrant-libvirt)

## KVM Installation (Ubuntu/Debian)

### Install KVM and libvirt
```bash
# Update package list
sudo apt update

# Install KVM and libvirt
sudo apt install -y qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# Add your user to libvirt group
sudo usermod -a -G libvirt $USER

# Start and enable libvirt service
sudo systemctl start libvirtd
sudo systemctl enable libvirtd

# Log out and back in for group changes to take effect
```

### Install Vagrant libvirt plugin
```bash
vagrant plugin install vagrant-libvirt
```

## Quick Start

1. **Clone or download this repository**

2. **Start the virtual machine**
   ```bash
   vagrant up --provider=libvirt
   ```

3. **Connect to the VM**
   ```bash
   vagrant ssh
   ```

4. **Stop the VM when done**
   ```bash
   vagrant halt
   ```

## Configuration Details

### VM Specifications
- **OS**: Debian Bookworm (12) 64-bit
- **Memory**: 2GB RAM
- **CPU**: 2 cores
- **Hostname**: debian-vm
- **Private IP**: 192.168.122.10
- **Hypervisor**: KVM with libvirt


## Available Commands

| Command | Description |
|---------|-------------|
| `vagrant up --provider=libvirt` | Start and provision the VM with KVM |
| `vagrant ssh` | SSH into the running VM |
| `vagrant halt` | Gracefully stop the VM |
| `vagrant destroy` | Remove the VM completely |
| `vagrant reload` | Restart the VM |
| `vagrant status` | Check VM status |
| `vagrant box list` | List available boxes |
| `vagrant box update` | Update the Debian box |

## KVM Management

### List VMs
```bash
# Using virsh
virsh list --all

# Using Vagrant
vagrant status
```

### Access VM console
```bash
# Using virsh
virsh console debian-vagrant

# Using Vagrant
vagrant ssh
```

### Monitor VM resources
```bash
# Using virt-top
sudo virt-top

# Using virsh
virsh dominfo debian-vagrant
```

## Customization

### Memory and CPU
Edit the `Vagrantfile` to modify resource allocation:
```ruby
libvirt.memory = 4096  # 4GB RAM
libvirt.cpus = 4       # 4 CPU cores
```

### Graphics and Display
Enable GUI if needed:
```ruby
libvirt.graphics_type = "vnc"
libvirt.graphics_port = 5900
```

### Storage
Customize disk settings:
```ruby
libvirt.storage_pool_name = "default"
libvirt.disk_size = "20G"
```

### Network
Modify network configuration:
```ruby
libvirt.network_name = "custom-network"
config.vm.network "private_network", ip: "192.168.100.10"
```

## Troubleshooting

### Common Issues

1. **Permission denied errors**
   ```bash
   # Ensure user is in libvirt group
   sudo usermod -a -G libvirt $USER
   # Log out and back in
   ```

2. **KVM not available**
   ```bash
   # Check virtualization support
   egrep -c '(vmx|svm)' /proc/cpuinfo
   # Should return > 0
   
   # Check KVM module
   lsmod | grep kvm
   ```

3. **Network issues**
   ```bash
   # Check libvirt network
   virsh net-list --all
   virsh net-start default
   virsh net-autostart default
   ```

4. **Box download fails**
   ```bash
   vagrant box add debian/bookworm64 --provider=libvirt
   ```

5. **VM won't start**
   - Check libvirtd service status
   - Verify KVM modules are loaded
   - Check available disk space
   - Review libvirt logs: `sudo journalctl -u libvirtd`

### Performance Optimization

- **Enable nested virtualization** (if needed):
  ```bash
  # Check if nested virtualization is enabled
  cat /sys/module/kvm_intel/parameters/nested
  
  # Enable if supported
  echo "options kvm_intel nested=1" | sudo tee -a /etc/modprobe.d/kvm.conf
  ```

- **Use virtio drivers** (already configured in Vagrantfile)
- **Enable CPU pinning** for critical workloads

## License

This project is open source and available under the [MIT License](LICENSE). 