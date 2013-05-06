default: ready

ready: bundler vagrant

bundler:
	bundle --local --path vendor/bundle

vagrant:
	bundle exec vagrant box remove vagrant-shell-demo shell || true
	bundle exec vagrant box add vagrant-shell-demo vagrant-shell-demo.box
