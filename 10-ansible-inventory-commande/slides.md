%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : ansible-inventory et graph



<br>

* commande ansible-inventory
		* pour y voir plus clair
		* pour grapher

<br>

* export au format json par défaut (serveurs et variables d'inventaire)

```
ansible-inventory -i <inventory_file> --list
ansible-inventory -i <inventory_file> --yaml
```

* plus compact

```
ansible-inventory -i 00_inventory.yml --list --export
```

<br>

* afficher un format compact sans variables

```
ansible-inventory -i <inventory_file> --graph
```

* avec les variables

```
ansible-inventory -i 00_inventory.yml --graph --vars
```

---------------------------------------------------------------------------------------------

# ANSIBLE : Variables d'inventaire


<br>

* export vers un fichier

```
ansible-inventory -i <inventory_file> --output
```

<br>

* format toml

```
pip3 install toml
ansible-inventory -i <inventory_file> --vars --toml
```

<br>

* grapher...

```
pip3 install ansible-inventory-grapher
sudo apt install graphviz graphicsmagick-imagemagick-compat
ansible-inventory-grapher -i inventory.yml all | dot -Tpng | display png:-
```

Dépôt : https://github.com/willthames/ansible-inventory-grapher
