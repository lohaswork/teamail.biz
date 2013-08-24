#
# = Capistrano database.yml task
#
# Provides a couple of tasks for creating the database.yml
# configuration file dynamically when deploy:setup is run.
#
# Category::    Capistrano
# Package::     Database
# Author::      Simone Carletti <weppos@weppos.net>
# Copyright::   2007-2010 The Authors
# License::     MIT License
# Link::        http://www.simonecarletti.com/
# Source::      http://gist.github.com/2769
#
#
# == Requirements
#
# This extension requires the original <tt>config/database.yml</tt> to be excluded
# from source code checkout. You can easily accomplish this by renaming
# the file (for example to database.example.yml) and appending <tt>database.yml</tt>
# value to your SCM ignore list.
#
#   # Example for Subversion
#
#   $ svn mv config/database.yml config/database.example.yml
#   $ svn propset svn:ignore 'database.yml' config
#
#   # Example for Git
#
#   $ git mv config/database.yml config/database.example.yml
#   $ echo 'config/database.yml' >> .gitignore
#
#
# == Usage
#
# Include this file in your <tt>deploy.rb</tt> configuration file.
# Assuming you saved this recipe as capistrano_database_yml.rb:
#
#   require "capistrano_database_yml"
#
# Now, when <tt>deploy:setup</tt> is called, this script will automatically
# create the <tt>database.yml</tt> file in the shared folder.
# Each time you run a deploy, this script will also create a symlink
# from your application <tt>config/database.yml</tt> pointing to the shared configuration file.
#
# === Password prompt
#
# For security reasons, in the example below the password is not
# hard coded (or stored in a variable) but asked on setup.
# I don't like to store passwords in files under version control
# because they will live forever in your history.
# This is why I use the Capistrano::CLI utility.
#

unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :deploy do

    namespace :db do

      desc <<-DESC
        Creates the database.yml configuration file in shared path.

        When this recipe is loaded, db:setup is automatically configured \
        to be invoked after deploy:setup. You can skip this task setting \
        the variable :skip_db_setup to true. This is especially useful \
        if you are using this recipe in combination with \
        capistrano-ext/multistaging to avoid multiple db:setup calls \
        when running deploy:setup for all stages one by one.
      DESC
      task :setup, :except => { :no_release => true } do

#        default_template = <<-EOF
#          base: &base
#            adapter: postgresql
#            username: #{Capistrano::CLI.ui.ask("Enter database username: ")}
#            password: #{Capistrano::CLI.password_prompt("Enter database password: ")}
#            pool: 5
#          development:
#            database: lahaswork_development
#            <<: *base
#          test:
#            database: lohaswork_test
#            <<: *base
#          production:
#            database: lohaswork_production
#            <<: *base
#        EOF

        default_template = <<-EOF
          base: &base
            adapter: mysql2
            encoding: utf8
            hostname: localhost
            username: #{Capistrano::CLI.ui.ask("Enter database username: ")}
            password: #{Capistrano::CLI.password_prompt("Enter database password: ")}
            pool: 5
          development:
            database: lahaswork_development
            <<: *base
          test:
            database: lohaswork_test
            <<: *base
          production:
            database: lohaswork_production
            <<: *base
        EOF

        location = fetch(:template_dir, "config/deploy") + '/database.yml.erb'
        template = File.file?(location) ? File.read(location) : default_template

        config = ERB.new(template)

        run "mkdir -p #{shared_path}/db"
        run "mkdir -p #{shared_path}/config"
        run "chmod g+rx,u+rwx #{shared_path}/config"
        put config.result(binding), "#{shared_path}/config/database.yml"
      end

      desc <<-DESC
        [internal] Updates the symlink for database.yml file to the just deployed release.
      DESC
      task :symlink, :except => { :no_release => true } do
        run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
      end

    end

    after "deploy:setup",           "deploy:db:setup"   unless fetch(:skip_db_setup, false)
    after "deploy:finalize_update", "deploy:db:symlink"

  end

end
