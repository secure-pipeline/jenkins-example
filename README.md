
This repository contains a sample [Jenkins](http://jenkins-ci.org/) continuous
integration setup focused on security testing.

As well as installing Jenkins this projects creates a number of jobs
which:

* Download [RailsGoat](https://github.com/OWASP/railsgoat) and run it's
  unit tests
* Scan for known viruses using [ClamAV](http://www.clamav.net/lang/en/)
* Check for insecure dependencies with [bundler
  audit](https://github.com/rubysec/bundler-audit)
* Run a static anaylsis using the
  [Brakeman](http://brakemanscanner.org/) security scanner
* Spider and report issues found via [OWASP
  ZAP](https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project)

We use the RailsGoat application as an example, for your own work you
could swap this out for your own applications.

## Getting started

First install [Vagrant](http://vagrantup.com), which we're using the
manage the virtual machines on which we're installing the tools.

Once you have Vagrant installed you'll need a few plugins.

```bash
vagrant plugin install vagrant-serverspec
vagrant plugin install vagrant-hosts
vagrant plugin install vagrant-cucumber-host
```

You'll need a basic Ruby environment for the following steps.
First install [Bundler](http://bundler.io/) which manages Ruby
dependencies. Then install the Ruby and Puppet dependencies.

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

### DigitalOcean provider

By default this will use Virtualbox, but if you'd rather run a remote
virtual machine it also contains a [DigitalOcean](http://digitalocean.com)
configuration.

```bash
vagrant up --provider=digital_ocean
```

This relies on environment variables `DIGITAL_OCEAN_CLIENT_ID` and
`DIGITAL_OCEAN_CLIENT_API_KEY`.


## Build an image

As well as being able to launch local and remote instances, the
repository also contains a Packer template for building an image in
DigitalOcean. This could be adopted for other providers easily enough.
With Packer install run the following:

```bash
packer build template.json
```

This requires the environment variables `DIGITALOCEAN_API_KEY` and
`DIGITALOCEAN_CLIENT_ID` to be set.


## Colophon

This uses a fair few open sources tools. Thanks in particular to:

* [Puppet](http://puppetlabs.com/puppet/puppet-open-source)
* [Vagrant](http://vagrantup.com)
* [Packer](http://packer.io)
* [ServerSpec](http://serverspec.org/)
* [Jenkins Job Builder](http://ci.openstack.org/jenkins-job-builder/)

