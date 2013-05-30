# don't need --provider xxx
ENV['VAGRANT_DEFAULT_PROVIDER'] = ENV['SHELL_SCRIPT'] || 'shell'

# make aliases for :shell provider
(ENV['SHELL_PROVIDERS'] || "").concat(ENV['SHELL_SCRIPT']).split.each do |nm_provider|
  VagrantPlugins::Shell::Plugin.make_provider(nm_provider.to_sym)
end
