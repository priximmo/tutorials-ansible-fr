%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Modules COMMAND & SHELL


<br>

Documentation : 
https://docs.ansible.com/ansible/2.5/modules/shell_module.html
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/command_module.html

Objectifs : lancer des commandes shell

Command vs Shell > 
		command : options réduites (lance des commandes simples)
		shell : utilisation de tout ce qui est dans la CLI (pipe...)

<br>

PARAMETRES : COMMAND

<br>

* argv : ligne de commande sous forme de liste

<br>

* chdir : change de répertoire

<br>

* cmd : commande lancée

<br>

* creates : la commande n'est pas lancée si le fichier existe

<br>

* removes : inverse de creates, si le fichier existe la commande est lancée

<br>

* stdin : spécifier une valeur entrante via stdin

<br>

* stdin_add_newline : passe une ligne pour le stdin

<br>

* strip_empyt_ends : supprimer les lignes vides

<br>

* warn : activer ou désactiver le task warning

---------------------------------------------------------------------------------

# ANSIBLE : Modules COMMAND & SHELL

<br>

* simple :

```
  - name: test
    command:
      cmd: ls
    register: __output
```

<br>

* changement de directory :

```
  - name: test
    command:
      cmd: ls
      chdir: /etc/
    register: __output
```

---------------------------------------------------------------------------------

# ANSIBLE : Modules COMMAND & SHELL

<br>

* commande en liste :

```
  - name: test
    command:
      argv:
      - ls
      - -larth
    register: __output
```

<br>

* sous condition si le fichier n'existe pas

```
  - name: touch
    file:
      path: /tmp/xavki
      state: touch
  - name: test
    command: 
      cmd: ls -lath /tmp
      creates: /tmp/xavki
    register: __output
  - name: debug
    debug:
      var: __output
```

---------------------------------------------------------------------------------

# ANSIBLE : Modules COMMAND & SHELL

<br>

* inverse : si il existe

```
  - name: test
    command: 
      cmd: ls -lath /tmp
      removes: /tmp/xavki
```


---------------------------------------------------------------------------------

# ANSIBLE : Modules COMMAND & SHELL


<br>

PARAMTRES : SHELL

<br>

* chdir : changement de répertoire d'exécution

<br>

* creates : la commande est lancée si le fichier n'existe pas

<br>

* executable : choix du shell utilisé

<br>

* removes : inverse de creates

<br>

* stdin : définir un stdin

<br>

* warn : afficher ou non les warn

---------------------------------------------------------------------------------

# ANSIBLE : Modules COMMAND & SHELL


<br>

* exemple simple :

```
  - name: test
    shell: cat /etc/hosts | grep 127
    register: __output
  - name: debug
    debug:
      var: __output
```

<br>

* exemple avec un bloc

```
  - name: test
    shell: |
      cat /etc/hosts
      ls /etc/
    register: __output
  - name: debug
    debug:
      var: __output
```

<br>

* exemple avec des variables d'environnement

```
  - name: test
    shell: echo "Hello $MAVAR"
    environment:
      MAVAR: "xavki"
    register: __output
```
