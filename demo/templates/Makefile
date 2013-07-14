SCRIPT := $(shell basename $(PWD))
VAGRANT_DEFAULT_PROVIDER := $(SCRIPT)

export VAGRANT_DEFAULT_PROVIDER

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
	bundle exec vagrant ssh $(shell bundle exec vagrant status | awk '$$2 == "running" && $$3 == "(docker)" { vg[length(vg)] = $$1 } END { print vg[0] }')

destroy:
	bundle exec vagrant destroy -f
