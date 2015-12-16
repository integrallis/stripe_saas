class Feature < ActiveRecord::Base
  has_many :plan_features
  has_many :plans, through: :plan_features

  default_scope { order(:display_order) }

  include StripeSaas::Feature
end
