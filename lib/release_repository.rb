# frozen_string_literal: true

class ReleaseRepository
  VERSION_REGEX = /v\d+.\d+.\d+/.freeze
  attr_reader :repo, :gc

  def initialize(repo)
    @repo = repo
    @gc = GithubClient.new
  end

  def update_release(*args)
    gc.client.update_release(*args)
  end

  def find(version)
    Release.new(releases.detect { |release| release.tag_name == version }, repo)
  end

  def find_bound(version, from_version)
    first_commit_sha, last_commit_sha = nil
    versions.each do |tag|
      if from_version.nil? && !last_commit_sha.nil?
        p "Found sha identifying commit of target version #{tag.name} => #{tag.commit.sha}"
        first_commit_sha = tag.commit.sha
      end

      if tag.name == from_version
        p "Found sha identifying commit of start version #{tag.name} => #{tag.commit.sha}"
        first_commit_sha = tag.commit.sha
      end
      if tag.name == version
        p "Found sha identifying commit of target version #{tag.name} => #{tag.commit.sha}"
        last_commit_sha = tag.commit.sha
      end

      return [first_commit_sha, last_commit_sha] if !last_commit_sha.nil? && !first_commit_sha.nil?
    end

    raise 'Version not found'
  end

  def tags
    gc.client.tags repo
  end

  def versions
    @versions ||= tags.select { |t| t.name.match VERSION_REGEX }
  end

  def releases
    @releases ||= gc.client.releases repo
  end
end
