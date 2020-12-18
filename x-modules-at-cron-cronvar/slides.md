%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Modules Expect & Assert


<br>

Documentation Expect : https://docs.ansible.com/ansible/2.9/modules/assert_module.html

Documentation Assert : https://docs.ansible.com/ansible/2.9/modules/assert_module.html

<br>

Objectifs : Compléter un input/prompt, tester des résultats


<br>

EXPECT

```
The given command will be executed on all selected nodes. It will not be processed through the shell, so variables like $HOME and operations like "<", ">", "|", and "&" will not work.

/bin/bash -c "/path/to/something | grep else"
```

* chdir : changement de directory pour lancer la commande

* command : la commande à lancer

* creates : check de l'existence d'un fichier et si il existe la tâche n'est pas lancée

* echo : vouloir récupérer le résultat de l'output

* removes : inverse de create, si le fichier n'existe pas la commande n'est pas lancée

* timeout : temps d'attente du retour de la commande (30s)

---------------------------------------------------------------------------------------------------

# ANSIBLE : Modules Expect & Assert


<br>

ASSERT

* fail_msg : message en cas d'erreur

* quiet : éviter le mode verbose

* success_msg

* that : les tests

<br>

* commençons par un petit script

```
#!/bin/bash
read -p "Quel est ton prénom ?" prenom
echo "Ton prénom est ${prenom}"
read -p "Tu habites où ?" ville
echo "et tu habites ${ville}"
```

---------------------------------------------------------------------------------------------------

# ANSIBLE : Modules Expect & Assert

<br>

* nous allons utiliser ansible en mode local pour réviser

```
- name: local test
  hosts: 127.0.0.1
  connection: local
  tasks:
```

<br>

* et tester notre script avec expect pour compléter les inputs

```
  - name: expect
    expect:
      echo: yes
      command: hello.sh
      chgdir: "{{ lookup('env','HOME') }}/playground/expect/"
      responses:
        (.*)prénom(.*): "Xavki"      
        (.*)ville(.*): "Caen"
    register: __output_script
```

---------------------------------------------------------------------------------------------------

# ANSIBLE : Modules Expect & Assert

<br>

* et bien sûr on debug

```
  - name: output
    debug:
      var: __output_script
```

<br>

* et si on testait le résultat ?

```
  - name: test prénom
    assert:
      that:
        - "'xavki' in __output_script.stdout_lines[1]"
        - "{{ __output_script.stdout_lines[3] | length }} > 4"
        - ansible_os_family == "Debian"

  - name: output
    debug:
      var: __output_script
```

Rq : filtres jinja > capture, regex, remplace, longueur, majususcule...
