require 'bundler/capistrano'
set :application, "LohasWork.com"
set :scm, :git
set :repository,  "git@github.com:lohaswork/LohasWork.com"
set :branch, "serco/deployment"
#set :current_path, ""

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :user, "lohaswork"
set :deploy_to, "/home/lohaswork/apps/LohasWork.com"
set :deploy_via, :remote_cache
set :use_sudo, false

set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"

set :rbenv_version, ENV['RBENV_VERSION'] || "1.9.3-p448"
set :default_environment, {
  'PATH' => "/home/#{user}/.rbenv/shims:/home/#{user}/.rbenv/bin:$PATH",
  'RBENV_VERSION' => "#{rbenv_version}",
}

role :web, "192.168.1.114"                          # Your HTTP server, Apache/etc
role :app, "192.168.1.114"                          # This may be the same as your `Web` server
role :db,  "192.168.1.114", :primary => true        # This is where Rails migrations will run


# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

before "deploy:assets:precompile" do
  run ["ln -nfs #{shared_path}/config/database.yml #{current_path}/config/database.yml"]
end

namespace :deploy do
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

end
