%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : CREATION D'UN MODULE - GET ALL DOCUMENTS

<br>

* correction : body => dict

<br>

* fonction d'exécution :

```
    elif state == 'acquire':
        get_documents(module)
```

<br>

* fonction get_documents : connection au cluster

```
def get_documents(module):
    es_api = get_elasticsearch_connect(module)
    index = module.params.get('index')
```

---------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - GET ALL DOCUMENTS

<br>

* fonction get_documents : requête

```
    request_all = {"query": { "match_all" : {}}}
    request_all = json.dumps(request_all)
    get_all_docs = es_api.search(index = index, body = request_all)
```

---------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - GET ALL DOCUMENTS

<br>

* fonction get_documents : envoi du résultat à l'utilisateur

```
    module.exit_json(changed=get_all_docs,
                     index=index)
```

---------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - GET ALL DOCUMENTS

<br>

* playbook :

```
  - name: run our module
    xavki_elasticsearch:
      index: "vid124"
      host: "192.168.20.102"
      state: acquire
    register: __output
```

---------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - GET ALL DOCUMENTS

<br>

* exploitation du résultat : cf vidéo 114 sur json

```
  - name: display output
    debug:
      var: __output.changed.hits.hits | json_query('[*]._source.city')
```
