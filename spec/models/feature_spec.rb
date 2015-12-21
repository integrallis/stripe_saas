require 'rails_helper'

describe Feature, type: :model do

  it { is_expected.to have_many(:plan_features) }
  it { is_expected.to have_many(:plans) }

  before do
    @feature = Feature.find_or_create_by(name: 'signals')
    @feature.update({
      description: "Inbound Signals",
      feature_type: :number,
      display_order: 1
    })
  end

  describe '#feature_type' do
    it 'correctly assigns the feature type and unit given a symbol' do
      expect(@feature.feature_type).to eq('number')
      expect(@feature.unit).to eq('Number')
    end

    it 'throws an error given an invalid feature type' do
      feature = Feature.new

      expect { feature.feature_type = :foo }.to raise_error(ArgumentError, "foo is not a valid feature type")
    end
  end

  describe '#to_s' do
    it 'returns the feature\'s name' do
      expect(@feature.to_s).to eq('signals')
    end
  end

end
