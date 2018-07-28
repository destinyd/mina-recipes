# nginx

namespace :nginx do
  %w(stop start restart reload status).each do |action|
    desc "#{action.capitalize} NGINX"
    task action.to_sym => :environment do
      # Log the command to the terminal output.
      command  %(echo "-----> #{action.capitalize} NGINX")
      # Run the command.
      command "sudo systemctl #{action} nginx"
    end
  end
end

# Install nginx server.
namespace :provision do
  desc "Install NGINX"
  task :nginx do
    command "sudo yum install nginx"
    command "sudo systemctl enable nginx"

    # Create nginx server file.
    nginx_puma = erb("#{fetch(:template_path)}/nginx_puma.erb")

    command %[echo '#{nginx_puma}' > /home/#{fetch(:user)}/nginx_conf]
    command %[sudo mkdir /etc/nginx/sites-enabled]
    command %[sudo mv /home/#{fetch(:user)}/nginx_conf /etc/nginx/sites-enabled/#{fetch(:app_name)}]

    # 添加防火墙规则
    command "sudo firewall-cmd --zone=public --add-service=http --permanent"
    command "sudo firewall-cmd --zone=public --add-service=http"
    command "sudo firewall-cmd --reload"

    # TODO 
    # 因为centos nginx没有加载site-enabled/*，
    # 运行之前还要修改，/etc/nginx/nginx.conf，具体参看对应文字介绍

    # 启动nginx服务
    command "sudo systemctl start nginx"
  end
end
