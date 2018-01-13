server 'cityprice.club', user: 'roger', roles: %w[app db web]
# after 'deploy:finishing'

role :app, %w[roger@cityprice.club]
role :web, %w[roger@cityprice.club]
role :db,  %w[roger@cityprice.club]

set :deploy_to, '/usr/local/cityprice'

set :repo_url, 'git@bitbucket.org:m_sanama/sauna_backend.git'

set :linked_files, %w[config/database.yml config/secrets.yml config/puma.rb config/initializers/cors.rb config/initializers/devise.rb]
set :linked_dirs, %w[bin log tmp/pids tmp/cache tmp/socket public]

namespace :deploy do
  desc 'Reload Puma'
  task :puma_restart do
    on roles(:web) do
      within release_path do
        execute 'bin/puma.sh restart'
      end
    end
  end
end

namespace :deploy do
  namespace :assets do
    task :precompile do
      logger.info 'Skipping asset pre-compilation because it API application'
    end
  end
end
