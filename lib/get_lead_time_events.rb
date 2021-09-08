# frozen_string_literal: true

class GetLeadTimeEvents
  def self.for_version(repo, from_version, to_version)
    release_repository = ReleaseRepository.new repo

    release = release_repository.find(to_version)

    commits = release.commits_since(from_version)

    prs = commits.map(&:latest_parent_pr).compact.uniq(&:id)

    reportable_prs = prs.select(&:report?)

    # TO CLEAN UP
    reportable_prs.sort_by(&:merged_at).select do |pr|
      next true if pr.parent_pr_number.nil?

      parent_pr = reportable_prs.detect { |potential_parent| potential_parent.number == pr.parent_pr_number }

      next true if parent_pr.nil?

      parent_pr.add_child(pr)

      false
    end

    reportable_prs.map { |pr| pr.to_lead_time(release) }
  end
end
