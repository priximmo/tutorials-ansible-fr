%title: ANSIBLE
%author: xavki


# ANSIBLE : TP MODULE IPTABLES


<br>






* bastion


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






* role for bastion

	
  - name: for bastion
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




* role for all

  - name: only ssh via bastion
    iptables:
      chain: INPUT
      protocol: tcp
      destination_port: 22
      source: 172.17.0.2 # éventuellement /24
      jump: ACCEPT

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
    apt:
      name: iptables-persistent
      state: present

  - name: persistent rules
    shell: iptables-save > /etc/iptables/rules.v4

