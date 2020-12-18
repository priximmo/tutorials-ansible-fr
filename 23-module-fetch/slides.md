%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Module FETCH


Documentation: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/fetch_module.html

Objectifs : récupération de fichiers des machines target
Equivalent ? scp


<br>

PARAMETRES :

<br>

* dest : destination du fichier récupérer (sur la machine ansible)

<br>

* fail_on_missing : erreur si le fichier manque (défaut yes)

<br>

* flat : écraser/force la destination (attention si plusieurs hosts)

<br>

* src: fichier récupéré de la machine target

<br>

* validate_checksum : validation de la récupération via la checksum

----------------------------------------------------------------------------

# ANSIBLE : Module FETCH


<br>

* exemple simple si copie vers \/

```
  - name: fetch
    fetch:
      src: /etc/hosts
      dest: tmp/
```

<br>

* avec une destination précise (attention sans flat)

```
  - name: fetch
    fetch:
      src: /etc/hosts
      dest: tmp/hosts_{{ ansible_hostname }}.txt
```

<br>

* avec le flat

```
  - name: fetch
    fetch:
      src: /etc/hosts
      dest: tmp/hosts_{{ ansible_hostname }}.txt
      flat: yes
```

----------------------------------------------------------------------------

# ANSIBLE : Module FETCH


<br>

* exemple simple : collecter les fichiers et les mettre à dispo avec nginx

```
- name: preparation local
  connection: local
  hosts: localhost
  become: yes
  tasks:
  - name: install nginx
    apt:
      name: nginx
      state: present
  - name: clean
    file:
      path: "{{ item }}"
      state: absent
    with_fileglob:
    - /var/www/html/*.html
- name: on découvre copy
  hosts: all
  tasks:
  - name: fetch
    fetch:
      src: /etc/hosts
      dest: /var/www/html/hosts_{{ ansible_hostname }}.txt
      flat: yes
```

conf nginx :

```
  autoindex on;
  autoindex_exact_size off;
```
