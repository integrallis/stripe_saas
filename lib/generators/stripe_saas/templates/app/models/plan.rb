class Plan < ActiveRecord::Base
  has_many :subscriptions

  include StripeSaas::Plan
end
