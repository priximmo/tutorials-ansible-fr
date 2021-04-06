%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : CREATION D'UN MODULE - INSERTION ELASTICSEARCH

<br>

* localisation du module :

```
/usr/share/ansible/plugins/modules/xavki_elasticsearch.py
```

* fonction d'exécution : add / delete / get

```
def execute(module):
    state = module.params.get('state')
    if state == 'present' :
        add_document(module)
    elif state == 'absent':
        delete_document(module)
    elif state == 'checked':
        get_documents(module)
    else:
        module.exit_json(msg="Unsupported state: %s" % (state, ))
```

-------------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - INSERTION ELASTICSEARCH


<br>

* fonction de connexion : utilisable pour les 3 types d'actions

```
def get_elasticsearch_connect(module):
    scheme = module.params.get('scheme')
    host = module.params.get('host')
    port = module.params.get('port')
    connect = "{}://{}:{}".format(module.params.get('scheme'), module.params.get('host'), module.params.get('port'))
    return elastic.Elasticsearch(connect)
``` 

-------------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - INSERTION ELASTICSEARCH

<br>

* test de dépendances

```
def test_dependencies(module):
    if not python_elasticsearch_installed:
        module.fail_json(msg="python3-elasticsearch required for this module. "
                             "see https://github.com/elastic/elasticsearch-py")
```

-------------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - INSERTION ELASTICSEARCH

<br>

* fonction d'ajout : initiation de la connexion

```
def add_document(module):
    es_api = get_elasticsearch_connect(module)
    index = module.params.get('index')
    body = module.params.get('body')
    body = json.dumps(body) #convert to json
```

-------------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - INSERTION ELASTICSEARCH

<br>

* fonction d'ajout : tests 

```
    if index is NOT_SET:
        raise AssertionError('Index not set `NOT_SET`')
    if body is NOT_SET:
        raise AssertionError('Body not set `NOT_SET`')
```

-------------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - INSERTION ELASTICSEARCH

<br>

* fonction d'ajout : création de l'index

```
    #raise AssertionError(body)
    es_api.indices.create(index = index, ignore = 400)
````

-------------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - INSERTION ELASTICSEARCH

<br>

* fonction d'ajout : avec ou sans id

```
    if module.params.get('id') is NOT_SET:
      changed = es_api.index(index = index, body = body)
    else:
      id = module.params.get('id')
      changed = es_api.index(index = index, id = id, body = body)

    module.exit_json(changed=changed,
                     index=index,
                     body=body)
```


-------------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - INSERTION ELASTICSEARCH


```
  - name: run our module
    xavki_elasticsearch:
      index: "hehe"     
      host: "192.168.20.102"
      body: 
        first_name: "xavki"
        city: "caen"   
```

-------------------------------------------------------------------------

# ANSIBLE : CREATION D'UN MODULE - INSERTION ELASTICSEARCH

* test

```
curl 192.168.20.102:9200/myindex/_doc/1

curl -H 'Content-Type: application/json' 
     'http://192.168.20.102:9200/myindex/_search?pretty'
     -XPOST -d '
         {
            "query": {
               "match_all": {}
            }
        }'
```

