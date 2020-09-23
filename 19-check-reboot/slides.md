%title: ANSIBLE
%author: xavki


# ANSIBLE : Check & Reboot


<br>



    - name: update cache
      apt:
        update_cache: yes
        force_apt_get: yes
        cache_valid_time: 3600

    - name: upgrade général
      apt:
        upgrade: dist
        force_apt_get: yes

    - name: vérification à partir du fichier reboot_required
      register: reboot_required_file
      stat:
        path: /var/run/reboot-required
        get_md5: no


    - name: lancement du reboot avec reboot
      reboot:
        msg: "Reboot via ansible"
        connect_timeout: 5
        reboot_timeout: 300
        pre_reboot_delay: 0
        post_reboot_delay: 30
        test_command: uptime
      when: reboot_required_file.stat.exists




