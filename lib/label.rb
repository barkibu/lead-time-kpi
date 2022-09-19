# frozen_string_literal: true

class Label
  extend Forwardable

  attr_reader :string, :configuration

  def_delegators :configuration, :ignorable_change_types, :change_type_priority, :default_change_type,
                 :change_type_aliases

  def initialize(string)
    @string = string
    @configuration = Configuration.instance
  end

  def report?
    !ignorable_change_types.include? string
  end

  def lead_time_type
    base_change_type(string)
  end

  def priority
    change_type_priority(lead_time_type)
  end

  def self.default
    new(default_change_type)
  end

  private

  def base_change_type(type)
    change_type_aliases[type]
  end
end
