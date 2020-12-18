%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Variables d'inventaire



<br>

* ansible = forte précédence des variables (ordre hiérarchique)

* regroupement par famille :
    * Configuration settings
    * Command-line options 		> VARIABLES D'INVENTAIRES 
    * Playbook keywords
    * Variables

<br>

* 22 types: 

```
        command line values (eg “-u user”)
        role defaults [1]
        inventory file or script group vars [2]
        inventory group_vars/all [3]
        playbook group_vars/all [3]
        inventory group_vars/* [3]
        playbook group_vars/* [3]
        inventory file or script host vars [2]
        inventory host_vars/* [3]
        playbook host_vars/* [3]
        host facts / cached set_facts [4]
        play vars
        play vars_prompt
        play vars_files
        role vars (defined in role/vars/main.yml)
        block vars (only for tasks in block)
        task vars (only for the task)
        include_vars
        set_facts / registered vars
        role (and include_role) params
        include params
        extra vars (always win precedence)
```

Doc : https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html


----------------------------------------------------------------------------------------------


# ANSIBLE : Variables d'inventaire


<br>

* variables d'inventaires:
		- fichier d'inventaire
		- group_vars (répertoire)
		- host_vars (répertoire)

* squelette :

```
├── 00_inventory.yml
├── group_vars
│   ├── all.yml
│   ├── dbserver.yml
│   └── webserver
│       ├── vault.yml
│       └── webserver.yml
└── host_vars
    ├── srv1
    │   └── srv1.yml
    └── srv2.yml
```

----------------------------------------------------------------------------------------------

# ANSIBLE : Variables d'inventaire

<br>

* multienv >> c'est facile !!!

```
├── dev
│   ├── 00_inventory.yml
│   ├── group_vars
│   │   ├── all.yml
│   │   ├── dbserver.yml
│   │   └── webserver
│   │       ├── vault.yml
│   │       └── webserver.yml
│   └── host_vars
│       ├── srv1
│       │   └── srv1.yml
│       └── srv2.yml
├── prod
│   ├── 00_inventory.yml
│   ├── group_vars
│   │   ├── all.yml
│   │   ├── dbserver.yml
│   │   └── webserver
│   │       ├── vault.yml
│   │       └── webserver.yml
│   └── host_vars
│       ├── srv1
│       │   └── srv1.yml
│       └── srv2.yml
└── stage
    ├── 00_inventory.yml
    ├── group_vars
    │   ├── all.yml
    │   ├── dbserver.yml
    │   └── webserver
    │       ├── vault.yml
    │       └── webserver.yml
    └── host_vars
        ├── srv1
        │   └── srv1.yml
        └── srv2.yml
```


----------------------------------------------------------------------------------------------

# ANSIBLE : Variables d'inventaire


<br>

* commande de test :

```
ansible -i "node2," all -b -e "var1=xavki" -m debug -a 'msg={{ var1 }}'
```

<br>

* inventory :

```
all:
  children:
    common:
      children:
        webserver:
          hosts:
            node[2:3]:
          vars:
            var1: "webserver"
        dbserver:
          hosts:
            node4:
            node5:
              var1: "node5"
          vars:
            var1: "dbserver"
    monitoring:
      children:
        webserver:
        dbserver:
```

----------------------------------------------------------------------------------------------

# ANSIBLE : Variables d'inventaire


<br>

* autour des group_vars

```
├── group_vars
│   ├── dbserver.yml
│   └── webserver.yml
└── inventory.yml
```

ou encore

```
├── group_vars
│   ├── dbserver
│   │   └── dbserver.yml
│   └── webserver
│       └── webserver.yml
└── inventory.yml
```

----------------------------------------------------------------------------------------------

# ANSIBLE : Variables d'inventaire


<br>

* autour des host_vars

```
├── group_vars
│   ├── dbserver
│   │   └── dbserver.yml
│   └── webserver
│       └── webserver.yml
├── host_vars
│   ├── node2
│   │   └── variables.yml
│   └── node5.yml
└── inventory.yml
```

----------------------------------------------------------------------------------------------

# ANSIBLE : Variables d'inventaire


<br>

* et si on ajoutait un host au hasard et appartenant à "all"

```
all:
  children:
    common:
      children:
        webserver:
          hosts:
            node[2:3]:
        dbserver:
          hosts:
            node4:
            node5:
    monitoring:
      hosts:
        node6:
      children:
        webserver:
        dbserver:
```

```
├── group_vars
│   ├── all.yml
│   ├── dbserver
│   │   └── dbserver.yml
│   └── webserver
│       └── webserver.yml
├── host_vars
│   ├── node2
│   │   └── variables.yml
│   └── node5.yml
└── inventory.yml
```
