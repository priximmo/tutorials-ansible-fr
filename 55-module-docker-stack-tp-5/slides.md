%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : module docker_stack


<br>

Documentation : 
https://docs.ansible.com/ansible/2.9/modules/docker_stack_module.html

<br>

PARAMETRES


<br>

* prérequis :

```
- name: install
  apt:
    name: python3-jsondiff
    state: present
```

<br>

* copy build et docker-compose files :

```
- name: copy myapp directory
  copy:
    src: app/
    dest: /tmp/app/
  when: inventory_hostname in groups['managers']
```

------------------------------------------------------------------------------------------

# ANSIBLE : module docker_stack


<br>

* deploiement de la stack :

```
- name: deploy stack myapp
  docker_stack:
    state: present
    name: myapp
    compose:
      - /tmp/app/docker-compose.yml
  when: inventory_hostname in groups['managers']
  run_once: yes
```

<br>

* éventuellement définir le compose dans la tâche

```
- name: compose task
  docker_stack:
    state: present
    name: mystack
    compose:
      - /opt/docker-compose.yml
      - version: '3'
        services:
          web:
            image: nginx:latest
            environment:
              ENVVAR: envvar
```
