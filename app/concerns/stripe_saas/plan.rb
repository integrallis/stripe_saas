module StripeSaas::Plan
  extend ActiveSupport::Concern

  included do
    monetize :price_cents
  end

  def is_upgrade_from?(plan)
    (price || 0) >= (plan.price || 0)
  end

  def free?
    price == 0.0
  end

  def features
    features_as_json.present? ? JSON::parse(features_as_json) : []
  end

  def features=(features_as_array)
    features_as_json = features_as_array.to_json
  end

  def metadata
    metadata_as_json.present? ? JSON::parse(metadata_as_json) : {}
  end

  def metadata=(metadata_hash)
    metadata_as_json = metadata_hash.to_json
  end

end
