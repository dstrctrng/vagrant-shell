require "vagrant-shell"

Vagrant.configure("2") do |config|
  config.vm.box = "vagrant-shell-demo"

  config.vm.provider :shell do |shell, override|
    # override docker image name with shell.image
    # shell.image = "ubuntu"
    
    # vagrant-shell comes with shell-docker to support docker containers
    shell.script = File.expand_path("../libexec/shell-docker", __FILE__)

    # set up vagrant keys, install/configure/run Ubuntu sshd
    shell.run_args = [ 'bash -c "mkdir -p /root/.ssh/authorized_keys; curl -s https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub > /root/.ssh/authorized_keys; aptitude install -y openssh-server; mkdir -p /var/run/sshd; exec /usr/sbin/sshd -D"' ]

    # ssh in as root, might need to be ubuntu or vagrant depending on the image
    override.ssh.username = "root"

    # don't copy anything to /vagrant
    override.vm.synced_folder ".", "/vagrant", :id => "vagrant-root", :disabled => true
  end
end
