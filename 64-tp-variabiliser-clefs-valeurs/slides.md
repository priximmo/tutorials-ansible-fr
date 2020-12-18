%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP - Variabiliser les valeurs... ET LES CLEFS


<br>

Documentation :
https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters.html#combining-hashes-dictionaries

Objectif : Créer intégralement un dictionnaire

<br>

* Exemple : création des labels Traefik

```
    labels:
      traefik.enable: "true"
      traefik.swarmmode: "true"
      traefik.docker.network: "traefik_net"
      traefik.http.routers.visu-public-http.rule: "Host(`visu.swarm`)"
      traefik.http.routers.visu-public-http.entrypoints: "http"
      traefik.http.services.visu-public.loadbalancer.server.port: "8080"
```

<br>

* création d'un dictionnaire vide

```
- name: Create Traefik labels's dictionary
  set_fact:
      traefik_labels: {}
```

Rq : obligatoire à cause de la boucle sur les fichiers (sinon ajout au précédent)

-----------------------------------------------------------------------------------------------------------------------------------

# ANSIBLE : TP - Variabiliser les valeurs... ET LES CLEFS


<br>

* alimentation du dictionnaire à partir des variables du fileglob

```
- name: Insert into Traefik labels's dictionary
  set_fact:
      traefik_labels: "{{ traefik_labels | default({}) | combine ({ loop_item.key : loop_item.value }) }}"
  with_items:
    - { 'key': 'traefik.enable' , 'value': 'true'}
    - { 'key': 'traefik.swarmmode' , 'value': 'true'}
    - { 'key': 'traefik.docker.network' , 'value': 'traefik_net'}
    - { 'key': 'traefik.http.routers.{{ w.deploy_wordpress_name }}.rule' , 'value': 'Host(`{{ w.deploy_wordpress_url }}`)'}
    - { 'key': 'traefik.http.routers.{{ w.deploy_wordpress_name }}.entrypoints' , 'value': 'http'}
    - { 'key': 'traefik.http.services.{{ w.deploy_wordpress_name }}.loadbalancer.server.port' , 'value': '{{ w.deploy_wordpress_container_port }}'}
  loop_control:
    loop_var: loop_item
  when: inventory_hostname in groups['managers'][0]
```

Rq : risque de conflit donc utilisation du loop_control

-----------------------------------------------------------------------------------------------------------------------------------

# ANSIBLE : TP - Variabiliser les valeurs... ET LES CLEFS

<br>

* création du conteneur mariadb

```
- name: "install mysql"
  docker_swarm_service:
    name: "mariadb_{{ w.deploy_wordpress_name }}"
    image: mariadb
    networks:
      - "wordpress_{{ w.deploy_wordpress_name }}"
    mounts:
    - source: "wp_database_{{ w.deploy_wordpress_name }}"
      target: /var/lib/mysql
      type: volume
    restart_config:
      condition: any
      delay: 30s
      max_attempts: 5
    env:
      MYSQL_ROOT_PASSWORD: "{{ w.deploy_wordpress_mariadb_password }}"
      MYSQL_DATABASE: "wordpress"
      MYSQL_USER: "{{ w.deploy_wordpress_mariadb_user }}"
      MYSQL_PASSWORD: "{{ w.deploy_wordpress_mariadb_password }}"
    labels:
      traefik.enable: "false"
  when: inventory_hostname in groups['managers'][0]
```

-----------------------------------------------------------------------------------------------------------------------------------

# ANSIBLE : TP - Variabiliser les valeurs... ET LES CLEFS

<br>

* création du conteneur wordpress avec injection du dictionnaire

```
- name: "install wordpress"
  docker_swarm_service:
    name: "wordpress_{{ w.deploy_wordpress_name }}"
    image: wordpress
    networks:
      - "wordpress_{{ w.deploy_wordpress_name }}"
      - "traefik_net"
    mounts:
    - source: "wp_statics_{{ w.deploy_wordpress_name }}"
      target: /var/www/html/
      type: volume
    restart_config:
      condition: any
      delay: 40s
      max_attempts: 5
    env:
       WORDPRESS_DB_HOST: "mariadb_{{ w.deploy_wordpress_name }}:3306"
       WORDPRESS_DB_USER: "{{ w.deploy_wordpress_mariadb_user }}"
       WORDPRESS_DB_PASSWORD: "{{ w.deploy_wordpress_mariadb_password }}"
    labels: "{{ traefik_labels }}"
  when: inventory_hostname in groups['managers'][0]
```

-----------------------------------------------------------------------------------------------------------------------------------

# ANSIBLE : TP - Variabiliser les valeurs... ET LES CLEFS


<br>

* test du code retour avant de passer au fichier suivant ou de terminer

```
- name: wait for wordpress service up
  uri:
    url: "http://127.0.0.1"
    method: GET
    status_code: [200]
    headers:
      Host: "{{ w.deploy_wordpress_url }}"
  register: __result
  until: __result.status == 200
  retries: 240
  delay: 1
  when: inventory_hostname in groups['managers'][0]
```

Rq : juste sur un manager
