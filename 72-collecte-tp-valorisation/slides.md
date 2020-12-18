%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP VALORISATION FACTS - Part 3 - collecte

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

# ANSIBLE : TP VALORISATION FACTS - Part 3 - collecte


<br>

* pour une valorisation à base de fetch (récupération de fichiers localement)

```
- name: create a directory to store all files
  hosts: localhost
  connection: local
  tasks:
  - name: create dir
    file:
      path: collect_files/
      recurse: yes
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 3 - collecte

<br>

* collecte de fichiers

```
- name: copy some files
  hosts: all
  become: yes
  tasks:
  - name: fetch
    fetch:
      src: "{{ item.src }}"
      dest: "collect_files/{{ item.dir }}/{{ item.prefix }}_{{ ansible_hostname }}.txt"
      flat: yes
    with_items:
    - { src: "/etc/hosts", dir: "etc_hosts", prefix: "hosts" }
    - { src: "/etc/resolv.conf", dir: "etc_resolv_conf", prefix: "resolv" }
    - { src: "/etc/os-release", dir: "etc_os_release", prefix: "release" }
    - { src: "/etc/passwd", dir: "etc_passwd", prefix: "passwd" }
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 3 - collecte


<br>

* collecte de facts (déjà collectés généralement)


```
  - name: state
    service_facts:
    register: __services_state

  - name: number of services 
    set_fact:
      service_up: "{{ __services_state.ansible_facts.services | length }}"
```

<br>

* calcul de la taille des db

```
  - name: size db1
    shell:  mysql -N -e "SELECT table_schema 'Data Base Name',round(sum( data_length + index_length) / 1024 / 1024, 2) 'Data Base Size in MB' FROM information_schema.TABLES where table_schema not in ('mysql', 'performance_schema', 'information_schema') GROUP BY table_schema ;" | tr '\t' ';'
    become_user: root
    register: __data_db_size_mb
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 3 - collecte

<br>

* calcul nombre de ligne par table et par db

```
  - name: size db1
    shell:  mysql -N -e "select table_schema,table_name,TABLE_ROWS from information_schema.TABLES where table_schema not in ('mysql', 'performance_schema', 'information_schema') group by TABLE_SCHEMA,table_name;"| tr "\t" ";"
    become_user: root
    register: __data_tb_rows_nb
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 3 - collecte

<br>

* si on veut voir ce que l'on a :

```
  - name: debug
    debug:
      msg: "{{ __data_db_size_mb.stdout_lines }}"

  - name: debug
    debug:
      msg: "{{ __data_tb_rows_nb.stdout_lines }}"
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 3 - collecte

<br>

* éventuellement des gather_facts

```  
  - name: disk size
    debug:
      msg: "{{ ansible_processor_cores }};{{ ansible_memory_mb.real.total }};{{ ansible_memory_mb.real.used }}"

  - name: os
    shell: "cat /etc/*elea*"
    register: __os_release
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 3 - collecte

<br>

* pourquoi par récupérer des fichiers sous forme de variables

```
  - name: sudoers
    shell: cat /etc/sudoers | grep -v "#" | grep -v -e "^[[:space:]]*$"
    register: __file_sudoers

  - name: debug
    debug:
      var: __file_sudoers
```

