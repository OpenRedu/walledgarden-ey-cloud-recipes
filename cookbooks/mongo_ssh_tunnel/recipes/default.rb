#
# Cookbook Name:: mongo_ssh_tunnel
# Recipe:: default
#

# if you want to have more than one tunnel set up on a given instance
# (which should be fairly rare) then copy the entire cookbook with a
# different top level name (don't change any filenames in it) and change
# this value to match before deploying.  Oh, and be sure to add a require_recipe
# line with the new cookbook name to the main cookbook's default.rb recipe file
tunnel_name = 'mongo_ssh_tunnel'

# fill in missing information below
tunnel_vars = {
  # the host hostname (an IP will work) to ssh to
  :ssh_hostname => "ec2-54-226-56-11.compute-1.amazonaws.com",
  # only change this if using a non-default ssh port on the destination host,
  # such as when connecting through a gateway
  :ssh_port => 22,
  # the system user account to use when logging into the destination host
  :ssh_user => 'deploy',
  # the path to the private key on the instance the tunnel is from
  :ssh_private_key => '/home/deploy/.ssh/id_rsa',
  # the path to the public key on the instance the tunnel is from
  :ssh_public_key => '/home/deploy/.ssh/id_rsa.pub',
  # the port that will be being forwarded
  :connect_port => '27017',
  # the host on the remote side (or local side for a reverse tunnel)
  # that the :connect_port will be forwarded to
  :forward_host => '127.0.0.1',
  # the port on :forward_host that :connect_port will be forwarded to
  :forward_port => '27017',
  # valid values: FWD, REV, DUAL. Determines what kind of tunnel(s) to create
  # DUAL means create both a forward and reverse tunnel
  :tunnel_direction => 'FWD',
  # the path to the ssh executable to use when making the ssh connection
  :ssh_cmd => '/usr/bin/ssh',
  # whether or not to use StrictHostKeyChecking when making the ssh connection
  :skip_hostkey_auth => false,
  # the path to the known hosts file with the public key of the remote server
  # only set if :skip_hostkey_auth is set to false
  # note that if :skip_hostkey_auth is set to true then you need to make a
  # manual connection to the remote host *before* deploying this recipe
  # and use the path to the known_hosts file that the remote host's public
  # key is written to here.  It's also even better to copy that key entry to
  # a file somewhere on an EBS volume and use that file's path here to ensure
  # that it won't be wiped after an instance restart (terminate and rebuild)
  :ssh_known_hosts => '',
  :tunnel_name => tunnel_name
}

# set this to match on the node[:instance_role] of the instance the tunnel
# should be set up on

if ['app_master', 'solo'].include?(node[:instance_role])

  template "/etc/init.d/#{tunnel_name}" do
    source "ssh_tunnel.initd.erb"
    owner 'root'
    group 'root'
    mode 0755
    variables(tunnel_vars)
  end

  template "/etc/monit.d/#{tunnel_name}.monitrc" do
    source "ssh_tunnel.monitrc.erb"
    owner node[:owner_name]
    group node[:owner_name]
    mode 0644
    variables(tunnel_vars)
  end

  execute "monit quit"

end
