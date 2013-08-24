configuration = Capistrano::Configuration.respond_to?(:instance) ?
  Capistrano::Configuration.instance(:must_exist) :
  Capistrano.configuration(:must_exist)

configuration.load do
  namespace :deploy do
    namespace :rollback do
      desc <<-DESC
      Rolls back the migration to the version found in schema.rb file of the previous release path.\
      Uses sed command to read the version from schema.rb file.
      DESC
      task :migrations do
        run "cd #{current_release};  rake db:migrate RAILS_ENV=#{rails_env} VERSION=`grep \":version =>\" #{previous_release}/db/schema.rb | sed -e 's/[a-z A-Z = \> \: \. \( \)]//g'`"
      end
      after "deploy:rollback","deploy:rollback:migrations"
    end
  end
end
