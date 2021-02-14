%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : FILTRE 1 - Files & suites


<br>

* capitalize : majuscule premier caractère


```
  - name: debug
    debug:
      msg: |
        {{ var1 | capitalize }}
```

<br>

* file/directory...

```
{{ path is file }}
{{ path is directory }}
{{ path is exists }}
{{ path is abs }}
{{ path is mount }}
{{ path is link }}
```

<br>

* opérateur ansible

```
{{ __result is success }}
{{ __result is changed }}
{{ __result is changed }}
{{ __result is failed }}
{{ ansible_facts['distribution_version'] is version('10', '>=') }}
{{ variable is vault_encrypted }}
```

<br>

* join : concatener une liste

```
{{ var1 | join(" ") | capitalize }}
```

<br>

* split 

```
{{ "192.168.0.17".split(".") }}
{{ "192.168.0.17".split(".") | join("/") }}
```

<br>

* bit vs bytes (1B = 8b)

```
{{ 102400000|human_readable(unit="G") }}
{{ 102400000|human_readable(isbits=True, unit="G") }}
```

* et l'inverse

```
{{'10.00 KB'|human_to_bytes}}
{{'10.00 Kb'|human_to_bytes(isbits=True)}}
```

<br>

* début de type

```
typeDeVar1: "{{ configuration2 | type_debug }}"
```

<br>

* combine : concaténation de dictionnaires

```
  vars:
    var1: 
      - a: 1
      - b: 2
      - c: 3
    var2: 
      - A: 3
      - B: 4
      - C: 5
    var3: 
      - A: 6
      - E: 4
      - F: 5
  tasks:
  - name: test
    copy:
      content: |
        {{ var1 | combine(var2,var3) }}
      dest: /tmp/xavki.txt
```

Rq : merge les listes (dernier l'emporte si valeur diff)

<br>

* récupérer des éléments du liste pur en refaire une autre

```
{{ [0,2] | map('extract', ['x','y','z']) | list }}
```

```
{{ ['x','y'] | map('extract', {'x': 42, 'y': 31, 'z': 53}) | list }}
```

<br>

* créer une lite de tuples

```
{{ [1,2,3,4,5] | zip(['a','b','c','d','e','f']) | list }}
```

<br>

* définir la liste dans le jinja

```
{% set myList = [ 1 , 2 , 3 ] %}
{% for value in myList %}
    {% if value is divisibleby(3) %}
         La valeur {{ value }} est divisible par 3
    {% else %}
         La valeur {{ value }} n'est pas divisible par 3
{% endfor %}
```
