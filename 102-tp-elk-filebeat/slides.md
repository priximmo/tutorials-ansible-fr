%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM


* ajout de filebeat (collecte des logs > syslog)

<br>

* ajout à toutes les machines

```
- name: install node exporter
  become: yes
  hosts: all
  roles:
  - node_exporter
  - filebeat
```

---------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* ajout apt-transport-https

```
- name: ensure apt-transport-https is installed
  apt:
    name: apt-transport-https
    state: present
    cache_valid_time: 3600
    update_cache: yes
```

---------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* ajout de la clef gpg

```
- name: Debian - Add Elasticsearch repository key
  apt_key:
    url: "{{ filebeat_elastic_url }}/GPG-KEY-elasticsearch"
    id: "{{ filebeat_elastic_key_apt_id }}"
    state: present
```

<br>

* ajout du dépôt

```
- name: Debian - Add elastic repository
  apt_repository:
    repo: "deb {{ filebeat_elastic_url }}/packages/{{ filebeat_elastic_version }}/apt stable main"
    state: present
```

---------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* installation de filebeat

```
- name: install filebeat
  apt:
    name: filebeat
    state: present
    update_cache: yes
    cache_valid_time: 3600
```

<br>

* démarrage de filebeat

```
- name: service always started
  systemd:
    name: filebeat
    state: started
    daemon-reload: yes
    enabled: yes
```

---------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* ajout du fichier de configuration

```
- name: add filebeat configuration
  template:
    src: filebeat.yml.j2
    dest: /etc/filebeat/filebeat.yml
    mode: 0600
    owner: root
    group: root
  notify: restart_filebeat
```

---------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* le template de configuration

```
#jinja2: lstrip_blocks: "True"
filebeat.inputs:
{{ filebeat_input_config | to_nice_yaml(indent=2) }}
filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
  reload.enabled: false
setup.template.settings:
  index.number_of_shards: 2
setup.kibana:
output.elasticsearch:
  hosts:
  {% for elastic in groups['elastic'] %}
  - {{ elastic }}:9200
  {% endfor %}
processors:
  - add_host_metadata:
      when.not.contains.tags: forwarded
  - add_cloud_metadata: ~
  - add_docker_metadata: ~
  - add_kubernetes_metadata: ~
```

---------------------------------------------------------------------

# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* ajout du handler

```
- name: restart_filebeat
  systemd:
    name: filebeat
    state: restarted
```
