%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Module - User


<br>

Doc : https://docs.ansible.com/ansible/latest/modules/user_module.html
Commande : ansible-doc user
Equivalence : useradd/adduser/userdel/deluser/luseradd

<br>

PARAMETRES :


<br>

* append : yes/no > en lien avec groups / ajout aux groupes ou changement

<br>

* comment : commentaire associé au user

<br>

* create_home : yes/no > création de la home ou pas

<br>

* expires : format epoch > date d'expiration

```
date "+%s" -d "10/06/2040 10:00:00"
```

<br>

* force : permet de forcer la suppression des fichier d'un user

<br>

* generate_ssh_key : génère en même temps une clef ssh à l'utilisateur

<br>

* group : définit le groupe principal de l'utilisateur

<br>

* groups : définit les groupes secondaires qui seront ajoutés

<br>

* home : définition de la home du user

<br>

* local : dans le cas d'une décentralisation de la gestion des users (forcer localement)

<br>

* move_home : pour déplacer une home existante

-----------------------------------------------------------------------------

# ANSIBLE : Module - User


<br>

* name : nom utilisateur

<br>

* password : hash du password

<br>

* password_lock : vérouiller le password du user

<br>

* remove : en cas de state absent, suppression en même des répertoires du user

<br>

* shell : définition sur shell attribué au user

<br>

* skeleton : avec create_home, pour définir le squelette à appliquer	

<br>

* ssh_key_bits : taille de la clef ssh générée

<br>

* ssh_key_comment : commentaire de la clef ssh

<br>

* ssh_key_file : spécifie le chemin de la clef ssh

<br>

* ssh_key_passphrase : définir la passphrase de la clef ssh sinon pas de passphrase

<br>

* ssh_key_type : rsa par défaut, type de clef ssh

<br>

* state : création ou suppression

<br>

* system : à la création définir ou non un compte system

<br>

* uid : fixer l'uid

<br>

* update_password : always/on_create > soit mettre à jour sur changement ou juste création


-----------------------------------------------------------------------------

# ANSIBLE : Module - User


<br>

* création d'un user avec password

```
- name: création de xavki
  user:
    name: xavki
    state: present
    password: "{{ 'password' | password_hash('sha512') }}"   
```

<br>

* ajout au groupe sudo

```
- name: création de xavki
  user:
    name: xavki
    state: present
    groups: sudo
    append: yes
    password: "{{ 'password' | password_hash('sha512') }}"   
```

<br>

* fixer l'uid

```
- name: création de xavki
  user:
    name: xavki
    state: present
    uid: 1200
    groups: sudo
    append: yes
    password: "{{ 'password' | password_hash('sha512') }}"   
```

-----------------------------------------------------------------------------

# ANSIBLE : Module - User


<br>

* génération de la clef ssh

```
- name: création de xavki
  user:
    name: xavki
    state: present
    uid: 1200
    groups: sudo
    append: yes
    generate_ssh_key: yes
    password: "{{ 'password' | password_hash('sha512') }}"   
```

<br>

* ajout d'un register et découvrir les outputs

```
  - name: création du user xavki
    user:
      name: xavki
      state: present
      generate_ssh_key: yes
      uid: 1200
      groups: sudo
      append: yes
      password: "{{ 'password' | password_hash('sha512') }}"
    register: mavar
  - name: debug
    debug:
      msg: "{{ mavar }}"
```

<br>

* nologin avec le shell

```
  - name: création du user xavki
    user:
      name: xavki
      state: present
      shell: /sbin/nologin
      generate_ssh_key: yes
      uid: 1200
      groups: sudo
      append: yes
      password: "{{ 'password' | password_hash('sha512') }}"
      password_lock: yes
```

<br>

* suppression d'un user


```
  - name: Suppression du user xavki
    user:
      name: xavki
      state: absent
```
