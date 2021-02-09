%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : JINJA LIST / DICT et FOR


<br>

* jinja = templating de python

* ressemblance avec le templating go

<br>

* simple variable

```
my_var: "valeur"

{{ my_var}}
```

<br>

* une liste

```
items:
  - valeur1
  - valeur2
  - valeur3
```

Rq : positionnement d'un tiret ( - )

-----------------------------------------------------------------------------------------------

# ANSIBLE : JINJA LIST / DICT et FOR


<br>

* boucle for

```
  tasks:
  - name: debug
    debug:
      msg: |
        {% for item in items %}
        {{ item }}
        {% endfor %}

  - name: copy in /tmp
    copy:
      content: |
        {%- for item in items %}
        {{ item }}
        {%- endfor %}
      dest: /tmp/xavki.txt
```

-----------------------------------------------------------------------------------------------

# ANSIBLE : JINJA LIST / DICT et FOR

<br>

* un dictionnaire avec que des clefs

```
items:
  key1
  key2
  key3
```

*  un vrai dictionnaire

```
items:
  key1: value1
  key2: value2
  key3: value3
```

<br>

* parcourir le dictionnaire

```
        {%- for key,value in items.items() %}
        {{ key }} >> {{ value }}
        {%- endfor %}
```

Rq : comme en python

-----------------------------------------------------------------------------------------------

# ANSIBLE : JINJA LIST / DICT et FOR

<br>

* une liste de dictionnaires

```
  vars:
    items:
        - {k1: v1, k2: v2}
        - {k1: v1, k2: v2}
```

<br>

* parcourir la liste de dictionnaires

```
        {% for item in items %}
        {{ item.k1 }} {{ item.k2 }} 
        {% endfor %}
```

-----------------------------------------------------------------------------------------------

# ANSIBLE : JINJA LIST / DICT et FOR

<br>

* dictionnaire de dictionnaires

```
        {% for item in items %}
        {{ item.k1 }} {{ item.k2 }} 
        {% endfor %}
```

<br>

* 1ère méthode

```
        {% for item in items %}
        {{ items[item].k1 }} - {{ items[item].k2 }} 
        {% endfor %}
```

<br>

* 2ème méthode

```
        {% for item, datas in items.items() %}
        {{ item }} {{ datas.k1 }}
        {% endfor %}
```

-----------------------------------------------------------------------------------------------

# ANSIBLE : JINJA LIST / DICT et FOR

<br>

* dictionnaires de listes

```
    items:
        item2:
          - titi
          - toto
          - tata
        item1:
          - tutu
          - tyty
```

<br>

* parcourir avec items()

```
        {% for item, lines in items.items() %}
        {{ item }}
        {% for line in lines %}
```

-----------------------------------------------------------------------------------------------

# ANSIBLE : JINJA LIST / DICT et FOR

<br>

* et pour ordonnerpar les clefs

```
{% for item, lines in items | dictsort  %}
```


<br>

* ordonner par les valeurs

```
    items:
      titi: z
      toto: d
      tata: a
```

<br>

* utilisation de dictsort

```
        {% for item, value in items | dictsort(by='value') %}
        {{ item }} {{ value }}
        {% endfor %}
```
