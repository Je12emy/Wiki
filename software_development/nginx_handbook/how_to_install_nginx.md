# How to Install NGINX

Installation on a Linux machine is very simple, you will need both Vagrant and Virtualbox. Create a new directory `~/vagrant/nginx-handbook` with a `Vagrantfile` with the following content.

```
Vagrant.configure("2") do |config|

    config.vm.hostname = "nginx-handbook-box"
  
    config.vm.box = "ubuntu/focal64"
  
    config.vm.define "nginx-handbook-box"
  
    config.vm.network "private_network", ip: "192.168.20.20"
  
    config.vm.provider "virtualbox" do |vb|
      vb.cpus = 1
      vb.memory = "1024"
      vb.name = "nginx-handbook"
    end
  
  end
```

In this directory run `vagrant up` and then `vagrant status`, this should show the following output:

```
Current machine states:

nginx-handbook-box           running (virtualbox)
```

We should be able to ssh into this machine with the following `vagrant ssh nginx-handbook-box`, our prompt should change too. This machine is accessible through `http://192.168.20.20`, we can assign a custom domain for it by modifying our hosts file at `/etc/hosts`.

```
192.168.20.20   nginx-handbook.test
```

Now on this virtual machine run the following:

```bash
sudo apt install nginx -y
# Check nginx's status
sudo systemctl status nginx
```

You should now be able to view the nginx startup screen over at `192.168.20.20` or `nginx-handbook.test`.
