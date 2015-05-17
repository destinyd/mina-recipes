###
### POSTGRESQL
################################################################################

set :pg_database,          "#{app_name}_production"
set :pg_user,              app_name
set :pg_host,              'localhost'

namespace :provision do
  desc "Install postgresql"
  task :postgresql do
    queue "wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -"
    queue "sudo sh -c 'echo \"deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main\" >> /etc/apt/sources.list.d/pgdg.list'"
    queue "sudo apt-get update -y"
    queue "sudo apt-get -y install libpq-dev postgresql-9.4"
    queue "sudo apt-get clean -y"

    set :pg_password, ask("Postgresql password: ") { |q| q.default = "password" }
    
    queue %Q{sudo -u postgres psql -c "create user #{app_name} with password '#{pg_password}';"}
    queue %Q{sudo -u postgres psql -c "alter role #{app_name} with superuser;"}
    queue %Q{sudo -u postgres psql -c "create database #{app_name}_production owner #{app_name};"}

    database_yml = erb("#{template_path}/postgresql.yml.erb")
    queue "echo '#{database_yml}' > #{deploy_to}/#{shared_path}/config/database.yml"
    queue "cat #{deploy_to}/#{shared_path}/config/database.yml"
  end
end