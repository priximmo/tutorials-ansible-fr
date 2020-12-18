%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Module APT


<br>

Documentation : https://docs.ansible.com/ansible/latest/collections/ansible/builtin/apt_module.html

Comamnde : apt

<br>

PARAMETRES :

<br>

* allow_unauthenticated : autoriser l'installation de paquets non authentifiés

<br>

* autoclean : effacement des anciennes versions des paquets

<br>

* cache_valid_time : durée durant laquelle ne pas remettre à jour le cache apt

<br>

* deb : lien vers une source de paquet .deb

<br>

* default_release : version par défaut

<br>

* dpkg_options : option d'installation dpkg

<br>

* force : équivaut à --force-yes, désactive la signature et certificats de paquets

<br>

* force_apt_get : force l'utilisation de apt-get

--------------------------------------------------------------------------------------------------------------
 
# ANSIBLE : Module APT



<br>

* install_recommends : activer ou désactiver les paquets recommandés (dépend des OS)

<br>

* name : nom du paquet

<br>

* only_upgrade : met à jour uniquement les paquets installés

<br>

* policy_rc_d : règle de déclenchement automatique à l'installation d'un paquet

<br>

* purge : purge les fichiers de configurations (--purge)

<br>

* state : present / absent / latest / fixed / build-dep

<br>

* update_cache : réaliser un update avant l'installation

<br>

* update_cache_retries : nombre de tentatives de l'update

<br>

* update_cache_retry_max_delay : délai de chaque retry

<br>

* upgrade : yes / no / safe / dist / full


--------------------------------------------------------------------------------------------------------------
 
# ANSIBLE : Module APT



<br>

* mise à jour du cache 

```
  - name:
    apt:
      update_cache: yes
      cache_valid_time: 3600
```

<br>

* délai de validité du cache

```
  - name:
    apt:
      name: haproxy
      update_cache: yes
      cache_valid_time: 60
```

<br>

* utiliser la version backport

```
  - name:
    apt:
      name: haproxy
      default_release: stretch-backports
      update_cache: yes
      cache_valid_time: 60
```

Rq : 
- apt list -a haproxy
- apt list -i haproxy


--------------------------------------------------------------------------------------------------------------
 
# ANSIBLE : Module APT


<br>

* mise à jour

```
  - name:
    apt:
      name: haproxy
      update_cache: yes
      cache_valid_time: 60
      state: latest
```

<br>

* suppression

```
  - name:
    apt:
      name: haproxy
      state: absent
```

<br>

* suppression complète

```
  - name:
    apt:
      name: haproxy
      state: absent
      purge: yes
      autoremove: yes
```
