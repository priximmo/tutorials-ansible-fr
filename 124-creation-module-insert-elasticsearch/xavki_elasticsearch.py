#!/usr/bin/python
from __future__ import absolute_import, division, print_function
__metaclass__ = type

DOCUMENTATION = '''
module: Xavki_Elasticsearch
short_description: Add and Get values from elasticsearch cluster
description:
  - Allows to insert data into an elasticsearch cluster. For example to store facts or whatever        
  - This module create an index and add document one by one (not by bulk injection)
  - Uses the elasticsearch python librarya - See https://github.com/elastic/elasticsearch-py
requirements:
  - python3-elasticsearch
  - python3-requests
author:
  - Xavier Pestel (alias xavki)
options:
    state:
        description:
          - The state helps you to select different actions. Three states are available.
            Absent to remove the index.
            Present to create an index and store a document.
            Acquire to get all documents in an specific index.
        choices: [ absent, acquire, present ]
        default: present
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

def execute(module):
    state = module.params.get('state')
    if state == 'present' :
        add_document(module)
    elif state == 'absent':
        delete_document(module)
    elif state == 'acquire':
        get_documents(module)
    else:
        module.exit_json(msg="Unsupported state: %s" % (state, ))

def get_elasticsearch_connect(module):
    scheme = module.params.get('scheme')
    host = module.params.get('host')
    port = module.params.get('port')
    connect = "{}://{}:{}".format(module.params.get('scheme'), module.params.get('host'), module.params.get('port'))
    return elastic.Elasticsearch(connect)

def test_dependencies(module):
    if not python_elasticsearch_installed:
        module.fail_json(msg="python3-elasticsearch required for this module. "
                            "see https://github.com/elastic/elasticsearch-py")

def add_document(module):
    es_api = get_elasticsearch_connect(module)
    index = module.params.get('index')
    body = module.params.get('body')
    body = json.dumps(body) #convert to json
    #id = module.params.get('id')
    if index is NOT_SET:
        raise AssertionError('Index not set `NOT_SET`')
    if body is NOT_SET:
        raise AssertionError('Body not set `NOT_SET`')

    #raise AssertionError(id)

    es_api.indices.create(index = index, ignore = 400)

    if module.params.get('id') is NOT_SET:
      changed = es_api.index(index = index, body = body)
    else:
      id = module.params.get('id')
      changed = es_api.index(index = index, id = id, body = body)

    module.exit_json(changed=changed,
                    index=index,
                    body=body)


def main():
    module = AnsibleModule(
        argument_spec = dict(
            host   = dict(type = "str", default = "localhost"),
            port   = dict(type = "int", default = 9200),
            body   = dict(type = "dict", default = ""),
            id     = dict(type = "int"),
            index  = dict(type = "str", default = "xavki"),
            scheme = dict(type = "str", default = "http"),
            state  = dict(type = "str", default = "present", choices = ["acquire", "present", "absent"])
        ),
        supports_check_mode=True
    )

    test_dependencies(module)

    try:
        execute(module)
    except ConnectionError as e:
        module.fail_json(msg='Could not Elasticsearch cluster at %s:%s, error was %s' % (
            module.params.get('host'), module.params.get('port'), e))
    except Exception as e:
        module.fail_json(msg=str(e))

if __name__ == '__main__':
    main()