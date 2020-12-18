%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP VALORISATION FACTS - Part 1 - mysql

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

# ANSIBLE : TP VALORISATION FACTS - Part 1 - mysql


<br>

* script de la vidéo 14

	https://gitlab.com/xavki/presentation-ansible-fr/-/blob/master/14-plateforme-dev-docker/deploy.sh

<br>

* création du rôle et playbook

```
- name: install servers
  hosts: all
  become: yes
  roles:
  - mariadb
```

<br>

* installation de mariadb

```
  - name: install mariadb
    apt: 
      name: mariadb-server,python3-pymysql
      state: present
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 1 - mysql

<br>

* démarrage du service

```
  - name: start mariadb
    service:
      name: mariadb
      state: started
      enabled: yes
```

<br>

* création des databases


```
  - name: "[MYSQL] - create database"
    mysql_db:
      name:
        - db1
        - db2
        - db3
      login_unix_socket: /var/run/mysqld/mysqld.sock
```

Rq : login via la socket

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 1 - mysql

<br>

* création de users

```
  - name: "[MYSQL] - create user"
    mysql_user:
      name: "xavki"
      password: "password"
      priv: "*.*:ALL"
      host: '%'
      login_unix_socket: /var/run/mysqld/mysqld.sock
``` 

Rq : tous les hosts

<br>

* si connexion externe

```
  - name: "[MYSQL] - change my.cnf"
    lineinfile:
      dest: "/etc/mysql/my.cnf"
      line: "{{ item }}"
    with_items:
      - "[mysqld]"
      - "bind-address  = 0.0.0.0"
      - "# skip-networking"
    notify: __restart_mariadb
```

Rq : écoute all

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 1 - mysql


<br>

* on restart le service si nécessaire avec le handler

```
  - name: __restart_mariadb
    service:
      name: mariadb
      state: restarted
      enabled: yes
```

