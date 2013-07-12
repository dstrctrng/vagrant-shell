require "vagrant"

module VagrantPlugins
  module Shell
    class Config < Vagrant.plugin("2", :config)
      # The ID of the Image to use.
      #
      # @return [String]
      attr_accessor :image

      # The timeout to wait for an instance to become ready.
      #
      # @return [Fixnum]
      attr_accessor :instance_ready_timeout

      # The user data string
      #
      # @return [String]
      attr_accessor :user_data

      # The shell script implementing some tech
      # 
      # @return [String]
      attr_accessor :script

      # The shell script run-instance args
      # 
      # @return [String]
      attr_accessor :run_args

      def initialize
        @image                  = UNSET_VALUE
        @instance_ready_timeout = UNSET_VALUE
        @user_data              = UNSET_VALUE
        @script                 = UNSET_VALUE
        @run_args               = UNSET_VALUE

        # Internal state (prefix with __ so they aren't automatically
        # merged)
        @__finalized = false
      end

      #-------------------------------------------------------------------
      # Internal methods.
      #-------------------------------------------------------------------

      def merge(other)
        super.tap do |result|
        end
      end

      def finalize!
        # Image must be nil, since we can't default that
        @image = nil if @image == UNSET_VALUE

        # Set the default timeout for waiting for an instance to be ready
        @instance_ready_timeout = 120 if @instance_ready_timeout == UNSET_VALUE

        # User Data is nil by default
        @user_data = nil if @user_data == UNSET_VALUE

        # No default shell script
        @script = nil if @script == UNSET_VALUE

        # No rub args by default
        @run_args = [] if @run_args == UNSET_VALUE

        # Mark that we finalized
        @__finalized = true
      end

      def validate(machine)
        { "Shell Provider" => [ ] } 
      end

      # utilities
      def read_script pth_script
        File.read(pth_script).split(/[ \t]*[\r\n]+/).join("; ")
      end

      def find_script name
        ENV['PATH'].split(/:/).flatten.inject([]) { |acc, p| x = File.join(p,"shell-#{name.to_s}"); File.exists?(x) && acc << x; acc }.first
      end

    end
  end
end
