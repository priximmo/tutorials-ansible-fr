%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM


* ajout monitoring et logs docker

<br>

* correction wait_for wordpress

```
    follow_redirects: all
```

<br>

* ajout de cadvisor sur les serveurs docker

```
- name: create containers
  docker_container:
    name: cadvisor
    image: google/cadvisor
    privileged: yes
    published_ports: 9666:8080
    volumes:
    - /:/rootfs:ro
    - /var/run:/var/run:ro
    - /sys:/sys:ro
    - /var/lib/docker/:/var/lib/docker:ro
    - /dev/disk/:/dev/disk:ro
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM


<br>

* modification du playbook

```
- name: install swarm cluster
  become: yes
  hosts: docker
  roles:
  - cadvisor
  - docker
  - swarm
  - tooling
  - deploy_wordpress
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* modification du scrape prometheus

```
prometheus_docker_exporter_group: "docker"
```

```
{% if prometheus_docker_exporter_group %}
- job_name: docker
  scrape_interval: 30s
  scrape_timeout:  30s
  metrics_path: "/metrics"
  static_configs:
  - targets:
{% for server in groups[prometheus_docker_exporter_group] %}
    - {{ server }}:9666
{% endfor %}
{% endif %}
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* ajout du dashboard + tasks grafana

```
  - { name: "docker-exporter" }
```

<br>

* collecte des logs docker

```
  - type: container
    enabled: true
    paths: 
      - '/var/lib/docker/containers/*/*.log'
```
