%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : module docker_container


<br>

* Objectif : lancement d'image docker

Documentation :
https://docs.ansible.com/ansible/latest/collections/community/general/docker_container_module.html

<br>

Prérequis :

	* docker

	* python3-docker ou pip3 install docker

<br>

PARAMETRES :

* capabilities : ajout de capabilities

* cap_drop : suppression de certaines capabilities

* command : command de run du conteneur

* comparisons : règle de gestion entre les paramètres du conteneurs existants et ce que pousse ansible

* env : définition des variables d'environnement

* env_file : fichier de définition des variables d'environnement

* exposed_ports : ports exposés

----------------------------------------------------------------

# ANSIBLE : module docker_container


* healthcheck : modalité du healthcheck

* image: image source (et son tag)

* links : (lien entre conteneur = réseau)

* log_driver : quel log driver (syslog, docker...)

* log_options : modalités de logs (log rotate etc)

* name : nom du conteneur

* networks : networks d'appartenance du conteneur

* ports : mapping des ports avec le host (publish)

* recreate : recréation ou non du conteneur systématique

* restart : modalité du restart (always, on-failure...)

* state : absent / present / stopped / started

* volumes : montage des volumes

* volumes_from : conteneurs source de volume

----------------------------------------------------------------

# ANSIBLE : module docker_container


<br>

EXEMPLES

<br>

* mise en place et premier run

```
  - name: install docker & docker for python
    apt:
      name: docker.io,python3-docker
      state: present
      update_cache: yes
      cache_valid_time: 3600
  - name: start docker
    systemd:
      name: docker
      state: started
      enabled: yes
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
        pull: yes
        path: /tmp/build/app/
        dockerfile: Dockerfile
        cache_from:
        - alpine:3.9
  - name: run
    docker_container:
      name: c1
      image: imgbuild:v1.0
      state: started
```

----------------------------------------------------------------

# ANSIBLE : module docker_container


<br>

* command et detach

```
  - name: run
    docker_container:
      name: c1
      image: ubuntu:latest
      state: started
      detach: no
      command: sleep 10
```

* exposition de ports

```
    - name: Start new docker container
      docker_container:
        name: c1
        pull: yes
        image: "myapp:{{ version }}"
        ports:
          - 8080:8080
```

----------------------------------------------------------------

# ANSIBLE : module docker_container


<br>

* exposition de ports et test :

```
  - name: build
    docker_image:
      build:
        path: /tmp/build/
        dockerfile: Dockerfile
        pull: yes
      name: myapp
      tag: v1.1
      source: build
  - name: run
    docker_container:
      name: c1
      image: myapp:v1.1
      state: started
      ports:
      - 8888:8080
  - name: wait for instance
    uri:
      url: "http://127.0.0.1:8888/select"
      status_code: 200
    register: result
    until: result.status == 200
    retries: 120
    delay: 1
```


----------------------------------------------------------------

# ANSIBLE : module docker_container


<br>

* avec healthcheck :

```
  - name: run
    docker_container:
      name: c1
      image: myapp:v1.3
      state: started
      ports:
      - 8888:8080
      healthcheck:
        test: ["CMD", "curl", "http://127.0.0.1:8080"]
        interval: 5s
        timeout: 10s
        retries: 3
        start_period: 10s
```

----------------------------------------------------------------

# ANSIBLE : module docker_container

<br>

* itération de conteneurs

```
  - name: iter container
    docker_container:
      name: "myapp-{{ item }}"
      image: "myapp:v1.3"
      state: started
    with_sequence: count=5
```

```
  - name: container list
    docker_host_info:
      containers: True
    register: docker_info
  - name: remove all containers
    docker_container:
      name: '{{ item.Names[0] | regex_replace("^/", "") }}'
      state: absent
    loop: '{{ docker_info.containers }}'
```

<br>

* si une image spécifique

```
when: item.Image == 'nginx'
```

----------------------------------------------------------------

# ANSIBLE : module docker_container

<br>

* output

```
  - name: run
    docker_container:
      name: c1
      image: myapp:v1.3
      state: started
    register: __container_infos
  - name: print output
    debug:
      var: __container_infos.ansible_facts.docker_container.NetworkSettings.IPAddress
```
