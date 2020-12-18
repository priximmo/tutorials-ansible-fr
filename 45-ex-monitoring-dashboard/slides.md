%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Ex - monitoring > grafana



<br>

Précédement : 
	1- installation node exporter
	2- installation prometheus
	3- installation grafana
  4> installation d'un dashboard

<br>

* variables

```
grafana_admin_user: "admin"
grafana_admin_password: "password"
```

<br>

* 

```
- name: change admin user
  lineinfile:
    path: /etc/grafana/grafana.ini
    regexp: "{{ item.before }}"
    line: "{{ item.after }}"
  with_items:
  - { before: "^;admin_user = admin", after: "admin_user = {{ grafana_admin_user }}"}
  - { before: "^;admin_password = admin", after: "admin_password = {{ grafana_admin_password }}"}
```

---------------------------------------------------------------------------

# ANSIBLE : Ex - monitoring > grafana

<br>

* installation d'une datasource grafana

```
- name: add prometheus datasource
  grafana_datasource:
    name: "prometheus-local"
    grafana_url: "http://127.0.0.1:3000"
    grafana_user: "{{ grafana_user_admin }}"
    grafana_password: "{{ grafana_admin_password }}"
    org_id: "1"
    ds_type: "prometheus"
    ds_url: "http://prometheus:9090"
  changed_when: false
```

<br>

* download dun dashboard (node exporter)

```
- name: install node exporter dashboard
  get_url:
    url: https://raw.githubusercontent.com/rfrail3/grafana-dashboards/master/prometheus/node-exporter-full.json
    dest: /var/lib/grafana/node-exporter.json
    mode: '0755'
```

<br>

* référencement du dashboard

```
- name: activate dashboard for node exporter
  template:
    src: dashboard-node-exporter.yml.j2
    dest: /etc/grafana/provisioning/dashboards/dashboard-node-exporter.yml
    mode: 0755
  notify: restart_grafana
```

---------------------------------------------------------------------------

# ANSIBLE : Ex - monitoring > grafana


<br>

* fichier template

```
apiVersion: 1
providers:
- name: 'node-exporter'
  orgId: 1
  folder: ''
  type: file
  disableDeletion: false
  updateIntervalSeconds: 10 
  options:
    path: /var/lib/grafana/node-exporter.json
```

<br>

* création du handlers

```
- name: restart_grafana
  systemd:
    name: grafana-server
    state: restarted
    enabled: yes
    daemon_reload: yes
```

