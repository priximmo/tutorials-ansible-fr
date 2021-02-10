%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : JINJA CONDITIONS


<br>

condition classique :

```
	{% IF <cond1> %}
	{% ELSIF <cond2> %}
	{% ELSE %}
  {% ENDIF %}
```

<br>

* Opérateurs de comparaison : ==, !=, >, >=, <, <=

* Opérateurs logique : and / or / not

* Boolean / Vérification : define / number / string / mapping (dict) / iterable (list,string,dict)

----------------------------------------------------------------------------------

# ANSIBLE : JINJA CONDITIONS


<br>

* comparaison et 1 condition

```
- name: jinja1
  hosts: all
  vars:
    var1: 11
    var2: 200.2
  tasks:
  - name: copy in /tmp
    copy:
      content: |
        {% if var1 < 11 %}
        {{ var1 }} est inf à 11
        {% else %}
        {{ var1 }} est sup ou égale à 11
        {% endif %}
      dest: /tmp/xavki.txt
```


----------------------------------------------------------------------------------

# ANSIBLE : JINJA CONDITIONS


* plusieurs conditions

```
        Début
        {% if var1 < var2 %}
        var1 est inf à var2
        {% elif var1 == var2 %}
        var1 égale à var2
        {% else %}
        var1 est sup ou égale à var2
        {% endif %}
        Fin
```

----------------------------------------------------------------------------------

# ANSIBLE : JINJA CONDITIONS

<br>

* définition ou true/false

```
        Début
        {% if var1 %}
        var1 est définie
        {% else %}
        var1 n'est pas définie
        {% endif %}
        Fin
```

<br>

* ou

```
        Début
        {% if var1 is defined %}
        var1 est définie
        {% else %}
        var1 n'est pas définie
        {% endif %}
        Fin
```

----------------------------------------------------------------------------------

# ANSIBLE : JINJA CONDITIONS


<br>

* la négation

```
        Début
        {% if var1 is not defined %}
        var1 est définie
        {% else %}
        var1 n'est pas définie
        {% endif %}
        Fin
```

<br>

* ou 

```
        {% if not var1 == 1 %}
        {{ var1 }} true
        {% else %}
        {{ var1 }} false
        {% endif %}
```

----------------------------------------------------------------------------------

# ANSIBLE : JINJA CONDITIONS

<br>

ou aussi

```
        {% if var1 != 1 %}
        {{ var1 }} true
        {% else %}
        {{ var1 }} false
        {% endif %}
```


----------------------------------------------------------------------------------

# ANSIBLE : JINJA CONDITIONS


<br>

* les opérateurs logiques

```
        Début
        {% if var1 is defined and var2 is not defined %}
        var1 est définie
        {% else %}
        var1 n'est pas définie
        {% endif %}
        Fin
```

----------------------------------------------------------------------------------

# ANSIBLE : JINJA CONDITIONS

<br>

* test de string

```
        Début
        {% if var1 is string %}
        var1 est définie
        {% else %}
        var1 n'est pas définie
        {% endif %}
        Fin
```

----------------------------------------------------------------------------------

# ANSIBLE : JINJA CONDITIONS

<br>

* test du number

```
        Début
        {% if var1 is number %}
        var1 est number
        {% else %}
        var1 n'est pas number
        {% endif %}
        Fin
```

----------------------------------------------------------------------------------

# ANSIBLE : JINJA CONDITIONS

<br>

* test du mapping

```
        Début
        {% if var1 is mapping %}
        var1 est mapping
        {% else %}
        var1 n'est pas mapping
        {% endif %}
        Fin
```

----------------------------------------------------------------------------------

# ANSIBLE : JINJA CONDITIONS

<br>

* test du iterable

```
        Début
        {% if var1 is iterable %}
        var1 est iterable
        {% else %}
        var1 n'est pas iterable
        {% endif %}
        Fin   
```
