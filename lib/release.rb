# frozen_string_literal: true

class Release
  attr_reader :object, :repo

  def initialize(object, repo)
    @object = object
    @repo = repo
  end

  def created_at
    object.created_at
  end

  def bounds(from_version)
    repository.find_bound(object.tag_name, from_version)
  end

  def commits_since(from_version)
    c = CommitRepository.new repo
    c.find_between(*bounds(from_version))
  end

  def tag_name
    object.tag_name
  end

  def add_to_body(text)
    appended_body = object.body || ''
    appended_body << "\n" if object.body
    appended_body << text
    repository.update_release(object.url, body: appended_body)
  end

  private

  def repository
    @repository ||= ReleaseRepository.new repo
  end
end
