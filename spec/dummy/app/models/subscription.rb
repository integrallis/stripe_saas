class Subscription < ActiveRecord::Base
  include StripeSaas::Subscription

  belongs_to :user
end
