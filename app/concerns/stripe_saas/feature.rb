module StripeSaas::Feature
  extend ActiveSupport::Concern

  FEATURE_TYPES = {
    boolean: 'Boolean',
    interval: 'Interval (in seconds)',
    filesize: 'Filesize (in bytes)',
    number: 'Number',
    percentage: 'Percentage (%)'
  }

  def feature_type=(val)
    val = val.to_sym
    raise(ArgumentError, "#{val} is not a valid feature type") unless FEATURE_TYPES.keys.include?(val)
    self[:feature_type] = val
    self[:unit] = FEATURE_TYPES[val]
  end

  def to_s
    name
  end

end
