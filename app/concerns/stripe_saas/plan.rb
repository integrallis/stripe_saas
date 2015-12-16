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

    plan_features.find_or_create_by(feature: feature).update({
      value: value,
      display_value: display_value
    })
  end

  def has_feature?(feature)
    if feature.is_a?(String)
      !features.find_by(name: feature).first.nil?
    else
      features.any? { |f| f.id == feature.id }
    end
  end

  def metadata
    metadata_as_json.present? ? JSON::parse(metadata_as_json) : {}
  end

  def metadata=(metadata_hash)
    metadata_as_json = metadata_hash.to_json
  end

end
