require 'lib/interceptors/production_mail_interceptor'
require 'lib/modules/properties_helper'

AnalyticsPortal::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
   config.log_level = :warn    # debug, info, warn, error

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

   config.logger = Logger.new("#{RAILS_ROOT}/log/#{RAILS_ENV}_#{Date.today.to_s}.log", 50, 1048576)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  config.serve_static_assets = false

  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  portal_properties = Utils::Properties.load_from_file("/etc/analytics/portal.properties", true)
  domain = PropertiesHelper.get_or_use_default(portal_properties, :analytics_portal_domain, 'localhost')
  port = PropertiesHelper.get_or_use_default(portal_properties, :analytics_portal_port, '80')
  if port != '80' && port != '443'
    host = "#{domain}:#{port}"
  else
    host = domain
  end

  # used by mailers and devise
  config.action_mailer.default_url_options = { :host => host }
  ActionMailer::Base.default :from => 'analytics@redacted.com'
end

# TODO fill in with valid options
ActionMailer::Base.smtp_settings = {
  :address              => "207.67.226.5",
  :port                 => 25,
  :domain               => "redacted.com",
#  :user_name            => "analytics@redacted.com",
#  :password             => "",
#  :authentication       => "plain",
  :enable_starttls_auto => false
}

Mail.register_interceptor(ProductionMailInterceptor)