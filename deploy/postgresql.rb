# Install postgresql database.
# TODO: Refactor variables and setup.

# Database host
set :pg_host, 'localhost'

namespace :provision do
  desc 'Install postgresql.'
  task :postgresql do
    # Ask is provided by highline and will prompt the terminal to enter in a password for the database.
    set :pg_password, ask('Postgresql password: ') { |q|
      q.default = 'password'
    }

    command "sudo yum install https://download.postgresql.org/pub/repos/yum/9.6/redhat/rhel-7-x86_64/pgdg-redhat96-9.6-3.noarch.rpm"
    command "sudo yum install postgresql96-server postgresql96-devel"
    command "sudo systemctl enable postgresql-9.6"
    command "sudo systemctl start postgresql-9.6"

    command "/usr/pgsql-9.6/bin/postgresql96-setup initdb"

    command %Q{sudo -u postgres psql -c "create user #{fetch(:app_name)} with password '#{fetch(:pg_password)}';"}
    command %Q{sudo -u postgres psql -c "alter role #{fetch(:app_name)} with superuser;"}
    command %Q{sudo -u postgres psql -c "create database #{fetch(:app_name)}_production owner #{fetch(:app_name)};"}

    database_yml = erb("#{fetch(:template_path)}/postgresql.yml.erb")
    command "echo '#{database_yml}' > #{fetch(:shared_path)}/config/database.yml"
  end
end
