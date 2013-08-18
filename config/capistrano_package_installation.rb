unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end

Capistrano::Configuration.instance.load do
  namespace :install do
    task :pkg_install do
      run '#{sudo} apt-get update'
      run '#{sudo} apt-get install -y build-essential openssl curl libcurl3-dev libreadline6 libreadline6-dev git zlib1g zlib1g-dev libssl-dev libyaml-dev libxml2-dev libxslt-dev autoconf automake libtool imagemagick libmagickwand-dev libpcre3-dev libsqlite3-dev libmysql-ruby libmysqlclient-dev'
      run '#{sudo} apt-get install git'
      run %[git config --global user.name "lohaswork"]
      run %[git config --global user.email "support@lohaswork.com"]
      run '#{sudo} mkdir /www'
      run '#{sudo} mkdir /www/teamind_deploy'
      run '#{sudo} chown -R deployer /www/teamind_deploy'
      run 'cd home/deployer'
      run %[ssh-keygen -t rsa -C "support@lohaswork.com"]
      run 'git clone git://github.com/sstephenson/rbenv.git ~/.rbenv'
      run 'git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build'
      run 'git clone git://github.com/sstephenson/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash'
      run %[echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.profile]
      run %[echo 'eval "$(rbenv init -)"' >> ~/.profile]
      run 'exec $SHELL'
      run 'rbenv install 1.9.3-p327'
      run 'rbenv global 1.9.3-p327'
      run 'gem source -r https://rubygems.org/'
      run 'gem source -a http://ruby.taobao.org'
      run 'gem install bundler'
      run '#{sudo} apt-add-repository ppa:chris-lea/node.js'
      run '#{sudo} apt-get update'
      run '#{sudo} apt-get install nodejs'
      run '#{sudo} apt-get install postgresql-9.1'
      run '#{sudo} apt-get install postgresql-client-9.1 postgresql-contrib-9.1 postgresql-server-dev-9.1'
      run '#{sudo} service postgresql start'
      run '#{sudo} apt-get install python-software-properties'
      run '#{sudo} add-apt-repository ppa:nginx/stable'
      run '#{sudo} apt-get update'
      run '#{sudo} apt-get install nginx'
      run '#{sudo} service nginx start'
      run 'cd /etc/nginx/sites-enabled/'
      run '#{sudo} rm default'
    end
  end
end
