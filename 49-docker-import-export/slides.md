%title: ANSIBLE
%author: xavki


# ANSIBLE : module docker_infos


<br>
* Objectif : lister avec docker et réutiliser

Documentation :
https://docs.ansible.com/ansible/latest/collections/community/general/docker_host_info_module.html


<br>
Prérequis :

	* docker

	* python3-docker ou pip3 install docker

<br>






- hosts: build_host
  gather_facts: no
  tasks:
    - name: archive container image as a tarball
      docker_image:
        name: democontainer:v1.0
        archive_path: /root/democontainer_v1_0.tar
        source: pull
        state: present
    - name: fetch archived image
      fetch:
        src: /root/democontainer_v1_0.tar
        dest: ./democontainer_v1_0.tar
        flat: true
