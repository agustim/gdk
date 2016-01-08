# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version '>= 1.5'

def require_plugins(plugins = {})
  needs_restart = false
  plugins.each do |plugin, version|
    next if Vagrant.has_plugin?(plugin)
    cmd =
      [
        'vagrant plugin install',
        plugin
      ]
    cmd << "--plugin-version #{version}" if version
    system(cmd.join(' ')) || exit!
    needs_restart = true
  end
  exit system('vagrant', *ARGV) if needs_restart
end

require_plugins \
  'vagrant-bindfs' => '0.3.2',
  'vagrant-vbguest' => '0.11.0'

Vagrant.configure('2') do |config|
  config.vm.provider :virtualbox do |vb, override|
    host = RbConfig::CONFIG["host_os"]

    if host =~ /darwin/ # OS X
      # sysctl returns bytes, convert to MB
      vb.memory = `sysctl -n hw.memsize`.to_i / 1024 / 1024 / 3
      vb.cpus = `sysctl -n hw.ncpu`.to_i
    elsif host =~ /linux/ # Linux
      # meminfo returns kilobytes, convert to MB
      vb.memory = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i / 1024 / 2
      vb.cpus = `nproc`.to_i
    end

    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.define 'guifidev' do |machine|
    machine.vm.hostname = 'localhost'
    machine.vm.network 'forwarded_port', :guest => 80, :host => 8280, :auto_correct => true

    machine.vm.box = 'debian/jessie64'

    machine.vm.network 'private_network', ip: '192.168.20.50'
    machine.vm.synced_folder '../guifi', '/var/www/html/drupal-6.37/sites/all/modules/guifi'
    machine.vm.synced_folder '../budgets', '/var/www/html/drupal-6.37/sites/all/modules/budgets'
    machine.vm.synced_folder '../theme_guifinet2011', '/var/www/html/drupal-6.37/sites/all/themes/theme_guifinet2011'

  end


  config.ssh.forward_agent = true

  config.vm.provision :shell, path: "bootstrap.sh"

end
