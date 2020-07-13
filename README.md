## Packer templates
**Packer templates fully tested on real infrastructure**

### CentOS 8 template

    cd ./centos-8
    packer build -only=vsphere-iso -var-file vars.json -var 'vsphere_password=PASSWORD' centos-8.json
