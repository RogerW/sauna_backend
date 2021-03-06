require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'active_storage/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sanama
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins 'http://localhost:4200', 'http://localhost:8081', 'http://localhost:4000'
        resource '*', headers: :any, methods: %i[get post options put delete]
      end
    end

    config.autoload_paths << Rails.root.join('lib')

    config.i18n.default_locale = :ru

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.active_job.queue_adapter = :sidekiq

    # Paperclip::Attachment.default_options[:storage] = :azure
    # Paperclip::Attachment.default_options[:azure_credentials] = {
    #     storage_account_name: ENV['AZURE_STORAGE_ACCOUNT'],
    #     storage_access_key:   ENV['AZURE_STORAGE_ACCESS_KEY'],
    #     container:            ENV['AZURE_CONTAINER_NAME']
    # }

    Paperclip::Attachment.default_options[:storage] = :filesystem
    Paperclip::Attachment.default_options[:url] = '/assets/system/:hash.:extension'
    Paperclip::Attachment.default_options[:path] = ':rails_root/public/system/:hash.:extension'
    Paperclip::Attachment.default_options[:hash_secret] = 'longSecretString123'
  end
end
