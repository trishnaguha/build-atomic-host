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
# For example: /var/lib/libvirt/images/Fedora-Atomic-25-20170131.0.x86_64.qcow2
```

**Replace the Variables in `vars/atomic.yml` with your httpserver IP Address and OSTree name.**


Run the main Playbook which will install the requirements, compose OSTree and perform SSH-Setup and Rebase on OSTree:
```
$ ansible-playbook main.yml --ask-sudo-pass
```


Now SSH to the Atomic Host and Perform a Reboot which will reboot in to your OSTree:
```
$ sudo systemctl reboot
```

Verify: SSH to the Atomic Host:

```
$ ssh atomic-user@192.168.122.221
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

## Shout-Out for the following folks:

* [Gerard Braad](https://twitter.com/gbraad) who mentored me for the project.
* [Jonathon Lebon](https://github.com/jlebon) who demonstrated Building Atomic host workshop in DevConf.CZ, 2017 at Brno. His slides are here: [jlebon-devconf-slides](http://jlebon.com/devconf/slides.pdf).
