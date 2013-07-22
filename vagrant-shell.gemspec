$:.unshift File.expand_path("../lib", __FILE__)
require "vagrant-shell/version"

Gem::Specification.new do |s|
  s.name          = "vagrant-shell"
  s.version       = VagrantPlugins::Shell::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = [ "Tom Bombadil", "Mitchell Hashimoto" ]
  s.email         = [ "amanibhavam@destructuring.org", "mitchell@hashicorp.com" ]
  s.homepage      = "http://destructuring.org/vagrant-shell"
  s.summary       = "Enables Vagrant to manage machines using shell scripts"
  s.description   = "Enables Vagrant to manage machines using shell scripts"

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "vagrant-shell"

  s.files         = Dir["lib/**/*"] + Dir["locales/**/*"]
  s.files        += %w(CHANGELOG.md LICENSE README.md VERSION )
  s.require_path  = 'lib'
end
