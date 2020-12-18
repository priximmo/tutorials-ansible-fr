%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP VALORISATION FACTS - Part 2 - Insertion datas

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

# ANSIBLE : TP VALORISATION FACTS - Part 2 - Insertion datas


<br>

* script d'alimentation via une procédure sql

```
CREATE TABLE IF NOT EXISTS {{ item.table }} (c1 int);
DELIMITER $$
DROP PROCEDURE IF EXISTS prepare_data;
CREATE PROCEDURE prepare_data()
BEGIN
  DECLARE i INT DEFAULT 100;
  WHILE i < {{ item.random }} DO
    INSERT INTO {{ item.table }} (c1) VALUES (i);
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;
CALL prepare_data();
DROP PROCEDURE IF EXISTS prepare_data;
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 2 - Insertion datas

<br>

* ajout du script sur les machines distantes

```
  - name: script to inject data
    template:
      src: inject.sql.j2 
      dest: /tmp/inject.sql
    with_random_choice:
    - { table: "t1", random: "1000" }
    - { table: "t1", random: "10000" }
    - { table: "t1", random: "8000" }
    - { table: "t2", random: "2000" }
    - { table: "t2", random: "4000" }
    - { table: "t2", random: "6000" }
    - { table: "t3", random: "2000" }
    - { table: "t3", random: "10000" }
    - { table: "t3", random: "3000" }
```

<br>

* run sur les db

```
  - name: run script
    shell: "mysql {{ item.db }} < /tmp/inject.sql"
    retries: "{{ item.repeat }}"
    with_items:
    - { db: "db1", repeat: "2" }
    - { db: "db2", repeat: "1" }
    - { db: "db3", repeat: "2" }
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 2 - Insertion datas


<br>

* test de collecte de la volumétrie de chaque base

```
  - name: size db1
    shell:  mysql -N -e "SELECT table_schema 'Data Base Name',round(sum( data_length + index_length) / 1024 / 1024, 2) 'Data Base Size in MB' FROM information_schema.TABLES where table_schema not in ('mysql', 'performance_schema', 'information_schema') GROUP BY table_schema ;" | tr '\t' ';'
    register: __data_db_size_mb
```

```
  - name: debug
    debug:
      var: __data_db_size_mb
```
