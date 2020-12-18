%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Inventory dynamic


Documentation : 

https://docs.ansible.com/ansible/latest/plugins/inventory.html
https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html

https://github.com/ansible-collections/community.general/tree/main/scripts/inventory


<br>

* ansible.cfg

```
[inventory]
# enable inventory plugins, default: 'host_list', 'script', 'auto', 'yaml', 'ini', 'toml'
#enable_plugins = host_list, virtualbox, yaml, constructed
```


* fichier d'inventaire

```
plugin: nmap
strict: false
address: 192.168.1.0/24
```

```
ansible-inventory -i nmap.yml --list
ansible -i nmap.yml all -m ping
```
