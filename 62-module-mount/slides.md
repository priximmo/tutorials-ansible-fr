%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Module Mount


<br>

Documentation : https://docs.ansible.com/ansible/latest/collections/ansible/posix/mount_module.html

Objectif : Monter des volumes > édition fstab

<br>

PARAMETRES

<br>

* backup : création d'un backup avant édition

<br>

* boot : montage au boot

<br>

* dump : enclenchement ou non du système de sauvegarde dump

<br>

* fstab : fichier utilisé si différent /etc/fstab

<br>

* fstype : type de filesystem

<br>

* path : destination du montage

<br>

* src : répertoire source (ou serveur avec son path)

<br>

* mount : absent / mounted / present / remounted / unmounted

--------------------------------------------------------------------------------------------------------------

# ANSIBLE : Module Mount


<br>

* exemple avec un serveur nfs

CREATION DU SERVEUR


<br>

* création d'un rôle nfs_server

<br>

* installation des paquets pour Debian

```
- name: Ensure NFS utilities are installed
  apt:
    name: nfs-common,nfs-kernel-server
    state: present
    update_cache: yes
    cache_valid_time: 3600
```

<br>

* création des répertoires

```
- name: Ensure directories to export exist
  file:  
    path: "/exports/{{ item }}"
    state: directory
  with_items: "{{ nfs_server_dir_data }}"
```

--------------------------------------------------------------------------------------------------------------

# ANSIBLE : Module Mount

<br>

* configuration des volumes mis à disposition

```
- name: Copy exports file.
  template:
    src: exports.j2
    dest: /etc/exports
    owner: root
    group: root
    mode: 0644
  notify: __reload_nfs
```

<br>

* default vars

```
nfs_server_dir_data:
  - "wp_database"
  - "wp_statics"
```

<br>

* contenu du fichier template

```
# edited by ansible
{% for export in nfs_server_dir_data %}
/exports/{{ export }} 192.168.15.0/24(rw,sync,no_root_squash)
{% endfor %}
```

--------------------------------------------------------------------------------------------------------------

# ANSIBLE : Module Mount

<br>

* inventory 

```
all:
  children:
    docker:
      children:
        managers:
          hosts:
            192.168.15.10:
            192.168.15.11:
            192.168.15.12:
        workers:
          hosts:
            192.168.15.13:
            192.168.15.14:
    nfs_server:
      hosts:
        192.168.15.15:
```

--------------------------------------------------------------------------------------------------------------

# ANSIBLE : Module Mount

<br>

* modification du playbook

```
- name: install nfs_server
  hosts: nfs_server
  become: yes
  roles:
  - nfs_server
  tags:
  - nfs_server

- name: install swarm cluster
  hosts: docker
  become: yes
  roles:
  - nfs_client
  - docker
  - swarm
  - tooling
  tags:
  - docker
```

--------------------------------------------------------------------------------------------------------------

# ANSIBLE : Module Mount

<br>

INSTALLATION DES CLIENTS NFS


<br>

* création du rôle nfs_client

<br>

* installation du paquet nfs-common

```
- name: Ensure nfs-common installed
  apt:
    name: nfs-common
    state: present
    update_cache: yes
    cache_valid_time: 3600
```

<br>

* création des répertoires

```
- name: ensure directories exists
  file:
    path: "/mnt/{{ item }}"
    state: directory
  with_items: "{{ nfs_server_dir_data }}"
```

--------------------------------------------------------------------------------------------------------------

# ANSIBLE : Module Mount

<br>

* montage finale via le module mount

```
- name: Mount an NFS volume
  mount:
    src: "{{ groups['nfs_server'][0] }}:/exports/{{ item }}"
    path: /mnt/{{ item }}
    opts: rw
    state: mounted
    fstype: nfs
  with_items: "{{ nfs_server_dir_data }}"
```

Attention : nfs_server_dir_data > variable de groupe pour partager cette variable entre client et serveur
