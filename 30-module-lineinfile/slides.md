%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Modules LINEINFILE


<br>

Documentation : 
	* https://docs.ansible.com/ansible/2.5/modules/lineinfile_module.html

<br>

PARAMETRES :

<br>

* attributes

<br>

* backrefs : pour utiliser des captures via regexp

<br>

* backup : réalise un backup avant modification

<br>

* create : si le fichier n'existe pas il est créé (default no)

<br>

* firstmatch : avec insertafter ou insertbefore s'exécute via la première occurence

<br>

* group : groupe propriétaire du fichier

<br>

* insertafter : insertion après la ligne recherché (default EOF > regex sans backrefs)

<br>

* insertbefore : idem after > mais avant la ligne

<br>

* line : ligne à ajouter ou remplacer (éventuellement avec la capture)

<br>

* mode : permissions (0755 ou u+rwx,g+rx,o+rx)

<br>

* owner : propriétaire du fichier

<br>

* path : chemin du fichier

<br>

* regexp : expression régulière permettant de rechercher la ligne (et éventuellement faire un capture)

<br>

* state : la ligne doit être présente/modifiée ou supprimée

<br>

* validate : commande de validation de la ligne

--------------------------------------------------------------------------------------

# ANSIBLE : Modules LINEINFILE


<br>

* cas le plus simple mais le moins courant : ajout d'une ligne

```
  - name: lineinfile
    lineinfile: 
      dest: /tmp/test.conf 
      line: "test"
      state: present
      create: True
```

Rq: si changement de line > nlle ligne

<br>

* recherche d'une ligne précise et modification

```
    lineinfile:
      dest: /tmp/test.conf
      line: "test 2"
      regexp: "^test$"
      state: present
      create: True
```

<br>

* modification avec capture

```
    lineinfile:
      dest: /tmp/test.conf
      line: 'je suis le nombre : \1'
      regexp: "^test ([0-2])$"
      backrefs: yes
      state: present
      create: True
```

Rq: si 2 runs attention

--------------------------------------------------------------------------------------

# ANSIBLE : Modules LINEINFILE


<br>

* commenter une ligne avec plus ou moins de précision

```
    lineinfile:
      dest: /tmp/test.conf
      line: '# \1'
      regexp: "(^je suis le nombre : [0-2])"
      backrefs: yes
      state: present
      create: True
```

<br>

* ajout avant une ligne

```
    lineinfile:
      dest: /tmp/test.conf
      line: "Ma nouvelle ligne"
      insertbefore: '# je suis le nombre : [0-2]'
      state: present
      create: True
```

Rq : idem after

--------------------------------------------------------------------------------------

# ANSIBLE : Modules LINEINFILE


<br>

* supprimer une ligne soit par regexp ou par line

```
  - name: lineinfile
    lineinfile:
      dest: /tmp/test.conf
      regexp: "^Ma nouvelle ligne"
      #line: "^Ma nouvelle ligne"
      state: absent
```

<br>

* avec backup avant modification

```
  - name: lineinfile
    lineinfile: 
      dest: /tmp/test.conf
      regexp: "^#"
      state: absent
      backup: yes
```
