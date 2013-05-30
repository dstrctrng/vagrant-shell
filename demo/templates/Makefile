SCRIPT := $(shell basename $(PWD))
SHELL_SCRIPT := $(SCRIPT)

default: ready

ready: bundler vagrant

bundler:
	bundle --local --path vendor/bundle

vagrant-shell.box: metadata.json
	tar cvfz vagrant-shell.box metadata.json

vagrant: vagrant-shell.box
	bundle exec vagrant box remove vagrant-shell $(SCRIPT) || true
	bundle exec vagrant box add vagrant-shell vagrant-shell.box

shell:
	bundle exec vagrant up || true
	bundle exec vagrant ssh default
