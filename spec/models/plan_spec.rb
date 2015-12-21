require 'rails_helper'

describe Plan, type: :model do

  it { is_expected.to have_many(:subscriptions) }
  it { is_expected.to have_many(:plan_features) }
  it { is_expected.to have_many(:features) }

  describe '#is_upgrade_from?' do

    it 'returns true if the price is higher' do
      plan = Plan.new(price: 123.23)
      cheaper_plan = Plan.new(price: 61.61)

      expect(plan.is_upgrade_from?(cheaper_plan)).to be true
    end

    it 'returns true if the price is the same' do
      plan = Plan.new(price: 123.23)

      expect(plan.is_upgrade_from?(plan)).to be true
    end

    it 'returns false if the price is the same or higher' do
      plan = Plan.new(price: 61.61)
      more_expensive_plan = Plan.new(price: 123.23)

      expect(plan.is_upgrade_from?(more_expensive_plan)).to be false
    end

    it 'handles a nil value gracefully' do
      plan = Plan.new(price: 123.23)
      cheaper_plan = Plan.new

      expect(plan.is_upgrade_from?(cheaper_plan)).to be true
    end
  end

  describe 'metadata' do
    it 'can set plan JSON metadata as a hash' do
      plan = Plan.new(price: 0.0)
      plan.metadata = { 'foo': 'bar' }

      expect(plan.metadata).to eq({'foo' => 'bar'})
    end
  end

  describe '#free?' do
    it 'returns whether the plan is a free plan' do
      plan = Plan.new(price: 0.0)
      expect(plan).to be_free
    end
  end

  describe '#is_downgrade_from?' do
    it 'is the opposite of #is_upgrade_from?' do
      plan = Plan.new(price: 123.23)
      cheaper_plan = Plan.new
      more_expensive_plan = Plan.new(price: 123.23)

      expect(plan.is_downgrade_from?(cheaper_plan)).to be false
      expect(plan.is_downgrade_from?(more_expensive_plan)).to be false
    end
  end

  describe 'features' do
    before(:all) do
      @number_feature = Feature.find_or_create_by(name: 'number_feature')
      @number_feature.update({
        description: "My numeric feature",
        feature_type: :number,
        unit: "some_unit",
        display_order: 1
      })

      @boolean_feature = Feature.find_or_create_by(name: 'boolean_feature')
      @boolean_feature.update({
        description: "My boolean feature",
        feature_type: :boolean,
        display_order: 2
      })

      @plan = Plan.find_or_create_by(stripe_id: 'my_plan')
      @plan.update({
        name: 'My Plan',
        price: 0.0,
        interval: 'month',
        interval_count: 1,
        statement_descriptor: 'My Awesome Plan',
        trial_period_days: 30,
        display_order: 1
      })

      @plan.add_feature(:number_feature, 100)
      @plan.add_feature(:boolean_feature, true)
    end

    describe '#add_feature' do
      it 'adds a PlanFeature to a Plan' do
        expect(@plan.features.map(&:name)).to include('boolean_feature', 'number_feature')
      end
    end

    describe '#has_feature?' do
      it 'determines if a plan as certain feature' do
        expect(@plan.has_feature?('boolean_feature')).to be true
      end
    end

    describe '#feature_value' do
      it 'returns the value of a PlanFeature' do
        expect(@plan.feature_value('number_feature')).to eq(100)
        expect(@plan.feature_value('boolean_feature')).to be true
      end
    end

    describe '#allows?' do
      it 'returns whether a feature is enabled' do
        expect(@plan.allows?('number_feature')).to be true
        expect(@plan.allows?('boolean_feature')).to be true
      end
    end

    describe '#boolean_plan_features' do
      it 'returns the plan features of boolean type' do
        expect(@plan.boolean_plan_features.map { |pf| pf.feature.name }).to contain_exactly('boolean_feature')
      end
    end

    describe '#non_boolean_plan_features' do
      it 'returns the plan features that are not of boolean type' do
        expect(@plan.non_boolean_plan_features.map { |pf| pf.feature.name }).to contain_exactly('number_feature')
      end
    end

  end
end
