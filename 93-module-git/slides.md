%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : MODULE GIT

<br>

Documentation : https://docs.ansible.com/ansible/latest/collections/ansible/builtin/git_module.html

Objectifs : cloner, mettre à jour, vérifier un dépôt git

Astuce > SSH

<br>

ansible ssh > remote server ssh > git server

transmission de la clef via le forward agent (sinon toke gitlab)

-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE GIT

<br>

PARAMETRES

<br>

* accept_hostkey : accepter le fingerprint

<br>

* archive : création d'une archive du dépôt à partir du dépôt local (zip, targ.gz, tar, tgz)

<br>

* archive_prefix : préfix pour tous les fichiers de l'archive

<br>

* bare : pour la création d'un bare repo (défaut = standard)
		* git init --bare == dépôts nus (juste l'historique)

<br>

* clone : (défaut yes) force à cloner le dépôt

<br>

* depth : réduire l'historique 

<br>

* dest : répertoire de destination

-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE GIT


<br>

* executable : path vers le binaire git à utiliser

<br>

* gpg_whitelisting : liste de fingerprint vérifés

<br>

* key_file : chemin ver sune clef privée (à éviter)

<br>

* recursive : clone tout ce qui est dans el dépôt (submodules)

<br>

* reference : copie les objets en cache (git clone --reference)

<br>

* refspec : comme le git fetch 

<br>

* remote : nom du remote (origin)

<br>

* repo : chemin et type de connexion vers le dépôt (ssh, https, git)

<br>

* separate_git_dir : séparation du répertoire .git

<br>

* ssh_opts : options pour le ssh (entre le target ansible et le dépôt git)

-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE GIT


<br>

* track_submodules : yes > maj avec dernier commit de master / no > celui connu par le dépôt git principal

<br>

* umask : définition du umask appliqué avant le clone

<br>

* update : (défaut yes) vérifie si le dépôt est à jour si no vérifie juste la présence du répertoire

<br>

* version : le HEAD ou la branche

-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE GIT

<br>

EXAMPLE 

<br>

Dépôt : https://gitlab.com/xavki/ansible_git.git

2 types de connexions ssh/https

<br>

* appli python/flask

```
- name: test git module
  hosts: all
  become: yes
  tasks:
  - name: install python libs
    apt:
      name: python3-flask,python3-requests
      update_cache: yes
      cache_valid_time: 3600
      state: present
```

Rq : attention !!! become > yes (root)


-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE GIT


<br>

* installation de l'api

```
  - name: move on /opt
    copy:
      src: /tmp/myapp
      dest: /opt/
      remote_src: yes
  
  - name: change mode
    file:
      path: /opt/myapp
      mode: 0755
      recurse: yes
  
  - name: add systemd service
    template:
      src: myapp.service.j2
      dest: /etc/systemd/system/myapp.service
    notify: reload_myapp
```

-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE GIT

```
  - name: start service myapp
    service:
      name: myapp
      state: started

  handlers:
  - name: reload_myapp
    systemd:
      name: myapp
      daemon_reload: yes
      state: restarted
      enabled: yes
```

-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE GIT


<br>

* le template du service systemd

```
[Unit]
Description= Flask myapp
After=network.target
[Service]
User=root
ExecStart=/opt/myapp/sample_api.py
[Install]
WantedBy=multi-user.target
```


-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE GIT


<br>

* simple en https 

```
  - name: git clone from gitlab
    git:
      repo: https://{{ user }}:{{ password }}@gitlab.com/xavki/ansible_git.git
      dest: /tmp/myapp
      version: master
    notify: reload_myapp
```

Rq : become > no (maintien du user)


-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE GIT


<br>

* simple en ssh

```
  - name: git clone from gitlab
    git:
      repo: git@gitlab.com:xavki/ansible_git.git
      dest: /tmp/myapp
      version: master
      update: yes
      accept_hostkey: yes
    notify: reload_myapp
    become: no
```

Rq : 
		
		* become > no (maintien du user)

		* accept host key > fingerprint

		* embarquer la clef ssh

```
[ssh_connection]
ssh_args = "-o ForwardAgent=yes -o ControlMaster=auto -o ControlPersist=60s"
```


-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE GIT


<br>

* faire une archive sur le serveur cible

```
  - name: git clone from gitlab
    git:
      repo: git@gitlab.com:xavki/ansible_git.git
      dest: /tmp/myapp
      version: master
      update: yes
      accept_hostkey: yes
      archive: /tmp/myapp.tar.gz
    notify: reload_myapp
    become: no
```


-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE GIT


<br>

* isoler le .git (objets)

```
  - name: git clone from gitlab
    git:
      repo: git@gitlab.com:xavki/ansible_git.git
      dest: /tmp/myapp
      version: master
      update: yes
      accept_hostkey: yes
      separate_git_dir: /tmp/git_dir
    notify: reload_myapp
    become: no
```
