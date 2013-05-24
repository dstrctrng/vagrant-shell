# Vagrant Shell Provider

This is a [Vagrant](http://www.vagrantup.com) 1.2+ plugin that adds a
shell provider to Vagrant, allowing Vagrant to control and provision
machines using shell scripts.  It's meant to be customized with scripts
for Xen, Docker, etc.

vagrant-shell is forked from vagrant-aws with the fog/aws parts replaced
with a shell script that takes four sub-commands: run-instance,
terminate-instance, ssh-info, and read-state.

See `libexec/shell-docker` for an example.

**NOTE:** This plugin requires Vagrant 1.2+, ruby 1.9, and bundler.  This
README was tested using Ubuntu Raring.

## Usage

I don't know how to install vagrant-shell as a plugin, so this repo uses
bundler and cached gems.

Run make to bundle gems, install the demo vagrant box:

    make

Download the ubuntu docker image:

    docker pull ubuntu

Bring up the docker containers:

    bundle exec vagrant up

The commands passed to the container are sourced from `libexec/init-docker`.
It sets up the root user with an ssh key suitable for vagrant.

SSH into one of the the containers:

    bundle exec vagrant ssh default

## TODO

vagrant package
vagrant status
vagrant reload?
