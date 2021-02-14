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

* début de type

    typeDeVar1: "{{ configuration2 | type_debug }}"

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

