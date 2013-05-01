require "log4r"

module VagrantPlugins
  module Shell
    module Action
      # This action connects to Shell, verifies credentials work, and
      # puts the Shell connection object into the `:shell_compute` key
      # in the environment.
      class ConnectShell
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_shell::action::connect_shell")
        end

        def call(env)
          # Build the shell config
          shell_config = {
            :provider              => :shell
          }

          @logger.info("Connecting to Shell...")
          env[:shell_compute] = Shell::Compute.new(shell_config)

          @app.call(env)
        end
      end
    end
  end
end
