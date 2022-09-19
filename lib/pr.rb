# frozen_string_literal: true

class PR
  PARENT_PR_MATCHER = /Parent PR:\s*\#(?<parent_pr_number>\d+)/.freeze
  attr_reader :object, :children

  def initialize(object)
    @object = object
    @children = []
  end

  def add_child(pull_request)
    children << pull_request
  end

  def id
    object.id
  end

  def title
    object.title
  end

  def merged_at?
    object.merged_at?
  end

  def latest_merged_at
    [merged_at, *children.map(&:latest_merged_at)].max
  end

  def merged_at
    object.merged_at
  end

  def number
    object.number
  end

  def prs_ids
    [number, *children.map(&:number)]
  end

  def merge_to_release(release)
    ((release.created_at - latest_merged_at) / (60 * 60 * 12)).round / 2
  end

  def to_lead_time(release)
    LeadTime.new(title, main_label.lead_time_type, merge_to_release(release), pr_ids: prs_ids).bind_release(release)
  end

  def main_label
    labels.max_by(&:priority) || Label.default
  end

  def report?
    main_label.report?
  end

  def labels
    object.labels.map { |l| Label.new(l.name) }
  end

  def parent_pr_number
    matches = object.body&.match(PARENT_PR_MATCHER)
    return unless matches

    matches[:parent_pr_number].to_i
  end
end
