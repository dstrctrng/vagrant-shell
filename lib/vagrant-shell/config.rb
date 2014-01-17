require "vagrant"

module VagrantPlugins
  module Shell
    class Config < Vagrant.plugin("2", :config)

      # The timeout to wait for an instance to become ready.
      #
      # @return [Fixnum]
      attr_accessor :instance_ready_timeout


      # The user data string
      #
      # @return [String]
      attr_accessor :user_data

      # The ID of the Image to use.
      attr_accessor :image

      # The shell script implementing some tech
      attr_accessor :script

      # The shell script run-instance args
      attr_accessor :run_args

      def initialize(region_specific=false)
        @instance_ready_timeout = UNSET_VALUE
        @user_data              = UNSET_VALUE
        @image                  = UNSET_VALUE
        @script                 = UNSET_VALUE
        @run_args               = UNSET_VALUE

        # Internal state (prefix with __ so they aren't automatically
        # merged)
        @__compiled_region_configs = {}
        @__finalized = false
        @__region_config = {}
        @__region_specific = region_specific
      end

      # Allows region-specific overrides of any of the settings on this
      # configuration object. This allows the user to override things like
      # AMI and keypair name for regions. Example:
      #
      #     aws.region_config "us-east-1" do |region|
      #       region.ami = "ami-12345678"
      #       region.keypair_name = "company-east"
      #     end
      #
      # @param [String] region The region name to configure.
      # @param [Hash] attributes Direct attributes to set on the configuration
      #   as a shortcut instead of specifying a full block.
      # @yield [config] Yields a new Shell configuration.
      def region_config(region, attributes=nil, &block)
        # Append the block to the list of region configs for that region.
        # We'll evaluate these upon finalization.
        @__region_config[region] ||= []

        # Append a block that sets attributes if we got one
        if attributes
          attr_block = lambda do |config|
            config.set_options(attributes)
          end

          @__region_config[region] << attr_block
        end

        # Append a block if we got one
        @__region_config[region] << block if block_given?
      end

      #-------------------------------------------------------------------
      # Internal methods.
      #-------------------------------------------------------------------

      def merge(other)
        super.tap do |result|
          # Copy over the region specific flag. "True" is retained if either
          # has it.
          new_region_specific = other.instance_variable_get(:@__region_specific)
          result.instance_variable_set(
            :@__region_specific, new_region_specific || @__region_specific)

          # Go through all the region configs and prepend ours onto
          # theirs.
          new_region_config = other.instance_variable_get(:@__region_config)
          @__region_config.each do |key, value|
            new_region_config[key] ||= []
            new_region_config[key] = value + new_region_config[key]
          end

          # Set it
          result.instance_variable_set(:@__region_config, new_region_config)

          # Merge in the tags
          result.tags.merge!(self.tags)
          result.tags.merge!(other.tags)
        end
      end

      def finalize!
        # Set the default timeout for waiting for an instance to be ready
        @instance_ready_timeout = 120 if @instance_ready_timeout == UNSET_VALUE

        # User Data is nil by default
        @user_data = nil if @user_data == UNSET_VALUE

        # Image must be nil, since we can't default that
        @image = nil if @image == UNSET_VALUE

        # No default shell script
        @script = nil if @script == UNSET_VALUE

        # No run args by default
        @run_args = [] if @run_args == UNSET_VALUE

        # Compile our region specific configurations only within
        # NON-REGION-SPECIFIC configurations.
        if !@__region_specific
          @__region_config.each do |region, blocks|
            config = self.class.new(true).merge(self)

            # Execute the configuration for each block
            blocks.each { |b| b.call(config) }

            # The region name of the configuration always equals the
            # region config name:
            config.region = region

            # Finalize the configuration
            config.finalize!

            # Store it for retrieval
            @__compiled_region_configs[region] = config
          end
        end

        # Mark that we finalized
        @__finalized = true
      end

      def validate(machine)
        errors = _detected_errors

        errors << I18n.t("vagrant_shell.config.region_required") if @region.nil?

        if @region
          # Get the configuration for the region we're using and validate only
          # that region.
          config = get_region_config(@region)

          if !config.use_iam_profile
            errors << I18n.t("vagrant_shell.config.access_key_id_required") if \
              config.access_key_id.nil?
            errors << I18n.t("vagrant_shell.config.secret_access_key_required") if \
              config.secret_access_key.nil?
          end

          errors << I18n.t("vagrant_shell.config.ami_required") if config.ami.nil?
      end

        { "Shell Provider" => errors }
      end

      # This gets the configuration for a specific region. It shouldn't
      # be called by the general public and is only used internally.
      def get_region_config(name)
        if !@__finalized
          raise "Configuration must be finalized before calling this method."
        end

        # Return the compiled region config
        @__compiled_region_configs[name] || self
      end

      # utilities
      def read_script pth_script
        File.read(pth_script).split(/[ \t]*[\r\n]+/).join("; ")
      end

      def find_script name
        try_path = ENV['PATH'].split(/:/).flatten.inject([]) { |acc, p| x = File.join(p,"shell-#{name.to_s}"); File.exists?(x) && acc << x; acc }.first
        if try_path
          return try_path
        end

        try_load = $:.inject([]) { |acc, p| x = File.expand_path("../libexec/shell-#{name.to_s}", p); File.exists?(x) && acc << x; acc }.first
        if try_load
          return try_load
        end
      end
    end
  end
end
