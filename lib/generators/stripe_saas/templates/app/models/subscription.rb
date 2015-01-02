class Subscription < ActiveRecord::Base
  include StripeSaas::Subscription

  belongs_to :<%= subscription_owner_model %>
end
