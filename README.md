guifi_dev
=========
Prepara un entorn de desenvolupament de guifi amb Vagrant sobre una maquina virtual i compartin entre el host i al guest tres carpetes del:
* Modul de guifi
* Modul de pressupostos
* Tema de guifi 2011

# Pre-Requisites

* VirtualBox
* Vagrant

Some libraries are necessari like libxml2:

```
sudo apt-get install zlib1g-dev
```

## Debian (jessie)

### VirtualBox
Active "contrib" component in ``/etc/apt/sources.list`
```
deb http://http.debian.net/debian/ jessie main contrib
```
Update
```
apt-get update
```
Install
```
apt-get install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') virtualbox
```
### Vagrant
```
apt-get install vagrant
```
## MacOS X

### VirtualBox
Download from [Virtualbox page](https://www.virtualbox.org/wiki/Downloads)

### Vagrant
Download from [Vagrant page](https://www.vagrantup.com/downloads.html)

# Requisit

Prepare environment:
```
mkdir guifi_dev
cd guifi_dev
git clone git clone https://github.com:agustim/gdk
```
Prepare sources, you need:
* gufi's module => guifi
* budgets' module => budgets
* theme => theme_guifinet2011
If this is your first time, you can install with first_step.sh:
```
cd gdk
./first_step.sh
```

# Deploy
```
cd gdk
vagrant up
```
A few minutes, you can write code in your local machne and you can view results in
http://localhost:8280
If you need write some changes in guest machine, you can open terminal with ssh.
```
vagrant ssh
```
You can suspend virtual machine with
```
vagrant suspend
```
