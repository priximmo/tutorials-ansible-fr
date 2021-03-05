%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : PULL

<br>

* pull à partir d'un playbook d'un dépôt git

* chaque serveurs est responsable de son run

* performance

sudo apt install -y python ansible 

cat local.yml 

- name: ansible pull
  connection: local
  hosts: localhost
  become: true
  become_user: root

  tasks:

  - name: install nginx
    apt:
      name: nginx
      update_cache: yes
      
  - name: start nginx
    shell: systemctl start nginx





