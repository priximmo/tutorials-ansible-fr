%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : module docker-compose

<br>

Documentation : https://docs.ansible.com/ansible/latest/collections/community/general/docker_compose_module.html


<br>

* Objectif : gérer docker-compose

<br>

PARAMETRES

<br>

* build : avec construction à base d'un dockerfile - path

<br>

* definition : pour configurer le docker-compose

<br>

* dependencies : dépendance d'un autre service

<br>

* docker_host : socket docker (unix/ssh/tcp)

<br>

* files : liste des docker-compose file

-------------------------------------------------------------------------------------


# ANSIBLE : module docker-compose


<br>

* nocache : build sans cache

<br>

* pull : puller en priorité les images ?

<br>

* remove_images : supprimer l'image local

<br>

* remove_orphans : supprimer les conteneurs non compris dans le docker-compose

<br>

* remove_volumes : suppression des volumes

<br>

* scale : définitin du scaling

<br>

* services : gestion du up (present), stop (stopped), restart (restarted)

<br>

* state : idem services

<br>

* plus simple

```
  - name: copy docker-compose.yml
    copy:
      src: app/docker-compose.yml
      dest: tmp/
  - name: test docker-compose
    docker_compose:
      project_src: tmp/
      state: present
```

-------------------------------------------------------------------------------------


# ANSIBLE : module docker-compose


<br>

* et son output

```
  - name: test docker-compose
    docker_compose:
      project_src: tmp/
      state: present
    register: __docker_compose
  - name: debug
    debug:
      var: __docker_compose
```

<br>

* scaling des services

```
  - name: test docker-compose
    docker_compose:
      project_src: tmp/
      state: present
      scale:
        app: 4
```

-------------------------------------------------------------------------------------


# ANSIBLE : module docker-compose

<br>

* supprimer

```
  - name: test docker-compose
    docker_compose:
      project_src: tmp/
      state: absent
```

<br>

* déintion du service sans fichier

```
  - name: test docker-compose
    docker_compose:
      project_name: mynginx
      definition:
        version: "3.7"
        services:
          app:
            image: nginx:latest
```

<br>

* avec build

```
  - name: copy docker-compose.yml
    copy:
      src: app/
      dest: /tmp/app

    docker_compose:
      project_name: mynginx
      definition:
        version: "3.7"
        services:
          app:
            build: "/tmp/app/"
            ports:
            - 8888:8080
```


