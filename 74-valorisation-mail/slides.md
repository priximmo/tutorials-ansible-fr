%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP VALORISATION FACTS - Part 4 - valorisation mail

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

# ANSIBLE : TP VALORISATION FACTS - Part 4 - valorisation mail


<br>

Documentation : https://docs.ansible.com/ansible/latest/collections/community/general/mail_module.html

<br>

* création d'une autre page html

```
  - name: pages machine
    template:
      src: "{{ item.src }}"
      dest: "/var/www/html/{{ item.dest }}"
    delegate_to: 172.17.0.2
    run_once: yes
    with_items:
    - { src: "global_db.html.j2", dest: "global_db.html" }
```

<br>

* récupération du fichier généré localement

```
  - name: test
    fetch:
      src: "/var/www/html/global_db.html"
      dest: "collect_files/recap_mail.html"
      flat: yes
    run_once: yes
    delegate_to: 172.17.0.2
```

----------------------------------------------------------------------------

# ANSIBLE : TP VALORISATION FACTS - Part 4 - valorisation mail


<br>

* envoi du fichier par mail

```
  - name: Send email
    mail:
      host: smtp.gmail.com
      username: "{{ vault_email_user }}"
      password: "{{ vault_email_pwd }}"
      port: 587
      subject: "States of your DB"
      body: "{{ lookup('file', 'collect_files/test.html') }}"
      from: "{{ vault_email_user }}"
      to: "{{ vault_email_user }}"
      headers:
      - Reply-To=moi@moi.fr
      subtype: html
      charset: us-ascii
    run_once: yes
    delegate_to: 127.0.0.1
    become: no
```
