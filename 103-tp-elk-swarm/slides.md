%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM


* intégration de l'exporter elasticsearch

<br>

```
- name: install eS
  become: yes
  hosts: elastic
  roles:
  - elasticsearch
  - logstash
  - elasticsearch_exporter
```

-------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM


<br>

* même base que pour node exporter

```
- name: check if elasticsearch exporter exist
  stat:
    path: "{{ elasticsearch_exporter_bin }}"
  register: __check_elasticsearch_exporter_present
```

<br>

* gestion de la version via le service systemd

```
- name: if elasticsearch exporter exist get version
  shell: "cat /etc/systemd/system/elasticsearch_exporter.service | grep Version | sed s/'.*Version '//g"
  register: __get_elasticsearch_exporter_version
  when: __check_elasticsearch_exporter_present.stat.exists == true
  changed_when: false
```

-------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* création d'un user

```
- name: create elasticsearch exporter user
  user:
    name: "{{ elasticsearch_exporter_user }}"
    append: true
    shell: /usr/sbin/nologin
    system: true
    create_home: false
    home: /
```

-------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* création du répertoire de configuration

```
- name: create elasticsearch exporter config dir
  file:
    path: "{{ elasticsearch_exporter_dir_conf }}"
    state: directory
    owner: "{{ elasticsearch_exporter_user }}"
    group: "{{ elasticsearch_exporter_group }}"
```

-------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* download et unarchive

```
- name: download and unzip elasticsearch exporter if not exist
  unarchive:
    src: "https://github.com/justwatchcom/elasticsearch_exporter/releases/download/v{{ elasticsearch_exporter_version }}/elasticsearch_exporter-{{ elasticsearch_exporter_version }}.linux-amd64.tar.gz"
    dest: /tmp/
    remote_src: yes
    validate_certs: false
  when: __check_elasticsearch_exporter_present.stat.exists == false or not __get_elasticsearch_exporter_version.stdout == elasticsearch_exporter_version
```

-------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* déplacement du binaire

```
- name: move the binary to the final destination
  copy:
    src: "/tmp/elasticsearch_exporter-{{ elasticsearch_exporter_version }}.linux-amd64/elasticsearch_exporter"
    dest: "{{ elasticsearch_exporter_bin }}"
    owner: "{{ elasticsearch_exporter_user }}"
    group: "{{ elasticsearch_exporter_group }}"
    mode: 0755
    remote_src: yes
  when: __check_elasticsearch_exporter_present.stat.exists == false or not __get_elasticsearch_exporter_version.stdout == elasticsearch_exporter_version
```

-------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* nettoyage de /tmp

```
- name: clean
  file:
    path: /tmp/elasticsearch_exporter-{{ elasticsearch_exporter_version }}.linux-amd64/
    state: absent
```

<br>

* ajout du service systemd


```
- name: install service
  template:
    src: elasticsearch_exporter.service.j2
    dest: /etc/systemd/system/elasticsearch_exporter.service
    owner: root
    group: root
    mode: 0644
  notify: reload_daemon_and_restart_elasticsearch_exporter
```

-------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* flush du handler et start/enable

```
- meta: flush_handlers

- name: service always started
  systemd:
    name: elasticsearch_exporter
    state: started
    daemon-reload: yes
    enabled: yes
```

-------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM


<br>

* le handler

```
- name: reload_daemon_and_restart_elasticsearch_exporter
  systemd:
    name: elasticsearch_exporter
    state: restarted
    daemon_reload: yes
    enabled: yes
```

<br>

* les variables

```
elasticsearch_exporter_version: "1.1.0"
elasticsearch_exporter_bin: /usr/local/bin/elasticsearch_exporter
elasticsearch_exporter_user: elasticsearch-exporter
elasticsearch_exporter_group: "{{ elasticsearch_exporter_user }}"
elasticsearch_exporter_dir_conf: /etc/elasticsearch_exporter
```

-------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* le service systemd

```
[Unit]
Description=Elasticsearch Exporter Version {{ elasticsearch_exporter_version }}
After=network-online.target
[Service]
User={{ elasticsearch_exporter_user }}
Group={{ elasticsearch_exporter_group }}
Type=simple
ExecStart={{ elasticsearch_exporter_bin }} \
--es.uri=http://{{ ansible_host }}:9200 \
--es.all \
--es.indices \
--es.clusterinfo.interval=30s
[Install]
WantedBy=multi-user.target
```

-------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>
* mise à jour de grafana pour le dashboard elasticsearch

```
- name: install remote exporter dashboards
  get_url:
    url: "{{ item.url }}"
    dest: /var/lib/grafana/{{ item.name }}.json
    mode: '0755'
  with_items:
  - { name: "node-exporter", url: "https://raw.githubusercontent.com/rfrail3/grafana-dashboards/master/prometheus/node-exporter-full.json" }
```

```
- name: install local exporter dashboards
  copy:
    src: dashboard-{{ item.name }}.json
    dest: /var/lib/grafana/{{ item.name }}.json
    mode: '0755'
  with_items:
  - { name: "elasticsearch-exporter" }
```

-------------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* boucle sur les dashboards

```
- name: activate dashboards 
  template:
    src: dashboard-conf.yml.j2
    dest: /etc/grafana/provisioning/dashboards/dashboard-{{ item.name }}.yml
    mode: 0755
  with_items:
  - { name: "node-exporter" }
  - { name: "elasticsearch-exporter" }
  notify: restart_grafana
```
