%title: ANSIBLE
%author: xavki


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

	* attribute : paramètres particuliers d'un fichier : immutabilité etc...
								(https://fr.wikipedia.org/wiki/Chattr)

	* force : pour les liens symboliques (si le fichier source existe pas, la destination existe)

	* group/owner : propriétaire et groupe de l'élément

	* mode : sous les deux formats : "0755" ou "u=rwx,g=rx,o=rx"

	* path : localisation

	* recurse : création du chemin intermédiaire si n'existe pas (yes/no)

	* src : pour les liens (hard ou symbolique)

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

<br>
* modification du groupe et des droits (RWX-RX-RX - 0755) | stat

- name: Change file ownership, group and permissions
  file:
    path: /etc/foo.conf
    owner: foo
    group: foo
    mode: '0644'

- name: Give insecure permissions to an existing file
  file:
    path: /work
    owner: root
    group: root
    mode: '1777'

- name: Create a symbolic link
  file:
    src: /file/to/link/to
    dest: /path/to/symlink
    owner: foo
    group: foo
    state: link

- name: Create two hard links
  file:
    src: '/tmp/{{ item.src }}'
    dest: '{{ item.dest }}'
    state: hard
  loop:
    - { src: x, dest: y }
    - { src: z, dest: k }

- name: Touch a file, using symbolic modes to set the permissions (equivalent to 0644)
  file:
    path: /etc/foo.conf
    state: touch
    mode: u=rw,g=r,o=r

- name: Touch the same file, but add/remove some permissions
  file:
    path: /etc/foo.conf
    state: touch
    mode: u+rw,g-wx,o-rwx

- name: Touch again the same file, but dont change times this makes the task idempotent
  file:
    path: /etc/foo.conf
    state: touch
    mode: u+rw,g-wx,o-rwx
    modification_time: preserve
    access_time: preserve

- name: Create a directory if it does not exist
  file:
    path: /etc/some_directory
    state: directory
    mode: '0755'

- name: Update modification and access time of given file
  file:
    path: /etc/some_file
    state: file
    modification_time: now
    access_time: now

- name: Set access time based on seconds from epoch value
  file:
    path: /etc/another_file
    state: file
    access_time: '{{ "%Y%m%d%H%M.%S" | strftime(stat_var.stat.atime) }}'

- name: Recursively change ownership of a directory
  file:
    path: /etc/foo
    state: directory
    recurse: yes
    owner: foo
    group: foo

- name: Remove file (delete file)
  file:
    path: /etc/foo.txt
    state: absent

- name: Recursively remove directory
  file:
    path: /etc/foo
    state: absent
