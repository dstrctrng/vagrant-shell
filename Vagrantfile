require "vagrant-shell"

Vagrant.configure("2") do |config|
  config.vm.provider :shell do |shell, override|
    override.vm.box = "raring"
    shell.script = File.expand_path("../libexec/shell-docker", __FILE__)
    shell.run_args = %w(/usr/sbin/sshd -D)
    override.ssh.username = "root"
    override.vm.synced_folder ".", "/vagrant", :id => "vagrant-root", :disabled => true
  end
end
