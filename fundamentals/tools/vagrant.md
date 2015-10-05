# A Vagrant tutorial

This tutorial introduces Vagrant, a tool for managing virtual machines.

Specifically, the tutorial covers:

* Installing and configuring Vagrant
* Using Vagrant to create and manage a simple virtual machine
* How Vagrant is used in DAMS

You should follow along with the tutorial, and refer to the [Vagrant documentation](https://www.vagrantup.com) if you'd like any more detailed explanations.

## Installation and Configuration

Vagrant (and VirtualBox) is installed on all Linux machines in the student labs. However, it will by default store all VM images in your home directory. These images are often large (several GBs), so I instead recommend that you install your VM images to a temporary directory. To do this, run the following command from the terminal:

```sh
VBoxManage setproperty machinefolder /tmp
```

**Run this command before doing anything else with Vagrant.** You should only have to do this now, and never again (on your university/departmental account).

Check that everything is working by running `vagrant` from the terminal. You should see something like this:

```
Usage: vagrant [options] <command> [<args>]

    -v, --version                    Print the version and exit.
    -h, --help                       Print this help.

Common commands:
```

## Using Vagrant

Vagrant can create and manage virtual machines automatically.

### Creating a VM

First, we have to tell Vagrant what kind of virtual machine we'd like: what operating system, what software should be installed, how should networking be configured, etc.

To do this, create a file called `Vagrantfile` with the following content:

```
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
  end
end
```

This configuration tells Vagrant to manage a VM with the Ubuntu operating system via VirtualBox, and to allocated 1GB of memory to the VM.

In the terminal:

1. Navigate to the directory containing your vagrant file: e.g., `cd dams/vagrant_tutorial/`
2. Use Vagrant to create a VM meeting your specifications: `vagrant up`

You will see the following output:

```
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Importing base box 'ubuntu/trusty64'...
...
```

After a few minutes you will see:

```
==> default: Checking for guest additions in VM...
==> default: Mounting shared folders...
    default: /vagrant => /<YOUR HOME DIR>/dams/vagrant_tutorial
```

If everything has worked correctly, running `vagrant status` should display:

```
Current machine states:

default                   running (virtualbox)

The VM is running. To stop this VM, you can run `vagrant halt` to
shut it down forcefully, or you can run `vagrant suspend` to simply
suspend the virtual machine. In either case, to restart it again,
simply run `vagrant up`.
```

### Using a VM

The most straightforward way to use your new VM is via a shell session. Let's try this now:

1. Run `vagrant ssh`. You will see a welcome message that starts with something like: `Welcome to Ubuntu 14.04.2 LTS (GNU/Linux 3.13.0-55-generic x86_64)`
2. Notice the shell prompt now reads: `vagrant@vagrant-ubuntu-trusty-64`. Notice how it is different to your typical terminal prompt. This indicates that any commands you issue will be executed on the VM, and not on the physical machine you are using.
3. Let's try changing the hostname of the machine, which is something that we wouldn't be able to do on a typical student lab machine:

```
echo awesomebox | sudo tee /etc/hostname
sudo hostname -F /etc/hostname
```

If you disconnect from the VM (`exit`) and reconnect (`vagrant ssh`). You should see that the shell prompt now reads `vagrant@awesomebox`, meaning that the two commands above have worked.

### Provisioning a VM

A fresh Vagrant box is normally of very little use until various configuration steps, known as provisioning, have been performed. Provisioning involves installing additional application dependencies (e.g., web servers, programming language runtimes) and other tools (e.g., firewalls, log rotation, etc.) Vagrant makes it easy to automate provisioning via shell scripts, and other more sophisticated tools.

You won't need to setup you own provisioning scripts in DAMS (as I have done this for you), but if you're curious take a look at the [Vagrant website](https://docs.vagrantup.com/v2/provisioning/index.html).

### Vagrant VMs should be temporary

Because creating and provisioning is automatic, it's very good practice to treat Vagrant VMs as volatile. This means two things: firstly, don't reconfigure the VM manually via `vagrant ssh` as these changes won't be repeatable when you next need to create a fresh VM. Secondly, don't store any data or code only on the VM's filesystem.

When using Vagrant in the CS student lab, it's particularly important to heed this advice: Vagrant VMs are **very** temporary. They are stored in `/tmp`, which means that they are not associated with your user account. Furthermore, they may not be accessible even if you log into the same student machine each time. So, in short, be prepared to run `vagrant up` every time you start to do some DAMS work on a CS student lab machine. If configuring and provisioning a VM (i.e., running `vagrant up`) is taking more than a minute or two, **this is a bug**. Please tell me so that either I or IT Services can fix it ASAP!

### Other useful VM commands

You will mostly use the `vagrant up` and possibly the `vagrant ssh` commands in DAMS. There are some other vagrant commands that might be occasionally useful:

* `vagrant status` - reports whether or not your VM is running and is healthy
* `vagrant reload` - restarts your VM (and uses any new Vagrantfile configuration)
* `vagrant halt` - stops your VM
* `vagrant destroy` - stops and completely erases all trace of the VM: this is your ejector seat if your VM gets corrupted!

### Inaccessible VMs

When using Vagrant in the CS software labs, you will almost certainly encounter an "inaccessible VM" error which will prevent Vagrant from doing any useful work. If this happens to you, open VirtualBox and delete any boxes that relate to DAMS. You should then be able to run `vagrant up` to build a fresh box from scratch.


## DAMS and Vagrant

In DAMS, Vagrant is used for almost all of the practicals and for the system used in your assessment. This is for two reasons:

1. It ensures that we can use the very latest Ruby and Gems (Ruby software packages). The Ruby community moves very quickly, and it's important for us to be able to keep up throughout the duration of DAMS.

2. For the assessment, it means that you are able to very closely emulate the real, production environment of the system that you are to maintain. This is very good practice, and will reduce (though not eliminate :-P) the pain that you suffer during your DAMS assessment ;-)

The Git repositories for the practicals and for the assessment provide a Vagrantfile, which should produce a working VM when you run "vagrant up". See the README.md files in each of these Git repositories for more details.

### An Important Tip

You will often need to run commands on your Vagrant VMs, and doing so via `vagrant ssh` is cumbersome. Instead, you can add the following line to the end of your `~/.bash_profile` (or equivalent):

```sh
vado() { vagrant ssh -c "cd /vagrant && $1 $2 $3 $4 $5 $6 $7 $8 $9" ;}
```

Restart your terminal, and you should now be able to type `vado COMMAND_TO_RUN_ON_VM`.

For example: `vado rake test`

If the output from this command isn't familiar to you, it's time to take a look at the RSpec [video](http://dams.flippd.it/videos/4) and [tutorial](../rspec/1_introduction.md).
