%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP ELK ET MONITORING - ELASTICSEARCH

<br>

Documentation : https://galaxy.ansible.com/elastic/elasticsearch

Dépôt : https://github.com/elastic/ansible-elasticsearch

Objectifs : Elargir notre stack monitoring et logging + callback logstash à venir


<br>

* Stack vagrant :

```
	* 1 elasticsearch + logstash + kibana
	* 1 elasticsearch + logstash
```

Cf : fichier joint

----------------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - ELASTICSEARCH


<br>

* préparation de l'inventaire

```
all:
  children:
    elastic:
      hosts:
        node1:
          ansible_host: 192.168.13.10
        node2:
          ansible_host: 192.168.13.11
    kibana:
      hosts:
        node1:
          ansible_host: 192.168.13.10
```

----------------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - ELASTICSEARCH

<br>

* installation du rôle de la communauté

```
mkdir -p roles group_vars host_vars
ansible-galaxy install elastic.elasticsearch,v7.10.2 -p roles
```

ou fichier requirements

```
- name: elasticsearch
  src: elastic.elasticsearch
  version: 7.10.2
```

Rq : avec vagrant commenter du wait dans le main.yml (interface)

----------------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - ELASTICSEARCH


<br>

* variables pour ce rôle

```
    es_heap_size: "1g"
    es_config:
      cluster.name: "xavki_es"
      network.host: "{{ ansible_host }}"
      cluster.initial_master_nodes: "node1"
      discovery.zen.ping.unicast.hosts: "node1,node2"
      http.port: 9200
      node.master: true
      node.data: true
```

----------------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - ELASTICSEARCH

<br>

* définition du playbook

```
- name: install eS
  become: yes
  user: vagrant
  hosts: elastic
  roles:
    - elasticsearch
```


