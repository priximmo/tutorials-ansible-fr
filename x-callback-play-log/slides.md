%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : CALLBACK LOG PLAYS

<br>

Documentation : https://docs.ansible.com/ansible/latest/collections/community/general/log_plays_callback.html

Objectifs : loguer par host dans des fichiers


<br>

* ajout de la collection general

```
ansible-galaxy collection install community.general
```

<br>
* modifier le ansible.cfg

```
[default]
callback_whitelist = log_plays
[callback_log_plays]
log_folder = /var/log/ansible/hosts 
```

Rq : le répertoire doit être éditable par le user qui lance le ansible

* définir des variables d'environnement

```
ANSIBLE_LOAD_CALLBACK_PLUGINS=yes
ANSIBLE_STDOUT_CALLBACK=log_plays
#ANSIBLE_LOG_PATH=$PWD/my-log #si nécessaire
```

<br>
* jouer le playbook

```
env ANSIBLE_LOAD_CALLBACK_PLUGINS=yes ANSIBLE_STDOUT_CALLBACK=log_plays ansible-playbook -vvv test.yml
```
