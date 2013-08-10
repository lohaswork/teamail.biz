require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, '192.168.0.104'  # NEED CHANGE
set :deploy_to, '/www/lohaswork_deploy'
set :repository, 'git@github.com:lohaswork/LohasWork.com.git'
set :branch, 'serco/mina'  # NEED CHANGE
set :rails_env, 'production'
set :user, 'deployer' # NEED CHANGE
set :home_dir, '/home/#{user}'
# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log','tmp','config/unicorn.rb','config/nginx.conf']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .rbenv-version to your repository.
  invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p327@lohaswork.com]'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.

esc "Install dependencies in server."
task :pkg_install do
  # Install packages
  queue 'sudo apt-get update'
  queue 'sudo apt-get install -y build-essential openssl curl libcurl3-dev libreadline6 libreadline6-dev git zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf automake libtool imagemagick libmagickwand-dev libpcre3-dev libsqlite3-dev libmysql-ruby libmysqlclient-dev'
  queue 'sudo apt-get git'
  queue 'git config --global user.name "lohaswork"'
  queue 'git config --global user.email "support@lohaswork.com'
  queue 'sudo mkdir /www/LohasWork.com'
  queue 'sudo chown -R deployer /www/LohasWork.com'
  in_directory '#{home_dir}' do
    queue 'ssh-keygen -t rsa -C "support@lohaswork.com"'
    queue 'git clone git://github.com/sstephenson/rbenv.git ~/.rbenv'
    queue 'git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build'
    queue 'git clone git://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash'
    queue %[echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile]
    queue %[echo 'eval "$(rbenv init -)"' >> ~/.profile]
    queue 'exec $SHELL'
  end
  queue 'rbenv install 1.9.3-p327'
  queue 'rbenv global 1.9.3-p327'
  queue 'gem source -r https://rubygems.org/'
  queue 'gem source -a http://ruby.taobao.org'
  queue 'gem install bundler'
  queue 'sudo apt-add-repository ppa:chris-lea/node.js'
  queue 'sudo apt-get update'
  queue 'sudo apt-get install nodejs'
  queue 'sudo apt-get install postgresql-9.1'
  queue 'sudo apt-get install postgresql-client-9.1 postgresql-contrib-9.1 postgresql-server-dev-9.1'
  queue 'service postgresql start'
  queue 'sudo apt-get install python-software-properties'
  queue 'sudo add-apt-repository ppa:nginx/stable'
  queue 'sudo apt-get update'
  queue 'sudo apt-get install nginx'
  queue 'sudo service nginx start'
  in_directory '/etc/nginx/sites-enabled/' do
    sudo rm default
  end
end

task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/shared/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/log"]

  queue! %[mkdir -p "#{deploy_to}/shared/tmp"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/tmp"]

  queue! %[mkdir -p "#{deploy_to}/shared/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/shared/config"]

  queue! %[touch "#{deploy_to}/shared/config/database.yml"]
  queue  %[echo "-----> Be sure to edit 'shared/config/database.yml'."]
end

desc "Deploys the very first version to the server."
task :deploy_cold => :environment do
  deploy_cold do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :create_db
    invoke :'rails:assets_precompile'
    queue 'sudo ln -s #{current_path}/config/nginx.conf'

    to :launch do
      invoke :restart
    end
  end
end

task :create_db do
  queue 'bundle exec rake:db:create'
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :restart
    end
  end
end

task :start => :environment do
  queue "cd #{current_path} && RAILS_ENV=production bundle exec unicorn_rails -c #{unicorn_config} -D"
end

task :stop => :environment do
  queue "if [ -f #{unicorn_pid} ]; then kill -QUIT `cat #{unicorn_pid}`; fi"
end

task :restart => :environment do
  # 用USR2信号来实现无缝部署重启
  queue "if [ -f #{unicorn_pid} ]; then kill -s USR2 `cat #{unicorn_pid}`; fi"
end
# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

