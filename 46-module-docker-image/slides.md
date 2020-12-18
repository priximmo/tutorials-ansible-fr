%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


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

<br>

* pull simple d'une image

```
  - name: Pull an image
    docker_image:
      name: alpine
      tag: latest
      source: pull
```

<br>

* retaguer une image

```
  - name: Pull an image
    docker_image:
      name: alpine
      tag: latest
      repository: myregistry/monimage:v1.0
```

------------------------------------------------------------------------------------------------------

# ANSIBLE : module docker login & docker_image


<br>

* import via un tar (docker save)

```
  - name: copy image
    copy:
      src: image.test.v1.0.tar
      dest: /tmp/
  - name: Pull an image
    docker_image:
      name: archive
      tag: v1.0
      load_path: /tmp/image.test.v1.0.tar
      source: load
```

<br>

* build d'image via Dockerfile

```
  - name: copy files
    file:
      path: /tmp/build
      state: directory
  - name: copy image
    copy:
      src: app/
      dest: /tmp/build
  - name: build
    docker_image:
      name: imgbuild
      tag: v1.0
      source: build
      build:
        path: /tmp/build/app/
        dockerfile: Dockerfile
        cache_from:
        - alpine:3.9
```


------------------------------------------------------------------------------------------------------

# ANSIBLE : module docker login & docker_image


<br>

* cas du build & push

```
  - include_vars: /home/oki/.vault.yml
  - name: docker login
    docker_login:
      registry_url: registry.gitlab.com
      username: xavki
      password: "{{ vault_token_gitlab }}"
      reauthorize: yes
  - name: build
    docker_image:
      build:
        path: /tmp/build/
        dockerfile: Dockerfile
        pull: yes
        cache_from:
        - alpine:3.9
      source: build
      name: registry.gitlab.com/xavki/testflux
      tag: v1.1
```
