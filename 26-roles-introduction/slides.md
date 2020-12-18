%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : LES ROLES


<br>

Documentation : https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html


<br>

C'EST QUOI ?
<br>

	* des actions ayant un objectif commun
<br>

	* les fichiers liés : templates, files...
<br>

	* des variables : par défaut ou pas

<br>

INTERETS :
<br>

	* élément de partage > approche générale (même si on ne le fera pas)
<br>

	* partage > dépôt pour chaque rôle
<br>

	* principe du lego > plus il est petit et plus il est réutilisable
<br>

	* pas de règles sur la granularité
<br>

	* ex :
			* un moteur de BDD
			* la réplication
			* le système de backup
<br>

	* avoir des dépôts similaires pour s'y retrouver !!!!

<br>

ORGANISATION DE TRAVAIL :
<br>

	* un dépôt par rôle
<br>

	* maintener (approbation des PR)
<br>

	* tests des rôles
<br>

	* prise en compte des impacts globals (ex : changement de variables etc).

------------------------------------------------------------------------------------------------

# ANSIBLE : LES ROLES



<br>

STRUCTURE :
<br>

* arborescence de répertoires et fichiers yaml

<br>

		* tasks : les actions et le point d'entrée

<br>

		* defaults : les variables par défaut

<br>

		* vars : les variables de rôle

<br>

		* handlers : les déclencheurs

<br>

		* templates : les fichiers jinja

<br>

		* files : les fichiers à copier ou fichiers statiques

<br>

		* meta : pour partager sur galaxya et inclure les dépendances

<br>

		* test : éléments de test

<br>

		* library : modules spécifiques au rôle

------------------------------------------------------------------------------------------------

# ANSIBLE : LES ROLES


<br>

GALAXY :

	* un site : https://galaxy.ansible.com/

	* une ligne de commande
