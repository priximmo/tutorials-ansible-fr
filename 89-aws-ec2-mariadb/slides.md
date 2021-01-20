%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : AWS - Installation de Mariadb

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

# ANSIBLE : AWS - Installation de Mariadb et son volume


<br>

* création d'un playbook


```
- name: Install Mariadb
  remote_user: ubuntu
  hosts: mariadb
  become: yes
  tasks:
```

Rq : remote_user, become, group mariadb (cf inventory)


-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de Mariadb


<br>

* on formate le fs

```
  - name: formatting the volume
    filesystem:
      dev: /dev/xvdf
      fstype: xfs
```

<br>

* création préalable du répertoire

```
  - name: create mysql dir
    file:
      path: /var/lib/mysql
      state: directory
      owner: ubuntu
      group: ubuntu
      mode: 0775
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de Mariadb

<br>

* montage

```
  - name: mounting the filesystem
    mount:
      src: /dev/xvdf
      opts: noatime
      name: /var/lib/mysql
      fstype: xfs
      state: mounted
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de Mariadb

<br>

* installation de mariadb + pymysql (attention update)

```
  - name: install mariadb
    apt:
      update_cache: yes
      state: present

  - name: install mariadb
    apt:
      name: mariadb-server,python3-pymysql
      update_cache: yes
      state: present

  - name: start mariadb
    service:
      name: mariadb
      state: started
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de Mariadb

<br>

* création de la db et du user:

```
  - name: Create DB
    become_user: root
    mysql_db:
      name: "{{ mysql_db }}"
      login_unix_socket: /var/run/mysqld/mysqld.sock

  - name: Create user
    become_user: root
    mysql_user:
      name: "{{ mysql_user }}"
      password: "{{ mysql_password }}"
      priv: "*.*:ALL"
      host: '%'
      login_unix_socket: /var/run/mysqld/mysqld.sock
```

-----------------------------------------------------------------------------------------------------

# ANSIBLE : AWS - Installation de Mariadb

<br>

* écoute toutes les interfaces :

```
  - name: "[MYSQL] - change my.cnf"
    lineinfile:
      dest: "/etc/mysql/my.cnf"
      line: "{{ item }}"
    with_items:
      - "[mysqld]"
      - "bind-address  = 0.0.0.0"
      - "# skip-networking"
```

<br>

* on restart (on verra plus tard pour plus propre ;)

```
  - name: start mariadb
    service:
      name: mariadb
      state: restarted
```
