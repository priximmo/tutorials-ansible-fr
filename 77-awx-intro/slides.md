%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : AWX INTRO

<br>

* complément à ansible

* ansible est centré CLI (pas gestion de droits, de projets...)

* gestion des crédentials limitée

<br>

AWX :

<br>

* opensource project accompagné par Redhat (ansible Tower)

<br>

* projet amont de ansible Tower (support et validation de fonctionnalités)

Pricing Tower : https://www.ansible.com/products/pricing

<br>

* dépôt : https://github.com/ansible/awx

<br>

* google group : https://groups.google.com/g/awx-project?pli=1

----------------------------------------------------------------------------------------

# ANSIBLE : AWX INTRO


ATOUTS :

<br>

* une GUI

<br>

* authentification RBAC : LDAP / Google OAuth / Github...

<br>

* jobs scheduling

* parallélisation de job (clustering)

<br>

* gestion de différentes credentials pour les targets : clefs ssh, passwords...

<br>

* facilite l'envoi de logs

<br>

* notification : email, grafana, slack rocketchat, irc...

<br>

----------------------------------------------------------------------------------------

# ANSIBLE : AWX INTRO

<br>

PREREQUIS
	* 4GB de ram
	* 2 coeurs
	* 20GB de volume
	* peut tourner plutôt sur Docker, Openshift, Kubernetes
	* postgresql >=10


COMPOSANTS

<br>

* nginx

* nodejs / front

<br>

* postgresql

<br>

* redis

<br>

POUR INSTALLATION

<br>

* installation facilitée par ansible

<br>

* prérequis (hors k8s) : ansible + docker + docker-compose + lib docker + lib docker-compose

<br>

* monte des volumes (par défaut):
	* les configurations
	* le volume des datas PG

----------------------------------------------------------------------------------------

# ANSIBLE : AWX INTRO

<br>

DEFINITIONS

<br>

* Projects >  playbook, configuration, roles, templates > git 

<br>

* Crendentials > ssh ou user/password pour accéder aux machines cibles

<br>

* Inventories > description des machines cibles

<br>

* Templates > rassemble le tout pour jouer le playbook suivant les conditions définies
