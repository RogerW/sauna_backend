source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

# gem 'activerecord-postgis-adapter'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.2'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma'
gem 'pundit'
gem 'rabl'

gem 'oj'
gem 'oj_mimic_json'

gem 'money'
gem 'money-rails', '~>1'

gem 'active_type'
gem 'sidekiq', '~> 5.0.5'

gem 'bcrypt'
gem 'devise', '~> 4.4.0'
gem 'faraday'
gem 'jwt'
gem 'oauth2'

# for db views
gem 'scenic'

gem 'paperclip', '~> 5.0.0'

gem 'email_validator'

gem 'aasm'

# gem 'devise_token_auth'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment

group :development do
  gem 'capistrano'
  # gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
  # gem 'swagger-blocks'
end

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  # gem 'cucumber-api'
  # gem 'cucumber-rails', :require => false
  gem 'rspec-rails'
  gem 'rswag'
end

group :test do
  gem 'database_cleaner'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'letter_opener'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
