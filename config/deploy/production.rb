# Server name
set :server_name, "121.199.43.92"

# Repository
set :branch, "master"  # Need changge to master

# Configurations
set :rails_env, "production"

# Roles
role :web, "121.199.43.92"                          # Your HTTP server, Apache/etc
role :app, "121.199.43.92"                          # This may be the same as your `Web` server
role :db,  "121.199.43.92", :primary => true        # This is where Rails migrations will run
