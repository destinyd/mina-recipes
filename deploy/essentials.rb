###
### ESSENTIALS
################################################################################

namespace :provision do
  desc "Install the essentials"
  task :essentials do
    queue "sudo apt-get update -y"
    queue "sudo apt-get install -y git-core curl wget zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev software-properties-common"
    queue "sudo apt-get clean -y"
  end
end