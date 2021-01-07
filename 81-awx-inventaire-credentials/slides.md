%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : AWX - Inventory


<br>

Objectif : lancer un playbook

Il nous faut :

* 1 accès : travailler

* 1 inventory : machines cibles

* 1 project : code source

* 1 template : associe project + inventory

-------------------------------------------------------------------------

# ANSIBLE : AWX - Inventory

<br>

INVENTORY

* admins > création d'inventaire

* smart inventory = à partir d'un autre inventaire

* permissions sur l'inventaire

* création des groupes et variables

* related groups

* groups = run command

-------------------------------------------------------------------------

# ANSIBLE : AWX - Inventory

<br>

HOSTS

* création d'un hosts

* ajout de l'inventaire 

* variable : ansible_host

* éventuellemnt visualisation des facts (après run)

* affectation à un groupe (si autre que all)

* run command

-------------------------------------------------------------------------

# ANSIBLE : AWX - Inventory

<br>

CREDENTIALS

* type de creds : machine

* création mini password

* ou clef privée

* retourner dans l'inventory pour tester la commande ping (F5 refresh)

 


