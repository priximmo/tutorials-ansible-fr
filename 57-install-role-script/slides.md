%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Organisation git > script


<br>

Objectifs:
	* travailler en commun sur les rôles et les playbooks
	* gérer plusieurs branches
	* partager les rôles dans la communauté galaxy
	* installer les rôles

<br>

* la règle > ansible-galaxy install = installation de rôles

<br>

Avantages :

* c'est la règle

* c'est pas fait maison 

* format yaml

* installation de la branche à la demande

<br>

Inconvénients :

* installation les rôles "non gitté" (développement hors répertoire rôle)

* être un peu initié à cette problématique


<br>

Proposition : script bash

-----------------------------------------------------------------------------------

# ANSIBLE : Organisation git > script


* première brique >> à vous de compléter (changement de branche, doc...)

```
install(){
	git clone "$1" "roles/$2" 2> /dev/null || git -C "roles/$2" pull
	echo $2" done"
}

mkdir -p roles/

install git@gitlab.com:ansible-xavki/ansible-role-docker.git docker
install git@gitlab.com:ansible-xavki/ansible-role-swarm.git swarm
install git@gitlab.com:ansible-xavki/ansible-role-tooling.git tooling
install git@gitlab.com:ansible-xavki/ansible-role-myapp.git myapp
```

