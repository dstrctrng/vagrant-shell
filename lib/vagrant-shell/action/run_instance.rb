require "log4r"
require "pp"

require 'vagrant/util/retryable'

require 'vagrant-shell/util/timer'

module VagrantPlugins
  module Shell
    module Action
      # This runs the configured instance.
      class RunInstance
        include Vagrant::Util::Retryable

        def initialize(app, env)
          @app    = app
          @logger = Log4r::Logger.new("vagrant_shell::action::run_instance")
        end

        def call(env)
          # Initialize metrics if they haven't been
          env[:metrics] ||= {}

          # Get the configs
          provider_config = env[:machine].provider_config
          ami                = provider_config.ami
          user_data          = provider_config.user_data

          # Launch!
          env[:ui].info(I18n.t("vagrant_shell.launching_instance"))
          env[:ui].info(" -- AMI: #{ami}")

          begin
            options = {
              :image_id           => ami,
              :user_data          => user_data
            }

            # Immediately save the ID since it is created at this point.
            system("echo server.create #{options[:image_id]} #{options[:user_data]}")
            env[:machine].id = rand(900) + 100
          rescue Shell::Compute::Error => e
            raise Errors::ShellError, :message => e.message
          end


          # Wait for the instance to be ready first
          env[:metrics]["instance_ready_time"] = Util::Timer.time do
            tries = provider_config.instance_ready_timeout / 2

            env[:ui].info(I18n.t("vagrant_shell.waiting_for_ready"))
            begin
              retryable(:on => Shell::Errors::TimeoutError, :tries => tries) do
                # If we're interrupted don't worry about waiting
                next if env[:interrupted]

                # Wait for the server to be ready
                true
              end
            rescue Shell::Errors::TimeoutError
              # Delete the instance
              terminate(env)

              # Notify the user
              raise Errors::InstanceReadyTimeout,
                timeout: provider_config.instance_ready_timeout
            end
          end

          @logger.info("Time to instance ready: #{env[:metrics]["instance_ready_time"]}")

          if !env[:interrupted]
            env[:metrics]["instance_ssh_time"] = Util::Timer.time do
              # Wait for SSH to be ready.
              env[:ui].info(I18n.t("vagrant_shell.waiting_for_ssh"))
              while true
                # If we're interrupted then just back out
                break if env[:interrupted]
                break if env[:machine].communicate.ready?
                sleep 2
              end
            end

            @logger.info("Time for SSH ready: #{env[:metrics]["instance_ssh_time"]}")

            # Ready and booted!
            env[:ui].info(I18n.t("vagrant_shell.ready"))
          end

          # Terminate the instance if we were interrupted
          terminate(env) if env[:interrupted]

          @app.call(env)
        end

        def recover(env)
          return if env["vagrant.error"].is_a?(Vagrant::Errors::VagrantError)

          if env[:machine].provider.state.id != :not_created
            # Undo the import
            terminate(env)
          end
        end

        def terminate(env)
          destroy_env = env.dup
          destroy_env.delete(:interrupted)
          destroy_env[:config_validate] = false
          destroy_env[:force_confirm_destroy] = true
          env[:action_runner].run(Action.action_destroy, destroy_env)
        end
      end
    end
  end
end
