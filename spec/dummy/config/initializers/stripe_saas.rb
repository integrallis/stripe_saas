StripeSaas.setup do |config|
  config.subscriptions_owned_by = :user
  # config.devise_scope = :user
  config.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  config.stripe_secret_key = ENV['STRIPE_SECRET_KEY']
  config.create_plans_in_stripe = false
end
