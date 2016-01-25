class Plan < ActiveRecord::Base
  has_many :subscriptions
  has_many :plan_features
  has_many :features, through: :plan_features

  default_scope { order(:display_order) }

  self.all.each do |plan|
    scope plan.to_sym, -> { find_by(stripe_id: plan.stripe_id) }
  end

  include StripeSaas::Plan
end
