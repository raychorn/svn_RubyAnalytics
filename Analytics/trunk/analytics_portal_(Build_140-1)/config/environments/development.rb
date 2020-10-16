require 'lib/interceptors/development_mail_interceptor'
require 'lib/modules/properties_helper'

AnalyticsPortal::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # used by mailers and devise
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  # needed for the subclasses method to load child models in single table inheritance
  config.to_prepare {
    Dir.glob(File.join(Rails.root, 'app', 'models', '*report.rb')).each { |file| require_dependency file }
  }

  #config.logger = Logger.new("#{RAILS_ROOT}/log/#{RAILS_ENV}_#{Date.today.to_s}.log", 50, 1048576)
end

if (1) then
  ActionMailer::Base.smtp_settings = {
    :address => "192.168.1.100",
    :port => "25",
    :domain => "redacted.com",
  }
  ActionMailer::Base.default :from => 'raychorn@gmail.com'
#  ActionMailer::Base.smtp_settings = {
#    :address              => "127.0.0.1",
#    :port                 => 25,
#    :domain               => "redacted.com",
  #  :user_name            => "analytics@redacted.com",
  #  :password             => "",
  #  :authentication       => "plain",
#    :enable_starttls_auto => false
#  }
#  ActionMailer::Base.default :from => 'analytics@redacted.com'
else
  ActionMailer::Base.smtp_settings = {
    :address              => "207.67.226.5",
    :port                 => 25,
    :domain               => "redacted.com",
  #  :user_name            => "analytics@redacted.com",
  #  :password             => "",
  #  :authentication       => "plain",
    :enable_starttls_auto => false
  }
  ActionMailer::Base.default :from => 'analytics@redacted.com'
end

Mail.register_interceptor(DevelopmentMailInterceptor)