
This repository contains a sample continuous integration setup focused on security testing.

## Getting started

First install [Vagrant](http://vagrantup.com), which we're using the
manage the virtual machines on which we're installing the tools.

Once you have Vagrant installed you'll need a few plugins.

```bash
vagrant pligin install vagrant-serverspec
vagrant pligin install vagrant-hosts
vagrant pligin install vagrant-hostsupdater
vagrant pligin install vagrant-cucumber-host
```

Next, lets download the required development dependencies and puppet modules

```bash
bundle install
bundle exec librarian-puppet install
```

Have a look in the `Gemfile` and `Puppetfile` for a pull list of what is
being downloaded. If you don't have the bundle command available see the
[Bunder](http://bundler.io) site for installation instructions.

And finally, lets boot the virtual machines.

```bash
vagrant up
```
