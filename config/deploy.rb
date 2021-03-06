require 'bundler/capistrano'
require 'sidekiq/capistrano'
$:.unshift('./config')
require 'capistrano-db-rollback'
require 'capistrano_database_yml'
require 'capistrano/ext/multistage'

# Five steps to run the first deployment
# 0. Create unicorn related files at local development ENV
# 1. Create deploy_user in linux and install packages
# 2. Manually create deploy_user in postgres and create www/#{appname} directory
# 3. Modify server info in deploy.rb & nginx.conf & capistrano_database_yml.rb
# 4. Run deploy:setup and config database following the leading message
# 5. !Important: Run cap deploy:cold for the very first deployment
# 6. Upload the video manually

# Need change before deployment
set :stages, %w(production staging)
set :default_stage, "staging"

set :user, "deployer"
set :sudo_user, "deployer"
set :deploy_to, "/www/teamail_deploy"

# Repository
set :application, "LohasWork.com"
set :scm, :git
set :repository,  "git@github.com:lohaswork/teamail.biz.git"

# Configurations
set :deploy_via, :remote_cache
set :copy_exclude, [ '.git' ]
set :use_sudo, false
set :normalize_asset_timestamps, false
default_run_options[:pty] = true
set :rbenv_version, ENV['RBENV_VERSION'] || "2.0.0-p247"
set :default_environment, {
  'PATH' => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH",
  'RBENV_VERSION' => "#{rbenv_version}",
}


# For sidekiq
set(:sidekiq_cmd) { "bundle exec sidekiq -e #{rails_env}" }
set(:sidekiqctl_cmd) { "bundle exec sidekiqctl" }
set(:sidekiq_timeout) { 10 }
set(:sidekiq_role) { :app }
set(:sidekiq_pid) { "#{current_path}/tmp/pids/sidekiq.pid" }
set(:sidekiq_processes) { 1 }

# For Unicorn service
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

# Fetch AARRR data
namespace :aarrr do
  desc "Get AARRR data"
  task :fetch do
    run "ruby ~/mysql-script/aarrr.rb"
  end
end

namespace :deploy do

  # redis
  namespace :redis do
    desc "Start the Redis server"
    task :start do
      run "#{sudo} /etc/init.d/redis-server start"
    end

    desc "Stop the Redis server"
    task :stop do
      run '#{sudo} /etc/init.d/redis-server stop'
    end

  end

  task :cold do       # Overriding the default deploy:cold
    update
    setup_db       # My own step, replacing migrations.
    start
  end

  task :add_shared do
    run "mkdir -p #{shared_path}/public"
    run "chmod g+rx,u+rwx #{shared_path}/public"
    run "mkdir -p #{shared_path}/public/videos"
    run "chmod g+rx,u+rwx #{shared_path}/public/videos"
    run "mkdir -p #{shared_path}/tmp"
    run "chmod g+rx,u+rwx #{shared_path}/tmp"
    run "mkdir -p #{shared_path}/unicorn"
    run "chmod g+rx,u+rwx #{shared_path}/unicorn"
    run "cd #{shared_path}"
    run "touch err.log out.log"
    run "mkdir -p #{shared_path}/sockets"
    run "chmod g+rx,u+rwx #{shared_path}/sockets"
    run "mkdir -p #{shared_path}/tmp/sessions"
    run "chmod g+rx,u+rwx #{shared_path}/tmp/sessions"
    run "mkdir -p #{shared_path}/tmp/cache"
    run "chmod g+rx,u+rwx #{shared_path}/tmp/cache"
  end

  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec unicorn_rails -c #{unicorn_config} -D"
  end

  task :stop, :roles => :app, :except => { :no_release => true } do
    run "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
  end

  task :restart, :roles => :app, :except => { :no_release => true } do
    # 用USR2信号来实现无缝部署重启
    run "if [ -f #{unicorn_pid} ]; then kill -s USR2 `cat #{unicorn_pid}`; fi"
  end

  desc 'clean old files, link shared files'
  task :housekeeping, :roles => :app do
    run "rm -rf #{current_path}/public/videos"  ###
    run "ln -s #{shared_path}/public/videos #{current_path}/public/videos"
    # Uncomment this when nginx configuration changes
    # run "#{sudo} ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/nginx.conf"
    run "rm -rf #{current_path}/unicorn"
    run "ln -s #{shared_path}/unicorn/ #{current_path}/unicorn"
    run "rm -rf #{current_path}/tmp/sockets"
    run "ln -s #{shared_path}/sockets #{current_path}/tmp/sockets"
    run "rm -rf #{current_path}/tmp/sessions"
    run "ln -s #{shared_path}/tmp/sessions #{current_path}/tmp/sessions"
    run "rm -rf #{current_path}/tmp/cache"
    run "ln -s #{shared_path}/tmp/cache #{current_path}/tmp/cache"

  end

  # utilize that capistrano has already done this!
  #
  # If you put your shared file or folder here:
  #   /path/to/app/shared/sockets
  # Then it will be symlinked here:
  #   /path/to/app/releases/20120517191233/tmp/sockets
  #
  shared_children.push "tmp/sockets"
  shared_children.push "unicorn"

  task :nginx_restart, :roles => :app do
    run "#{sudo} service nginx restart"
  end

  task :setup_db, :roles => :app do
    raise RuntimeError.new('db:setup aborted!') unless Capistrano::CLI.ui.ask("About to `rake db:setup`. Are you sure to wipe the entire database (anything other than 'yes' aborts):") == 'yes'
    run "cd #{current_path}; bundle exec rake db:schema:load RAILS_ENV=#{rails_env}"
  end

end

after 'deploy:setup', 'deploy:add_shared'
after "deploy:update_code", "deploy:migrate"
after 'deploy:create_symlink', 'deploy:housekeeping'
after 'deploy:restart', 'deploy:cleanup'
