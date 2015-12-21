require 'rails_helper'

describe Subscription, type: :model do

  it { is_expected.to belong_to(:plan) }

  let(:user) { User.new({email: 'bsbodden@integrallis.com'}) }

  let(:less_expensive_plan) { Plan.new({
    stripe_id: 'free_plan',
    name: 'My Plan',
    price: 0.0,
    interval: 'month',
    interval_count: 1,
    statement_descriptor: 'Cheaper Awesome Plan',
    trial_period_days: 30,
    display_order: 1
  })}

  let(:plan) { Plan.new({
    stripe_id: 'my_plan',
    name: 'My Plan',
    price: 10.0,
    interval: 'month',
    interval_count: 1,
    statement_descriptor: 'My Awesome Plan',
    trial_period_days: 30,
    display_order: 1
  })}

  let(:more_expensive_plan) { Plan.new({
    stripe_id: 'another_plan',
    name: 'Another Plan',
    price: 100.0,
    interval: 'month',
    interval_count: 1,
    statement_descriptor: 'More Expensive Awesome Plan',
    trial_period_days: 30,
    display_order: 2
  })}

  let(:subscription) { Subscription.new(user: user, plan: plan) }

  describe '#subscription_owner' do
    it 'returns the owner of the subscription' do
      expect(subscription.subscription_owner).to be(user)
    end
  end

  describe '#subscription_owner_email' do
    it 'returns the owner of the subscription' do
      expect(subscription.subscription_owner_email).to eq(user.email)
    end
  end

  describe '#subscription_owner_description' do
    it 'returns a descriptive field for the owner of the subscription' do
      expect(subscription.subscription_owner_description).to eq(user.email)
    end
  end

  describe '#describe_difference' do
    it 'returns whether it would be an Upgrade to a given plan' do
      expect(subscription.describe_difference(more_expensive_plan)).to eq('Upgrade')
    end

    it 'returns whether it would be a Downgrade to a given plan' do
      expect(subscription.describe_difference(less_expensive_plan)).to eq('Downgrade')
    end
  end


end
