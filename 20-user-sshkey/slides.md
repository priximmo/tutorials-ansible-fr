%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : SSH Key et User


Documentation:
* https://docs.ansible.com/ansible/latest/collections/ansible/posix/authorized_key_module.html
* https://docs.ansible.com/ansible/latest/collections/community/crypto/openssh_keypair_module.html

Objectifs : générer une clef ssh et la déployer

Attention : où suis-je ? qui suis-je ?

<br>

PARAMETRES : openssh_keypair

<br>

* attibutes : attributs des fichiers (non supprimable etc)

<br>

* comment : commentaire de la clef

<br>

* force : regénère la clef si elle existe déjà

<br>

* group : group propriétaire des fichiers

<br>

* mode : permisssions (cf file, 0600, u+rw)

<br>

* owner : propirétaire

<br>

* path : localisation des clefs (attention sécurité de la clef privée)

<br>

* regenerate : never / fail / partial_idempotence (si non conforme) / full_idempotence (et si non lisible) / always

<br>

* size : taille de la clef

<br>

* state : present/absent

<br>

* type : rsa / dsa / rsa1 / ecdsa / ed25519

<br>

* unsafe_writes : prévenir les corruptions de fichiers

Rq : si password / clef cassé > force : yes

--------------------------------------------------------------------------------------------------

# ANSIBLE : SSH Key et User


<br>

* exemple de génération de clef

``` 
- name: mon premier playbook
  hosts: all
  remote_user: vagrant
  tasks:
  - name: generate SSH key"
    openssh_keypair:
      path: /tmp/xavki
      type: rsa
      size: 4096
      state: present
      force: no
    run_once: yes
    delegate_to: localhost
```

Rq : delegate_to & run_once


--------------------------------------------------------------------------------------------------

# ANSIBLE : SSH Key et User


<br>

PARAMETRES : authorized_key:

* comment : commentaire (écrase le commentaire d'origine)

* exclusive : permet de supprimer les clefs non mentionnée (plusieurs clefs possibles)
			* atention pas par loop (with_items...), retour à la ligne "\n"
			* with_file fonctionne

* follow : suivre les liens symboliques

* key : contenu de la clef (cf lookup)

* key_options : options de la clef ssh (from=<ip>...)

* manage_dir : gère lui-même le répertoire (création etc...) - default yes

* path : chemin alternatif vers la clef (default .ssh...)

* state : present / absent

* user : utilisateur de la machine cible où sera installé la clef



--------------------------------------------------------------------------------------------------

# ANSIBLE : SSH Key et User


<br>

* exemple à pour le user devops à partir de la clef générée

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

--------------------------------------------------------------------------------------------------

# ANSIBLE : SSH Key et User


<br>

* exemple mode exclusif

```
- name: Set authorized key, removing all the authorized keys already set
  authorized_key:
    user: root
    key: '{{ item }}'
    state: present
    exclusive: True
  with_file:
    - public_keys/doe-jane
```
