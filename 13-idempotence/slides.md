%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Idempotence et Stateful


<br>

Doc : https://docs.ansible.com/ansible/latest/modules/file_module.html
Commande : ansible-doc file

<br>

* différence importante entre ansible et terraform

		* terraform = idempotence et stateful
		* ansible = idempotence et stateless

<br>

* touch avec idempotence

```
  - name: touch idempotent
    file:
      path: /tmp/xavki.txt
      state: touch
      mode: 0755
      modification_time: preserve
      access_time: preserve
```

<br>

* à l'inverse

```
  - name: dir sans idempotence
    file:
      path: /tmp/xavki/1/2/3
      state: touch
      mode: 0755
      modification_time: now
      access_time: now
```


---------------------------------------------------------------------------------


# ANSIBLE : Idempotence et Stateful



<br>

* idemportence > existance strictement

* stateful > existance/inexistance

cf Terraform


<br>

ex :

* je créé une VM

		* terraform la créé et l'ajoute à son .state (database)

		* ansible la créé et c'est tout

<br>


* je supprime la variable de la VM (sa ressource)

		* terraform compare avec son state et se rend compte qu'une machine existait et 
			qu'il faut la supprimer

		* ansible connait pas ce qu'il a déjà fait donc ne sait as qu'il doit supprimer
			sauf si vous gérez vous même un système de recensement etc


