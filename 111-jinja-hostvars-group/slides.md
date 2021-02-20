%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : HostVars et GroupVars > croisement


<br>

* exemple :

```
    manager:
      hosts:
        172.17.0.2:
        172.17.0.3:
        172.17.0.4:
    worker:
      hosts:
        172.17.0.4:
        172.17.0.5:
        172.17.0.6:
```

----------------------------------------------------------------------------

# ANSIBLE : HostVars et GroupVars > croisement


<br>

* lister les machines d'un groupe

```
groups["manager"]
```

<br>

* récupérer la première/dernière machine

```
groups["manager"][0]
groups["manager"][-1]
```

----------------------------------------------------------------------------

# ANSIBLE : HostVars et GroupVars > croisement

<br>

* parcourir une liste de groupe

```
        {% for server in groups["manager"] %}
          Srv : {{ server }}          
        {% endfor%}
```

<br>

* accéder aux variables des servers :

```
        {% for server in groups["manager"] %}
          Srv : {{ hostvars[server] }}          
        {% endfor%}
```

----------------------------------------------------------------------------

# ANSIBLE : HostVars et GroupVars > croisement

<br>

* les variables d'un groupe = variables d'une machines du groupe

```
Srv : {{ hostvars[groups["manager"][0]] }}
```

<br>

* une variable précise :

```
Srv : {{ hostvars[groups["manager"][0]]['manager'] }}
```

<br>

* filtre par un when

```
  - name: debug manager
    debug:
      msg: |
          Srv : {{ hostvars[groups["manager"][0]]['manager'] }}
    when: inventory_hostname in groups['worker']
```

----------------------------------------------------------------------------

# ANSIBLE : HostVars et GroupVars > croisement

<br>

* pour une variable register

```
  - name: host name
    shell: hostname
    register: __host_name

Srv : {{ hostvars[groups["manager"][0]]['__host_name'] }}
```
