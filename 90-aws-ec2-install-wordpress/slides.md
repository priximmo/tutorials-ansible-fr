%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : AWS - Installation de wordpress

<br>

OBJECTIFS : 

* découvrir  des modules aws

* monter un blog wordpress

* en simplifiant les choses pour la pédagogie

* architecture


```
       |
       |
       |      +-------------------------+       +-------------------------+
       |      |  Worpdress              |       |                         |
+------------->  apache + php + code wp +------->        MariaDB          |
       |      +-------------------------+       +-------------------------+
       |
       |
       |
```


<br>

* Pré-Requis : boto & boto3

```
sudo apt python3-pip
pip3 install boto boto3 --user
```

Rq : boto n'est pas utilisable sur toutes les régions

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de wordpress


<br>

* playbook dédié à l'installation de wordpress

```
- name: Install Wordpress
  remote_user: ubuntu
  become: yes
  hosts: wordpress
  vars:
    wordpress_source: "https://wordpress.org/latest.tar.gz"
  tasks:
```

<br>

* formater le volume


```
  - name: formatting the volume
    filesystem:
      dev: /dev/xvdf
      fstype: xfs
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de wordpress

<br>

* création du répertoire 

```
  - name: create wordpress dir
    file:
      path: /var/www/html
      state: directory
      owner: ubuntu
      group: ubuntu
      mode: 0775
```

<br>

* montage du filesystem

```
  - name: mounting the filesystem
    mount:
      src: /dev/xvdf
      opts: noatime
      name: /var/www/html
      fstype: xfs
      state: mounted
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de wordpress

<br>

* installation de apache, php, lib

```
  - name: install apache
    apt:
      update_cache: yes
      cache_valid_time: 3600
      name: apache2,php7.4-common,php7.4-mysql,libapache2-mod-php7.4,wget
      state: present
```

<br>

* démarrage de apache

```
  - name: start apache
    service:
      name: apache2
      state: started
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de wordpress

<br>

* vérification si wordpress a déjà été installé

```
  - name: check if wordpress exists"
    stat:
      path: "/var/www/html/wordpress/"
    register: __check_wordpress
```

<br>

* suppression de l'index.html

```
  - name: drop file default index.html
    file:
      path: "/var/www/html/index.html"
      state: absent
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de wordpress

<br>

* téléchargement et installation de wordpress

```
  - name: download wordpress tar.gz
    unarchive:
      src: "{{ wordpress_source }}"
      dest: "/var/www/html/"
      remote_src: yes
    when: __check_wordpress.stat.exists == False
```

<br>

* vérification si le modèle de conf est présent

```
  - name: check if sample config exists
    stat:
      path: /var/www/html/wordpress/wp-config-sample.php
    register: __check_sample
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de wordpress

<br>

* copie du fichier

``` 
  - name: rename wp-config-sample.php
    copy:
      src: /var/www/html/wordpress/wp-config-sample.php
      dest: /var/www/html/wordpress/wp-config.php
      remote_src: yes
    when: __check_sample.stat.exists == True
```

<br>

* vérification de l'ip privée du mariadb

```
  - name: private ip for mariadb
    debug:
      msg: "{{ hostvars[groups['mariadb'][0]]['ansible_all_ipv4_addresses'] }}"
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de wordpress

<br>

* adaptation de la configuration wp-config.php

```
  - name: modify wp-config.php
    lineinfile:
      dest: /var/www/html/wordpress/wp-config.php
      regexp: "{{ item.search }}"
      line: "{{ item.new }}"
      backrefs: yes
    with_items:
      - {'search': '^(.*)database_name_here(.*)$', 'new': '\1{{ mysql_db }}\2'}
      - {'search': '^(.*)username_here(.*)$', 'new': '\1{{ mysql_user }}\2'}
      - {'search': '^(.*)password_here(.*)$', 'new': '\1{{ mysql_password }}\2'}
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de wordpress

<br>

* ajout de l'ip privée du mariadb

```
  - name: modify wp-config.php - mariadb dns
    replace:
      path: /var/www/html/wordpress/wp-config.php
      regexp: 'localhost'
      replace: "{{ hostvars[groups['mariadb'][0]]['ansible_all_ipv4_addresses'][0] }}"
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de wordpress

<br>

* changement de la conf apache

```
  - name: change document root in apache2
    replace:
      path: /etc/apache2/sites-available/000-default.conf
      regexp: '/var/www/html$'
      replace: "/var/www/html/wordpress"
    notify: __reload_apache
```

Rq : préférer les templates

<br>

* reload de l'apache si nécessaire

```
  handlers:
  - name: __reload_apache
    service:
      name: apache2
      state: reloaded
```


