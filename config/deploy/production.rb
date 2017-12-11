server 'cityprice.club', user: 'roger', roles: %w[app db web]

role :app, %w[roger@cityprice.club]
role :web, %w[roger@cityprice.club]
role :db,  %w[roger@cityprice.club]

set :deploy_to, '/usr/local/cityprice'
