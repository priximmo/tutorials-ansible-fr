%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : AWX - Permissions


<br>

Objectif : lancer un playbook

Il nous faut :

* 1 accès : travailler

* 1 inventory : machines cibles

* 1 project : code source

* 1 template : associe project + inventory

-----------------------------------------------------------------------

# ANSIBLE : AWX - Permissions

<br>

ACCESS

<br>

* création d'une organisation

<br>

* création de users : 

<br>

		* administrator : peut tout faire

<br>

		* droits auditor : voir tout mais pas tout modifier / ne peut pas modifier un projet / créer d'inventaire...

<br>

		* normal : intervenir / ne peut pas modifier un projet / ni inventaire

<br>

* attention des users admin est indispensable pour la création d'objets (puis ajout des permissions)

<br>

* éventuellement une team (pas indispensable)

Attention : les teams permettent une gestion plus global des droits à l'échelle de la team (inventaire, projects...)

