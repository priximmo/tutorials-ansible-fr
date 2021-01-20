%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : AWS - Projets & Key Pairs

<br>

OBJECTIFS : 

* découvrir  des modules aws

* monter un blog wordpress

* en simplifiant les choses pour la pédagogie

* architecture


```
       |
       |
       |      +-------------------------+       +-------------------------+
       |      |  Worpdress              |       |                         |
+------------->  apache + php + code wp +------->        MariaDB          |
       |      +-------------------------+       +-------------------------+
       |
       |
       |
```


<br>

* Pré-Requis : boto & boto3

```
sudo apt python3-pip
pip3 install boto boto3 --user
```

Rq : boto n'est pas utilisable sur toutes les régions

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Projets & Key Pairs


<br>

* Key Pairs = clefs SSH (générée ou importée)

* Security Group = règles firewall (entrées/sorties)

<br>

* Gestion des crédentials

```
mkdir -p group_vars/all/
vim group_vars/all/all.yml
```

```
ec2_access_key: "{{ vault_ec2_access_key }}"
ec2_secret_key: "{{ vault_ec2_secret_key }}"
ec2_region: "eu-west-1"
```

<br>

* chiffrement avec ansible-vault :

```
vim group_vars/all/vault.yml
```

```
vault_ec2_access_key: <valeur_id_key>
vault_ec2_secret_key: <valeur_secret_key>
```

```
ansible-vault encrypt group_vars/all/vault.yml
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Projets & Key Pairs

<br>

* les variables

```
ec2_access_key: "{{ vault_ec2_access_key }}"
ec2_secret_key: "{{ vault_ec2_secret_key }}"

key_name: my_ssh_key
region: eu-west-1
image: ami-0aef57767f5404a3c 
id_wordpress: wp_wordpress
id_mariadb: wp_mariadb
sec_group_wordpress: ssh-sg-wordpress
sec_group_mariadb: ssh-sg-mariadb
vpc_id: vpc-0234e77b

mysql_db: "wordpress"
mysql_user: "xavki"
mysql_password: "password"
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Projets & Key Pairs

<br>

* modules aws :  ansible en local > api AWS

<br>

* exemple :

```
- hosts: localhost
  connection: local
  tasks:
  - name: list instances
    ec2_instance_info:
      aws_access_key: "{{ ec2_access_key }}"
      aws_secret_key: "{{ ec2_secret_key }}"
      region: "{{ region }}"
    register: __ec2_info
```

Note : https://docs.ansible.com/ansible/latest/collections/community/aws/ec2_instance_info_module.html

<br>

* utilisation de la variable

```
  - name: Instances ID
    debug:
      msg: "ID: {{ item.instance_id }} - State: {{ item.state.name }} - Public DNS: {{ item.public_dns_name }}"
    loop: "{{ __ec2_info.instances }}"
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Projets & Key Pairs

<br>

* module des key pairs (crée, supprimée, importée ou générée et récupération via register)

```
  - name: Upload public key to AWS
    ec2_key:
      name: "{{ key_name }}"
      key_material: "{{ lookup('file', '/home/oki/.ssh/id_rsa.pub') }}"
      region: "{{ region }}"
      aws_access_key: "{{ ec2_access_key }}"
      aws_secret_key: "{{ ec2_secret_key }}"
```

Note : https://docs.ansible.com/ansible/latest/collections/amazon/aws/ec2_key_module.html
