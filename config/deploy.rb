# Please install the Engine Yard Capistrano gem
# gem install eycap --source http://gems.engineyard.com

require "eycap/recipes"

# =============================================================================
# ENGINE YARD REQUIRED VARIABLES
# =============================================================================
# You must always specify the application and repository for every recipe. The
# repository must be the URL of the repository you want this recipe to
# correspond to. The :deploy_to variable must be the root of the application.

set :keep_releases,       5
set :application,         "dailycaption"
set :repository,          "github-dailycaption:joevandyk/daily-caption.git"
set :user,                "tanga"
set :password,            "k31bv4j3"
set :deploy_to,           "/data/#{application}"
# This will execute the Git revision parsing on the *remote* server rather than locally
set :real_revision,       lambda { source.query_revision(revision) { |cmd| capture(cmd) } }

set :monit_group,         "dailycaption"
set :scm,                 :git
set :runner,              "tanga"

# Database configuration for production
set :production_database, "psql82-2-master"
set :production_dbhost,   ""


set :dbuser, "tanga_db"
set :dbpass, "lb31v12j"

# comment out if it gives you trouble. newest net/ssh needs this set.
ssh_options[:paranoid] = false

# =============================================================================
# ROLES
# =============================================================================
# You can define any number of roles, each of which contains any number of
# machines. Roles might include such things as :web, or :app, or :db, defining
# what the purpose of each machine is. You can also specify options that can
# be used to single out a specific subset of boxes in a particular role, like
# :primary => true.

task :production do
  role :web, "74.201.254.36:8234" # tanga [thin] [psql82-2-master] and dailycaption [thin] [psql82-2-master]
  role :app, "74.201.254.36:8234", :thin => true
  role :db,  "74.201.254.36:8234", :primary => true
  set :rails_env, "production"
  set :environment_database, defer { production_database }
  set :environment_dbhost, defer { production_dbhost }
end

# =============================================================================
# after "deploy:symlink_configs", "dailycaption_custom"
# task :dailycaption_custom, :roles => :app, :except => {:no_release => true, :no_symlink => true} do
#   run <<-CMD
#   CMD
# end
# =============================================================================

# Do not change below unless you know what you are doing!

after "deploy",             "deploy:cleanup"
after "deploy:migrations",  "deploy:cleanup"
after "deploy:update_code", "deploy:symlink_configs"

after "deploy:symlink_configs", "symlink_dc_configs"
task "symlink_dc_configs", :roles => :app, :except => { :no_release => true, :no_symlink => true } do
  run <<-CMD
    ln -nfs #{shared_path}/config/facebooker.yml #{release_path}/config
  CMD
  run <<-CMD
    ln -nfs #{shared_path}/config/memcached.yml #{release_path}/config
  CMD
end

# uncomment the following to have a database backup done before every migration
# before "deploy:migrate", "db:dump"

