# Work in progress, still QA'ing the demo

# Vagrant Shell Provider

This is a [Vagrant](http://www.vagrantup.com) 1.2+ plugin that adds a
shell provider to Vagrant, allowing Vagrant to control and provision
machines using shell scripts.  It's meant to be customized with scripts
for Xen, Docker, etc.

**NOTE:** This plugin requires Vagrant 1.2+,

vagrant-shell is forked from vagrant-aws with the fog/aws parts replaced
with a shell script that takes four command arguments:

    script run-instance $image_id command args... -> $instance_id
    script terminate-instance $instance_id
    script ssh-info $instance_id -> ssh-host ssh-port
    script read-state $instance_id -> *

See `libexec/shell-docker` for an example.

## Usage

I don't know how to instal vagrant-shell as a plugin, so this repo uses
bundler and cached gems.  Requires ruby 1.9.3 (vagrant).

Run make to bundle gems and install the demo vagrant box:

    make

Bring up the docker container:

    bundle exec vagrant up --provider shell

SSH into the container:

    bundle exec vagrant ssh
