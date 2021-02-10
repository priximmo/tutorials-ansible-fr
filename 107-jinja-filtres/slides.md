%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : Jinja Filtres


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

