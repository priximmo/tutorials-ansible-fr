%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Precedence des variables


<br>

* 23 types / localisation :

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

---------------------------------------------------------------------------------

# ANSIBLE : Precedence des variables

<br>

* exemple > role

<br>

	* default variable
<br>

	* group vars
<br>

	* host vars
<br>

	* variables de playbook
<br>

	* variables de roles
<br>

	* facts de roles (set_fact)
<br>

	* variable de cli
