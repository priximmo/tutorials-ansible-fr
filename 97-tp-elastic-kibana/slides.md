%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP ELK ET MONITORING - KIBANA

<br>

Documentation : https://galaxy.ansible.com/elastic/elasticsearch

Objectifs : Elargir notre stack monitoring et logging + callback logstash à venir


<br>

* Stack vagrant :

```
	* 1 elasticsearch + logstash + kibana
	* 1 elasticsearch + logstash
```

---------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - KIBANA

<br>

* initier un role kibana

```
- name: install kibana
  become: yes
  user: vagrant
  hosts: kibana
  roles:
    - kibana
```

<br>

* s'assurer de https pour apt

```
- name: Install apt-transport-https to support https APT downloads
  apt:
    name: apt-transport-https
    state: present
```

---------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - KIBANA

<br>

* ajout du dépôt elastic (si pas déjà présent)

```
- name: Add Elastic repository key
  apt_key:
    url: "{{ kibana_elastic_url }}/GPG-KEY-elasticsearch"
    id: "46095ACC8548582C1A2699A9D27D666CD88E42B4"
    state: present

- name: Add elasticsearch repository
  apt_repository:
    repo: "deb {{ kibana_elastic_url }}/packages/{{ kibana_elastic_version }}/apt stable main"
    state: present
```

---------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - KIBANA

<br>

* installation de kibana

```
- name: Update repositories cache and install Kibana
  apt:
    name: kibana
    state: present
    update_cache: yes
    cache_valid_time: 3600
```

---------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - KIBANA

<br>

* mise à jour de la configuration de kibana

```
- name: Updating the config file to restrict outside access
  lineinfile:
    destfile: /etc/kibana/kibana.yml
    regexp: "{{ item.target }}"
    line: "{{ item.replace }}"
  with_items:
  - { target: "server.host:", replace: "server.host: 0.0.0.0"}
  - { target: "#elasticsearch.hosts", replace: "elasticsearch.hosts: [\"http://192.168.13.10:9200\"]"}
  notify: restart_kibana
```

---------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - KIBANA

<br>

* activation du service kibana

```
- name: Enabling Kibana service
  systemd:
    name: kibana
    state: started
    enabled: yes
```

<br>

* ajout du handler

```
- name: restart_kibana
  systemd:
    name: kibana
    state: restarted
```

---------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - KIBANA

<br>

* variables par défaut

```
kibana_elastic_url: "https://artifacts.elastic.co"
kibana_elastic_version: "7.x"
kibana_elastic_key_apt_id: "46095ACC8548582C1A2699A9D27D666CD88E42B4"
```
