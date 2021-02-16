%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : REGEX & RAW


<br>

* regexp_search

```
        {% set url = 'xavki.blog' %}
        {% if url | regex_search('xavki') %}
           On est bien là...
        {% else %}
           Je t'invite à voir xavki
        {% endif %}
```

<br>

* regex_search : insensitif à la case

```
        {% if url | regex_search('xavki', ignorecase=True) %}
```

---------------------------------------------------------------------------------

# ANSIBLE : REGEX & RAW


<br>

* regex_findall

```
{{ texte | regex_findall('(xav[a-z]*)+')}}
```

<br>

* regex_replace : cas simple

```
        {{ texte | regex_replace('(xav[a-z]*)+','REMPLACEMENT')}}
```

<br>

* regex_replace : avec capture et réutilisation

```
        {{ texte | regex_replace('(xav[a-z]*)+','\1 blog')}}

```

---------------------------------------------------------------------------------

# ANSIBLE : REGEX & RAW

<br>

* regex_replace : suppression

```
        {{ texte | regex_replace('(xav[a-z]*)+')}}

```

<br>

* regex_escape : échappement des caractères spéciaux

```
        {{ '^f.*o(.*)$' | regex_escape() }}
```

---------------------------------------------------------------------------------

# ANSIBLE : REGEX & RAW

<br>

* balises raw

```
  {% raw %}
  {% endraw %}
```
