%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP VALORISATION FACTS - Part 6 - valorisation par database - ex : elasticsearch

<br>

Objectif ?

	* créer un ensemble de serveurs

	* y ajouter des mariadb

	* y injecter des données de manière aléatoire

	* récupérer des infos : facts et commandes

	* valorisation par web

	* valorisation par mail

	* valorisation par bases de données


>> plusieurs vidéos :
		* module mariadb
		* set_facts
		* manipualtion jinja
		* module fetch
		* module shell
		* templating...

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 6 - valorisation par database


<br>

* ajout d'un rôle

```
- name: copy some files
  hosts: all
  become: yes
  roles:
  - collect
  - valo_web
  - valo_es
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 6 - valorisation par database


<br>

* récupération des éléments de dates et heures


```
  - name: date without cache
    shell: "date +%Y-%m-%d"
    register: shell_date

  - name: hour without cache
    shell: "date +%H"
    register: shell_hour

  - name: date iso without cache
    shell: "date --iso-8601=seconds"
    register: shell_date_iso

  - set_fact:
      date: "{{ shell_date.stdout }}"
      hour: "{{ shell_hour.stdout }}"
      date_iso: "{{ shell_date_iso.stdout }}"
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 6 - valorisation par database


<br>

* création du json avec les datas à insérer

```
- name: generate json
  template:
    src: es.json.j2
    dest: collect_files/inject.json
  delegate_to: 127.0.0.1
  become: no
  run_once: yes
```

<br>

* push des datas dans elasticsearch

```
- name: push json to ES
  shell: "curl -X POST '192.168.20.102:9200/_bulk' -H 'Content-Type: application/x-ndjson' --data-binary '@collect_files/inject.json'"
  delegate_to: 127.0.0.1
  become: no
  run_once: yes
```

