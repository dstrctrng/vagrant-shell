require "vagrant-shell"

Vagrant.configure("2") do |config|
  config.vm.provider :shell do |shell, override|
    override.vm.box = "vagrant-shell-demo"
    shell.script = File.expand_path("../libexec/shell-docker", __FILE__)
    shell.run_args = [ 'bash -c "mkdir -p /root/.ssh/authorized_keys; curl -s https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub > /root/.ssh/authorized_keys; aptitude install -y openssh-server; mkdir -p /var/run/sshd; exec /usr/sbin/sshd -D"' ]
    override.ssh.username = "root"
    override.vm.synced_folder ".", "/vagrant", :id => "vagrant-root", :disabled => true
  end
end
