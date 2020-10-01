%title: ANSIBLE
%author: xavki


# ANSIBLE : Modules UNARCHIVE ET GET_URL


<br>
UNARCHIVE

Documentation : 
	* https://docs.ansible.com/ansible/2.5/modules/unarchive_module.html

Prérequis : unzip, tar, wget

<br>
PARAMETRES :

<br>
* attributes : attributs du fichier

<br>
* copy : deprecated > utiliser remote_src

<br>
* creates : si un répertoire ou fichier exist la tâche n'est pas lancé

<br>
* decrypt : (default yes) déchiffrer les fichiers vaultés

<br>
* dest : destination des éléments

<br>
* exclude : fichier ou chemin à exclure de unarchive

<br>
* extra_opt : options complémentaires

<br>
* group : groupe propriétaire

<br>
* keep_newer : garder le plus récent

<br>
* list_files : retourne la liste des fichiers de l'archive

<br>
* mode : permissions (0755, u+rwx,g+rx,o+rx)

<br>
* remote_src : passer par le host ansible pour pousser récupérer l'archive 

<br>
* src : no > copy du fichier vers les cibles, yes > download et pousse

<br>
* unsafe_writes : éviter les corruptions de fichiers

<br>
* validate_certs : dans le cas de https (default yes) 


exemple : https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gzls


* copy et dezip:

```
  - name: start haproxy service
    unarchive:
      src: /tmp/node_exporter-1.0.1.linux-amd64.tar.gz
      dest: /home/oki/
```


