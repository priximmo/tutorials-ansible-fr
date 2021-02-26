%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : JINJA - JSON / YAML

<br>

Filtres:

```
		from_json
		from_yaml
		to_json
		to_yaml
		to_nice_json
		to_nice_yaml
```

-----------------------------------------------------------------------------------

# ANSIBLE : JINJA - JSON / YAML


<br>


* variable json non formée

```
jsonVrac: '[{ "hostname": "host1", "customProperties": { "foo": "first", "foo2": "second" }},{ "hostname": "host2", "customProperties": { "foo": "third", "foo2": "fourth" }}]'
```

-----------------------------------------------------------------------------------

# ANSIBLE : JINJA - JSON / YAML

<br>

* variable au format json

```
    jsonSource: |
      [
        {
            "hostname": "host1",
            "customProperties": {
                "foo": "first",
                "foo2": "second"
            }
        },
        {
            "hostname": "host2",
            "customProperties": {
                "foo": "third",
                "foo2": "fourth"
            }
        }
      ]
```

-----------------------------------------------------------------------------------

# ANSIBLE : JINJA - JSON / YAML

<br>

* variable au format yaml

```
    yamlSource: |
      bloc1:
        key1: value1
        key2: value2
      bloc2:
        key3: value3
        key4: value4
```

-----------------------------------------------------------------------------------

# ANSIBLE : JINJA - JSON / YAML

<br>

* remise en forme du json non formé

```
  - name: 2
    debug:
      msg: |
        {{ jsonVrac | from_json }}
```

-----------------------------------------------------------------------------------

# ANSIBLE : JINJA - JSON / YAML

<br>

* conversion de json en yaml

```
  - name: 0
    copy:
      content: "{{ yamlSource | from_yaml | to_nice_json }}"
      dest: test.json
```

-----------------------------------------------------------------------------------

# ANSIBLE : JINJA - JSON / YAML

<br>

* conversion du yaml en json

```
  - name: 0
    copy:
      content: "{{ jsonSource | from_json | to_nice_yaml }}"
      dest: test.yaml
```

----------------------------------------------------------------------------------


# ANSIBLE : JINJA - JSON / YAML


<br>

* compléter un json

```
  - name: fact
    set_fact:
      hostList2: '{{ (jsonSource | from_json)  + [{ "hostname": "host3",  "customProperties": { "foo": "first", "foo2": "second"  }}] }}'
  - name: debug
    debug:
      var: hostList2
```

----------------------------------------------------------------------------------


# ANSIBLE : JINJA - JSON / YAML


<br>

* définition d'une variable yaml

```
prometheus_var_config:
  global:
    scrape_interval: "15s"
    evaluation_interval: 5s
    external_labels:
      env: 'prod'
  scrape_configs:
    - job_name: prometheus
      scrape_interval: 15s
      static_configs:
        - targets: ['127.0.0.1:9090']
```

----------------------------------------------------------------------------------


# ANSIBLE : JINJA - JSON / YAML


<br>

* 

```
#jinja2: lstrip_blocks: "True"
{{ prometheus_var_config | to_nice_yaml(indent=2) }}
- job_name: node_exporter
  scrape_interval: 15s
```
