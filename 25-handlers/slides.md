%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : LES HANDLERS


<br>

Documentation: https://docs.ansible.com/ansible/latest/user_guide/playbooks_handlers.html


* handlers = trigger/déclencheur

* exemple : vhost nginx et reload

<br>

* installation :

```
- name: premier playbook
  hosts: all
  become: yes
  vars: 
   nginx_port: 8888
  tasks:
  - name: install nginx
    apt:
      name: nginx,curl
      state: present
      cache_valid_time: 3600
      update_cache: yes
```

<br>

* suppression des vhosts default

```
  - name: remove default file
    file:
      path: "{{ item }}"
      state: absent
    with_items:
    - "/etc/nginx/sites-available/default"
    - "/etc/nginx/sites-enabled/default"
```

--------------------------------------------------------------------------------------------------------------

# ANSIBLE : LES HANDLERS


<br>

*  création du vhost dans sites-available

```
  - name: install vhost
    template:
      src: default_vhost.conf.j2
      dest: /etc/nginx/sites-available/default_vhost.conf
      owner: root
      group: root
      mode: 0644
    notify: reload_nginx 		# ajout du handlers
```

<br>

* création du lien symbolique dans sites-enabled

```
  - name: activate vhost
    file:
      src: /etc/nginx/sites-available/default_vhost.conf
      dest: /etc/nginx/sites-enabled/default_vhost.conf
      state: link
```

<br>

* dans tous les cas on start nginx 

```
  - name: start nginx
    systemd:
      name: nginx
      state: started
```

--------------------------------------------------------------------------------------------------------------

# ANSIBLE : LES HANDLERS


<br>

* on définit le handlers

```
  handlers:
  - name: reload_nginx
    systemd:
      name: nginx
      state: reloaded
```

<br>

* attention quand jouer le trigger ?

```
  - name: Flush handlers
    meta: flush_handlers
```

```
- name: Check if need to restart
  stat: 
    path: /var/run/reboot.pending
  register: __need_reboot
  changed_when: __need_reboot.stat.exists
  notify: reboot_server
```
