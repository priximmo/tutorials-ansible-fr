%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : commande ansible CLI



<br>

* peu utilisé (en proportion) au profit de ansible-playbook

* permettre du test (ping, inventaire)

* permet de jouer des tâches

* beaucoup d'options similaires à la commande ansible-playbook

<br>

* test de connexions 

```
ansible -i "node2," all -u vagrant -m ping
```

<br>

* principales options à connaître :
		* -u : user distant utilisé
		* -b : passer les commandes en élévation de privilèges (sudo)
		* -k ou --ask-pass  > password SSH
		* -K ou --ask-become-pass > password pour élévation privilèges
		* -C ou --check : faire un dry run
		* -D ou --diff : avoir un output de la diff
		* --key-file : lien direct vers la clef privée
		* -e ou --extra-vars : définir des variables
		* --ask-vault-pass : déchiffrer un secret vault
		* --vault-password-file : fichier pour déchiffrer
		* -f x ou --forks : paralléliser
		* -vvv : verbose


---------------------------------------------------------------------------------------------------------------

# ANSIBLE : commande ansible CLI



<br>

* définir des paramètres ssh

```
ansible -i "node2," all -u vagrant -k --ssh-extra-args="-o 'PreferredAuthentications=password'" -m ping
```


<br>

* sshpass pour passer un password

```
sshpass -p 'vagrant' ansible -i "node2," all -u vagrant -k --ssh-extra-args="-o 'PreferredAuthentications=password'" -m ping
```

<br>

* affichage oneline

```
ansible -i "node2," all -u vagrant -m ping --one-line
```

<br>

* module command

```
ansible -i "node2," all -u vagrant -m command -a uptime
```

<br>

* passage d'une variable

```
ansible -i "node2," all -b -e "var1=xavki" -m debug -a 'msg={{ var1 }}'
```
