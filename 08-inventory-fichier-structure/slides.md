%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Static Inventory



<br>

* inventory = inventaire des machines et de leurs variables

<br>

* élément éssentiel car il décrit votre infra :
		* vos serveurs
		* vos types de serveurs

<br>

* deux types d'instances :
		* hosts
		* groupes

<br>

* plusieurs formats :
		* ini = plat
		* yaml = plus homogène
		* json = pour manipuler

<br>

* possiblité d'utiliser des patterns

<br>

* inventory = 
		* fichier d'inventaire
		* répertoire group_vars
		* répertoire host_vars

----------------------------------------------------------------------------------------------------

# ANSIBLE : Static Inventory


<br>

* fichier d'inventaire

<br>

* groupe racine => all

<br>

* groupes enfants

<br>

* exemple :
		* un groupe parent1
		* groupes enfants : enfant1 et enfant2
		* "sous" enfant de enfant2 : enfant3
		* enfant1 = srv1 et srv2
		* enfant2 = srv3
		* parent1 = srv4
		* enfant3= srv5

----------------------------------------------------------------------------------------------------

# ANSIBLE : Static Inventory


<br>

* format init

```
[parent1]
srv4
[enfant1]
srv1
srv2
[enfant2]
srv3
[enfant3]
srv5
[parent1:children]
groupe1
groupe2
[enfant2:children]
enfant3
```


----------------------------------------------------------------------------------------------------

# ANSIBLE : Static Inventory


<br>

* format yaml

```
all:
  children:
    parent1:
      hosts:
        srv4:
      children:
        enfant1:
          hosts:
            srv1:
            srv2:
        enfant2:
          hosts:
            srv3:
        children
          enfant3:
            hosts:
              srv5:
```

----------------------------------------------------------------------------------------------------

# ANSIBLE : Static Inventory

<br>

* passer un groupe à un autre groupe


```
all: 
  children:
    parent1:
      parent2:
      hosts:
        srv4:
      children:
        enfant1:
          hosts:
            srv1:
            srv2:
        enfant2:
          hosts:
            srv3:
          children
            enfant3:
              hosts:
                srv5:
    parent2:
      hosts:
        srv6:
        srv7:
        srv8:
        srv9:
```


----------------------------------------------------------------------------------------------------

# ANSIBLE : Static Inventory


<br>

* pattern

```
all: 
  children:
    parent1:
      parent2:
      hosts:
        srv4:
      children:
        enfant1:
          hosts:
            srv[1:2]:
        enfant2:
          hosts:
            srv3:
          children
            enfant3:
              hosts:
                srv5:
    parent2:
      hosts:
        srv[6:]:
```


----------------------------------------------------------------------------------------------------

# ANSIBLE : Static Inventory



<br>

* un peu plus vers la pratique
		* couche commune > common
		* serveurs web nginx > webserver 
		* bases de données > dbserver
		* applications dockerisées ou non > app / appdock
    * monitoring qui semble lié à toutes les machines users > monitoring

```
all:
  children:
    common:
      children:
        webserver:
          hosts:
            srv[1:4]:
        dbserver:
          hosts:
            srv[5:6]:
        app:
          hosts:
            srv[7:10]:
        appdock:
          hosts:
            srv[11:15]:
    monitoring:
      children:
        common:
```

		

Format json : https://linuxhint.com/ansible_inventory_json_format/
