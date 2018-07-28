# Essentials
namespace :provision do
  desc "Install essential packages required for building ruby and git."
  task :essentials do
    command "sudo yum install epel-release"
    command "sudo yum install -y gcc-c++ glibc-headers openssl-devel readline libyaml-devel readline-devel zlib zlib-devel git"
  end
end
