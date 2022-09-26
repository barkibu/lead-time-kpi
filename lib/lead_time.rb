class LeadTime < KpiEvent
  attr_reader :description, :type, :value, :pr_ids, :release

  def initialize(description, type, value, pr_ids: [])
    @description = description
    @type = type
    @value = value
    @pr_ids = pr_ids
    super()
  end

  def bind_release(release)
    @release = release
    self
  end

  def date
    release.created_at
  end

  def name
    'lead_time'.freeze
  end

  def payload
    { type: type.titleize, name: description, pr_ids: pr_ids }
  end
end
