%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP VALORISATION FACTS - Part 4 - valorisation nginx

<br>

Objectif ?

	* créer un ensemble de serveurs

	* y ajouter des mariadb

	* y injecter des données de manière aléatoire

	* récupérer des infos : facts et commandes

	* valorisation par web

	* valorisation par mail

	* valorisation par bases de données


>> plusieurs vidéos :
		* module mariadb
		* set_facts
		* manipualtion jinja
		* module fetch
		* module shell
		* templating...

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 4 - valorisation nginx


<br>

* installation de nginx et start

```
  - name: install nginx
    apt:
      name: nginx

  - name: start nginx
    systemd:
      name: nginx
      state: started
      enabled: yes

  - name: clean
    shell: rm -rf /var/www/html/*
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 4 - valorisation nginx

<br>

* installation de la page d'accueil

```
  - name: pages machine
    template:
      src: "{{ item.src }}"
      dest: "/var/www/html/{{ item.dest }}"
    delegate_to: 172.17.0.2
    with_items:
    - { src: "index.html.j2", dest: "index.html" }
    - { src: "style.css.j2", dest: "style.css" }
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 4 - valorisation nginx

<br>

* installation des pages par serveur

```
  - name: pages machine
    template:
      src: servers.html.j2
      dest: /var/www/html/server-{{ ansible_hostname }}.html
    delegate_to: 172.17.0.2
```


