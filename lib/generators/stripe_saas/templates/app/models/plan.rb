class Plan < ActiveRecord::Base
  has_many :subscriptions
  has_many :plan_features
  has_many :features, through: :plan_features

  default_scope { order(:display_order) }

  scope :by_stripe_id, lambda { |stripe_id| find_by(stripe_id: stripe_id.to_s) }

  include StripeSaas::Plan
end
