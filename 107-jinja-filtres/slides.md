%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : FILTRE 1 - Strings & Lists


<br>

* opérateur de comparaison

```
  - name: test
    copy:
      content: |
        {{ (var1 < var2) }}
      dest: /tmp/xavki.txt
```

<br>

* ternaire

```
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
```

--------------------------------------------------------------------------------------------------

# ANSIBLE : FILTRE 1 - Strings & Lists


<br>

* default

```
  - name: test
    copy:
      content: |
        {{ var1 | default("xavki") }}
      dest: /tmp/xavki.txt
```

<br>

* random

```
    {{ ['a','b','c'] | random }}
    {{ 60 | random }} * * * * root /script/from/cron
```

<br>

* random mac

```
    {{ '52' | random_mac }}
    {{ '52:E4' | random_mac }}
```

--------------------------------------------------------------------------------------------------

# ANSIBLE : FILTRE 1 - Strings & Lists


<br>

* min

```
    {{ [5,120,1] | min }}
    {{ [5,120,1] | max }}
```

<br>

* length

```
    {{ [5,120,1] | length }}
```

<br>

* shuffle

```
    {{ ['a','b','c'] | shuffle }}
```

<br>

* flatten

```
    {{ [3, [4, 2] ] | flatten }}
```

Rq : flatten(levels=1)

--------------------------------------------------------------------------------------------------

# ANSIBLE : FILTRE 1 - Strings & Lists

<br>

* unique

```
    {{ [3, 3,1,1,5,2,5,3 ] | unique }}
```

<br>

* union

```
    {{ [1,2,3,4,5] | union(["a","b","c"]) }}
```

<br>

* intersect

```
    {{ [1,2,3,4,5] | intersect([2,3,4,8,9]) }}
```

--------------------------------------------------------------------------------------------------

# ANSIBLE : FILTRE 1 - Strings & Lists

<br>

* difference (attention sens référence à gauche)

```
    {{ [1,2,3,4,5] | difference([2,3,4,8,9]) }}
```
