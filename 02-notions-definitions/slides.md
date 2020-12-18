%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Notions et Définitions


<br>

* Control node :
		* noeud disposant de ansible et permettant de déployer
		* accès ssh aux autres machines (bastions...)
		* password ou clef ssh
		* sécurité importante

<br>

* Managed nodes :
		* serveurs cibles
		* permet la connexion ssh
		* élévation de privilèges via le user

<br>

* Inventory :
		* inventaires des machines  (ip, dns)
		* format ini (plat) ou format yaml
		* et les variables (host_vars et group_vars)
		* statique (fichiers) ou dynamique (api via script)
		* utilisation de patterns possible (srv-pg93-0[0-2])

-----------------------------------------------------------------------------------------------

# ANSIBLE : Notions et Définitions


<br>

* Groupes : 
		* dans un inventaire les machines peuvent être regroupées (serveur web, databases...)
		* possibilité de créer différents niveaux > arbre (parents/enfants)
		* groupe racine = all

<br>

* Groups Vars : 
		* variables d'un même groupe
		* définie dans le fichier central d'inventory 
		* ou dans un répertoire spécifique (reconnu par ansible)

<br>

* Host Vars :
		* variables spécifiques à un serveur en particulier 
		* surcharge d'autres variables définies plus haut dans l'arbre - ex - groupe

<br>

* exemple d'inventory :

```
inventory.yml
host_vars/
group_vars/
```

-----------------------------------------------------------------------------------------------

# ANSIBLE : Notions et Définitions


<br>

* Tasks :
		* actions variées (user, group, command, module)
		* format yaml

<br>

* Modules :
		* ensemble d'actions ciblées sur une utilisation commune
		* pour un outil donnée : ex. postgres, mysql, vmware...
		* chacune de ses actions est utilisable via une task
		* chaque action prend des options
		* les actions peuvent fournir un retour (id, résultat...)
		* fournis par ansible pour l'essentiel
		* peuvent être chargés spécifiquement
		* contribution possible auprès des mainteneurs

<br>

* Rôles :
		* ensemble d'actions coordonnées pour réaliser un ensemble cohérent (installer nginx et le configurer etc)
		* organisé en différents outils (tasks, templates, handlers, variables (default ou non), meta)
		* peuvent être partagés sur le hub ansible galaxy
		* il vaut mieux les versionner

<br>

* Playbooks :
		* un fichier (et rien d'autres...)
		* applique des rôles à un inventory
		* partie cruciale inventory > playbook < rôles
		* peut contenir des variables (à éviter)
		* peut contenir des tasks (à éviter)
		* peut contenir des conditions (à éviter)

<br>

* Plugins :
		* modifie ou augmente les capacités de ansible
		* de différentes manières : output, inventory dynamique, strategy, tests...



