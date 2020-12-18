%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Installations


<br>

* Controller node : 
		* Python >= 2.7
		* tout sauf windows
		* ssh/scp (ou sftp)

* Managed node :
		* Python >= 2.6

Documentation : https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

<br>

* Différents types d'installations :
		* paquets des distributions
		* librairie python
		* binaire
		* éventuellement par docker (abandonné depuis 2 ans)

* les différentes releases :

https://releases.ansible.com/ansible/

--------------------------------------------------------------------------------------------------------

# ANSIBLE : Installations



<br>

* via le binaire :

```
git clone https://github.com/ansible/ansible.git
cd ansible
source ./hacking/env-setup
sudo apt install python-pip
pip install --user -r ./requirements.txt
echo "127.0.0.1" > ~/ansible_hosts
export ANSIBLE_INVENTORY=~/ansible_hosts
ansible all -m ping --ask-pass
```

<br>

* via pip :

```
sudo apt install python3-pip
pip3 install ansible
```

<br>

* via les paquets des distributions (debian)

```
sudo apt install ansible
```


--------------------------------------------------------------------------------------------------------

# ANSIBLE : Installations



<br>

* remarque macOS : 
		* remonter la limite du nombre de fichiers
		* fork > 15

```
sudo launchctl limit maxfiles unlimited
```

<br>

* remarque python interpreter - par défaut /usr/bin/python

```
ansible_python_interpreter=/usr/bin/python3
```

ou installation (raw ne dépend pas de python côté client)

```
ansible myhost --become -m raw -a "yum install -y python2"
```

Doc : https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html#ansible-python-interpreter
