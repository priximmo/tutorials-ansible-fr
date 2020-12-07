%title: ANSIBLE
%author: xavki


# ANSIBLE : TP MODULE IPTABLES


<br>


:INPUT DROP
:FORWARD DROP
:OUTPUT ACCEPT 
-A INPUT -s 192.168.1.0/24 -p tcp -m tcp --dport 22 -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A OUTPUT -p icmp -j ACCEPT
-A OUTPUT -p tcp -m tcp --dport 22 -j ACCEPT
-A OUTPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT


- name: persistent rules
  apt:
    name: iptables-persistent
    state: present

- name: for bastion
  iptables:
    chain: INPUT
    protocol: tcp
    destination_port: 22
    source: 172.17.0.1 # éventuellement /24
    jump: ACCEPT
  when: bastion is defined

- name: for workers
  iptables:
    chain: INPUT
    protocol: tcp
    destination_port: 22
    source: 172.17.0.2 #mon bastion
    jump: ACCEPT
  when: bastion is not defined


- name: bastion can go everywhere with ssh
  iptables:
    chain: OUTPUT
    protocol: tcp
    destination_port: 22
    jump: ACCEPT
    state: present
  when: bastion is defined

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

- name: Allow related and established connections
  iptables:
    chain: INPUT
    ctstate: ESTABLISHED,RELATED
    jump: ACCEPT

- name: Allow related and established connections
  iptables:
    chain: OUTPUT
    ctstate: ESTABLISHED,RELATED
    jump: ACCEPT

- name: Set the policy for the INPUT chain to DROP
  iptables:
    chain: OUTPUT
    policy: ACCEPT

- name: Set the policy for the INPUT chain to DROP
  iptables:
    chain: INPUT
    policy: DROP

- name: Set the policy for the INPUT chain to DROP
  iptables:
    chain: FORWARD
    policy: DROP

- name: persistent rules
  shell: iptables-save > /etc/iptables/rules.v4

