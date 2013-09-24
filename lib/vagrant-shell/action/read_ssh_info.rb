require "log4r"

module VagrantPlugins
  module Shell
    module Action
      # This action reads the SSH info for the machine and puts it into the
      # `:machine_ssh_info` key in the environment.
      class ReadSSHInfo
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_shell::action::read_ssh_info")
        end

        def call(env)
          env[:machine_ssh_info] = read_ssh_info(env[:script], env[:machine])

          @app.call(env)
        end

        def read_ssh_info(script, machine)
          return nil if machine.id.nil?

          # Find the machine
          server = script.servers.get(machine.id)
          if server.nil?
            # The machine can't be found
            @logger.info("Machine couldn't be found, assuming it got destroyed.")
            machine.id = nil
            return nil
          end

          # Read the DNS info
          return {
            :host => server.public_ip_address || server.dns_name || server.private_ip_address,
            :port => server.public_port || server.private_port
          }
        end
      end
    end
  end
end
