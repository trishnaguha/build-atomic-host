# Build Your Own Atomic Host
Automation of Building your own [Atomic-Host](http://www.projectatomic.io/).
To know about Atomic-Host, please visit [http://www.projectatomic.io](http://www.projectatomic.io/).

## Steps

```
$ git clone https://github.com/trishnaguha/build-atomic-host.git
$ cd build-atomic-host
```


Download Fedora Atomic QCOW2 Image: [https://getfedora.org/en/atomic](https://getfedora.org/en/atomic/download/).
Create VM from the Atomic QCOW2 image

```
$ sudo sh create-vm.sh atomic-node /path/to/fedora-atomic25.qcow2
# /path/to/fedora-atomic25.qcow2 = /var/lib/libvirt/images/Fedora-Atomic-25-20170131.0.x86_64.qcow2
```

Run the main Playbook which will install the requirements, compose OSTree and perform SSH-Setup:
```
$ ansible-playbook main.yml --ask-sudo-pass
```

Rebase on the OSTree:

Run this playbook. Use IP Address of your HTTP Server to `httpserver`.
You can use `ip addr` to check the IP Address of the HTTP server.
```
$ ansible-playbook rebase.yml --ask-sudo-pass -i inventory --extra-vars "httpserver=192.168.121.1"
```

Now SSH to the Atomic Host and Perform a Reboot which will reboot in to your OSTree:
```
$ sudo systemctl reboot
```

Verify: SSH to the Atomic Host:

```
[tguha@dhcp193-94 ~]$ ssh atomic-user@192.168.121.221
[atomic-user@atomic-node ~]$ sudo rpm-ostree status
State: idle
Deployments:
● my-atomic:fedora-atomic/25/x86_64/docker-host
       Version: 25.1 (2017-02-07 05:34:46)
        Commit: 15b70198b8ec7fd54271f9672578544ff03d1f61df8d7f0fa262ff7519438eb6
        OSName: fedora-atomic

  fedora-atomic:fedora-atomic/25/x86_64/docker-host
       Version: 25.51 (2017-01-30 20:09:59)
        Commit: f294635a1dc62d9ae52151a5fa897085cac8eaa601c52e9a4bc376e9ecee11dd
        OSName: fedora-atomic
```
