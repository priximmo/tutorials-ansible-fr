%title: ANSIBLE
%author: xavki


# ANSIBLE : introduction


<br>
* Créé en 2012 (2015 repris par Redhat) par Michael DeHaan (Cobler, outil de provisionnement)

<br>
* Ansible = Infrastructure as code + déploiement de configurations + installations

* à base de python

<br>
* Documentation : https://docs.ansible.com/

<br>
<br>
* orchestrateur basé sur du push > pas d'agent = serveur distant pousse les informations

<br>
* à la différence des outils à base d'agents > pull (puppet etc..)

* concurrents :
		* puppet
		* chef
		* saltstack
		* capistrano

------------------------------------------------------------------------------------------------------------------------

# ANSIBLE : introduction


<br>
* simplicité lié à l'utilisation de SSH

<br>
* intégration facile dans les outils de CI/CD

<br>
* facilité d'utilisation à base de fichiers yaml

<br>
* de très nombreux modules et une très forte communauté (notamment via ansible galaxy)

<br>
* différentes notions et déinitions : inventory + playbook + rôles

<br>
* inventory > playbook < rôles

<br>
* des outils :
		* ansible vault
		* ansible playbook
		* ansible galaxy
		* ansible doc

------------------------------------------------------------------------------------------------------------------------

# ANSIBLE : introduction


* installation :
		* via les sources
		* via les paquets
		* via librairie python (pip)

* système de templating = jinja2 (python)
		* équivalent à erb pour puppet (ruby)

* modules sur de nombreux outils communs :
		* postgres
		* vmware
		* aws
		* libvirt (kvm)
		* network
		* grafana
		* postgresql
		* mysql
		...

* également utilisable pour récupérer les données de vos serveurs
