%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : AWS - Dynamic inventory

<br>

Objectif : Se passer d'un inventaire en se connectant à AWS

<br>

* Pré-Requis : boto & boto3

```
sudo apt python3-pip
pip3 install boto boto3 --user
```

Rq : boto n'est pas utilisable sur toutes les régions

<br>

* configuration ansible
		* /etc/ansible/ansible.cfg
		* ~/.ansible/ansible.cfg
		* ansible_dir/ansible.cfg

* utilisation du plugin

```
[defaults]
host_key_checking = False
[inventory]
enable_plugins = aws_ec2
```

Rq : https://docs.ansible.com/ansible/latest/plugins/plugins.html

-------------------------------------------------------------------

# ANSIBLE : AWS - Dynamic inventory

<br>

* utilisation du plugin
https://docs.ansible.com/ansible/latest/plugins/inventory.html

```
# demo.aws_ec2.yml
plugin: amazon.aws.aws_ec2
regions:
  - us-east-1
  - us-east-2
keyed_groups:
  # add hosts to tag_Name_value groups for each aws_ec2 host's tags.Name variable
  - key: tags.Name
    prefix: tag_Name_
    separator: ""
groups:
  # add hosts to the group development if any of the dictionary's keys or values is the word 'devel'
  development: "'devel' in (tags|list)"
compose:
  # set the ansible_host variable to connect with the private IP address without changing the hostname
  ansible_host: private_ip_address
```

Rq : si le host ne répond pas aux critères il n'est pas retenu dans l'inventaire

Attention : le nom du fichier doit toujours se finir par : xxx.aws_ec2.yml

-------------------------------------------------------------------

# ANSIBLE : AWS - Dynamic inventory

<br>

```
@all:
  |--@aws_ec2:
  |  |--ec2-12-345-678-901.compute-1.amazonaws.com
  |  |--ec2-98-765-432-10.compute-1.amazonaws.com
  |  |--...
  |--@development:
  |  |--ec2-12-345-678-901.compute-1.amazonaws.com
  |  |--ec2-98-765-432-10.compute-1.amazonaws.com
  |--@tag_Name_ECS_Instance:
  |  |--ec2-98-765-432-10.compute-1.amazonaws.com
  |--@tag_Name_Test_Server:
  |  |--ec2-12-345-678-901.compute-1.amazonaws.com
  |--@ungrouped
```

-------------------------------------------------------------------

# ANSIBLE : AWS - Dynamic inventory

<br>

* le plugin inventory peut utiliser le cache


```
plugin: amazon.aws.aws_ec2
cache: yes
cache_plugin: ansible.builtin.jsonfile
cache_timeout: 7200
cache_connection: /tmp/aws_inventory
cache_prefix: aws_ec2
```

Rq : différent de fact_caching

-------------------------------------------------------------------

# ANSIBLE : AWS - Dynamic inventory

<br>

```
---
plugin: aws_ec2
aws_access_key: AKIASBKEZI2BAAZERDSAY3TXBEDFDS               
aws_secret_key: lxFoMNvWrAhcxw+s8B3vrUxhCLRVyVeGFSDFyHzxdog32U
regions: 
  - eu-west-1
keyed_groups:
  - key: tags
    prefix: tag
  - prefix: instance_type
    key: instance_type
```

Rq : https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html#options

<br>

* vérification

```
ansible-inventory -i xavki_aws_ec2.yml --list
ansible-inventory -i xavki_aws_ec2.yml --graph
```
