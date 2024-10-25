Description
--- 
This is vagrant project configured to work with vmware workstation (vmware_desktop), the project aims to replicate a working kubeneets cluster locally.
The project takes sometime to run, after that you will find a generated file called `hostkubeConfig.yaml` once the install is completed.
Also you will find two batch files, the `route_command.bat`  add a route from your local machine to the created subnet, `192.168.30.10`, the other file will delete the route.

CONFIG
---
- 1 master node
- 2 nodes

default values:
IP subnet: "192.168.30.10"
admin name: ADMIN_NAME # the certs will be named after him and the kubeconfig context also

RUN
--
```language=shell
vagrant up
```

FORCE DESTRY AND RUN
---
```
vagrant destroy -f && vagrant up
```

Notes about windows config
---
if you are using windows, a network route is required to link local widows network with the create subnet
execute `route delete 192.168.30.0` as administrator