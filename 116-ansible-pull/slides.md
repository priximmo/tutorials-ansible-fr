%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : PULL

<br>

* sur plusieurs vidéos

* PUSH : dépôts git > ansible server > targets

* PULL : dépôts git > targets ansible


<br>

* pull à partir d'un playbook d'un dépôt git

* généralalement chaque serveurs est responsable de son run

* performance à large échelle

* cloud (dynamique sans passer par un inventaire dynamique)



--------------------------------------------------------------------------------

# ANSIBLE : PULL


<br>

* création d'un dépôt nécessaire

* nom de playbook par défaut > local.yml

```
- name: ansible pull
  connection: local
  hosts: localhost
  become: true
```

```
  tasks:
  - name: install nginx
    apt:
      name: nginx
      update_cache: yes
  - name: start
    service:
      name: nginx
      state: started
```

--------------------------------------------------------------------------------

# ANSIBLE : PULL

<br>

* installation de python et de ansible

```
sudo apt install -y python ansible 
```

<br>

* la ligne de commande ansible pull

--accept-host-key : acceptation de la clef ssh

--check : dry run

--clean : annulation des modifications dans le répertoire 

--diff : diff des modifications

--full : fair eun git clone intégral (plutôt qu'une resync)

--private-key : ajouter une clef privée

--key-file : le fichier de clef privée

--purge : clean après le run

--------------------------------------------------------------------------------

# ANSIBLE : PULL

--scp-extra-args : arguments pour le scp

--sftp-extra-args : argument si sftp

--track-subs : récupèr eles derniers changements pour les sub modules git

--checkout,-C : pour spécifier un tag ou une branche

--timeout,-T : timeout (default 10s)

--url,-U : url du playbook

-d,--directory : répertoire de destination du clone

--------------------------------------------------------------------------------

# ANSIBLE : PULL

-e,--extra-vars : variable passée en ligne de commande

-f,--force : run le playbook même si pas de modification pullée

-o,--only-if-changed : seulement si le playbook a eu des changement

-m,--module-name : dépôt des modules

-s,--sleep : temps d'attente aléatoire entre 0 et le chiffre indiqué

-t,--tags : filtre par le ou les tags

-u,--user : utilisateur utilisé

--------------------------------------------------------------------------------

# ANSIBLE : PULL

<br>

```
ansible-pull -U git@gitlab.com:xavki/test_pull.git --private-key /home/vagrant/.ssh/id_rsa --accept-host-key
```

Note : cron


