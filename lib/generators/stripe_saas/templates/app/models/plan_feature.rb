class PlanFeature < ActiveRecord::Base
  belongs_to :plan
  belongs_to :feature

  default_scope { joins(:feature).order(:display_order) }

  include StripeSaas::PlanFeature
end
