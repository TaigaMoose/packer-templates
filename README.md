## Packer templates

### CentOS 8 template

    cd ./centos-8
    packer build -only=vsphere-iso -var-file vars.json -var 'vsphere_password=PASSWORD' centos-8.json
