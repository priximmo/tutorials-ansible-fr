%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : MODULE FIND

<br>

Documentation : https://docs.ansible.com/ansible/latest/collections/ansible/builtin/find_module.html

Objectifs : comme la commande find


<br>

PARAMETRES

<br>

* age : fichier plus vieux ou égale à

<br>

* age_stamp : type de comparaison d'age (mtime / atime / ctime )

<br>

* contains : pattern sur le contenu du fichier

<br>

* depth : profondeur

-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE FIND
<br>

* excludes : patterns d'exclusion (liste)

<br>

* file_type : any / directory / file / link

<br>

* follow : follow the symlink

<br>

* get_checksum : retrouver un fichier par son checksum

<br>

* hidden : inclusion des fichiers cachés (default : no)

<br>

* paths : liste de chemins

<br>

* patterns : sélection des fichiers

<br>

* recurse : suivre les sous répertoires (défaut non)

<br>

* size : sélection sur supérieur ou égale (b,k,m,g)

<br>

* use_regex : (default no) no > pattern shell / yes > regex python




-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE FIND

<br>

* script de génération des fichiers


```
- name: playbook
  hosts: all
  tasks:

  - name: script
    become: yes
    copy:
      dest: /tmp/generate.sh
      content: |
        date +%Y%m%d%H%M.%S
        day=$(date +%d)
        year_month=$(date +%Y%m)
        time=$(date +%H%M.%S)
        echo "${year_month}${day}${time}"
        for i in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18;do
          mkdir -p tree/${i}/
          touch -t ${year_month}${i}${time} tree/${i}/xavki-${i}.txt
        done
        sleep 1
      mode: 0755

  - name: run
    become: yes
    shell: /tmp/generate.sh
```

-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE FIND

<br>

* find sur le mtime à 15d

```
  - name: find
    find:
      paths: /home/oki/tree/
      age: 1s
      age_stamp: ctime
      recurse: yes
    register: __find_files
```

-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE FIND

<br>

* ajout d'un fichier local de template pour collecter (peut être tout autre task)

```
  - name: debug
    template:
      src: template.txt.j2
      dest: "./collect/{{ ansible_hostname }}.txt"
    loop: "{{ __find_files.files }}"
    delegate_to: 127.0.0.1
```

```
{% for file in __find_files.files %}
{{ file.path }}
{% endfor %}
```

-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE FIND


<br>

* debug éventuellement

```
   - name: debug
    debug:
      msg: "{{ item.path }}"
    loop: "{{ __find_files.files }}"
```

<br>

* si sur le ctime (cf stat du fichier)

```
  - name: find
    find:
      paths: /home/oki/tree/
      age: 1s
      age_stamp: ctime
      recurse: yes
    register: __find_files
```

-----------------------------------------------------------------------------------------------------------

# ANSIBLE : MODULE FIND

<br>

* avec pattern :

```
  - name: find
    find:
      paths: /home/oki/tree/
      recurse: yes
      use_regex: yes
      patterns:
        - '^xavki-0[1-3].txt$'
        - '^xavki-1[5-8].txt$'
    register: __find_files
```
