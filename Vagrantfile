# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  vagrant_version = Vagrant::VERSION.sub(/^v/, '')

  config.vm.box = "ubuntu/trusty64"

  config.vm.network "private_network", ip: "192.168.50.2"
  if defined?(VagrantPlugins::HostsUpdater)
    config.vm.hostname = "wp-site.local"
    #config.hostsupdater.aliases = ["alias.testing.de", "alias2.somedomain.com"]

    # Recursively fetch the paths to all vvv-hosts files under the www/ directory.
    vagrant_dir = File.expand_path(File.dirname(__FILE__))
    paths = Dir[File.join(vagrant_dir, 'www', '**', 'vvv-hosts')]

    # Parse the found vvv-hosts files for host names.
    hosts = paths.map do |path|
      # Read line from file and remove line breaks
      lines = File.readlines(path).map(&:chomp)
      # Filter out comments starting with "#"
      lines.grep(/\A[^#]/)
    end.flatten.uniq # Remove duplicate entries

    # Pass the found host names to the hostsupdater plugin so it can perform magic.
    config.hostsupdater.aliases = hosts
    config.hostsupdater.remove_on_suspend = true
  end

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  config.vm.provision :shell, path: "vagrant-bootstrap.sh"

  # Always start MySQL on boot, even when not running the full provisioner
  # (run: "always" support added in 1.6.0)
  if vagrant_version >= "1.6.0"
    config.vm.provision :shell, inline: "sudo service mysql restart", run: "always"
    # config.vm.provision :shell, inline: "sudo service nginx restart", run: "always"
  end

end
