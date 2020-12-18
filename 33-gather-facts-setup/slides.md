%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Gather Facts & module Setup


<br>

Documentation : 
	* setup : https://docs.ansible.com/ansible/2.3/setup_module.html
	* gather facts : https://docs.ansible.com/ansible/latest/user_guide/playbooks_vars_facts.html

<br>

* facts > données relatives aux machines plus ou moins détaillées (réduit, non collectés...)
		* networks
		* devices
		* os
		* hardware
		* connexion utilisée
		* montages/volumes...

<br>

* ansible_facts : dictionnaire contenant tous les facts

* collectés via setup (forcé ou non au gathering fact > lancement du playbook)

<br>

* soit en cli 

```
ansible -i 00_inventory.yml all -m setup
ansible -i 00_inventory.yml all -m setup -a "filter=ansible_user*"
```
<br>

* soit par la variable

```
  - name: debug
    debug:
      var: ansible_facts
```

-----------------------------------------------------------------------------------------

# ANSIBLE : Gather Facts & module Setup


<br>

* soit par le module via une tasks (playbook ou roles)

```
  - name: debug
    setup:
    register: _hosts_facts
  - name: display
    debug:
      var: _hosts_facts
```

<br>

* avec filtre

```
  - name: debug
    setup:
      filter: ansible_user*
    register: _hosts_facts
```

<br>

* possibilité de ne pas les collecter

```
- name: test variables
  hosts: all
  gather_facts: no 
  tasks:
  - name: display
    debug:
      var: ansible_facts
```
