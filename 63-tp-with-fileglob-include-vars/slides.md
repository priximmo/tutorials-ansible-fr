%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP - Combinaison with_fileglob & include_vars


<br>

Documentation :
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/fileglob_lookup.html
https://docs.ansible.com/ansible/latest/collections/ansible/builtin/include_vars_module.html

Objectif : Parcourir des fichiers de variables identiques

<br>

Exemples :
	* vhost nginx
	* base de données
	* stacks à instancier

<br>

* Reprenons notre cluster swarm pour instancier du wordpress

* un fichier descriptif pour chaque wordpress

<br>

* deux vidéos dans cette thématique

--------------------------------------------------------------------------------------------------------------

# ANSIBLE : TP - Combinaison with_fileglob & include_vars


<br>

* disposer d'un répertoire décrivant chaque wordpress

```
mkdir -p group_vars/instances_wordpress
```

Rq : localisation au choix 

Attention : localisation du playbook

<br>

* Base d'un fichier pour une instance wordpress

```
cat group_vars/instances_wordpress/xavki.yml

deploy_wordpress_name: "xavki"
deploy_wordpress_url: "xavki.swarm"
deploy_wordpress_mariadb_user: "mariadb_xavki"
deploy_wordpress_mariadb_password: "monpassword"
deploy_wordpress_container_port: "80"
```

Rq : port 80 pour traefik, sécurité password...

--------------------------------------------------------------------------------------------------------------

# ANSIBLE : TP - Combinaison with_fileglob & include_vars

<br>

* utilisation de fileglob

```
cat roles/deploy_wordpress/tasks/main.yml

- name: "Instanciate wordpress {{ item.name }}"
  include_tasks: wordpress.yml
  with_fileglob:
  - "./group_vars/instances_wordpress/*.yml"
```

<br>

* création du fichier de task sur lequel boucler (par fichier d'instance)

```
cat roles/deploy_wordpress/tasks/wordpress.yml

- name: load vars
  include_vars: 
    file: "{{ item }}"
    name: "w"
```

Rq : w la clef des variables

--------------------------------------------------------------------------------------------------------------

# ANSIBLE : TP - Combinaison with_fileglob & include_vars

<br>

* utilisation pour la création des networks de chacun des wordpress

```
- name: create network
  docker_network:
    name: "wordpress_{{ w.deploy_wordpress_name }}"
    driver: overlay
  when: inventory_hostname in groups['managers'][0]
```

<br>

* création des volumes docker (double boucle : fichiers + with_items)

```
- name: create volume
  docker_volume:
   name: "{{ loop_item }}_{{ w.deploy_wordpress_name }}"
   driver_options:
      type: "nfs"
      o: "addr={{ groups['managers'][0] }},rw"
      device: ":/exports/{{ loop_item }}/{{ w.deploy_wordpress_name }}"
  when: inventory_hostname in groups['managers'][0]
  with_items:
  - "{{ nfs_server_dir_data }}"
  loop_control:
    loop_var: loop_item
```


