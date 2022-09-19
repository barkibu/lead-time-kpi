class GithubClient
  def client
    Octokit::Client.new(access_token: access_token)
  end

  private

  def access_token
    Configuration.instance.github_access_token
  end
end
