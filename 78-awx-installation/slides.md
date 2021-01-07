%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : AWX INSTALLATION


<br>
Différentes installations :
	* paquets redhat
	* docker/compose
	* openshift
	* kubernetes (chart helm)

Documentation : https://github.com/ansible/awx/blob/devel/INSTALL.md

Role de Jeff Geerling : https://github.com/geerlingguy/ansible-role-awx

<br>

* installation de docker

```
sudo curl -fsSL https://get.docker.com -o get-docker.sh 2>&1
sudo sh get-docker.sh 2>&1 >/dev/null
sudo service docker start
sudo usermod -aG docker vagrant
```

<br>

* installation de docker-compose

```
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod 755 /usr/local/bin/docker-compose
```

----------------------------------------------------------------------------------------

# ANSIBLE : AWX INSTALLATION

<br>

* installation de ansible

```
sudo apt install -y ansible
```

<br>

* téléchargement du dépôt awx

```
git clone https://github.com/ansible/awx
```

<br>

* installation de pip et les libs docker

```
sudo apt install -y python3-pip
pip3 install docker docker-compose --user
```

<br>

* adaptation de la configuration (passwords...)

```
cd installer/
vim inventory
```


