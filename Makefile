default: ready

ready: bundler vagrant

bundler:
	bundle --local --path vendor/bundle

vagrant:
	bundle exec vagrant box remove vagrant-shell shell || true
	bundle exec vagrant box add vagrant-shell vagrant-shell.box

shell:
	docker pull ubuntu
	bundle exec vagrant up --provider shell || true
	bundle exec vagrant ssh
