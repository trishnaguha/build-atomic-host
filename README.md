# Build Your Own Atomic Host
Automation of Building your own [Atomic-Host](http://www.projectatomic.io/).
To know about Atomic-Host, please visit [http://www.projectatomic.io](http://www.projectatomic.io/).

# Steps

## Clone Source
```
$ git clone https://github.com/trishnaguha/build-atomic-host.git
$ cd build-atomic-host
```

## Install Ansible
Please Make sure Ansible is intalled in your system.
```
$ sudo dnf install ansible   # Install python2-dnf if you are using Fedora Linux Distribution
```

## Download Atomic QCOW2 Image
Download Fedora Atomic QCOW2 Image: [https://getfedora.org/en/atomic](https://getfedora.org/en/atomic/download/).
You can also download CentOS Atomic QCOW2 Image.


## SetUp Environment
Install Requirements - Start HTTP Server. After running the following playbook you may use `ip addr` to check the IP Address of your HTTP server.
```
$ ansible-playbook setup.yml --ask-sudo-pass
```


## Variables
**Replace the Variables in `vars/atomic.yml` with your httpserver IP Address, OSTree name, Basehost.**

**If you wish to use CentOS Atomic modify the variables accordingly.**

```
---
# Variables for Atomic host
atomicname: my-atomic
basehost: fedora-atomic/25/x86_64/docker-host
httpserver: 192.168.122.1
```


**Add the additional Packages you would like to have in the OSTree in `vars/buildrepo.yml`.**

**If you wish to use CentOS Atomic modify the variables accordingly.**

```
---
# Variables for Atomic repository/OSTree packages
repo: https://pagure.io/fedora-atomic.git
branch: f25
repodir: fedora-atomic
abs_path: /workspace                                  # The absolute path to the git repo.
custommanifest: customized-atomic-docker-host.json    # The manifest that goes into the custom host(ostree) content that we are going to build.
sourcemanifest: fedora-atomic-docker-host.json        # The manifest that goes into the actual Base Fedora host(ostree) content.
packages: '"vim-enhanced", "git"'                     # Packages you want to have in your Atomic host.
```
You can add packages like above in double-qoutes separated by comma.


**Replace Variables for Creating VM from QCOW2 Image.**
**If you wish to use CentOS Atomic modify the variables accordingly.**

```	
# Variables for Creating VM

domain: atomic-node
image: Fedora-Atomic-25-20170228.0.x86_64
cpu: 1
mem: 1536
os:
  variant: fedora23
path: /tmp
```


## Main Playbook
Run the main Playbook which will create VM from QCOW2 image, compose OSTree and perform SSH-Setup and Rebase on OSTree:
```
$ ansible-playbook main.yml --ask-sudo-pass
```
**`user-name: atomic-user, password: atomic` for the instance.**


## Reboot the Host
Now SSH to the Atomic Host and Perform a Reboot which will reboot in to your OSTree:
```
$ sudo systemctl reboot
```


## Verify: SSH to the Atomic Host:

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

* [Gerard Braad](https://gbraad.nl) who mentored me for the project.
* [Jonathan Lebon](https://github.com/jlebon) who demonstrated Building Atomic host workshop in DevConf.CZ, 2017 at Brno. His slides are here: [jlebon-devconf-slides](http://jlebon.com/devconf/slides.pdf).
