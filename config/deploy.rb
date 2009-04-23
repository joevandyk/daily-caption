set :application, "dailycaption"
set :repository,  "git@github.com:joevandyk/daily-caption.git"
set :scm, :git
set :ssh_options, { :forward_agent => true }
set :deploy_to, "/data/#{application}"
set :user, 'monkey'
set :deploy_via, :remote_cache

set :use_sudo, false
role :app, "ec2.fixieconsulting.com"
role :web, "ec2.fixieconsulting.com"
role :db,  "ec2.fixieconsulting.com", :primary => true

namespace :deploy do
  task :restart, :roles => :app do
    # invoke_command "cd #{release_path} && RAILS_ENV=production script/runner 'Publisher.register_all_templates'"
    invoke_command "touch #{release_path}/tmp/restart.txt"
  end

  task :after_update_code, :roles => [:app] do
    run "cp #{release_path}/config/live/facebooker.yml #{release_path}/config"
  end

  task :regenerate do
    invoke_command "cd #{current_path} && rake paperclip:refresh CLASS=#{ENV['CLASS']} RAILS_ENV=production "
  end
end


require 'vendor/plugins/cap_gun/lib/cap_gun' # typical Rails vendor/plugins location
set :cap_gun_action_mailer_config, {
    :address => "smtp.gmail.com",
    :port => 587,
    :user_name => "mailer@groupieguide.com",
    :password => "welcome",
    :authentication => :plain
}
set :cap_gun_email_envelope, { :recipients => %w[joe@fixieconsulting.com, jordan@fixieconsulting.com], :from => "Fixie Deployer <info@fixieconsulting.com>" }
after "deploy:restart", "cap_gun:email"
