require "vagrant"

module VagrantPlugins
  module Shell
    class Config < Vagrant.plugin("2", :config)
      # The ID of the AMI to use.
      #
      # @return [String]
      attr_accessor :ami

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

      def initialize
        @ami                    = UNSET_VALUE
        @instance_ready_timeout = UNSET_VALUE
        @user_data              = UNSET_VALUE
        @script                 = UNSET_VALUE

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
        # AMI must be nil, since we can't default that
        @ami = nil if @ami == UNSET_VALUE

        # Set the default timeout for waiting for an instance to be ready
        @instance_ready_timeout = 120 if @instance_ready_timeout == UNSET_VALUE

        # User Data is nil by default
        @user_data = nil if @user_data == UNSET_VALUE

        # No default shell script
        @script = nil if @script == UNSET_VALUE

        # Mark that we finalized
        @__finalized = true
      end

      def validate(machine)
        { "Shell Provider" => [ ] } 
      end
    end
  end
end
