module StripeSaas
  mattr_accessor :subscriptions_owned_by
  @@subscriptions_owned_by = nil

  mattr_accessor :devise_scope
  @@devise_scope = nil

  mattr_accessor :customer_accessor
  @@customer_accessor = nil

  mattr_accessor :stripe_publishable_key
  @@stripe_publishable_key = nil

  mattr_accessor :stripe_secret_key
  @@stripe_secret_key = nil

  mattr_accessor :create_plans_in_stripe
  @@create_plans_in_stripe = false

  def self.setup
    yield self

    # Configure the Stripe gem.
    ::Stripe.api_key = stripe_secret_key
  end

  # e.g. :users
  def self.owner_resource
    subscriptions_owned_by.to_s.pluralize.to_sym
  end

  # e.g. :user_id
  def self.owner_id_sym
    :"#{StripeSaas.subscriptions_owned_by}_id"
  end

  # e.g. :user=
  def self.owner_assignment_sym
    :"#{StripeSaas.subscriptions_owned_by}="
  end

  # e.g. User
  def self.owner_class
    StripeSaas.subscriptions_owned_by.to_s.classify.constantize
  end

  def self.create_plans_in_stripe?
    StripeSaas.create_plans_in_stripe
  end

end
