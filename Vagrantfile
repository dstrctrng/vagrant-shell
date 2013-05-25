require "vagrant-shell"

ENV['VAGRANT_DEFAULT_PROVIDER'] = 'shell'

if %w(self).member? ENV['SHELL_SCRIPT']
  module Vagrant
    module Util
      class Platform
        def self.solaris?
          true
        end
      end
    end
  end

  require "net/ssh"

  module Net::SSH
    class << self
      alias_method :old_start, :start
      
      def start(host, username, opts)
        opts[:keys_only] = false
        self.old_start(host, username, opts)
      end
    end
  end 
end

def read_script pth_script
  File.read(pth_script).split(/[ \t]*[\r\n]+/).join("; ")
end

def find_script name
  File.expand_path("../libexec/shell-#{name}", __FILE__)
end

Vagrant.configure("2") do |config|
  config.vm.box = "vagrant-shell"

  config.vm.provision :shell, :inline => "uname -a"

  script = ENV['SHELL_SCRIPT'] || "docker"

  case script
  when "aws"
    config.vm.provider :shell do |shell, override|
      override.ssh.username = "ubuntu"
      override.ssh.private_key_path = ENV['AWS_SSH_PRIVATE']
      shell.image = ENV['AWS_AMI']

      # vagrant-shell comes with shell-docker to support docker containers
      shell.script = find_script(script)
    end
  else
    [ :default, :memcache, :mysql, :redis, :app, :admin ].each do |mm|
      config.vm.define mm do |container|
        container.vm.provider :shell do |shell, override|
          case script
          when "self"
            # use local user for localhost
            override.ssh.username = ENV['LOGNAME']
          when "docker"
            # public docker ubuntu only has root
            override.ssh.username = "root"
          end

          shell.image = "ubuntu"

          # vagrant-shell comes with shell-docker to support docker containers
          shell.script = find_script(script)
      
          # set up vagrant keys, install/configure/run Ubuntu sshd
          shell.run_args = [ "bash -c '#{read_script File.expand_path("../libexec/init-docker", __FILE__)}'" ]
        end
      end
    end
  end
end
