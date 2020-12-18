%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Les Modules : ex File


<br>

Doc : https://docs.ansible.com/ansible/latest/modules/file_module.html
Commande : ansible-doc file

<br>

Objectif : gestion des fichiers et répertoires

<br>

Périmètre : fichiers, répertoires, liens symboliques

<br>

Options courantes :

<br>

	* attribute : paramètres particuliers d'un fichier : immutabilité etc...
								(https://fr.wikipedia.org/wiki/Chattr)

<br>

	* force : pour les liens symboliques (si le fichier source existe pas, la destination existe)

<br>

	* group/owner : propriétaire et groupe de l'élément

<br>

	* mode : sous les deux formats : "0755" ou "u=rwx,g=rx,o=rx"

<br>

	* path : localisation

<br>

	* recurse : création du chemin intermédiaire si n'existe pas (yes/no) > pour directory uniquement

<br>

	* src : pour les liens (hard ou symbolique)

<br>

	* state : type (absent / directory / file / hard / link / touch)
			touch > créé le fichier vide
			file > vérifie l'existence et les caractéristiques


----------------------------------------------------------------------------------------------------


# ANSIBLE : Les Modules : ex File


<br>

* un inventaire pour débuter :

```
all:
  children:
    common:
      hosts:
        node2:
```

<br>

Playbook :


* déclaration qui et où

```
- name: Je débute avec ansible
  hosts: all
  remote_user: vagrant
  tasks:
```

<br>

* le module ping (pas nécessaire) > ping ssh

```
- name: je teste ma connexion
  ping:
```

Rq : ansible -i inventory all -m ping

----------------------------------------------------------------------------------------------------


# ANSIBLE : Les Modules : ex File



<br>

* créer un répertoire

```
- name: création du répertoire /tmp/xavki
  file:
    path: /tmp/xavki/
    state: directory
```

Rq: user de création > user de connexion

<br>

* changement de user > root

```
- name: création du répertoire /tmp/xavki
  file:
    path: /tmp/xavki/
    state: directory
    owner: root
```

Rq : droit sudo du user vagrant

<br>

* become = yes > différents endroits pour le faire
		* cli > -b
		* playbook/tasks > become: yes 

```
- name: création du répertoire /tmp/xavki
  file:
    path: /tmp/xavki/
    state: directory
    owner: root
  become: yes
```

Rq :attention à l'indentation

----------------------------------------------------------------------------------------------------


# ANSIBLE : Les Modules : ex File



<br>

* modification du groupe et des droits (RWX-RX-RX - 0755) | stat

```
- name: création du répertoire /tmp/xavki
  file:
    path: /tmp/xavki/
    state: directory
    owner: root
    group: root
    mode: 0755
  become: yes
```

<br>

* récursivité (pour directory uniquement

```
  - name: création du répertoire /tmp/xavki
    file:
      path: /tmp/xavki/1/2/3/4
      recurse: yes
      state: directory
      owner: root
      group: root
      mode: 0755
``` 

* touch

```
  - name: création du répertoire /tmp/xavki
    file:
      path: /tmp/xavki/1/2/3/4/fichier.txt
      state: touch
      owner: root
      group: root
      mode: 0755
```

----------------------------------------------------------------------------------------------------


# ANSIBLE : Les Modules : ex File


<br>

* lien symbolique = lien vers fichier (diff avec hardlink = lien vers inode)

```
  - name: création du répertoire /tmp/xavki
    file:
      src: /tmp/xavki/1/2/3/4/
      dest: /tmp/symlink
      state: link  #hard
      owner: root
      group: root
      mode: 0755
```

Rq: idempotence


<br>

* suppression de fichier

```
  - name: dir sans idempotence
    file:
      path: /tmp/xavki.txt
      state: absent
```

<br>

* suppression de répertoire récursive

```
  - name: dir sans idempotence
    file:
      path: /tmp/xavki/
      state: absent
```
