default: ready

ready: bundler vagrant

bundler:
	bundle --local --path vendor/bundle

vagrant:
	bundle exec vagrant box remove vagrant-shell shell || true
	bundle exec vagrant box add vagrant-shell vagrant-shell.box

shell:
	bundle exec vagrant up || true
	bundle exec vagrant ssh
