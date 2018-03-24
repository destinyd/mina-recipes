# Mina
require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina/puma'
require 'mina/scp'

# Highline for `ask`
require 'highline/import'

# Tasks
require_relative 'deploy/essentials'
require_relative 'deploy/setup'
require_relative 'deploy/imagemagick'
require_relative 'deploy/postgresql'
require_relative 'deploy/nodejs'
require_relative 'deploy/rbenv'
require_relative 'deploy/puma'
require_relative 'deploy/nginx'
require_relative 'deploy/secrets'

# SSH
set :user, 'deployer'
set :domain, '0.0.0.0'
# AWS
set :identity_file, 'app.pem'
# VPS
# set :forward_agent, true

# App
set :app_name, 'app'
set :template_path, File.join('config', 'deploy', 'templates')

# Deploy
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:app_name)}"
set :shared_dirs, fetch(:shared_dirs, []).push('log', 'tmp')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/application.yml', 'config/secrets.yml')

# Repository
set :repository, 'git://github.com/username/repo'
set :branch, 'master'

# Enviroment
desc 'Load the enviroment.'
task :environment do
  invoke :'rbenv:load'
end

# mina deploy
desc 'Deploys the current version to the server.'
task :deploy do
  # Deployment tasks
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    # After deploy
    on :launch do
      invoke :'puma:restart'
      invoke :'nginx:restart'
    end
  end
end
