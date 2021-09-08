# frozen_string_literal: true

class Label
  IGNORABLE = %w[translation ignore-for-kpis].freeze
  LEAD_TIME_MAPPER = {
    technical_debt: 'Tech Debt',
    feature: 'Feature',
    bug: 'Defect'
  }.freeze

  attr_reader :string

  def initialize(string)
    @string = string
  end

  def report?
    !IGNORABLE.include? string
  end

  def lead_time_type
    LEAD_TIME_MAPPER[string.to_sym] || 'Feature'
  end

  def priority
    LEAD_TIME_MAPPER.keys.find_index(lead_time_type)
  end

  def self.default
    new('Feature')
  end
end
