%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Module SET_FACT


<br>

Documentation : https://docs.ansible.com/ansible/latest/collections/ansible/builtin/set_fact_module.html

* définir des facts (gather facts)

<br>

PARAMETRES

<br>

* cacheable : ajouté au cache (défaut non)

* key_value : définition de la clef et de la valeur prise

<br>


* définir un gather fact

```
  - name: set fact
    set_fact:
      mavariable: "Hello tout le monde !!"
  - name: debug
    debug:
      var: mavariable
```

----------------------------------------------------------------------

# ANSIBLE : Module SET_FACT


<br>

* exemple avec éléments calculés

```
  vars:
    var1: "hello"
    var2: "je suis"
  tasks:
  - name: get user
    command: "echo $USER"
    register: __user
  - name: date
    set_fact:
      mavariable: "{{ var1 }} {{ var2 }} {{ __user.stdout }} sur {{ ansible_hostname }}"
  - name: debug
    debug:
      var: mavariable
```

----------------------------------------------------------------------

# ANSIBLE : Module SET_FACT

<br>

* le gather fact datetime :

```
  - name: date
    debug:
      var: ansible_date_time
```

<br>

* si cache (ansible.cfg)

```
#cache facts
gathering = smart
fact_caching = jsonfile
fact_caching_connection = /tmp/facts_cache
# two hours timeout
fact_caching_timeout = 7200
```

----------------------------------------------------------------------

# ANSIBLE : Module SET_FACT

<br>

* contourner le cache

```
  - name: date without cache
    shell: "date +%Y-%m-%d"
    register: shell_date
  - set_fact:
      date: "{{ shell_date.stdout }}"
```
