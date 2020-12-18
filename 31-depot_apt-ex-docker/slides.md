%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Installation dépôt APT - ex : docker


<br>

Documentation : 
	* apt_key : https://docs.ansible.com/ansible/2.5/modules/apt_key_module.html
	* apt_repository : https://docs.ansible.com/ansible/2.5/modules/apt_repository_module.html

<br>

APT_KEY

PARAMETRES :

<br>

* data > directement fournir la clef

* file : chemin vers un fichier contenant la clef

* id : identifiant de la clef (pour la supprimer)

* keyring : le chemin vers la clef en place

* keyserver : le serveur où trouver la clef

* state : present/absent

* url : url pour télécharger la clef

* validate_certs : valider strictement ou non le certificat

---------------------------------------------------------------------------------

# ANSIBLE : Installation dépôt APT - ex : docker

Quelques exemples :

<br>

* à partir d'un fichier

```
- name: Add a key from a file on the Ansible server.
  apt_key:
    data: "{{ lookup('file', 'apt.asc') }}"
    state: present
```

<br>

* à partir d'une url

```
- name: Add an Apt signing key to a specific keyring file
  apt_key:
    id: 9FED2BCBDCD29CDF762678CBAED4B06F473041FA
    url: https://ftp-master.debian.org/keys/archive-key-6.0.asc
    keyring: /etc/apt/trusted.gpg.d/debian.gpg
```

<br>

* suppression d'une clef

```
- name: Remove a Apt specific signing key, leading 0x is valid
  apt_key:
    id: 0x9FED2BCBDCD29CDF762678CBAED4B06F473041FA
    state: absent
```

---------------------------------------------------------------------------------

# ANSIBLE : Installation dépôt APT - ex : docker


<br>

APT_REPOSITORY

PARAMETRES :

<br>

* codename : si par un ppa surcharge la distribution

<br>

* filename : nom du fichier dans /etc/apt/source.list.d/

<br>

* mode : permissions sur le fichier (0644)

<br>

* repo : dépot source

<br>

* state : present/absent

<br>

* update_cache : enchainer avec un update du cache apt

<br>

* validate_certs : validation strict du ssl


---------------------------------------------------------------------------------

# ANSIBLE : Installation dépôt APT - ex : docker


<br>

Exemple : installation docker


```
  - name: Ensure old versions of Docker are not installed.
    apt:
      name: docker,docker-engine
      state: absent

  - name: Install role dependencies.
    apt:
      name: apt-transport-https,ca-certificates,gnupg
      state: present
      autoclean: true

  - name: Add Docker apt key
    apt_key:
      url: "https://download.docker.com/linux/debian/gpg"
      state: present

  - name: Add Docker repository.
    apt_repository:
      repo: "deb [arch=amd64] https://download.docker.com/linux/debian buster stable"
      state: present
      update_cache: true

  - name: install docker
    apt:
      name: docker-ce
      state: present

  - name: start docker
    systemd:
      name: docker
      state: started
      enabled: yes
```
