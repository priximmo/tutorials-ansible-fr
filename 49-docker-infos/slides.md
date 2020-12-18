%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : module docker... infos


<br>

* Objectif : lister des éléments docker > réutilisation


```
docker_compose – Manage multi-container Docker applications with Docker Compose
docker_config – Manage docker configs
docker_container – manage docker containers
docker_container_info – Retrieves facts about docker container
docker_host_info – Retrieves facts about docker host and lists of objects of the services
docker_image – Manage docker images
docker_image_info – Inspect docker images
docker_login – Log into a Docker registry
docker_network – Manage Docker networks
docker_network_info – Retrieves facts about docker network
docker_node – Manage Docker Swarm node
docker_node_info – Retrieves facts about docker swarm node from Swarm Manager
docker_prune – Allows to prune various docker objects
docker_secret – Manage docker secrets
docker_stack – docker stack module
docker_swarm – Manage Swarm cluster
docker_swarm_info – Retrieves facts about Docker Swarm cluster
docker_swarm_service – docker swarm service
docker_swarm_service_info – Retrieves information about docker services from a Swarm Manager
docker_volume – Manage Docker volumes
docker_volume_info – Retrieve facts about Docker volumes
```

------------------------------------------------------------------

# ANSIBLE : module docker... infos

<br>

Prérequis :

	* docker

	* python3-docker ou pip3 install docker

<br>

* modules de collecte d'infos

```
docker_container_info
docker_image_info
docker_network_info
docker_volume_info
docker_host_info
docker_node_info
docker_swarm_info
```

<br>

* liste des conteneurs et quelques éléments

```
  - name: run
    docker_container:
      name: "n{{ item }}"
      image: nginx:latest
      state: started
    with_sequence: count=5
  - name: container list
    docker_host_info:
      containers: True
    register: docker_info
  - name: debug
    debug:
      var: docker_info
```

----------------------------------------------------------------------------------------------

# ANSIBLE : module docker... infos


<br>

* infos des conteneurs

```
  - name: run
    docker_container:
      name: c1
      image: myapp:v1.3
      state: started
    register: __container_infos
  - name: print output
    debug:
      var: __container_infos
  - name: test
    uri:
      url: "http://{{ __container_infos.container.NetworkSettings.Networks.bridge.IPAddress }}"
      status_code: 200
```

----------------------------------------------------------------------------------------------

# ANSIBLE : module docker... infos


<br>

* compilation des deux liste conteneurs et infos (ip)

```
  - name: run
    docker_container:
      name: "n{{ item }}"
      image: nginx:latest
      state: started
    with_sequence: count=5
  - name: container list
    docker_host_info:
      containers: True
    register: docker_info
  - name: collecte ips
    docker_container_info:
      name: '{{ item.Names[0] | regex_replace("^/", "") }}'
    register: __container_infos
    loop: '{{ docker_info.containers }}'
  - name: print
    debug:
      msg: "{{ item.container.NetworkSettings.Networks.bridge.IPAddress }}"
    with_items:
    - "{{ __container_infos.results }} "
```

----------------------------------------------------------------------------------------------

# ANSIBLE : module docker... infos


<br>

* infos sur un réseau

```
  - name: create network xavki
    docker_network:
      name: xavki
  - name: Get infos about network
    docker_network_info:
      name: xavki
    register: __network_infos
  - name: debug
    debug:
      var: __network_infos
```

----------------------------------------------------------------------------------------------

# ANSIBLE : module docker... infos

<br>

* infos sur un volume

```
  - name: create directory
    file:
      path: /tmp/data
      state: directory
  - name: Create a volume
    docker_volume:
      name: xavki_data
      driver: local
      driver_options:
        o: bind
        type: none
        device: /tmp/data
  - name: get info about volume
    docker_volume_info:
      name: xavki
    register: __volume_infos
  - name: print
    debug:
      var: __volume_infos
```



