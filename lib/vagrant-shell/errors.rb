require "vagrant"

module VagrantPlugins
  module Shell
    module Errors
      class VagrantShellError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_shell.errors")
      end

      class ShellError < VagrantShellError
        error_key(:shell_error)
      end

      class InstanceReadyTimeout < VagrantShellError
        error_key(:instance_ready_timeout)
      end

      class RsyncError < VagrantShellError
        error_key(:rsync_error)
      end
    end
  end
end
