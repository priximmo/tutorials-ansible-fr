%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : oneline modules



<br>

* module command

```
ansible -i "node2," all -u vagrant -m command -a uptime
```

* module shell 

```
ansible -i "node2," all -u vagrant -m shell -a "ps aux | grep vagrant | wc -l" --one-line
```

<br>

* exemple raw (sans python)

```
sudo apt autoremove --purge git
ansible -i "node2," all -u vagrant -b -K -m raw -a "apt install -y git"
```

<br>

* module apt

```
ansible -i "node2," all -b -m apt -a 'name=nginx state=latest'
```

<br>

* arrêt d'une service

```
ansible -i "node2," all -b -m service -a 'name=nginx state=stopped'
```

------------------------------------------------------------------------------------------------------

# ANSIBLE : oneline modules



<br>

* faire un scp ??

```
ansible -i "node2," all -m copy -a 'src=toto.txt dest=/tmp/titi.txt'
```

<br>

* récupérer un fichier

```
ansible -i "node2," all -m fetch -a 'src=/tmp/titi.txt dest=xavki.txt flat=yes'
```

<br>

* lister les gathers facts

```
ansible -i "node2," all -m setup -a "filter=ansible_distribution*"
```
