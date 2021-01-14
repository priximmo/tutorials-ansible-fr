%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Module COPY


Documentation: https://docs.ansible.com/ansible/2.5/modules/copy_module.html

Objectifs : copier des fichiers ou du contenu
Equivalent ? scp


<br>

PARAMETRES :

<br>

* attributes : attributs du fichier

<br>

* backup : réalise une copie datée avant la copie

<br>

* checksum : vérification du ficheir via un hash

<br>

* content : dans le cas ou la source n'est pas un fichier mais une variable ou un string

<br>

* decrypt : déchiffre les fichiers si ils sont vaultés (défaut : yes)

<br>

* dest : localisation du fichier sur les serveurs target

<br>

* directory_mode : dans le cas d'une recopie en mode récursif

---------------------------------------------------------------------------------------------------

# ANSIBLE : Module COPY


<br>

* follow : indiquer le filesytème dans la destination

<br>

* force : remplace le fichier si il est différent de la source 

<br>

* group : group propriétaire

<br>

* local_follow : indique le filesystème dans la source

<br>

* mode : permissions du fichier ou du répertoire (0755, u+rwx,g+rx,o+rx)

<br>

* owner : user propriétiare

<br>

* remote_src : no > copie du master vers la target, yes > copie de la target vers la target

<br>

* src : localisation de la source
		* attention : roles / dir files / .

<br>

* unsafe_writes : éviter la corruption de fichier

<br>

validate : commande jouée pour valider le fichier avant de le copier (le fichier se situe %s)

---------------------------------------------------------------------------------------------------

# ANSIBLE : Module COPY


<br>

* simple

```
  tasks:
  - name: copy
    copy:
      src: test.txt
      dest: /tmp/xavki.txt
```

Rq : attention à la localisation de la source (cf les rôles)

<br>

* si changement > de base reupload

```
  tasks:
  - name: copy
    copy:
      src: test.txt
      dest: /tmp/xavki.txt
      force: no
```

<br>

* en mode récursif

```
mkdir -p tmp/xavki/{1,2,3}
```

```
  - name: copy
    copy:
      src: tmp/
      dest: /tmp/
```

---------------------------------------------------------------------------------------------------

# ANSIBLE : Module COPY

<br>

* déplacer les fichiers ou répertoires sur la cible

```
  - name: copy
    copy:
      src: /home/oki
      dest: tmp/
      remote_src: yes
```

<br>

* combinaison avec with_items

```
  vars:
    mesfichiers:
      - { source: "xavki1.txt", destination: "/tmp/{{ ansible_hostname }}_xavki1.txt", permission: "0755" }
      - { source: "xavki2.txt", destination: "/home/oki/{{ ansible_hostname }}_xavki2.txt", permission: "0644" }
  tasks:
  - name: copy
    copy:
      src: "{{ item.source }}"
      dest: "{{ item.destination }}"
      mode: "{{ item.permission }}"
    with_items: "{{ mesfichiers }}"
```


<br>

* utilisation de pattern

```
  - name: copy
    copy:
      src: "{{ item }}"
      dest: /tmp/
    with_fileglob:
    - xavk*
```

---------------------------------------------------------------------------------------------------

# ANSIBLE : Module COPY

<br>

* avec backup

```
  - name: copy
    copy:
      src: "{{ item }}"
      dest: /tmp/
      backup: yes
    with_fileglob:
    - xavk*
```

<br>

* recopier du contenu à partir d'une variale ou/et un string

```
  - name: copy
    copy:
      content: |
         Salut
         la team !!
         on est sur {{ ansible_hostname }}
      dest: /tmp/hello.txt
```

---------------------------------------------------------------------------------------------------

# ANSIBLE : Module COPY

<br>

* avec validation

```
- name: copie du fichier nginx.conf avec check
  copy:
    src: nginx.conf
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: 0644
    validate: /usr/bin/nginx -t -c %s
```

ou encore

```
  - name: Add devops user to the sudoers
    copy:
      dest: "/etc/sudoers.d/devops"
      content: "oki ALL=(ALL)  NOPASSWD: ALL"
      owner: root
      group: root
      mode: 0400
      validate: /usr/sbin/visudo -cf %s
```

test

```
  - name: Add devops user to the sudoers
    copy:
      dest: "/etc/sudoers.d/devops"
      content: "oki ALL=(ALL)  AAAAA: ALL"
      owner: root
      group: root
      mode: 0400
      validate: /usr/sbin/visudo -cf %s
    become: yes
```
