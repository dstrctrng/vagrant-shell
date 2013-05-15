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
	bundle exec vagrant ssh default

ubuntu:
	apt-get install -y ruby1.9.1 ruby1.9.1-dev build-essential libxml2-dev libxslt-dev zlib1g-dev libssl-dev libreadline-dev libyaml-dev 
	gem install bundler
