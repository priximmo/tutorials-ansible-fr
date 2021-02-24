%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : JINJA - JSON / YAML

<br>

```
[{
  "hostname": "host1",
  "customProperties": {
    "foo": "first",
    "foo2": "second"
  }
}, {
   "hostname": "host2",
   "customProperties": {
     "foo": "third",
     "foo2": "fourth"
  }
}]
```



- name: test
  hosts: localhost
  connection: local
  vars:
    hostList: "{{ lookup('file', 'my.json') }}"
  tasks:

  - name: 1
    debug:
      msg: |
        {{ hostList | to_yaml }}


  - name: 2
    debug:
      msg: "{{ (hostList | to_nice_yaml).split('\n') }}"


