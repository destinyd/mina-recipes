require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina/puma'
require 'mina/scp'

### Needed to ask for postgresql password
require 'highline/import'

###
### TASKS
################################################################################

require_relative 'deploy/essentials'
require_relative 'deploy/setup'
require_relative 'deploy/imagemagick'
require_relative 'deploy/postgresql'
require_relative 'deploy/nodejs'
require_relative 'deploy/redis'
require_relative 'deploy/rbenv'
require_relative 'deploy/puma'
require_relative 'deploy/nginx'
require_relative 'deploy/secrets'
require_relative 'deploy/sidekiq'

###
### SERVER
################################################################################

set :domain,                '104.236.8.190'                       # Server ip or domain
set :user,                  'deployer'                            # Server user
set :forward_agent,          true                                 # SSH key

set :app_name,              'tickets'                             # App name

set :app_root,              '/Users/codyeatworld/rails/tickets'   # Local path to application
set :template_path,         "#{app_root}/config/deploy/templates" # Local path to deploy templates

set :deploy_to,             "/home/#{user}/#{app_name}"           # Where to deploy

set :repository,            'git://github.com/ctrl-alt/tickets'   # What to deploy
set :branch,                'master'                              # Which branch to deploy

set :shared_paths,          ['config/database.yml',               # Database config
                             'config/application.yml',            # Figaro variables
                             'config/secrets.yml',                # Rails secrets
                             'public/uploads',                    # Image uploads
                             'log',                               # Log files
                             'tmp'
                            ]

### Load rbenv into the session
task :environment do
  invoke :'rbenv:load'
end

###
### MINA DEPLOY
################################################################################

desc "Deploys the current version to the server."
task deploy: :environment do
  to :before_hook do
    # Put things to run locally before ssh
  end

  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'
    invoke :'secrets:upload'

    to :launch do
      invoke :'puma:restart'
      invoke :'sidekiq:start'
    end
  end
end