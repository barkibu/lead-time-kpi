class Commit
  attr_reader :object, :repo

  def initialize(object, repo)
    @object = object
    @repo = repo
  end

  def latest_parent_pr
    pr_repository = PrRepository.new repo
    pr_repository.latest_parent_pr(object)
  end

  def sha
    object.sha
  end

  def message
    object.commit.message
  end
end
