module StripeSaas::PlanFeature
  extend ActiveSupport::Concern

  def value=(val)
    super(val.to_s)
  end

  def value
    case feature.feature_type.to_sym
      when :boolean
        self[:value] == 'true'
      when :number, :percentage, :filesize, :interval
        self[:value].to_i
    end
  end

  def to_s
    case feature.feature_type
      when :boolean
        feature.name
      when :number, :percentage, :filesize, :interval
        "#{self[:value]} #{feature.description}"
    end
  end
end
