# rbenv
# TODO: Disble enviorment task preload

# Ruby version to install
set :ruby_version, '2.4.4'

namespace :provision do
  desc "Install ruby #{fetch(:ruby_version)} with rbenv"
  task :rbenv do
    command "sudo yum install -y git-core zlib zlib-devel gcc-c++ patch readline readline-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison curl sqlite-devel"
    command "git clone https://github.com/rbenv/rbenv.git ~/.rbenv"
    command "git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build"
    command "echo 'export PATH=\"$HOME/.rbenv/bin:$HOME/.rbenv/plugins/ruby-build/bin:$PATH\"' >> ~/.bash_profile"
    command "echo 'eval \"$(rbenv init -)\"' >> ~/.bash_profile"
    command "source ~/.bash_profile"

    # Load enviorment manually
    invoke :'rbenv:load'
    command "rbenv install #{fetch(:ruby_version)}"
    command "rbenv global #{fetch(:ruby_version)}"
    command "echo 'gem: --no-ri --no-rdoc' > ~/.gemrc"
    command "gem install bundler"
    command "rbenv rehash"

    # for bundle pg
    command "bundle config build.pg --with-pg=/usr/pgsql-9.6 --with-pg-config=/usr/pgsql-9.6/bin/pg_config"
  end
end
