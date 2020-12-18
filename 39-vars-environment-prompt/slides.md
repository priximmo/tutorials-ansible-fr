%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Variables d'environnement et prompt


<br>

Documentation : 
https://docs.ansible.com/ansible/latest/user_guide/playbooks_environment.html


Objectifs : Définir des variables d'environnement et utiliser un prompt


<br>

* différents endroits pour définir les variables d'environnement
	* playbook
	* tasks

<br>

* définition de la variable et utilisation

```
  environment:
    PATHLIB: "/var/lib/"
	tasks:
  - name: echo
    shell: echo $PATHLIB
    register: __output
  - name: print
    debug:
      var: __output
```

------------------------------------------------------------------------------------

# ANSIBLE : Variables d'environnement et prompt


<br>

* var prompt : interrogation de l'utilisateur

```
  vars_prompt:
    - name: nom
  tasks:
  - name: echo
    shell: "echo Salut {{ nom }}"
    register: __output
  - name: print
    debug:
      var: __output
```

<br>

* avec phrase et valeur par défaut

```
  vars_prompt:
  - name: env
    prompt: "Quel est votre environnement ? prod/stage/dev"
    default: dev
  environment:
    ENV: "{{ env }}"
  tasks:
  - name: echo
    shell: "echo Salut $ENV"
    register: __output
  - name: print
    debug:
      var: __output
```

------------------------------------------------------------------------------------

# ANSIBLE : Variables d'environnement et prompt


<br>

* variable d'environnement de la machine ansible

```
  - name: echo
    shell: "echo {{ lookup('env', 'ENV') | default('stage', True) }}"
    register: __output
  - name: print
    debug:
      var: __output
```
