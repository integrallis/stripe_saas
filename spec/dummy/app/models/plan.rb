class Plan < ActiveRecord::Base
  has_many :subscriptions
  has_many :plan_features
  has_many :features, through: :plan_features
  
  default_scope { order(:display_order) }

  include StripeSaas::Plan
end
