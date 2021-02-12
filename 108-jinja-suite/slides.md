%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : FILTRE 1 - Strings & Lists


* capitalize : majuscule premier caractère


```
  - name: debug
    debug:
      msg: |
        {{ var1 | capitalize }}
```

<br>

* join : concatener une liste

```
{{ var1 | join(" ") | capitalize }}
```

<br>

* default

  - name: test
    copy:
      content: |
        {{ var1 | default("xavki") }}
      dest: /tmp/xavki.txt

<br>

* random

    {{ ['a','b','c'] | random }}
    {{ 60 | random }} * * * * root /script/from/cron

<br>

* random mac

    {{ '52' | random_mac }}
    {{ '52:E4' | random_mac }}

<br>

* min

    {{ [5,120,1] | min }}
    {{ [5,120,1] | max }}

<br>

* length

    {{ [5,120,1] | length }}

<br>

* shuffle

    {{ ['a','b','c'] | shuffle }}

<br>

* flatten

    {{ [3, [4, 2] ] | flatten }}

Rq : flatten(levels=1)

<br>

* unique

    {{ [3, 3,1,1,5,2,5,3 ] | unique }}


<br>

* union

    {{ [1,2,3,4,5] | union(["a","b","c"]) }}


<br>

* intersect

    {{ [1,2,3,4,5] | intersect([2,3,4,8,9]) }}

<br>

* difference (attention sens référence à gauche)

    {{ [1,2,3,4,5] | difference([2,3,4,8,9]) }}

<br>

* opérateur de comparaison

  - name: test
    copy:
      content: |
        {{ (var1 < var2) }}
      dest: /tmp/xavki.txt

<br>

* ternaire

  vars:
    var1: 10
    var2: 20
    configuration1: |
      ceci est ma conf 1
    configuration2: |
      ceci est ma conf 2
  tasks:
  - name: test
    copy:
      content: |
        {{ (var1 > var2) | ternary(configuration1, configuration2) }}
      dest: /tmp/xavki.txt

<br>

* type

  vars:
    var1: 10
    var2: 20
    configuration1: |
      ceci est ma conf 1
    configuration2: |
      ceci est ma conf 2
    typeDeVar1: "{{ configuration2 | type_debug }}"
  tasks:
  - name: test
    copy:
      content: |
        {{ typeDeVar1 }}
      dest: /tmp/xavki.txt

<br>

* combine : concaténation de dictionnaires

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

Rq : merge les listes (dernier l'emporte si valeur diff)


<br>

* récupérer des éléments du liste pur en refaire une autre

{{ [0,2] | map('extract', ['x','y','z']) | list }}

{{ ['x','y'] | map('extract', {'x': 42, 'y': 31, 'z': 53}) | list }}

<br>

* créer une lite de tuples

{{ [1,2,3,4,5] | zip(['a','b','c','d','e','f']) | list }}

<br>

