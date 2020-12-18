%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Modules UNARCHIVE ET GET_URL


<br>

UNARCHIVE

Documentation : 
	* https://docs.ansible.com/ansible/2.5/modules/unarchive_module.html

Prérequis : unzip, tar

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

---------------------------------------------------------------------------------------------


# ANSIBLE : Modules UNARCHIVE ET GET_URL


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

---------------------------------------------------------------------------------------------


# ANSIBLE : Modules UNARCHIVE ET GET_URL


<br>


exemple : https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz

<br>

* copy de la machine ansible et dezip sur la machine cible:

```
  - name: test unarchive
    unarchive:
      src: /tmp/node_exporter-1.0.1.linux-amd64.tar.gz
      dest: /home/oki/
```

<br>

* avec url utilisation de remote_src

```
  - name: test unarchive
    unarchive:
      src: https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
      dest: /home/oki/
      remote_src: yes
```

---------------------------------------------------------------------------------------------


# ANSIBLE : Modules UNARCHIVE ET GET_URL


<br>

GET_URL

Documentation : 
	* https://docs.ansible.com/ansible/latest/collections/ansible/builtin/get_url_module.html

<br>

PARAMETRES :

<br>

* attributes

* backup : garde un backup du fichier avant (horodaté)

* checksum : vérifie le fichier à l'arrivée

* client_cert : pour la certification cliente tls

* client_key : non nécessaire pour tls

* dest : chemin où le fichier est stocké

* force : remplacement du fichier existant ou pas (si destination est un fichier)

* force_basic_auth : pour utiliser l'identification basic auth

* group : groupe propriétaire

* headers : ajouter un header personnalisé à la requête

---------------------------------------------------------------------------------------------


# ANSIBLE : Modules UNARCHIVE ET GET_URL


<br>

* http_agent: spécifier un agent

* mode : permissions (0755 ou u+rwx,g+rx,o+rx)

* owner : propriétaire du fichier

* sha256sum : calcul du sha256 après téléchargement

* timeout : limite la durée de la requête

* tmp_dest : localisation temporaire pour le téléchargement

* unsafe_writes : ne pas éviter la corruption de fichier

* url : url de la source (http/https, ftp)

* url_password : pour le basic_auth

* url_username : pour le basic_auth

* use_proxy : si derrière un proxy

* validate_certs : validation du certificats


---------------------------------------------------------------------------------------------


# ANSIBLE : Modules UNARCHIVE ET GET_URL


<br>


<br>

* exemple : https://downloads.apache.org/tomcat/tomcat-10/v10.0.0-M8/bin/

<br>

* avec checksum:

```
  - name: start haproxy service
    get_url:
      url: https://downloads.apache.org/tomcat/tomcat-10/v10.0.0-M8/bin/apache-tomcat-10.0.0-M8.tar.gz
      dest: /opt/tomcat8
      mode: 0755
      checksum: sha512:5e3dcbc56e14de73c6b866d355db8169680d093fa447e52e9a4082cc7ca363a385ac2a37a1acdc66c1945a21effe440aa06edd8a572ac6096cbe5e22ea356de4
      group: oki
      owner: oki
```

