require "vagrant-shell"

def read_script pth_script
  File.read(pth_script).split(/[ \t]*[\r\n]+/).join("; ")
end

Vagrant.configure("2") do |config|
  config.vm.box = "vagrant-shell"

  config.vm.provider :shell do |shell, override|
    # use public docker ubuntu
    shell.image = "ubuntu"
    override.ssh.username = "root"

    # vagrant-shell comes with shell-docker to support docker containers
    shell.script = File.expand_path("../libexec/shell-docker", __FILE__)

    # set up vagrant keys, install/configure/run Ubuntu sshd
    shell.run_args = [ "bash -c '#{read_script File.expand_path("../libexec/init-docker", __FILE__)}'" ]

    # don't copy anything to /vagrant
    override.vm.synced_folder ".", "/vagrant", :id => "vagrant-root", :disabled => true
  end
end
