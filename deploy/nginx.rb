###
### NGINX
################################################################################

namespace :nginx do
  %w(stop start restart reload status).each do |action|
    desc "#{action.capitalize} NGINX"
    task action.to_sym => :environment do
      queue  %(echo "-----> #{action.capitalize} NGINX")
      queue "sudo service nginx #{action}"
    end
  end
end

namespace :provision do
  desc "Install NGINX"
  task :nginx do
    queue "sudo add-apt-repository -y ppa:nginx/stable"
    queue "sudo apt-get update -y"
    queue "sudo apt-get install -y nginx"
    queue "sudo apt-get clean -y"

    nginx_puma = erb("#{template_path}/nginx_puma.erb")

    queue %[echo '#{nginx_puma}' > /home/#{user}/nginx_conf]
    queue %[sudo mv /home/#{user}/nginx_conf /etc/nginx/sites-enabled/#{app_name}]
    queue %[sudo rm -f /etc/nginx/sites-enabled/default]
  end
end
