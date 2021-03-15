%title: ANSIBLE
%author: xavki
%Vidéos: [Formation Ansible](https://www.youtube.com/playlist?list=PLn6POgpklwWoCpLKOSw3mXCqbRocnhrh-)
%blog: [Xavki Blog](https://xavki.blog)


# ANSIBLE : PRESEED > INSTALL ANSIBLE PULL

<br>

Vidéo précédente : ansible push > ansible pull

<br>

* TP

Preseed > ansible push local > ansible pull

<br>

```
d-i preseed/late_command string \
  in-target sh -c "git clone https://xavki:mtcmVP2BiggViyax_EAD@gitlab.com/xavki/pre_install_ansible.git /root/preinstall"; \
  in-target sh -c "chmod 755 /root/preinstall/run.sh"; \
  in-target /bin/sh -c "/root/preinstall/run.sh";
```
