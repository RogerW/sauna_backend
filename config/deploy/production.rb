server 'cityprice.club', user: 'roger', roles: %w[app db web]

role :app, %w[roger@cityprice.club]
role :web, %w[roger@cityprice.club]
role :db,  %w[roger@cityprice.club]

set :deploy_to, '/usr/local/cityprice'

set :repo_url, 'git@bitbucket.org:m_sanama/sauna_backend.git'

set :linked_files, %w[config/database.yml config/secrets.yml]
set :linked_dirs, %w[bin log tmp/pids tmp/cache tmp/socket]

namespace :deploy do
  namespace :assets do
    task :precompile do
      on release_roles(fetch(:assets_roles)) do
        within release_path do
          with rails_env: fetch(:rails_env), rails_groups: fetch(:rails_assets_groups) do
            logger.info 'Skipping asset pre-compilation because it API application'
          end
        end
      end
    end
  end
end
