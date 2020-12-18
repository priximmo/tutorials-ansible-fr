%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Check & Reboot


Documentation: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/reboot_module.html

Objectifs : rebooter des machines sous conditions et reprendre après

<br>

PARAMETRES :

<br>

* boot_time_command : command qui génère l'id de reboot

<br>

* connect_timeout : timeout de la connexion en seconde

<br>

* msg : message délivré avant le reboot

<br>

* post_reboot_delay : temps d'attente en secondes après le reboot pour continuer

<br>

* pre_reboot_delay : délai avant de lancer le reboot

<br>

* reboot_timeout : timeout du reboot lui-même

<br>

* search_paths : path pour la commande shutdown

<br>

* test_command  : commande de test pour confirmer le succés du reboot

-----------------------------------------------------------------------------------------------------


# ANSIBLE : Check & Reboot


<br>

* démonstration avec de simples fichiers

```
- name: mon premier playbook
  hosts: all
  remote_user: vagrant
  become: yes
  tasks:
  - name: create file
    file:
      path: /tmp/xavki.txt
      state: touch
```

<br>

```
  - name: test
    stat:
      path: /tmp/xavki.txt
    register: __file_exist
```

<br>

```
  - name: lancement du reboot avec reboot
    reboot:
      msg: "Reboot via ansible"
      connect_timeout: 5
      reboot_timeout: 300
      pre_reboot_delay: 0
      post_reboot_delay: 30
      test_command: uptime
    when: __file_exist.stat.exists

  - name: file2
    file:
      path: /tmp/xavki2.txt
      state: touch
```


-----------------------------------------------------------------------------------------------------


# ANSIBLE : Check & Reboot



<br>

* exemple d'une mise à jour


```
    - name: update cache
      apt:
        update_cache: yes
        force_apt_get: yes
        cache_valid_time: 3600

    - name: upgrade général
      apt:
        upgrade: dist
        force_apt_get: yes

    - name: vérification à partir du fichier reboot_required
      register: reboot_required_file
      stat:
        path: /var/run/reboot-required

    - name: lancement du reboot avec reboot
      reboot:
        msg: "Reboot via ansible"
        connect_timeout: 5
        reboot_timeout: 300
        pre_reboot_delay: 0
        post_reboot_delay: 30
        test_command: uptime
      when: reboot_required_file.stat.exists
``` 


