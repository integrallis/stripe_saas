class Plan < ActiveRecord::Base
  has_many :subscriptions

  include StripeSaas::Plan

  belongs_to :user
end
