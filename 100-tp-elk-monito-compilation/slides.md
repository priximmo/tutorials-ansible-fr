%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP ELK + MONITORING + DOCKER SWARM

<br>

* compilation avec la vidéo 45

* ajout exporter elasticsearch et étendre le parc

<br>

```
- name: install node exporter
  become: yes
  user: vagrant
  hosts: all
  roles:
  - node_exporter

- name: install prometheus/grafana
  become: yes
  user: vagrant
  hosts: monitor
  roles: 
  - prometheus
  - grafana
```
