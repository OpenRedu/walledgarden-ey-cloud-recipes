#
# Cookbook Name:: mongo_solo
# Recipe:: default
#

version = "2.2.0"
# file_to_fetch = "http://fastdl.mongodb.org/linux/mongodb-linux-i686-#{version}.tgz"

# execute "fetch #{file_to_fetch}" do
#   Chef::Log.info "Downloading MongoDB file"
#   cwd "/tmp"
#   command "wget #{file_to_fetch}"
#   not_if { FileTest.exists?("/tmp/mongodb-linux-i686-#{version}.tgz") }
# end
#
# execute "untar /tmp/mongodb-linux-i686-#{version}.tgz" do
#   Chef::Log.info "Copying mongodb file"
#   command "cd /tmp; tar zxf mongodb-linux-i686-#{version}.tgz -C /opt"
#   not_if { FileTest.directory?("/opt/mongodb-linux-i686-#{version}") }
# end
#
# execute "creating a symbolik link" do
#   Chef::Log.info "Creating a symbolic link to mongodump"
#   command "ln -s /opt/mongodb-linux-i686-#{version}/bin/mongodump /usr/bin/mongodump"
#   not_if { FileTest.exists?("/usr/bin/mongodump") }
# end
#
# execute "create MongoDB --dbpath" do
#   Chef::Log.info "Creating dir to hold mongodb data"
#   command "mkdir /data/db"
#   not_if { FileTest.directory?("/data/db") }
# end
#
# execute "start mongodb" do
#   Chef::Log.info "Starting Mongodb"
#   command "sudo /opt/mongodb-linux-i686-#{version}/bin/mongod --journal " + \
#   "--fork --dbpath /data/db --logpath /var/log/mongodb.log --logappend"
#   Chef::Log.info "Starting executed"
#   not_if { FileTest.exists?("/data/db/mongod.lock") }
# end

ey_cloud_report "MongoDB" do
  message "installing mongodb #{version}"
end

enable_package "dev-db/mongodb-bin" do
  version version
end

package "dev-db/mongodb-bin" do
  version version
  action :install
end

execute "start MongoDB" do
  Chef::Log.info "Starting MongoDB"
  command "sudo /etc/init.d/mongodb start"
  not_if { FileTest.exists?("/var/run/mongodb/mongodb.pid") }
end
