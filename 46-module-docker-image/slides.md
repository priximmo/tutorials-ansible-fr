%title: ANSIBLE
%author: xavki


# ANSIBLE : module docker login & docker_image


<br>
* Objectif : construction, build et push d'images docker

Documentation :
https://docs.ansible.com/ansible/latest/collections/community/general/docker_image_module.html

<br>
Prérequis :

	* docker

	* python3-docker ou pip3 install docker

<br>
PARAMETRES :

<br>
* api_version : version de l'api docker (docker info)

<br>
* archive_path : cas d'une image en tar, chemin d'accès

<br>
* build : pour constuire une image
		* args : clef/valeur
		* cache_from : images sources utilisées en cache
		* container_limits: limite applicable aux conteneurs POUR LE BUILD
					* cpusetcpus : spécificier le cpu (taskset)
					* cpushares : poids des cpus
					* memory : mémoire maximum
					* memswap : mémoire total (mem + swap) , -1 = disable swap

		* dockerfile : nom du fichier Dockerfile
		* /etc/hosts : utilisé lors du build (liste : ip / adresses)
		* http_timeout : timeout lors du build
		* network : utilisé pour le RUN
		* no_cache: ne pas utiliser de cache
		* path : chemin de contexte pour le build
		* pull : dowload du/des FROM
		* rm : suppression des images intermédiaires après le build
		* target : image finale résultant de plusieurs stage
		* use_config_proxy : utilisation d'un proxy

------------------------------------------------------------------------------------------------------

# ANSIBLE : module docker login & docker_image



<br>
* buildargs (deprecated) : idem build > args

<br>
* ca_cert : vérficiation du serveur par ca (DOCKER_CERT_PATH)

<br>
* client_cert : tls client

<br>
* client_key : tls client clef 

<br>
* containers_limit (deprecated) : idem build > container_limits
				
<br>
* debug : activation du mode debug

<br>
* docker_hosts : par défaut socket local sinon tcp/ssh

<br>
* dockerfile (deprecated) : cf build

<br>
* force : à utiliser avec le state absent pour forcer la suppression

<br>
* force_source : refaire build, load, pull d'une image qui existe déjà

<br>
* force_tag : forcer le tagging d'une image

<br>
* http_timeout (deprecated) : cf build

------------------------------------------------------------------------------------------------------

# ANSIBLE : module docker login & docker_image


<br>
* load_path : load une image via son archive tar

<br>
* name : nom de l'image url_registry/nom

<br>
* nocache : ne pas utiliser le cache au build

<br>
* path (deprecated) : cf build

<br>
* pull : idem

<br>
* push : idem

<br>
* repository : chemin vers le dépôt

<br>
* rm (deprecated) : cd build

<br>
* source : origine de l'image :
		* build : dockerfile
		* load : archive tar
		* pull : pull d'une registry
		* local : déjà présente dans le cache local

------------------------------------------------------------------------------------------------------

# ANSIBLE : module docker login & docker_image


<br>
* ssl_version : version ssl pour docker

<br>
* state : present / build / absent

<br>
* tag : tag de l'image

<br>
* timeout : délai pour le timeout du daemon docker

<br>
* tls : connexion chiffrée vers l'api docker

<br>
* tls_hostname : hostname pour le tls

<br>
* validate_certs : check tls


------------------------------------------------------------------------------------------------------

# ANSIBLE : module docker login & docker_image


<br>
EXEMPLES :



- name: nom du playbook
  hosts: all
  become: yes
  tasks:

  - name: create directory for build
    file:
      path: /tmp/build
      state: directory

  - name: copy files
    copy:
      src: app/
      dest: /tmp/build

  - name: install requirements
    apt:
      name: docker.io,python3-docker
      state: present
      update_cache: yes
      cache_valid_time: 3600

  - name: docker login
    docker_login:
      registry_url: registry.gitlab.com
      username: test
      password: test
      reauthorize: yes
  
  - name: build
    docker_image:
      build:
        path: /tmp/build/
        dockerfile: Dockerfile
        pull: yes
      name: registry.gitlab.com/xavki/testflux
      tag: v1.1
      push: yes
      source: build
 



