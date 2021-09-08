class GithubClient
  attr_reader :access_token

  def initialize(access_token: ENV['GITHUB_ACCESS_TOKEN'])
    @access_token = access_token
  end

  def client
    Octokit::Client.new(access_token: access_token)
  end
end
