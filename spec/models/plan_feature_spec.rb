require 'rails_helper'

describe PlanFeature, type: :model do

  it { is_expected.to belong_to(:feature) }
  it { is_expected.to belong_to(:plan) }

  before(:all) do
    @number_feature = Feature.find_or_create_by(name: 'number_feature')
    @number_feature.update({
      description: "Data Retention",
      feature_type: :number,
      unit: "months",
      display_order: 1
    })

    @boolean_feature = Feature.find_or_create_by(name: 'boolean_feature')
    @boolean_feature.update({
      description: "My boolean feature",
      feature_type: :boolean,
      display_order: 2
    })

    @another_number_feature = Feature.find_or_create_by(name: 'another_number_feature')
    @another_number_feature.update({
      description: "Data Retention",
      feature_type: :number,
      unit: "month",
      use_unit: true,
      display_order: 3
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
    @plan.add_feature(:another_number_feature, 314)
  end

  describe '#value=' do
    it 'correctly marshalls the given type to a string for storage' do
      boolean_plan_feature = @plan.plan_features.joins(:feature).find_by(features: { name: 'boolean_feature'})
      number_plan_feature = @plan.plan_features.joins(:feature).find_by(features: { name: 'number_feature'})

      expect(boolean_plan_feature['value']).to eq('true')
      expect(number_plan_feature['value']).to eq('100')
    end
  end

  describe '#value' do
    it 'correctly un-marshalls to the correct data type' do
      boolean_plan_feature = @plan.plan_features.joins(:feature).find_by(features: { name: 'boolean_feature'})
      number_plan_feature = @plan.plan_features.joins(:feature).find_by(features: { name: 'number_feature'})

      expect(boolean_plan_feature.value).to eq(true)
      expect(number_plan_feature.value).to eq(100)
    end
  end

  describe '#to_s' do
    it 'returns the qty and description for non-boolean features' do
      number_plan_feature = @plan.plan_features.joins(:feature).find_by(features: { name: 'number_feature'})

      expect(number_plan_feature.to_s).to eq('100 Data Retention')
    end

    it 'returns the description for boolean features' do
      boolean_plan_feature = @plan.plan_features.joins(:feature).find_by(features: { name: 'boolean_feature'})

      expect(boolean_plan_feature.to_s).to eq('boolean_feature')
    end

    it 'returns the qty and description for non-boolean features' do
      number_plan_feature = @plan.plan_features.joins(:feature).find_by(features: { name: 'another_number_feature'})

      expect(number_plan_feature.to_s).to eq('314 Months Data Retention')
    end
  end

end
