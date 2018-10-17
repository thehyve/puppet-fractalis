# Puppet module for Fractalis

[![Build Status](https://travis-ci.org/thehyve/puppet-fractalis.svg?branch=master)](https://travis-ci.org/thehyve/puppet-fractalis/branches)

This is the repository containing a puppet module for deploying the _[Fractalis]_ backend application.
Fractalis is a scalable open-source service for platform-independent interactive visual analytics,
developed by Sascha Herzinger of the University of Luxembourg.

The module creates the system user `fractalis`, downloads and installs
Redis, RabbitMQ, Python, R and Fractalis, and serves the application
on the configured address.


## Dependencies and installation

### Install Puppet
```bash
# Install Puppet
apt install puppet

# Check Puppet version, Puppet 4.8 and Puppet 5 should be fine.
puppet --version
```

### Puppet modules
The module depends on the `stdlib`, `archive`, `rabbitmq`, `python`, and `r` modules.
For installing on Ubuntu, also the `apt` module is required.

The most convenient way is to run `puppet module install` as `root`:
```bash
sudo puppet module install puppetlabs-stdlib
sudo puppet module install puppet-archive -v 1.2.0
sudo puppet module install puppet-rabbitmq -v 8.2.2
sudo puppet module install puppet-python -v 2.1.1
sudo puppet module install forward3ddev-r -v 0.0.2
```

Check the installed modules:
```bash
sudo puppet module list --tree
```

### Install the `fractalis` module
Copy the `fractalis` module repository to the `/etc/puppetlabs/code/modules` directory:
```bash
cd /etc/puppetlabs/code/modules
git clone https://github.com/thehyve/puppet-fractalis.git fractalis
```

## Configuration

### The node manifest

For each node where you want to install Fractalis, the module needs to be included with
`include ::fractalis::complete`.

Here is an example manifest file `manifests/test.example.com.pp`:
```puppet
node 'test.example.com' {
    include ::fractalis::complete
}
```
The node manifest can also be in another file, e.g., `site.pp`.

### Configuring a node using Hiera

It is preferred to configure the module parameters using Hiera.

To activate the use of Hiera, configure `/etc/puppetlabs/code/hiera.yaml`. Example:
```yaml
:backends:
  - yaml
:yaml:
  :datadir: '/etc/puppetlabs/code/hieradata'
:hierarchy:
  - '%{::clientcert}'
  - 'default'
```
Defaults can then be configured in `/etc/puppetlabs/code/hieradata/default.yaml`, e.g.:
```yaml
---
fractalis::version: 0.0.1-SNAPSHOT
```

Machine specific configuration should be in `/etc/puppetlabs/code/hieradata/${hostname}.yaml`, e.g.,
`/etc/puppetlabs/code/hieradata/test.example.com.yaml`:
```yaml
fractalis::hostname: fractalis.example.com
```

### Configuring a node in the manifest file

Alternatively, the node specific configuration can also be done with class parameters in the node manifest.
Here is an example:
```puppet
node 'test.example.com' {
    # Site specific configuration for Fractalis
    class { '::fractalis::params':
        hostname      => 'fractalis.example.com',
    }

    include ::fractalis::complete
}
```

### Configuring the use of a proxy
```puppet
node 'test.example.com' {
    ...

    # Configure a proxy for fetching artefacts
    Archive::Nexus {
        proxy_server => 'http://proxyurl:80',
    }
    # Configure a proxy for fetching packages with yum
    Yumrepo {
        proxy => 'http://proxyurl:80',
    }
}
```


## Masterless installation
It is also possible to use the module without a Puppet master by applying a manifest directly using `puppet apply`.

There is an example manifest in `examples/complete.pp`.

```bash
cd /etc/puppetlabes/code/modules/fractalis
sudo puppet apply examples/complete.pp
```


## Development

### Test
There are some automated tests, run using [rake].

`ruby >= 2.3` is required. [rvm] can be used to install a specific version of `ruby`.
Use `rvm install 2.4` to use `ruby` version `2.4`.


#### Rake tests
Install rake using the system-wide `ruby`:
```bash
yum install ruby-devel
gem install bundler
export PUPPET_VERSION=4.8.2
bundle
```
or using `rvm`:
```bash
rvm install 2.4
gem install bundler
export PUPPET_VERSION=4.8.2
bundle
```
Run the test suite:
```bash
rake test
```

### Classes

Overview of the classes defined in this module.

| Class name | Description |
|------------|-------------|
| `::fractalis` | Creates the system user, installs `redis`, `rabbitmq`, `python` and `r`. |
| `::fractalis::package` | Downloads `fractalis`. |
| `::fractalis::config` | Generates the application configuration. |
| `::fractalis::worker`  | Creates a `fractalis` worker. |
| `::fractalis::app` | Creates the `fractalis` app. |
| `::fractalis::complete` | Installs all of the above. |

### Module parameters

Overview of the parameters that can be used in Hiera to configure the module.
Alternatively, the parameters of the `::fractalis::params` class can be used to configure these settings.

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `fractalis::version`       | `0.0.1-SNAPSHOT` | The version of Fractalis to install. |
| `fractalis::user`          | `fractalis` | System user that owns the application assets. |
| `fractalis::user_home`     | `/home/${user}` | The user home directory |

Note that the modules only serves the application over plain HTTP, by configuring a simple Apache virtual host.
For enabling HTTPS, a separate Apache instance needs to be setup as a proxy.
Typically, the application should be installed in a small virtual machine where this module is applied,
with an SSL proxy installed on the host machine.


## License

Copyright &copy; 2018 &nbsp; The Hyve and respective contributors.

Licensed under the [Apache License, Version 2.0](LICENSE) (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at https://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


[Fractalis]: https://fractalis.lcsb.uni.lu
[rake]: https://github.com/ruby/rake
[rvm]: https://rvm.io/
