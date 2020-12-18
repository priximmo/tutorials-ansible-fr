%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Ex - Monitoring > Prometheus


<br>

Objectif : série de vidéo de mise en pratique autour du monitoring

>> prometheus / grafana / node-exporter...

<br>

* étapes :
		1- installation node exporter
		2- installation de prometheus
		3- installation de grafana

<br>

* travail sur 4 noeuds
		1- un de monitoring (prometheus/grafana)
		2- tous monitoré par node exporter

<br>

* 2ème étape : Prometheus

<br>

* structure = inventory + playbook + role node exporter + role prometheus

----------------------------------------------------------------------------------------

# ANSIBLE : Ex - Monitoring > Prometheus


<br>

LES TASKS DU ROLE

0- mise en place du rôle
1- variables
2- installation de prometheus
3- arguments de la ligne de commande
4- fichier de configuration
5- start du service
6- handlers

<br>

* les variables

```
prometheus_dir_configuration: "/etc/prometheus"
prometheus_retention_time: "365d"
prometheus_scrape_interval: "30s"
prometheus_node_exporter: true
prometheus_node_exporter_group: "all"
prometheus_env: "production"
prometheus_var_config: 
  global:
    scrape_interval: "{{ prometheus_scrape_interval }}"
    evaluation_interval: 5s 
    external_labels:
      env: '{{ prometheus_env }}'
  scrape_configs:
    - job_name: prometheus
      scrape_interval: 5m
      static_configs:
        - targets: ['{{ inventory_hostname }}:9090']
```

----------------------------------------------------------------------------------------

# ANSIBLE : Ex - Monitoring > Prometheus



<br>

* installation de prometheus

```
- name: update and install prometheus
  apt:
    name: prometheus
    state: latest
    update_cache: yes
    cache_valid_time: 3600
```

<br>

* arguments passés à prometheus

```
- name: prometheus args
  template:
    src: prometheus.j2
    dest: /etc/default/prometheus
    mode: 0644
    owner: root
    group: root
  notify: restart_prometheus
```

----------------------------------------------------------------------------------------

# ANSIBLE : Ex - Monitoring > Prometheus


<br>

* configuration de prometheus

```
- name: prometheus configuration file
  template:
    src: prometheus.yml.j2
    dest: "{{ prometheus_dir_configuration }}/prometheus.yml"
    mode: 0755
    owner: prometheus
    group: prometheus
  notify: reload_prometheus
```

<br>

* start du service prometheus

```
- name: start prometheus
  systemd:
    name: prometheus
    state: started
    enabled: yes
```

----------------------------------------------------------------------------------------

# ANSIBLE : Ex - Monitoring > Prometheus


<br>

* flush du handler

```
- meta: flush_handlers
```

<br>

* handlers

```
- name: restart_prometheus
  systemd:
    name: prometheus
    state: restarted
    enabled: yes
    daemon_reload: yes

- name: reload_prometheus
  uri: 
    url: http://localhost:9090/-/reload
    method: POST
    status_code: 200
```
