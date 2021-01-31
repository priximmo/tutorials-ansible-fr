%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : CALLBACK LOGSTASH

<br>

Documentation : https://docs.ansible.com/ansible/2.8/plugins/callback/logstash.html

Objectifs : loguer dans logstash > ELK

<br>

```
pip3 install python-logstash
cd /usr/share/ansible/plugins/callback/
git clone https://github.com/ujenmr/ansible-logstash-callback
```

Attention : change handlers to TCP
 and comment `_options`

https://github.com/ujenmr/ansible-logstash-callback
https://pypi.org/project/python3-logstash/

```
env ANSIBLE_LOAD_CALLBACK_PLUGINS=yes ANSIBLE_STDOUT_CALLBACK=logstash ansible-playbook -i inv.yml test.yml
```	
