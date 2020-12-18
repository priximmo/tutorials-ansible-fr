%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Register - Stat


<br>

Documentation : https://docs.ansible.com/ansible/latest/modules/stat_module.html

Paramètres :

* path : chemin du fichier ou répertoire

* follow : suivre les liens symboliques

* get_checksum  : récupérer la checksum

* checksum_algorithm : type de checksum (md5, etc)

* get_mime: récupération du type de données 

--------------------------------------------------------------

# ANSIBLE : Register - Stat


<br>

* création d'un fichier

```
  - name: création d'un fichier
    file:
      path: /tmp/xavki.txt
      state: touch
      owner: xavki
```

<br>

* utilisation de stat

```
  - name: check avec stat
    stat:
      path: /tmp/xavki.txt
```

<br>

* récupération de la variable

```
  - name: check avec stat
    stat:
      path: /tmp/xavki.txt
    register: __fichier_xavki_exist
  - name: debug
    debug:
      var: __fichier_xavki
```

--------------------------------------------------------------

# ANSIBLE : Register - Stat


<br>

* récupération d'une clef

```
  - name: debug
    debug:
      var: __fichier_xavki.stat.exists
```

<br>

* utilisation conditionnnel

```
  - name: création répertoire xavki
    file:
      path: /tmp/xavki
      state: directory
    when: __fichier_xavki.stat.exists
```

<br>

* exemple: 

```
  tasks:
  - name: création d'un fichier
    file:
      path: /tmp/xavki.txt
      state: touch
      owner: root
    when: xavki_file is defined
  - name: check avec stat
    stat:
      path: /tmp/xavki.txt
    register: __fichier_xavki
  - name: debug
    debug:
      var: __fichier_xavki.stat.exists
  - name: création répertoire xavki
    file:
      path: /tmp/xavki
      state: directory
    when: __fichier_xavki.stat.exists and xavki_file is defined
```
