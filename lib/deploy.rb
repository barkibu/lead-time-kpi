class Deploy < KpiEvent
  attr_reader :release

  def initialize(release)
    @release = release
    super()
  end

  def date
    release.created_at
  end

  def name
    'deployment_to_production'.freeze
  end

  def value
    1
  end

  def payload
    { version: release.tag_name }
  end
end
