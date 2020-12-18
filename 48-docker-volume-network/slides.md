%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : module docker_network & docker_volume


<br>

* Objectif : manager les réseaux et volumes

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

Source : https://docs.ansible.com/ansible/2.9/modules/list_of_all_modules.html

--------------------------------------------------------------------------------------------------------

# ANSIBLE : module docker_network & docker_volume

<br>

Prérequis :

	* docker

	* python3-docker ou pip3 install docker

<br>

PARAMETRES

<br>

* appends : ajouter un réseau aux réseaux du conteneurs

<br>

* connected : affecter des conteneurs existants à un réseau unique

<br>

* docker_host : accès distant ou local en fonction de la socket unix/tcp/ssh

<br>

* ipam_config : configuration du réseau

<br>

* name : nom du réseau

<br>

* state : present / absent


------------------------------------------------------------------------------------------


# ANSIBLE : module docker_network



<br>

* création d'un network 

```
  - name: create network xavki
    docker_network:
      name: xavki
```

<br>

* affecter des conteneurs existants à un réseau

```
  - name: create network xavki
    docker_network:
      name: xavki
      connected:
      - c1
  - name: run
    docker_container:
      name: c1
      image: myapp:v1.1
      state: started
      networks:
      - name: xavki
```

------------------------------------------------------------------------------------------


# ANSIBLE : module docker_network


<br>

* ajouter un réseau aux autres réseaux du conteneur

```
  - name: create network xavki
    docker_network:
      name: xavki2
      appends: yes
      connected:
      - c1
```

<br>

* configuration du réseau (ip gateway...)

```
  - name: create network xavki
    docker_network:
      name: xavki
      connected:
      - c1
      ipam_config:
      - subnet: 172.13.12.0/24
        gateway: 172.13.12.1
        iprange: 172.13.12.0/24
```

Rq: https://docs.docker.com/compose/compose-file/compose-file-v2/#ipam


------------------------------------------------------------------------------------------


# ANSIBLE : module docker_volume


<br>

Documentation : https://docs.ansible.com/ansible/2.9/modules/docker_volume_module.html


<br>

PARAMETRES

<br>

* driver : local / nfs...

* driver_options : configuration du driver

* name : nom du volume

* recreate : never / always

* state : present / absent


------------------------------------------------------------------------------------------


# ANSIBLE : module docker_volume



<br>

* création sinple d'un volume

```
  - name: Create a volume
    docker_volume:
      name: xavki_data
      state: present
```

<br>

* création d'un volume vers un path

```
  - name: Create a volume
    docker_volume:
      name: xavki_data
      driver: local
      driver_options:
        o: bind
        type: none 
        device: /tmp/data
```

<br>

* suppression du volume

```
  - name: Create a volume
    docker_volume:
      name: xavki_data
      state: present
      recreate: never
```
