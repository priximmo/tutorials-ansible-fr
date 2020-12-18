%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : module docker_swarm & docker_node-> drain, remove, manipulation

<br>

Documentation : 
https://docs.ansible.com/ansible/2.9/modules/docker_node_module.html#docker-node-module
https://docs.ansible.com/ansible/2.9/modules/docker_swarm_module.html#docker-swarm-module

<br>

PARAMETRES

<br>

* availability : active / pause / drain
		* active : le noeud peut recevoir des services
		* pause : conserve ses services mais n'en prend pas de nouveau
		* drain : vide le noeud

<br>

* docker_host : socket unix/tcp/ssh

<br>

* hostname : nom du noeud ou DI

<br>

* labels : attributs complémentaires aux noeuds k/v

<br>

* labels_replace : merge/replace

<br>

* labels_to_remove : suppression

<br>

* role : manager/worker

------------------------------------------------------------------------------------------------------

# ANSIBLE : module docker_swarm & docker_node-> drain, remove, manipulation


<br>

* astuce travail sur le hostname plutôt que le inventory_name

```
  vars:
    nodeList: []
```

```
- name: fact
  set_fact:     
    nodeList: "{{ [ hostvars[item]['ansible_hostname'] ] + nodeList }}"
  with_items: "{{ groups['all'] }}"
  when: inventory_hostname in groups['managers'][0]
```

<br>

* exemple afficage des machines à nombre paire dans le hostname

```
- name: print
  debug:
    msg: "{{ item }}"
  when: inventory_hostname in groups['managers'][0] and item | regex_replace('^ans.*([0-9]+)$', '\\1') | int is divisibleby 2
  with_items: "{{ nodeList }}"
```

------------------------------------------------------------------------------------------------------

# ANSIBLE : module docker_swarm & docker_node-> drain, remove, manipulation


<br>

* drain des noeuds

```
- name: drain node
  docker_node:
    hostname: "{{ item }}"
    availability: drain
  when: inventory_hostname in groups['managers'][0] and item | regex_replace('^ans.*([0-9]+)$', '\\1') | int is divisibleby 2
  with_items: "{{ nodeList }}"
```

<br>

* changement de rôle pour les hostnames impaires

```
- name: change role 
  docker_node:
    hostname: "{{ item }}"
    role: worker
  when: inventory_hostname in groups['managers'][0] and item | regex_replace('^ans.*([0-9]+)$', '\\1') | int is divisibleby 2
  with_items: "{{ nodeList }}"
```

------------------------------------------------------------------------------------------------------

# ANSIBLE : module docker_swarm & docker_node-> drain, remove, manipulation


<br>

* suppression des noeuds du cluster

```
- name: stop node 
  docker_swarm:
    state: absent
    force: true
  when: ansible_hostname | regex_replace('^ans.*([0-9]+)$', '\\1') | int is divisibleby 2
```

<br>

* inspect du cluster

```
- name: Inspect swarm
  docker_swarm:
    state: inspect
  register: __swarm_info
- name: print swarm infos
  debug:
    var: __swarm_info
```
