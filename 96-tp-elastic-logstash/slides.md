%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP ELK ET MONITORING - LOGSTASH

<br>

Documentation : https://galaxy.ansible.com/elastic/elasticsearch

Objectifs : Elargir notre stack monitoring et logging + callback logstash à venir


<br>

* Stack vagrant :

```
	* 1 elasticsearch + logstash + kibana
	* 1 elasticsearch + logstash
```

<br>

* initier un role logstash et ajout au playbook


* s'assurer que l'on peut faire du https pour apt

```
- name: ensure apt-transport-https is installed
  apt:
    name: apt-transport-https
    state: present
```

---------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - LOGSTASH


<br>

* ajout de la clef gpg du dépôt elastic

```
- name: Debian - Add Elasticsearch repository key
  apt_key:
    url: "{{ logstash_elastic_url }}/GPG-KEY-elasticsearch"
    id: "46095ACC8548582C1A2699A9D27D666CD88E42B4"
    state: present
```

<br>

* ajout du dépôt dans les sources

```
- name: Debian - Add elasticsearch repository
  apt_repository:
    repo: "deb {{ logstash_elastic_url }}/packages/{{ logstash_elastic_version }}/apt stable main"
    state: present
```

---------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - LOGSTASH


<br>

* installation de logstash


```
- name: install logstash
  apt:
    name: logstash
    state: present
    update_cache: yes
    cache_valid_time: 3600
```

<br>

* ajout du user logstash

```
- name: add user for logstash
  user:
    name: logstash
    group: logstash
    groups: adm
  notify: restart logstash
```

---------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - LOGSTASH


<br>

* création d'un fichier de configuration par défaut

```
- name: create the default configuration file
  template:
    src: "{{ item }}.j2"
    dest: "/etc/logstash/conf.d/{{ item }}"
    owner: logstash
    group: logstash
    mode: 0644
  with_items:
    - default.conf
  notify: restart logstash
```

---------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - LOGSTASH


<br>

* démarrer logstash

```
- name: ensure logstash is started
  service:
    name: logstash
    state: started
    enabled: yes
```

<br>

* ajout du handler :

```
- name: restart logstash
  service:
    name: logstash
    state: restarted
```

---------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - LOGSTASH


<br>

* fichier de template

```
input {
  tcp {
    port => 5000
    codec => json
  }
}
filter {

}
output {
  elasticsearch {
    hosts => ["{{ ansible_host }}:9200"]
    index => "ansible-%{+YYYY.MM.dd}"
  }
}
```

---------------------------------------------------------------------------------

# ANSIBLE : TP ELK ET MONITORING - LOGSTASH


<br>

* les variables

```
logstash_elastic_url: "https://artifacts.elastic.co"
logstash_elastic_version: "7.x"
logstash_elastic_key_apt_id: "46095ACC8548582C1A2699A9D27D666CD88E42B4"
```
