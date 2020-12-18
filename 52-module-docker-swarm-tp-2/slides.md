%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : module docker-swarm > initialisation d'un cluster

<br>

Documentation : https://docs.ansible.com/ansible/latest/collections/community/general/docker_swarm_module.html

<br>

PARAMETRES

<br>

* advertise_addr : adresse référencée auprès des autres nodes (attention vagrant ;))

<br>

* autolock_managers : vérouillage des datas des managers via une clef

<br>

* ca_cert / ca_force_rotate / client_cert / client_key...

<br>

* default_addr_pool : range d'ip utilisé par défaut

<br>

* docker_host: socket docker (unix/tcp/ssh)

<br>

* election_tick : délai sans leader qui provoque une élection

<br>

* heartbeat_tick : délai de check

<br>

* join_token : lorsque state vaut join, token pour rejoindre le cluster (manager/worker)

----------------------------------------------------------------------------------------

# ANSIBLE : module docker-swarm > initialisation d'un cluster


<br>

* keep_old_snapshots : nombre de snapshots à conserver

<br>

* listen_addr : adresse d'écoute de la socket

<br>

* name : nom du cluster

<br>

* node_cert_expiry  : délai d'expiration des certificats des nodes/workers (3 mois)

<br>

* node_id : pour supprimer un noeud par son ID (state remove)

<br>

* remote_addrs : list ou string des managers du cluster

<br>

* rotate_manager_token : activation de la rotation des tokens pour les managers

<br>

* rorate_worker_token : activation de la rotation des tokens pour les workers

<br>

* snapshot_interval : délai entre les snapshots

<br>

* state : present / absent / join / remove / inspect

<br>

OUTPUTS

* ip / tokens...

----------------------------------------------------------------------------------------

# ANSIBLE : module docker-swarm > initialisation d'un cluster


<br>

Exemple : cluster de 3 managers avec 2 workers

* inventory

```
all:
  children:
    managers:
      hosts:
        192.168.15.10:
        192.168.15.11:
        192.168.15.12:
        #192.168.15.15:
        #192.168.15.16:
    workers:
      hosts:
        192.168.15.13:
        192.168.15.14:
```

* 2 rôles : docker + swarm

----------------------------------------------------------------------------------------

# ANSIBLE : module docker-swarm > initialisation d'un cluster

<br>

* installation des autres managers non leaders

```
- name: install nodes
  docker_swarm:
    state: join
    timeout: 60
    advertise_addr: enp0s8:2377
    join_token: "{{ hostvars[groups['managers'][0]]['__output_swarm']['swarm_facts']['JoinTokens']['Manager'] }}"
    remote_addrs: "{{ groups['managers'][0] }}"
  when: inventory_hostname in groups['managers'] and inventory_hostname not in groups['managers'][0]
```

<br>

* installation des workers

```
- name: install worker
  docker_swarm:
    state: join
    timeout: 60
    advertise_addr: enp0s8:2377
    join_token: "{{ hostvars[groups['managers'][0]]['__output_swarm']['swarm_facts']['JoinTokens']['Worker'] }}"
    remote_addrs: "{{ groups['managers'][0] }}"
  when: inventory_hostname in groups['workers']
```
