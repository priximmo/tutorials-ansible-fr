%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : AWX - Manual Project & Templates


<br>

Objectif : lancer un playbook

Il nous faut :

* 1 accès : travailler

* 1 inventory : machines cibles

* 1 project : code source

* 1 template : associe project + inventory


-----------------------------------------------------------------------------------

# ANSIBLE : AWX - Manual Project & Templates



<br>

INSTALLATION

* prévoir les volumes persistants (/var/lib/awx/projects)

* bases de données et compose

```
sudo apt install -y ansible python3-pip
sudo pip3 install docker docker-compose
git clone https://github.com/ansible/awx
vim awx/installer/inventory #datas pg / projects / compose
ansible -i inventory -b install.yml
```

<br>

* local = beaucoup d'inconvénients

		* versionning

		* persistence

		* gestion du volume

		* restart si docker

-----------------------------------------------------------------------------------

# ANSIBLE : AWX - Manual Project & Templates


<br>

PROJECTS

* ajouter un projet

* type SCM

* créer un répertoire dans le répertoire de projets
		* créer la structure en prévision

<br>

TEMPLATE

<br>

* type de run (run/check)

* inventory + playbook

* important : prévoir dans les credentials l'élévation de privilèges

* prompt launch


