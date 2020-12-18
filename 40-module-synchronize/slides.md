%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Module SYNCHRONIZE


<br>

Documentation : https://docs.ansible.com/ansible/2.3/synchronize_module.html


* utilisation de rsync > source + destination

* intérêt ? qualité de rsync (mise à jour, risque de coupure...)

* vs copy > performance

<br>

PARAMETRES

<br>

* archive : maintien des persmissions etc

<br>

* checksum : vérification à base de checksum

<br>

* compress : compression pour le transfert

<br>

* copy_links: copie des liens symboliques

<br>

* delete : supprime les fichiers en trop déjà présents sur la destination

<br>

* dest : path de destination

<br>

* dest_port : port d'utilisation pour ssh

<br>

* dirs : transfert uniquement le répertoire mais sans récursivité

<br>

* existing_only : ne créé pas les nouveaux fichiers

---------------------------------------------------------------------------------------------

# ANSIBLE : Module SYNCHRONIZE


<br>

group : yes/no préservation du group

<br>

* links : copie des liens symboliques en tant que liens symboliques

<br>

* mode : push/pull définit le sens de la synchronisation

<br>

* owner : préserve le owner

<br>

* partial : conserve les fichiers partiellement chargés

<br>

* perms : préserve les permissions

<br>

* recursive : entre dans les sous répertoires

<br>

* rsync_opts : options de rsync complémentaires

<br>

* rsync_path : chemin vers le binaire rsync

<br>

* rsync_timeout : timeout de la commande rsync

<br>

* set_remote_user : pour préciser un user à utiliser

---------------------------------------------------------------------------------------------

# ANSIBLE : Module SYNCHRONIZE


<br>

* src : fichier ou répertoire source

<br>

* times : préserve la date de modification

<br>

* use_ssh_args : ajout d'arguments ssh complémentaires

<br>

* verify_host : vérification de la clef du host

---------------------------------------------------------------------------------------------

# ANSIBLE : Module SYNCHRONIZE



<br>

* simple

```
truncate -s 1G xavki.txt
```

```
  - name:
    apt:
      name: rsync
      state: present
    become: yes
  - name: sync
    synchronize:
      src: xavki.txt
      dest: /tmp/xavki.txt
```


* copie d'un répertoire

```
mkdir -p files;for i in $(seq 1000);do touch files/$i;done
```

```
  - name: dir
    file:
      path: /tmp/files
      state: directory
  - name: sync
    synchronize:
      src: files/
      dest: /tmp/files
```

---------------------------------------------------------------------------------------------

# ANSIBLE : Module SYNCHRONIZE


* d'une machine à une autre (autre que la machine ansible

```
  - name:
    apt:
      name: rsync
      state: present
    become: yes
  - name: dir
    file:
      path: /tmp/files
      state: directory
  - name: sync
    synchronize:
      src: /tmp/files/
      dest: /tmp/files
    delegate_to: 172.17.0.2
```



