%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Module ASSEMBLE


<br>

Documentation : https://docs.ansible.com/ansible/latest/collections/ansible/builtin/assemble_module.html

* concatener des fichiers

<br>

PARAMETRES

<br>

* backup : sauvegarde du fichier avant changement

<br>

* decrypt : déchiffrer automatiquement par défaut ou pas le vault

<br>

* delimiter : séparation entre chaque fichier

<br>

* dest : la destination (fichier)

<br>

* group : groupe du fichier de destination

<br>

* regexp : regular expression de pattern des fichiers sources

<br>

* remote_src

<br>

* src : répertoire source

<br>

* validate : commande de validation

-----------------------------------------------------------------------------------------

# ANSIBLE : Module ASSEMBLE


<br>

* simple via uniquement le remote

```
  - name: dir
    file:
      path: /tmp/sources
      state: directory
  - name: copy
    copy:
      src: "files/{{ item }}"
      dest: /tmp/sources/
    with_items:
    - t1
    - t2
    - t3
  - name: test assemble
    assemble:
      src: /tmp/sources
      dest: /tmp/myconf.cfg
```


-----------------------------------------------------------------------------------------

# ANSIBLE : Module ASSEMBLE


<br>

* ajouter un delimiter

```
delimiter: '### START FRAGMENT ###'
```

<br>

* sans remote src

```
  - name: test assemble
    assemble:
      src: files/
      dest: /tmp/myconf.cfg
      remote_src: no
```

