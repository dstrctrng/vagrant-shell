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
          system("echo server.destroy #{env[:machine].id}")
          env[:machine].id = nil

          @app.call(env)
        end
      end
    end
  end
end
