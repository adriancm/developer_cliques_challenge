require 'octokit'

class GithubClient
  def self.get
    Octokit::Client.new(access_token: ENV["GITHUB_ACCESS_TOKEN"])
  end
end
