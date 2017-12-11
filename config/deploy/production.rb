# server-based syntax
# ======================
# Defines a single server with a list of roles and multiple properties.
# You can define all roles on a single server, or split them:

server 'cityprice.club', user: 'roger', roles: %w[app db web]

set :keep_releases, 3

set :application, 'cityprice.club'
set :deploy_to, '/usr/local/cityprice'
set :repo_url, 'git@bitbucket.org:m_sanama/sauna.git/'

set :linked_files, %w[config/database.yml config/secrets.yml]
set :linked_dirs, %w[bin log tmp/pids tmp/cache tmp/socket]

set :deploy_subdir, "sanama_sauna_service"

# namespace :deploy do
#   desc 'Runs rake db:migrate if migrations are set'
#   task migrate: [:set_rails_env] do
#     on fetch(:migration_servers) do
#       conditionally_migrate = fetch(:conditionally_migrate)
#       info '[deploy:migrate] Checking changes in db' if conditionally_migrate
#       if conditionally_migrate && test(:diff, "-qr #{release_path}/db #{current_path}/db")
#         info '[deploy:migrate] Skip `deploy:migrate` (nothing changed in db)'
#       else
#         info '[deploy:migrate] Run `rake db:migrate`'
#         # NOTE: We access instance variable since the accessor was only added recently. Once capistrano-rails depends on rake 11+, we can revert the following line
#         invoke :'deploy:migrating' unless Rake::Task[:'deploy:migrating'].instance_variable_get(:@already_invoked)
#       end
#     end
#   end

#   desc 'Runs rake db:migrate'
#   task migrating: [:set_rails_env] do
#     on fetch(:migration_servers) do
#       within release_path do
#         with rails_env: fetch(:rails_env) do
#           execute "cd '#{release_path}/sanama_sauna_service'; bundle exec db:migrate"
#         end
#       end
#     end
#   end

#   after 'deploy:updated', 'deploy:migrate'
# end

# namespace :bundler do
#   desc 'Install the current Bundler environment.'
#   task :install do
#     on fetch(:bundle_servers) do
#       within release_path do
#         with fetch(:bundle_env_variables) do
#           options = []
#           options << "--gemfile #{fetch(:bundle_gemfile)}" if fetch(:bundle_gemfile)
#           options << "--path #{fetch(:bundle_path)}" if fetch(:bundle_path)
#           unless test(:bundle, :check, *options)
#             options << "--binstubs #{fetch(:bundle_binstubs)}" if fetch(:bundle_binstubs)
#             options << "--jobs #{fetch(:bundle_jobs)}" if fetch(:bundle_jobs)
#             options << "--without #{fetch(:bundle_without)}" if fetch(:bundle_without)
#             options << fetch(:bundle_flags).to_s if fetch(:bundle_flags)
#             # execute :bundle, :install, *options
#             execute "cd '#{release_path}/sanama_sauna_service'; bundle install #{options}"
#           end
#         end
#       end
#     end
#   end
# end
