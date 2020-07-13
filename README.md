## Packer templates
**Packer templates fully tested on real infrastructure**

### CentOS 8 template `cd ./centos-8`
Build Packer template with VMware vSphere or VMware ESXi.
Required ESXi 6.7+

VM configuration:  
* VM name: 'packer-centos-8'
* VM hardware version 14 (ESXi 6.7 +)
* 1 CPU core, 2048 MB RAM, 8192 MB video RAM, 10240 MB disk with thin provision
* Boot EFI secure boot


VM install from CentOS official iso with kickstart config placed in `./http`:
* 'Server' installation profile
* Hostname is 'centos8.localdomain'
* Root password is 'packer'
* Create user 'packer' with password 'packer'
* SElinux set to 'permissive' mode
* Firewalld is disabled
* Disk partition layout: || /boot/efi - 200 MiB esp | / - 10038 MiB xfs ||  

Build:
You must setting up your vSphere or ESXi settings in `vars.json`
Then execute:

    packer build -only=vsphere-iso -force -var-file vars.json -var 'vsphere_password=PASSWORD' -var 'host_password=PASSWORD' centos-8.json
