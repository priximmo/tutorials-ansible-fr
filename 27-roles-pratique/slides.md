%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Les ROLES - en pratique


<br>

Documentation : https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html


<br>

STRUCTURE :
<br>

* arborescence de répertoires et fichiers yaml
		* tasks : les actions et le point d'entrée
		* defaults : les variables par défaut
		* vars : les variables de rôle
		* handlers : les déclencheurs
		* templates : les fichiers jinja
		* files : les fichiers à copier ou fichiers statiques
		* meta : pour partager sur galaxya et inclure les dépendances
		* test : éléments de test
		* library : modules spécifiques au rôle

```
ansible-galaxy init roles/user
```

------------------------------------------------------------------------------------------------

# ANSIBLE : LES ROLES


<br>

* arborescence type 

```
├── 00_inventory.yml
├── group_vars
├── host_vars
├── playbook.yml
└── roles
    └── users
        ├── defaults
        │   └── main.yml
        ├── files
        ├── handlers
        │   └── main.yml
        ├── meta
        │   └── main.yml
        ├── README.md
        ├── tasks
        │   └── main.yml
        ├── templates
        ├── tests
        │   ├── inventory
        │   └── test.yml
        └── vars
            └── main.yml

```

------------------------------------------------------------------------------------------------

# ANSIBLE : LES ROLES

<br>

* 3 rôles :
		* ssh_keygen : génération de la clef en local (pb become yes)
		* users : création des users et déploiement des clefs
		* nginx : installation d'un reverse proxy

<br>

* ROLE SSH_KEYGEN : génération d'une clef

```
- name: mon premier playbook
  hosts: localhost
  connection: local
  roles:
  - ssh_keygen
```

```
  - name: generate SSH key"
    openssh_keypair:
      path: /tmp/xavki
      type: rsa
      size: 4096
      state: present
      force: no
```

------------------------------------------------------------------------------------------------

# ANSIBLE : LES ROLES


<br>

* ROLE USERS : création d'un user et ajout de la clef ssh

```
  - name: création du user devops
    user:
      name: devops
      shell: /bin/bash
      groups: sudo
      append: yes
      password: "{{ 'password' | password_hash('sha512') }}"
    become: yes
  - name: Add devops user to the sudoers
    copy:
      dest: "/etc/sudoers.d/devops"
      content: "devops  ALL=(ALL)  NOPASSWD: ALL"
    become: yes
  - name: Deploy SSH Key
    authorized_key: 
      user: devops
      key: "{{ lookup('file', '/tmp/xavki.pub') }}"
      state: present
    become: yes
```


------------------------------------------------------------------------------------------------

# ANSIBLE : LES ROLES


<br>

* ROLE NGINX : installation du serveur nginx

```
  - name: install nginx
    apt:
      name: nginx,curl
      state: present
      cache_valid_time: 3600
      update_cache: yes
  - name: remove default file
    file:
      path: "{{ item }}"
      state: absent
    with_items:
    - "/etc/nginx/sites-available/default"
    - "/etc/nginx/sites-enabled/default"
  - name: install vhost
    template:
      src: default_vhost.conf.j2
      dest: /etc/nginx/sites-available/default_vhost.conf
      owner: root
      group: root
      mode: 0644
    notify: reload_nginx
  - name: Flush handlers
    meta: flush_handlers

```

------------------------------------------------------------------------------------------------

# ANSIBLE : LES ROLES


<br>

* ROLE NGINX : start

```
  - name: start nginx
    systemd:
      name: nginx
      state: started
```

* handlers

```
  - name: reload_nginx
    systemd:
      name: nginx
      state: reloaded
```

------------------------------------------------------------------------------------------------

# ANSIBLE : LES ROLES


<br>

* le playbook

```
- name: utilisation des rôles
  hosts: all
  become: yes
  vars:
    nginx_port: 8888
  roles: 
  - users
  - nginx
````
