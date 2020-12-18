%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Organisation git


<br>

Objectifs:
	* travailler en commun sur les rôles et les playbooks
	* gérer plusieurs branches
	* partager les rôles dans la communauté galaxy
	* installer les rôles

<br>

1 - mettre en place un .gitignore pour éviter les rôles

<br>

2 - 1 dépôt par rôle

<br>

3 - 1 dépôt pour les playbooks et l'invetory

<br>

3 - fichier de requirements.yml

```
- src: http://gitlab.example.com/mypipeline/install-docker.git
  name: docker
  version: master
  scm: git
```

<br>

4 - 1 dépôt pour les playbooks et l'inventory

5 - clean et run

```
ansible-galaxy install --roles-path roles -r requirements.yml
```
