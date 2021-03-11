%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE INSTALLE ANSIBLE-PULL ???

<br>

1- playbook pour installer ansible-pull
		* ansible-pull
		* clef ssh privée
    * cron

2- run du playbook

3- mise à jour du dépôt distant

--------------------------------------------------------------

# ANSIBLE INSTALLE ANSIBLE-PULL ???


<br>

* création de l'inventaire

```
all:
  hosts:
    ans2:
    ans3:
    ans4:
    ans5:
    ans6:
    ans7:
```

--------------------------------------------------------------

# ANSIBLE INSTALLE ANSIBLE-PULL ???


<br>

* création du playbook

```
- name: install ansible-pull
  hosts: all
  become: yes
  tasks:
```

--------------------------------------------------------------

# ANSIBLE INSTALLE ANSIBLE-PULL ???

<br>

* installation de ansible-pull

```
  - name: install ansible
    apt:
      name: ansible,sshpass
      state: present
      cache_valid_time: 3600
      update_cache: yes
```

--------------------------------------------------------------

# ANSIBLE INSTALLE ANSIBLE-PULL ???


<br>

* création d'un répertoire si nécessaire

```
  - name: create ssh dir
    file:
      path: /home/vagrant/.ssh/
      mode: 0700
      owner: vagrant
      group: vagrant
```

--------------------------------------------------------------

# ANSIBLE INSTALLE ANSIBLE-PULL ???

<br>

* pousser une clef (privée pour joindre gitlab)


```
  - name: push private key
    copy:
      content: "{{ pull_ssh_key_private }}"
      dest: /home/vagrant/.ssh/id_rsa
      mode: 0600
```

* run

```
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory.yml install_ansible_pull.yml
```

--------------------------------------------------------------

# ANSIBLE INSTALLE ANSIBLE-PULL ???


<br>

* installation du cron pour ansible-pull

```
  - name: install pull cron
    cron:
      name: ansible-pull
      cron_file: ansible-pull
      user: root
      job: "ansible-pull -U git@gitlab.com:xavki/my_ansible_pull.git --clean --purge --full --private-key /home/vagrant/.ssh/id_rsa --accept-host-key -i inventory.yml 2>&1 >> /var/log/ansible-pull.log" 
```
