Guifi Development Kit (GDK)
===========================

The Guifi Development Kit sets up a development environment for the Guifi.net website using Vagrant on a VirtualBox virtual machine, where the host and guest machines share three folders:
* Guifi Drupal module
* Guifi Budgets Drupal module
* Guifi 2011 Drupal Theme

# Pre-requisites

The GDK uses Vagrant and VirtualBox, as well as some libraries and packages like zlib1g-dev and Git.

## Installation on Debian 8 Jessie

To set up the GDK on a Debian 8 Jessie host, run the following steps to install the required packages.

### VirtualBox
Activate the "contrib" section in ``/etc/apt/sources.list``:
```
deb http://http.debian.net/debian/ jessie main contrib
```
Update the packages repository 
```
apt-get update
```
Install VirtualBox and the Linux headers packages for your host:
```
apt-get install linux-headers-$(uname -r|sed 's,[^-]*-[^-]*-,,') virtualbox
```
### Vagrant
Install Vagrant and the required libraries and packages:
```
apt-get install vagrant zlib1g-dev git
```
## MacOS X

### VirtualBox
Download from [Virtualbox page](https://www.virtualbox.org/wiki/Downloads)

### Vagrant
Download from [Vagrant page](https://www.vagrantup.com/downloads.html)

# Preparing the environment

The environment will be built in a folder named "guifi_dev". You can choose another name, if you prefer. Start by creating it and cloning the GDK repository there:
```
mkdir guifi_dev
cd guifi_dev
git clone https://github.com/agustim/gdk
```
To set up the development environment you need to download the sources:
* Guifi.net module => guifi folder
* Guifi.net budgets module => budgets folder
* Guifi.net 2011 theme => theme_guifinet2011 folder

You can download these sources automatically by running the first_step.sh script:
```
cd gdk
./first_step.sh
```

# Deployment

To deploy the virtual machine with the development environment, go to the guifi_dev folder (or the name you chose) and run:

```
cd gdk
vagrant up
```

The process takes a few minutes. After that, you can start editing the code in your local machine and see the results live at http://localhost:8280

If you need to make changes to the guest virtual machine, you can open a terminal via SSH:
```
vagrant ssh
```
You can suspend the virtual machine with:
```
vagrant suspend
```
