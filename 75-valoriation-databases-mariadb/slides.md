%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP VALORISATION FACTS - Part 5 - valorisation par database - ex : mariadb

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

# ANSIBLE : TP VALORISATION FACTS - Part 5 - valorisation par database


<br>

* objectif > mariadb + metabase

<br>

* ajout d'un rôle

```
- name: copy some files
  hosts: all
  become: yes
  roles:
  - collect
  - valo_web
  - valo_mail
  - valo_databases
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 5 - valorisation par database

<br>

* faire un template

```
- name: pages machine
  template:
    src: mysql.sql.j2
    dest: "/tmp/mysql.sql"
  delegate_to: 172.17.0.2
  run_once: yes
```

<br>

* création de la base

```
- name: "[MYSQL] - create database"
  mysql_db:
    name:
      - collect
    login_unix_socket: /var/run/mysqld/mysqld.sock
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 5 - valorisation par database

<br>

* run du script

```
- name: run script
  shell: "mysql collect < /tmp/mysql.sql"
  become_user: root
  delegate_to: 172.17.0.2
  run_once: yes
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 5 - valorisation par database


<br>

* outil de valorisation metabase via docker sur notre localhost

```
- name: create a directory to store all files
  hosts: localhost
  connection: local
  tasks:
  - name: create dir
    file:
      path: collect_files/
      recurse: yes
  - name: run metabase
    docker_container:
      name: metabase
      image: metabase/metabase
      state: started
      detach: yes
      ports:
      - 3000:3000
```
