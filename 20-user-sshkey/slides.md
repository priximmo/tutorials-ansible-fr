%title: ANSIBLE
%author: xavki


# ANSIBLE : SSH Key et User


Documentation:
* https://docs.ansible.com/ansible/latest/collections/ansible/posix/authorized_key_module.html
* https://docs.ansible.com/ansible/latest/collections/community/crypto/openssh_keypair_module.html

Objectifs : générer une clef ssh et la déployer

Attention : où suis-je ? qui suis-je ?

<br>
PARAMETRES :



<br>
* 
- name: mon premier playbook
  hosts: all
  remote_user: vagrant
  tasks:
  - name: generate SSH key"
    openssh_keypair:
      path: /tmp/xavki
      type: rsa
      size: 4096
      state: present
      force: no
    delegate_to: localhost

  - name: création du user devops
    user:
      name: devops
      shell: /bin/bash
      groups: sudo
      append: yes
      password: "{{ 'password' | password_hash('sha512') }}"
    become: yes

  - name: Add devops user to the sudoers
    copy:
      dest: "/etc/sudoers.d/devops"
      content: "devops  ALL=(ALL)  NOPASSWD: ALL"
    become: yes

  - name: Deploy SSH Key
    authorized_key: 
      user: devops
      key: "{{ lookup('file', '/tmp/xavki.pub') }}"
      state: present
    become: yes

