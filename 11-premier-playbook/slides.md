%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Premier Playbook & Command


<br>

* playbook : 
		* fichier déclenchant les actions à réaliser
		* sert à articuler l'inventory avec les rôles
		* peut inclure des tasks (actions) > éviter
		* peut inclure des variables (éviter autant que possible)
		* peut faire tout ce que fait un rôle (globalement) > rôle
		* spécifier quel user et comment ?

<br>

* une commande : ansible-playbook

* nombreuses options :
		* -i : inventory
<br>

		* -l : limit > spécifier un/des groupes ou serveurs ou patterns
<br>

		* -u : user
<br>

		* -b : become > sudo
<br>

		* -k : password de ssh (à éviter)
<br>

		* -K : password du sudo
<br>

		* -C : check > dry run
<br>

		* -D : diff > afficher les différences avant/après les tasks (actions)
<br>

		* --ask-vault : prompt pour le password vault
<br>

		* --syntax-check : vérfier la syntax
<br>

		* --vault-password-file : passer le vault password par un fichier
<br>

		* -e : surcharger n'importe quelle variable
<br>

		* -f : nombre de parallélisation
<br>

		* -t : filtrer sur les tags (--skip-tags)
<br>

		* --flush-cache : éviter l'utilisation du cache
<br>

		* --step : une tâche à la fois (confirmation via prompt)
<br>

		* --start-at-task : commencer à une tâche spécifiquement
<br>

		* --list-tags : lister tous les tags rencontrés
<br>

		* --list-tasks : liste les tâches qui vont être exécutées


----------------------------------------------------------------------------------------------------


# ANSIBLE : Premier Playbook & Command

<br>

* premier playbook

```
- name: Mon Playbook !!
  hosts: all
  remote_user: vagrant
  become_user: yes
  tasks:
  - name: je debug
    debug:
      msg: "{{ var1 }}"
```



