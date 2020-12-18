%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# Fichiers de configuration



<br>

* configuration de différentes manières :
    * ansible.cfg
    * cli

<br>

* et à différents endroits pour ansible.cfg (ordre inverse de prise en compte)
    * éventuellement en définissant ANSIBLE_CONFIG
    * à l'endroit de votre playbook ansible.cfg
    * ~/.ansible/ansible.cfg
    * /etc/ansible/ansible.cfg

<br>

* exemple : 

```
inventory       = /etc/ansible/hosts
forks           = 5
sudo_user       = root
ask_sudo_pass   = True
ask_pass        = True
gathering       = implicit
gather_subset   = all
roles_path      = /etc/ansible/roles
log_path        = /var/log/ansible.log
vault_password_file = /path/to/vault_password_file
fact_caching_connection =/tmp
pipelining = False
```

Doc : https://docs.ansible.com/ansible/2.3/intro_configuration.html

-------------------------------------------------------------------------------------------------------------

# Fichiers de configuration


<br>

* commande : 

```
ansible-config
ansible-config view  # voir le ansible.cfg pris en compte
ansible-config list  # toute les variables et leurs valeurs
cf : https://docs.ansible.com/ansible/latest/reference_appendices/config.html

ansible-config dump  # liste toutes les variables ansible
ansible-config dump --only-changed #valeurs par défaut modifiée
```
* exemple

<br>

```
ANSIBLE_SSH_ARGS:
  default: -C -o ControlMaster=auto -o ControlPersist=60s
  description:
  - If set, this will override the Ansible default ssh arguments.
  - In particular, users may wish to raise the ControlPersist time to encourage performance.  A
    value of 30 minutes may be appropriate.
  - Be aware that if `-o ControlPath` is set in ssh_args, the control path setting
    is not used.
  env:
  - name: ANSIBLE_SSH_ARGS
  ini:
  - key: ssh_args
    section: ssh_connection
  yaml:
    key: ssh_connection.ssh_args
```

-------------------------------------------------------------------------------------------------------------

# Fichiers de configuration : tuning


<br>

* host key checking = fingerprint

```
[defaults]
host_key_checking = False
```

<br>

* callback temps par action

```
[defaults]
callback_whitelist = profile_tasks
```

<br>

* pipelining

```
[ssh_connection]
pipelining = True
```

<br>

Principe par défaut :
  * création fichier python
  * création directory
  * envoi fichier python via sftp
  * run python
  * récupération résultat

<br>

Avec pipelining :
  * génération du fichier python
  * envoi sur le python interpreter distant via stdin
  * récupération du stdout


Rq: travailler sans fichier distant


-------------------------------------------------------------------------------------------------------------

# Fichiers de configuration : tuning


<br>

* partage de plusieurs sessions et augmentation de la persistence (connexion...)

```
[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s
```

Doc : https://www.blog-libre.org/2019/05/11/loption-controlmaster-de-ssh_config/

<br>

* spécifier le mode d'identification

```
[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o PreferredAuthentications=publickey
```

<br>

* fork = parallélisation

```
[defaults]
forks = 30
```

-------------------------------------------------------------------------------------------------------------

# Fichiers de configuration : tuning


<br>

* gather facts avec précaution

```
gather_facts: no
```

<br>

* gather facts caching par fichier

```
fact_caching = jsonfile
fact_caching_timeout = 3600
fact_caching_connection = /tmp/mycachedir
```

<br>

* gather facts caching par redis


```
fact_caching = redis
fact_caching_timeout = 3600
fact_caching_connection = localhost:6379:0
```

<br>

* Mitogen

Doc : https://mitogen.networkgenomics.com/ansible_detailed.html

<br>

* cas ultime > ansible localhost  >> ansible-pull (commande)
  * chargement du code ansible sur le serveur distant
      * cloud init > cron > ansible-pull
  * exécution en localhost
  * problème récupération des informations
