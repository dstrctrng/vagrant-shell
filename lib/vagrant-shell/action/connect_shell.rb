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
          # Get the region we're going to booting up in
          region = env[:machine].provider_config.region

          # Get the configs
          region_config     = env[:machine].provider_config.get_region_config(region)

          # Build the shell config
          shell_config = {
            :provider              => :shell,
            :region                => region
          }
          if region_config.use_iam_profile
            shell_config[:use_iam_profile] = True
          else
            shell_config[:shell_access_key_id] = region_config.access_key_id
            shell_config[:shell_secret_access_key] = region_config.secret_access_key
          end

          shell_config[:endpoint] = region_config.endpoint if region_config.endpoint
          shell_config[:version]  = region_config.version if region_config.version

          @logger.info("Connecting to Shell...")
          env[:shell_compute] = Shell::Compute.new(shell_config)

          @app.call(env)
        end
      end
    end
  end
end
