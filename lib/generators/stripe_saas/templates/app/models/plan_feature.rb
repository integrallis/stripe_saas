class PlanFeature < ActiveRecord::Base
  belongs_to :plan
  belongs_to :feature

  include StripeSaas::PlanFeature
end
