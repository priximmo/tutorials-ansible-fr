%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Ex - monitoring > grafana



<br>

Précédement : 
	1- installation node exporter
	2- installation prometheus
	3 > installation grafana


<br>

* ajout gnupg

```
- name: install gpg
  apt:
    name: gnupg,software-properties-common
    state: present
    update_cache: yes
    cache_valid_time: 3600
```

* module apt_key :

```
- name: add gpg hey
  apt_key:
    url: "https://packages.grafana.com/gpg.key"
    validate_certs: no
```

<br>

* module apt_repository

```
- name: add repository
  apt_repository:
    repo: "deb https://packages.grafana.com/oss/deb stable main"
    state: present
    validate_certs: no
```

--------------------------------------------------------------------------

# ANSIBLE : Ex - monitoring > grafana


<br>

* installation de grafana

```
- name: install grafana
  apt:
    name: grafana
    state: latest
    update_cache: yes
    cache_valid_time: 3600
```

<br>

* démarrage du service dans tous les cas

```
- name: start service grafana-server
  systemd:
    name: grafana-server
    state: started
    enabled: yes
```

--------------------------------------------------------------------------

# ANSIBLE : Ex - monitoring > grafana

<br>

* attendre le démarrage du service

```
- name: wait for service up
  uri:
    url: "http://127.0.0.1:3000"
    status_code: 200
  register: __result
  until: __result.status == 200
  retries: 120
  delay: 1
```

<br>

* changement du password

```
- name: change admin password for grafana gui
  shell : "grafana-cli admin reset-admin-password {{ grafana_admin_password }}"
	register: __command_admin
	changed_when: __command_admin.rc !=0
```

