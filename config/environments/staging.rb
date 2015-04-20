require_relative "production"

Mail.register_interceptor(
  RecipientInterceptor.new(ENV.fetch("EMAIL_RECIPIENTS"))
)
Delayed::Worker.delay_jobs = false
Rails.application.configure do
  # ...

  config.action_mailer.default_url_options = { host: 'staging.connect.com' }
end
