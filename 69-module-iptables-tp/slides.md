%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : TP MODULE IPTABLES

<br>

Découverte du module iptables

Documentation : https://docs.ansible.com/ansible/latest/collections/ansible/builtin/iptables_module.html

<br>

* sur le futur bastion - playbook.yml


```
- name: install bastion
  hosts: 127.0.0.1
  connection: local
  become: yes
  roles:
  - fw_bastion
  - fw_all


- name: other servers
  hosts: all
  become: yes
  roles:
  - fw_all
```

---------------------------------------------------------------------------------

# ANSIBLE : TP MODULE IPTABLES

<br>

* fw_bastion

```
- name: install iptables
  apt:
    name: iptables
    state: present

- name: for bastion - accept only the laptop
  iptables:
    chain: INPUT
    protocol: tcp
    destination_port: 22
    source: 172.17.0.1 # éventuellement /24
    jump: ACCEPT

- name: bastion can go everywhere with ssh
  iptables:
    chain: OUTPUT
    protocol: tcp
    destination_port: 22
    jump: ACCEPT
    state: present
```

---------------------------------------------------------------------------------

# ANSIBLE : TP MODULE IPTABLES

<br>

* role for all

```
- name: install iptables
  apt:
    name: iptables
    state: present

- name: only ssh via bastion
  iptables:
    chain: INPUT
    protocol: tcp
    destination_port: 22
    source: 172.17.0.2 # éventuellement /24
    jump: ACCEPT
```

---------------------------------------------------------------------------------

# ANSIBLE : TP MODULE IPTABLES

<br>

* maintient du ping

```
- name: icmp accept
  iptables:
    chain: INPUT
    protocol: icmp
    jump: ACCEPT

- name: icmp accept
  iptables:
    chain: OUTPUT
    protocol: icmp
    jump: ACCEPT
```

---------------------------------------------------------------------------------

# ANSIBLE : TP MODULE IPTABLES

<br>

* maintien des communications établies

```
- name: Allow related and established connections
  iptables:
    chain: INPUT
    ctstate: ESTABLISHED,RELATED
    jump: ACCEPT

- name: Set the policy for the INPUT chain to DROP
  iptables:
    chain: OUTPUT
    policy: ACCEPT
```

---------------------------------------------------------------------------------

# ANSIBLE : TP MODULE IPTABLES

<br>

* drop de toutes les entrées

```
- name: Set the policy for the INPUT chain to DROP
  iptables:
    chain: INPUT
    policy: DROP

- name: Set the policy for the INPUT chain to DROP
  iptables:
    chain: FORWARD
    policy: DROP
```

---------------------------------------------------------------------------------

# ANSIBLE : TP MODULE IPTABLES

<br>

* persistence des règles

```
- name: persistent rules
  apt:
    name: iptables-persistent
    state: present

- name: persistent rules
  shell: iptables-save > /etc/iptables/rules.v4
```

<br>

* go go go....

```
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook -i 00_inventory.yml playbook.yml
```
