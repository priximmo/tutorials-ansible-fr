%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : CREATION D'UN MODULE - OBJECTIFS

<br>

Objectif : créer un module simple

		* peu de paramètres

		* inspiré de la vidéo 76 > exporter des facts vers ES

		* création d'un index

		* compléter des champs pour insérer dans un index


Module = utilisation de l'api ElasticSearch (hors module uri - custom)

--------------------------------------------------------------------

## POUR COMMENCER : PRENDRE DES EXEMPLES


<br>

* la documentation des modules est notre amie

```
ansible-doc -t module stat
```

Rq : on est plus dans un mode utilisation d'une api

<br>

* Documentation : 
https://docs.ansible.com/ansible/latest/dev_guide/developing_modules_general.html

<br>

* commencer par faire les choses en python pour savoir où aller


--------------------------------------------------------------------

## POUR COMMENCER : PRENDRE DES EXEMPLES

<br>

* installation des prérequis (python3) :

```
sudo apt install -y python3-elasticsearch python3-requests
```

Rq : possible par pip3 également

<br>

* possibilité d'utiliser virtualenv

<br>

* nécessité d'un ES (cf Vargrantfile joint)

-----------------------------------------------------------------------

## TEST EN PYTHON


<br>

* en tête et imports

```
#!/usr/bin/python3.8
import elasticsearch as elastic
```

<br>

* établir une connexion

```
url = "http://192.168.20.102:9200"
es = elastic.Elasticsearch(url)
```

--------------------------------------------------------------------

## DOCUMENTS ET INDEX

<br>

* création d'un index

```
es.indices.create(index='xavki', ignore=400)
```

<br>

* check

```
curl http://192.168.20.102:9200/_cat/indices
```

--------------------------------------------------------------------

## DOCUMENTS ET INDEX

<br>

* ajout d'un document

```
doc1 = { "first_name": "xavki",
    "last_name": "myname",
    "age": 41,
    "city": "Caen"
}
print("Insert document...")
es.index(index = "xavki", body=doc1) #id if you want
```

--------------------------------------------------------------------

## DOCUMENTS ET INDEX

<br>

* récupérer un document ou tous les documents

```
result = es.get(index ="myindex", id = 1)
search = es.search(index = "myindex", body={"query":{"match_all":{}}})
print(result)
print(search)
```

Test :

```
curl 192.168.20.102:9200/myindex/_doc/1
```
