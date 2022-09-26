# frozen_string_literal: true

class KpiEvent
  attr_reader :configuration

  def initialize
    @configuration = Configuration.instance
  end

  def date
    raise 'Implement the date of the event'
  end

  def name
    raise 'Implement the name of the event'
  end

  def payload
    raise 'Implement the payload of the event'
  end

  def project
    configuration.project
  end

  def value
    raise 'Implement the value of the event'
  end

  def to_event
    [date, name, project, value, payload.stringify_keys]
  end
end
