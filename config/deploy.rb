require 'bundler/capistrano'
require 'capistrano-db-rollback'
require './capistrano_database_yml'
require './capistrano_package_installation'

# Five steps to run the first deployment
# 0. Create unicorn related files at local development ENV
# 1. Create deploy_user in linux and install packages
# 2. Manually create deploy_user in postgres and create www/#{appname} directory
# 3. Modify server info in deploy.rb & nginx.conf
# 4. Run deploy:setup and config database following the leading message
# 5. !Important: Run deploy:cold for the very first deployment

# Need change before deployment
set :server_name, "192.168.1.114"
set :user, "deployer"
set :sudo_user, "deployer"
set :deploy_to, "/www/teamind_deploy"

# Repository
set :application, "LohasWork.com"
set :scm, :git
set :repository,  "git@github.com:lohaswork/LohasWork.com"
set :branch, "serco/deployment"  # Need changge to master

# Configurations
set :rails_env, "production"
set :deploy_via, :remote_cache
set :use_sudo, false
set :normalize_asset_timestamps, false
default_run_options[:pty] = true
set :rbenv_version, ENV['RBENV_VERSION'] || "1.9.3-p327"
set :default_environment, {
  'PATH' => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH",
  'RBENV_VERSION' => "#{rbenv_version}",
}

#roles
role :web, "192.168.1.114"                          # Your HTTP server, Apache/etc
role :app, "192.168.1.114"                          # This may be the same as your `Web` server
role :db,  "192.168.1.114", :primary => true        # This is where Rails migrations will run

namespace :deploy do

  task :cold do       # Overriding the default deploy:cold
    update
    setup_db       # My own step, replacing migrations.
    start
  end

  task :add_tmp do
    run "mkdir -p #{shared_path}/tmp"
    run "chmod g+rx,u+rwx #{shared_path}/tmp"
  end

  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && RAILS_ENV=production bundle exec unicorn_rails -c #{unicorn_config} -D"
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
    run "rm -rf #{current_path}/public/videos"
    run "ln -s #{shared_path}/public/videos #{current_path}/public/videos"
    run "#{sudo} ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/nginx.conf"
    run "ln -nfs #{current_path}/config/unicorn.rb #{shared_path}/config/unicorn.rb"
  end

  desc "Create socket file symlink for nginx"
  task :symlink_unicorn, :roles => :app, :except => {:no_release => true} do
    run "mkdir -p #{shared_path}/unicorn"
    run "chmod g+rx,u+rwx #{shared_path}/unicorn"
    run "cd #{shared_path}"
    run "touch err.log out.log"
    run "ln -s #{shared_path}/unicorn/ #{current_path}/unicorn"
    run "mkdir -p #{shared_path}/sockets"
    run "chmod g+rx,u+rwx #{shared_path}/sockets"
    run "ln -s #{shared_path}/sockets #{current_path}/tmp/sockets"
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

  # Manually execute this step
  # desc 'reload nginx when nginx.conf changes'
  # task :nginx_config, :roles => :app do
  #   run "#{sudo} ln -s #{shared_path}/config/nginx.conf /etc/nginx/sites-enabled/nginx.conf", :pty => true
  # end

  task :setup_db, :roles => :app do
    raise RuntimeError.new('db:setup aborted!') unless Capistrano::CLI.ui.ask("About to `rake db:setup`. Are you sure to wipe the entire database (anything other than 'yes' aborts):") == 'yes'
    run "cd #{current_path}; bundle exec rake db:setup RAILS_ENV=#{rails_env}"
  end

  task :start_sql, :roles => :db do
    run "#{sudo} service postgresql start"
  end
end

before 'deploy:setup_db', 'deploy:start_sql'
after 'deploy:setup', 'deploy:add_tmp'
after 'deploy:create_symlink', 'deploy:housekeeping', 'deploy:symlink_unicorn'
after 'deploy:restart', 'deploy:cleanup'
