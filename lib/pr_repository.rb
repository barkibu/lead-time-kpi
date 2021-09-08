# frozen_string_literal: true

class PrRepository
  attr_reader :repo, :gc

  def initialize(repo)
    @repo = repo
    @gc = GithubClient.new
  end

  def latest_parent_pr(commit)
    pr_object = latest_parent_pr_object(commit)
    return nil if pr_object.nil?

    PR.new(pr_object)
  end

  def latest_parent_pr_object(commit)
    parent_prs(commit).select(&:merged_at?).sort_by(&:merged_at)&.last
  end

  def parent_prs(commit)
    gc.client.commit_pulls repo, commit.sha, accept: 'application/vnd.github.groot-preview+json'
  end
end
