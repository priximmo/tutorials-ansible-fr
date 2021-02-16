%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : URL & DATES


<br>

* exemple d'url

```
url: https://xavki:password@xavki.blog:8080/search/index.html?query=dc1#titre1 
```

Exemple : collecte d'aresse sur des serveurs distants et centralisation/split (hostname, user...)

<br>

* hostname

```
{{ url | urlsplit('hostname') }}
```

<br>

* username

```
{{ url | urlsplit('username') }}
```

-----------------------------------------------------------------------------------------

# ANSIBLE : URL & DATES


<br>

* password

```
{{ url | urlsplit('password') }}
```

<br>

* path :

```
{{ url | urlsplit('path') }}
```

<br>

* port

```
{{ url | urlsplit('port') }}
```

-----------------------------------------------------------------------------------------

# ANSIBLE : URL & DATES

<br>

* scheme

```
{{ url | urlsplit('port') }}
```

<br>

* query

 
```
{{ url | urlsplit('query') }}
```

<br>

* dictionnaire

```

{{ url | urlsplit() }}
```

-----------------------------------------------------------------------------------------

# ANSIBLE : URL & DATES


<br>

* to_datetime : comparer du temps
 
```
{{ "2021-02-16 18:00:00" | to_datetime }}
```

```
mydate: "16 Feb 21 20:00 UTC"
{{ ( mydate | to_datetime("%d %b %y %H:%M %Z")
```


<br>

* calcul sur date

```
{{ ( mydate | to_datetime("%d %b %y %H:%M %Z") - "2021-02-16 18:00:00" | to_datetime ).total_seconds()  }}
{{ ( mydate | to_datetime("%d %b %y %H:%M %Z") - "2021-02-16 18:00:00" | to_datetime ).days }}
```

-----------------------------------------------------------------------------------------

# ANSIBLE : URL & DATES

<br>

* strftime : convertion à partir d'un format

```
date +%s
mydate: 1613504248
{{ '%Y-%m-%d %H:%M:%S' | strftime(mydate) }} 
{{ '%H:%M:%S' | strftime(mydate) }} 
```

-----------------------------------------------------------------------------------------

# ANSIBLE : URL & DATES

<br>

* Mais ansible à d'autres atouts : ansible_date_time

```
{{ ansible_date_time.epoch|int - __stat_hosts.stat.mtime }}
```

<br>

* tous les formats disponibles

```
{{ ansible_date_time }}
```

<br>

* il y a 30 jours

```
{{ (ansible_date_time.epoch | int)-(86400*30) }}
```

<br>

* comparaison

```
{{ (__stat_hosts.stat.mtime) > (ansible_date_time.epoch | int)-(86400*30) }}
```

-----------------------------------------------------------------------------------------

# ANSIBLE : URL & DATES

<br>

* et encore en dernier recours la commande...

```
  - name: commande date
    shell: "date +%Y-%m-%d%H-%M-%S.%5N"
    register: __date_time
  - name: Set variables
    set_fact:
       date: "{{ __date_time.stdout[0:10]}}"
       time: "{{ __date_time.stdout[10:]}}"
```


