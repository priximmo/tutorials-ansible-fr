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

```
self.handler = logstash.TCPLogstashHandler(
```

 and comment `_options`

```
            # if self._options is not None:
            #  self.base_data['ansible_checkmode'] = self._options.check
            #  self.base_data['ansible_tags'] = self._options.tags
            #  self.base_data['ansible_skip_tags'] = self._options.skip_tags
            #  self.base_data['inventory'] = self._options.inventory
```

https://github.com/ujenmr/ansible-logstash-callback
https://pypi.org/project/python3-logstash/

---------------------------------------------------------------------------------------------------------

# ANSIBLE : CALLBACK LOGSTASH

<br>

* configuration du ansible.cfg

```
[default]
callback_whitelist = logstash
host_key_checking = False
[callback_logstash]
port = 5000
server = 192.168.13.10
```

<br>

* lancement du playbook

```
env ANSIBLE_LOAD_CALLBACK_PLUGINS=yes ANSIBLE_STDOUT_CALLBACK=logstash ansible-playbook -i inv.yml test.yml
```	
