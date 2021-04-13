%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : CREATION D'UN MODULE - DELETE DOCS / INDEX

<br>

* objectif :
		* supprimer des documents précis
		* supprimer un index

<br>

* change ID = string !!

<br>

* méthode : .delete()
		* index et éventuellement un ID
		* gestion idempotence (sans erreur si déjà absent > ignore error)

* si pas d'ID = suppression index sinon le doc

-------------------------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - DELETE DOCS / INDEX


<br>

* on repart de notre execute() :

```
    if state == 'present' :
        add_document(module)
    elif state == 'absent':
        delete_document(module)
    elif state == 'acquire':
        get_documents(module)
    else:
        module.exit_json(msg="Unsupported state: %s" % (state, ))
```

-------------------------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - DELETE DOCS / INDEX

<br>

* notre bloc de connexion

```
def delete_document(module):
    es_api = get_elasticsearch_connect(module)
    index = module.params.get('index')
```

-------------------------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - DELETE DOCS / INDEX

<br>

* si on a pas de paramètre ID :

```
    if module.params.get('id') is NOT_SET:
      delete_result = es_api.indices.delete(index = index, ignore = [400, 404])
```

<br>

* sinon on passe un ID :

```
    else:
      id = module.params.get('id')
      delete_result = es_api.delete(index = index, id = id, ignore = [400, 404])
```

-------------------------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - DELETE DOCS / INDEX

<br>

* et un retour pour l'utilisateur :

```
    module.exit_json(changed = delete_result,
                     index = index)
```


-------------------------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - DELETE DOCS / INDEX

<br>

* test : collecte de /etc/hosts sur un parc de srv

```
  - name: get /etc/hosts
    shell: cat /etc/hosts
    register: __file_hosts
```

<br>

* injection dans ES (delegate_to)

```
  - name: insert into ES
    xavki_elasticsearch:
      host: "192.168.20.102"
      index: mydc
      id: "{{ ansible_hostname }}"
      body:
        etc_hosts: "{{ __file_hosts.stdout_lines }}"
    delegate_to: localhost
```
-----------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - DELETE DOCS / INDEX

<br>

* vérification :

```
curl 
-H "Content-Type: application/json"
-XPOST 127.0.0.1:9200/mydc/_search?pretty 
-d '{ "query": {"match_all": {}}}'
```
