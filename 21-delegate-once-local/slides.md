%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Delegate, run_once, local


Documentation: https://docs.ansible.com/ansible/2.3/playbooks_delegation.html

Objectifs : gérer les run locaux ou déléguer des tâches
		* primaire/secondaire

<br>

* delegate_to : déléguer une tache à un autre serveur identifié

```
- name: premier playbook
  hosts: all
  tasks:
  - name: création de fichier
    file:
      state: touch
      path: /tmp/xavki.txt
    delegate_to: localhost
```

Rq : attention au nombre d'itération si plusieurs serveurs

<br>

* quelles variables ?

```
- name: premier playbook
  hosts: all
  tasks:
  - name: debug
    debug:
      var: var1
  - name: debug
    debug:
      var: var1
    delegate_to: localhost
```

---------------------------------------------------------------------------------------

# ANSIBLE : Delegate, run_once, local


<br>

* si on ne veut faire qu'une seule fois la tâche ?

```
  - name: création de fichier
    file:
      state: touch
      path: /tmp/xavki.txt
    delegate_to: localhost
    run_once: yes
```

<br>

* local avec ssh

```
  tasks:
  - name: local action
    local_action: "command touch /tmp/xavki2.txt"
```

<br>

* sans ssh

```
- name: premier playbook
  hosts: localhost
  connection: local
  tasks:
  - name: local action
    file:
      state: touch
      path: /tmp/xavki3.txt
```
