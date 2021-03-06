%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : CREATION D'UN MODULE - STRUCTURE

<br>

* entête du module

```
#!/usr/bin/python
from __future__ import absolute_import, division, print_function
__metaclass__ = type
```

Rq : compatibilité python2 vers python3

--------------------------------------------------------

## DOCUMENTATION

<br>


```
DOCUMENTATION = '''
module: Xavki_Elasticsearch
short_description: Add and Get values from elasticsearch cluster
```

--------------------------------------------------------

## DOCUMENTATION

<br>

```
description:
  - Allows to insert data into an elasticsearch cluster. For example to store facts or whatever
  - This module create an index and add document one by one (not by bulk injection)
  - Uses the elasticsearch python librarya - See https://github.com/elastic/elasticsearch-py
```

```
requirements:
  - python3-elasticsearch
  - requests
author:
  - Xavier Pestel (alias xavki)
```

--------------------------------------------------------

## DOCUMENTATION

<br>

```
options:
    state:
        description:
          - The state helps you to select different actions. Three states are available. 
            Absent to remove the index.
            Present to create an index and store a document.
            Acquire to get all documents in an specific index.
        choices: [ absent, acquire, present ]
        default: present
```

--------------------------------------------------------

## DOCUMENTATION

<br>

```
    host:
        description:
          - Host of the elasticsearch cluster (by default localhost)
        type: str
    port:
        description:
          - Port of the elasticsearch cluster (by default 9200)
        type: int
    scheme:
        description:
          - The protocol scheme on which the elasticsearch is running (by defautl http)
        type: str
```

--------------------------------------------------------

## DOCUMENTATION

<br>

```
    index:
        description:
          - which index do you want to create or inject your document
        type: str
    id:
        description:
          - To use a document id (not required)
        type: int
    body:
        desription:
          - All fields of the document
        type: dict
'''
```

--------------------------------------------------------

## LIBRAIRIES


<br>

```
from ansible.module_utils._text import to_text
from ansible.module_utils.basic import AnsibleModule
try:
    import elasticsearch as elastic
    import json
    from requests.exceptions import ConnectionError
    python_elasticsearch_installed = True
except ImportError:
    python_elasticsearch_installed = False

NOT_SET = None
```

--------------------------------------------------------

## MAIN

<br>

```
def main():
    module = AnsibleModule(
        argument_spec = dict(
            host   = dict(type = "str", default = "localhost"),
            port   = dict(type = "int", default = 9200),
            body   = dict(type = "dict", default = ""),
            id     = dict(type = "int"),
            index  = dict(type = "str", default = "xavki"),
            scheme = dict(type = "str", default = "http"),
            state  = dict(type = "str", default = "present", choices=["acquire", "present", "absent"]),
        ),
        supports_check_mode=True
    )
```

--------------------------------------------------------

## MAIN


```
    test_dependencies(module)
    try:
        execute(module)
    except ConnectionError as e:
        module.fail_json(msg='Could not Elasticsearch cluster at %s:%s, error was %s' % (
            module.params.get('host'), module.params.get('port'), e))
    except Exception as e:
        module.fail_json(msg=str(e))
```

```
if __name__ == '__main__':
    main()
```
