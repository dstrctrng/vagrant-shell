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

      class TimeoutError < VagrantShellError
        error_key(:instance_ready_timeout)
      end

      class ComputeError < VagrantShellError
        error_key(:instance_ready_timeout)
      end

      class InstanceReadyTimeout < VagrantShellError
        error_key(:instance_ready_timeout)
      end
    end
  end
end
