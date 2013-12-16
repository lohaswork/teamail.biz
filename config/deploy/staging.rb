# Server name
set :server_name, "121.199.16.68"

# Repository
set :branch, "staging"  # Need changge to master

# Configurations
set :rails_env, "staging"

# Roles
role :web, "121.199.16.68"                          # Your HTTP server, Apache/etc
role :app, "121.199.16.68"                          # This may be the same as your `Web` server
role :db,  "121.199.16.68", :primary => true        # This is where Rails migrations will run
