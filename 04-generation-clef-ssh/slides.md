%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# SSH - Génération et Utilisation de la clef



<br>

* principe clefs
		* clef privée
		* clef privée
		* type de clef / algorithme (rsa, dsa, ecdsa)
		* longeur de clef (dépend de l'algo ecdsa 521)

<br>

* génération via ssh-keygen

```
ssh-keygen -t ecdsa -b 521
```

<br>

* spécifier la localisation de sortie

```
ssh-keygen -t ecdsa -b 521 -f /myhome/.ssh/maclefprivee
```

* ssh-keygen fourni un prompt pour vous aider

* important : ajout d'une passphrase 
		* sinon une clef ssh est plus dangereuse qu'un password

--------------------------------------------------------------------------------------

# SSH - Génération et Utilisation de la clef



<br>

* ajout de votre clef publique sur le host distant

```
vim /home/user/.ssh/authorized_keys
```

ou via ssh-copy-id

```
ssh-copy-id -i /myhome/.ssh/maclefprivee xavki@monhost
```

Remarque : specific pour une ip

```
from="10.0.0.?,*.example.com",no-X11-forwarding ssh-rsa AB3Nz...EN8w== xavki@monhost
```

<br>

* utilisation de la clef

```
ssh -i /localisation/clef/privee xavki@monhost
```

ou plus facilement par un agent ssh (embarque votre configuration ssh)

<br>

* check si un agent tourne

```
ps -p $SSH_AGENT_PID
```

* lancement d'un agent ssh

```
eval `ssh-agent`
```

* ajout de la clef à l'agent

```
ssh-add
```

* check de la clef de l'agent

```
ssh-add -l
```


--------------------------------------------------------------------------------------

# SSH - Génération et Utilisation de la clef



<br>

* attention ordre de lecture de haut en bas

<br>

* exemple

```
touch ~/.ssh/config
chmod 600 ~/.ssh/config
cat ~/.ssh/config

Host * !monhost*
    User vagrant
    Port 22
    IdentityFile /myhome/.ssh/maclefprivee
    LogLevel INFO
    Compression yes
    ForwardAgent yes
    ForwardX11 yes
```

* astuce pour bypasser la conf

```
ssh -F /dev/null xavki@monhost
```
