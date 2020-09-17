%title: ANSIBLE
%author: xavki


# ANSIBLE : Idempotence vs Stateful


<br>
Doc : https://docs.ansible.com/ansible/latest/modules/file_module.html
Commande : ansible-doc file


<br>
* touch avec idempotence

```
  - name: touch idempotent
    file:
      path: /tmp/xavki.txt
      state: touch
      mode: 0755
      modification_time: preserve
      access_time: preserve
```

<br>
* à l'inverse

```
  - name: dir sans idempotence
    file:
      path: /tmp/xavki/1/2/3
      state: touch
      mode: 0755
      modification_time: now
      access_time: now
```

