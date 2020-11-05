%title: ANSIBLE
%author: xavki


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

* capabilities : 

* cap_drop :

* command :

* comparisons : 

* env :

* env_file :

* exposed_ports :

* healthcheck : 

* image: 

* links :

* log_driver :

* log_options :

* name :

* networks :

* ports :

* recreate : 

* restart : 

* state :

* volumes :

* volumes_from :


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


    - name: Create a data container
      docker_container:
        name: my-test-container
        image: python:2.7
        command: /bin/sleep 600
    - name: Check if container is running
      shell: docker ps


    - name: Running the container
      docker_container:
        image: web:latest
        path: docker
        state: running

    - name: Start new docker container
      docker_container:
        name: app
        pull: yes
        image: "application:{{ version }}"
        ports:
          - 8080:8080

    - name: Run Docker container using simple-docker-image
      docker_container:
        name: simple-docker-container
        image: simple-docker-image:latest
        state: started
        recreate: yes
        detach: true
        ports:
          - "8888:8080"




    - name: Create default containers
      docker_container:
        name: "{{ default_container_name }}{{ item }}"
        image: "{{ default_container_image }}"
        command: "{{ default_container_command }}"
        state: present
      with_sequence: count={{ create_containers }}




    - name: Get a list of all running containers
      docker_host_info:
        containers: True
      register: docker_info
    - name: Stop all running containers
      docker_container:
        name: '{{ item.Names[0] | regex_replace("^/", "") }}'
        state: stopped
      loop: '{{ docker_info.containers }}'




    - name: Get a list of all running containers
      docker_host_info:
        containers: True
      register: docker_info
    - name: Stop all containers running nginx image
      docker_container:
        name: '{{ item.Names[0] | regex_replace("^/", "") }}'
        state: stopped
      when: item.Image == 'nginx'
      loop: '{{ docker_info.containers }}'


docker run --publish=3000:3000 --rm -e "MESSAGE=cool by env" bithavoc/hello-world-env

RETURN OUTPUT
