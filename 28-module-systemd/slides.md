%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Module Systemd


<br>

Documentation : 

Objectifs : gestion des services systemd et reload

Documentation : https://docs.ansible.com/ansible/2.5/modules/systemd_module.html

<br>

PARAMETRES :

<br>

* daemon_reexec :

<br>

* daemon_reload : exécute un reload pour prendre en compte les changements de conf systemd

<br>

* enabled : active le démarrage au boot du service

<br>

* force : écraser les liens symboliques systemd

<br>

* masked : masquer l'unité systemd

<br>

* name : nom du service systemd

<br>

* no_block : ne pas attendre la fin de l'opération pour continuer

<br>

* scope: systemd manager pour un user ou l'ensemble des users

<br>

* state : started /stopped / reloaded / restarted

<br>

* user : deprecated


-------------------------------------------------------------------------------------

# ANSIBLE : Module Systemd


<br>

* le plus simple : 

```
- name: Make sure a service is running
  systemd:
    name: haproxy
    state: started
```

<br>

* arrêt

```
- name: Make sure a service is running
  systemd:
    name: haproxy
    state: stopped
```

<br>

* activation au boot

```
- name: active to the start
  systemd:
    name: haproxy
    state: started
    enabled: yes
```

-------------------------------------------------------------------------------------

# ANSIBLE : Module Systemd


<br>

* exécuter avant si nécessaire un daemon-reload

```
- name: with daemon reload
  systemd:
    name: haproxy
    state: started
    enabled: yes
    daemon-reload: yes
```

<br>

* s'assurer sa présence dans le list-units

```
- name: no masked
  systemd:
    name: haproxy
    state: started
    enabled: yes
    daemon-reload: yes
    masked: no
```

<br>

* juste faire un daemon-reload

```
- name: just do a daemon-reload
  systemd:
    daemon-reload: yes
```
