Mina-Recipes
============

**In progress of updating to Mina 1.2+**

Deploy to a vps with [mina](https://github.com/mina-deploy/mina), [rails](https://github.com/rails/rails), [puma](https://github.com/puma/puma), [nginx](https://github.com/nginx/nginx), [rbenv](https://github.com/sstephenson/rbenv), [redis](https://github.com/redis), [figaro](https://github.com/laserlemon/figaro) and [sidekiq](https://github.com/mperham/sidekiq)!

#### Available tasks

```bash
$ mina tasks
mina bundle:install                  # Install gem dependencies using Bundler
mina deploy:cleanup                  # Clean up old releases
mina deploy:force_unlock             # Forces a deploy unlock
mina deploy:link_shared_paths        # Links paths set in :shared_paths
mina deploy:rollback                 # Rollbacks the latest release
mina git:clone                       # Clones the Git repository to the release path
mina nginx:reload                    # Reload NGINX
mina nginx:restart                   # Restart NGINX
mina nginx:start                     # Start NGINX
mina nginx:status                    # Status NGINX
mina nginx:stop                      # Stop NGINX
mina provision:essentials            # Install the essentials
mina provision:imagemagick           # Install the imagemagick library
mina provision:nginx                 # Install NGINX
mina provision:nodejs                # Install nodejs for a javascript runtime
mina provision:postgresql            # Install postgresql
mina provision:rbenv                 # Install ruby 2.2.2 with rbenv
mina provision:redis                 # Install redis server
mina puma:config                     # Update puma config
mina puma:phased_restart             # Restart puma (phased restart)
mina puma:restart                    # Restart puma
mina puma:start                      # Start puma
mina puma:stop                       # Stop puma
mina rails:assets_precompile         # Precompiles assets (skips if nothing has changed since the last release)
mina rails:assets_precompile:force   # Precompiles assets
mina rails:db_migrate                # Migrates the Rails database (skips if nothing has changed since the last release)
mina rails:db_migrate:force          # Migrates the Rails database
mina rails:db_rollback               # Rollbacks the Rails database
mina rbenv:load                      # Load rbenv into the session
mina secrets:upload                  # Upload secret configuration files
mina sidekiq:quiet                   # Quiet sidekiq (stop accepting new work)
mina sidekiq:restart                 # Restart sidekiq
mina sidekiq:start                   # Start sidekiq
mina sidekiq:stop                    # Stop sidekiq
```

#### Install gems

Add gems to Gemfile.

```ruby
gem 'figaro'
gem 'mina'
gem 'sidekiq'
gem 'highline',  require: false
gem 'mina-puma', require: false
gem 'mina-scp',  require: false
```

#### Install Figaro 

[Learn more about Figaro at laserlemon/figaro](https://github.com/laserlemon/figaro)

Your `config/secrets.yml` should reference values with `ENV['secret_key_base']`.
Set ENV variables in Figaro's `config/application.yml`.

```bash
figaro install
```

#### Install recipes

Copy the recipes into your rails app config directory.

```bash
git clone https://github.com/codyeatworld/mina-recipes.git
cp -R mina-recipes/deploy* path/to/rails/config
```

#### Deployer

Setup deployer on a Ubuntu 14.04 server and update `deploy.rb` with your servers configuration.

```bash
ssh root@domain.com
adduser deployer
gpasswd -a deployer sudo
echo "deployer ALL=(ALL:ALL) ALL" >> /etc/sudoers
```

#### Install everything onto the server

Modify `deploy/templates` as needed.

```bash
mina setup
mina provision:essentials
mina provision:imagemagick
mina provision:nginx
mina provision:nodejs
mina provision:postgresql
mina provision:redis
mina provision:rbenv
mina puma:config
```

#### Deploy

Now run `mina deploy`.
