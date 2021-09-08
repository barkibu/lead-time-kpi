# frozen_string_literal: true

class CommitRepository
  attr_reader :repo, :gc, :release_repository

  def initialize(repo)
    @repo = repo
    @release_repository = ReleaseRepository.new(repo)
    @gc = GithubClient.new
  end

  def compare(first_sha, last_sha)
    gc.client.compare(repo, first_sha, last_sha)
  end

  def find_between(first_sha, last_sha)
    compare(first_sha, last_sha).commits.map do |commit|
      Commit.new(commit, repo)
    end
  end

  def previous_commits(sha, branch: 'master', count: 30)
    gc.client.commits repo, branch: branch, per_page: count, sha: sha
  end
end
