%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : AWS - Wait & Volumes

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

# ANSIBLE : AWS - Wait & Volumes


<br>
* constituer notre inventaire avec add_host (cf vidéo 58)

```
  - name: add wordpress instances to inventory
    add_host:
      hostname: '{{ item.public_dns_name }}'
      ansible_host: '{{ item.public_dns_name }}'
      groups:
      - wordpress
    loop: "{{ __wordpress_instances.tagged_instances }}"

  - name: add mariadb instances to inventory
    add_host:
      hostname: '{{ item.public_dns_name }}'
      ansible_host: '{{ item.public_dns_name }}'
      mariadb_private_ip: '{{ item.private_dns_name }}'
      groups:
      - mariadb
    loop: "{{ __mariadb_instances.tagged_instances }}"
```


-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Wait & Volumes


<br>

* attendre que les instances répondent avec wait_for

```
  - name: Wait for ssh to come up
    wait_for:
      host: '{{ item.public_dns_name }}'
      port: 22
      delay: 20
      timeout: 200
      state: started
    loop: "{{ __wordpress_instances.tagged_instances }}"

  - name: Wait for ssh to come up
    wait_for:
      host: '{{ item.public_dns_name }}'
      port: 22
      delay: 20
      timeout: 200
      state: started
    loop: "{{ __mariadb_instances.tagged_instances }}"
```


-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Wait & Volumes


<br>

* ajouter des volumes à nos instances avec ec2_vol

```
  - name: add volume to wordpresss instance
    ec2_vol:
      aws_access_key: "{{ ec2_access_key }}"
      aws_secret_key: "{{  ec2_secret_key }}"
      instance: "{{ item.id }}"
      region: "{{ region }}"
      volume_size: "10"
      volume_type: gp2
      device_name: /dev/xvdf
      delete_on_termination: yes
    loop: "{{ __wordpress_instances.tagged_instances }}"
    register: __ec2_volume_wordpress

  - name: add volume to mariadb instance
    ec2_vol:
      aws_access_key: "{{ ec2_access_key }}"
      aws_secret_key: "{{  ec2_secret_key }}"
      instance: "{{ item.id }}"
      region: "{{ region }}"
      volume_type: gp2
      volume_size: "20"
      device_name: /dev/xvdf
      delete_on_termination: yes
    loop: "{{ __mariadb_instances.tagged_instances }}"
```
