%title: ANSIBLE
%author: xavki


# ANSIBLE : module docker_image


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

* api_version : version de l'api docker (docker info)

* archive_path : cas d'une image en tar, chemin d'accès

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

* buildargs (deprecated) : idem build > args

* ca_cert : vérficiation du serveur par ca (DOCKER_CERT_PATH)

* client_cert : tls client

* client_key : tls client clef 

* containers_limit (deprecated) : idem build > container_limits
				
* debug : activation du mode debug

* docker_hosts : par défaut socket local sinon tcp/ssh

* dockerfile (deprecated) : cf build

* force : à utiliser avec le state absent pour forcer la suppression

* 



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
      username: xavki
      password: Casimodo12*
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
 



