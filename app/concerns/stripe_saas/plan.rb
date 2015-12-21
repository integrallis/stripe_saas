module StripeSaas::Plan
  extend ActiveSupport::Concern

  included do
    monetize :price_cents
  end

  def is_upgrade_from?(plan)
    (price || 0) >= (plan.price || 0)
  end

  def is_downgrade_from?(plan)
    !is_upgrade_from?(plan)
  end

  def free?
    price == 0.0
  end

  def add_feature(feature, value, display_value=nil)
    feature = Feature.find_by(name: feature.to_s) if feature.is_a?(String) || feature.is_a?(Symbol)

    raise(ActiveRecord::RecordNotFound, "The feature #{feature.to_s} does not exist") if feature.nil?

    plan_features.find_or_create_by(feature: feature).update({
      value: value,
      display_value: display_value
    })
  end

  def has_feature?(feature)
    if feature.is_a?(String)
      !features.find_by(name: feature).nil?
    else
      features.any? { |f| f.id == feature.id }
    end
  end

  def boolean_plan_features
    plan_features.joins(:feature).where(features: {feature_type: 'boolean'}).order("features.display_order")
  end

  def non_boolean_plan_features
    plan_features.joins(:feature).where.not(features: {feature_type: 'boolean'}).order("features.display_order")
  end

  def feature_value(feature)
    plan_features.joins(:feature).find_by(features: {name: feature.to_s}).value
  end

  def allows?(feature)
    plan_feature = plan_features.joins(:feature).find_by(features: {name: feature.to_s})
    plan_feature.feature.feature_type == 'boolean' ? plan_feature.value : (plan_feature.value > 0)
  end

  def metadata
    self.metadata_as_json.present? ? JSON::parse(self.metadata_as_json) : {}
  end

  def metadata=(metadata_hash)
    self.metadata_as_json = metadata_hash.to_json
  end

end
