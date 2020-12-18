%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Module Add_host & docker & module raw


<br>

Documentation : https://docs.ansible.com/ansible/latest/collections/ansible/builtin/add_host_module.html


Objectif : refaire le script de la vidéo 14 avec ansible

<br>

PARAMETRES

<br>

* groups : group alimenté

<br>

* hostname : nom de la machine (définition des variables standards, port...)
		dont ansible_connection > docker
<br>

* name : nom de la machine dans l'inventory

<br>

* connexion local + clef ssh pub dans une variable

```
- name: create docker containers
  hosts: localhost
  connection: local
  become: yes
  vars:
    sshkey_source: "{{ lookup('file', '/home/oki/.ssh/id_rsa.pub') }}"
  tasks:

  - name: install docker for python3
    apt:
      name: python3-docker
      state: present
```

---------------------------------------------------------------------------------------------

# ANSIBLE : Module Add_host & docker & module raw


<br>

* création des conteneurs

```
  - name: create containers
    docker_container:
      name: "c{{ item }}"
      hostname: "c{{ item }}"
      image: priximmo/buster-systemd-ssh
      privileged: yes
      published_ports: all
      volumes:
      - /srv/data:/srv/html
      - /sys/fs/cgroup:/sys/fs/cgroup:ro
    with_sequence: count=5
    register: __output_containers
```

<br>

* ajout des conteneurs dans l'inventaire au groupe docker

```
  - name: add hosts to docker group
    add_host:
      groups: docker
      ansible_connection: docker
      name: "c{{ item }}"
    with_sequence: count=5
```

---------------------------------------------------------------------------------------------

# ANSIBLE : Module Add_host & docker & module raw

<br>

* création d'user dans le conteneur

```
  - name: run command in container 
    raw: useradd -m -p sa3tHJ3/KuYvI --shell /bin/bash {{ lookup('env', 'USER') }}
    failed_when: false
    delegate_to: "{{ item }}"
    with_items: "{{ groups['docker'] }}"
```

<br>

* ajustement

```  
  - name: create ssh directory
    raw: |
      mkdir -p  {{ lookup('env', 'HOME') }}/.ssh
      chmod 700 {{ lookup('env', 'HOME') }}/.ssh
      chown {{ lookup('env', 'USER') }}:{{ lookup('env', 'USER') }} {{ lookup('env', 'HOME') }}/.ssh
      echo '{{ lookup('env', 'USER') }}   ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers
      echo '{{ sshkey_source }}' >{{ lookup('env', 'HOME') }}/.ssh/authorized_keys
      service ssh start
    delegate_to: "{{ item }}"
    with_items: "{{ groups['docker'] }}"
```

---------------------------------------------------------------------------------------------

# ANSIBLE : Module Add_host & docker & module raw

<br>

* éventuellement collecte des ip

```  
  - name: collecte ips
    docker_container_info:
      name: '{{ item }}'
    register: __container_infos
    with_items: "{{ groups['docker'] }}"
  - name: print
    debug:
      msg: "{{ item.container.NetworkSettings.Networks.bridge.IPAddress }}"
    with_items:
    - "{{ __container_infos.results }}"
```
