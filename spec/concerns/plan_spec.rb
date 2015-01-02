require 'rails_helper'

describe StripeSaas::Plan do
  describe '#is_upgrade_from?' do

    it 'returns true if the price is higher' do
      plan = Plan.new
      plan.price = 123.23
      cheaper_plan = Plan.new
      cheaper_plan.price = 61.61
      expect(plan.is_upgrade_from?(cheaper_plan)).to be true
    end

    it 'returns true if the price is the same' do
      plan = Plan.new
      plan.price = 123.23
      expect(plan.is_upgrade_from?(plan)).to be true
    end

    it 'returns false if the price is the same or higher' do
      plan = Plan.new
      plan.price = 61.61
      more_expensive_plan = Plan.new
      more_expensive_plan.price = 123.23
      expect(plan.is_upgrade_from?(more_expensive_plan)).to be false
    end

    it 'handles a nil value gracefully' do
      plan = Plan.new
      plan.price = 123.23
      cheaper_plan = Plan.new

      expect(plan.is_upgrade_from?(cheaper_plan)).to be true
    end

    it 'returns whether the plan is a free plan' do
      plan = Plan.new
      plan.price = 0.0
      expect(plan).to be_free
    end

  end
end
