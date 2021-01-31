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


- name: Debian - Install apt-transport-https to support https APT downloads
  apt:
    name: apt-transport-https
    state: present

- name: Debian - Add Elasticsearch repository key
  apt_key:
    url: "https://artifacts.elastic.co/GPG-KEY-elasticsearch"
    id: "46095ACC8548582C1A2699A9D27D666CD88E42B4"
    state: present

- name: Debian - Add elasticsearch repository
  apt_repository:
    repo: "deb https://artifacts.elastic.co/packages/7.8.0/apt stable main"
    state: present

- name: Install Logstash.
  apt:
    name: logstash
    state: present

- name: Add Logstash user to adm group (Debian).
  user:
    name: logstash
    group: logstash
    groups: adm
  notify: restart logstash

- name: Create Logstash configuration files.
  template:
    src: "{{ item }}.j2"
    dest: "/etc/logstash/conf.d/{{ item }}"
    owner: root
    group: root
    mode: 0644
  with_items:
    - default.conf
  notify: restart logstash

- name: Ensure Logstash is started and enabled on boot.
  service:
    name: logstash
    state: started
    enabled: yes



* handlers :

```
- name: restart logstash
  service:
    name: logstash
    state: restarted
```

* templates

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
