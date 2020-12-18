%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Ex - Monitoring > node exporter


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

* 1ère étape : Node Exporter

Source : https://github.com/prometheus/node_exporter/releases

<br>

* structure = inventory + playbook + role node exporter

----------------------------------------------------------------------------------------

# ANSIBLE : Ex - Monitoring > node exporter


<br>

LES TASKS DU ROLE

0- variables
1- check si existe
2- création du user pour le service
3- création d'un répertoire de conf (si nécessaire)
4- téléchargeent et unzip
5- déplacement dans les binaires
6- suppression du téléchargement
7- création du service systemd


<br>

* vérifier si node exporter est déjà installé 

```
- name: check if node exporter exist
  stat:
    path: "{{ node_exporter_bin }}"
  register: __check_node_exporter_present
```

----------------------------------------------------------------------------------------

# ANSIBLE : Ex - Monitoring > node exporter

<br>

* les variables

```
node_exporter_version: "1.0.1"
node_exporter_bin: /usr/local/bin/node_exporter
node_exporter_user: node-exporter
node_exporter_group: "{{ node_exporter_user }}"
node_exporter_dir_conf: /etc/node_exporter
```

<br>

* création du user qui lancera le service

```
- name: create node exporter user
  user:
    name: "{{ node_exporter_user }}"
    append: true
    shell: /usr/sbin/nologin
    system: true
    create_home: false
    home: /
```

<br>

* création du répertoire de conf (pas nécessaire)

```
- name: create node exporter config dir
  file:
    path: "{{ node_exporter_dir_conf }}"
    state: directory
    owner: "{{ node_exporter_user }}"
    group: "{{ node_exporter_group }}"
```

----------------------------------------------------------------------------------------

# ANSIBLE : Ex - Monitoring > node exporter


<br>

* download et unzip

```
- name: download and unzip node exporter if not exist
  unarchive:
    src: "https://github.com/prometheus/node_exporter/releases/download/v{{ node_exporter_version }}/node_exporter-{{ node_exporter_version }}.linux-amd64.tar.gz"
    dest: /tmp/
    remote_src: yes
  when: __check_node_exporter_present.stat.exists == false
```

<br>

* déplacement du binaire

```
- name: move the binary to the final destination
  copy:
    src: "/tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/node_exporter"
    dest: "{{ node_exporter_bin }}"
    owner: "{{ node_exporter_user }}"
    group: "{{ node_exporter_group }}"
    mode: 0755
    remote_src: yes
  when: __check_node_exporter_present.stat.exists == false
```

<br>

* nettoyage

```
- name: clean
  file:
    path: /tmp/node_exporter-{{ node_exporter_version }}.linux-amd64/
    state: absent
```

----------------------------------------------------------------------------------------

# ANSIBLE : Ex - Monitoring > node exporter


<br>

* template pour le service systemd

```
[Unit]
Description=Node Exporter
After=network-online.target
[Service]
User={{ node_exporter_user }}
Group={{ node_exporter_user }}
Type=simple
ExecStart={{ node_exporter_bin }}
[Install]
WantedBy=multi-user.target
```

<br>

* installation du template

```
- name: install service
  template:
    src: node_exporter.service.j2
    dest: /etc/systemd/system/node_exporter.service
    owner: root
    group: root
    mode: 0755
  notify: reload_daemon_and_restart_node_exporter
```


----------------------------------------------------------------------------------------

# ANSIBLE : Ex - Monitoring > node exporter


<br>

* flush du handler

```
- meta: flush_handlers

- name: service always started
  systemd:
    name: node_exporter
    state: started
    enabled: yes
```

<br>

* handler

```
- name: reload_daemon_and_restart_node_exporter
  systemd:
    name: node_exporter
    state: restarted
    daemon_reload: yes
    enabled: yes
```
