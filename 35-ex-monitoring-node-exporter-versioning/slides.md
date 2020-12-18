%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Ex - Monitoring > node exporter


<br>

Objectif : mettre à jour node exporter

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

* collecter la version : comment ?
		* via le binaire (go en command line ???)
		* curl (il faut qu'il tourne ???)
		* via la conf du service | provoquer le restart si modification

<br>

* ajout d'une version dans la conf du service systemd

```
[Unit]
Description=Node Exporter Version {{ node_exporter_version }}
After=network-online.target
```

<br>

* on récupère la version via le module shell

```
- name: if node exporter exist get version
  shell: "cat /etc/systemd/system/node_exporter.service | grep Version | sed s/'.*Version '//g"
  when: __check_node_exporter_present.stat.exists == true
  changed_when: false
  register: __get_node_exporter_version
```

<br>

* on conditionne le téléchargement et le clean

```
when: __check_node_exporter_present.stat.exists == false or not __get_node_exporter_version.stdout == node_exporter_version
```
