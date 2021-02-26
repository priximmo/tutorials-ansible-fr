%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : JINJA - JSON QUERY

<br>

* utilisation d'une rest api

```
    url: "https://jsonplaceholder.typicode.com/todos/"

  - name: 0
    uri:
      url: "{{ url }}"
    register: __output_url

  - name: output
    debug: 
      msg: "{{ __output_url.json | json_query('[*]') }}"
      
      msg: "{{ __output_url.json | json_query('[*].id') }}"
```

-------------------------------------------------------------------------------

# ANSIBLE : JINJA - JSON QUERY


* à partir d'une source json plus élaborée


```
    jsonSource: |
      {
        "servers": [
          {
            "hostname": "host1",
            "spec" : {
              "ram": "8Gb",
              "cpu": "4"
            }
          },
          {
            "hostname": "host2",
            "spec" : {
              "ram": "16Gb",
              "cpu": "2"
            }
          },
          {
            "hostname": "host3",
            "spec" : {
              "ram": "32Gb",
              "cpu": "16"
            }
          }
        ]
      }
```

-------------------------------------------------------------------------------

# ANSIBLE : JINJA - JSON QUERY


<br>

* récupération d'un élément d'une liste

```
msg: "{{ jsonSource | from_json | json_query('servers[*].hostname') }}"
```

<br>

* sélection d'un des blocs

```
query: "servers[?hostname == 'host2']"
```

<br>

* récupération de clefs spécifiques

```
query: "servers[?hostname == 'host2'].spec"
query: "servers[?hostname == 'host2'].spec.ram"
query: "servers[\*].spec.ram"
```

-------------------------------------------------------------------------------

# ANSIBLE : JINJA - JSON QUERY


<br>

* manipulation avec d'autres filtres

```
msg: "{{ jsonSource | from_json | json_query(query) | regex_replace('Gb') }}"
```

<br>

* faire la somme des ram ?

```
  - name: fact
    set_fact:
      sum_ram: "{{ sum_ram|default(0)|int + item|int }}"
    loop: "{{ jsonSource | from_json | json_query(query) | regex_replace('Gb') }}"
```
