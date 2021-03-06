require "log4r"

module VagrantPlugins
  module Shell
    module Action
      # This terminates the running instance.
      class TerminateInstance
        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_shell::action::terminate_instance")
        end

        def call(env)
          # Destroy the server and remove the tracking ID
          env[:ui].info(I18n.t("vagrant_shell.terminating"))
          output = %x{ #{env[:machine].provider_config.script} terminate-instance #{env[:machine].id}}
          if $?.to_i > 0
            raise Errors::ShellError, :message => "Failure: #{env[:machine].provider_config.script} terminate-instance #{env[:machine].id}"
          end

          puts output

          env[:machine].id = nil

          @app.call(env)
        end
      end
    end
  end
end
