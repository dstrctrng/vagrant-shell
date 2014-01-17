require "log4r"

module VagrantPlugins
  module Shell
    module Action
      # This action connects to Shell, verifies credentials work, and
      # puts the Shell script object into the `:script` key
      # in the environment.
      class ConnectShell
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_shell::action::connect_shell")
        end

        def call(env)
          # Get the region we're going to booting up in
          region = env[:machine].provider_config.region

          # Get the configs
          region_config     = env[:machine].provider_config.get_region_config(region)

          @logger.info("Connecting to Shell...")
          env[:script] = nil

          @app.call(env)
        end
      end
    end
  end
end
